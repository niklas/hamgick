require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new
  end
  def parse(input)
    parser.parse(input)
  end

  def render(input)
    parse(input).image.display
  end

  before( :all ) do
    Treetop.load 'lib/hamgick'
  end

  it "should render image" do
    render('%image').should be_true
  end
  it "should build image with circle" do
    pending "whitespace indention"
    @text = "%image\n  %circle"
    parse(@text).should_not be_nil
  end
  
end

