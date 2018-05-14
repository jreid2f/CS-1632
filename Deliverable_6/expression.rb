# Joseph Reidell & Mohit Jain
# Software Quality Assurance
# Bill Laboon

require_relative 'keyword'

# Expression Class
class Expression
  def initialize
    @err = Error.new
    @user_input = []
  end

  # This returns an integer, otherwise it returns nothing
  def int_check(num)
    num.to_i.to_s == num
  end

  # This method limits the amount of variables referenced from the input
  def var_limit(var)
    @user_input[var.upcase.ord - 65]
  end

  # This returns the alphabetical characters used in the input
  def alpha_var(var)
    input = []
    var.each do |token|
      input.push(token) if var_check([token])
    end
    input
  end

  # This checks if the input entered is a certain alphabetical character
  def var_check(var)
    upper = ('A'..'Z').to_a
    lower = ('a'..'z').to_a
    return true if (var & upper).any? || (var & lower).any?
  end

  def stack_eval(input, line, file)
    eval = []
    input.each do |token|
      eval = load_stack(token, eval, line, file) unless eval.nil? || !eval
    end
    @err.stack_error(eval, file, line)
  end

  def stack_exp(token, stack, line, file)
    result = var_limit(token)
    if var_limit(token).nil?
      @err.error_code(1, line, token, file)
      return false
    else
      stack.push(result)
    end
  end

  def load_stack(token, stack, line, file)
    arr = token.upcase.ord
    if int_check(token)
      stack.push(token)
    elsif (arr > 64) & (arr < 91) & var_check([token])
      stack_exp(token, stack, line, file)
    else
      run_opt(token, stack, line, file)
    end
  end

  def use_variable(input, line, file)
    arr = input[0].upcase.ord
    return @err.check_input(line) unless var_check([input[0]])
    if input[1].nil?
      puts "Line #{line}: operator LET applied to empty stack"
      @err.error_code(2, line, nil, file)
    else
      input.shift
      value = stack_eval(input, line, file)
      @user_input[arr - 65] = value unless value.nil?
    end
  end

  def opt_check(opt, stack, line, file, arr)
    a1 = arr[0]
    a2 = arr[1]
    unless ['+', '-', '*', '/'].include?(opt) && !(opt == '/' && a2.to_i.zero?)
      puts "Line #{line}: Could not evaluate expression"
      @err.error_code(5, line, nil, file)
      return false
    end
    stack.push(a1.to_i.send(opt.to_sym, a2.to_i))
  end

  def run_opt(token, stack, line, file)
    arr2 = stack.pop
    arr1 = stack.pop
    if arr1.nil? || arr2.nil?
      puts "Line #{line}: Operator #{token} applied to an empty stack"
      @err.error_code(2, line, nil, file)
      return false
    end
    arr = [arr1, arr2]
    opt_check(token, stack, line, file, arr)
  end

  def print_stack(input, line, file)
    exp = stack_eval(input, line, file)
    puts exp.to_s unless exp.nil?
  end

  def which_variable(input, line)
    var = alpha_var(input)
    var.each do |vary|
      if var_limit(vary).nil?
        puts "Line #{line}: Variable #{vary} is not initialized"
        return -1
      end
    end
    3
  end
end
