class Przelewy24Generator < Rails::Generator::NamedBase
  default_options :skip_migration => false

  # from rails/scaffold_generator
  attr_reader   :controller_name,
    :controller_class_path,
    :controller_file_path,
    :controller_class_nesting,
    :controller_class_nesting_depth,
    :controller_class_name,
    :controller_underscore_name,
    :controller_singular_name,
    :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    if @name == @name.pluralize && !options[:force_plural]
      logger.warning "Plural version of the model detected, using singularized version.  Override with --force-plural."
      @name = @name.singularize
      assign_names!(@name)
    end

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Model, controller, helpers and views directories
      m.directory File.join('app/models', class_path)
      m.directory File.join('app/controllers', controller_class_path)
      m.directory File.join('app/helpers', controller_class_path)
      m.directory File.join('app/views', controller_class_path, controller_file_name)

      # Generate views
      for action in p24_views
        m.template(
          "view_#{action}.html.erb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end

      # Generate controller
      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      # Generate helper
      m.template(
        'helper.rb', File.join('app/helpers', controller_class_path, "#{controller_file_name}_helper.rb")
      )

      # Route
      m.route_resources controller_file_name

      # Named routes monkey inject
      # unless options[:pretend]
      #   gsub_file 'config/routes.rb', /(resource \:#{controller_file_name})/mi do |match|
      #     "#{match}\n
      #      map.confirm_#{@singular_name} 'confirmation', :controller => :#{@plural_name}, :action => :confirm
      #      map.ok_#{@plural_name} 'verification-successful', :controller => :#{@plural_name}, :action => :ok, :conditions => { :method => :post }
      #      map.error_#{@plural_name} 'error-in-transaction', :controller => :#{@plural_name}, :action => :error
      #      \n"
      #   end
      # end


      migration_file_path = file_path.gsub(/\//, '_')
      migration_name = class_name
      if ActiveRecord::Base.pluralize_table_names
        migration_name = migration_name.pluralize
        migration_file_path = migration_file_path.pluralize
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{migration_name.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{migration_file_path}"
      end

      # Generate model
      m.template(
        'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      )

      m.readme "INSTALL"

    end

  end

  protected

  def banner
    "Usage: #{$0} #{spec.name} ModelName"
  end

  def add_options!(opt)
    opt.separator("Options: ")
    opt.on("--skip-migration", "Don't generate migration for Przelewy24")
  end

  def p24_views
    %w( new index _form show ok error confirm )

  end
end
