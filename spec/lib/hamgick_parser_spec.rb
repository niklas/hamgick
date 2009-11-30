require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
describe "Parsing Hamgick" do

  def parser
    @parser ||= HamgickParser.new
  end
  def parse(input=code)
    parser.parse(input)
  end

  def render(input=code)
    parse(input).render
  end

  def code
    @code ||= File.read( File.join(RAILS_ROOT, 'app/views/basics/duck.svg.hamgick')  )
  end

  before( :all ) do
    Treetop.load 'lib/options'
    Treetop.load 'lib/hamgick'
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

  it "should create a new Magick::RVG" do
    Magick::RVG.should_receive(:new).and_return(rvg_mock(:draw => true))
    render
  end

  it "should accept random newlines"

  
end

