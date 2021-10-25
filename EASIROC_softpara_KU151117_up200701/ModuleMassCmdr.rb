#!/usr/bin/env ruby

ENV['INLINEDIR'] = File.dirname(File.expand_path(__FILE__))

require 'readline'
require 'optparse'
require 'bundler'
require 'bundler/setup'
Bundler.require
require_relative './ModuleCtrlCmdr.rb'

$logger = Logger.new(STDOUT)
$logger.formatter = proc{|severity, datetime, progname, message|
  "#{message}\n"
}

OPTS = {}
opt = OptionParser.new
opt.on('-e COMMAND', 'execute COMMAND') {|v| OPTS[:command] = v}
opt.on('-q', 'quit after execute command') {|v| OPTS[:quit] = v}
opt.on('-d', 'debug mode') {|v| OPTS[:debug] = v}
opt.parse!(ARGV)

if OPTS[:debug] then
  $logger.level = Logger::DEBUG
else
  $logger.level = Logger::INFO
end

PathOfThisFile = File.expand_path(File.dirname(__FILE__))
Path = PathOfThisFile + "/"
daq_ready = Queue.new

cmdrs = []
cmdrs << ModuleCtrlCmdr.new("moduleKEK15", "192.168.10.15", Path + (ARGV.shift || ".rc"), daq_ready)
#cmdrs << ModuleCtrlCmdr.new("Y1", "192.168.10.26", Path + (ARGV.shift || ".rc"), daq_ready)
#cmdrs << ModuleCtrlCmdr.new("Y2", "192.168.10.19", Path + (ARGV.shift || ".rc"), daq_ready)
#cmdrs << ModuleCtrlCmdr.new("X1", "192.168.10.25", Path + (ARGV.shift || ".rc"), daq_ready)
#cmdrs << ModuleCtrlCmdr.new("X2", "192.168.10.16", Path + (ARGV.shift || ".rc"), daq_ready)

threads=[]
cmdrs.each {|cmdr|
	begin
   	threads << Thread.new {
      	begin
        		cmdr.runCommand # runCommand is defined in ModuleCtrlCmdr 
      		rescue => e
        		puts "Error in cmdr.runCommand. name: #{cmdr.getName}"
        		puts e.message
      	ensure
        		cmdr.termination
      	end
    	}
	rescue => e
    	puts "Error in Thread. name: #{cmdr.getName}"
    	puts e.message
	ensure
   	#cmdr.termination
  	end
}

Signal.trap(:INT){
  puts "!!!! Ctrl+C !!!! 'exit|quit' command is recommended."
  puts "Kill threads..."
  threads.each {|t| t.kill}
  threads.each {|t| t.join}
  exit
}
Signal.trap(:TSTP){
  puts "!!!! Ctrl+Z !!!! 'exit|quit' command is recommended."
  puts "Kill threads..."
  threads.each {|t| t.kill}
  threads.each {|t| t.join}
  exit
}

threads.each {|t| t.join}
puts "Operation Finished!"
