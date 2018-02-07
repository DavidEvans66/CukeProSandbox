Feature: Rinkles Reportable at Secloon Level table

  Scenario: Only Rinkles marked RINKLESECLOON on the table are returned
    Given the following table of Rinkles Reportable by Secloon
      | Rinkle No | Dec No | Reportable Level |
      |    5552 |      0 | RINKLESECLOON      |
      |    5554 |      1 | RINKLESECLOON      |
      |    5555 |      1 | RINKLESECLOON      |
      |    5555 |      2 | TRANSACTION      |
      |    5555 |      3 | UNKNOWN          |
    When we Query Reportable Rinkles At Secloon Level
    Then the set of Reindeer References is
      | 5555/1                |
      | 5554/1                |
      | 5552/0                |