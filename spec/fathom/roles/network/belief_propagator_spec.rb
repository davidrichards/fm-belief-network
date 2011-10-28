require File.expand_path('../../../../spec_helper', __FILE__)

include Fathom

describe BeliefPropagator do
  
  before do
    @variable = Variable.new
    @variable.extend(BeliefPropagator)
  end
  
  it "should add a belief matrix to Variable" do
    Variable.should have_an_initialization_accessor_for(:belief)
  end
  
  it "should add children to Variable" do
    Variable.should have_an_initialization_accessor_for(:children)
  end
  
  it "should add parents to Variable" do
    Variable.should have_an_initialization_accessor_for(:parents)
  end
  
end