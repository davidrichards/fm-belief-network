module Fathom
  class CPTBuilderContext
    
    attr_reader :cpt
    
    def initialize(cpt)
      @cpt = cpt
    end
    
    def build_cpt(entries=nil)
      cpt.extend CPTBuilder
      cpt.create_table!
      cpt.fill_table!(entries)
    end
  end
end

