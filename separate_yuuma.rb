require 'debug'


# pins = [1,2,3,4,10,1]
# -> [[1,2], [3,4],[10],[1]]

# [[1]]
# [[1,2]]
# [[1,2],[3]]
# [[1,2],[3,4]]
# [[1,2],[3,4], [10]]
# [[1,2],[3,4], [10], [1]]

# 10フレーム目が3回投げる
# [1,2,3,4,...,10,1,2]
# -> [[1,2], [3,4], ..., [10, 1, 2]]

def seperate_frame(pins)
    pin_pairs = pins.inject([]) do |pairs, pin|
        # debugger
        p pin
        p pairs
        
        # ストライクまたは初回の投球だったら最後に要素を付け足す
        if pin == 10 || pairs.size == 0
            pairs.push([pin])
            next pairs
        end

        # 最後のスコアがストライク、または2回投げていたら新しいスコアとして追加する
        # 1回目のみのスコアだったら既存のスコアを更新する
        last_pair = pairs.pop || []
        if last_pair.size == 2 || last_pair[0] == 10
            pairs.push(last_pair, [pin])
            next pairs
        else
            new_pair = [last_pair[0], pin]
            pairs.push(new_pair)
            next pairs
        end
    end
end

p seperate_frame([1,2,3])

a = [1]
p a[0..1]
p a[0..1].sum
