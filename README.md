# 【QBCORE ONLY】Parking your rental car in a garage - Advanced car rental script
---
# Dependencies
* [qb-core](https://github.com/qbcore-framework/qb-core)
* [qb-target](https://github.com/qbcore-framework/qb-target)
* [qb-menu](https://github.com/qbcore-framework/qb-menu)

# Installation
* Import the database in the player_vehicles table to record the rental car information
```
ALTER TABLE player_vehicles ADD COLUMN rent BIGINT NULL;
```

# Issues and Suggestions
Please use the GitHub issues system to report issues or make suggestions, when making suggestion, please keep [Suggestion] in the title to make it clear that it is a suggestion.