#!/usr/bin/env ruby

ENV['INLINEDIR'] = File.dirname(File.expand_path(__FILE__))

require 'readline'
require 'optparse'
require 'bundler'
require 'bundler/setup'
Bundler.require
require_relative './VME-EASIROC.rb'


class CommandDispatcher
  DIRECT_COMMANDS = %i(ls rm rmdir cp mv mkdir cat less root)
  DIRECT_COMMANDS_OPTION = {ls: "-h --color=auto", root: "-l"}
  COMMANDS = %w(shutdownHV setHV statusHV statusTemp statusInputDAC muxControl slowcontrol read adc tdc scaler cd pwd mode reset help version exit quit progress stop) + DIRECT_COMMANDS.map(&:to_s)

  
  def initialize(vmeEasiroc, hist)
    @vmeEasiroc = vmeEasiroc
    @hist = hist
  end

  def dispatch(line)
    command, *arg = line.split
    
    if !COMMANDS.include?(command)
      puts "unknown command #{command}"
      return
    elsif command=="progress" || command=="stop"
      puts "command #{command} works only while reading out data ... "
      return
    end
    
    begin
      send(command, *arg)
    rescue ArgumentError
      puts "invalid argument '#{arg.join(' ')}' for command '#{command}'"
    end
  end

  DIRECT_COMMANDS.each do |command|
    define_method(command) do |*arg|
      option = DIRECT_COMMANDS_OPTION[command]
      option ||= ''
      option << ' '
      system(command.to_s + ' ' + option + arg.join(' '))
    end
  end
  
  def shutdownHV
    @vmeEasiroc.sendShutdownHV
  end
  
  def setHV(value)
    @vmeEasiroc.sendMadcControl
    @vmeEasiroc.sendHVControl(value.to_f)
  end
  
  def statusHV
    @vmeEasiroc.sendMadcControl

    ## Read the MPPC bias voltage
    rd_madc = @vmeEasiroc.readMadc(3)
    puts sprintf("Bias voltage >> %.2f V", rd_madc)
    
    ## Read the MPPC bias current
    rd_madc = @vmeEasiroc.readMadc(4)
    puts sprintf("Bias current >> %.2f uA", rd_madc)
  end

  def statusTemp
    @vmeEasiroc.sendMadcControl
    
    ## Read the temparature1
    rd_madc = @vmeEasiroc.readMadc(5)
    puts sprintf("Temparature 1  >> %.2f C", rd_madc)

    ## Read the temparature2
    rd_madc = @vmeEasiroc.readMadc(0)
    puts sprintf("Temparature 2  >> %.2f C", rd_madc)
  end
 
  def statusInputDAC(channel)
    @vmeEasiroc.sendMadcControl
    
    ## Read the Input DAC voltage
    chInt = channel.to_i
    readNum = -1
    if 0<=chInt && chInt<=63
      num = chInt%32
      readNum = chInt/32 + 1
      @vmeEasiroc.setCh(num)
      rd_madc = @vmeEasiroc.readMadc(readNum)
      puts sprintf("ch %2d: Input DAC >> %.2f V",chInt,rd_madc)
    elsif chInt == 64
      ch = 0..31
      ch.each{|num|
        @vmeEasiroc.setCh(num)
        rd_madc = @vmeEasiroc.readMadc(1)
        puts sprintf("ch %2d: Input DAC >> %.2f V",num,rd_madc)
      }		
      ch = 32..63
      ch.each{|num|
        @vmeEasiroc.setCh(num-32)
        rd_madc = @vmeEasiroc.readMadc(2)
        puts sprintf("ch %2d: Input DAC >> %.2f V",num,rd_madc)
      }
    else
      puts "channel: 0~63, or 64(all channels)"
      return
    end
    
    @vmeEasiroc.setCh(32)
  end
  
  def muxControl(chnum)
    @vmeEasiroc.setCh(chnum.to_i)
  end
  
  def slowcontrol
    @vmeEasiroc.reloadSetting
    @vmeEasiroc.sendSlowControl
    @vmeEasiroc.sendProbeRegister
    @vmeEasiroc.sendReadRegister
    @vmeEasiroc.sendPedestalSuppression
    @vmeEasiroc.sendSelectbaleLogic
    @vmeEasiroc.sendTriggerWidth
    @vmeEasiroc.sendTimeWindow
    @vmeEasiroc.sendUsrClkOutRegister
  end
  
  def adc(on_off)
    if(on_off == 'on')
      @vmeEasiroc.sendAdc = true
    elsif(on_off == 'off')
      @vmeEasiroc.sendAdc = false
    else
      puts "Unknown argument #{on_off}"
      return
    end
  end
  
  def tdc(on_off)
    if(on_off == 'on')
      @vmeEasiroc.sendTdc = true
    elsif(on_off == 'off')
      @vmeEasiroc.sendTdc = false
    else
      puts "Unknown argument #{on_off}"
      return
    end
  end
  
  def scaler(on_off)
    if(on_off == 'on')
      @vmeEasiroc.sendScaler = true
    elsif(on_off == 'off')
      @vmeEasiroc.sendScaler = false
    else
      puts "Unknown argument #{on_off}"
      return
    end
  end

  def cd(path)
    begin
      Dir.chdir(path)
    rescue Errno::ENOENT
      puts "No such file or directry #{path}"
    end
  end
  
  def pwd
    puts Dir.pwd
  end
  
  def read(events, filename, monitor="default")

      events = events.to_i
      if /\.dat$/ !~ filename
        filename << '.dat'
      end
      
      data_filename = 'data/' + filename
      if File.exist?(data_filename)
        puts "#{data_filename} already exists"
        return
      end
      
      if monitor=="default"
          progress_bar = nil
          File.open(data_filename, 'wb') do |file|
            @vmeEasiroc.readEvent(events) do |header, data|
              progress_bar ||= ProgressBar.create(
                total: events,
                format: '%p%% [%b>%i] %c %revent/s %e'
              )
              file.write(header[:header])
              file.write(data.pack('N*'))
              progress_bar.increment
            end
          end
          progress_bar.finish

      elsif monitor=="monitor"       
        num_events = Queue.new
        send_stop = Queue.new
 
        readline_thread = Thread.new do
          sleep 1
          numEvent = 0
          progress_rd = 0.0
          commandsInRead = %w(progress stop statusHV statusTemp statusInputDAC)
          
          while buf_read = Readline.readline('DAQ is running... > ', true)
            buf_com, *buf_arg = buf_read.split
            
            if !commandsInRead.include?(buf_com)
              puts "Cannnot excute '#{buf_com}' while reading data..."
            elsif buf_com == "progress"
              numEvent = num_events.pop
              sleep 0.5
              progress_rd = numEvent.to_f/events*100
              puts sprintf("Number of events: %d, progress: %.3f%",numEvent,progress_rd)
            elsif buf_com == "stop"
              send_stop.push(1)
              sleep 5
            else
              dispatch(buf_read)
            end
          end
        end

        read_thread = Thread.new do
          ievents = 0
          File.open(data_filename, 'wb') do |file|
            @vmeEasiroc.readEvent(events) do |header, data|
              file.write(header[:header])
              file.write(data.pack('N*'))

              ievents += 1
              if !num_events.empty?
                num_events.pop
              end
              num_events.push(ievents)

              if !send_stop.empty?
                puts "Daq stop is requested"
                break
              end
            end
            puts sprintf("!!!!Readout finished!!!! Total number of events: %d, %d%", ievents, ievents.to_f/events*100)
            readline_thread.kill
          end
        end
                
        read_thread.join
        readline_thread.join

        num_events.clear
        send_stop.clear

      else
        puts "Invalid mode... 'default' or 'monitor'"
        return
      end
      
      
      if File.exist?(@hist) && FileTest::executable?(@hist)
        system("#{@hist} #{filename}")
      end
      slowcontrol
  end

  def reset(target)
    if !%w(probe readregister, pedestalsuppression).include?(target)
      puts "unknown argument #{target}"
      return
    end
    
    if target == 'probe'
      @vmeEasiroc.resetProbeRegister
    end
    
    if target == 'readregister'
      @vmeEasiroc.resetReadRegister
    end
    
    if target == 'pedestalsuppression'
      @vmeEasiroc.resetPedestalSuppression
    end
  end

  
  def help
  puts <<-EOS
  How to use
  setHV <bias voltage>	input <bias voltage>; 0.00~90.00V to MPPC
  slowcontrol           	transmit SlowControl
  read <EventNum> <FileName>  read <EventNum> events and write to <FileName>
  reset probe|readregister    reset setting
  help                        print this message
  version                     print version number
  exit|quit                   quit this program
  
  COMMANDS:
  - adc <on/off>
  - cd <path>
  - exit 
  - help 
  - mode 
  - muxControl <ch(0..32)>
  - pwd 
  - quit
  - read <EventNum> <FileName>
  - reset <target>
  - scaler <on/off>
  - setHV  <bias voltage (00.00~90.00)>
  - slowcontrol 
  - statusInputDAC <ch(0..63) / all(64)>
  - statusHV
  - statusTemp
  - tdc <on/off>
  - version 
  DIRECT_COMMANDS:
  - cat 
  - cp 
  - less 
  - ls 
  - mkdir 
  - mv 
  - rm 
  - rmdir 
  - root
  EOS
  end
  
  def version
    versionMajor, versionMinor, versionHotfix, versionPatch,
      year, month, day = @vmeEasiroc.version
    puts "v.#{versionMajor}.#{versionMinor}.#{versionHotfix}-p#{versionPatch}"
    puts "Synthesized on #{year}-#{month}-#{day}"
  end
  
  alias quit exit
end



$logger = Logger.new(STDOUT)
$logger.formatter = proc{|severity, datetime, progname, message|
  "#{message}\n"
}
$logger.level = Logger::INFO
#$logger.level = Logger::DEBUG

OPTS = {}
opt = OptionParser.new
opt.on('-e COMMAND', 'execute COMMAND') {|v| OPTS[:command] = v}
opt.on('-q', 'quit after execute command') {|v| OPTS[:quit] = v}
opt.parse!(ARGV)

#ipaddr = ARGV[0]
ipaddr = ARGV.shift || "192.168.10.16"

if !ipaddr
  puts "Usage:"
  puts "    #{$0} <Options> <IP Address>"
  exit 1
end

vmeEasiroc = VmeEasiroc.new(ipaddr, 24, 4660)
vmeEasiroc.sendSlowControl
vmeEasiroc.sendProbeRegister
vmeEasiroc.sendReadRegister
vmeEasiroc.sendPedestalSuppression
vmeEasiroc.sendSelectbaleLogic
vmeEasiroc.sendTriggerWidth
vmeEasiroc.sendTimeWindow
vmeEasiroc.sendUsrClkOutRegister

pathOfThisFile = File.expand_path(File.dirname(__FILE__))
hist = pathOfThisFile + '/hist'

commandDispatcher = CommandDispatcher.new(vmeEasiroc, hist)

runCommandFile = pathOfThisFile + '/.rc'
begin
  open(runCommandFile) do |f|
    f.each_line do |line|
      commandDispatcher.dispatch(line.chomp)
    end
  end
rescue Errno::ENOENT
end

if OPTS[:command]
  OPTS[:command].split(';').map(&:strip).each do |line|
    commandDispatcher.dispatch(line)
  end
  
  if OPTS[:quit]
    exit
  end
end

def shellCommand
  cache = nil
  proc {
    return cache if cache
    cache = []
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      if !FileTest::exist?(path)
        next
      end
      
      Dir::foreach(path) do |d|
        if FileTest::executable?(path + '/' + d) &&
          FileTest::file?(path + '/' + d)
          cache << d
        end
      end
    end
    cache.sort!.uniq!
  }
end


shellCommandCompletion = proc {|word|
  comp = shellCommand.call.grep(/\A#{Regexp.quote word}/)
  
  if Readline::FILENAME_COMPLETION_PROC.call(word)
    filenameComp = []
    Readline::FILENAME_COMPLETION_PROC.call(word).each do |file|
      if FileTest::executable?(file) && FileTest::file?(file)
        filenameComp << file
      elsif FileTest::directory?(file)
        filenameComp << file + '/'
      end
    end
    
    if comp.empty? && filenameComp.size == 1 && filenameComp[0][-1] == '/'
      comp = [filenameComp[0] + 'hoge', filenameComp[0] + 'fuga']
    else
      comp.concat(filenameComp)
    end
  end
  comp
}

Readline.completion_proc = proc {|word|
  if word[0] == '!'
    shellCommandCompletion.call(word[1..-1]).map{|i| '!' + i}
  else
    CommandDispatcher::COMMANDS.grep(/\A#{Regexp.quote word}/)
    .concat(Readline::FILENAME_COMPLETION_PROC.call(word) || [])
  end
}

commandHistoryFile = pathOfThisFile + '/.history'
begin
  open(commandHistoryFile) do |f|
    f.each_line do |line|
      Readline::HISTORY << line.chomp
    end
  end
rescue Errno::ENOENT
end

Signal.trap(:INT){
  puts "!!!! Ctrl+C !!!! 'exit|quit' command is recommended."
  puts "Decreasing MPPC bias voltage..."
  commandDispatcher.setHV(0.00)
  sleep 0.2
  puts "Shutdown HV supply..."
  commandDispatcher.shutdownHV
  sleep 0.2
  exit
}
Signal.trap(:TSTP){
  puts "!!!! Ctrl+Z !!!! 'exit|quit' command is recommended."
  puts "Decreasing MPPC bias voltage..."
  commandDispatcher.setHV(0.00)
  sleep 0.2
  puts "Shutdown HV supply..."
  commandDispatcher.shutdownHV
  sleep 0.2
  exit
}


while buf = Readline.readline('> ', true)
  hist = Readline::HISTORY
  if /^\s*$/ =~ buf
    hist.pop
    next
  end
  
  begin
    if hist[hist.length - 2] == buf && hist.length != 1
      hist.pop
    end
  rescue IndexError
  end
  
  if buf[0] == '!'
    if system(buf[1..-1]) == nil
      puts "cannot execute #{buf[1..-1]}"
    end
  else
    begin
      commandDispatcher.dispatch(buf)
    rescue SystemExit
      puts "Decreasing MPPC bias voltage..."
      commandDispatcher.setHV(0.00)
      sleep 0.2
      puts "Shutdown HV supply..."
      commandDispatcher.shutdownHV
      sleep 0.2
      
      exit
    end
  end
  
  begin
    open(commandHistoryFile, 'a') do |f|
      f.puts(buf)
    end
  rescue Errno::EACCES
  end
end
