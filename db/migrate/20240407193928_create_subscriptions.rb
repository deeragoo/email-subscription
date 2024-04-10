class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.references :subscribers, foreign_key: true
      t.timestamps
    end
  end
end
