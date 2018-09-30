class MultiHash
  
  @hash = nil
  @levels = nil
  
  def initialize(levels, default)
    @levels = levels
    raise Exception.new("levels must be higher than 1") if @levels < 2
    
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
    if keys.length > @levels
      raise ArgumentError.new(
        "incorrect number of arguments (#{keys.length}) supplied, instance only has #{@levels} levels")
    end
    return nil if not @hash.has_key? keys[0]
    keys.length == 1 ? @hash[keys[0]] : @hash[keys[0]].get(*keys[1..-1])
  end
  
  def put(*args)
    if args.length != @levels + 1
      raise ArgumentError.new("incorrect number of arguments (#{args.length}) supplied, #{@levels + 1} required")
    end
    @hash[args[0]].put(*args[1..-1])
  end
  
  def has_key?(*keys)
    return @hash.has_key? keys[0] if keys.length == 1
    
    has_key? keys[1..-1]
  end
  
  def delete(*keys)
    # remove any entries matching the keys
    # If the resulting subhash is empty remove it too.
    # TODO: fill this in
    if keys.length > @levels
      raise ArgumentError.new("too many keys supplied (#{args.length}), instance only has #{@levels} levels")
    end
    
    return @hash.delete(keys[0]) if keys.length == 1
      
    top_key = keys[0]
    inner = @hash[top_key]
    return if inner.nil?

    deleted = inner.delete(*keys[1..-1])
    @hash.delete(top_key) if inner.size == 0
    deleted
  end
  
  def size()
    total = 0
    @hash.values.each { |inner| total += inner.size }
    total
  end
  
  def each
    @hash.each { |k,v| yield([k,v]) }
  end

  # Returns an array with fully specified keys-value entries
  def get_all
    @hash.each do |k,v|
      v.get_all do |e|
        yield [k].push(*e)
      end
    end
  end
  
end

class OneLevelHash
  # Just a wrapper around a regular Hash which implements the methods of MultiHash.
  @hash = nil
  
  def initialize(default)
    @hash = Hash.new {default}
  end
  
  def get(key)
    @hash[key]
  end
  
  def put(*args)
    @hash[args[0]] = args[1]
  end
  
  def delete(key)
    @hash.delete(key)
  end
  
  def size()
    @hash.size()
  end
  
  def has_key?()
    @hash.has_key?
  end
  
  def each
    return @hash.each { |k,v| yield([k,v]) }
  end

  def get_all
    @hash.each do |k,v|
      yield [k,v]
    end
  end
  
end 