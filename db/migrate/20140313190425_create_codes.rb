class CreateCodes < ActiveRecord::Migration
  def change
    drop_table :codes if table_exists? :codes
    create_table :codes do |t|
      t.string :title, default: ''
      t.text :code
      t.string :code_url, default: ''
      t.integer :status, limit: 1, default: 1

      t.timestamps
    end
  end
end
