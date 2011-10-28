def basic_graph(context_name="ManualEntry")
  @network = Network.new
  @context = ("Fathom::" + context_name + "Context").constantize.new(@network)
  @appropriate_entries = {
    :variables => [
      {:name => :participate, :prior_odds => [0.8, 0.2]},
      {:name => :final_paper, :prior_odds => [0.7, 0.3]},
      {:name => :letter},
    ],
    :edges => [
      {:participate => :letter},
      {:final_paper => :letter}
    ]
  }

  @context.build_graph(@appropriate_entries)
  @network
end
