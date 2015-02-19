class AddToMessageIdToPrivateMessages < ActiveRecord::Migration
  def change
    add_column :private_messages, :to_message_id, :integer, default: nil
  end
end