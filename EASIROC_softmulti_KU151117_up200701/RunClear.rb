#!/usr/bin/env ruby

require 'yaml'

nrun=(ARGV.shift || 0).to_i
nsub=0

HV1=0
HV2=0
HV3=0
repeat=1
interval=0.2
events=5
name1="YNUno1"
name2="UTno5"
name3="UTno4"
rcfile0="clear_0000_0000.txt"
rcfile1="clear_0000_0100.txt"
rcfile2="clear_0000_0200.txt"

buf0=<<-EOS
standby 1
read %d %s enclk
sleep 2
EOS

buf1=<<-EOS
read %d %s queue
sleep 2
EOS

buf2=<<-EOS
read %d %s queue
sleep 2
EOS

str_repeat0=""
str_repeat1=""
str_repeat2=""
repeat.times {|i|
  irun = nrun + i
  datafile0 = sprintf("clear_%s_%04d_#{Time.now.to_i}", name1, irun)
  datafile1 = sprintf("clear_%s_%04d_#{Time.now.to_i}", name2, irun)
  datafile2 = sprintf("clear_%s_%04d_#{Time.now.to_i}", name3, irun)
  str_repeat0 += sprintf(buf0, events, datafile0)
  str_repeat1 += sprintf(buf1, events, datafile1)
  str_repeat2 += sprintf(buf2, events, datafile2)
}

str0=<<-EOS
increaseHV #{HV1}
#{str_repeat0.chomp}
sleep 1
setHV 0.0
sleep 1
shutdownHV
sleep 1
exit
EOS

str1=<<-EOS
increaseHV #{HV2}
sleep 1
#{str_repeat1.chomp}
sleep 1
setHV 0.0
sleep 1
shutdownHV
sleep 1
exit
EOS

str2=<<-EOS
increaseHV #{HV3}
sleep 1
#{str_repeat2.chomp}
sleep 1
setHV 0.0
sleep 1
shutdownHV
sleep 1
exit
EOS

puts "Make #{rcfile0}, #{rcfile1}, #{rcfile2}"
File.write("rc/"+rcfile0, str0)
File.write("rc/"+rcfile1, str1)
File.write("rc/"+rcfile2, str2)

#puts "waiting 60 sec..."
sleep 0.1
system(%Q(./masstest.rb rc/#{rcfile0} rc/#{rcfile1} rc/#{rcfile2}))

