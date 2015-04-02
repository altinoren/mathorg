require 'rails_helper'

RSpec.describe Categorizable, type: :model do
  let!(:topic1) { Topic.create!(name: "Topic 1") }
  let!(:topic2) { Topic.create!(name: "Topic 2") }
  let(:problem) { Problem.create!(body: "asdfdsdafsd") }

  describe "#topics_string=" do 
    it "sets topics from strings" do 
      problem.topics_string = "Topic 1, Topic 2"
      expect(problem.topics.sort).to eq [topic1, topic2].sort
    end
  end 

  describe "#topics_string" do 
    it "its topic strings reflect its topics" do 
      problem.topics << topic1 << topic2
      expect(problem.topics_string).to eq "Topic 2, Topic 1"
    end
  end
end