class StringService
  # The built-in string.hash method is producing inconsistent results. I think it is factoring in the object.hash method, which
  # probably considers the memory address. Instead we reinvent the wheel and make our own hash method.
  def self.hash_string(hash_me)
    total = 0
    base = 31
    power = 0
    hash_me.bytes.each { |byte|
      total = total + (byte * base ^ power)
      power = power + 1
    }
    total
  end
  # The built-in string.capitalize will u_case the first character of a string and l_case every subsequent letter. We want
  # to only u_case the first letter and leave the rest as they are.
  def self.capitalize_first_char(capitalize_me)
    capitalize_me.slice(0, 1).capitalize + capitalize_me.slice(1..-1)
  end
end
