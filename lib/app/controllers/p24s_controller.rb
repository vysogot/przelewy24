# responsible for transactions and connection with payments service
# Przelewy24.pl
class P24sController < ApplicationController

  # requests from Przelewy24.pl
  protect_from_forgery :except => [:ok, :error]

  filter_resource_access
  filter_access_to :confirm, :ok, :error, :attribute_check => false

  #before_filter :require_ssl, :only => [:new, :confirm]

  # redirect back if guest wants to buy license and will log in
  def permission_denied
    if params[:action] == "new"
      flash[:notice] = t('login_before_buy')
      session[:redirect_to] = new_p24_url(params[:license])
    end
    redirect_to login_url
  end

  def index
    @p24s = P24.user_transactions(current_user)
  end

  def show
    @p24 = P24.find(params[:id])
  end

  def new
    if @license = License.find(params[:license])
      @p24 = P24.new(:license => @license)
    else
      redirect_to price_path
    end
  end

  # create new transaction with p24 before verifing it with p24 confirm form
  def create
    @p24 = P24.new(params[:p24])
    @p24.user = current_user

    if @p24.save
      flash[:notice] = t('transaction_created')
      session[:p24_id] = @p24.id

      # if transaction is for existing account extension, put it down
      if session[:username]
        @p24.account = Account.find_by_username(session[:username])
        @p24.update_attribute(:is_for_extension, true)
      end

      redirect_to confirm_p24_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @p24 = P24.find(params[:id])
    @p24.destroy
    flash[:notice] = "Successfully destroyed p24."
    redirect_to p24s_url
  end

  # transaction confirmation
  def confirm
    @p24 = P24.find(session[:p24_id])
  end

  # first verification from Przelewy24.pl
  def ok
    @p24 = P24.find_by_session_id(params[:p24_session_id])
    if @p24 && @p24.update_attribute(:order_id, params[:p24_order_id])

      # name in polish because of Przelewy24.pl - to be plugin
      p24_weryfikuj
    end
  end

  def error
  end

  def verified    
  end

  private

  # Przelewy24.pl final verification process
  def p24_weryfikuj

    # verification script url
    url = URI.parse('https://secure.przelewy24.pl/transakcja.php')

    # post request with '&' PHP connectors
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data(@p24.attributes_for_verify, '&')

    # create new http object with ssl usage
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    # get the response from Przelewy24.pl
    res = http.start {|http| http.request(req) }

    # drop session variable for account extension process
    session[:username] = nil
    
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      results = res.body.split("\r\n")
      if results[1] == "TRUE"

        # check if transaction is not already used
        unless @p24.is_verified
          @p24.set_account
          flash[:notice] = t('new_account_added', :username => @p24.account.username, :desc => @p24.opis)
          redirect_to accounts_url
          return
        else
          error_desc = t('transaction_used')
        end
      else
        error_desc = "#{results[2]} #{results[3]}"
      end
    else
      error_desc = t('p24_connection_error') 
    end

    # display error flash and redirect to error action
    flash[:error] = error_desc
    redirect_to :action => :error
  end
end
