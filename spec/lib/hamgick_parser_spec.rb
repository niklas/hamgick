require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
class RenderedImage
  def initialize
  end

  def matches?(code)
    @code = code
    @parser = HamgickParser.new
    @parsed = @parser.parse(code)
    @image  = @parsed.image if @parsed
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

  def draw_mock
    return @draw_mock if @draw_mock
    @draw_mock = stub('Magick::Draw',
      :draw => true
    )
    Magick::Draw.stub!(:new).and_return(@draw_mock)
    @draw_mock
  end

  def environment_mock
    return @environment_mock if @environment_mock
    @environment_mock = stub('Hamgick::Environment')
    Hamgick::Environment.stub!(:new).and_return(@environment_mock)
    @environment_mock
  end

  def should_draw(something)
    draw_mock.should_receive(something)
  end

  def should_change_stroke_to(settings)
    environment_mock.should_receive("stroke=").with(settings)
  end

  #it "should render image" do
  #  render('%image').should be_true
  #end
  it "should render image with circle" do
    should_draw(:circle)
    code = <<EOHAM
%image
  %draw
    %circle
EOHAM
    code.chomp.should render_an_image
  end

  it "should render image with with colored circle" do
    pending "really commands and %stroke"
    should_change_stroke_to(:color => 'red').ordered
    should_draw(:circle).ordered
    code = <<EOHAM
%image
  %draw
    %stroke{:color => 'red'}
      %circle
EOHAM
    code.chomp.should render_an_image
  end

  it "should render image with two circles" do
    pending "multiple commands in same column"
    should_draw(:circle).twice
    code = <<EOHAM
%image
  %draw
    %circle
    %circle
EOHAM
    code.chomp.should render_an_image
  end
  
end

