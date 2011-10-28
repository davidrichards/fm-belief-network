Given /^a target populated cpt$/ do
  @cpt = CPT.new(:causal_variables => @network.variables[0..1], :target_variable => @network.variables[2])
  interim_context = CPTBuilderContext.new(@cpt)
  @appropriate_entries = [
    {"participate"=>true, "final_paper"=>true, "value"=>true, "probability"=>0.98}, 
    {"participate"=>true, "final_paper"=>true, "value"=>false, "probability"=>0.02}, 
    {"participate"=>true, "final_paper"=>false, "value"=>true, "probability"=>0.8}, 
    {"participate"=>true, "final_paper"=>false, "value"=>false, "probability"=>0.2}, 
    {"participate"=>false, "final_paper"=>true, "value"=>true, "probability"=>0.9}, 
    {"participate"=>false, "final_paper"=>true, "value"=>false, "probability"=>0.1}, 
    {"participate"=>false, "final_paper"=>false, "value"=>true, "probability"=>0.00001}, 
    {"participate"=>false, "final_paper"=>false, "value"=>false, "probability"=>0.99999}
  ]
  interim_context.build_cpt(@appropriate_entries)
end

When /^I pass it an exact query$/ do
  @query = {"participate"=>false, "final_paper"=>false, "value"=>true} 
  @result = @context.query(@query)
end

Then /^I should get accurate query results$/ do
  @result.should eql(0.00001)
end