require 'rspec'
require 'markov_model'

describe MarkovModel do
  
  it "should add values with its correspondent frequence" do
    text = "The man is tall. The man is big."

    mc = MarkovModel.new(text.split)
    mc.frequencies["is"].should == {"big." => 0.5, "tall." => 0.5}
  end
  
  it "should pick word corresponding to random number" do
    text = "The man is tall. The man is big."

    # Obs: testing private method through "send"
    mc = MarkovModel.new(text.split)
    wd = mc.send(:pick_value, 0.8, "is")
    wd.should == "tall."
  end
  
  it "should re-compute frequencies after inserting more input" do
    text1 = "The man is tall. The man is big."
    text2 = "The man is strange. The man is very strange."

    mc = MarkovModel.new()
    mc.add_input(text1.split)
    mc.frequencies["is"].should == {"big." => 0.5, "tall." => 0.5}
    
    mc.add_input(text2.split)
    mc.frequencies["is"].should == {"big." => 0.25, "tall." => 0.25, "strange." => 0.25, "very" => 0.25}
  end
  
end