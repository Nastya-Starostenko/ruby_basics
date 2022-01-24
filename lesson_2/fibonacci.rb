
arr = []
index = 0
while true
  arr.push(index < 2 ? index : arr[index-1] + arr[index-2])
  index += 1
  break if arr[index-1] + arr[index-2] > 100
end
