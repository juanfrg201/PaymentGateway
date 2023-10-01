class CreateCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :charges do |t|
      t.string :uid, limit: 50
      t.integer :status
      t.integer :payment_method
      t.decimal :amount
      t.text :error_message
      t.jsonb :response_data
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
