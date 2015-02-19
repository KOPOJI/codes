class AddShowFromToCodes < ActiveRecord::Migration
  def change
    add_column :codes, :show_from, :string
  end
end
