class StocksController < ApplicationController
  protect_from_forgery except: :search
  before_action :check_if_user_is_tracking_stock, only: [:forum]

  def search
    stock_ticker = params[:stock].upcase
    if stock_ticker.present?
      @stock = Stock.new_lookup(stock_ticker)
      if @stock
        respond_to do |format|
          format.js { render partial: 'stocks/results' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.js { render partial: 'stocks/results' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.js { render partial: 'stocks/results' }
      end
    end
  end 

  def show
    if Stock.where(id: params[:id]).exists?
      @stock = Stock.find(params[:id])
    else
      flash[:alert] = "Unknown stock!"
      redirect_to my_portfolio_path
    end
  end

  def get_change
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    stock_ticker = params[:stock].upcase

    @ytd_change = client.quote(stock_ticker).ytd_change
    @volume = client.quote(stock_ticker).latest_volume
    @close_price = client.quote(stock_ticker).close
    @open_price = client.quote(stock_ticker).open
    @change = client.quote(stock_ticker).change_percent_s
    historical_prices = client.historical_prices(stock_ticker)
    @price_data = construct_hash_for_chart(historical_prices)
  end

  def forum
    if Stock.where(id: params[:id]).exists?
      @messages = Message.where(stock_id: params[:id])
      @stock = params[:id]
    else
      flash[:alert] = "Unknown stock!"
      redirect_to my_portfolio_path
    end
  end

  def forum_submit
    message_data = params["message"]
    stock = params["stock_id"]
    # binding.break
    message = Message.new(content: message_data, user_id: current_user.id, stock_id: stock)
    message.save()

    @message_content = params["message"]
    @username = current_user
    @time = message.created_at
  end

  private
  def construct_hash_for_chart(historical_prices)
    prices = Hash.new
    historical_prices.each do |data|
      date_of_data = data["date"]
      closing_price = data["close"]
      prices[date_of_data] = closing_price
    end
    prices
  end

  def check_if_user_is_tracking_stock
    if Stock.where(id: params[:id]).blank?
      flash[:alert] = "Unkown stock!"
      redirect_to my_portfolio_path and return
    end
    if UserStock.where(user: current_user, stock: params[:id]).blank?
      flash[:alert] = "You have to be tracking this stock to access the forum!"
      redirect_to my_portfolio_path
    end
  end

end