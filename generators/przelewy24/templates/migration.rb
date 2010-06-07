class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string :session_id
      t.string :id_sprzedawcy
      t.integer :kwota
      t.string :klient
      t.string :adres
      t.string :kod
      t.string :miasto
      t.string :kraj
      t.string :email
      t.text :opis
      t.integer :order_id
      t.integer :order_id_full
      t.string :error_code
      t.string :language
      t.integer :metoda
      t.boolean :is_verified, :default => false

      t.timestamps
    end
  end
  
  def self.down
    drop_table :<%= table_name %>
  end
end
