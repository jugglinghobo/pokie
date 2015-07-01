class Hash
  def pretty
    JSON.pretty_generate self
  end
end

class Array
  def pretty
    JSON.pretty_generate self
  end
end

