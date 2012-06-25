require 'rspec'
require 'musikov/markov_builder'

describe Musikov::MidiElement do
  
  it "should respect equals based on the 'note' and 'duration' attributes" do
    midi1 = Musikov::MidiElement.new("silence", 64)
    midi2 = Musikov::MidiElement.new("silence", 64)
    
    midi1.should == midi2
  end
  
  it "should same hash if objects have the same attributes" do
    midi1 = Musikov::MidiElement.new("silence", 64)
    midi2 = Musikov::MidiElement.new("silence", 64)
    
    midi1.hash.should == midi2.hash 
  end
  
  it "should respect eql? equality" do
    midi1 = Musikov::MidiElement.new("silence", 64)
    midi2 = Musikov::MidiElement.new("silence", 64)
    
    (midi1.eql? midi2).should == true
  end

end