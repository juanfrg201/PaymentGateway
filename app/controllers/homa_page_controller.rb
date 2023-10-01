class HomaPageController < ApplicationController
  def index
    if current_user != nil
      @charges = current_user.charges
    end
  end
end
