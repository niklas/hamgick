module Hamgick
  class Environment < Hash

    attr_accessor :drawer

    @@stack = []

    def self.start(attrs={})
      @@stack.clear
      push(attrs)
    end

    def self.push(attrs={})
      @@stack << new.merge(attrs)
      last
    end

    def self.last
      @@stack.last
    end

    def self.size
      @@stack.size
    end

    def image
      self[:image] ||= build_image
    end

    def stroke=(settings)
      settings.each do |name, value|
        case name
        when :color
          drawer.stroke(value)
        else
          raise "unknown stroke setting: '#{name}'"
        end
      end
    end

    private
    def build_image
      opts = dup.reverse_merge({
        :width => 64,
        :height => 64,
        :background_color => 'green'
      })
      Magick::Image.new(opts[:width], opts[:height]) do
        self.background_color = opts[:background_color]
        self.format = 'png'
      end
    end

  end
end
