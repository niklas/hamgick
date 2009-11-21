require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new
  end
  def parse(input)
    parser.parse(input)
  end

  before( :all ) do
    Treetop.load 'lib/hamgick'
  end

  it "should recognize single command" do
    parse('%foo').should_not be_nil
  end
  it "should recognize single command with leading spaces" do
    parse('  %foo').should_not be_nil
  end
  
end

