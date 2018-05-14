# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

require 'minitest/autorun'

require_relative 'verifier.rb'

class verifierTest < Minitest::Test

    # Tests whether or not the verifier splits transactions correctly
    # Uses a sample blockchain to check and split the array
    def test_split_trans
        # Sample blockchain
        chain = "Person1<Person2(360):Person3<Person4(930)"
        # Initialize new blockchain 
        block = Blockchain.new(0,0,chain, 1.5,"c77h")
        chain_array = block.getTransArray()
        # Assert the array to test whether it splits
        assert_equal(["Person1", "Person2", "360", "Person3", "Person4", "930"], chain_array)
    end

end