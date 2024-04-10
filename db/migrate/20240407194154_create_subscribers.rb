class CreateSubscribers < ActiveRecord::Migration[7.1]
  def change
    create_table :subscribers do |t|
      t.string :email
      t.references :subscription, foreign_key: true
      t.timestamps
    end
  end
end
