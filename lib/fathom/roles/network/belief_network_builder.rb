module Fathom
  module BeliefNetworkBuilder
    
    # This hash-like class does 2 things:
    # 
    # 1) uses assoc to check key values 
    # This means it uses == instead of object_id to see if it has a key
    # so that v1 = Variable(:name => :name) & v2 = Variable.new(:name => :name)
    # h = LooselyComparingHash.new
    # h[v1] = 1
    # h[v2] = 2
    # h[v1] # => 2
    # 
    # 2) ensures a new hash entry is an empty array
    # E.g. h = LooselyComparingHash.new
    # h[1] # => []
    class LooselyComparingHash < Hash

      def initialize(*attrs, &block)
        super() {|h, k| h.original_set(k, [])}
      end

      alias :original_lookup :[]
      def [](key)
        (k, v) = self.assoc(key)
        v ? v : original_lookup(key)
      end

      alias :original_set :[]=
      def []=(key, value)
        (found_key, v) = self.assoc(key)
        if found_key
          self.original_set(found_key, value)
        else
          self.original_set(key, value)
        end
      end
    end

    def self.extended(base)
      Network.send(:attribute, :adjacency_list, [])
      Network.send(:attribute, :parents, LooselyComparingHash.new)
      Network.send(:attribute, :children, LooselyComparingHash.new)
      
      Variable.send(:include, VariableMethods)
      Variable.send(:attribute, :network)
    end

    # Add a variable from a Variable, Hash, Symbol (for the name),
    # or String (for the name)
    def add_variable(obj)
      self.variables = Array(self.variables)
      variable = Variable.infer(obj)
      variable.network = self
      self.variables += [variable]
      variable
    end
    
    def add_edge(obj, optional_child=nil)
      if obj.is_a?(Edge)
        edge = obj
      else
        parent = Variable.infer(obj)
        child = Variable.infer(optional_child)
        edge = Edge.new(:parent => parent, :child => child)
      end
      raise ArgumentError, "An edge could not be infered" unless edge
      return false if self.adjacency_list.find { |e| e == edge }
      
      self.adjacency_list << edge
      self.parents[edge.child] << edge.parent
      self.children[edge.parent] << edge.child
      true
    end
    
    def parents_for(variable); self.parents[variable]; end
    def children_for(variable); self.children[variable]; end
    
    module VariableMethods
      attr_accessor :parents
      def parents
        raise ArgumentError, "Unknown network" unless self.network
        self.network.parents_for(self)
      end
      
      def add_parent(*attrs)
        raise ArgumentError, "Unknown network" unless self.network
        attrs.each do |obj|
          parent = Variable.infer(obj)
          parent.network = self.network
          self.network.add_edge(parent, self)
        end
        true
      end
      alias :add_parents :add_parent
      
      def children
        raise ArgumentError, "Unknown network" unless self.network
        self.network.children_for(self)
      end
      
      def add_child(*attrs)
        raise ArgumentError, "Unknown network" unless self.network
        attrs.each do |obj|
          child = Variable.infer(obj)
          child.network = self.network
          self.network.add_edge(self, child)
        end
        true
      end
      alias :add_children :add_child
      
      def add_cpt(&block)
      end
    end
    
  end
end


# # ====================================
# # = Use Case: Build Network Manually =
# # ====================================
# n = Network.new(:name => "Some Name")
# n.extend ManualBuilder
# p = n.add_variable(:name => :participate, :prior_odds => [0.8, 0.2])
# f = n.add_variable(:name => :final_paper, :prior_odds => [0.7, 0.3])
# l = n.add_variable(:name => :letter)
# l.add_parent(p)
# l.add_parent(f)
# l.add_cpt do |cpt|
#   cpt.add :participate => false, :final_paper => false, [99.9999, 0.00001]
#   cpt.add :participate => true, :final_paper => false, [0.8, 0.2]
#   cpt.add :participate => false, :final_paper => true, [0.9, 0.1]
#   cpt.add :participate => true, :final_paper => true, [0.98, 0.02]
# end
