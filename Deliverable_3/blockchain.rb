# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

require_relative 'transactions.rb'
require_relative 'hash_address.rb'

# Constructor Method
class Blockchain
    def initialize(num, prev, seq, time, curr)
        @block_num = num
        @prev_hash = prev
        @trans_seq = seq
        @trans_arr = check_trans
        @timestamp = time
        @curr_hash = curr
        @line_hash = read_hash

    end

    #Setter Methods
    def setNum(num)
        @block_num = num
    end

    def setPrev(prev)
        @prev_hash = prev
    end

    def  setSeq(seq)
        @trans_seq = seq
    end

    def setTime(time)
        @timestamp = time
    end

    def setCurr(curr)
        @curr_hash = curr
    end

    def setHash(hash)
        @line_hash = hash
    end

    #Getter Methods
    def getNum
        return @block_num
    end

    def getPrev
        return @prev_hash
    end

    def getSeq
        return @trans_seq
    end

    def getTransArray
        return @trans_arr
    end

    def getTime
        return @timestamp
    end

    def getCurr
        return @curr_hash
    end

    def getHash
        return @line_hash
    end

    def getAddress
        return @address
    end

    def getFinal
        return @final
    end

    # A hash is created based off the first four methods
    def read_hash
        line = Array.new
        line_sum = 0
        modulo = 0
        string_to_hash = "#{@block_num}|#{@prev_hash}|#{@trans_seq}|#{@timestamp}"
        line = (string_to_hash.unpack('U*'))
        line.map! do
            |x| (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
        end
        line_sum = line.inject(0){|x,y| x + y}
        modulo = line_sum % 65536
        @line_hash = modulo.to_s(16)

        return @line_hash
    end

    # This splits up individual transactions
    def check_trans
        @trans_seq.split(/\W+/)
    end

    # Organize the objects and store them in a new array
    def finalTrans
        @final = Array.new
        @address = Array.new

        # Loop variables 
        i = 0
        j = 0

        until i > trans_arr.count
            @final[i] = transactions.new(@trans_arr[i], @trans_arr[i + 1], @trans_arr[i + 2])
            @address[j] = hash_address.new(@trans_arr[i].strip)
            @address[j + 1] = hash_address.new(@trans_arr[i + 1].strip)
            
            # increments the variables
            i += 3
            j += 2
        end
    end

    # Checks if the block is valid
    # Used mainly for unit testing
    def is_valid
        if check_curr == 0
            puts "Block is not valid"
            return 0
        else
            puts "Block is valid"
            return 1
        end    
    end

    # Checks the current hash to the calculated hash
    def check_curr
        if @curr_hash.strip.eql? @line_hash.strip
            return 1
        else
            return 0
        end
    end

    # Calculate the amount of transactions in an array
    # Used for mainly unit testing
    def trans_count
        return (@trans_arr.count / 3)
    end
end