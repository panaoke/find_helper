module FindHelper

    module FormatFinderValue

      def format_date
        if find_value.is_a?(Date)
          find_value
        elsif find_value.respond_to?(:to_date)
          find_value.to_date
        else
          Date.parse(find_value.to_s)
        end
      end

      def format_regexp
        if find_value.is_a?(Regexp)
          find_value
        else
          Regexp.new(find_value)
        end
      end

      def format_time
        if [DateTime, Time].include?(find_value.class)
          find_value
        elsif find_value.respond_to?(:to_time)
          find_value.to_time
        else
          if find_value.is_a?(Numeric)
            Time.at(find_value)
          else
            Time.parse(find_value)
          end
        end
      end

      def format_array
        case find_value
          when String
            find_value.split(",")
	        else
						if find_value.respond_to?(:to_a)
							find_value.to_a
						else
							Array(find_value)
						end

        end
      end

      def format_boolean
        case find_value
          when String
            ['true', '1'].include?(find_value)
          when Integer
            find_value == 1
          else
            find_value
        end
      end

      def format_value
        case field_type
          when :date
            format_date
          when :datetime
            format_time
          when  :time
            format_time
          when :integer
            find_value.to_i
          when :float
            find_value.to_f
          when :boolean
            format_boolean
          else
            find_value
        end
      end

    end

end