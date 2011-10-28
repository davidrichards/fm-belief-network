Feature: Building a network

  Scenario: Build a Network Manually
    Given a network
    When I use the ManualEntry context with a network
    And I pass it appropriate manual entries via build_graph
    Then I should get a network populated with variables and edges
    
  Scenario: Build a CPT Manually
    Given a basic graph
    And a target cpt
    When I use the CPTBuilder context with a cpt
    And I pass it appropriate manual entries via build_cpt
    Then I should get a CPT filled with the appropriate values

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
