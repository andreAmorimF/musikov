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
  end
  
end
  
class MarkovBuilder
  
  def initialize
    @value_chain = {}
  end
  
  def add(sequency)
    quarter_note_length = sequency.note_to_delta('quarter')
    puts "Quarter : #{quarter_note_length}"
    
    sequency.each { |track|
      next if track.instrument.nil?
      
      events = []
      @value_chain[track.instrument] ||= events
      
      track.each { |event|
        if MIDI::NoteOnEvent === event then
          event.print_note_names = true
          event.off.print_note_names = true
          
          events << MidiElement.new(event.note_to_s, 0)
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
  
  attr_accessor :note, :duration
  
  def initialize(note, duration)
    @note = note
    @duration = duration
  end
  
  def ==(comparison_object)
    comparison_object.equal?(self) ||
      (comparison_object.instance_of?(self.class) && 
       @note == comparison_object.note &&
       @duration == comparison_object.duration)
  end
  
  def eql?(comparison_object)
    self.class.equal?(comparison_object.class) &&
      @note == comparison_object.note &&
      @duration == comparison_object.duration
  end
  
  def hash
    @note.hash ^ @duration.hash
  end
  
  def to_s
    "[Note: #{@note} Duration: #{@duration}]"
  end
  
end

end