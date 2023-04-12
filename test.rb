a = [1, 2, 3, 4, 10, 6, 7, 10, 9, 0]
b = []

idx = 0
while idx < a.size
  if a[idx] == 10
    b << [a[idx]]
    idx += 1
  else
    b << a.slice(idx, 2)
    idx += 2
  end
end

puts b.inspect
# => [[1, 2], [3, 4], [10], [6, 7], [10], [9, 0]]
