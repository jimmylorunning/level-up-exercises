=begin
     csv = CsvFile.new(file)
     csv.each do |key, value|
     @dinosaurs << Dinosaur.new([key,valu
=end

class CsvFile

  def initialize(file)
    @file = file
  end

end
