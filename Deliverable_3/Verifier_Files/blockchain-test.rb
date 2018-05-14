# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

require 'minitest/autorun'

require_relative 'blockchain.rb'

class Block_Chain_Test < Minitest::Test
    # Tests whether or not the verifier splits transactions correctly
    # Uses a sample blockchain to check and split the array
    def test_split_trans
        # Sample blockchain
        chain = "Person1<Person2(360):Person3<Person4(930)"
        block = Blockchain.new(0,0,chain, 1.5,"ch77")
        chain_array = block.getTransArray()
        # Assert the array to test whether it splits
        assert_equal(["Person1", "Person2", "360", "Person3", "Person4", "930"], chain_array)
    end

    # This will test the value of the amount of transactions 
    # It is better to know that the number of transactions are correct or not
    def test_count
        chain = "Person1<Person2(360):Person3<Person4(930)"
        block = Blockchain.new(0,0,chain, 1.5,"ch77")
        
        assert_equal(2, block.trans_count())
    end

    # This will test whether two hash values that are set is equal
    # Since this does equal, it will return 1
    def test_equal_hash
        chain = "Person1<Person2(360):Person3<Person4(930)"
        block = Blockchain.new(0,0,chain, 1.5,"ch77")
        block.setHash("ch77")

        assert_equal(1, block.check_curr())
    end

    # This will test whether two hash values that are set is not equal
    # Since this does not equal, it will return 0
    def test_nonequal_hash
        chain = "Person1<Person2(360):Person3<Person4(930)"
        block = Blockchain.new(0,0,chain, 1.5,"ch77")
        block.setHash("m1p0")

        assert_equal(0, block.check_curr())
    end

    # This will test if the hash is calculated correctly
    def test_calc_hash
        chain = "SYSTEM>Kurt(50)"
        block = Blockchain.new("5", "5", chain, "1518892051.812065000", "ch78")
        hash_value = block.getHash
        calc = hash_value.strip.eql? "ch77"

        assert_equal calc, true
    end

    # This will test if the blockchain sampled is valid
    # This should be valid and return 1
    def test_valid_block
        chain = "SYSTEM>Kurt(50)"
        block = Blockchain.new("5", "5", chain, "1518892051.812065000", "ch77")

        assert_equal 1, block.is_valid
    end

    # This will test if the blockchain sampled is invalid
    # This should be invalid and return 0
    def test_invalid_block
        chain = "SYSTEM>Kurt(50)"
        block = Blockchain.new("5", "5", chain, "1518892051.812065000", "ch78")

        assert_equal 0, block.is_valid
    end

end