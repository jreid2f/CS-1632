# Joseph Reidell   
# Software Quality Assurance
# Bill Laboon

class CheckFile

    # This checks if the command line has only one argument entered 
    def one_file args
        if args == 1
            return 1
        else
            return -1
        end
    end

    # This checks if the file entered in at the command line actually exists 
    def exist_file file
        if(File.exist?(file))
            return 1
        else
            return -1
        end
    end
    
end