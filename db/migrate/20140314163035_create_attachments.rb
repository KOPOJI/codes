class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :code_id
      t.string :image

      t.timestamps
    end
  end
end
