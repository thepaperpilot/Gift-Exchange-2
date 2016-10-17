class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.string :token
      t.string :type
      t.boolean :names, default: true
      t.boolean :groups
      t.boolean :case
      t.boolean :regex
      t.boolean :invert
      t.references :rule, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
