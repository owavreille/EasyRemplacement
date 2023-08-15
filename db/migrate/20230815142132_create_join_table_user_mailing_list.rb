class CreateJoinTableUserMailingList < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :mailing_lists do |t|
      # t.index [:user_id, :mailing_list_id]
      # t.index [:mailing_list_id, :user_id]
    end
  end
end
