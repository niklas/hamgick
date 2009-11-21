module BasicsHelper
  def image(opts={}, &block)
    stuff = capture_haml(&block)
    opts = opts.dup.reverse_merge({
      :width => 64,
      :height => 64,
      :background_color => 'green'
    })
    @image = Magick::Image.new(opts[:width], opts[:height]) do
      self.background_color = opts[:background_color]
      self.format = 'png'
    end
    haml_concat @image.to_blob
  end
end
