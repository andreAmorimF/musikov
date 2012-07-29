require 'midilib/sequence'
require 'midilib/io/seqreader'

module Musikov
  
class FileNotFoundError < StandardError ; end

# This class is responsible for interacting with MidiLib in order
# to read the input midi files.
class MidiParser
  
  ####################
  public
  ####################
  
  # Initializes the parser using the file (or folder) path parameter
  # * Parameter can be a single file path or a folder
  def initialize(file_or_folder_path)
    @path = file_or_folder_path
  end
  
  # Obtains the list of midi files to parse and call the Midilib parse routine
  def parse  
    raise FileNotFoundError unless File.exists?(@path)
    
    result = []
    files = []
    if File.directory?(@path) then
      files += Dir.glob("#{@path}/**/*.mid")
    else
      files << file_or_folder_path if File.extname(@path) == ".mid"
    end
    
    if files.empty? then
      puts "No files were added."
    else
      files.each { |file_path|
        result << read_midi(file_path)
      }
    end
    
    return result
  end
  
  ####################
  private
  ####################
  
  # Call the Midilib's parse routine to read information from a midi file
  def read_midi(file_path)
    # Create a new, empty sequence.
    seq = MIDI::Sequence.new()
    
    # Read the contents of a MIDI file into the sequence.
    File.open(file_path, 'rb') { | file |
        seq.read(file)
    }
    
    return seq
  end
    
end

end