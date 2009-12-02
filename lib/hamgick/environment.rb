module Hamgick
  class Environment < Hash

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

    def self.current
      last
    end

    def self.size
      @@stack.size
    end


  end
end
