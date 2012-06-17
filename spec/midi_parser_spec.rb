require 'rspec'
require 'midi_parser'

describe MidiElement do
  
  it "should respect equals based on the 'note' and 'tempo' attributes" do
    midi1 = MidiElement.new("silence", 100)
    midi2 = MidiElement.new("silence", 100)
    
    (midi1 == midi2).should == true
  end
  
  it "should same hash if objects have the same attributes" do
    midi1 = MidiElement.new("silence", 100)
    midi2 = MidiElement.new("silence", 100)
    
    midi1.hash.should == midi2.hash 
  end
  
end