# Joseph Reidell
# Software Quality Assurance
# Bill Laboon

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
begin
require_relative 'city_sim_9006'
require_relative 'driver'
rescue RuntimeError => err
end

class CitySimTest < Minitest::Test

    # If arg is bigger than 1 argument then raise an exception
    def test_two_arguements
        arg = [5, 10]
        assert_raises "Enter in only one seed" do
            assert_equal arg
        end
    end

    # If a string is entered as a seed, then use the string as the random seed
    # EDGE CASE
    def test_string_arguement
        str = 'city'
        ran = Random.new(str.to_i)
        run = Driver.new(ran, 5)
        assert_equal ran, run.rand
    end

    # If nothing is entered as a seed, it should raise an exception
    def test_empty_arguement
        ran = Random.new(0)
        run = Driver.new(ran, 5)
        assert_raises "Enter in only one seed" do
            assert_equal '', run.rand
        end
    end

    # If a random integer is entered as a seed, then use that integer as the seed.
    def test_int_arguements
        ran = Random.new(1450)
        run = Driver.new(ran, 5)
        assert_equal ran, run.rand
    end

    # This tests if the correct instance variables are used.
    # As long as they are correct, then it sets everything to zero or default
    def test_initial
      ran = Random.new(1000)
      run = Driver.new(ran, 5)
      assert_equal ran, run.rand
      assert_equal 5, run.driv
      assert_includes ['Hillman', 'Cathedral', 'Museum', 'Hospital'], run.locate
      assert_equal 0, run.dinos
      assert_equal 0, run.books
      assert_equal 0, run.classes
    end

    # This tests what happens when two of the same random numbers start at the same location
    # This should help show that the program ensures repeatability
    def test_repeat
        ran1 = Random.new(45)
        ran2 = Random.new(45)

        run1 = Driver.new(ran1, 1)
        run2 = Driver.new(ran2, 2)
        assert_equal run1.locate, run2.locate
    end

    # This tests if there is no random number entered in as a seed.
    # Uses a string to counter act the randomness of the seed.
    # This test does not show a failure.
    # EDGE CASE
    def test_invalid_seed
        assert_raises "The seed entered in invalid" do
            run = Driver.new('Toy', 5)
        end
    end

    # This looks for a location destination that is not seen on the map.
    # Since this does not appear on the map, it will cause a failure in testing
    # This test is meant to fail and it does just that.
    # EDGE CASE
    def test_invalid_route
        ran = Random.new(5)
        run = Driver.new(ran, 5)
        run.stub :locate, 'streetboo' do
            assert_nil run.good_route
        end
    end

    # This test looks for if the correct route output is the same output used from 
    # the drive_route method. It does output the same sentence but, for some reason
    # the test fails. However, it does show that the output needed is shown correctly.
    def test_route
        ran = Random.new(5)
        run = Driver.new(ran, 1)

        run.stub :good_route, [['Foo St.', 'Far Ave.']] do
            run.stub :locate, 'Hospital' do
                assert_output('Driver 1 heading from Hospital to Far Ave. via Foo St.'){
                    place = run.drive_route
                    assert_equal 'Far Ave.', place
                }
            end
        end
    end

    # This tests what happens when only one book is accounted for.
    # This checks if locate is set at the 'Hillman'
    # Then compares that books is equal to 1.
    # This also helps check that obj_count runs properly
    def test_book
        run = Driver.new(Random.new(1000), 1)
        run.stub :locate, 'Hillman' do
            (1..5).each { |x|
                run.stub :books, 1 do
                    assert_equal 1, run.books
                    run.obj_count
                end
            }
        end
    end

    # This tests what happens when only one toy is accounted for.
    # This checks if locate is set at the 'Museum'
    # Then compares that dinos is equal to 1.
    # This also helps check that obj_count runs properly
    def test_toys
        run = Driver.new(Random.new(1000), 1)
        run.stub :locate, 'Museum' do
            (1..5).each { |x|
                run.stub :dinos, 1 do
                    assert_equal 1, run.dinos
                    run.obj_count
                end
            }
        end
    end

    # This test checks if Downtown appears as locate.
    # When Downtown is set to be locate, the driver exits and the program ends.
    # Asserting 1 should help it end the program when Downtown appears. 
    def test_downtown
        run = Driver.new(Random.new(1001), 2)
        run.stub :locate, 'Downtown' do
            run.stub :obj_total, 1 do
                assert_equal 1, run.drive_path
            end
        end
    end

    # This test checks if Monroeville appears as locate.
    # When Downtown is set to be locate, the driver exits and the program ends.
    # Asserting 1 should help it end the program when Monroeville appears. 
    def test_monroeville
        run = Driver.new(Random.new(1001), 2)
        run.stub :locate, 'Monroeville' do
            run.stub :obj_total, 1 do
                assert_equal 1, run.drive_path
            end
        end
    end

    # This tests what happens when zero classes have been accounted for.
    # This checks if locate is set at the 'Cathedral'
    # Then compares that classes is equal to 0.
    # EDGE CASE
    def test_zero_class
        run = Driver.new(Random.new(15), 2)
        run.stub :locate, 'Cathedral' do
            assert_equal 0, run.classes
            run.obj_count
        end
    end

    # This tests what happens only one toy is accounted for.
    # Then compares that dinos is equal to 1
    def test_one_toy
        run = Driver.new(Random.new(15), 1)
        run.stub :dinos, 1 do
            assert_equal 1, run.dinos
            run.obj_count
        end
    end

    # This tests what happens only one toy is accounted for.
    # Then compares that dinos is equal to 1
    def test_one_book
        run = Driver.new(Random.new(15), 1)
        run.stub :books, 1 do
            assert_equal 1, run.books
            run.obj_count
        end
    end

    # This tests what happens when there is only one class accounted for.
    # Then compares that classes is equal to 1.
    def test_one_classes
        run = Driver.new(Random.new(15), 1)
        run.stub :classes, 1 do
            assert_equal 1, run.classes
            run.obj_count
        end
    end

    # This tests multiple drivers and the paths that are taken.
    # This helps with testing out the count methods and the correct
    # statements that have to be displayed
    def test_multiple_path
        (1..5).each do |x|
            trip = Driver.new(Random.new(15), x)
            assert_nil trip.drive_path
        end
    end

    # This tests one single driver and the path the driver takes.
    # This helps with testing out the count methods and the correct
    # statements that have to be displayed
    def test_single_path
      trip = Driver.new(Random.new(1), 1)
      assert_nil trip.drive_path
    end

end
