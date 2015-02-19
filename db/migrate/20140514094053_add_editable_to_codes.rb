class AddEditableToCodes < ActiveRecord::Migration
  def change
    add_column :codes, :editable, :boolean, default: true
  end
end
