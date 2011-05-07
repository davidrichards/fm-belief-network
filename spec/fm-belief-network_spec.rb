require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Fathom::BeliefNetwork do
  it "should require fathom" do
    defined?(Fathom::Plugins).should be_true
  end
end
