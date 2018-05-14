# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

class Hash_Address
    
    # Constructor Methods
    def initialize(address)
        @name = address.strip
    end

    def initialize(address, coin_total)
        @name = address
        @total = coin_total
    end

    #Setter Methods
    def setName(address)
        @name = address
    end

    def setTotal(coin_total)
        @total = coin_total
    end

    #Getter Methods
    def getName
        return name
    end

    def getTotal
        return total
    end

end