
module Musikov

# This class represents a generic markov chain. It holds
# a hash of frequencies of subsequent states, for each state.
class MarkovModel
  
  attr_reader :frequencies
  
  ###################
  public
  ###################
  
  # Initialize the hashes used to build the markov chain.
  # Passes the initial array of values to be included in the model.
  # * The "transitions" hash maps a state into another hash mapping the subsequent states to its number of subsequent occurrences
  # * The "frequencies" hash maps a state into another hash mapping the subsequent states to a frequency indicating the probability of subsequent occurrences.
  def initialize(value_chain = [])
    @transitions = {}
    @frequencies = {}
    add_input(value_chain)
  end
  
  # Generate a random sequence from a markov chain
  # * The initial_value is a state where the random chain must start
  # * The initial_value may be nil
  # * The value_number indicates the number of elements on the result random sequence
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
  
  # Passes the argument array of state values to be included in the model.
  def add_input(value_chain = [])
    prev_value = nil
    
    value_chain.each { |value|
      add_value(prev_value, value)
      prev_value = value
    }
    
    compute_frequencies
  end
  
  ###################
  private
  ###################
  
  # Add a state on the transitions hash
  def add_value(prev_value = nil, value) 
    @transitions[prev_value] ||= Hash.new{0}
    @transitions[prev_value][value] += 1
  end
  
  # Pick a value on the frequencies hash based on a random number and the previous state
  def pick_value(random_number, prev_value)
    succ_list = @frequencies[prev_value].sort
    freq_counter = 0.0
    
    succ_list.each { |succ_value, freq|
      freq_counter += freq
      return succ_value if freq_counter >= random_number
    }
  end
  
  # Compute the frequencies hash based on the transistions hash
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
    }
  end
  
  def to_s
    return @frequencies
  end
  
end

end