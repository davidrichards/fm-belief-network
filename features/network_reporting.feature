Feature: Reporting on a network

  Scenario: Query a CPT directly
    Given a basic graph
    And a target populated cpt
    When I use the CPTReporter context with a cpt
    And I pass it an exact query
    Then I should get accurate query results

