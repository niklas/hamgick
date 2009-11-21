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

  def color(opts={}, &block)
    if fg = opts[:foreground] || opts[:stroke]
      @draw.stroke(fg)
    end
    if fill = opts[:fill]
      @draw.fill(fill)
    end
    block.call
  end

  def circle(opts={}, &block)
    opts = opts.dup.reverse_merge({
      :radius => 16,
      :x => 32, :y => 32
    })
    origin_x = opts[:x]
    origin_y = opts[:y]
    perim_x  = opts[:x] - opts[:radius]
    perim_y  = opts[:y]
    @draw.circle(origin_x, origin_y, perim_x, perim_y)
    block.call if block_given?
  end
end
