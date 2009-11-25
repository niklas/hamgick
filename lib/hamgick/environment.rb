module Hamgick
  class Environment

    attr_accessor :image
    attr_accessor :drawer

    def initialize
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

  end
end
