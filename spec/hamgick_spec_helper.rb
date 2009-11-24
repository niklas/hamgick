module HamgickSpecHelper
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
  def render_an_image
    RenderedImage.new
  end

end
