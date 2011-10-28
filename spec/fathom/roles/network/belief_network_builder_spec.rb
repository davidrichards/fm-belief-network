require File.expand_path('../../../../spec_helper', __FILE__)

include Fathom

describe BeliefNetworkBuilder do
  
  before do
    @network = Network.new
    @network.extend(BeliefNetworkBuilder)
  end
  
  # ======================
  # = LooselyComparingHash =
  # ======================
  context "when using LooselyComparingHash" do
    before do
      @hash = Fathom::BeliefNetworkBuilder::LooselyComparingHash.new
    end
    
    it "should default the values to Array" do
      @hash[1].should eql([])
    end
    
    it "should compare the keys with ==" do
      @v1 = Variable.new(:name => :name)
      @v2 = Variable.new(:name => :name)
      @hash[@v1] = :v1
      @hash[@v2] = :v2
      @hash[@v1].should eql(:v2)
    end
    
    it "should be able to append the arrays naturally" do
      @hash[1] << 1
      @hash[1] << 2
      @hash[1].should eql([1,2])
    end
  end
  
  # ===============================
  # = Managing the Adjacency List =
  # ===============================
  context "when managing the adjacency list" do
    it "should add an adjacency_list as an initialization attribute" do
      Network.new.adjacency_list.should eql([])
    end
    
    it "should have defined a LooselyComparingHash" do
      defined?(Fathom::BeliefNetworkBuilder::LooselyComparingHash).should be_true
    end

    it "should have a parents list as an initialization attribute" do
      Network.new.parents.should eql(BeliefNetworkBuilder::LooselyComparingHash.new)
    end
    
    it "should have a children list as an initialization attribute" do
      Network.new.children.should eql(BeliefNetworkBuilder::LooselyComparingHash.new)
    end
    
    it "should be able to add_edge with an Edge" do
      @v1 = Variable.new(:name => :v1)
      @v2 = Variable.new(:name => :v2)
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @network.add_edge(@edge)
      @network.adjacency_list.should eql([@edge])
    end
    
    it "should be able to add_edge with two variables" do
      @v1 = Variable.new(:name => :v1)
      @v2 = Variable.new(:name => :v2)
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @network.add_edge(@v1, @v2)
      @network.adjacency_list.first.should ==(@edge)
    end
    
    it "should be able to add_edge with two names" do
      @edge = Edge.new(:parent => :v1, :child => :v2)
      @network.add_edge(:v1, :v2)
      @network.adjacency_list.first.should ==(@edge)
    end
    
    it "should add to the parents from the edge" do
      @v1 = Variable.new(:name => :v1)
      @v2 = Variable.new(:name => :v2)
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @network.add_edge(@edge)
      @network.parents[@v2].should eql([@v1])
      @network.parents_for(@v2).should eql([@v1])
    end
    
    it "should add to the children from the edge" do
      @v1 = Variable.new(:name => :v1)
      @v2 = Variable.new(:name => :v2)
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @network.add_edge(@edge)
      @network.children[@v1].should eql([@v2])
      @network.children_for(@v1).should eql([@v2])
    end
    
    it "should not be able to add an identical edge (as defined by ==, using Variable names)" do
      @v1 = Variable.new(:name => :v1)
      @v2 = Variable.new(:name => :v2)
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @network.add_edge(@edge)
      @network.add_edge(@edge)
      @network.add_edge(@v1, @v2)
      @network.adjacency_list.size.should eql(1)
    end
    
  end

  # =====================
  # = Adding a Variable =
  # =====================
  context "when adding a variable" do
    
    it "should add an add_variable method" do
      @network.should respond_to(:add_variable)
    end
    
    it "should be able to add a Variable instance" do
      @variable = Variable.new
      @network.add_variable(@variable)
      @network.variables.should eql([@variable])
    end
    
    it "should be able to add a variable from the variable's initialization hash" do
      @hash = {:name => :name, :prior_odds => [0.2, 0.8]}
      @network.add_variable(@hash)
      @variable = @network.variables.first
      @variable.should be_a(Variable)
      @variable.name.should eql(:name)
      @variable.prior_odds.should eql([0.2, 0.8])
    end
    
    it "should be able to add a variable by its name as a symbol" do
      @symbol = :name
      @network.add_variable(@symbol)
      @variable = @network.variables.first
      @variable.should be_a(Variable)
      @variable.name.should eql(@symbol)
    end
    
    it "should be able to add a variable by its name as a string" do
      @string = 'name'
      @network.add_variable(@string)
      @variable = @network.variables.first
      @variable.should be_a(Variable)
      @variable.name.should eql(@string)
    end
    
    it "should add the network association when adding a variable" do
      @network.add_variable(:v1)
      @network.variables.first.network.should eql(@network)
    end
    
    it "should be able to add more than one variable" do
      @variable = Variable.new
      @hash = {:name => :name, :prior_odds => [0.2, 0.8]}

      @network.add_variable(@variable)
      @network.add_variable(@hash)

      @network.variables.shift.should eql(@variable)
      
      @variable = @network.variables.first
      @variable.should be_a(Variable)
      @variable.name.should eql(:name)
      @variable.prior_odds.should eql([0.2, 0.8])
    end
    
  end
  
  # ========================================
  # = Local Access to Parents and Children =
  # ========================================
  context "when using parents and children from variables" do
    
    before do
      @v1 = Variable.infer(:v1)
      @v1.network = @network
      @v2 = Variable.infer(:v2)
      @v2.network = @network
    end
    
    it "should extend a variable to add_parent" do
      @variable = Variable.new
      @variable.should respond_to(:add_parent)
    end
    
    it "should extend a variable to add_cpt" do
      @variable = Variable.new
      @variable.should respond_to(:add_cpt)
    end
    
    it "should extend a variable to have a network attribute" do
      Variable.should have_an_initialization_accessor_for(:network)
    end
    
    it "should raise an error when trying to check for parents and it doesn't have the network attribute set" do
      @variable = Variable.infer(:v1)
      lambda{@variable.parents}.should raise_error(ArgumentError, /Unknown network/)
    end
    
    it "should use the network's parents lookup to get the variable's parents" do
      @network.should_receive(:parents_for).with(@v1).and_return(:found)
      @v1.parents.should eql(:found)
    end
    
    it "should add an edge to the network when adding a parent" do
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @v2.add_parent(@v1)
      @network.adjacency_list.first.should ==(@edge)
    end
    
    it "should be able to add more than one parent at a time" do
      @v3 = Variable.infer(:v3)
      @v3.network = @network
      @v3.add_parents(@v1, @v2)
      @network.adjacency_list.first.should ==(Edge.new(:parent => @v1, :child => @v3))
      @network.adjacency_list.last.should ==(Edge.new(:parent => @v2, :child => @v3))
    end

    it "should raise an error when trying to check for children and it doesn't have the network attribute set" do
      @variable = Variable.infer(:v1)
      lambda{@variable.children}.should raise_error(ArgumentError, /Unknown network/)
    end
    
    it "should use the network's children lookup to get the variable's children" do
      @network.should_receive(:children_for).with(@v1).and_return(:found)
      @v1.children.should eql(:found)
    end
    
    it "should add an edge to the network when adding a children" do
      @edge = Edge.new(:parent => @v1, :child => @v2)
      @v1.add_child(@v2)
      @network.adjacency_list.first.should ==(@edge)
    end

    it "should be able to add more than one child at a time" do
      @v3 = Variable.infer(:v3)
      @v3.network = @network
      @v1.add_children(@v2, @v3)
      @network.adjacency_list.first.should ==(Edge.new(:parent => @v1, :child => @v2))
      @network.adjacency_list.last.should ==(Edge.new(:parent => @v1, :child => @v3))
    end

  end
  
  # ===============
  # = Build a CPT =
  # ===============
  # TODO: Build a CPT
  
end