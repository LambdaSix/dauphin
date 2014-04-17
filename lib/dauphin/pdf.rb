module Dauphin
  class Pdf
    attr_accessor :executable, :stylesheets, :logger, :log_file, :prince_logging

    def initialize(opt={})
      options = {
          :path => nil,
          :executable => Dauphin.runtime,
          :prince_logging => false,
          :log_file => nil,
          :logger => nil
      }.merge(opt)

      @executable = options[:path] ? Dauphin::Runtime.new(options[:path]) : options[:executable]
      @stylesheets = ''
      @log_file = options[:log_file]
      @logger = options[:logger]
      @prince_logging = options[:prince_logging]
    end

    def logger
      @logger || Dauphin::Logging.logger
    end

    def log_file
      @log_file || Dauphin::Logging.file
    end

    def add_style_sheet(*sheets)
      @stylesheets << sheets.map { |sheet| " -s #{sheet} " }.join(' ')
    end

    def exe
      @executable.join(executable_options)
    end

    def executable_options
      options = []
      options << '--input=html'
      options << "--log=#{log_file}" if @prince_logging
      options << @stylesheets || ''
      options
    end

    def prince_version
      `#{executable.path + ' --version'}`
    end


    # @return A string containing the PDF binary data
    def mkpdf_stream(string, output_file = '-')
      (mkpdf string, output_file, {:output_to_log_file => false}; nil)
      File.binread("#{output_file}.pdf").to_s
    end

    def mkpdf_file(string, output_file)
      (mkpdf string, output_file; nil)
    end

    protected
    def mkpdf(string, output_file, opt={})
      options = {
          :log_command => true,
          :output_log => true
      }.merge(opt)

      filename = Digest::SHA1.hexdigest(string)

      File.open(filename, 'w+') do |file|
        file.puts string
      end

      path = exe
      path << " >> '#{log_file}' 2>> '#{log_file}'" if options[:output_to_log_file]
      path << " #{filename} "
      path << " --output #{output_file}.pdf"

      log path if options[:log_command]

      result = (`#{path}`; nil)

      puts result

      File.binread("#{filename}.pdf")
    end

    def log(path)
      logger.info "\n\nPRINCE PDF:"
      logger.info path
      logger.info ''
    end
  end
end