require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new
  end
  def parse(input)
    parser.parse(input)
  end

  def render(input)
    parsed = parse(input)
    parsed.should_not be_nil
    parsed.image.display
  end

  before( :all ) do
    Treetop.load 'lib/hamgick'
  end

  #it "should render image" do
  #  render('%image').should be_true
  #end
  it "should build image with circle" do
    @text = "%image\n  %draw\n    %circle"
    render(@text)
  end
  
end

