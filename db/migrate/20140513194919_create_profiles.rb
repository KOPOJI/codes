class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :interests
      t.string :exp
      t.string :about_me
      t.string :signature
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
