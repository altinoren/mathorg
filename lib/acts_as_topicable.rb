def acts_as_topicable(options = {})
  topics_name     = options[:topics_name]     || :topics
  topicable_name  = options[:topicable_name]  || name.tableize.to_sym
  topicable_class = options[:topicable_class] || name

  self.class_eval do 
    # prevents naming conflicts when e.g. included in Topic
    pseudo_join_name = "#{topics_name.to_s.singularize}_#{topicable_name}".to_sym
    has_many pseudo_join_name, class_name: 'TopicCategorizable', as: :categorizable
    has_many topics_name, through: pseudo_join_name, source: :topic

    define_singleton_method "topics_name" do 
      topics_name 
    end 

    define_method "__topics" do |*args|
      send topics_name, args
    end

    define_method "__topics=" do |*args|
      send "#{topics_name}=".to_sym, *args
    end

    include Categorizable
  end

  Topic.class_eval do 
    has_many topicable_name, through: :topic_categorizables, source: :categorizable, source_type: topicable_class
  end 
end