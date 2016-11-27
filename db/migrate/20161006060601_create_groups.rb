class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :code
      t.string :instructions, default: "To join the group, type your name in the form below and click 'Join Group'. After the gift exchanges are generated you'll be able to look up who you are giving to and receiving from through this link. You can also share this link with others so they can join the group as well."
      t.string :password_digest
      t.boolean :open, default: true
      t.boolean :public, default: true

      t.timestamps
    end
  end
end
