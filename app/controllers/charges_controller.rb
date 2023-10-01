class ChargesController < ApplicationController
  def new
    @charge = Charge.new
  end

  def create
    charge = Charge.new(amount: create_params[:amount], user_id: current_user.id) 
    if charge.save 
      redirect_to root_path
    else  
      redirect_to root_path
    end
  end

  private

  def create_params 
    params.permit(:amount)
  end
end
