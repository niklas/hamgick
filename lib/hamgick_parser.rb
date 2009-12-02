class HamgickParser

  class Line < Struct.new(:text, :index, :parser, :eod?)
  end

  def initialize(template, options = {})
    @options = {
      :format => 'png'
    }.merge(options)
    @template = (template.rstrip).split(/\r\n|\r|\n/) + [:eod, :eod]
    @template_index = 0
  end

  def precompile
    @line = next_line
  end

  def render
    "TODO Render Image"
  end

  def next_line
    text, index = raw_next_line
    return unless text

    # :eod is a special end-of-document marker
    line =
      if text == :eod
        Line.new '-#', '-#', '-#', index, self, true
      else
        Line.new text, index, self, false
      end
    @next_line = line
  end

  def raw_next_line
    text = @template.shift
    return unless text

    index = @template_index
    @template_index += 1

    return text, index
  end

end
