module Fathom
  
  # This is an extension of the general table attribute on the Definition data object.  
  # It is meant to represent this data as a matrix and then host the various roles 
  # necessary to maintain this data cleanly.
  class CPT
    
    # ============
    # = Behavior =
    # ============
    extend Plugins
    plugin AttributeSystem
    
    # ==============
    # = Attributes =
    # ==============
    attribute :table
    attribute :causal_variables, []
    attribute :target_variable, []
    
    def initialize(attributes={})
      @attributes = attributes
    end
    
    def table_name
      "#{target_variable.underscored_name}_via_#{causal_variables.map(&:underscored_name).join('_')}"
    end
    
  end
end
