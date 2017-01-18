class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :family
      t.boolean :participating, default: true
      t.integer :giving_to
      t.integer :receiving_from
      t.integer :user_id
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
