# From page 61 and prior pages explaining the chain rule.
class Goofing
  
  attr_reader :variables
  
  def initialize(*variables)
    @variables = variables
  end
  
  # Produces a complete joint distribution without any factorization
  def chain_rule
    output = []
    variables.each_with_index do |variable, i|
      j = i - 1
      given = j < 0 ? [] : variables[0..i - 1]
      output << {variable => given}
    end
    output
  end
  
end

# From Page 75, incomplete (need more theory and principles to ensure I'm doing a good job here.)
class ReachableNodes
  
  attr_reader :network, :source_variable, :observations
  
  # Usage (shorthand):
  # ReachableNodes.new(:graph => g, :variable => v, :observations {...})
  def initalize(opts={})
    @network = opts.delete(:network)
    @network ||= opts.delete(:graph)
    raise ArgumentError, "Must provide a network (graph)" unless network and network.is_a?(Network)
    
    @source_variable = opts.delete(:source_variable)
    @source_variable ||= opts.delete(:variable)
    raise ArgumentError, "Must provide a source variable (variable)" unless source_variable and
      source_variable.is_a?(Variable)
      
    @observations = opts.delete(:observations)
    @observations.merge!(opts)
  end
  
  TrailDirective = STRUCT.new(variable, direction)
  
  def find_reachable_nodes
    
    # Role extensions?
    
    to_visit = observations.keys
    ancestors = []
    
    # Create an ancestors stack from our observations and the parents of our observations.
    until to_visit.empty?
      y = to_visit.pop
      unless ancestors.include?(y)
        to_visit += y.parents
      end
      
      ancestors += y
    end
    
    # Traverse active trails, beginning with the source_variable
    
    active_trails = [TrailDirective.new(source_variable, :up) ]
    visited = []
    nodes_reachable = []
    
    until active_trails.empty?
      directive = active_trails.shift
      if not visited.include?(directive)
        if not observations.keys.include?()
          nodes_reachable += directive.variable
        end
        visited += directive
        
        if directive.direction == :up and not visited.include?(directive)

          directive.variable.breadth_first_parents.each do |parent|
            active_trails += TrailDirective.new(parent, :up)
          end

          directive.variable.breadth_first_children.each do |child|
            active_trails += TrailDirective.new(child, :down)
          end
          
        elsif directive.direction == :down
          if not visited.include?(directive.variable)
            # blah! (31)
          end
          # blah! (32)
        end
      end
    end
  end
  
end


