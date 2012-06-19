require 'musikov/midi_parser.rb'
require 'musikov/markov_model.rb'

module Musikov

class MarkovRepository
  
  attr_accessor :models_by_instrument
  
  def initialize
    @models_by_instrument = {}
  end
  
  def import(path)
    parser = MidiParser.new(path)
    sequencies = parser.parse
    
    builder = MarkovBuilder.new()
    sequencies.each { |sequency|
      builder.add(sequency)
    }
    
    @models_by_instrument = builder.build
    puts @models_by_instrument
  end
  
end
  
class MarkovBuilder
  
  def initialize
    @value_chain = {}
  end
  
  def add(sequency)
    sequency.each { |track|
      @value_chain[track.instrument] ||= []
      
      track.each { |event|
        if MIDI::NoteEvent === event then
          event.print_decimal_numbers = true
          event.print_note_names = true
          
          @value_chain[track.instrument] << MidiElement.new(event.note, event.velocity)
        end
      }
    }
  end
  
  def build
    model_by_instrument = {}
    @value_chain.each{ |key, value|
      model_by_instrument[key] = MarkovModel.new(value)
    }
    
    return model_by_instrument
  end
  
end

class MidiElement
  
  attr_accessor :note, :tempo
  
  def initialize(note, tempo)
    @note = note
    @tempo = tempo
  end
  
  def ==(comparison_object)
    comparison_object.equal?(self) ||
      (comparison_object.instance_of?(self.class) && 
       @note == comparison_object.note &&
       @tempo == comparison_object.tempo)
  end
  
  def hash
    @note.hash ^ @tempo.hash
  end
  
  def to_s
    "Note: #{@note} Tempo: #{@tempo} "
  end
  
end

end