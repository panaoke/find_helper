module FindHelper

	module Scope
		def by_scopes(attrs, allow_blank = false)
			case attrs
				when Array
					by_array_scopes(attrs, allow_blank = false)
				when Hash, HashWithIndifferentAccess
					by_hash_scopes(attrs, allow_blank = false)
			end
		end

		def list_order(order_hash)
			if order_hash.blank?
				(@_default_order_call || ->{ self}).call
			else
				if is_active_record?
					order(order_hash.map do |field, sord|
						      "#{field} #{sord}"
					      end.join(" and "))
				else
					order_by(Hash[order_hash.map do |field, sord|
						              [field, sord == 'desc' ? -1 : 1]
					              end])
				end
			end
		end

		def default_order(scope = nil)
			scope = Proc.new if block_given?
			@_default_order_call = scope
		end


		def by_hash_scopes(attrs, allow_blank = false)
			attrs = attrs.delete_if{|_, value| value.blank? } unless allow_blank

			attrs.inject(self.where({})) do |parent_scope, (key, value)|
				scope_name = key.to_sym
				is_named_scope = self.respond_to?(scope_name)

				if is_named_scope
					parent_scope.send(scope_name, value)
				else
					finder_class = is_active_record? ? ActiveRecordFinder : MongoidFinder

					finder_class.new(self, key, value).to_finder(parent_scope)
				end
			end
		end

		def by_array_scopes(attrs, allow_blank = false)
			attrs.compact.inject(self.where({})) do |result, attr|
				result.by_hash_scopes(attr, allow_blank)
			end
		end

		def is_active_record?
			self.superclass.name == 'ActiveRecord::Base'
		end

	end
end
