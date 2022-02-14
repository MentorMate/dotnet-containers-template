Feature: add and subtract operations
  I want to do arithmetic operations
  
  Scenario: Add 2 numbers
    Given I open default page
     When I press '5'
      And I press '+'
      And I press '3'
      And I press '='
     Then I see '8'

  Scenario: Subtract 2 numbers
    Given I open default page
     When I press '5'
      And I press '-'
      And I press '3'
      And I press '='
     Then I see '2'
