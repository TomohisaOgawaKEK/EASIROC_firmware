#!/usr/bin/env ruby

ENV['INLINEDIR'] = File.dirname(File.expand_path(__FILE__))

#require_relative './Named-EASIROC.rb'
require_relative './Named-Easiroc200626.rb'
#require_relative './ModuleCtrlDptr.rb'
require_relative './ModuleCtrlDptr200626.rb'

class ModuleCtrlCmdr
	def initialize(name, ipaddr, runCmdFile, que)
		puts "ModuleCtrlCmdr initialize: name=#{name}, ip=#{ipaddr}"
      puts "ModuleCtrlCmdr initialize: runf=#{runCmdFile}\n"
    	@name = name
    	@ipaddr = ipaddr
    	@runCmdFile = runCmdFile
    	@que = que

    	@namedEasiroc = NamedEasiroc.new(@ipaddr, 24, 4660, @name)
    	@namedEasiroc.sendSlowControl
    	@namedEasiroc.sendProbeRegister
    	@namedEasiroc.sendReadRegister
    	@namedEasiroc.sendPedestalSuppression
    	@namedEasiroc.sendSelectbaleLogic
    	@namedEasiroc.sendTriggerWidth
    	@namedEasiroc.sendTimeWindow
    	@namedEasiroc.sendUsrClkOutRegister

    	@pathOfThisFile = File.expand_path(File.dirname(__FILE__))
    	@hist = @pathOfThisFile + '/hist'
    	@ctrlDispatcher = ModuleCtrlDptr.new(@namedEasiroc, @hist, @que)
	end

   def runCommand
   	begin
         puts "\nModule: #{@name}: open file and read commands ..."
     		open(@runCmdFile) do |f|
      		f.each_line do |line|
         		begin
            		@ctrlDispatcher.dispatch(line.chomp)
          		rescue SystemExit => e
            		puts e.message
            		puts "Decreasing MPPC bias voltage..."
            		@ctrlDispatcher.setHV(0.0)
            		sleep 0.2
            		#puts "Shutdown HV supply..."
            		#@commandDispathcer.shutdownHV
            	exit
          	end
        	end
      end
    	rescue Errno::ENOENT => e
      	puts e.message
    	rescue => e
      	puts e.message
    	end

    	sleep 1
    	@ctrlDispatcher.setHV(0.0)
    	sleep 1 
    	puts "Shutdown HV supply..."
   	@ctrlDispatcher.shutdownHV
  	end

  	def termination
    	puts "ModuleCtrlCmdr termination. name: #{@name}"
    	@ctrlDispatcher.setHV(0.0)
    	sleep 1
    	puts "Shutdown HV supply..."
    	@ctrlDispatcher.shutdownHV
    	sleep 1
  	end

  	def getName
    	return @name
  	end

  	def getIpaddr
    	return @ipaddr
  	end

end
