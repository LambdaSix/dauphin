module Dauphin
  class Pdf
    attr_accessor :executable, :stylesheets, :logger, :log_file

    def initialize(opt={})
      options = {
          :path => nil,
          :executable => Dauphin.runtime,
          :log_file => nil,
          :logger => nil
      }.merge(opt)

      @executable = options[:path] ? Dauphin::Runtime.new(options[:path]) : options[:executable]
      @stylesheets = ''
      @log_file = options[:log_file]
      @logger = options[:logger]
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
      puts "@executable: #{@executable.inspect}"
      @executable.join(executable_options)
    end

    def executable_options
      options = []
      options << "--input=html"
      options << "--log=#{log_file}"
      options << @stylesheets
      options
    end

    def mkpdf_stream(string, output_file = '-')
      pdf = create_pdf string, output_file, {:output_to_log_file => false}
      pdf.close_write

      result = pdf.gets
      pdf.close_read

      result.force_encoding(Encoding::BINARY) if RUBY_VERSION >= '1.9'
      result
    end

    def mkpdf_file(string, output_file)
      pdf = create_pdf string, output_file
      pdf.close
    end

    protected
    def create_pdf(string, output_file, opt={})
      options = {
          :log_command => true,
          :output_log => true
      }.merge(opt)

      path = exe

      path << " --silent - -o #{output_file}"
      path << " >> '#{log_file}' 2>> '#{log_file}'" if options[:output_to_log_file]
      puts "Path: #{path.inspect}"

      log path if options[:log_command]

      pdf = IO.popen(path, 'w+')
      pdf.puts string
      pdf
    end

    def log(path)
      logger.info "\n\nPRINCE PDF:"
      logger.info path
      logger.info ''
    end
  end
end