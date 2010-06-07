module P24 #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def p24s
        @set.add_route("/p24s", { :controller => "p24s_controller", :action => "index" })
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, P24::Routing::MapperExtensions
