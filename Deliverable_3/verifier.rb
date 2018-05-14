# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

require 'flamegraph'

require_relative 'file_checker'
require_relative 'blockchain'

# These are the main variables used throughout the program 
@final_total = Hash.new
@num = 0
@prev_line = ""
@file_check = CheckFile::new

newFile = @file_check.one_file(ARGV.count)

# This checks if the file that is entered is actually valid
if (newFile == -1)
    puts "Enter in a valid file that actually exists"
    exit
end

# File entered in from the command line is set as this variable
file = ARGV[0]

newFile = @file_check.exist_file(file)

# This checks if the file that is entered actually exists
if (newFile == -1)
    puts "Sorry, this file does not exist"
    exit
end

# This checks if the block that is entered has the correct format for each line
def check_line(block, line)
    chain_line = line.split("|")

    chain = block.getSeq
	chain_transaction = chain.split(":")

    # This checks if the correct amount of arguments on a line is at 5
    if (chain_line.length != 5)
        puts "Line #{@num}: Line #{@num} has #{chain_line.length} arguments instead of 5!"
        return -1
    end

    # This checks if the blocks are in the correct order
    if block.getNum() != @num.to_s
		puts "Line #{@num}: The block #{@num} is block number #{block.getNum()}."
        return -1
	end
    
    # This checks each transaction and splits them up 
    # If the sender or reciever is not correct, it will come back invalid
	chain_transaction.each{ |billcoin|
		send = billcoin.split(">")[0]
		recieve = billcoin.split(">")[1].split("(")[0]
        
        # This checks if the sender is formatted correctly
		if (/^[A-z]{1,6}$/ =~ send) == nil
			puts "Line #{@num}: The sender '#{send}' on line #{@num} is invalid."
            return -1
        # This checks if the reciever is formatted correctly
		elsif (/^[A-z]{1,6}$/ =~ recieve) == nil
			puts "Line #{@num}: The recipient '#{recieve}' on line #{@num} is invalid."            
            return -1
		end
	}

    # This checks if the block is entered incorrectly with invalid characters
    if (chain =~ /^(([A-z]{1,6}>[A-z]{1,6}\([0-9]+\))(:[A-z]{1,6}>[A-z]{1,6}\([0-9]+\))*(:SYSTEM>[A-z]{1,6}\([0-9]+\))$)|(^SYSTEM>[A-z]{1,6}\([0-9]+\))$/) == nil
        puts "Line #{@num}: Block #{num} is bad. Might be invalid characters."
        return -1;
    end

    # This checks if the current hash is formatted correctly
	if (block.getCurr() =~ /^([0-9]|[a-f]){1,4}$/) == nil
		puts "Line #{@num}: The current block: #{block.getCurr()} on line #{@num} is bad."
        return -1
    end
    
	# This checks if the previous hash is formatted correctly
	if (block.getPrev() =~ /^([0-9]|[a-f]){1,4}$/) == nil
		puts "Line #{@num}: The previous block: #{block.getPrev()} on line #{@num} is bad."
        return -1
	end
    
    # This checks if a block that contains one transaction is formatted correctly
	if @num == 0
        if (chain =~ /^SYSTEM>[A-z]{1,6}\([0-9]+\)$/) == nil
            puts "Line #{@num}: The first block does not contain exactly one transaction."
            return -1
        end
    end
    
    # This checks if the timestamp is formatted correctly
	if (block.getTime() =~ /^[0-9]+.[0-9]+$/) == nil
        puts "Line #{@num}: The timestamp #{block.getTime()} is invalid."
        return -1
    end
	
    return 1 
end

# This checks if either the current or previous hash is valid 
def check_hash block
    if @num != 0
        if @prev_line.split("|")[4].split("\n")[0] != block.getPrev()
            puts "Line #{@num}: Previous hash was #{block.getPrev()}, should be #{block.getCurr()}"
            return -1
        end
    else
        if block.getPrev() != "0"
            puts "Line #{@num}: Previous hash in the first block does not equal to 0"
            return -1
        end
    end

    if block.check_curr() == 1
        return 1
    end

    puts "Line #{@num}: The hash does not match the previous. #{block.getHash()} != #{block.getCurr()}"
    return -1
end

# This checks the timestamp on each line and checks if they are valid
def check_time block
    if @prev_line == ""
        return 1
    end

    oldStamp = @prev_line.split("|")[3]
    newStamp = block.getTime()

    if newStamp.split(".")[0].to_i == oldStamp.split(".")[0].to_i
        if newStamp.split(".")[1].to_i > oldStamp.split(".")[1].to_i
            return 1
        end
    end

    if newStamp.split(".")[0].to_i > oldStamp.split(".")[0].to_i
        return 1
    end

    puts "Line #{@num}: Previous timestamp #{oldStamp} >= new timestamp #{newStamp}"
    return -1
end

# This checks if the balance after a transaction is correct or not
# If not, it will display the name and amount of billcoins 
def check_balance block
    chain = block.getSeq
	chain_transaction = chain.split(":")
	
	chain_transaction.each{ |billcoin|
		send = billcoin.split(">")[0]
		recieve = billcoin.split(">")[1].split("(")[0]
		chain_total = billcoin.split(">")[1].split("(")[1].split(")")[0].to_i
        
        if @final_total[recieve] == nil
            @final_total[recieve] = chain_total
        else
            @final_total[recieve] += chain_total
        end

        unless send == "SYSTEM"
            if @final_total[send] == nil
                @final_total[send] = chain_total * -1
            else
                @final_total[send] -= chain_total  
            end
        end
    }
    
    @final_total.each{ |coin_total|
        if coin_total[1] < 0
            puts "Line #{@num}: After block #{@num} #{coin_total[0]} has #{coin_total[1]} billcoins"
            return -1
        end
    }

    return 1
end

# This runs the verifier program
# This generates the html page for the flame graph on each run
Flamegraph.generate('verifier.html') do
    lines = []
    lines = File.readlines(file)

    # Loop variable
    i = 0

    # This checks the number of blocks and creates block objects as an array
    block_count = lines.count
    array = []

    while i < block_count do

        # This splits the line up and enters it as a new blockchain
        array = lines[i].split('|')
        curr_line = Blockchain.new(array[0], array[1], array[2], array[3], array[4])

        # These all check if the blocks that are entered have an error 
        if check_line(curr_line, lines[i]) == -1
            puts "BLOCKCHAIN INVALID"
            exit
        elsif check_hash(curr_line) == -1
            puts "BLOCKCHAIN INVALID"
            exit
        elsif check_time(curr_line) == -1
            puts "BLOCKCHAIN INVALID"
            exit
        elsif check_balance(curr_line) == -1
            puts "BLOCKCHAIN INVALID"
            exit
        end

        # Update the previous line to the current line if the blocks are valid
        @prev_line = lines[i]
        @num += 1
        i += 1
    end

    # This displays the name and total amount of billcoins
    @final_total.each{|coin_total|
        puts "#{coin_total[0]} : #{coin_total[1]} billcoins"
    }

end