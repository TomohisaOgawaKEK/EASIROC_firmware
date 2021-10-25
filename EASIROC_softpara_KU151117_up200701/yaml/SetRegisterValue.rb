#!/bin/env ruby

require 'yaml'
require 'optparse'

FILENAME='RegisterValue.yml'
data = YAML.load_file(FILENAME)

opt = OptionParser.new
opt.on('-c HG_CH1', '--hg-ch1 HG_CH1', 'High Gain Channel 1')
      {|v| data["High Gain Channel 1"] = v.to_i}

opt.on('-d HG_CH2', '--hg-ch2 HG_CH2', 'High Gain Channel 2')
      {|v| data["High Gain Channel 2"] = v.to_i}

opt.on('-f [CHG_FB]', '--chg-fb [CHG_FB]', 'EASIROC1 => Capacitor HG PA Fdbck (default: 200fF)')
      {|v| data["EASIROC1"]["Capacitor HG PA Fdbck"] = v || "200fF"}

opt.on('-g [CLG_FB]', '--clg-fb [CLG_FB]', 'EASIROC1 => Capacitor LG PA Fdbck (default: 200fF)')
      {|v| data["EASIROC1"]["Capacitor LG PA Fdbck"] = v || "200fF"}

opt.on('-t DAC', '--thr DAC', 'EASIROC1 => DAC code')
      {|v| data["EASIROC1"]["DAC code"] = v.to_i}

opt.on('-u UCLK', '--uclk UCLK', 'UsrClkOut')
		{|v| 
  			if v.include?('Hz') then
    			data["UsrClkOut"] = v
  			else
    			data["UsrClkOut"] = v.to_i
  			end
		}
opt.parse!(ARGV)

puts "************"
puts data
File.write(FILENAME, data.to_yaml)

