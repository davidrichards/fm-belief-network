def loaded_cpt

  @v1 = Variable.infer(:participate)
  @v2 = Variable.infer(:final_paper)
  @v3 = Variable.infer(:letter)
  @cpt = CPT.new(:causal_variables => [@v1, @v2], :target_variable => @v3)
  @context = CPTBuilderContext.new(@cpt)

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

  @context.build_cpt(@appropriate_entries)

  @cpt
  
end