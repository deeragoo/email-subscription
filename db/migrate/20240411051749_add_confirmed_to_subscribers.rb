class AddConfirmedToSubscribers < ActiveRecord::Migration[7.1]
  def change
    add_column :subscribers, :confirmed, :boolean, default: false
  end
end
