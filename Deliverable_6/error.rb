# Joseph Reidell & Mohit Jain
# Software Quality Assurance
# Bill Laboon

# Error Class
class Error
  def check_input(line)
    puts "Line #{line}: Could not evaluate expression"
  end

  def error_code(num, line, var, file)
    case num
    when 1
      puts "Line #{line}: Variable #{var} has not been initialized"
    when 3
      puts "Line #{line}: #{var} elements in stack after evaluation"
    end
    exit num if file
    nil
  end

  def check_let(input, line, file)
    var = input[1].ord
    if ((var > 64) & (var < 91)) || ((var > 96) & (var < 123))
      1
    else
      puts "Line #{line}: No variable specified"
      error_code(5, line, nil, file)
      0
    end
  end

  def stack_error(result, file, line)
    return nil if result == false
    if result.nil?
      puts 'Could not evaluate expression'
      nil
    elsif result.length > 1
      error_code(3, line, result.length, file)
      nil
    else
      result[0]
    end
  end
end
