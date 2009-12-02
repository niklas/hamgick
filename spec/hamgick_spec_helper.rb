module HamgickSpecHelper
  class RenderedImage
    def initialize
    end

    def matches?(code)
      @code = code
      @parser = HamgickParser.new(code)
      @parser.precompile
      @image  = @parser.render
      @image.is_a?(Magick::Image)
    end

    def failure_message_for_should
      "expected the following code to create an image (was #{@image.inspect}):\n#{@code}\n----\n"
    end
  end
  def render_an_image
    RenderedImage.new
  end
  class Validation
    def initialize
    end

    def matches?(code)
      @code = code
      @parser = HamgickParser.new(code)
      begin
        @parser.precompile
        true
      rescue Exception => e
        @exception = e
        false
      end
    end

    def failure_message_for_should
      "expected valid Hamgick, #{@exception}\n#{@code}\n"
    end
  end
  def be_valid_hamgick
    Validation.new
  end

end

