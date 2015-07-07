module FindHelper
  class Engine < ::Rails::Engine
    isolate_namespace FindHelper

    initializer "finder_helper" do |app|
	    ActiveSupport.on_load :active_record do
		    if defined?(Rails::Railtie)
			    ::ActiveRecord::Base.include ::FindHelper
		    elsif defined?(Rails::Initializer)
			    raise "finder helper  is not compatible with Rails 2.3 or older"
		    end

		    if defined?(Mongoid::Document)
			    Mongoid::Document.include ::FindHelper
		    end

	    end
	  end
  end
end
