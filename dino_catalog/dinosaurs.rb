# to do : write tests
# fix bug in from_period
# move csv stuff out into its own class

require 'debugger'
require 'json'

class Dinosaurs
  include Enumerable

  BIG = 4000 # pounds

  attr_accessor :dinosaurs

  def method_missing(meth, *args, &block)
    if meth.to_s =~ /^from_(.+)$/
      from_period(Regexp.last_match(1))
    else
      super
    end
  end

  def initialize(*files)
    @dinosaurs = []
    files.each do |file|
      read_from_file(file)
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
    self
  end

  def read_from_array(array)
    @dinosaurs.concat(array)
    self
  end

  def find(&block)
    Dinosaurs.new.read_from_array(select(&block))
  end

  def bipeds
    find { |dino| dino.walking =~ /Biped/i }
  end

  def carnivores
    find(&:carnivore?)
  end

  def from_period(p)
    find { |dino| dino.period.split.map(&:downcase).include? p.downcase }
  end

  def big
    find { |dino| dino.weight_in_lbs.to_i > BIG }
  end

  def print
    each do |dinosaur|
      dinosaur.print
      puts
    end
  end

  def where(conditions_hash)
    dinosaur = self
    conditions_hash.each do |key, cond|
      dinosaur = dinosaur.find { |dino| dino.send(key.to_s) == cond }
    end
    dinosaur
  end

  def json
    JSON.generate dinosaurs.map(&:to_hash)
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
      'WEIGHT' => 'weight_in_lbs' }

    PRINT_ORDER = [
      'Name',
      'Period',
      'Continent',
      'Diet',
      'Carnivore',
      'Weight in lbs',
      'Walking',
      'Description']

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

    def carnivore?
      (carnivore.downcase == 'yes') ? true : false
    end

    def print
      PRINT_ORDER.each do |field|
        value = send(to_variable(field))
        puts "#{field}: #{value}" unless value.nil? || value.empty?
      end
    end

    def to_hash
      hash = Hash.new { |h, key| h[key] = send(to_variable(key)) }
      PRINT_ORDER.each { |attr| hash[attr] }
      hash
    end

    private

    def assign_attr(attr, value)
      return unless ATTR_CHART[to_attr_key(attr)]
      send("#{ATTR_CHART[to_attr_key(attr)]}=", rm_trailing_newline(value))
    end

    def diet=(d)
      self.carnivore = (d =~ /Carnivore|Insectivore|Piscivore/i) ? 'Yes' : 'No'
      @diet = d
    end

    def to_variable(field)
      field.downcase.gsub(/\s/, '_')
    end

    def to_attr_key(attr)
      rm_trailing_newline(attr.upcase)
    end

    def rm_trailing_newline(attr)
      return attr[0..-2] if attr[-1] == "\n"
      attr
    end
  end
end
