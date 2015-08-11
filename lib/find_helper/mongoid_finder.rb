module FindHelper

    class MongoidFinder
      include ::FindHelper::FormatFinderValue
      attr_reader :klass, :filed, :find_filed, :find_value, :find_type

      FINDER_TYPES = {
          :$eq => lambda{|filed, value, ins| {filed => value} },
          :$gt => lambda{|filed, value, ins| {filed => {:$gt => value}} },
          :$gte => lambda{|filed, value, ins| {filed => {:$gte => value} } },
          :$lt => lambda{|filed, value, ins| {filed => {:$lt => value}} },
          :$lte => lambda{|filed, value, ins| {filed => {:$lte => value}} },
          :$ne => lambda{|filed, value, ins| {filed => {:$ne => value} } },
          :$in => lambda{|filed, value, ins| {filed => {:$in => ins.format_array}} },
          :$nin => lambda{|filed, value, ins| {filed => {:$nin => ins.format_array } } },
          :$like => lambda{|filed, value, ins| {filed => ins.format_regexp} },
          :$exists => lambda{|filed, value, ins| {filed => { :$exists => true} } },
          :$nexists => lambda{|filed, value, ins| {filed => { :$exists => false} } }
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

      def to_finder(parent_scope)
        split_filed

        parent_scope.where(FINDER_TYPES[@find_type].call(@find_filed, format_value, self))
      end

      def field_type
        @field_type ||= FIELD_TYPES[klass.fields[@find_filed.to_s].type.name.to_sym]
      end

    end

end
