class Topic < ActiveRecord::Base
  searchkick

  validates :name, presence: true, uniqueness: true, length: { minimum: 5 }

  has_many :topic_categorizables
  has_many :problems,     through: :topic_categorizables, source: :categorizable, source_type: "Problem"
  has_many :explanations, through: :topic_categorizables, source: :categorizable, source_type: "Explanation"
  has_many :solutions,    through: :topic_categorizables, source: :categorizable, source_type: "Solution"

  has_many :topic_child_parents, foreign_key: :child_id, dependent: :destroy 
  has_many :parents, through: :topic_child_parents, source: :parent
  has_many :topic_parent_children, class_name: 'TopicChildParent', foreign_key: :parent_id, dependent: :destroy 
  has_many :children, through: :topic_parent_children, source: :child

  ## ::TODO_LATER:: fix this up maybe? 
  def self.topics_string_to_topics_array(tag_string)
    topic_string_array = tag_string.split(",").map(&:strip).uniq.reject(&:empty?)
    Topic.find_all_by_name(topic_string_array)
  end

  def self.topics_array_to_topics_string(topics)
    topics.map(&:name).join(', ')
  end

  def ancestor_topics
    (self.parents.empty? ? [self] : self.parents.map(&:ancestor_topics).flatten.append(self)).uniq
  end

  def descendant_topics
    (self.children.empty? ? [self] : self.children.map(&:descendant_topics).flatten.append(self)).uniq
  end
end