class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
