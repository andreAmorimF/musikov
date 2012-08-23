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
    i = 0
    
    # Create a track to hold the notes. Add it to the sequence.
    sequence_hash.each { |instrument, midi_elements|
      track = MIDI::Track.new(seq)
      seq.tracks << track
      
      if (MIDI::GM_PATCH_NAMES.include?(instrument)) then
        program_change = MIDI::GM_PATCH_NAMES.index(instrument)
      else
        program_change = MIDI::GM_DRUM_NOTE_NAMES.index(instrument)
        i = 10 # set channel to 10 => percussion channel
      end
    
      # Give the track a name and an instrument name (optional).
      track.instrument = instrument
    
      # Add a volume controller event (optional).
      track.events << MIDI::Controller.new(i, MIDI::CC_VOLUME, 127)
      track.events << MIDI::ProgramChange.new(i, program_change, 0)
      midi_elements.each { |midi_element|
        track.events << MIDI::NoteOn.new(i, midi_element.note ,127,0)
        track.events << MIDI::NoteOff.new(i, midi_element.note ,127, seq.note_to_delta(midi_element.duration))
      }

      i += 1
      i += 1 if (i == 10)
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
