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

		def by_hash_scopes(attrs, allow_blank = false)
			attrs = attrs.delete_if{|_, value| value.blank? } unless allow_blank

			attrs.inject(self.where({})) do |parent_scope, (key, value)|
				scope_name = key.to_sym
				is_named_scope = self.respond_to?(scope_name)

				if is_named_scope
					parent_scope.send(scope_name, value)
				else
					is_active_record = self.superclass.name == 'ActiveRecord::Base'
					finder_class = is_active_record ? ActiveRecordFinder : MongoidFinder

					parent_scope.where(finder_class.new(self, key, value).to_finder)
				end
			end
		end

		def by_array_scopes(attrs, allow_blank = false)
			attrs.compact.inject(self.where({})) do |result, attr|
				result.by_hash_scopes(attr, allow_blank)
			end
		end

	end
end
