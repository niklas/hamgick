module BasicsHelper
  def image(opts={}, &block)
    opts = opts.dup.reverse_merge({
      :width => 64,
      :height => 64,
      :background_color => 'green'
    })
    @image = Magick::Image.new(opts[:width], opts[:height]) do
      self.background_color = opts[:background_color]
      self.format = 'png'
    end
    block.call
    haml_concat @image.to_blob
  end

  def draw(opts={}, &block)
    @draw = Magick::Draw.new
    block.call
    @draw.draw(@image)
  end

  def circle(opts={})
    opts = opts.dup.reverse_merge({
    })
    origin_x = 32
    origin_y = 32
    perim_x  = 23
    perim_y  = 23
    @draw.circle(origin_x, origin_y, perim_x, perim_y)
  end
end
