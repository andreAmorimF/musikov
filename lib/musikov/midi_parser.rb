require 'midilib/sequence'
require 'midilib/io/seqreader'

module Musikov
  
class FileNotFoundError < StandardError ; end

class MidiParser
  
  public
  
  def initialize(file_or_folder_path)
    @path = file_or_folder_path
  end
  
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
  
  private
  
  def read_midi(file_path)
    # Create a new, empty sequence.
    seq = MIDI::Sequence.new()
    
    # Read the contents of a MIDI file into the sequence.
    File.open(file_path, 'rb') { | file |
        seq.read(file) { | track, num_tracks, i |
            # Print something when each track is read.
            puts "=> reading track #{track ? track.name : ''} (#{i} of #{num_tracks})"
        }
    }
    
    return seq
  end
    
end

end