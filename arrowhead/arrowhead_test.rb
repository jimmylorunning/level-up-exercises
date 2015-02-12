require 'minitest/autorun'
require_relative 'arrowhead.rb'

class TestArrowhead < Minitest::Unit::TestCase

	def test_northern_plains
		->{ Arrowhead.classify(:northern_plains, :bifurcated) }.must_output "You have a(n) 'Oxbow' arrowhead. Probably priceless.\n"
		->{ Arrowhead.classify(:northern_plains, :lanceolate) }.must_output "You have a(n) 'Humboldt Constricted Base' arrowhead. Probably priceless.\n"
		->{ Arrowhead.classify(:northern_plains, :stemmed) }.must_output "You have a(n) 'Archaic Stemmed' arrowhead. Probably priceless.\n"
		->{ Arrowhead.classify(:northern_plains, :notched) }.must_output "You have a(n) 'Besant' arrowhead. Probably priceless.\n"
	end

	def test_far_west
		->{ Arrowhead.classify(:far_west, :bifurcated) }.must_output "You have a(n) 'Cody' arrowhead. Probably priceless.\n"
		->{ Arrowhead.classify(:far_west, :lanceolate) }.must_output "You have a(n) 'Agate Basin' arrowhead. Probably priceless.\n"
		->{ Arrowhead.classify(:far_west, :stemmed) }.must_output "You have a(n) 'Archaic Stemmed' arrowhead. Probably priceless.\n"
		->{ Arrowhead.classify(:far_west, :notched) }.must_output "You have a(n) 'Archaic Side Notch' arrowhead. Probably priceless.\n"
	end

	def test_unknown_shape
		err = ->{ Arrowhead.classify(:northern_plains, :fancy) }.must_raise RuntimeError
		err.message.must_match /Unknown shape value\. Are you sure you know what you\'re talking about\?/
		err = ->{ Arrowhead.classify(:far_west, :lollypop) }.must_raise RuntimeError
		err.message.must_match /Unknown shape value\. Are you sure you know what you\'re talking about\?/
	end

	def test_unknown_region
		err = ->{ Arrowhead.classify(:asian_steppes, :bifurcated) }.must_raise RuntimeError
		err.message.must_match /Unknown region, please provide a valid region\./
	end

	def test_unknown_region_and_shape
		err = ->{ Arrowhead.classify(:midwest, :pear) }.must_raise RuntimeError
		err.message.must_match /Unknown region, please provide a valid region\./
	end

end
