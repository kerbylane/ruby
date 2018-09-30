$:.unshift File.join(File.dirname(__FILE__))

require "MultiHash"

puts "work with MH 2"
hash = MultiHash.new(2,0)
hash.put("one","one-one",11)
hash.put("one","one-two",12)
hash.put("two","two-one",21)

puts "Now try get_all"
hash.get_all { |e| puts e.join(",") }

puts "work with MH 3"
hash = MultiHash.new(3,0)
hash.put("one","one-one","one-one-one",111)
hash.put("one","one-two","one-two-one",121)
hash.put("two","two-one","two-one-one",211)

puts "Check the size()"
if hash.size() != 3
  puts "the size should be 3, but got #{hash.size}"
end

puts "Now try get_all"
hash.get_all { |e| puts e.join(",") }

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

puts "delete something simple"
value = hash.delete("one", "one-one", "one-one-one")
if value != 111
  puts "ERROR: delete did not return inner value 111, got #{value}"
end

if hash.size != 2
  puts "ERROR: delete did not decrease the size?"
end

puts "delete another leaf causing higher levels to be cleared out"
value = hash.delete("one","one-two","one-two-one")
if value != 121
  puts "ERROR: delete did not return inner value 121, got #{value}"
end

puts "Here is the hash currently: #{hash.inspect}"

if hash.size != 1
  puts "ERROR: delete did not decrease the size? have #{hash.inspect}"
end

if hash.has_key?("one")
  puts "ERROR: prior delete did not clear out higher levels of the hash"
end

hash.delete("two", "two-one")
if hash.size != 0
  puts "ERROR: last delete should have cleared out the entire map, but get #{hash.size}"
end

if hash.get("one") != nil
  puts "ERROR: get creates empty inner hashes"
end

puts "done with all tests"
