require 'rails/generators'
require 'rails/generators/base'


module ManybotsFoursquare
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../../templates", __FILE__)
      
      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true

      desc 'Mounts Manybots Foursquare at "/manybots-foursquare"'

      def add_manybots_foursquare_routes
        route 'mount ManybotsFoursquare::Engine => "/manybots-foursquare"' if options.routes?
      end
      
      desc "Creates a ManybotsFoursquare initializer"
      def copy_initializer
        template "manybots-foursquare.rb", "config/initializers/manybots-foursquare.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
      
    end
  end
end
