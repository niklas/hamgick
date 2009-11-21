require 'spec_helper'

describe BasicsController do

  #Delete these examples and add some real ones
  it "should use BasicsController" do
    controller.should be_an_instance_of(BasicsController)
  end


  describe "GET 'circle'" do
    it "should be successful" do
      get 'circle'
      response.should be_success
    end
  end

  describe "GET 'multicircle'" do
    it "should be successful" do
      get 'multicircle'
      response.should be_success
    end
  end
end
