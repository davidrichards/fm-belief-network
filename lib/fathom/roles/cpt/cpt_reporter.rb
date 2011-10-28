require 'matrix'

module Fathom
  module CPTReporter

    def query(query)
      result = Fathom.config.db.execute(select_sql(query)).map do |row|
        row[0]
      end
      # TODO: Lots more to do here...
      result[0]
    end
    
    protected
      def select_sql(query)
        "SELECT probability FROM #{table_name} WHERE #{where_clause(query)}"
      end
      
      def where_clause(query)
        query.map do |k, v|
          variable = variable_from_key(k)
          "#{k} = #{typecast_value(v, variable)}"
        end.join(" AND ")
      end
    
      def variable_from_key(key)
        case key
        when "value", "probability"
          target_variable
        else
          causal_variables.find {|v| v.underscored_name == key}
        end
      end
    
      def causal_records_for(variable)
        variable.outcomes.map do |outcome|
          {variable.underscored_name => outcome}
        end
      end

      def target_records_for(variable)
        output = []
        variable.prior_odds.each_with_index do |prior_odds, i|
          output << {"value" => variable.outcomes[i], "probability" => prior_odds}
        end
        output
      end
      
      def typecast_value(value, variable)
        return value if variable == "probability"
        variable = variable_from_key(variable) unless variable.is_a?(Variable)
        case variable.outcomes.first
        when TrueClass, FalseClass
          value ? 1 : 0
        when Fixnum, Float
          value
        else
          "'#{value}'"
        end
      end
    
  end
end
