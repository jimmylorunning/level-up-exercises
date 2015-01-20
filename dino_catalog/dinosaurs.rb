# example usage: 
#  d = Dinosaur.new('one.csv', 'two.csv')
#  d.read_from_file('three.csv')
#  d.find_bipeds
#  d.find_carnivores
#  d.find_period('jurassic')
#  d.find_big
#  d.find_period('jurassic').find_carnivores.find_bipeds 
#  d.print
#  d.find_big.print

require 'debugger'

class Dinosaurs

include Enumerable

BIG = 4000 # pounds

attr_accessor :keys
attr_accessor :dinosaurs

def initialize(*files)
  @dinosaurs = Array.new
  files.each do |file|
    self.read_from_file(file) 
  end
end

def each(&block)
  @dinosaurs.each do |dinosaur|
    block.call(dinosaur)
  end
end

def read_from_file(file)
  lines = File.open(file).readlines
  keys = lines[0].split(',')
  lines[1..-1].each do |dinosaur|
    @dinosaurs << Dinosaur.new(keys.zip(dinosaur.split(',')))
  end
end

def read_from_array(array)
  @dinosaurs.concat(array)
end

def find(&block)
  new_dinos = Dinosaurs.new
  new_dinos.read_from_array(self.select(&block))
  new_dinos
end

def find_bipeds
  self.find { |dino| dino.walking =~ /Biped/i }
end

def find_carnivores
  self.find(&:carnivore?)
end

def find_period(p)
  self.find { |dino| dino.period.downcase.match(p.downcase) }
end

def find_big
  self.find { |dino| dino.weight_in_lbs.to_i > BIG }
end

def print
  self.each do |dinosaur|
    dinosaur.print
  end
end

  class Dinosaur

  ATTR_CHART = {
    'NAME' => 'name',
    'PERIOD' => 'period',
    'CONTINENT' => 'continent',
    'DIET' => 'diet',
    'WEIGHT_IN_LBS' => 'weight_in_lbs',
    'WALKING' => 'walking',
    'DESCRIPTION' => 'description',
    'GENUS' => 'name',
    'CARNIVORE' => 'carnivore',
    'WEIGHT' => 'weight_in_lbs'}

  attr_accessor :name
  attr_accessor :period
  attr_accessor :continent
  attr_accessor :diet
  attr_accessor :carnivore
  attr_accessor :weight_in_lbs
  attr_accessor :walking
  attr_accessor :description

  def initialize(dino)
    dino.each do |d|
      assign_attr(d[0], d[1])
    end
  end

  def assign_attr(attr, value)
    if ATTR_CHART[attr.upcase]
      self.send(ATTR_CHART[attr.upcase]+'=', value)
    end
  end

  def carnivore?
    return ((self.carnivore.downcase == 'yes') ? true : false)
  end

  def diet=(d)
    self.carnivore = (d =~ /Carnivore|Insectivore|Piscivore/i) ? 'Yes' : 'No'
    @diet = d
  end

  def print
    puts 'NAME: ' + self.name
    puts 'PERIOD: ' + self.period if !self.period.nil?
    puts 'CONTINENT: ' + self.continent if !self.continent.nil?
    puts 'DIET: ' + self.diet if !self.diet.nil?
    puts 'CARNIVORE?: ' + self.carnivore if !self.carnivore.nil?
    puts 'WEIGHT (LBS): ' + self.weight_in_lbs if !self.weight_in_lbs.nil?
    puts 'WALKING: ' + self.walking if !self.walking.nil?
    puts 'DESCRIPTION: ' + self.description if !self.description.nil?
    puts
  end

  end

end
