module FindHelper

    class ActiveRecordFinder

      include ::FindHelper::FormatFinderValue
      attr_reader :klass, :filed, :find_filed, :find_value, :find_type, :filed_type

      FINDER_TYPES = {
          :$eq => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} = ?", value]},
          :$gt => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} > ?", value]},
          :$gte => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} >= ?", value]},
          :$lt => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} < ?", value]},
          :$lte => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} <= ?", value]},
          :$ne => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} != ?", value]},
          :$in => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} in (?)", ins.format_array]},
          :$nin => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} not in (?) ", ins.format_array]},
          :$like => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} like ?", "%#{value}%"]},
          :$exists => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} is not null "]},
          :$nexists => lambda{|klass, filed, value, ins| ["#{klass.table_name}.#{filed} is null "]}
      }

      DEFAULT_FINDER_TYPES = :$eq

      def initialize(klass, filed, find_value)
        @klass = klass
        @filed = filed
        @find_value = find_value
      end

      def split_filed
        @find_type = :$eq
        @find_filed = @filed
        @find_type, @find_filed = @filed.to_s.split("_", 2) if @filed.to_s.first == "$"
        @find_type = @find_type.to_sym
      end

      def to_finder
        split_filed

        FINDER_TYPES[@find_type].call(@klass, @find_filed, format_value, self)
      end

      def field_type
        @field_type ||= klass.columns_hash[@find_filed.to_s].type
      end

    end

end
