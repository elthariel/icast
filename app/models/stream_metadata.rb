#
# Here we override HashKey from redis object to allow AR delegation
#
class StreamMetadata < Redis::HashKey
  def method_missing(sym, *args)
    if sym.to_s =~ /^([a-z_-]+)=$/ and args.length == 1
      self[$1] = args.shift
    elsif sym.to_s =~ /^([a-z_-]+)$/
      self[sym]
    else
      raise NoMethodError
    end
  end
end
