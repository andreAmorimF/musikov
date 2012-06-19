
module Musikov
  
class MarkovBuilder
  
  def initialize
    @value_chain = []
  end
  
  def add_sequency(sequency)
    sequency.each { |track|
      track.each { |event|
        if MIDI::NoteEvent === event then
          event.print_decimal_numbers = true
          event.print_note_names = true
          
          @value_chain << MidiElement.new(event.note, event.velocity)
        end
      }
    }
  end
  
  def build
    return MarkovModel.new(@value_chain)
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
    "Note: #{@note.upcase} Tempo: #{@tempo} "
  end
  
end

end