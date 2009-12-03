require 'haml'
class HamgickParser

  class Line < Struct.new(:text, :index, :precompiler, :eod)
    alias_method :eod?, :eod
    attr_accessor :command, :arguments_or_options

    def initialize(*args)
      super

      @assign = false
      if text =~ /([\w_]+=?)\s*(.*)$/
        @command = $1
        @arguments_or_options = $2
        if @command.ends_with?('=')
          @command.chop!
          @assign = true
        end
      end
    end

    def assign?
      @assign
    end

    def stripped
      @stripped ||= text.lstrip
    end

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

    # FIXME poor detection hash vs. array
    def evaled_arguments
      to_eval = if arguments_or_options =~ /[^,]+=>/
        %Q~{ #{arguments_or_options}  }~
      else
        %Q~[ #{arguments_or_options}  ]~
      end
      precompiler.instance_eval to_eval
    end
  end

  # commands that need a group to operate on
  PROPERTY  = %w( background_fill ).map(&:to_sym)

  def initialize(template, options = {})
    @options = {
      :format => 'png'
    }.merge(options)
    @template = (template.rstrip).split(/\r\n|\r|\n/) + [:eod, :eod]
    @template_index = 0
  end

  def compile
    @environment = Hamgick::Environment.start
    @newlines = 0
    @template_tabs = 0
    @line = next_line
    newline
    raise SyntaxError.new("Indenting at the beginning of the document is illegal.", @line.index) if @line.tabs != 0

    while next_line
      process_indent(@line) unless @line.text.empty?

      process_line(@line) unless @line.text.empty?

      if @next_line.tabs - @line.tabs > 1
        raise SyntaxError.new("The line was indented #{@next_line.tabs - @line.tabs} levels deeper than the previous line.", @next_line.index)
      end

      #resolve_newlines unless @next_line.eod?
      @line = @next_line
      newline unless @next_line.eod?
    end
    close until Hamgick::Environment.almost_empty?
  end

  alias_method :precompile, :compile

  def next_line_indented?
    @next_line.tabs > @line.tabs
  end

  def process_indent(line)
    return unless line.tabs <= @template_tabs && @template_tabs > 0

    to_close = @template_tabs - line.tabs
    to_close.times {|i| close }
  end

  def process_line(line)
    @index = line.index + 1

    raise SyntaxError, "no command found in #{line.index}: #{line.text}" if line.command.nil?

    if line.assign?
      partial = Magick::RVG::Group.new
      @environment[line.command.to_sym] = partial
      push_canvas(partial) if next_line_indented?
      return
    end

    arguments_or_options = line.evaled_arguments
    command = line.command.to_sym
    case command
    when :rvg # TODO do it lazy
      @environment.create_canvas
      @template_tabs += 1
      return
    when *@environment.keys # previously saved partials
      arguments_or_options.unshift @environment[command]
      command = :use
    when :group
      command = :g
    when *Magick::RVG::STYLES
      arguments_or_options = {command => arguments_or_options.first }
      command = :styles
    when *PROPERTY
      command = :"#{command}="
    end

    result = execute_command(command, arguments_or_options)
    push_canvas(result) if next_line_indented?
  end

  def execute_command(command, arguments_or_options)
    if arguments_or_options.is_a?(Hash)
      @environment.canvas.send(command, arguments_or_options)
    else
      @environment.canvas.send(command, *arguments_or_options)
    end
  end

  def close
    @template_tabs -= 1
    @environment = @environment.pop
  end


  def render
    Hamgick::Environment.last.canvas.draw
  end

  def push_canvas(new_canvas)
    @template_tabs += 1
    @environment = @environment.push_canvas(new_canvas)
  end

  def next_line
    text, index = raw_next_line
    return unless text

    # :eod is a special end-of-document marker
    line =
      if text == :eod
        Line.new '', index, self, true
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

  def log(text)
    STDERR.puts text
  end

end
