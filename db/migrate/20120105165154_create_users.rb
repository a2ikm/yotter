class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid,      null: false
      t.string :nickname, null: false
      t.string :token,    null: false
      t.string :secret,   null: false
      t.boolean :active,  null: false, default: true

      t.timestamps
    end
    add_index :users, :uid, unique: true
  end
end
