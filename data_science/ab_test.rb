require 'json'
require 'abanalyzer'

class ABTest
  attr_reader :json_data
  attr_reader :cohort
  attr_reader :sample_size
  attr_reader :conversion
  attr_reader :error

  def initialize(json_file, cohort='cohort', result='result')
    file = File.new(json_file)
    @json_data = JSON.parse(file.read)
    @cohort_wording = cohort
    @result_wording = result
  end

end