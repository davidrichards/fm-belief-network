require File.expand_path('../../../spec_helper', __FILE__)

include Fathom

describe Variable do
  it "should have a parents array" do
    @v = Variable.new
    @v.parents.should eql([])
  end
  
  it "should have a parents accessor" do
    @v = Variable.new(:parents => [1,2,3])
    @v.parents.should eql([1,2,3])
  end
  
  it "should have a frequencies array" do
    @v = Variable.new
    @v.frequencies.should eql([])
  end
  
  it "should have a frequencies accessor" do
    @v = Variable.new(:frequencies => [10, 20, 30])
    @v.frequencies.should eql([10, 20, 30])
  end
end