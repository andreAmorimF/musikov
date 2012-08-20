require 'musikov/midi_parser.rb'
require 'musikov/midi_writer.rb'
require 'musikov/markov_model.rb'

module Musikov


# This class holds the markov chains of each
# instrument built from the selected midi files.
class MarkovRepository
  
  attr_accessor :models_by_instrument
  
  # Initialize the map of markov chain by instrument
  def initialize
    @models_by_instrument = {}
  end
  
  # Call parser over indicated paths and trigger the 
  # markov chain building process.
  # * the paths can be either folders or files
  # * the file indicated by the path must exist!
  def import(paths = [])
    parser = MidiParser.new(paths)
    sequencies = parser.parse
    
    builder = MarkovBuilder.new()
    sequencies.each { |sequency|
      builder.add(sequency)
    }
    
    @models_by_instrument = builder.build
  end
  
  # Export the generated chains
  def export(sequence_hash = {}, path = ".")
    writer = MidiWriter.new(path)
    writer.write(sequence_hash)
  end
  
end

# This class is responsible for building the markov
# chain map from midi sequences. For every sequence,
# a "quarter" duration will be extracted and every note
# duration will be mapped in the possible values on the
# duration table. From a note and a specifc duration,
# MidiElements will be created representing a state on the
# markov chain. 
class MarkovBuilder
  
  ####################
  public
  ####################
  
  # Initialize the hashes used to build the markov chain of note elements.
  # * The value_chain is a hash containing a list of note events by instrument.
  # * The duration table is a dynamic generated hash (generated from the "quarter" duration value) that maps
  # a the duration of the notes to a string representation.
  def initialize
    @value_chain = Hash.new
    @duration_table = Hash.new("unknow")
  end
  
  # Add a midi sequence to the model. From each sequence,
  # different tracks (instruments) will be analyzed. Each
  # sequence has a "tempo" that defines the "quarter" duration in ticks.
  # From the "quarter" duration, creates a duration table containg (almost)
  # every possible note duration.
  # Creates markov chain elements by the value of the played note and the
  # duration string mapped from the duration table.
  def add(sequence)
    # Obtains a quarter duration for this sequence
    quarter_note_length = sequence.note_to_delta('quarter')
    
    # Create the duration table based on the sequence's "quarter" value
    create_duration_table(quarter_note_length)
    
    # For each instrument on the sequence...
    sequence.each { |track|
      # Program change of the current track
      program_change = nil

      # Create a list of midi elements for an instrument
      elements = []

      # Iterates the track event list...
      track.each { |event|
        
        # Consider only "NoteOn" events since they represent the start of a note event (avoid duplication with "NoteOff").
        if event.kind_of?(MIDI::NoteOnEvent) then
          # From its correspondent "NoteOff" element, extract the duration of the note event.
          duration = event.off.time_from_start - event.time_from_start + 1
          
          # Maps the duration in ticks to a correspondent string on the duration table.
          duration_representation = @duration_table[duration]
          
          # In the case that the note do not correspond to anything in the table,
          # we just truncate it to the closest value.
          if duration_representation.nil? or duration_representation == "unknow" then
            new_duration = 0
            smallest_difference = Float::INFINITY
            @duration_table.each { |key, value|
              difference = (duration - key).abs
              if difference < smallest_difference then
                smallest_difference = difference
                new_duration = key
              end
            }
            duration_representation = @duration_table[new_duration]
          end

          # Create new markov chain state and put into the "elements" list
          elements << MidiElement.new(event.note_to_s, duration_representation)
        elsif event.kind_of?(MIDI::ProgramChange) then
          program_change = event.program
        end
      }
      
      if program_change.nil?
        program_change = 1
      end
      
      @value_chain[program_change] ||= elements unless elements.empty?
    }
  end
  
  # Build the markov chain for each instrument on the input midi file(s)
  def build
    model_by_instrument = {}
    @value_chain.each{ |key, value|
      model_by_instrument[key] = MarkovModel.new(value)
    }
    
    return model_by_instrument
  end
  
  ####################
  private
  ####################
  
  # Creates the duration table from the "quarter" note duration in ticks.
  # * The quarter note duration will change for every track!
  def create_duration_table(quarter_note_length)
    # Fuck it if the song have two dots or a combination of dots and "three"...
    whole = (quarter_note_length * 4)
    dotted_whole = (quarter_note_length * 6)
    whole_triplet = (8 * quarter_note_length / 3)
    half = (quarter_note_length * 2)
    dotted_half = (quarter_note_length * 3)
    half_three = (whole / 3)
    dotted_quarter = (quarter_note_length * 1.5)
    quarter_triplet = (half / 3)
    eight = (quarter_note_length / 2)
    eight_triplet = (quarter_note_length / 3)
    dotted_eight = (3 * quarter_note_length / 4)
    sixteenth = (quarter_note_length / 4)
    sixteenth_triplet = (eight / 3)
    dotted_sixteenth = (3 * quarter_note_length / 8)
    thirty_second = (quarter_note_length / 8)
    thirty_second_triplet = (sixteenth / 3)
    dotted_thirty_second = (3 * quarter_note_length / 16)
    sixty_fourth = (quarter_note_length / 16)
    sixty_fourth_triplet = (thirty_second / 3)
    dotted_sixty_fourth = (3 * quarter_note_length / 32)
    
    @duration_table = {
      whole => 'whole',
      dotted_whole => 'dotted whole',
      whole_triplet => 'whole triplet',
      half => 'half',
      dotted_half => 'dotted half',
      half_three => 'half triplet',
      quarter_note_length => 'quarter',
      dotted_quarter => 'dotted quarter',
      quarter_triplet => 'quarter triplet',
      eight => 'eighth',
      dotted_eight => 'dotted eighth',
      eight_triplet => 'eighth triplet',
      sixteenth => 'sixteenth',
      dotted_sixteenth => 'dotted sixteenth',
      sixteenth_triplet => 'sixteenth triplet',
      thirty_second => 'thirtysecond',
      dotted_thirty_second => 'dotted thirtysecond',
      thirty_second_triplet => 'thirtysecond triplet',
      sixty_fourth => 'sixtyfourth',
      dotted_sixty_fourth => 'dotted sixtyfourth',
      sixty_fourth_triplet => 'sixtyfourth triplet'
    }
  end
  
end

# This class represents a state on the markov chain. This state
# is built from a note and a duration string representation.
class MidiElement
  
  attr_accessor :note, :duration
  
  # Initializes the midi element by a note string and a string representation of the duration.
  def initialize(note, duration)
    @note = note
    @duration = duration
  end
  
  # Overriding comparison to be used on "=="
  def ==(comparison_object)
    comparison_object.equal?(self) ||
      (comparison_object.instance_of?(self.class) && 
       @note == comparison_object.note &&
       @duration == comparison_object.duration)
  end
  
  # Overriding comparison to be used on hashing
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
