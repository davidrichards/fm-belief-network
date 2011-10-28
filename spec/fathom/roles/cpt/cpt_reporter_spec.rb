require File.expand_path('../../../../spec_helper', __FILE__)

include Fathom

describe CPTReporter do
  
  before do
    @cpt = loaded_cpt
    @cpt.extend CPTReporter
  end
  
  it "should add a query method" do
    @cpt.should respond_to(:query)
  end
  
  it "should be able to return the appropriate value from an exact query" do
    @query = {"participate"=>false, "final_paper"=>false, "value"=>true} 
    @cpt.query(@query).should eql(0.00001)
  end
  
  # TODO: Look at looser queries
  
end