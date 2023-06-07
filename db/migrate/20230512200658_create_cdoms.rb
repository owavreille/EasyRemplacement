class CreateCdoms < ActiveRecord::Migration[7.0]
  def change
    create_table :cdoms do |t|
      t.string :departement
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
