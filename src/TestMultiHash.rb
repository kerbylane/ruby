$:.unshift File.join(File.dirname(__FILE__))

require "MultiHash"

class TestMultiHash
  def TestOneLevel
    hash = MultiHash.OneLevelHash.new(Integer)
    
    puts hash[0]
    
    hash[1] = "one"
    puts hash[1]
  end
end


#hash = OneLevelHash.new(0)
#
#puts hash.get(0)
#puts hash.get(1)
#
#hash.put([1,"one"])
#puts hash.get(1)
#
#puts hash
#
#hash.each do |k,v|
#  puts k.to_s + " " + v
#end

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

puts hash.get("two","two-one","two-one-two")
puts hash.get("two","two-two")


puts "done with all tests"
