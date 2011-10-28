require File.expand_path('../../../spec_helper', __FILE__)

include Fathom

describe CPT do

  it "should initialize a table accessor" do
    CPT.should have_an_initialization_accessor_for(:table)
  end
  
  it "should initialize a causal_variables accessor" do
    CPT.should have_an_initialization_accessor_for(:causal_variables)
  end
  
  it "should default the causal_variables to an array" do
    CPT.new.causal_variables.should eql([])
  end

  it "should initialize a target_variable accessor" do
    CPT.should have_an_initialization_accessor_for(:target_variable)
  end

  it "should default the target_variable to an array" do
    CPT.new.target_variable.should eql([])
  end
  
  it "should define a table_name from the variables" do
    v1 = Variable.infer(:v1)
    v2 = Variable.infer(:v2)
    v3 = Variable.infer(:v3)
    cpt = CPT.new(:causal_variables => [v1, v2], :target_variable => v3)
    cpt.table_name.should eql("v3_via_v1_v2")
  end
  
  it "should underscore variable names to get the table name" do
    v1 = Variable.infer('this is')
    v2 = Variable.infer("a trick")
    v3 = Variable.infer("don't you think?")
    cpt = CPT.new(:causal_variables => [v1, v2], :target_variable => v3)
    cpt.table_name.should eql("don_t_you_think__via_this_is_a_trick")
  end

end