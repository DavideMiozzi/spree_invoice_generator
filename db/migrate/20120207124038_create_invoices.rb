class CreateInvoices < ActiveRecord::Migration
  def up
    create_table :spree_invoices do |t|
      t.integer :counter, :default => 0      
      t.string :invoice_number

      t.references :order, :user
      
      t.timestamps
    end
    add_index :spree_invoices, :invoice_number
  end
  
  def down
    drop_table :spree_invoices
  end
end
