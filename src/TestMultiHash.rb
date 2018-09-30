$:.unshift File.join(File.dirname(__FILE__))

require "MultiHash"

puts "work with MH 2"
hash = MultiHash.new(2,0)
hash.put("one","one-one",11)
hash.put("one","one-two",12)
hash.put("two","two-one",21)

puts "Now try get_all"
for e in hash.get_all
  puts e.join(",")
end


puts "work with MH 3"
hash = MultiHash.new(3,0)
hash.put("one","one-one","one-one-one",111)
hash.put("one","one-two","one-two-one",121)
hash.put("two","two-one","two-one-one",211)

puts "Now try get_all"
for e in hash.get_all
  puts e.join(",")
end

puts "Now get with fully specified keys"
value = hash.get("two","two-one","two-one-one")
if value != 211
    puts "incorrect value, #{value}, found, 211 expected"
end

puts "Get with only 2 keys"
inner_hash = hash.get("two","two-one")
puts "get this hash:"
inner_hash.each { |k,v| puts "#{k}\t=> #{v}"}
if inner_hash.get("two-one-one") != 211
  puts "incorrect inner instance found, for value for key two-one-one was not 211"
end

begin
  hash.get("one", "two", "three", "four")
rescue ArgumentError
  puts "correctly identified that too many levels of keys were given"
end

puts "done with all tests"
