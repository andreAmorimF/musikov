require 'rspec'
require 'markov_model'

describe MarkovModel do
  
  it "should add values with its correspondent frequence" do
    text = "The man is tall. The man is big."

    mc = MarkovModel.new(text.split)
    mc.frequencies["is"].should == [["big.", 0.5], ["tall.", 0.5]]
  end
  
  it "pick word corresponding to random number" do
    text = "The man is tall. The man is big."


    # Obs: testing private method through "send"
    mc = MarkovModel.new(text.split)
    wd = mc.send(:pick_value, 0.8, "is")
    wd.should == "tall."
  end
  
end