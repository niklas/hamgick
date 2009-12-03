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

    describe "pushing a canvas" do
      before( :each ) do
        @new_env = @env.push_canvas(:new_canvas)
      end

      it "should return a new environment" do
        @new_env.should_not == @env
      end

      it "should set the given canvas" do
        @new_env.canvas.should == :new_canvas
      end

      it "should be the new current" do
        Hamgick::Environment.last.should == @new_env
      end

      describe "popping it" do

        before( :each ) do
          @prev_env = @new_env.pop
        end

        it "should return the original env" do
          @prev_env.should == @env
        end

        it "should make the original env the last one" do
          Hamgick::Environment.last.should == @env
        end

      end
      
    end

    
  end
  
end
