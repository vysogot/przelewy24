class Przelewy24Generator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :class_name, :type => :string, :default => "Payment"
  argument :seller_id, :type => :string, :default => "1000"
  class_option :migration, :type => :boolean, :default => true, :desc => "Include migration file."

  def generate_files

    # Generate views
    views.each do |view|
      template "views/#{view}.html.erb", "app/views/#{plural_name}/#{view}.html.erb"
    end

    # Copy locales
    copy_file "przelewy24.yml", "config/locales/przelewy24.yml"

    # Generate controller
    template 'controller.rb', "app/controllers/#{plural_name}_controller.rb"

    # Generate helper
    template 'helper.rb', "app/helpers/#{plural_name}_helper.rb"

    # Generate model
    template 'model.rb', "app/models/#{singular_name}.rb"

    # Generate routes
    routes_string=<<FINITO
resources :#{plural_name} do
    collection do
      get  'confirm'
      get  'error' 
      post 'ok' 
    end
  end
FINITO
  
    route(routes_string)
   
    # Generate migration
    if options.migration?
      # #{Time.now.utc.strftime("%Y%m%d%H%M%S")}_
      migration_file_name = "#{Time.now.utc.strftime("%Y%m%d")}_create_#{table_name}"
      template 'migration.rb', "db/migrate/#{migration_file_name}.rb"

      # migrate
      rake("db:migrate", :env => :development)
    end
  end

  private

  def views
    %w(new index _form show ok error confirm)
  end


  # imagine model: SuperService
  def controller_class_name
    class_name.pluralize # SuperServices
  end

  def singular_name
    class_name.underscore # super_service
  end

  def migration_name
    "Create#{controller_class_name}" # CreateSuperServices
  end

  def plural_name
    singular_name.pluralize # super_services
  end

  alias table_name plural_name # super_services
  alias file_name singular_name # super_service
end
