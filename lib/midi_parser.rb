require 'midilib/sequence'
require 'midilib/io/seqreader'

class FileNotFoundError < StandardError ; end

class MidiParser
  
  public
  
  def initialize(file_or_folder_path)
    read_files(file_or_folder_path)
  end
  
  def add_resource(file_or_folder_path)
    read_files(file_or_folder_path)
  end
  
  private
  
  def read_files(file_or_folder_path)  
    raise FileNotFoundError unless File.exists?(file_or_folder_path)
    
    files = []
    if File.directory?(file_or_folder_path) then
      files += Dir.glob("#{file_or_folder_path}/**/*.mid")
    else
      files << file_or_folder_path if File.extname(file_or_folder_path) == ".mid"
    end
    
    if files.empty? then
      puts "No files were added."
      return
    end 
    
    files.each { |file_path|
      read_midi(file_path)
    }
  end
  
  def read_midi(file_path)
    # Create a new, empty sequence.
    seq = MIDI::Sequence.new()
    
    # Read the contents of a MIDI file into the sequence.
    File.open(file_path, 'rb') { | file |
        seq.read(file) { | track, num_tracks, i |
            # Print something when each track is read.
            puts "read track #{i} of #{num_tracks} => #{track.inspect}"
        }
    }
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