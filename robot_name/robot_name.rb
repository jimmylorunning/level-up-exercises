class NameCollisionError < RuntimeError; end

class Robot
  attr_accessor :name
  COLLISION_ERR_MSG = 'There was a problem generating the robot name!'

  @@registry ||= []

  def initialize(args = {})
    @name_generator = args[:name_generator] || -> { default_name_generator }
    generate_name
    register_name
  end

  def generate_name
    @name = @name_generator.call
    raise NameCollisionError, COLLISION_ERR_MSG if name_collides?
  end

  private

  def default_name_generator
    "#{generate_character}#{generate_character}#{generate_number}" \
      "#{generate_number}#{generate_number}"
  end

  def name_collides?
    !(name =~ /[[:alpha:]]{2}[[:digit:]]{3}/) || @@registry.include?(name)
  end

  def register_name
    @@registry << @name
  end

  def generate_character
    ('A'..'Z').to_a.sample
  end

  def generate_number
    rand(10)
  end
end

robot = Robot.new
puts "My pet robot's name is #{robot.name}, but we usually call him sparky."
generator = -> { 'AA111' }
r2 = Robot.new(name_generator: generator)
puts "My pet robot's name is #{r2.name}, but we usually call him sparky."
# expect error:
r3 = Robot.new(name_generator: generator)
puts "My pet robot's name is #{r3.name}, but we usually call him sparky."
