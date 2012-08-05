require 'midilib/sequence'
require 'midilib/consts'
require 'midilib/io/seqwriter'

module Musikov

# This class is responsible for interacting with MidiLib in order
# to write the output midi files.
class MidiWriter
  
  ####################
  public
  ####################
  
  # Initializes the parser using the output path parameter
  # * Parameter need to be a folder folder
  def initialize(output_path = ".")
    @path = output_path
  end
  
  # Writes the output midi file from the generated sequence hash
  def write(sequence_hash)
    # Create a new, empty sequence.
    seq = MIDI::Sequence.new()
    
    track = MIDI::Track.new(seq)
    seq.tracks << track
    track.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(120))
    track.events << MIDI::MetaEvent.new(MIDI::META_SEQ_NAME, 'Sequence Name')
    
    # Create a track to hold the notes. Add it to the sequence.
    sequence_hash.each { |instrument, midi_elements|
      track = MIDI::Track.new(seq)
      seq.tracks << track
    
      # Give the track a name and an instrument name (optional).
      track.name = instrument
      track.instrument = instrument
    
      # Add a volume controller event (optional).
      
      track.events << MIDI::Controller.new(0, MIDI::CC_VOLUME, 127)
      track.events << MIDI::ProgramChange.new(0, 1, 0)
      midi_elements.each { |midi_element|
        track.events << MIDI::NoteOn.new(0, midi_element.note ,127,0)
        track.events << MIDI::NoteOff.new(0, midi_element.note ,127, seq.note_to_delta(midi_element.duration))
      }
    }
    
    write_midi(seq)
  end
  
  ####################
  private
  ####################
  
  # Call the Midilib's parse routine to read information from a midi file
  def write_midi(seq)
    # Writing output file
    File.open("#{@path}/output.mid", 'wb') { | file | seq.write(file) }
  end
    
end

end