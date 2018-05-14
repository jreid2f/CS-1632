# Joseph Reidell
# Software Quality Assurance
# Bill Laboon

# Driver class
class Driver
  attr_reader :rand, :driv, :locate, :books, :dinos, :classes

  def initialize(seed, num)
    @start_path = %w[Hillman Cathedral Museum Hospital]
    @street_path =
      {
        'Hillman' => [['Fifth Ave.', 'Downtown'], ['Foo St.', 'Hospital']],
        'Cathedral' => [['Fourth Ave.', 'Monroeville'], ['Bar St.', 'Museum']],
        'Museum' => [['Bar St.', 'Cathedral'], ['Fifth Ave', 'Hillman']],
        'Hospital' => [['Foo St.', 'Hillman'], ['Fourth Ave.', 'Cathedral']]
      }
    @end_path = %w[Downtown Monroeville]
    raise 'Seed entered is invalid' unless seed.is_a? Random
    @rand = seed
    @driv = num
    @locate = @start_path.sample(random: @rand)
    @dinos = 0
    @books = 0
    @classes = 0
  end

  def drive_route
    route = good_route
    path = route.sample(random: @rand)
    puts "Driver #{@driv} heading from #{@locate} to #{path[1]} via #{path[0]}"
    path[1]
  end

  def count_dinos
    return @dinos += 1 if @locate == 'Museum'
  end

  def count_books
    return @books += 1 if @locate == 'Hillman'
  end

  def count_classes
    return @classes = 1 if @locate == 'Cathedral' && @classes.zero?
    @classes *= 2
  end

  def obj_count
    count_dinos
    count_books
    count_classes
  end

  def total_dinos
    if @dinos == 1
      puts "Driver #{@driv} obtained #{@dinos} dinosaur toy!"
    else
      puts "Driver #{@driv} obtained #{@dinos} dinosaur toys!"
    end
  end

  def total_books
    if @books == 1
      puts "Driver #{@driv} obtained #{@books} book!"
    else
      puts "Driver #{@driv} obtained #{@books} books!"
    end
  end

  def total_classes
    if @classes == 1
      puts "Driver #{@driv} attended #{@classes} class!"
    else
      puts "Driver #{@driv} attended #{@classes} classes!"
    end
  end

  def obj_total
    total_dinos
    total_books
    total_classes
  end

  def good_route
    @street_path[@locate]
  end

  def drive_path
    until @end_path.include? @locate
      obj_count
      @locate = drive_route
    end
    obj_total
  end
end
