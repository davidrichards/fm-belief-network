module Fathom
  
  # This is intended to use Pearl's prior odds and likelihood messages
  # to update beliefs in a belief network.  It captures changes to
  # any variable and then begins to propagate changes.
  # 
  # Note: if we are using this role, the network itself represents 
  # a single possible world.  The idea is that we update the network
  # with actual observations, letting the network be the memory of
  # all observations.  In this way, we don't have to employ any
  # other algorithms when querying the network.
  module BeliefPropagator
    
    def self.extended(base)
      Variable.attribute(:belief)
      Variable.attribute(:children)
      Variable.attribute(:parents)
    end
    
    # TODO: Define the intervening CPTs (need to think through the desired syntax)
    # TODO: Capture updates to beliefs and propagate the change (dependent on CPTs)
    # TODO: Build a simple belief updating syntax
    # TODO: Build a context that updates a network with this role, as well as takes a list of observations
    # TODO: Build a server (context) that serves observations to a network real-time
    # TODO: Build a context for copying a belief network, annotating it, and allowing the new context to have reign
    # TODO: Work through any Fathom-wide configuration on Matrix
    # TODO: Build a Memcached context for caching these networks
    # TODO: Build a Redis context for caching these networks
    # TODO: Extend my numbers project to visualize graphs
    # TODO: Find some protocols, look for some standards, build a network from protocols
    # TODO: Take some CCR data, bridge it to a belief network.
    # TODO: Add a network as CDS
    
  end
end
