# responsible for process with payment service Przelewy24.pl
class <%= class_name %> < ActiveRecord::Base

  before_create :set_session_id

  SELLER_ID = 1000 # Put here you account login on przelewy24
  COUNTRY   = 'PL'
  LANGUAGE  = 'pl'

  validates_presence_of :email, :klient, :adres, :kod, :miasto
  validates_format_of :kod, :with => /[0-9]{2}-[0-9]{3}/ # polish post code check

  # price to display - in db is in cents
  def kwota_pln
    kwota.to_f/100
  end

  # generate 64-char long key to przelewy24.pl
  def self.generate_session_id
    <%= class_name %>Tools::generate(64, 26, 97)
  end

  # attributes that are needed in second verification
  def attributes_for_verify
    {
      'p24_session_id' => session_id,
      'p24_order_id' => order_id,
      'p24_id_sprzedawcy' => SELLER_ID,
      'p24_kwota' => kwota
    }
  end

  # attibutes that are needed for first contact with przelewy24.pl
  def attributes_for_p24
    {
      'p24_session_id' => session_id,
      'p24_id_sprzedawcy' => SELLER_ID,
      'p24_opis' => <%= class_name %>Tools::replace_polish_chars(opis),
      'p24_kwota' => kwota,
      'p24_klient' => <%= class_name %>Tools::replace_polish_chars(klient),
      'p24_adres' => <%= class_name %>Tools::replace_polish_chars(adres),
      'p24_kod' => kod,
      'p24_miasto' => <%= class_name %>Tools::replace_polish_chars(miasto),
      'p24_kraj' => COUNTRY,
      'p24_email' => email,
      'p24_language' => LANGUAGE
    }
  end

  # after the payment correct verification
  def set_account
    transaction do
      unless is_verified
        update_attribute(:is_verified, true)
        
        # Here you should put what happen after correct verification process
      end
    end
  end

  private

  # setting session id for connection with przelewy24
  def set_session_id
    self.session_id = <%= class_name %>.generate_session_id
    self.id_sprzedawcy = SELLER_ID
    self.kraj = COUNTRY
    self.language = LANGUAGE
  end

  class <%= class_name %>Tools

    # Generate a string with given length from given ascii range
    def self.generate(length, from, to)
      string = ""
      length.times { |i| string << (rand(from)+to).chr }
      string
    end

    # Replace polish chars, so there will be no funny signs on Przelewy24 in transactions
    def self.replace_polish_chars(string)    
      ascii = "acelnoszzACELNOSZZ"
      cep = "\271\346\352\263\361\363\234\277\237\245\306\312\243\321\323\214\257\217"  
      string = Iconv.new("cp1250", "UTF-8").iconv(string)  
      string.tr(cep,ascii)  
    end

  end

end
