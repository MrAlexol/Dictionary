class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :word, null: false
      t.references :user, null: false, foreign_key: true
      t.text :definition

      t.timestamps
    end
  end
end
