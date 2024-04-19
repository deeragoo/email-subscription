class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.string :desc
      t.string :author
      t.timestamps
    end
  end
end