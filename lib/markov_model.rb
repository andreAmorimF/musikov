class MarkovModel
  
  attr_reader :frequencies
  
  public
  
  def initialize(value_chain = [])
    @transitions = {}
    @frequencies = {}
    add_input(value_chain)
    compute_frequencies
  end
  
  def generate(initial_value, value_number)
    generated_sequence << initial_value
    selected_value = initial_value
    
    rnd = Random.new
    until generated_sequence.count == value_number do
      selected_value = pick_value(rnd.rand(0.1..1.0), selected_value)
      generated_sequence << selected_value
    end
    
    return generated_sequence
  end
  
  def add_input(value_chain = [])
    prev_value = nil
    
    value_chain.each { |value|
      add_value(prev_value, value)
      prev_value = value
    }
  end
  
  private
  
  def add_value(prev_value = nil, value) 
    @transitions[prev_value] ||= Hash.new{0}
    @transitions[prev_value][value] += 1
  end
  
  def pick_value(random_number, prev_value)
    succ_list = @frequencies[prev_value]
    freq_counter = 0.0
    
    succ_list.each { |succ_value, freq|
      freq_counter += freq
      return succ_value if freq_counter >= random_number
    }
  end
  
  def compute_frequencies
    @transitions.map { |value, transition_hash|
      sum = 0.0
      transition_hash.each { |succ_value, occurencies| 
        sum += occurencies
      }
      
      transition_hash.each { |succ_value, occurencies|
        @frequencies[value] ||= Hash.new{0}
        @frequencies[value][succ_value] = occurencies/sum 
      }
      
      @frequencies[value] = @frequencies[value].sort
    }
  end
  
end