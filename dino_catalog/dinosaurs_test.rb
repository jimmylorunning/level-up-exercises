require 'minitest/autorun'
require_relative 'dinosaurs.rb'

describe Dinosaurs do
  before do
    @d = Dinosaurs.new('one.csv', 'two.csv')
  end

  describe "dinosaurs" do
    it "returns the correct dinosaurs" do
      @d.dinosaurs.map(&:name).must_equal ["Albertosaurus", "Albertonykus", "Baryonyx", "Deinonychus", "Diplocaulus", "Megalosaurus", "Giganotosaurus", "Quetzalcoatlus", "Yangchuanosaurus", "Dracopelta", "Abrictosaurus", "Afrovenator", "Carcharodontosaurus", "Giraffatitan", "Paralititan", "Suchomimus", "Melanorosaurus"]
    end
  end
  
  describe "bipeds" do
    it "returns only the bipeds" do
      @d.bipeds.must_be_instance_of Dinosaurs
      @d.bipeds.dinosaurs.map(&:name).must_equal ["Albertosaurus", "Albertonykus", "Baryonyx", "Deinonychus", "Megalosaurus", "Giganotosaurus", "Yangchuanosaurus", "Abrictosaurus", "Afrovenator", "Carcharodontosaurus", "Suchomimus"]
    end
  end

  describe "carnivores" do
    it "returns only the carnivores" do
      carnies = @d.carnivores
      carnies.must_be_instance_of Dinosaurs
      carnies.dinosaurs.map(&:name).must_equal ["Albertosaurus", "Albertonykus", "Baryonyx", "Deinonychus", "Diplocaulus", "Megalosaurus", "Giganotosaurus", "Quetzalcoatlus", "Yangchuanosaurus", "Afrovenator", "Carcharodontosaurus", "Suchomimus"]
    end
  end

  describe "from_period" do
    it "returns only dinosaurs from that period" do
      @d.from_something.must_be_instance_of Dinosaurs
      @d.from_jurassic.dinosaurs.map(&:name).must_equal ['Megalosaurus', 'Dracopelta', 'Abrictosaurus', 'Afrovenator', 'Giraffatitan']
      @d.from_triassic.dinosaurs.map(&:name).must_equal ['Melanorosaurus']
      @d.from_assic.dinosaurs.must_equal []
    end

    it "handles missing period information" do
      d3 = Dinosaurs.new('three.csv')
      d3.from_jurassic.dinosaurs.map(&:name).must_equal [] 
    end
  end

  describe "big" do
    it "returns only dinosaurs that are big" do
      @d.big.must_be_instance_of Dinosaurs
      @d.big.dinosaurs.map(&:name).must_equal ['Baryonyx','Giganotosaurus','Yangchuanosaurus','Giraffatitan','Paralititan','Suchomimus']
    end
  end

  describe "where" do
    it "returns only dinosaurs that matches conditional" do
      quadrupeds = ['Diplocaulus', 'Quetzalcoatlus', 'Dracopelta', 'Giraffatitan', 'Paralititan', 'Melanorosaurus']
      north_america = %w(Albertosaurus Albertonykus Deinonychus Diplocaulus Quetzalcoatlus)
      both = quadrupeds & north_america
      @d.where(walking: 'Quadruped').must_be_instance_of Dinosaurs
      @d.where(walking: 'Quadruped').map(&:name).must_equal quadrupeds
      @d.where(continent: 'North America').map(&:name).must_equal north_america
      @d.where(walking: 'Quadruped', continent: 'North America').map(&:name).must_equal both
      @d.where(walking: 'Quadruped').where(continent: 'North America').map(&:name).must_equal both
    end
  end

  describe "chaining" do
    it "returns only dinosaurs that match chained methods" do
      carnivores = @d.carnivores.map(&:name)
      big = @d.big.map(&:name)
      bipeds = @d.bipeds.map(&:name)
      @d.big.carnivores.map(&:name).must_equal big & carnivores
      @d.big.bipeds.map(&:name).must_equal big & bipeds
      @d.bipeds.carnivores.map(&:name).must_equal bipeds & carnivores
      @d.big.bipeds.carnivores.map(&:name).must_equal bipeds & carnivores & big
      @d.big.bipeds.carnivores.must_be_instance_of Dinosaurs
    end
  end

  describe "find" do
    it "returns only dinosaurs based on any random condition" do
      extremest = @d.find { |dino| dino.description =~ /est/i }
      extremest.map(&:name).must_equal %w(Albertonykus Giganotosaurus Quetzalcoatlus)
      extremest.must_be_instance_of Dinosaurs
      @d.find { |dino| dino.name =~ /saurus/i && dino.weight_in_lbs.to_i < 4000 }.map(&:name).must_equal %w(Albertosaurus Megalosaurus Abrictosaurus Carcharodontosaurus Melanorosaurus)
    end
  end

  describe "json" do
    it "returns the correct json" do
      @d.big.json.must_equal "[{\"Name\":\"Baryonyx\",\"Period\":\"Early Cretaceous\",\"Continent\":\"Europe\",\"Diet\":\"Piscivore\",\"Carnivore\":\"Yes\",\"Weight in lbs\":\"6000\",\"Walking\":\"Biped\",\"Description\":\"One of the only known dinosaurs with a fish-only diet.\"},{\"Name\":\"Giganotosaurus\",\"Period\":\"Late Cretaceous\",\"Continent\":\"South America\",\"Diet\":\"Carnivore\",\"Carnivore\":\"Yes\",\"Weight in lbs\":\"30420\",\"Walking\":\"Biped\",\"Description\":\"Largest hunter and also the coolest ever.\"},{\"Name\":\"Yangchuanosaurus\",\"Period\":\"Oxfordian\",\"Continent\":\"Asia\",\"Diet\":\"Carnivore\",\"Carnivore\":\"Yes\",\"Weight in lbs\":\"7200\",\"Walking\":\"Biped\",\"Description\":\"\"},{\"Name\":\"Giraffatitan\",\"Period\":\"Jurassic\",\"Continent\":null,\"Diet\":null,\"Carnivore\":\"No\",\"Weight in lbs\":\"6600\",\"Walking\":\"Quadruped\",\"Description\":null},{\"Name\":\"Paralititan\",\"Period\":\"Cretaceous\",\"Continent\":null,\"Diet\":null,\"Carnivore\":\"No\",\"Weight in lbs\":\"120000\",\"Walking\":\"Quadruped\",\"Description\":null},{\"Name\":\"Suchomimus\",\"Period\":\"Cretaceous\",\"Continent\":null,\"Diet\":null,\"Carnivore\":\"Yes\",\"Weight in lbs\":\"10400\",\"Walking\":\"Biped\",\"Description\":null}]"
    end
  end

end
