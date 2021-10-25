#!/usr/bin/env ruby

nruns=[56, 58]
#nruns=[54, 55, 56, 58]
#nruns=[54]
paradir="para/"

nruns.each {|irun|
  image_file=sprintf("image_scaler_eps/mppc_%04d_*.eps", irun)
  list=`ls #{image_file}`.split("\n")
  list.each {|file|
    name0=file[17..35]
    name1=file[17..30]
    ch=file[34..35].to_i

    parafile=paradir+name0+".txt"
    dac=0
    begin
      File.open(parafile) {|ifile|
        data=ifile.gets.chomp.split("\t")
        if data[0]!="#dac" then
          puts "Fail to read dac value"
          return false
        end
        data=ifile.gets.chomp.split("\t")
        dac=data[0]
      } #ifile
    rescue => e
      puts e.message
    end
    system(%Q(root -l -b -q 'scaler1.cpp("#{name1}", #{dac}, #{ch})'))
    #puts %Q(root -l -b -q 'scaler1.cpp("#{name1}", #{dac}, #{ch})')
  } #file
} #irun

system(%Q(./rsync_local_to_dropbox.sh))
