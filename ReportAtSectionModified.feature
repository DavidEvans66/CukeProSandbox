Feature: Report a Risk by Section

  Scenario: Two similar Risks, one reported at Section Level, one reported at Risk Level

    Given these four Candidate Lines for three unique Reinsurance References(two lines reported at Section Level, two lines at Risk level)
    |Reinsurance Reference| Section Id| Comment|
    |5555/0-1             | 2001      |Unique reference for a Section|
    |5555/0-2             | 2002      | another unique reference for a Section|
    |6666/6               | 6001      | Unique reference for a Risk           |
    |6666/6               | 6002      | same reference as above               |

    When we Generate the Bordereau,
    Then it contains these three entries (two for the Risk reported at Section level, one for the other risk reported at Risk level)
    |Reinsurance Reference| High Level References|
    |5555/0-1             | 2001                 |
    |5555/0-2             | 2002                 |
    |6666/6               | 6001, 6002           |