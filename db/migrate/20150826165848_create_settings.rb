class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.string :last_changed_by, default: 'system'

      t.timestamps null: false
      t.index :name, unique: true
    end
  end
end
