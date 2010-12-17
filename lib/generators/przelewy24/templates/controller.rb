# responsible for transactions and connection with payments service
# Przelewy24.pl
class <%= controller_class_name %>Controller < ApplicationController

  # requests from Przelewy24.pl
  protect_from_forgery :except => [:ok, :error]

  # If you want to use ssl, uncomment that line
  # before_filter :require_ssl, :only => [:new, :confirm]

  def index
    @<%= table_name %> = <%= class_name %>.all
  end

  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  def new
    @<%= file_name %> = <%= class_name %>.new
  end

  # create new transaction with <%= file_name %> before verifing it with <%= file_name %> confirm form
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

    if @<%= file_name %>.save
      flash[:notice] = t('transaction_created')
      session[:<%= file_name %>_id] = @<%= file_name %>.id

      redirect_to confirm_<%= plural_name %>_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy
    flash[:notice] = t('transaction_destroyed')
    redirect_to <%= table_name %>_url
  end

  # transaction confirmation
  def confirm
    @<%= file_name %> = <%= class_name %>.find(session[:<%= file_name %>_id])
  end

  # first verification from Przelewy24.pl
  def ok
    @<%= file_name %> = <%= class_name %>.find_by_session_id(params[:p24_session_id])
    if @<%= file_name %> && @<%= file_name %>.update_attributes(:order_id => params[:p24_order_id], 
                                                                :metoda => params[:p24_karta], 
                                                                :order_id_full => params[:p24_order_id_full])

      # verification with service - name in polish to be consistent with current PHP spec
      przelewy24_weryfikuj
    else
      flash[:error] = 'Transaction not found'
      redirect_to <%= table_name %>_url
    end
  end

  def error
  end

  private

  # Przelewy24.pl final verification process
  def przelewy24_weryfikuj

    # verification script url
    url = URI.parse('https://secure.przelewy24.pl/transakcja.php')

    # post request with '&' PHP connectors
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data(@<%= file_name %>.attributes_for_verify, '&')

    # create new http object with ssl usage
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    
    # UNCOMMENT THAT IF OpenSSL throws unwanted errors
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # get the response from Przelewy24.pl
    res = http.start {|http| http.request(req) }

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      results = res.body.split("\r\n")
      if results[1] == "TRUE"

        # check if transaction is not already used
        unless @<%= file_name %>.is_verified
          @<%= file_name %>.update_attribute(:is_verified, true)
          return
        else
          error_desc = t('transaction_already_used')
        end
      else
        error_desc = "#{results[2]} #{results[3]}"
      end
    else
      error_desc = t('connection_error') 
    end

    @<%= file_name %>.update_attribute(:error_code, results[2])
    # display error flash and redirect to error action
    flash[:error] = error_desc
    redirect_to :action => :error
  end
end
