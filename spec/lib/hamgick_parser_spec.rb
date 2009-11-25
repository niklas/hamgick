require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new
  end
  def parse(input=@code)
    parser.parse(input)
  end

  def render(input=@code)
    parse(input).render
  end

  before( :all ) do
    Treetop.load 'lib/hamgick'
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

  describe "with every valid input", :shared => true do
    it "should get a parse tree" do
      @code.chomp.should be_valid_hamgick
    end
    it "should render an image" do
      @code.chomp.should render_an_image
    end
    
  end

  describe "image" do
    before( :each ) do
      @code = '%image'
    end
    it_should_behave_like 'with every valid input'
  end

  describe "image with circle" do
    before( :each ) do
      @code = <<EOHAM
%image
  %draw
    %circle
EOHAM
    end

    it_should_behave_like 'with every valid input'

    it "should draw a circle" do
      should_draw(:circle)
      render
    end
    
  end

  describe "imge with colored circle" do
    before( :each ) do
      @code = <<EOHAM
%image
  %draw
    %stroke{:color => 'red'}
      %circle
EOHAM
    end
      
    it_should_behave_like 'with every valid input'

    it "should set color and draw a circle" do
      pending "really commands and %stroke"
      should_change_stroke_to(:color => 'red').ordered
      should_draw(:circle).ordered
      render
    end
    
  end


  describe "image with 2 circles" do
    before( :each ) do
      @code = <<EOHAM
  %image
    %draw
      %circle
      %circle
EOHAM
    end

    it_should_behave_like 'with every valid input'

    it "should draw 2 circles" do
      pending "multiple commands in same column"
      should_draw(:circle).twice
      render
    end
    
  end

  
end

