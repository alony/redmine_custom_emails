class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string :action
      t.text :html
      t.text :text
      t.string :subject
      t.string :locale
      
      t.timestamps
    end
  end

  def self.down
    drop_table :email_templates
  end
end
