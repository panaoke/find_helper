module FindHelper

    class ActiveRecordFinder

      include ::FindHelper::FormatFinderValue
      attr_reader :klass, :field, :find_field, :find_value, :find_type, :field_type, :relation_class,
                  :relation_foreign_key, :relation_class_name

      FINDER_TYPES = {
          :$eq => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} = ?", value]},
          :$gt => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} > ?", value]},
          :$gte => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} >= ?", value]},
          :$lt => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} < ?", value]},
          :$lte => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} <= ?", value]},
          :$ne => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} != ?", value]},
          :$in => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} in (?)", ins.format_array]},
          :$nin => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} not in (?) ", ins.format_array]},
          :$like => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} like ?", "%#{value}%"]},
          :$exists => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} is not null "]},
          :$nexists => lambda{|klass, field, value, ins| ["#{klass.table_name}.#{field} is null "]}
      }

      DEFAULT_FINDER_TYPES = :$eq

      def initialize(klass, field, find_value)
        @klass = klass
        @field = field
        @find_value = find_value

        if field.to_s.include?('.')
          @relation_class_name, @field = field.split('.')
          @relation_class = @klass._reflections[@relation_class_name].klass
          @relation_foreign_key = @klass._reflections[@relation_class_name].foreign_key
        end
      end

      def split_field
        @find_type = :$eq
        @find_field = @field
        @find_type, @find_field = @field.to_s.split("_", 2) if @field.to_s.first == "$"
        @find_type = @find_type.to_sym
      end

      def to_finder(parent_scope)
        split_field
        conditions = FINDER_TYPES[@find_type].call((@relation_class || @klass), @find_field, format_value, self)
        if @relation_class
          parent_scope.joins(@relation_class_name.to_sym).where(conditions)
        else
          parent_scope.where(conditions)
        end
      end

      def field_type
        @field_type ||= (@relation_class || @klass).columns_hash[@find_field.to_s].type
      end

    end

end
