class Client::SharesController < ApplicationController
  before_action :set_winner, only: [:edit , :update]
  before_action :fetch_banners, only: [:index]
  before_action :fetch_news_tickers, only: [:index]

  def index
    @published_winners = Winner.where(state: 'published').order(created_at: :desc).page(params[:page]).per(6)
  end
  def edit
  end

  def update
    # render json: params
    if @winner.update(share_params)
      if @winner.delivered?
        @winner.share!
        flash[:notice] = "Thank you for sharing your feedback!"
        redirect_to winning_history_client_me_path
      else
        flash[:alert] = "This prize has already been shared."
        redirect_to winning_history_client_me_path
      end
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new
    end
  end


  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def share_params
    params.require(:winner).permit(:picture, :comment)
  end

  def fetch_banners
    @banners = Banner.where(status: 'active')
                     .where('online_at >= ? AND ? < offline_at', Time.current, Time.current)
                     .order(:sort)
  end

  def fetch_news_tickers
    @news_tickers = NewsTicker.active.order(:sort).limit(5)
  end
end