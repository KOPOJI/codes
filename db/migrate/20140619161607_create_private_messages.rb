class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.integer :user_from_id
      t.integer :user_to_id
      t.string :title
      t.text :text
      t.string :file

      t.boolean :deleted_by_from_user,  default: false
      t.boolean :deleted_by_to_user,    default: false
      t.boolean :read,                  default: false

      t.timestamps
    end
  end
end
