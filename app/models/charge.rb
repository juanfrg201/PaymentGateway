class Charge < ApplicationRecord
  belongs_to :user
  enum status: [:created, :pending, :paid, :rejected, :error]
  enum payment_method: [:unknow, :credit_card, :debit_card, :pse, :cash, :referenced]

  before_create :generate_uid 

  private 

  def generate_uid
    begin 
      self.uid = SecureRandom.hex(5)
    end while self.class.exists?(uid: self.uid)
  end
  
end
