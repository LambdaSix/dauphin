require_relative 'platform'

module Dauphin
  class Runtime
    attr_reader :path

    def initialize(exepath=nil)
      puts "Making new Runtime(#{self.inspect}), path: #{exepath.inspect}"
      @path = exepath || default_executable_path
      puts "default_executable_path: #{path}"
      puts "Path: #{@path}"
      check_for_binary
    end

    def check_for_binary
      raise 'Cannot find prince command-line app in $PATH' if !path || path.length == 0
      raise "Cannot run executable at #{path}" unless File.executable? path
    end

    def default_executable_path
      if Platform.windows?
        return 'C:/Program Files/Prince/Engine/bin/prince'
      end
      if Platform.linux?
        `which prince`.chomp
      end
    end

    def join(options)
      ([@path] + Array(options)).join(' ')
    end
  end
end