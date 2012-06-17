require 'unimidi'

class MidiParser
  
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