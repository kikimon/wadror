class ChangeStyleToBeTable < ActiveRecord::Migration
  def change
     create_table :style do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
      end
  end
end
