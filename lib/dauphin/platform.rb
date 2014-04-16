require 'rbconfig'

module Dauphin
  class Platform
    def self.os
      @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          :linux
        when /solaris|bsd/
          :unix
        else
          raise Exception, "Unknown OS: #{host_os.inspect}"
      end
      )
    end

    def self.windows?
      os == :windows
    end

    def self.linux?
      os == :linux
    end
  end
end