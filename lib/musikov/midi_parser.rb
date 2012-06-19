require 'midilib/sequence'
require 'midilib/io/seqreader'

module Musikov
  
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
    
    result = []
    files = []
    if File.directory?(file_or_folder_path) then
      files += Dir.glob("#{file_or_folder_path}/**/*.mid")
    else
      files << file_or_folder_path if File.extname(file_or_folder_path) == ".mid"
    end
    
    if files.empty? then
      puts "No files were added."
    else
      files.each { |file_path|
        result << parse(file_path)
      }
    end
    
    return result
  end
  
  def parse(file_path)
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