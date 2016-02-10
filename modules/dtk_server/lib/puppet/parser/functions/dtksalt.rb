require 'fileutils'

module Puppet::Parser::Functions
      newfunction(:dtksalt, :type => :rvalue) do |args|
        filename = args[0]
        FileUtils.mkdir_p File.dirname(filename)
        unless File.exist? filename
          str = (1..50).map{(rand(86)+40).chr}.join.gsub(/\\/,'\&\&')
          File.open(filename, 'a') {|fd| fd.print str }
        end
        File.open(filename, 'rb') { |f| f.read }
      end
    end
