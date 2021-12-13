class CreateSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :searches do |t|
      t.string :phrase
      t.string :groups
      t.string :part_of_speech

      t.timestamps
    end
  end
end
