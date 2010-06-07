ActiveRecord::Schema.define(:version => 0) do
  create_table :p24s, :force => true do |t|

    # t.integer :user_id
    # t.integer :license_id
    # t.integer :account_id

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
    t.boolean :is_for_extension, :default => false
    t.boolean :is_verified, :default => false

    t.timestamps
  end
end
