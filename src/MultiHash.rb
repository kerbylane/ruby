class MultiHash
  
  @hash = nil
  @levels = nil
  
  def initialize(levels, default)
    @levels = levels
    if @levels < 2
      raise Exception.new("levels must be higher than 1")
    end
    puts "dev: init MH #{@levels}"
    if @levels == 2
      @hash = Hash.new { |h,k| h[k] = OneLevelHash.new(default) }
    else
      @hash = Hash.new { |h,k| h[k] = MultiHash.new(@levels-1,default) }
    end
  end
  
  # Returns value identified by keys supplied.  This is either a nil, single value, or submap,
  # depengind on whether the keys are in the MultiHash and whether or not the number of keys
  # matches the levels of it.
  def get(*keys)
    puts "in get #{@levels}"
    if keys.length > @levels
      raise ArgumentError.new("incorrect number of arguments (#{keys.length}) supplied, instance only has #{@levels} levels")
    end
    return keys.length == 1 ? @hash[keys[0]] : @hash[keys[0]].get(*keys[1..-1])
  end
  
  def put(*args)
    puts "dev: MH#{@levels}.put(#{args})"
    if args.length != @levels + 1
      raise ArgumentError.new("incorrect number of arguments (#{args.length}) supplied, #{@levels + 1} required")
    end
    @hash[args[0]].put(*args[1..-1])
  end
  
  def remove(keys)
    # remove any entries matching the keys
    # TODO: fill this in
  end
  
  def each
    puts "in MultiHash.each level #{@levels}"
    return @hash.each { |k,v| yield([k,v]) }
  end

  def get_all
    puts "in get_all #{@levels}"
    puts "we have keys of #{@hash.keys()}"
    resp = []
    @hash.each do |k,v|
      # puts "dev: process k=#{k}"
      for e in v.get_all
        array = [k].push(*e)
        resp << array
      end
    end
    return resp
  end
  
end

class OneLevelHash
  # Just a wrapper around a regular Hash which implements the methods of MultiHash.
  @hash = nil
  
  def initialize(default)
    # puts "dev: init OLH"
    @hash = Hash.new {default}
  end
  
  def get(key)
    # puts "dev OLH.get(#{key})"
    return @hash[key]
  end
  
  def put(*args)
    # puts "dev: OLH put[#{args[0]}] #{args[1]}"
    @hash[args[0]] = args[1]
    # puts "dev: after put OLH keys = #{@hash.keys()}"
  end
  
  def remove(key)
    @hash.delete(key)
  end
  
  def each
    # puts "in OneLevelHash.each"
    return @hash.each { |k,v| yield([k,v]) }
  end

  def get_all
    puts "dev: OLH get_all"
    puts "dev: we have keys of #{@hash.keys()}"
    resp = []
    @hash.each do |k,v|
      resp << [k,v]
    end
    puts "dev: returning #{resp.length} entries: #{resp}"
    return resp
  end
  
end 