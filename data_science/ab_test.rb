require 'json'
require 'abanalyzer'

class ABTest
  attr_reader :json_data
  attr_reader :cohort
  attr_reader :sample_size
  attr_reader :conversion
  attr_reader :error

  def initialize(json_file, options = {}) # cohort='cohort', result='result')
    @options = {cohort: 'cohort', result: 'result'}.merge(options)
    file = File.new(json_file)
    @json_data = JSON.parse(file.read)
    @cohort = {}
    @conversion = {}
    @error = {}
    calculate
  end

  def calculate
    @sample_size = @json_data.count
    count_conversions
    calculate_conversions
  end

  def calculate_conversions
    cohorts.each do |cohort|
      @conversion[cohort.to_sym] = calculate_conversion(cohort) * 100
      @error[cohort.to_sym] = standard_error(cohort) * 2 * 100
    end
  end

  def standard_error(cohort)
    p = calculate_conversion(cohort)
    n = data_for_cohort(cohort).count.to_f
    Math.sqrt((p * (1 - p))/n)
  end

  def calculate_conversion(cohort)
    @cohort[cohort.to_sym]["1"].to_f / data_for_cohort(cohort).count.to_f
  end

  def count_conversions
    cohorts.each do |cohort|
      conversions = count_conversions_for(cohort)
      nonconversions = data_for_cohort(cohort).count - conversions
      @cohort[cohort.to_sym] = { "1" => conversions, "0" => nonconversions }
    end
  end

  def count_conversions_for(cohort)
    data_for_cohort(cohort).count do |row|
      row.has_key?(@options[:result]) && row[@options[:result]].to_i == 1
    end
  end

  def data_for_cohort(cohort)
    @json_data.select do |row|
      row[@options[:cohort]] == cohort
    end
  end

  def cohorts
    @json_data.map do |row|
      row[@options[:cohort]]
    end.uniq
  end

  def confidence
    tester = ABAnalyzer::ABTest.new @cohort
    score = tester.chisquare_score
    conf = 0
    if score >= 10.827
      conf = 99.9
    elsif score >= 6.635
      conf = 99
    elsif score >= 5.412
      conf = 98
    elsif score >= 3.841
      conf = 95
    else
      conf = 0
    end
    return conf
  end

end