class StocksController < ApplicationController
  protect_from_forgery except: :search

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'stocks/results' }
        end
        # render 'users/my_portfolio'
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.js { render partial: 'stocks/results' }
          # redirect_to my_portfolio_path
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        # redirect_to my_portfolio_path
        format.js { render partial: 'stocks/results' }
      end
    end
  end 

end