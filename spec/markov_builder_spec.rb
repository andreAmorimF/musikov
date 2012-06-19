require 'rspec'
require 'musikov/markov_builder'

describe Musikov::MidiElement do
  
  it "should respect equals based on the 'note' and 'tempo' attributes" do
    midi1 = Musikov::MidiElement.new("silence", 100)
    midi2 = Musikov::MidiElement.new("silence", 100)
    
    (midi1 == midi2).should == true
  end
  
  it "should same hash if objects have the same attributes" do
    midi1 = Musikov::MidiElement.new("silence", 100)
    midi2 = Musikov::MidiElement.new("silence", 100)
    
    midi1.hash.should == midi2.hash 
  end
  
end