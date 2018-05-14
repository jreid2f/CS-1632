require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative 'error'
require_relative 'keyword'
require_relative 'expression'
require_relative 'repl'

class Group_tester< Minitest::Test
  def setup
    @err = Error.new
    @key = Keyword.new
    @expr = Expression.new
    @rep = Repl.new
  end

  #========================================================================================
  # Keyword.rb UNIT TESTS

  # This test checks if a letter has been entered into the prompt
  # If it has, then we return true.
  def test_check_keyword
    assert_equal true, @key.check_keyword(['LET', 'a', '3'])
    assert_equal false, @key.check_keyword(['4', '3', '+'])
  end

  # This test checks if when no keyword after LET is entered,
  # the test will print "Line 1: Operator LET applied to an empty stack"
  # and then return 0 to end the method.
  def test_run_let
    assert_equal 0, @key.run_let(['LET'], 1, nil)
  end

  # This test checks if there is a variable after PRINT, returns -2 if not
  def test_run_print
    assert_equal 2, @key.run_print(['PRINT', 'a'], 1)
    assert_equal -2, @key.run_print(['PRINT'], 1)
  end

  # This test checks that the method run_quit will
  # return false if quit is entered, else true for everything else.
  def test_run_quit
    assert_equal false, @key.run_quit(['quit'])
    assert_equal true, @key.run_quit([''])
    assert_equal true, @key.run_quit(['LET', 'a', '3'])
  end

  # This test will run keywords let, print, and some invalid keyword
  # to check if the correct return value is associated with each keyword
  def test_run_keyword
    assert_equal 0, @key.run_keyword(['LET', '5', '3', '+'], 1, nil)
    assert_equal 2, @key.run_keyword(['PRINT', 'a'], 1, nil)
    assert_equal 0, @key.run_keyword(['oh no', '4'], 1, nil)
  end

  # This test will test the input "LET" as a whole
  def test_let
    good_case = @expr.use_variable(['LET', 'a', '3'], 1, nil)
    bad_case = @expr.use_variable(['LET', 'a'], 1, nil)
    assert_equal good_case, @key.let(['LET', 'a', '3'], 1, nil)
    assert_equal bad_case, @key.let(['LET', 'a'], 1, nil)
  end

  # This is a small, probably unnecessary test for printer
  # Check test for print_stack
  def test_printer
    val = @expr.print_stack(['PRINT', 'a'], 1, nil)
    assert_equal val, @key.printer(['PRINT', 'a'], 1, nil)
  end

  # This test tests for a simple expression that does not include
  # the keywords LET, PRINT, QUIT
  def test_exp_result
    val = @expr.stack_eval(['4', '3', '+'], 5, nil).to_s
    bad_val = @expr.stack_eval(['4', '3'], 2, nil).to_s
    assert_output (/7/) { @key.exp_result(['4', '3', '+'], 5, nil) }
    assert_output (/Line 2: 2 elements in stack after evaluation/) { @key.exp_result(['4', '3'], 2, nil) }
  end

  # This test tests the three different types of ways that commands could be run
  # does not include the QUIT keyword
  def test_run_command
    assert_equal @key.let(['LET', 'a', '3'], 1, nil), @key.run_command(1, ['LET', 'a', '3'], 1, nil)
    assert_equal @key.printer(['PRINT', 'a', '3'], 1, nil), @key.run_command(2, ['PRINT', 'a', '3'], 1, nil)
    assert_equal @key.exp_result(['4', '3', '+'], 5, nil), @key.run_command(3, ['4', '3', '+'], 5, nil)
  end

  # tests that when a certain type of keyword was entered
  # the test should return the right value for it
  def test_command_type
    assert_equal @key.run_keyword(['LET', 'a', '3'], 1, nil), @key.command_type(['LET', 'a', '3'], 1, nil)
    assert_equal @expr.which_variable(['a', 'b', '3', '+'], 1), @key.command_type(['a', 'b', '3', '+'], 1, nil)
    assert_equal 3, @key.command_type(['4', '3', '+'], 1, nil)
    assert_equal -4, @key.command_type(['dajf;ldksaj'], 1, nil)
  end

  #========================================================================================

  # Error.rb UNIT TESTS

  # This test is combined with test_run_let in that in which if
  # there exists an argument, then we check what the method would
  # return if there is a letter as an argument. i.e. LET a
  # returns 0 if not.
  def test_err_check_let
    assert_equal 0, @err.check_let(['LET', '5', '3', '+'], 1, nil)
    assert_equal 1, @err.check_let(['LET', 'a'], 1, nil)
  end

  # Tests that line number is properly inserted
  def test_err_check_input
    assert_output (/Line 1: Could not evaluate expression/) {@err.check_input(1)}
  end

  # Tests that errors are properly displayed when called
  def test_err_error_code
    assert_output (/Line 1: Variable a has not been initialized/) { @err.error_code(1, 1, 'a', nil) }
    assert_output (/Line 1: a elements in stack after evaluation/) { @err.error_code(3,1,'a',nil) }
  end

  # Tests that if the result size is empty, > 1, or equal to 1,
  # the proepr output should be displayed
  def test_err_stack_error
    assert_nil @err.stack_error(false, nil, 2)
    assert_nil @err.stack_error([1, 2], nil, 2)
    assert_equal 1, @err.stack_error([1], nil, 2)
  end

  #========================================================================================

  # Repl.rb UNIT TESTS

  # If the file does not exist, then this test should return
  # false. Otherwise, it should read the file. This test assumes
  # the latter is true if the first condition is also true.
  def test_check_file
    assert_equal false, @rep.check_file("blah")
  end

  # Will return nil if no file is read in
  def test_no_file
    assert_nil @rep.no_file(1, false);
  end

  # tests that when the line ends, the "> " is displayed
  def test_run_prompt
    prompt = 'PRINT a'
    value = prompt.split
    assert_equal value, @rep.run_prompt('PRINT a')
  end

  # This test will return true for all values except if you
  # quit the program, so tested a lot of edge cases to make sure
  def test_work_prompt
    assert_equal true, @rep.work_prompt(' ', 1, nil)
    assert_equal true, @rep.work_prompt('dalkjflajdafljkajf;', 1, nil)
    assert_equal true, @rep.work_prompt('4 3 +', 1, nil)
    assert_equal true, @rep.work_prompt('LeT a 89994392492042340923042930492304923', 1, nil)
  end

  #========================================================================================

  # Expression.rb UNIT TESTS

  # test should return true if the expression is an integer
  # otherwise it should return false
  def test_int_check
    assert_equal true, @expr.int_check('33423094809238409238948230984023490830840923')
  end

  # This test checks that alpha_var will return an input array,
  # given a valid input array
  def test_alpha_var
    assert_equal ['A'], @expr.alpha_var(['A'])
  end

  # This test will return true if the input array contains a valid
  # character type. Anything else should return nil.
  def test_var_check
    assert_equal true, @expr.var_check(['A'])
    assert_equal nil, @expr.var_check(['ABCDEFG'])
  end

end
