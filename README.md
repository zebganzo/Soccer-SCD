Soccer-SCD
==========

A soccer simulator, written in ADA. It was developed for the Concurrent and Distributed Systems class.

Features
========

The type of match is fixed and involves two teams, 11 players per team and 7 bench-warmers. There are three main steps:

1) Team configuration - choose the formation, swap the players, change the attitude (attack - balance - defense)
2) Simulation start - the simulation runs until the end of the first half
3) Break - chance to modify the formation and make substitutions
4) Simulation continues - the second half is run, until the match ends

At the end of the match, the user has the chance of playing another game of quitting the simulation altogether.

Languages
=========

The core is ADA only. The AI part is written in Prolog, while the UI is made using Java AWT/Swing.