#!/bin/env ruby
#!/usr/bin/env ruby

ENV['INLINEDIR'] = File.dirname(File.expand_path(__FILE__))

require 'readline'
require 'optparse'
require 'bundler'
require 'bundler/setup'
Bundler.require
require_relative './VME-EASIROC.rb'

Trigger = 10000 #10kHz

class CommandDispatcher
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
    calibrateTrigDelayTime checkHVstability  
    takeNoiseRate testTriggerDelay
    muxControl slowcontrol standby fit drawScaler dsleep 
    read adc tdc scaler cd pwd mode reset help version 
    exit quit progress stop timeStamp makeError 
    ttt 
  ) + DIRECT_COMMANDS.map(&:to_s)
  
  def initialize(vmeEasiroc, hist, q)
    @vmeEasiroc = vmeEasiroc
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
    	@vmeEasiroc.sendShutdownHV
  	end

   def setHV(value)
      value = value.to_f
      @vmeEasiroc.sendMadcControl
      rd_madc = @vmeEasiroc.readMadc(3) # read HV firstly
      diff = value - rd_madc 
      if diff.abs > 10.0 then
         puts "diff is #{diff.abs}! diff is too large! use stepSetHV; stepSetHV(#{value})"
         stepSetHV(value)
         return
      end
      @vmeEasiroc.sendHVControl(value)
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
      @vmeEasiroc.sendMadcControl
      rd_madc = @vmeEasiroc.readMadc(3) # read HV firstly

      #diff = ( value - rd_madc ).abs
      diff = value - rd_madc 
      if diff.abs < 5.0 then
         puts "use SetHV XX; return;"
         return
      end
      count = (diff.abs).div( stepHV ) - 1
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
      @vmeEasiroc.sendMadcControl
      #checkHV(value.to_f+stepHV, curlim)
      rd_madc = @vmeEasiroc.readMadc(3)
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
    	@vmeEasiroc.sendMadcControl
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
    	@vmeEasiroc.sendMadcControl

    	## Read the MPPC bias voltage
    	rd_madc_v = @vmeEasiroc.readMadc(3)
    	puts sprintf("Bias voltage >> %.3f V", rd_madc_v)
     	## Read the MPPC bias current
    	rd_madc_a = @vmeEasiroc.readMadc(4)
    	puts sprintf("Bias current >> %.3f uA", rd_madc_a)
		return rd_madc_v 
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
 
  	def statusInputDAC(channel, filename="temp")
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
      	puts "Reading monitor ADC..."
      	if /\.yml$/ !~ filename
      		filename << '.yml'
      	end

        if /\.yml$/ !~ filename
           filename << '.yml'
        end

      	status_filename = 'status/' + filename
      	if ( !filename.include?("temp" ) && 
             File.exist?(status_filename) )
           puts "\n\n\n!!!!! #{status_filename} already exsit !!!!!\n\n\n"
           status_filename="status/temp_#{Time.now.to_i}.yml"
      	end
      	puts "Status is save as #{status_filename}."

      	status = {}
      	status[:HV] = @vmeEasiroc.readMadc(3).round(3)
      	status[:current] = @vmeEasiroc.readMadc(4).round(3)
      	status[:InputDAC]=[]
      	ch = 0..31
      	ch.each{|eachnum|
      	  @vmeEasiroc.setCh(eachnum)
      	  status[:InputDAC] << @vmeEasiroc.readMadc(1).round(3)
      	}
      	ch = 32..63
      	ch.each{|eachnum|
      	  @vmeEasiroc.setCh(eachnum-32)
      	  status[:InputDAC] << @vmeEasiroc.readMadc(2).round(3)
      	}
      	puts status
      	File.write(status_filename, status.to_yaml)
   	else
      	puts "channel: 0~63, or 64(all channels)"
      	return
    	end
    	@vmeEasiroc.setCh(32)
  end

   def checkHV(vollim=80.0, curlim=20.0, repeat=3)
      @vmeEasiroc.sendMadcControl
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
      	 ### Read the MPPC bias voltage
      	 voltage = @vmeEasiroc.readMadc(3)
      	 ### Read the MPPC bias current
      	 current = @vmeEasiroc.readMadc(4)
      	 if voltage > vollim || current > curlim then
      	    puts sprintf("\n=> <checkHV> OVER the LIMIT! 
                          The current V = %.2fV, A = %.2fuA. trying again...\n", voltage, current)
      	    sleep 1
      	 else
      	    puts sprintf("=> <checkHV> The Status is OK... V = %.2f V, A = %.2f uA", voltage, current)
      	    check=true
      	 end
      end
   end

	# implemented for mass test programs by Hosotani 151110
  def setInputDAC(voltage) 
    @vmeEasiroc.setInputDAC(voltage.to_f)
    sleep 0.5
    slowcontrol
  end

	# implemented for mass test programs by Hosotani 151110
  def setRegister(key, value)
    @vmeEasiroc.setRegister(key, value)
    sleep 0.5
    slowcontrol
  end
  
	# implemented for mass test programs by Hosotani 151110
  def setThreshold(pe, chip="0", filename="temp")
    @vmeEasiroc.setThreshold(pe, chip, filename)
    sleep 0.5
    slowcontrol
  end

  def muxControl(chnum)
    @vmeEasiroc.setCh(chnum.to_i)
  end
  
   def slowcontrol
      puts "\n<< CALLED: slowcontrol w ReloadSettings >>"
      @vmeEasiroc.reloadSetting
      @vmeEasiroc.sendSlowControl
      @vmeEasiroc.sendProbeRegister
      @vmeEasiroc.sendReadRegister
      @vmeEasiroc.sendPedestalSuppression
      @vmeEasiroc.sendSelectbaleLogic
      @vmeEasiroc.sendTriggerWidth
      @vmeEasiroc.sendTimeWindow
      @vmeEasiroc.sendUsrClkOutRegister
      @vmeEasiroc.sendTestChargePattern
      @vmeEasiroc.sendTriggerValues 
   end
 
   def slowcontrol_woReloadSettings
      puts "\n<< CALLED: slowcontrol w/o ReloadSettings >>"
      #@vmeEasiroc.reloadSetting
      @vmeEasiroc.sendSlowControl
      @vmeEasiroc.sendProbeRegister
      @vmeEasiroc.sendReadRegister
      @vmeEasiroc.sendPedestalSuppression
      @vmeEasiroc.sendSelectbaleLogic
      @vmeEasiroc.sendTriggerWidth
      @vmeEasiroc.sendTimeWindow
      @vmeEasiroc.sendUsrClkOutRegister
      @vmeEasiroc.sendTestChargePattern
      @vmeEasiroc.sendTriggerValues
   end
 
  def adc(on_off)
    puts "Set adc #{on_off}"
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
    puts "Set tdc #{on_off}"
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
    puts "Set scaler #{on_off}"
    if(on_off == 'on')
      @vmeEasiroc.sendScl = true
    elsif(on_off == 'off')
      @vmeEasiroc.sendScl = false
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
    }
    $logger.debug "sleep 1 in standby."
    sleep 1
    $logger.debug "End of standby."
  end


   def read(events, filename="temp", mode="default")
      system('mkdir data')
      events = events.to_i
      if /\.dat$/ !~ filename
         filename << '.dat'
      end

      data_filename = 'data/' + filename
      if ( !filename.include?("temp") && 
           File.exist?(data_filename) )
         puts "\n\n\n!!!!! #{data_filename} already exsits !!!!!\n\n\n"
         data_filename="data/temp_#{Time.now.to_i}.dat"
      end
      puts "\n\nData is saved as #{data_filename}"

      if mode=="default"
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

      elsif mode=="queue"
      File.open(data_filename, 'wb') do |file|
         $logger.debug "Create fork to readEvent."
         pid = Process.fork {
           @vmeEasiroc.readEvent(events) do |header, data|
             file.write(header[:header])
             file.write(data.pack('N*'))
           end
         }
         $logger.debug "Child process pid: #{pid}"
         @q.push(@vmeEasiroc.name)
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

      elsif mode=="enclk"
         setRegister("clk", "0")
         enclk = Queue.new
      begin
        enclk_thread = Thread.new {
          Thread.pass
          enclk.pop
          sleep 1
          setRegister("clk", "1")
        }
      rescue => e
        $logger.info "Error in read, mode==enclk, enclk_thread. name: #{@vmeEasiroc.name}"
        $logger.info e.message
      end

      begin
        timelimit=(events/Trigger).to_i
        read_thread = Thread.new {
          ievents = 0
          File.open(data_filename, 'wb') do |file|
            enclk.push(1)
            Thread.pass
            @vmeEasiroc.readEvent(events, timelimit+10) do |header, data|
              progress_bar ||= ProgressBar.create(
                total: events,
                format: '%p%% [%b>%i] %c %revent/s %e'
              )
              file.write(header[:header])
              file.write(data.pack('N*'))
              progress_bar.increment

              ievents += 1
            end
            if progress_bar.kind_of?(ProgressBar) then
              $logger.info "ProgressBar finish."
              progress_bar.finish
            end
          end
        }
        isTimeout = (read_thread.join(timelimit+20) == nil)
         if isTimeout then
            raise("Timeout Error. name: #{@vmeEasiroc.name}")
            read_thread.kill
         end
         rescue => e
            $logger.info "Error in read, mode==enclk, read_thread. name: #{@vmeEasiroc.name}"
            $logger.info e.message
         ensure
            $logger.info "Timeout Error. name: #{@vmeEasiroc.name}" if isTimeout
         end

         read_thread.join
         enclk_thread.join

         enclk.clear

         sleep 1
         setRegister("clk", "0")
      else
         puts "Invalid mode... 'default', 'monitor', or 'enclk'"
         return
      end

      if File.exist?(@hist) && FileTest::executable?(@hist)
         system("#{@hist} #{data_filename}")
      end
      #slowcontrol
      slowcontrol_woReloadSettings
      sleep 0.3
   end

  def fit(filename="temp", *ch) 
    status_filename = "status/" + filename + ".yml"
    status = YAML.load_file(status_filename)
    if ch.empty? then
      64.times {|ich|
        voltage = status[:HV]-status[:InputDAC][ich]
        system(%Q(root -l -b -q 'fit1.cpp("#{filename}", #{voltage}, #{ich})'))
      } 
    else
      ch.map(&:to_i).each {|ich|
        voltage = status[:HV]-status[:InputDAC][ich]
        system(%Q(root -l -b -q 'fit1.cpp("#{filename}", #{voltage}, #{ich})'))
      } 
    end
  end

  def drawScaler(filename="temp", dac="reg", *ch)
    if dac == "reg" then
      dac = @vmeEasiroc.getRegister("thr")
    else
      dac = dac.to_i
    end

    if ch.empty? then
      64.times {|ich|
        system(%Q(root -l -b -q 'scaler1.cpp("#{filename}", #{dac}, #{ich})'))
      } 
    else
      ch.map(&:to_i).each {|ich|
        system(%Q(root -l -b -q 'scaler1.cpp("#{filename}", #{dac}, #{ich})'))
      } 
    end
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

   ##### add 19/11/10
   # to check H.V. stability 
   def checkHVstability(fileName="test")
      system('mkdir status')
      #dataFileName = 'data/' + fileName
      #if ( !fileName.include?("temp") && File.exist?(dataFileName) )
      #   puts "#{dataFileName} already exsits."
      #   dataFileName="data/test#{Time.now.to_i}.log"
      #end
      #puts "Save as #{dataFileName}"
      #File.open(dataFileName, 'a') do |file|
      #File.open(dataFileName, 'w') do |file|
      #   file.puts("Hello, World!")
      #end

      stepSetHV(50.0) # initial increase of HV
      countA = 0
      countB = 0
      # 1 hour 3600 sec ~ 360 countA
      # 30 min 1800 sec ~ 180 countA 
      # 15 min  900 sec ~  90 countA 
      #  5 min  300 sec ~  30 countA
      #  3 min  180 sec ~  18 countA
      while countA < 90 do  
         if countA%18 == 0 then  
            countB += 1
            if countB%1 == 0
               $logger.debug "set 52.0 [V]\n"
               setHV(53.0)
            end
            if countB%2 == 0
               $logger.debug "set 56.0 [V]\n"
               setHV(55.0)
            end
            if countB%3 == 0
               $logger.debug "set 60.0 [V]\n"
               setHV(57.0)
            end
         end
         sleep 2 # waiting for HV 
         countA += 1 # 1 ~ 10 sec becuase statusInputDAC takes ~ 10 sec
         retVal = statusHV
         $logger.debug "counter=#{countA}, return value=#{retVal} [V]"
         # log it here
         #File.open(dataFileName, 'a') do |file|
         #   file.puts "#{countA} #{retVal}"
         #end
         fname = 'inputDAC' + countA.to_s
         statusInputDAC(64, fname) # put globalHV, adjustbleHV
      end
   end

   ##### add 20/01/16
   # set and adjust HV while looking the status of monitor ADC
   def convergeHV(value)
      value = value.to_f
  	  set_value = value
  	  @vmeEasiroc.sendMadcControl
  	  rd_madc = @vmeEasiroc.readMadc(3) # read HV

      if ( rd_madc - set_value ).abs > 10 then 
         stepSetHV(set_value) # initial increase of HV
      end
  	  @vmeEasiroc.sendHVControl(set_value)
  	  sleep 0.5
  	  rd_madc = @vmeEasiroc.readMadc(3)
  	  delta = rd_madc - value
  	  #while delta.abs > 0.01 do
  	  while delta.abs > 0.005 do
  	     set_value = set_value - delta
         puts "[convergeHV] setHV=#{set_value}"
   		 @vmeEasiroc.sendHVControl(set_value)
   		 sleep 1 
   		 rd_madc = @vmeEasiroc.readMadc(3)
   		 delta = rd_madc - value
      	 puts "[convergeHV] readHV=#{rd_madc}, current delta=#{delta}"
  	  end
   end

   ##### add 19/12/08
   # to chage test pulse pattern
   def setTestPulsePtn(val)
      puts "[setTestPulsePtn] val=#{val}"
      @vmeEasiroc.setTestChargePattern(val)
      sleep 0.3
   end

   ##### add 20/06/15 
   def setTestPulseTo(ch) 
      chi = ch.to_i
      if chi > 63 then
         puts 'wrong argument, must be ch <64'
         return
      end
      value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      if chi <  0 then
         @vmeEasiroc.setEasiroc1SlowControl_("DisablePA & In_calib_EN", value)
         @vmeEasiroc.setEasiroc2SlowControl_("DisablePA & In_calib_EN", value)
      elsif chi < 32 then
         value[chi] = 1
         @vmeEasiroc.setEasiroc1SlowControl_("DisablePA & In_calib_EN", value)
         value[chi] = 0 
         @vmeEasiroc.setEasiroc2SlowControl_("DisablePA & In_calib_EN", value)
      else
         @vmeEasiroc.setEasiroc1SlowControl_("DisablePA & In_calib_EN", value)
         #chi = chi - 32
         value[chi-32] = 1
         @vmeEasiroc.setEasiroc2SlowControl_("DisablePA & In_calib_EN", value)
      end
      @vmeEasiroc.sendSlowControl
      sleep 0.3
	  #puts "Easiroc1SlowControl"
      #p @vmeEasiroc.getEasiroc1SlowControl.values_at("DisablePA & In_calib_EN")
	  #puts "Easiroc2SlowControl"
      #p @vmeEasiroc.getEasiroc2SlowControl.values_at("DisablePA & In_calib_EN")
   end

   ##### add 20/06/15 
   def calibrateIndividual64
      system('mkdir data_calib; rm data_calib/*')
      for ch in 0..63 do
         for pp in 0..2 do # pulse pattern
         puts "==> Calibrate gain mv/fQ for ch: #{ch} by puting pulse pattern #{pp}"  

         #setThresholdDAC(770) #UT18
         #setTriggerDelay(30) #UT18
         setThresholdDAC(810) #KEK15
         setTriggerDelay(32) #KEK15
         setTestPulseTo (ch.to_i) # call slowcontrol  
         setTestPulsePtn(pp.to_i)
         sleep 0.4
         fname = 'calib_ch' + ch.to_s + '_qptn' + pp.to_s
         read(4000, fname) # caution: read calls slowcontrol in the end as default
         sleep 0.2
         end          
         # convert dat to tree 
         #       cmdtree/tree data/calib_chan0_qptn0.dat
         fname0 = 'calib_ch' + ch.to_s + '_qptn0.dat'
         fname1 = 'calib_ch' + ch.to_s + '_qptn1.dat'
         fname2 = 'calib_ch' + ch.to_s + '_qptn2.dat'
         fname3 = 'calib_ch' + ch.to_s + '_sum.root'
         fname4 = 'calib_ch' + ch.to_s + '*.root'
         system("cmdtree/tree data/#{fname0}")
         system("cmdtree/tree data/#{fname1}")
         system("cmdtree/tree data/#{fname2}")
         puts "\nhadd -f data/#{fname3} data/#{fname4}\n"
         system("hadd -f data/#{fname3} data/#{fname4}")
      end
      puts "\nmv data/calib_ch* \n"
      system("mv data/calib_ch* data_calib/")
   end

   ##### add 20/06/28 
   def calibrateTrigDelayTime
      system('mkdir data_calib; rm data_calib/*')
      [1,33].each do |ch|
         for pp in 0..2 do # pulse pattern
         	#for dl in 20..56 do # tigger dalay for farm8
         	for dl in 2..35 do # tigger dalay for farmX
         	puts "==> Calibrate delay time for ch #{ch} w/ PulsePattern #{pp} and TriggerDelay: #{dl}"

         	setThresholdDAC(770) #UT18
         	#setThresholdDAC(810) #KEK15
         	setTriggerDelay(dl.to_i)
         	setTestPulseTo (ch.to_i) # put pulse to chX only
         	setTestPulsePtn(pp.to_i)
         	sleep 0.4
         	fname1 = 'calib_ch' + ch.to_s + '_trigdelay' + dl.to_s + '_qptn' + pp.to_s
         	read(4000, fname1) # caution: read calls slowcontrol in the end as default
         	sleep 0.2
         	end
         end
      end  
      puts "\nmv data/calib_ch* \n"
      system("mv data/calib_ch* data_calib/")
   end

  ##### add 20/06/30 
   def takeNoiseRate
      for dac in 800..900 do #KEK15
         if dac%2 == 0
            fname = 'noiserate_dac' + dac.to_s
            puts "dac #{dac}, name #{fname} "
            setThresholdDAC(dac) 
            #setTriggerDelay(32) #KEK15 farm8
            setTriggerDelay(15) #KEK15 farmX
            sleep 1 
            read(5000, fname) # caution: read calls slowcontrol in the end as default
            sleep 1
          end
      end
   end

   ##### add 20/06/15 
   def setThresholdDAC(val)
      vali = val.to_i
      @vmeEasiroc.setEasiroc1SlowControl_("DAC code", vali)
      @vmeEasiroc.setEasiroc2SlowControl_("DAC code", vali)
      @vmeEasiroc.sendSlowControl
      sleep 0.3
   end

   ##### add 20/06/15 
   def setTriggerMode(value)
      puts "setTriggerMode #{value}"
      @vmeEasiroc.sendTriggerMode(value.to_i)
   end

   ##### add 20/06/15 
   def setTriggerDelay(value)
      puts "setTriggerDelay #{value}"
      @vmeEasiroc.sendTriggerDelay(value.to_i)
   end

   ##### add 20/06/15 
   def testTriggerDelay
      for i in 8..64 do
	      puts "setTriggerDelay #{i.to_i}"
	      @vmeEasiroc.sendTriggerDelay(i.to_i)
         sleep 1.0
		end
   end

   ##### add 20/06/15 
   def setSelectbaleLogic(chan)
      chan = chan.to_i
      selectableLogic88bits = Array.new.fill(0,0...11)
      selectableLogic88bits[0] = 0
      selectableLogic88bits[1] = chan
      @vmeEasiroc.sendSelectbaleLogicCmdLine(selectableLogic88bits)
      @vmeEasiroc.sendSlowControl
   end

   ##### add 20/06/15
   # to see trigger bevaviour on an oscilloscope   
   def activateIndividual64
      for i in 0..63 do
         puts "activate only #{i}"
         setSelectbaleLogic(i)
         sleep 1.5
      end
   end

   def help
   puts <<-EOS

  Basic Commands for Usage:
    setHV <bias voltage>	    input <bias voltage>; 0.00~90.00V to MPPC
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
   - calibrateTrigDelayTime : scan trigger delay 

  Direct Commands:
   - cat cp less ls mkdir mv pwd
   - rm rmdir root sleep

  Memorandums 
   - Use "stepSetHV", and Don't forget to use "turnOffHV"
   - "slowcontrol", "slowcontrol_woReloadSettings", 
   - "testTriggerDelay", "takeNoiseRate"
   - see "analysis/mydiary.txt"
   EOS
   end

   def ttt 
      system('mkdir data')
      stepSetHV(55.0)
      setHV(56.0)
      sleep 1
      # 56.40--57.40
      # 56.20--57.20
      for i in 0..10 do
         #inhv = 56.40 + i * 0.1 #KEK15
         inhv = 56.20 + i * 0.1 #UT18
         inhv = inhv.round(3)
         setHV( inhv )
         sleep 2.0
         #setThresholdDAC(800) #KEK15
         setThresholdDAC(770) #UT18
         setTriggerDelay(15) #KEK15
         fnam1 = 'statusDAC' + inhv.to_s
         statusInputDAC(64, fnam1) # put globalHV, adjustbleHV
         fnam2 = 'voltage' + inhv.to_s
         read(100000, fnam2) 
         #puts "inhv=#{inhv}, fnam1=#{fnam1}, fnam2=#{fnam2}"
      end
   end

   def version
   	  versionMajor, 
	  versionMinor, 
	  versionHotfix, 
	  versionPatch,
      year, month, day = @vmeEasiroc.version
      #puts "--- version.#{versionMajor}.#{versionMinor}.#{versionHotfix}-p#{versionPatch} ---"
      puts "--- Vivado version-#{versionMajor}#{versionMinor}.#{versionHotfix}.#{versionPatch} ---"
      puts "--- Synthesized on #{year}-#{month}-#{day} ---"
   end

   def timeStamp
    time=Time.now
    puts "Time stamp: #{time}, #{time.to_i}"
   end
 
   alias quit exit
end # end of definition CommandDispatcher




OPTS = {}
opt = OptionParser.new
opt.on('-e COMMAND', 'execute COMMAND') {|v| OPTS[:command] = v}
opt.on('-q', 'quit after execute command') {|v| OPTS[:quit] = v}
opt.parse!(ARGV)

#ipaddr = ARGV.shift || "192.168.10.16"
#ipaddr = "192.168.10.16"
#ipaddr = "192.168.10.15" #KEK15
ipaddr = "192.168.10.18" #UT18

if !ipaddr
  puts "Usage:"
  puts "    #{$0} <Options> <IP Address>"
  exit 1
end


# STDOUT(標準出力)への書き出し
$logger = Logger.new(STDOUT)
$logger.formatter = proc{|severity, datetime, progname, message|
  "#{message}\n"
}
#$logger.level = :WARN
$logger.level = :INFO
#$logger.level = :DEBUG


vmeEasiroc = VmeEasiroc.new(ipaddr, 24, 4660)
vmeEasiroc.sendSlowControl
vmeEasiroc.sendProbeRegister
vmeEasiroc.sendReadRegister
vmeEasiroc.sendPedestalSuppression
vmeEasiroc.sendSelectbaleLogic
vmeEasiroc.sendTriggerWidth
vmeEasiroc.sendTimeWindow
vmeEasiroc.sendUsrClkOutRegister
vmeEasiroc.sendTestChargePattern
vmeEasiroc.sendTriggerValues 

pathOfThisFile = File.expand_path(File.dirname(__FILE__))
hist = pathOfThisFile + '/hist'

que = Queue.new
commandDispatcher = CommandDispatcher.new(vmeEasiroc,hist,que)
commandDispatcher.version
commandDispatcher.help

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
  puts "Decreasing MPPC bias voltage... using turnOffHV"
  #commandDispatcher.setHV(0.00)
  commandDispatcher.turnOffHV(0.00)
  sleep 1
  puts "Shutdown HV supply..."
  commandDispatcher.shutdownHV
  sleep 1
  exit
}

Signal.trap(:TSTP){
  puts "!!!! Ctrl+Z !!!! 'exit|quit' command is recommended."
  puts "Decreasing MPPC bias voltage... using turnOffHV"
  #commandDispatcher.setHV(0.00)
  commandDispatcher.turnOffHV(0.00)
  sleep 1
  puts "Shutdown HV supply..."
  commandDispatcher.shutdownHV
  sleep 1
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
