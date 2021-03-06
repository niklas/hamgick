module Hamgick
  class DrawCommandNode < Treetop::Runtime::SyntaxNode
    attr_accessor :draw
    def render(draw, opts={})
      self.draw = draw
      method_name = name.text_value
      if respond_to?(method_name)
        send(method_name, opts)
      else
        raise "do not know how to draw #{method_name}"
      end
    end
    def circle(opts={})
      opts = opts.dup.reverse_merge({
        :radius => 16,
        :x => 32, :y => 32
      })
      origin_x = opts[:x]
      origin_y = opts[:y]
      perim_x  = opts[:x] - opts[:radius]
      perim_y  = opts[:y]
      draw.circle(origin_x, origin_y, perim_x, perim_y)
    end
  end
end
