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

  it "should create a new Magick::RVG" do
    Magick::RVG.should_receive(:new).and_return(rvg_mock(:draw => true))
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

