#!/usr/bin/env ruby

ENV['INLINEDIR'] = File.dirname(File.expand_path(__FILE__))

#require 'readline'
#require 'optparse'
#require 'bundler/setup'
require 'yaml'
#Bundler.require

Trigger = 0.1 #10kHz

class ModuleCtrlDptr
  DIRECT_COMMANDS = %i(
   ls rm rmdir cp mv mkdir cat less root sleep
   )
  DIRECT_COMMANDS_OPTION = {ls: "-h --color=auto", root: "-l"}
  COMMANDS = %w(
    initialCheck turnOffHV shutdownHV statusTemp 
    checkHV statusHV setHV stepSetHV convergeHV
    statusInputDAC 
    setInputDAC setThreshold setRegister
    setSelectbaleLogic activateIndividual64
    setThresholdDAC setTriggerMode setTriggerDelay 
    setTestPulsePtn setTestPulseTo calibrateIndividual64 
    checkHVstability  
    muxControl slowcontrol standby fit drawScaler dsleep 
    read adc tdc scaler cd pwd mode reset help version 
    exit quit progress stop timeStamp makeError 
    fit_PDE 
    ) + DIRECT_COMMANDS.map(&:to_s)
  
  def initialize(namedEASIROC, hist, q)
    @NameNamedEASIROC = namedEASIROC
    @hist = hist
    @q = q
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
    rescue => e
      puts e.message
      puts "exit..."
      setHV(0.0)
      sleep 1
      exit
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

  def dsleep(time)
    sleep time.to_f
  end

  def shutdownHV
    @NameNamedEASIROC.sendShutdownHV
  end

  def setHV(value)
    @NameNamedEASIROC.sendMadcControl
    @NameNamedEASIROC.sendHVControl(value.to_f)
  end

   ### set HV step by step
   def stepSetHV(value)
      value = value.to_f
      if value < 0.0 then
         puts "Input value must be positive!"
         return
      elsif value > 70.0 then
         puts "Too large input value! Must be smaller than 90.0"
         puts " => change 90.0 to 70.0 @ 20/03/31"
          return
      end

      curlim = 30.0 # current limit
      stepHV =  5.0
      @NameNamedEASIROC.sendMadcControl
      rd_madc = @NameNamedEASIROC.readMadc(3) # read HV firstly

      #diff = ( value - rd_madc ).abs
      diff = value - rd_madc
      if diff.abs < 5.0 then
         puts "use SetHV XX; return;"
         return
      end
      count = (diff.abs).div( stepHV )
      puts "inputHV = #{value},  readHV = #{rd_madc},  diffHV = #{diff},  iterate = #{count}"

      for i in 0..count do
         if diff > 0 then
            puts "\niteration #{i}: setHV #{rd_madc + (i+1) * stepHV}"
            setHV(   rd_madc + (i+1) * stepHV )
            sleep 1.0
            checkHV( rd_madc + (i+2) * stepHV, curlim) # def checkHV(vollim=80.0, curlim=20.0, repeat=3)
         else
            puts "\niteration #{i}: setHV #{rd_madc - (i+1) * stepHV}"
            setHV(   rd_madc - (i+1) * stepHV )
            sleep 1.0
            checkHV( rd_madc - (i-1) * stepHV, curlim) # def checkHV(vollim=80.0, curlim=20.0, repeat=3)
         end
     end
      puts "\nsetHV #{value}"
      setHV( value )
      sleep 1.0
      checkHV( value + stepHV, curlim)
   end

   def turnOffHV
      curlim = 60.0 # current limit
      stepHV =  5.0
      @NameNamedEASIROC.sendMadcControl
      #checkHV(value.to_f+stepHV, curlim)
      rd_madc = @NameNamedEASIROC.readMadc(3)
      count = rd_madc.div(stepHV)
      for i in 0..count do
          setHV((count-i)*stepHV)
          sleep 1.5
          #checkHV((count-i+1)*stepHV, curlim)
      end
      setHV(0.0)
      sleep 1
      #checkHV(stepHV, curlim)
   end

  def initialCheck
    @NameNamedEASIROC.sendMadcControl
    checkHV(10.0, 20.0)
    sleep 0.2
    setHV(2.0)
    sleep 1
    checkHV(10.0, 20.0)
    sleep 0.2
    setHV(3.0)
    sleep 1
    checkHV(10.0, 20.0)
    sleep 0.2
    setHV(5.0)
    sleep 1
    checkHV(10.0, 20.0)
    sleep 0.2
    setHV(10.0)
    sleep 1
    checkHV(20.0, 20.0)
    sleep 0.2
    setHV(0.0)
  end

  def statusHV
    @NameNamedEASIROC.sendMadcControl

    ## Read the MPPC bias voltage
    #@NameNamedEASIROC.readMadc(3) #for debug by hosomi 151110
    rd_madc = @NameNamedEASIROC.readMadc(3)
    puts sprintf("#{@NameNamedEASIROC.name}: Bias voltage >> %.2f V", rd_madc)
    
    ## Read the MPPC bias current
    #@NameNamedEASIROC.readMadc(4) #for debug by hosomi 151110
    rd_madc = @NameNamedEASIROC.readMadc(4)
    puts sprintf("#{@NameNamedEASIROC.name}: Bias current >> %.2f uA", rd_madc)
  end

  def statusTemp
    @NameNamedEASIROC.sendMadcControl
    
    ## Read the temparature1
    rd_madc = @NameNamedEASIROC.readMadc(5)
    puts sprintf("Temparature 1  >> %.2f C", rd_madc)

    ## Read the temparature2
    rd_madc = @NameNamedEASIROC.readMadc(0)
    puts sprintf("Temparature 2  >> %.2f C", rd_madc)
  end
 
  def statusInputDAC(channel, filename="temp")
    @NameNamedEASIROC.sendMadcControl
    
    ## Read the Input DAC voltage
    chInt = channel.to_i
    readNum = -1

    if 0<=chInt && chInt<=63
      num = chInt%32
      readNum = chInt/32 + 1
      @NameNamedEASIROC.setCh(num)
      #@NameNamedEASIROC.readMadc(readNum) #for debug by hosomi 151110
      rd_madc = @NameNamedEASIROC.readMadc(readNum)
      puts sprintf("ch %2d: Input DAC >> %.2f V",chInt,rd_madc)
    elsif chInt == 64
      puts "Reading monitor ADC..."
      if /\.yml$/ !~ filename
        filename << '.yml'
      end

      status_filename = 'status/' + filename
      if (!filename.include?("temp") && File.exist?(status_filename))
        #puts "#{status_filename} already exist. Overwrite? (y/n) "
        #while str = STDIN.gets
        #  return if str.chomp == "n"
        #  break if str.chomp == "y"
        #  puts "Overwrite? (y/n) "
        #end

        puts "#{status_filename} already exsit."
        status_filename="status/temp_#{Time.now.to_i}.yml"
      end
      puts "Save as #{status_filename}."

      status = {}
      #@NameNamedEASIROC.readMadc(3) #for debug
      status[:HV] = @NameNamedEASIROC.readMadc(3).round(3)
      status[:current] = @NameNamedEASIROC.readMadc(4).round(3)
      status[:InputDAC]=[]
      ch = 0..31
      ch.each{|eachnum|
        @NameNamedEASIROC.setCh(eachnum)
        #@NameNamedEASIROC.readMadc(1) #for debug by hosomi 151110
        #status[:InputDAC] << sprintf("%.3f", @NameNamedEASIROC.readMadc(1))
        status[:InputDAC] << @NameNamedEASIROC.readMadc(1).round(3)
        #rd_madc = @NameNamedEASIROC.readMadc(1)
        #puts sprintf("ch %2d: Input DAC >> %.2f V",eachnum,rd_madc)
      }
      ch = 32..63
      ch.each{|eachnum|
        @NameNamedEASIROC.setCh(eachnum-32)
        #@NameNamedEASIROC.readMadc(2) #for debug by hosomi 151110
        #status[:InputDAC] << sprintf("%.3f", @NameNamedEASIROC.readMadc(2))
        status[:InputDAC] << @NameNamedEASIROC.readMadc(2).round(3)
        #rd_madc = @NameNamedEASIROC.readMadc(2)
        #puts sprintf("ch %2d: Input DAC >> %.2f V",eachnum,rd_madc)
      }
      puts status
      File.write(status_filename, status.to_yaml)
    else
      puts "channel: 0~63, or 64(all channels)"
      return
    end
    @NameNamedEASIROC.setCh(32)
  end

  def checkHV(vollim=80.0, curlim=20.0, repeat=3)
    @NameNamedEASIROC.sendMadcControl

    vollim = vollim.to_f
    curlim = curlim.to_f
    repeat = repeat.to_i
    check=false
    count=0
    while !check do
      count+=1
      if count > repeat then
        puts "Attempt limit. exit..."
        setHV(0.0)
        sleep 1
        exit
      end

      ## Read the MPPC bias voltage
      voltage = @NameNamedEASIROC.readMadc(3)

      ## Read the MPPC bias current
      current = @NameNamedEASIROC.readMadc(4)

      if voltage > vollim || current > curlim then
        puts sprintf("Over the limit. voltage=%.2fV, current=%.2fuA. trying again...\n", voltage, current)
        sleep 1
      else
        puts sprintf("Status OK. voltage=%.2fV, current=%.2fuA \n", voltage, current)
        check=true
      end
    end
  end

  def setInputDAC(voltage)
    @NameNamedEASIROC.setInputDAC(voltage.to_f)
    sleep 0.5
    slowcontrol
  end

  def setRegister(key, value)
    @NameNamedEASIROC.setRegister(key, value)
    sleep 0.5
    slowcontrol
  end
  
  def setThreshold(pe, chip="0", filename="temp")
    @NameNamedEASIROC.setThreshold(pe, chip, filename)
    sleep 0.5
    slowcontrol
  end

  def muxControl(chnum)
    @NameNamedEASIROC.setCh(chnum.to_i)
  end
  
  def slowcontrol
    @NameNamedEASIROC.reloadSetting
    @NameNamedEASIROC.sendSlowControl
    @NameNamedEASIROC.sendProbeRegister
    @NameNamedEASIROC.sendReadRegister
    @NameNamedEASIROC.sendPedestalSuppression
    @NameNamedEASIROC.sendSelectbaleLogic
    @NameNamedEASIROC.sendTriggerWidth
    @NameNamedEASIROC.sendTimeWindow
    @NameNamedEASIROC.sendUsrClkOutRegister
  end
  
  def adc(on_off)
    puts "Set adc #{on_off}"
    if(on_off == 'on')
      @NameNamedEASIROC.sendAdc = true
    elsif(on_off == 'off')
      @NameNamedEASIROC.sendAdc = false
    else
      puts "Unknown argument #{on_off}"
      return
    end
  end
  
  def tdc(on_off)
    puts "Set tdc #{on_off}"
    if(on_off == 'on')
      @NameNamedEASIROC.sendTdc = true
    elsif(on_off == 'off')
      @NameNamedEASIROC.sendTdc = false
    else
      puts "Unknown argument #{on_off}"
      return
    end
  end
  
  def scaler(on_off)
    puts "Set scaler #{on_off}"
    if(on_off == 'on')
      @NameNamedEASIROC.sendScaler = true
    elsif(on_off == 'off')
      @NameNamedEASIROC.sendScaler = false
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

  def standby(counts)
    counts.to_i.times {
      buf = @q.pop
            puts "EASIROC #{buf} is ready."
      #puts "EASIROC #{@NameNamedEASIROC.name} is ready."
    }
    $logger.debug "sleep 1 in standby."
    sleep 1
    $logger.debug "End of standby."
  end


	def read(events, filename="temp", mode="default")
   	$logger.debug "Begin of read."
    	events = events.to_i
    	if /\.dat$/ !~ filename
      	filename << '.dat'
    	end

    	data_filename = 'data/' + filename
    	if (!filename.include?("temp") && File.exist?(data_filename))
      	#puts "#{data_filename} already exists. Overwrite? (y/n) "
      	#while str = STDIN.gets
      	#  return if str.chomp == "n"
      	#  break if str.chomp == "y"
      	#  puts "Overwrite? (y/n) "
      	#end
      	puts "#{data_filename} already exsits."
      	data_filename="data/temp_#{@NameNamedEASIROC.name}_#{Time.now.to_i}.dat"
    	end
    	puts "Save as #{data_filename}"

    	if mode=="default"
      	puts "here default"
      	progress_bar = nil
      	File.open(data_filename, 'wb') do |file|
        		#puts "file open"
        		@NameNamedEASIROC.readEvent(events) do |header, data|
          		progress_bar ||= ProgressBar.create(
            		total: events,
            		format: '%p%% [%b>%i] %c %revent/s %e'
          		)
          		time=Time.now.to_i
          		buffer=[time]
          		#puts buffer
          		file.write(header[:header])
          		file.write(buffer.pack('N'))
          		file.write(data.pack('N*'))
          		progress_bar.increment
        		end
      	end
      	progress_bar.finish

    	elsif mode=="queue"
      	puts "here queue #{@NameNamedEASIROC.name}"
      	File.open(data_filename, 'wb') do |file|
        		$logger.debug "Create fork to readEvent."
        		pid = Process.fork {
          		@NameNamedEASIROC.readEvent(events) do |header, data|
            		time=Time.now.to_i
            		buffer=[time]
            		file.write(header[:header])
           			file.write(buffer.pack('N'))
            		file.write(data.pack('N*'))
          		end
        		}
        		$logger.debug "Child process pid: #{pid}"
        		@q.push(@NameNamedEASIROC.name)
        		Process.waitpid pid
      	end
      	sleep 1

    	elsif mode=="monitor"
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
          @NameNamedEASIROC.readEvent(events) do |header, data|
            time=Time.now.to_i
            buffer=[time]
            file.write(header[:header])
            file.write(buffer.pack('N'))
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

    elsif mode=="enclk"
      puts "here enclk #{@NameNamedEASIROC.name}"
      setRegister("clk", "0")
      enclk = Queue.new
      #num_events = Queue.new

      begin
        enclk_thread = Thread.new {
          Thread.pass
          enclk.pop
          #@q.pop
          sleep 1
          setRegister("clk", "1")
        }
      rescue => e
        $logger.info "Error in read, mode==enclk, enclk_thread. name: #{@NameNamedEASIROC.name}"
        $logger.info e.message
      end

      begin
        timelimit=(events/Trigger).to_i
        read_thread = Thread.new {
          ievents = 0
          File.open(data_filename, 'wb') do |file|
            enclk.push(1)
            Thread.pass
            @NameNamedEASIROC.readEvent(events, timelimit+10) do |header, data|
              progress_bar ||= ProgressBar.create(
                total: events,
                format: '%p%% [%b>%i] %c %revent/s %e'
              )
              time=Time.now.to_i
              buffer=[time]
              file.write(header[:header])
              file.write(buffer.pack('N'))
              file.write(data.pack('N*'))
              progress_bar.increment

              ievents += 1
              #if !num_events.empty?
              #  num_events.pop
              #end
              #num_events.push(ievents)
            end
            if progress_bar.kind_of?(ProgressBar) then
              $logger.info "ProgressBar finish."
              progress_bar.finish
            end
            puts sprintf("!!!!Readout finished!!!! Total number of events: %d, %d%", ievents, ievents.to_f/events*100)
          end
        }
        isTimeout = (read_thread.join(timelimit+20) == nil)
        if isTimeout then
          raise("Timeout Error. name: #{@NameNamedEASIROC.name}")
          read_thread.kill
        end
      rescue => e
        $logger.info "Error in read, mode==enclk, read_thread. name: #{@NameNamedEASIROC.name}"
        $logger.info e.message
      ensure
        #$logger.info "Timeout Error. name: #{@NameNamedEASIROC.name}" if isTimeout
      end

      read_thread.join
      enclk_thread.join

      enclk.clear
      #num_events.clear

      sleep 1
      setRegister("clk", "0")
    else
      puts "Invalid mode... 'default', 'monitor', or 'enclk'"
      return
    end

    if File.exist?(@hist) && FileTest::executable?(@hist)
      system("#{@hist} #{filename}")
    end
    slowcontrol
  end

  def fit(filename="temp", *ch) #hosomi 151208
    #data_filename = "rootfile/" + filename + ".root"
    status_filename = "status/" + filename + ".yml"
    status = YAML.load_file(status_filename)
    if ch.empty? then
      64.times {|ich|
        voltage = status[:HV]-status[:InputDAC][ich]
        system(%Q(root -l -b -q 'fit1.cpp("#{filename}", #{voltage}, #{ich})'))
      } #ich
    else
      ch.map(&:to_i).each {|ich|
        voltage = status[:HV]-status[:InputDAC][ich]
        system(%Q(root -l -b -q 'fit1.cpp("#{filename}", #{voltage}, #{ich})'))
      } #ich
    end
  end

  def fit_PDE(filename="temp", *ch)
    #data_filename = "rootfile/" + filename + ".root"
    status_filename = "status/" + filename + ".yml"
    status = YAML.load_file(status_filename)
    output_filename = "data_PDE/" + filename + ".txt"
    File.write(output_filename, "")
    if ch.empty? then
      64.times {|ich|
        voltage = status[:HV]-status[:InputDAC][ich]
        system(%Q(root -l -b -q 'fit_PDE.cpp("#{filename}", #{voltage}, #{ich})'))
      } #ich
    else
      ch.map(&:to_i).each {|ich|
        voltage = status[:HV]-status[:InputDAC][ich]
        system(%Q(root -l -b -q 'fit_PDE.cpp("#{filename}", #{voltage}, #{ich})'))
      } #ich
    end
  end

  def drawScaler(filename="temp", dac="reg", *ch) #hosomi 160126
    if dac == "reg" then
      dac = @NameNamedEASIROC.getRegister("thr")
    else
      dac = dac.to_i
    end

    if ch.empty? then
      64.times {|ich|
        system(%Q(root -l -b -q 'scaler1.cpp("#{filename}", #{dac}, #{ich})'))
      } #ich
    else
      ch.map(&:to_i).each {|ich|
        system(%Q(root -l -b -q 'scaler1.cpp("#{filename}", #{dac}, #{ich})'))
      } #ich
    end
  end

  def reset(target)
    if !%w(probe readregister, pedestalsuppression).include?(target)
      puts "unknown argument #{target}"
      return
    end
    
    if target == 'probe'
      @NameNamedEASIROC.resetProbeRegister
    end
    
    if target == 'readregister'
      @NameNamedEASIROC.resetReadRegister
    end
    
    if target == 'pedestalsuppression'
      @NameNamedEASIROC.resetPedestalSuppression
    end
  end

  def timeStamp
    time=Time.now
    puts "Time stamp: #{time}, #{time.to_i}"
  end
  
  def help
  puts <<-EOS

  Basic Commands for Usage:
    setHV <bias voltage>       input <bias voltage>; 0.00~90.00V to MPPC
    slowcontrol                 transmit slowcontrol
    read <EventNum> <FileName>  read <EventNum> events and write to <FileName>
    reset probe|readregister    reset setting
    exit|quit                   quit this program
    help                        print this message
    version                     print version number
    exit|quit                   quit this program

  Other Commands:
   - adc    <on/off>
   - tdc    <on/off>
   - scaler <on/off>
   - cd     <path>
   - sleep  <time>
   - initialCheck
   - mode
   - muxControl  <ch(0..32)>
   - reset       <target>
   - statusTemp
   - setInputDAC <InputDAC voltage (0.0~4.5)>
   - read
   - fit

   - statusInputDAC : <ch(0..63) / all(64)> put a status file under status/ 
   - checkHVstability : check HV stability for ~ 30 min using above command  
   - setThresholdDAC 
   - setSelectbaleLogic :  <0..63> only is activated = OneCh_XX
   - activateIndividual64 : loop using above to see trigger bevaviour on an oscilloscope      

  HV Controlles  
   - setHV       <bias voltage (00.00~90.00)> @ don't use! this increases at once @
   - stepSetHV   <bias voltage> : step by step
   - convergeHV  <bias voltage> : step by step and coverge it by looking HV monitor
   - statusHV
   - checkHV     <voltage_limit=80> <current_limit=20> <repeat_count=3>
   - turnOffHV   : step by step to 0
 
  Internal Trigger Ptn and Delay: see yaml/RegisterValue.yml
   - setTriggerMode   : <0: ,>
   - setTriggerDelay  : <0: ,>

  Pulse Calibration:
   - setTestPulsePtn  : <0,1,2>
   - setTestPulseTo   : <0..63> each chip and ch by ch (recommended)
   - calibrateIndividual64 : input test pulse to each chip and ch by ch (recommended) 

  Direct Commands:
   - cat cp less ls mkdir mv pwd
   - rm rmdir root sleep

  Memorandums 
   - Use "stepSetHV", and Don't forget to use "turnOffHV"
   - "slowcontrol", "slowcontrol_woReloadSettings", 
   - "testTriggerDelay"
  EOS
  end
  
  def version
    versionMajor, versionMinor, versionHotfix, versionPatch,
      year, month, day = @NameNamedEASIROC.version
    puts "v.#{versionMajor}.#{versionMinor}.#{versionHotfix}-p#{versionPatch}"
    puts "Synthesized on #{year}-#{month}-#{day}"
  end
  
  alias quit exit
end


