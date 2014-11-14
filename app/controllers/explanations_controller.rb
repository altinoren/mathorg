class ExplanationsController < ApplicationController
  def new 
  end

  def edit
    @explanation = Explanation.find(params[:id])
  end

  def create
    @explanation = Explanation.new(params[:explanation].permit(:title, :description, :body))
    @topics = Topic.topics_string_to_topics_array(params[:explanation][:topics])
    @explanation.save
    @explanation.topics << @topics

    redirect_to action: :show, id: @explanation.id
  end

  def show
    @explanation = Explanation.find(params[:id])
    @cur_vote = user_signed_in? ? Vote.find_by_user_id_and_votable_id(current_user.id, @explanation.id) : nil
  end

  def destroy
      @explanation = Explanation.find(params[:id])
      @explanation.destroy

      render text: 'Your explanation has been deleted.'
  end

  def vote
    #@cur_vote = Vote.find(params[:cur_vote])
    render text: @cur_vote
    #@cur_vote = Vote.new(params.permit(:positive, :user_id, :votable_id))
    #@cur_vote.votable_type = "Explanation"
    #@cur_vote.save

    #redirect_to action: :show, id: params[:votable_id]
  end
end
