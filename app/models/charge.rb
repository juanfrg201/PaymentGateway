class Charge < ApplicationRecord
  belongs_to :user
  enum status: [:created, :pending, :paid, :rejected, :error]
  enum payment_method: [:unknow, :credit_card, :debit_card, :pse, :cash, :referenced]

  before_create :generate_uid 

  def update_status(status)
    if status == "4"
      self.paid!
    elsif status == "7"
      self.pending!
    elsif status == "6"
      self.rejected!
      self.update(error_message: params[:response_message_pol])
    end
  end

  def update_payment_method(payment_method)
    if payment_method == "2"
      self.credit_card!
    elsif payment_method == "4"
      self.pse!
    elsif payment_method == "6"
      self.debit_card!
    elsif payment_method == "7"
      self.cash!
    elsif payment_method == "8" || payment_method == "10"
      self.referenced!
    elsif payment_method == "14"
      self.transfer!
    end
  end

  private 

  def generate_uid
    begin 
      self.uid = SecureRandom.hex(5)
    end while self.class.exists?(uid: self.uid)
  end

end
