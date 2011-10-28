module Fathom
  class CPTReporterContext
    
    attr_reader :cpt
    
    def initialize(cpt)
      @cpt = cpt
    end
    
    def query(query={})
      cpt.extend CPTReporter
      cpt.query(query)
    end
  end
end

