TEST_MODE = true # This tells timetrap not to use the real database.

# Monkey patch for Ruby 3.2 compatibility with old RSpec version
class File
  class << self
    alias_method :exists?, :exist? unless method_defined?(:exists?)
  end
end

require 'rubygems'
require 'bundler'
Bundler.require
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
    Timetrap::Config.stub(:[]).with('auto_sheet').and_return(nil)
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
      Time.stub(:now).and_return local_time('2008-10-04 20:00:00')
      @desired_output = <<-OUTPUT
Timesheet: SpecSheet
    Day                Start      End        Duration   Notes
    Fri Oct 03, 2008   16:00:00 - 18:00:00   4:00:00    entry f:2
                                             4:00:00
    Sat Oct 04, 2008   16:00:00 - 18:00:00   1:00:00    entry f:0.5
                       19:00:00 -            1:00:00    entry
                                             2:00:00
    ---------------------------------------------------------------
    Total                                    6:00:00
      OUTPUT
    end

    it "should correctly handle factors in notes" do
      Timetrap::Timer.current_sheet = 'SpecSheet'
      invoke 'display --format factor'
      $stdout.string.should == @desired_output
    end
  end

  describe "by date" do
    before do
      Timetrap::Entry.create( :sheet => 'SpecSheet',
        :note => 'entry one', :start => '2008-10-03 16:00:00', :end => '2008-10-03 18:00:00'
      )
      Timetrap::Entry.create( :sheet => 'SpecSheet',
        :note => 'entry two', :start => '2008-10-04 16:00:00', :end => '2008-10-04 18:00:00'
      )
      Timetrap::Entry.create( :sheet => 'SpecSheet',
        :note => 'entry theww', :start => '2008-10-04 19:00:00'
      )
      Time.stub(:now).and_return local_time('2008-10-04 20:00:00')
    end

    it "should correctly output by day format" do
      Timetrap::Timer.current_sheet = 'SpecSheet'
      invoke 'display --format by_day'
      $stdout.string.should == <<-OUTPUT
## Fri Oct 03, 2008 ##

        Sheet   Start      End        Duration   Notes
    SpecSheet   16:00:00 - 18:00:00   2:00:00    entry one
    ────────────────────────────────────────────────────────────
    Total                                    2:00:00

## Sat Oct 04, 2008 ##

        Sheet   Start      End        Duration   Notes
    SpecSheet   16:00:00 - 18:00:00   2:00:00    entry two
                19:00:00 -            1:00:00    entry theww
    ────────────────────────────────────────────────────────────
    Total                                    3:00:00

────────────────────────────────────────────────────────────────
Grand Total                                  5:00:00
OUTPUT
    end
  end

  describe "day" do
    before do
      # Configure the day formatter settings
      Timetrap::Config.stub(:[]).with('day_length_hours').and_return(8.0)
      Timetrap::Config.stub(:[]).with('progress_width').and_return(40.0)
      Timetrap::Config.stub(:[]).with('day_exclude_sheets').and_return([])
      Timetrap::Config.stub(:[]).with('day_countdown').and_return(false)
      Timetrap::Config.stub(:[]).with('formatter_search_paths').and_return(
        [File.expand_path(File.join(File.dirname(__FILE__), '..', 'formatters'))]
      )
      
      # Create entries for a past date (2013-07-29)
      Timetrap::Entry.create( :sheet => 'work',
        :note => 'past entry', :start => '2013-07-29 10:00:00', :end => '2013-07-29 14:00:00'
      )
    end

    it "should correctly display entries for past dates" do
      Timetrap::Timer.current_sheet = 'work'
      invoke 'display --start "2013-07-29" --end "2013-07-29" --format day'
      # Should show 4 hours of 8 hours = 50%
      output = $stdout.string
      output.should include('50%')
      output.should include('4:00:00')
    end

    it "should correctly display entries for a different date" do
      # Create entries for a specific date (not necessarily today)
      Timetrap::Entry.create( :sheet => 'work',
        :note => 'entry for specific date', :start => '2013-07-30 09:00:00', :end => '2013-07-30 11:00:00'
      )
      
      Timetrap::Timer.current_sheet = 'work'
      invoke "display --start \"2013-07-30\" --format day"
      # Should show 2 hours of 8 hours = 25%
      output = $stdout.string
      output.should include('25%')
      output.should include('2:00:00')
    end
  end
end
