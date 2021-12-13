class CreateWords < ActiveRecord::Migration[6.1]
  def change
    create_table :words do |t|
      t.string :phrase, null: false
      t.string :groups
    end
  end
end
