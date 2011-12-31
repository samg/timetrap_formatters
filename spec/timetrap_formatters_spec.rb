TEST_MODE = true # This tells timetrap not to use the real database.
require 'rubygems'
require 'timetrap'
require 'rspec'

describe Timetrap::Formatters do
  def local_time(str)
    Timetrap::Timer.process_time(str)
  end

  def local_time_cli(str)
    local_time(str).strftime('%Y-%m-%d %H:%M:%S')
  end

  def invoke command
    Timetrap::CLI.parse command
    Timetrap::CLI.invoke
  end
  before :each do
    Timetrap::Config.stub(:[]).with('formatter_search_paths').and_return(
      [File.expand_path(File.join(File.dirname(__FILE__), '..', 'formatters'))]
    )
    Timetrap::Entry.create_table!
    Timetrap::Meta.create_table!
    $stdout = StringIO.new
    $stdin = StringIO.new
    $stderr = StringIO.new
  end

  after :each do
    STDERR.puts $stderr.string unless $stderr.string == ''
  end

  describe "factor" do
    before do
      Timetrap::Entry.create( :sheet => 'SpecSheet',
        :note => 'entry f:2', :start => '2008-10-03 16:00:00', :end => '2008-10-03 18:00:00'
      )
      Timetrap::Entry.create( :sheet => 'SpecSheet',
        :note => 'entry f:0.5', :start => '2008-10-04 16:00:00', :end => '2008-10-04 18:00:00'
      )
      Timetrap::Entry.create( :sheet => 'SpecSheet',
        :note => 'entry', :start => '2008-10-04 19:00:00'
      )
      Time.stub!(:now).and_return local_time('2008-10-04 20:00:00')
      @desired_output = <<-OUTPUT
Timesheet: SpecSheet
    Day                Start      End        Duration   Notes
    Fri Oct 03, 2008   16:00:00 - 18:00:00   4:00:00    entry f:2
                                             4:00:00
    Sat Oct 04, 2008   16:00:00 - 18:00:00   1:00:00    entry f:0.5
                       19:00:00 -            1:00:00    entry
                                             2:00:00
    ---------------------------------------------------------
    Total                                    6:00:00
      OUTPUT
    end

    it "should correctly handle factors in notes" do
      Timetrap::Timer.current_sheet = 'SpecSheet'
      invoke 'display --format factor'
      $stdout.string.should == @desired_output
    end
  end
end
