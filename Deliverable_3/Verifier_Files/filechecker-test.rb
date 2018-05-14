# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

require 'minitest/autorun'

require_relative 'file_checker.rb'

class FileCheckerTest < Minitest::Test

    @file_check = CheckFile::new


    # EDGE CASE
    # This test checks if more than 2 arguments is entered
    # This should display an error message
    def test_two_files
        assert_equal -1, @file_check.one_file(2)
    end

    # EDGE CASE
    # This test checks if only one argument is entered
    # This should run like normal
    def test_one_file
        assert_equal 1, @file_check.one_file(1)
    end
    
    # EDGE CASE
    # This test checks if less than 1 argument is entered
    # This should display an error message
    def test_no_files
        assert_equal -1, @file_check.one_file(0)
    end

    # This will test if the text file exists
    # This file should exist
    def test_file_exist
        assert_equal 1, @file_check.exist_file("sample.txt")
    end

    # This will test if the text file does not exist
    # This file should not exist
    def test_no_file_test
        assert_equal -1, @file_check.exist_file("650.txt")
    end
    
end