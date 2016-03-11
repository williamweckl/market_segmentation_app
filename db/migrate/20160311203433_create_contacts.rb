class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :age, null: false
      t.integer :state, null: false, index: true
      t.references :position, foreign_key: true, null: false

      t.timestamps
    end
  end
end
