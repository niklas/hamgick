module Hamgick
  class Environment < Hash

    @@stack = []
    attr_reader :canvas

    def self.start(attrs={})
      @@stack.clear
      push(attrs)
    end

    def self.push(attrs={})
      @@stack << new.merge(attrs)
      last
    end

    def push(attrs={})
      self.class.push( self.merge(attrs) )
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
      require 'rvg/rvg'
      Magick::RVG.dpi = 90
      @canvas = Magick::RVG.new(2.5.in, 2.5.in)
    end


  end
end
