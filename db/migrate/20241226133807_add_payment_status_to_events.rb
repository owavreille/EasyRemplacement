class AddPaymentStatusToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :payment_status, :string
  end
end
