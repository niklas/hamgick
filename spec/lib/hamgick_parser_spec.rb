require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new(code)
  end
  def compile
    parser.precompile
  end

  def render(input=code)
    compile
    parser.render
  end

  def code
    @code ||= File.read( File.join(RAILS_ROOT, 'app/views/basics/duck.svg.hamgick')  )
  end

  before( :each ) do
    @parser = nil
  end

  def environment_mock
    return @environment_mock if @environment_mock
    @environment_mock = stub('Hamgick::Environment')
    Hamgick::Environment.stub!(:new).and_return(@environment_mock)
    @environment_mock
  end

  def rvg_mock(stubs={})
    @environment_mock = stub('Magick::RVG', stubs)
  end

  def should_change_stroke_to(settings)
    environment_mock.should_receive("stroke=").with(settings)
  end

  it "should load code" do
    code.should_not be_blank
  end


  it "should be parsable" do
    code.should be_valid_hamgick
  end

  it "should be renderable" do
    code.should render_an_image
  end

  it "should use Magick::RVG and derivates" do
    Magick::RVG.should_receive(:new).and_return( rvg = mock('Magick::RVG', :draw => true) )
    rvg.should_receive(:viewbox).with(0,0,250,250).and_return(rvg)
    rvg.should_receive(:background_fill=).with('white')
    rvg.should_receive(:g).and_return( g1 = mock('Magick::RVG::Group_1'))
      g1.should_receive(:translate).with(100, 150).and_return( g1 )
      g1.should_receive(:rotate).with(-30).and_return( g1 )
      g1.should_receive(:styles).with(:fill => 'yellow', :stroke => 'black', :stroke_width => 2).and_return( g1 )
      g1.should_receive(:ellipse).with(50,30)
      g1.should_receive(:rect).with(45, 20, -20, -10).and_return( rect = mock('Magick::RVG::Rect') )
        rect.should_receive(:styles).with(:fill => 'orange')
    
    rvg.should_receive(:g).and_return( g2 = mock('Magick::RVG::Group_2'))
      g2.should_receive(:translate).with(130, 83).and_return( g2 )
      g2.should_receive(:styles).with(:stroke => 'black')
      g2.should_receive(:styles).with(:stroke_width => 2)
      g2.should_receive(:circle).with(30).and_return( circle = mock('Magick::RVG::Circle') )
        circle.should_receive(:styles).with(:fill => 'yellow')
      g2.should_receive(:circle).with(5, 10, -5).and_return( circle = mock('Magick::RVG::Circle') )
        circle.should_receive(:styles).with(:fill => 'black')
      g2.should_receive(:polygon).with(30,0, 70,5, 30,10, 62,25, 23,20).and_return( polygon = mock('Magick::RVG::Polygon') )
        polygon.should_receive(:styles).with(:fill => 'orange')

    render
  end

  it "should accept random newlines"

  describe "parsing" do
    it "should parse arguments"
    it "should parse options"
    it "should parse any ruby returning arguments or options"
    it "should eval this ruby in the @template's context"
    it "should call the commands on Magick objects"
    it "should keep a stack of Magick objects"
    it "should be empty at first"
    it "should create a new default Magick::RVG instance if no 'rvg' command is found on root of document"
    it "should call the commands always on the last (current) item on the stack"
    it "should push the result of a command to the stack if it opens a new block by indention"
    it "should pop the stack when finding less indented commands"
    it "should not create groups implicitly"
  end
  
end

