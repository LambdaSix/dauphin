require 'spec_helper'

describe Dauphin::Pdf do
  let(:html_doc) { '<html><body>Hello World</body></html>'}

  before :each do
    Dauphin::Runtime.any_instance.stub(:check_for_binary).and_return(true)
  end

  it 'generates a PDF from HTML' do
    dauphin = Dauphin::Pdf.new
    pdf = dauphin.mkpdf_stream(html_doc)
    pdf.should start_with('%PDF-1.4')
    pdf.rstrip.should end_with('%%EOF')
    pdf.length > 100
  end

  it 'adds stylesheets' do
    dauphin = Dauphin::Pdf.new
    dauphin.add_style_sheet('test.css')

    dauphin.stylesheets.should == ' -s test.css '
  end

  describe 'logger' do
    it 'defaults to STDOUT' do
      dauphin = Dauphin::Pdf.new(:prince_logging => true)
      dauphin.logger.should == Dauphin::StdoutLogger
    end

    it 'can be set' do
      LoggerClass = Class.new
      dauphin = Dauphin::Pdf.new(:logger => LoggerClass.new, :prince_logging => true)
      dauphin.logger.should be_an_instance_of LoggerClass
    end
  end

  describe 'integration library' do
    it 'returns a version number' do
      dauphin = Dauphin::Pdf.new
      dauphin.prince_version
    end
  end

  describe 'log_file' do
    it 'defaults to a known path' do
      Dauphin::Logging.file = nil

      path = Pathname.new 'log_path'
      Dauphin.should_receive(:root).and_return(path)
      dauphin = Dauphin::Pdf.new(:prince_logging => true)

      dauphin.log_file.should == path.join('log/prince.log')
    end
  end

  describe 'exe_path' do
    let(:dauphin) { Dauphin::Pdf.new(:path => '/bin/true') }

    before :each do
      dauphin.stub(:log_file).and_return('./test_log')
    end

    it 'appends default options' do
      dauphin.exe.should == '/bin/true --input=html '
    end

    it 'adds stylesheet paths' do
      dauphin.stylesheets = ' -s test.css '
      dauphin.exe.should == '/bin/true --input=html  -s test.css '
    end
  end
end