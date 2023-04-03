#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10
BASIC_SIZE_1FRAME = 2

class Frame
  def initialize(points, previous_frame = nil, pre_previous_frame = nil)
    @points = points
    @previous_frame = previous_frame
    @pre_previous_frame = pre_previous_frame
  end

  def score
    @points.sum + score_spare + score_strike
  end

  def score_spare
    if !@previous_frame.nil? && @previous_frame.spare?
      @points[0] # スペアなら1フレームの一投目だけを追加で加算
    else
      0
    end
  end

  def score_strike
    if !@previous_frame.nil? && @previous_frame.strike?
      sum = @points[0] # 前のフレームがストライクならまずは1フレームの一投目だけを追加で加算
      sum += @points[1] if @points.size >= BASIC_SIZE_1FRAME # ストライクまたは半フレーム（フレームの途中）以外なら2投目を追加で加算
      sum += @points[0] if !@pre_previous_frame.nil? && @pre_previous_frame.strike? # 前と2個前がストライクなら更に1投目を追加で加算
      sum
    else
      0
    end
  end

  def spare?
    @points.size == BASIC_SIZE_1FRAME && @points.sum == MAX_PIN
  end

  def strike?
    @points.size == BASIC_SIZE_1FRAME - 1 && @points[0] == MAX_PIN
  end
end

def pin_data2int(input)
  input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
end

def separate_frame(pins)
  all_frame = [] # 全フレームの倒したピンの数の配列（１フレームごとに入れ子の配列になっている）
  pins_1frame = [] # 1フレームの倒したピンの数の配列

  pins.each do |pin|
    pins_1frame << pin
    maxsize_1frame = all_frame.size >= MAX_FRAME - 1 ? BASIC_SIZE_1FRAME + 1 : BASIC_SIZE_1FRAME # 最後のフレームはBASIC_SIZE_1FRAME + 1投げられる

    if (pins_1frame[0] == 10 && all_frame.size < MAX_FRAME - 1) || pins_1frame.size >= maxsize_1frame
      all_frame << pins_1frame # MAX_FRAME - 1フレームまではストライク一個で1フレーム、それ以外はmaxsize_1frameになるまで今のフレームの点数はall_frameには追加されない
      pins_1frame = []
    end
  end

  all_frame << pins_1frame unless pins_1frame.empty? # 現在の投球がフレームの途中だった場合、半端な投球をall_frameに追加する
  all_frame
end

def calculate_score(all_pins)
  score = 0
  previous_frame = nil
  pre_previous_frame = nil

  separate_frame(all_pins).each do |pins|
    frame = Frame.new(pins, previous_frame, pre_previous_frame)
    score += frame.score
    pre_previous_frame = previous_frame
    previous_frame = frame
  end

  score
end

# ******** main *********
input = ARGV[0]

unless input.nil?
  input_array = pin_data2int(input)
  puts calculate_score(input_array)
end
