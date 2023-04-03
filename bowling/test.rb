#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling'

INPUT_SAMPLE_DATA = [
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5',
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X',
  '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4',
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0',
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8',
  'X,X,X,X,X,X,X,X,X,X,X,X'
].freeze

OUTPUT_SAMPLE_DATA = [139, 164, 107, 134, 144, 300].freeze

class TestFrameMethod < Minitest::Test
  def test_score
    frame = Frame.new([1, 0])
    assert_equal frame.score, 1
    frame = Frame.new([3])
    assert_equal frame.score, 3
  end

  def test_spare
    frame = Frame.new([3, 4])
    assert_equal false, frame.spare?
    frame = Frame.new([2, 8])
    assert_equal true, frame.spare?
    frame = Frame.new([10])
    assert_equal false, frame.spare?
    frame = Frame.new([0, 10])
    assert_equal true, frame.spare?
  end

  def test_strike
    frame = Frame.new([3, 4])
    assert_equal false, frame.strike?
    frame = Frame.new([2, 8])
    assert_equal false, frame.strike?
    frame = Frame.new([10])
    assert_equal true, frame.strike?
  end

  def test_score_spare
    previous_frame = Frame.new([1, 9])
    frame = Frame.new([3, 4], previous_frame)
    assert_equal 3, frame.score_spare
    previous_frame = Frame.new([0, 10])
    frame = Frame.new([1, 5], previous_frame)
    assert_equal 1, frame.score_spare
  end

  def test_score_strike
    previous_frame = Frame.new([10])
    frame = Frame.new([3, 4], previous_frame)
    assert_equal 7, frame.score_strike
  end
end

class TestSmallScoreCalculation < Minitest::Test
  def test_calc_normal_score
    all_pins = [1, 2, 3, 4]
    assert_equal 10, calculate_score(all_pins)
    all_pins = [1, 2, 3]
    assert_equal 6, calculate_score(all_pins)
  end

  def test_calc_spare_score
    all_pins = [1, 9, 3, 4]
    assert_equal 20, calculate_score(all_pins)
    all_pins = [1, 9, 3]
    assert_equal 16, calculate_score(all_pins)
    all_pins = [0, 10, 1]
    assert_equal 12, calculate_score(all_pins)
  end

  def test_calc_strike_score
    all_pins = [10, 3, 4]
    assert_equal 24, calculate_score(all_pins)
    all_pins = [10, 3]
    assert_equal 16, calculate_score(all_pins)
    all_pins = [10, 2, 3, 10, 2, 3]
    assert_equal 40, calculate_score(all_pins)
    all_pins = [10, 10, 10, 2, 3]
    assert_equal 35 + 20 + 12 + 5, calculate_score(all_pins)
    all_pins = [10, 10, 10, 2]
    assert_equal 32 + 20 + 12 + 2, calculate_score(all_pins)
  end

  def test_separate_frame
    all_pins = [1, 2, 3, 4]
    assert_equal [[1, 2], [3, 4]], separate_frame(all_pins)
    all_pins = [1, 2, 3]
    assert_equal [[1, 2], [3]], separate_frame(all_pins)
  end
end

class TestSampleCalculation < Minitest::Test
  def test_pin_data2int
    input_array = pin_data2int('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 6, 4, 5], input_array
  end

  def test_data1_scrore
    index = 0
    input_array = pin_data2int('6,3,9,0,0,3,8,2')
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2].sum, calculate_score(input_array)
    input_array = pin_data2int('6,3,9,0,0,3,8,2,7,3,X')
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10]].flatten.sum + 7 + 10, calculate_score(input_array)
    input_array = pin_data2int('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0')
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10], [9, 1], [8, 0]].flatten.sum + 7 + 10 + 10 + 8, calculate_score(input_array)
    input_array = pin_data2int('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X')
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10], [9, 1], [8, 0], [10]].flatten.sum + 7 + 10 + 10 + 8, calculate_score(input_array)
    input_array = pin_data2int('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
  end

  def test_data2_scrore
    index = 2
    input_array = pin_data2int('0,10,1,5,0,0,0,0')
    assert_equal [0, 10, 1, 5, 0, 0, 0, 0].sum + 1, calculate_score(input_array)
    input_array = pin_data2int('0,10,1,5,0,0,0,0,X,X,X,5')
    assert_equal [0, 10, 1, 5, 0, 0, 0, 0, 10, 10, 10, 5].sum + 1 + [10, 10].sum + [10, 5].sum + 5, calculate_score(input_array)
    input_array = pin_data2int('0,10,1,5,0,0,0,0,X,X,X,5,1')
    assert_equal [0, 10, 1, 5, 0, 0, 0, 0, 10, 10, 10, 5, 1].sum + 1 + [10, 10].sum + [10, 5].sum + [5, 1].sum, calculate_score(input_array)
    input_array = pin_data2int('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
  end

  def test_all_score
    index = 0
    input_array = pin_data2int(INPUT_SAMPLE_DATA[index])
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
    index = 1
    input_array = pin_data2int(INPUT_SAMPLE_DATA[index])
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
    index = 2
    input_array = pin_data2int(INPUT_SAMPLE_DATA[index])
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
    index = 3
    input_array = pin_data2int(INPUT_SAMPLE_DATA[index])
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
    index = 4
    input_array = pin_data2int(INPUT_SAMPLE_DATA[index])
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
    index = 5
    input_array = pin_data2int(INPUT_SAMPLE_DATA[index])
    assert_equal OUTPUT_SAMPLE_DATA[index], calculate_score(input_array)
  end
end
