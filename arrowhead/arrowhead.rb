class Arrowhead
  # This seriously belongs in a database.
  CLASSIFICATIONS = {
    far_west: {
      notched: "Archaic Side Notch",
      stemmed: "Archaic Stemmed",
      lanceolate: "Agate Basin",
      bifurcated: "Cody",
    },
    northern_plains: {
      notched: "Besant",
      stemmed: "Archaic Stemmed",
      lanceolate: "Humboldt Constricted Base",
      bifurcated: "Oxbow",
    },
  }

  def self.classify(region, shape)
    self.prevent_invalid_params(region, shape)
    shapes = self.shapes(region)
    arrowhead = shapes[shape]
    puts "You have a(n) '#{arrowhead}' arrowhead. Probably priceless."
  end

  def self.prevent_invalid_params(region, shape)
    raise "Unknown region, please provide a valid region." unless valid_region? region
    raise "Unknown shape value. Are you sure you know what you're talking about?" unless valid_shape?(region, shape)
  end

  def self.valid_region?(region)
    CLASSIFICATIONS.include? region
  end

  def self.valid_shape?(region, shape)
    shapes = self.shapes(region)
    shapes.include? shape
  end

  def self.shapes(region)
    CLASSIFICATIONS[region]
  end
end

