module Fathom
  class ManualEntryContext
    
    attr_reader :network
    
    def initialize(network)
      @network = network
    end
    
    # Builds a graph manually from a hash.
    # Expects a variables array and an edges array.
    # Each entry in the edges should be a hash ({parent => child}
    # or {parent => [children]})
    def build_graph(opts={})
      network.extend BeliefNetworkBuilder
      opts[:variables].each { |v| network.add_variable(v) }
      opts[:edges].each do |edge|
        edge.each do |parent, children|
          children = Array(children)
          children.each do |child|
            network.add_edge(parent, child)
          end # each child
        end # each edge entry (possibly multiple children)
      end # each edge hash
    end # build_graph
    
  end
end
