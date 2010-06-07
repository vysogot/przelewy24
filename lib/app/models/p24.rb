# responsible for process with payment service Przelewy24.pl
class P24 < ActiveRecord::Base
  
  # use this when you have a license based product
  # belongs_to :license

  # use this when you want to connect p24 transaction with your user model
  # belongs_to :user

  # use this when you have a account based product
  # belongs_to :account

  before_create :set_variables

  SELLER_ID = 1000 # here provide your SELLER_ID
  COUNTRY   = 'PL'
  LANGUAGE  = 'pl'

  validates_presence_of :email, :klient, :adres, :kod, :miasto
  validates_format_of :kod, :with => /[0-9]{2}-[0-9]{3}/

  # use when you want to connect it with user model to list his transactions
  # listing transactions - all for admin, user's for member
  
  # named_scope :user_transactions, lambda { |u| 
  #  { :conditions => { :user_id => u.id } } unless u.admin? 
  # }

  # price to display - in db is in cents
  def kwota_pln
    kwota.to_f/100
  end

  # generate 64-char long key to przelewy24.pl
  def self.generate_session_id
    MyGenerator::generate(64, 26, 97)
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
      'p24_opis' => MyGenerator::replace_polish_chars(license.name),
      'p24_kwota' => kwota,
      'p24_klient' => klient,
      'p24_adres' => adres,
      'p24_kod' => kod,
      'p24_miasto' => miasto,
      'p24_kraj' => COUNTRY,
      'p24_email' => email,
      'p24_language' => LANGUAGE
    }
  end

  # after the payment correct verification account is created of extended
  def set_account
    transaction do
      unless is_verified
        update_attribute(:is_verified, true)

        # if you want to use it for extending time of some
        # account based product, use those lines:
        
        # if is_for_extension
        #   account.extend(license.days)
        # else
        #   account = self.create_account(:user_id => user_id)
        #   update_attribute(:account_id, account.id)
        # end
      end
    end
  end

  private

  # setting data for p24 from foreign objects
  def set_variables
    self.session_id = P24.generate_session_id
    self.kwota = license.price
    self.opis = license.name
  end

end
