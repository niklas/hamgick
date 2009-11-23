require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
class RenderedImage
  def initialize
  end

  def matches?(code)
    @parser = HamgickParser.new
    @parsed = @parser.parse(code)
    @image  = @parsed.image
    @image.is_a?(Magick::Image)
  end

  def failure_message_for_should
    "expected the following code to create an image (was #{@image.inspect}):\n#{@code}\n----"
  end
end

describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new
  end
  def parse(input)
    parser.parse(input)
  end

  def render(input)
    parse(input)
  end

  before( :all ) do
    Treetop.load 'lib/hamgick'
  end

  def render_an_image
    RenderedImage.new
  end

  #it "should render image" do
  #  render('%image').should be_true
  #end
  it "should render image with circle" do
    "%image\n  %draw\n    %circle".should render_an_image
  end
  
end

