module HamgickSpecHelper
  class RenderedImage
    def initialize
    end

    def matches?(code)
      @code = code
      @parser = HamgickParser.new
      @parsed = @parser.parse(code)
      @image  = @parsed.render if @parsed
      @image.is_a?(Magick::Image)
    end

    def failure_message_for_should
      "expected the following code to create an image (was #{@image.inspect}):\n#{@code}\n----\n#{@parser.failure_reason}"
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
      @parser = HamgickParser.new
      @parsed = @parser.parse(code)
      @parsed.is_a?(Treetop::Runtime::SyntaxNode)
    end

    def failure_message_for_should
      "expected valid Hamgick, #{@parser.failure_reason}\n#{@code}\n"
    end
  end
  def be_valid_hamgick
    Validation.new
  end

end

