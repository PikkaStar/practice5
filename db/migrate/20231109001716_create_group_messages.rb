class CreateGroupMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :group_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
