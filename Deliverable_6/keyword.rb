# Joseph Reidell & Mohit Jane
# Software Quality Assurance
# Bill Labooon

require_relative 'error'
require_relative 'expression'

# Keyword Class
class Keyword
  def initialize
    @err = Error.new
    @exp = Expression.new
  end

  def check_keyword(input)
    key = %w[LET PRINT]

    input.each do |line_num|
      return true if key.include?(line_num.upcase)
    end
    false
  end

  def run_let(input, line, file)
    if input[1].nil?
      puts "Line #{line}: Operator LET applied to an empty stack"
      return 0
    end
    @err.check_let(input, line, file)
  end

  def run_print(input, line)
    if input[1].nil?
      puts "Line #{line}: Operator PRINT applied to an empty stack"
      -2
    else
      2
    end
  end

  def run_quit(input)
    return true if input.empty?
    return false if input[0].casecmp('QUIT').zero?
    true
  end

  def run_keyword(input, line, file)
    if input[0].casecmp('LET').zero?
      run_let(input, line, file)
    elsif input[0].casecmp('PRINT').zero?
      run_print(input, line)
    else
      puts "Line #{line}: Could not evaluate expression"
      @err.error_code(5, line, nil, file)
      0
    end
  end

  def let(input, line, file)
    input.shift
    result = @exp.use_variable(input, line, file)
    puts result unless result.nil? || file || !result
  end

  def printer(input, line, file)
    input.shift
    @exp.print_stack(input, line, file)
  end

  def exp_result(input, line, file)
    value = @exp.stack_eval(input, line, file).to_s
    puts value unless value.empty? || file
  end

  def run_command(code, input, line, file)
    case code
    when 1
      let(input, line, file)
    when 2
      printer(input, line, file)
    when 3
      exp_result(input, line, file)
    when -4..-1
      exit code.abs if file
    end
  end

  def command_type(input, line, file)
    if check_keyword(input)
      run_keyword(input, line, file)
    elsif @exp.var_check(input)
      @exp.which_variable(input, line)
    elsif @exp.int_check(input[0])
      3
    else
      puts "Line #{line}: unknown keyword #{input[0]}"
      -4
    end
  end
end
