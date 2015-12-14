module FindHelper

    class MongoidFinder
      include ::FindHelper::FormatFinderValue
      attr_reader :klass, :field, :find_field, :find_value, :find_type

      FINDER_TYPES = {
          :$eq => lambda{|field, value, ins| {field => value} },
          :$gt => lambda{|field, value, ins| {field => {:$gt => value}} },
          :$gte => lambda{|field, value, ins| {field => {:$gte => value} } },
          :$lt => lambda{|field, value, ins| {field => {:$lt => value}} },
          :$lte => lambda{|field, value, ins| {field => {:$lte => value}} },
          :$ne => lambda{|field, value, ins| {field => {:$ne => value} } },
          :$in => lambda{|field, value, ins| {field => {:$in => ins.format_array}} },
          :$nin => lambda{|field, value, ins| {field => {:$nin => ins.format_array } } },
          :$like => lambda{|field, value, ins| {field => ins.format_regexp} },
          :$exists => lambda{|field, value, ins| {field => { :$exists => true} } },
          :$nexists => lambda{|field, value, ins| {field => { :$exists => false} } },
          :$boolean => lambda{|field, value, ins| {field => ['true', '1'].include?(value.to_s) } }
      }
      FIELD_TYPES = {
          :Time => :time,
          :Integer => :integer,
          :String => :string,
          :Boolean => :boolean,
          :Float =>  :float,
          :Date => :date
      }

      DEFAULT_FINDER_TYPES = :$eq

      def initialize(klass, field, find_value)
        @klass = klass
        @field = field
        @find_value = find_value
      end

      def split_field
        @find_type = :$eq
        @find_field = @field
        @find_type, @find_field = @field.to_s.split("_", 2) if @field.to_s.first == "$"
        @find_type = @find_type.to_sym
      end

      def to_finder(parent_scope)
        split_field

        parent_scope.where(FINDER_TYPES[@find_type].call(@find_field, format_value, self))
      end

      def field_type
        @field_type ||= FIELD_TYPES[klass.fields[@find_field.to_s].type.name.to_sym]
      end

    end

end
