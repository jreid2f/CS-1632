# Joseph Reidell
# Software Quality Assurance
# Bill Laboon

require_relative 'driver'

raise 'Enter in only one seed' if ARGV.length != 1
num = Random.new(ARGV[0].to_i)
(1..5).each do |x|
  trip = Driver.new(num, x)
  trip.drive_path
end
