require 'spec_helper'


describe Hamgick::Environment do

  describe "freshly started" do
    before( :each ) do
      @env = Hamgick::Environment.start
    end

    it "should not be empty" do
      Hamgick::Environment.should_not be_empty
    end

    it "should be almost empty" do
      Hamgick::Environment.should be_almost_empty
    end

    it "should have last/current" do
      Hamgick::Environment.last.should_not be_nil
      Hamgick::Environment.current.should_not be_nil
    end

    it "should create a Magick::RVG on #create_canvas" do
      Magick::RVG.should_receive(:new).and_return('new rvg')
      @env.create_canvas
      @env.canvas.should == 'new rvg'
    end

    
  end
  
end
