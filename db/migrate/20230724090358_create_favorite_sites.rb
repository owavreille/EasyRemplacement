class CreateFavoriteSites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_sites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
