require 'haml'
class HamgickParser

  class Line < Struct.new(:text, :index, :precompiler, :eod)
    alias_method :eod?, :eod

    def tabs
      line = self
      @tabs ||= precompiler.instance_eval do
        break 0 if line.text.empty? || !(whitespace = line.text[/^\s+/])

        if @indentation.nil?
          @indentation = whitespace

          if @indentation.include?(?\s) && @indentation.include?(?\t)
            raise SyntaxError.new("Indentation can't use both tabs and spaces.", line.index)
          end

          break 1
        end

        tabs = whitespace.length / @indentation.length
        break tabs if whitespace == @indentation * tabs

        raise SyntaxError.new(<<END.strip.gsub("\n", ' '), line.index)
Inconsistent indentation: #{Haml::Shared.human_indentation whitespace, true} used for indentation,
but the rest of the document was indented using #{Haml::Shared.human_indentation @indentation}.
END
      end
    end
  end

  def initialize(template, options = {})
    @options = {
      :format => 'png'
    }.merge(options)
    @template = (template.rstrip).split(/\r\n|\r|\n/) + [:eod, :eod]
    @template_index = 0
  end

  def precompile
    @newlines = 0
    @line = next_line
    newline
    raise SyntaxError.new("Indenting at the beginning of the document is illegal.", @line.index) if @line.tabs != 0

    while next_line
      process_indent(@line) unless @line.text.empty?

      process_line(@line.text, @line.index) unless @line.text.empty?

      if @next_line.tabs - @line.tabs > 1
        raise SyntaxError.new("The line was indented #{@next_line.tabs - @line.tabs} levels deeper than the previous line.", @next_line.index)
      end

      #resolve_newlines unless @next_line.eod?
      @line = @next_line
      newline unless @next_line.eod?
    end
  end

  def process_indent(line)
    STDERR.puts "Indent: #{line.tabs}"
  end

  def process_line(text, index)
    @index = index + 1
    STDERR.puts "#{index}: #{text}"
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
        Line.new '-#', index, self, true
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

  def newline
    @newlines += 1
  end


end
