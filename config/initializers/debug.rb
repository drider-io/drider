trap(29) {
  list = Thread.list
  puts '-' * 90
  puts "Count: #{list.count}"
  list.each do |t|
    p t
    puts t.backtrace
    puts "#" * 90
  end
}
