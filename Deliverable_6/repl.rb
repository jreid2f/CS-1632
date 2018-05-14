# Joseph Reidell & Mohit Jain
# Software Quality Assurance
# Bill Laboon

require_relative 'keyword'

# Repl Class
class Repl
  def initialize
    @key = Keyword.new
  end

  # Checks if a file that is read in, exists
  def check_file(file)
    begin
      file_read = File.open(file, 'r')
    rescue SystemCallError
      puts "#{file} does not exist"
      return false
    end
    file_read
  end

  # Iterates through each line in the file and runs the commands
  def use_file(file_arg, line)
    read = true
    file_arg.each do |file|
      f = check_file(file)
      exit 5 unless f
      f.each_line do |num|
        line += 1
        work_prompt(num, line, read)
      end
      f.close
    end
  end

  # If no file is read in, it will run the repl loop
  # Iterates each line after a command is written
  def no_file(num, run)
    read = false
    while run
      num += 1
      run = work_prompt(nil, num, read)
    end
  end

  # This method helps with displaying the prompt
  # Takes in the input from the user and returns an array
  # of the whitespace delimitered commands
  def run_prompt(line)
    if !line.nil?
      prompt = line
    else
      print '> '
      prompt = gets
    end
    prompt.split
  end

  # Uses functions to check if input is being read in or reading in a file
  # If an empty line is entered in, an empty line is returned
  # If the user types in quit, run_quit will terminate the program
  def work_prompt(line, num, file)
    input = run_prompt(line)
    return true if input[0].nil?

    run = @key.run_quit(input)
    unless run
      return run if line.nil?
      abort
    end
    code = @key.command_type(input, num, file)
    @key.run_command(code, input, num, file)
    run
  end

  # This runs the program using either a file or enter repl mode
  def run_rpn(args)
    run = true
    line = 0
    if !args.empty?
      use_file(args, line)
    else
      no_file(line, run)
    end
  end
end
