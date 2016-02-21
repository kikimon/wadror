class RemoveOldStyleFieldFromBeers < ActiveRecord::Migration
  def change
     remove_column :beers, :old_style, :string
     drop_table :style
  end
end
