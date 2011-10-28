require 'matrix'

module Fathom
  module CPTBuilder

    def self.extended(base)
      base.table = base.default_records
    end
    
    # Create a table unless one already exists by this name
    def create_table!
      return true unless Fathom.config.uses_sqlite_optimizer
      value = Fathom.config.db.execute(table_creation_sql)
    end
    
    def fill_table!(hashes=nil)
      hashes ||= default_records # So that fill_table!(nil) will still use the default_records
      self.table = hashes
      insert_hashes_into_table(hashes) if Fathom.config.uses_sqlite_optimizer
    end
    
    def default_records
      output = []
      all_records = causal_variables.map do |v|
        causal_records_for(v)
      end
      all_records += [target_records_for(target_variable)]
      all_records.reverse_each do |set|
        output = combine_sets(set, output)
      end
      output
    end
    
    protected
    
      def insert_hashes_into_table(hashes)
        hashes.each do |hash|
          sql = insert_sql_for(hash)
          Fathom.config.db.execute(sql)
        end
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
          (value and value != 0) ? 1 : 0
        when Fixnum, Float
          value
        else
          "'#{value}'"
        end
      end

      def combine_sets(set1, set2=[])
        return set1 if set2.empty?
        set1.product(set2).map do |(a, b)|
          a.merge(b)
        end
      end
      
      def insert_sql_for(hash)
        values = hash.map {|key, value| typecast_value(value, key)}
        "INSERT INTO #{table_name} (#{hash.keys.join(', ')}) VALUES ( #{values.join(', ')} )"
      end
    
      def table_creation_sql
        <<-SQL
          CREATE TABLE IF NOT EXISTS #{table_name} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            #{field_definitions}
          );
        SQL
      end
      
      def field_definitions
        seperator = ",\n            "
        output = "probability FLOAT"
        output += seperator
        output += "value #{sql_data_type_for(target_variable)}"
        output += seperator
        output += causal_variables.map do |variable|
          "#{variable.underscored_name} #{sql_data_type_for(variable)}"
        end.join(seperator)
        output
      end
      
      def sql_data_type_for(variable)
        case variable.outcomes.first
        when Fixnum, TrueClass, FalseClass
          "INTEGER"
        when Float
          "FLOAT"
        else
          "VARCHAR(255)"
        end
      end
    
  end
end
