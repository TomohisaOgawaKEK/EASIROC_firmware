#!/bin/env ruby

require 'yaml'

FILENAME="InputDAC.yml"
DEFAULT = 400

#p ARGV
ch = ARGV.shift || "all"
chnum = ch.to_i
val = ARGV.shift || DEFAULT
val = val.to_i

#p ch
#p chnum
#p val
#puts "ch=#{ch}, chnum=#{chnum}, val=#{val}"

data = YAML.load_file(FILENAME)

if ch == "all" || chnum == -1 then
  puts "Set all DAC value to #{val}."
  for i in 0..31 do
    data["EASIROC1"]["Input 8-bit DAC"][i]=val
    data["EASIROC2"]["Input 8-bit DAC"][i]=val
  end
elsif 0 <= chnum && chnum < 64 then
  puts "Set ch #{ch} DAC value to #{val}."
  if 0 <= chnum && chnum < 32 then
    data["EASIROC1"]["Input 8-bit DAC"][chnum]=val
  elsif 32 <= chnum && chnum < 64 then
    data["EASIROC2"]["Input 8-bit DAC"][chnum-32]=val
  end
else
  puts <<-EOS
USAGE: #{__FILE__} chnum val
0 <= chnum < 64
0 <= val < 512
  EOS
end

puts "************"
puts data
File.write(FILENAME, data.to_yaml)
