class CreateDatabase < ActiveRecord::Migration
  def self.up
    create_table :examples do |t|
      t.string :first_path
      t.string :second_path
      t.string :default_field
    end
  end
  
  def self.down
    drop_table :examples
  end
end
