require_relative 'ab_test.rb'

RSpec.describe ABTest do
  context "initialize" do
    before do
      @ab = ABTest.new('data_export_test_1.json')
    end

    it "initializes json data" do
      json_data =
        [
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"A", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>1},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>0},
        {"date"=>"2014-03-20", "cohort"=>"B", "result"=>0},
        ]
      expect(@ab.json_data).to eq(json_data)
    end

    it "raises error if json data missing" do
      expect{ ABTest.new }.to raise_error(ArgumentError)
    end

    it "sets total sample size" do
      expect(@ab.sample_size).to eq(20)
    end

    it "sets number of conversions for each cohort" do
      expect(@ab.cohort[:A]).to eq({"1" => 1, "0" => 9})
      expect(@ab.cohort[:B]).to eq({"1" => 6, "0" => 4})
    end
  end

  it "calculates conversion rate with 95% confidence for each cohort" do
    @ab = ABTest.new('data_export_test_1.json')

    expect(@ab.conversion[:A]).to eq(10)  # 10% conversion rate
    expect(@ab.error[:A]).to eq(18.97)    # + or - 18.97%
    expect(@ab.conversion[:B]).to eq(60)  # 60% conversion rate
    expect(@ab.error[:B]).to eq(30.98)    # + or - 30.98%
  end

  it "calculates confidence level of result" do
    expect(@ab.confidence).to eq(98)      # 98% confidence
  end
end