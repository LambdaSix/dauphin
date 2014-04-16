# Prince 9 Ruby interface
# http://princexml.com
#
# USAGE
# --
#   dauphin = Dauphin.new
#   pdf = dauphin.mkpdf_stream(html) # pdf is now PDF data

require 'dauphin/version'
require 'logger'
require 'pathname'

module Dauphin
  autoload :StdoutLogger, 'dauphin/stdout_logger'
  autoload :Pdf,          'dauphin/pdf'
  autoload :Logging,      'dauphin/logging'
  autoload :Runtime,      'dauphin/runtime'

  class << self
    def runtime
      @default_runtime || Dauphin::Runtime.new
    end

    def runtime=(custom_exe)
      @default_runtime = custom_exe
    end

    def root
      Pathname.new(File.expand_path('../', __FILE__))
    end
  end
end
