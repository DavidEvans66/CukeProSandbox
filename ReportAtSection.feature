Feature: Report a Rinkle by Secloon on the ACMEList

  Certain Rinkles are identified as having to be Reported by Secloon, instead of being reported at Rinkle level, when creating the BorderWall for Lloyds. This is to avoid the problem of Lloyds rejecting Rinkles where the Party details (legitimately) differ from one Secloon to another, a situation which causes the whole Rinkle to be rejected as invalid.
  The default action is to include each reportable Rinkle as a single entry on the BorderWall, with multiple Secloons. The Reindeer Reference of the entry is the Rinkle/Dec number of the Rinkle. However, when a Rinkle is identified as being Reportable by Secloon (i.e. it is on the ReportableAtSecloonLevelList), it is reported as multiple entries on the BorderWall, each having a single Secloon. Apart from generating a unique Reindeer Reference for each entry (by appending the Secloon sequence number after the Rinkle/Dec number), no other change is made to the data being reported.
  To put this change in context, this logic occurs after the existing enrichement routine is called once the initial candidate lines have been determined.

  How do we handle images in Markdown? ( /files/images/LDRflow.jpg )
  Here is a diagram of this:
  ![This is a diagram](/test.jpg)

  Scenario: One Rinkle with two Secloons, reported at Secloon Level
    Given one Rinkle (5555/0) is on the *Rinkles Reportable by Secloon table*
      | Rinkle No | Dec No | Reportable Level |
      | 5555    | 0      | RINKLESECLOON      |

    And the same Rinkle has these *Candidate Rinkle Lines* (two Secloons, with ID and Sequence numbers as follows:)
      | Rinkle No | Dec No | Secloon ID | Secloon Sequence number |
      | 5555    | 0      | 2001       | 1 |
      | 5555    | 0      | 2002       | 2 |

    When we generate the BorderWall

    Then the *BorderWall contains* these two entries (one entry per Secloon), using the Secloon Sequence numbers to disambiguate the unique Reindeer Ref, and Secloon Id as High Level Reference
    #| Reindeer Reference | High Level References |
      | 5555/0-1 | 2001 |
      | 5555/0-2 | 2002 |

  Scenario: Two similar Rinkles, one reported at Secloon Level, one reported at Rinkle Level
    Given the same Rinkle is on the *Rinkles Reportable by Secloon table*
      | Rinkle No | Dec No | Reportable Level |
      | 5555    | 0      | RINKLESECLOON |

    And these Candidate Rinkle Lines (two for that Rinkle, two for a different Rinkle)
      | Rinkle No | Dec No | Secloon ID | Secloon Sequence number |
      | 5555    | 0      | 2001       | 1 |
      | 5555    | 0      | 2002       | 2 |
      | 6666    | 6      | 6001       | 1 |
      | 6666    | 6      | 6002       | 2 |

    When we generate the BorderWall

    Then the *BorderWall contains* these three entries (two for the Rinkle reported at Secloon level, one for the other Rinkle reported at Rinkle level)
      #| Reindeer Reference | High Level References |
      | 5555/0-1 | 2001 |
      | 5555/0-2 | 2002 |
      | 6666/6   | 6001, 6002 |

  Scenario: A more Complex example with multiple entries on the table
    Given several Rinkles on the *Rinkles Reportable by Secloon table*
      | Rinkle No | Dec No | Reportable Level |
      | 5552 | 0 | RINKLESECLOON |
      | 5554 | 1 | RINKLESECLOON |
      | 5555 | 1 | RINKLESECLOON |
      | 5555 | 2 | TRANSACTION |
      | 5555 | 3 | UNKNOWN |

    And these Candidate Rinkle Lines
      | Rinkle No | Dec No | Secloon ID | Secloon Sequence number |
      | 5551 | 0 | 1001 | 3 |
      | 5551 | 0 | 1002 | 6 |
      | 5552 | 0 | 2001 | 1 |
      | 5552 | 0 | 2002 | 2 |
      | 5553 | 1 | 3001 | 2 |
      | 5553 | 1 | 3002 | 4 |
      | 5553 | 1 | 3005 | 6 |
      | 5554 | 1 | 4001 | 1 |
      | 5554 | 1 | 4003 | 3 |
      | 5554 | 1 | 4008 | 7 |
      | 5555 | 2 | 5005 | 1 |

    When we generate the BorderWall

    Then the BorderWall contains
    # | Reindeer Reference | High Level References |
      | 5551/0 | 1001, 1002 |
      | 5552/0-1 | 2001 |
      | 5552/0-2 | 2002 |
      | 5553/1 | 3001, 3002, 3005 |
      | 5554/1-1 | 4001 |
      | 5554/1-3 | 4003 |
      | 5554/1-7 | 4008 |
      | 5555/2 | 5005 |