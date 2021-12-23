class RemoveColumnsFromSearch < ActiveRecord::Migration[6.1]
  def change
    remove_column :searches, :groups, :string
    remove_column :searches, :created_at, :string
    remove_column :searches, :updated_at, :string
  end
end
