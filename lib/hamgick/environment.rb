require 'rvg/rvg'
module Hamgick
  class Environment < Hash

    @@stack = []
    attr_reader :canvas

    def self.start(attrs={})
      @@stack.clear
      push(attrs.merge(:root => true))
    end

    def self.push(attrs={})
      @@stack << new.merge(attrs)
      last
    end

    def self.empty?
      @@stack.empty?
    end

    def self.almost_empty?
      size == 1
    end

    def self.pop
      @@stack.pop
    end

    def push(attrs={})
      self.class.push( self.merge(attrs) )
    end

    def pop
      self.class.pop
      self.class.last
    end

    def self.last
      @@stack.last
    end

    def self.current
      last
    end

    def self.size
      @@stack.size
    end


    def create_canvas(opts={})
      Magick::RVG.dpi = 90
      self[:canvas] = Magick::RVG.new(2.5.in, 2.5.in)
    end

    def canvas
      self[:canvas]
    end

    def push_group
      push(:canvas => canvas.g, :is_group => true)
    end

    def push_canvas(new_canvas)
      push(:canvas => new_canvas, :is_group => false)
    end

    def is_group?
      self[:is_group]
    end


  end
end
