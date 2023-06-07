class CreateMailingLists < ActiveRecord::Migration[7.0]
  def change
    create_table :mailing_lists do |t|
      t.string :name
      t.string :texte
      t.references :site, null: true, foreign_key: true

      t.timestamps
    end
  end
end
