class CreateRules < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.string :name, default: "New Rule"
      t.boolean :source_match_all
      t.boolean :whitelist_match_all
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
