class StocksController < ApplicationController
  protect_from_forgery except: :search

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
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
    @stock = Stock.find(params[:id])
  end

  # def get_change
  #   client = IEX::Api::Client.new(
  #     publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
  #     endpoint: 'https://sandbox.iexapis.com/v1'
  #   )
    
  #   @change = client.quote(params[:stock]).change_percent_s
  # end

  # def get_open_price
  #   client = IEX::Api::Client.new(
  #     publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
  #     endpoint: 'https://sandbox.iexapis.com/v1'
  #   )

  #   @price = client.quote(params[:stock]).open
  # end

  # def get_close_price
  #   client = IEX::Api::Client.new(
  #     publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
  #     endpoint: 'https://sandbox.iexapis.com/v1'
  #   )

  #   @price = client.quote(params[:stock]).close
  # end

  # def get_volume
  #   client = IEX::Api::Client.new(
  #     publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
  #     endpoint: 'https://sandbox.iexapis.com/v1'
  #   )

  #   @volume = client.quote(params[:stock]).latest_volume
  # end

  def get_change
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    @ytd_change = client.quote(params[:stock]).ytd_change
    @volume = client.quote(params[:stock]).latest_volume
    @close_price = client.quote(params[:stock]).close
    @open_price = client.quote(params[:stock]).open
    @change = client.quote(params[:stock]).change_percent_s
    historical_prices = client.historical_prices(params[:stock])
    @price_data = construct_hash_for_chart(historical_prices)
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

end