class MurderMethodFactory
  def self.pick_murder_method(round)
    seed = round.flavor_text_seed
    MurderMethod.subclasses[StringService.hash_string(seed) % MurderMethod.subclasses.length].new
  end
  def self.find_murder_method(method_name)
    method = MurderMethod.subclasses.find { |method| method.name == method_name }
    if method
      method
    else
      nil
    end
  end
end
