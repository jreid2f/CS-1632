# Joseph Reidell & Mohit Jain
# Software Quality Assurance
# Bill Laboon

require_relative 'repl'

# Uses Repl class to run the RPN calculator
rpn = Repl.new
rpn.run_rpn(ARGV)
