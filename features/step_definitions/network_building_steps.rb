Given /^a network$/ do
  @network = Network.new
end

When /^I use the (\w+) context with a (\w+)$/ do |context_name, object_name|
  variable = instance_variable_get("@#{object_name}")
  @context = ("Fathom::" + context_name + "Context").constantize.new(variable)
end

When /^I pass it appropriate manual entries via build_graph$/ do
  @appropriate_entries = {
    :variables => [
      {:name => :participate, :prior_odds => [0.8, 0.2]},
      {:name => :final_paper, :prior_odds => [0.7, 0.3]},
      {:name => :letter},
    ],
    :edges => [
      {:participate => :letter},
      {:final_paper => :letter}
    ]
  }
  
  @context.build_graph(@appropriate_entries)
end

Then /^I should get a network populated with variables and edges$/ do
  @network.variables.size.should eql(3)
  participate = @network.variables[0]
  final_paper = @network.variables[1]
  letter = @network.variables[2]
  
  participate.name.should eql(:participate)
  participate.prior_odds.should eql([0.8, 0.2])
  
  final_paper.name.should eql(:final_paper)
  final_paper.prior_odds.should eql([0.7, 0.3])
  
  letter.name.should eql(:letter)
  letter.prior_odds.should eql([0.5, 0.5])
  
  @network.adjacency_list.size.should eql(2)
  pl = @network.adjacency_list[0]
  fl = @network.adjacency_list[1]
  
  pl.should be_a(Edge)
  pl.parent.should ==(participate)
  pl.child.should ==(letter)
  
  fl.should be_a(Edge)
  fl.parent.should ==(final_paper)
  fl.child.should ==(letter)
  
  @network.parents_for(letter).should ==([participate, final_paper])
end

Given /^a basic graph$/ do
  @network = basic_graph
end

Given /^a target cpt$/ do
  @cpt = CPT.new(:causal_variables => @network.variables[0..1], :target_variable => @network.variables[2])
end

When /^I pass it appropriate manual entries via build_cpt$/ do
  @appropriate_entries = [
    {"participate"=>1, "final_paper"=>1, "value"=>1, "probability"=>0.98}, 
    {"participate"=>1, "final_paper"=>1, "value"=>0, "probability"=>0.02}, 
    {"participate"=>1, "final_paper"=>0, "value"=>1, "probability"=>0.8}, 
    {"participate"=>1, "final_paper"=>0, "value"=>0, "probability"=>0.2}, 
    {"participate"=>0, "final_paper"=>1, "value"=>1, "probability"=>0.9}, 
    {"participate"=>0, "final_paper"=>1, "value"=>0, "probability"=>0.1}, 
    {"participate"=>0, "final_paper"=>0, "value"=>1, "probability"=>0.00001}, 
    {"participate"=>0, "final_paper"=>0, "value"=>0, "probability"=>0.99999}
  ]
  @context.build_cpt(@appropriate_entries)
end

Then /^I should get a CPT filled with the appropriate values$/ do
  @cpt.table[0].should eql(@appropriate_entries[0])
  @cpt.table[1].should eql(@appropriate_entries[1])
  @cpt.table[2].should eql(@appropriate_entries[2])
  @cpt.table[3].should eql(@appropriate_entries[3])
  @cpt.table[4].should eql(@appropriate_entries[4])
  @cpt.table[5].should eql(@appropriate_entries[5])
  @cpt.table[6].should eql(@appropriate_entries[6])
  @cpt.table[7].should eql(@appropriate_entries[7])
end