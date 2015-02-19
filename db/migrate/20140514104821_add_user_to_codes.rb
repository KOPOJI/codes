class AddUserToCodes < ActiveRecord::Migration
  def change
    add_reference :codes, :user, index: true
  end
end
