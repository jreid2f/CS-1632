# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

class Transaction
    
    # Constructor Method
    def initialize(send, recieve, num)
        @send = send
        @recieve = recieve
        @num = num
    end

    #Setter Methods
    def setSender(send)
        @send = send
    end

    def setReciever(recieve)
        @recieve = recieve
    end

    def setNum(num)
        @num = num
    end

    #Getter Methods
    def getSender
        return @send
    end

    def getReciever
        return @recieve
    end

    def getNum
        return @num
    end

end