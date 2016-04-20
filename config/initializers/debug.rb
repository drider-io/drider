trap(:PWR) {
  puts '-' * 90
  Thread.list.each do |t|
    p t
    puts t.backtrace
    puts "#" * 90
  end
}
