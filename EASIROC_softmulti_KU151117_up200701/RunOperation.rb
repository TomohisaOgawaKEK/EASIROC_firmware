#!/usr/bin/env ruby

require 'yaml'

nrun=(ARGV.shift || 0).to_i
#nsub=0

repeat=1 #10

events=10 #10000

HV0=5
HV1=5
HV2=5
name0="easiroc0"
name1="easiroc1"
name2="easiroc2"
rcfile0="easiroc_control_000.txt"
rcfile1="easiroc_control_001.txt"
rcfile2="easiroc_control_002.txt"

str_repeat0=""
str_repeat1=""
str_repeat2=""
repeat.times {|i|
  irun = nrun + i
  datafile0 = sprintf("%s_%04d_#{Time.now.to_i}", name0, irun)
  datafile1 = sprintf("%s_%04d_#{Time.now.to_i}", name1, irun)
  datafile2 = sprintf("%s_%04d_#{Time.now.to_i}", name2, irun)
  str_repeat0 += sprintf("test %d %s", events, datafile0)
  #str_repeat0 += sprintf("standby 1\nread %d %s enclk\nsleep 2\n", events, datafile0)
  str_repeat1 += sprintf("read %d %s queue\nsleep 2\n",            events, datafile1)
  str_repeat2 += sprintf("read %d %s queue\nsleep 2\n",            events, datafile2)
}

# generate run scripts below
str0=<<-EOS
timeStamp
sleep 1
zzzincreaseHV #{HV0}
zzz#{str_repeat0.chomp}
sleep 1
setHV 0.0
sleep 1
shutdownHV
sleep 1
timeStamp
sleep 10
exit
EOS

str1=<<-EOS
timeStamp
sleep 1
increaseHV #{HV1}
sleep 1
#{str_repeat1.chomp}
sleep 1
setHV 0.0
sleep 1
shutdownHV
sleep 1
timeStamp
sleep 1
exit
EOS

str2=<<-EOS
timeStamp
sleep 1
increaseHV #{HV2}
sleep 1
#{str_repeat2.chomp}
sleep 1
setHV 0.0
sleep 1
shutdownHV
sleep 1
timeStamp
sleep 1
exit
EOS

puts "\nFILES are generated to ..."
puts "#{rcfile0}"
puts "#{rcfile1}"
puts "#{rcfile2}"
File.write("runscript/"+rcfile0, str0)
File.write("runscript/"+rcfile1, str1)
File.write("runscript/"+rcfile2, str2)

puts "\nStart opearion ModuleMassCmdr.rb\n"
sleep 0.5
system(%Q(./ModuleMassCmdr.rb runscript/#{rcfile0} runscript/#{rcfile1} runscript/#{rcfile2}))
