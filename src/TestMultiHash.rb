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
    puts "ERROR: incorrect value, #{value}, found, 211 expected"
end

puts "Get with only 2 keys"
inner_hash = hash.get("two","two-one")
puts "get this hash:"
inner_hash.each { |k,v| puts "#{k}\t=> #{v}"}
if inner_hash.get("two-one-one") != 211
  puts "ERROR: incorrect inner instance found, for value for key two-one-one was not 211"
end

begin
  hash.get("one", "two", "three", "four")
rescue ArgumentError
  puts "correctly identified that too many levels of keys were given"
end

puts "test the update method when all keys specified"
hash.update("two","two-one","two-one-one") do |keys,value|
  hash.put(*keys,value + 1)
end

value = hash.get("two","two-one","two-one-one")
puts "dev: got value #{value}"
if value != 212
  puts "ERROR: increment did not work"
end

puts "test update of a subhash"
hash.update("one") do |keys,value|
  hash.put(*keys, value + 1)
end

value = hash.get("one", "one-one", "one-one-one")
if value != 112
  puts "ERROR: increment didn't work, expected 112, got #{value}"
end

value = hash.get("one", "one-two", "one-two-one")
if value != 122
  puts "ERROR: increment didn't work, expected 122, got #{value}"
end

puts "done with all tests"
