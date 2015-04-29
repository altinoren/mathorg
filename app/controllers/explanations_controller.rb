class ExplanationsController < ApplicationController
  before_action :set_explanation, only: [:edit, :update, :show, :destroy]
  def new 
    @explanation = Explanation.new(body: RichText.new)
    @explanation.topics = [Topic.find(params[:topic])] unless params[:topic].nil?
  end

  def edit
  end

  def create
    @explanation = Explanation.new(explanation_params)
    if @explanation.save
      redirect_to action: :show, id: @explanation.id
    else
      render 'new'
    end
  end

  def update
    @explanation.update(explanation_params)

    @explanation.user = current_user
    @explanation.save

    redirect_to @explanation
  end

  def show
  end

  def destroy
    @explanation.destroy

    render text: 'Your explanation has been deleted.'
  end

private
  def explanation_params
    params.require(:explanation).permit(:title, :description, :topics_string, body_attributes: [:text])
  end

  def set_explanation
    @explanation = Explanation.find(params[:id])
  end
end