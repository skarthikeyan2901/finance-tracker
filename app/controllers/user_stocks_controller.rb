class UserStocksController < ApplicationController

  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    # binding.break
    if current_user.stocks.size >= 10
      flash[:alert] = "You are already tracking 10 stocks!"
      redirect_to my_portfolio_path
    elsif !UserStock.where(user: current_user, stock: stock).blank?
      flash[:alert] = "You are already tracking this stock!"
      redirect_to my_portfolio_path
    else
      @user_stock = UserStock.create(user: current_user, stock: stock)
      flash[:notice] = "Stock #{stock.name} was successfully added  to your portfolio!"
      redirect_to my_portfolio_path
    end
  end

  def destroy
    if Stock.where(id: params[:id]).blank?
      flash[:alert] = "Unknown stock!"
      redirect_to my_portfolio_path and return
    end
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id)
    # binding.break
    if user_stock.blank?
      flash[:alert] = "Stock is not present in portfolio for it to be deleted!"
      redirect_to my_portfolio_path
    else
      user_stock = user_stock.first
      user_stock.destroy
      flash[:notice] = "#{stock.ticker} was successfully removed from your portfolio!"
      redirect_to my_portfolio_path
    end
  end

end
