class CreateInquiries < ActiveRecord::Migration

  def up
    create_table :refinery_inquiries do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :message
      t.boolean :spam, null: false, default: false
      t.boolean :archived, null: false, default: false

      t.timestamps null: false
    end

    add_index :refinery_inquiries, :updated_at
  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({name: 'inquiries'})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({plugin_page_id: 'inquiries'})
      ::Refinery::Page.delete_all({plugin_page_id: 'inquiries_thank_you'})
    end

    drop_table :refinery_inquiries
  end

end
