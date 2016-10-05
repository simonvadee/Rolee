# Rolee

iOS project KB-50vt - Iris Poot, Ammar Polat, Tijmen Wiegmans, Simon Vadée
==========================================================================

Schedule :
----------

week 1 -
* Wireframes
* Sitemap
* Class diagram
* App skeleton (implementation sitemap)
* Logo

week 2 -
* UI
	- home (=main)
	- success/fail level
	- settings
* Code
	- Game object -> start game, create ball, create holes, create win exit
* Documentation/unit tests
	- setup test module
	- document 'Game' object.

week 3 -
* UI
	- ball(s)
	- hole(s)
	- exit
	- loading screen
* Code
	- Ball object -> move, collisions
	- Game object -> win game, lose game
	- start Player object (to prepare GameCenter handling) -> id, apple account, auth
* Doc/tests
	- document Game object, Ball object and Player object
	- create a unit test for each class, testing each method
           
week 4 - 
* UI
	- design more levels (backgrounds)
	- design more balls/holes
	- scoreboard
* Code
	- Ball object (if not finished) -> moves, collisions
	- GameCenter integration : publish score on scoreboard, check other players' score
* Doc/test
	- document GameCenter mechanism
	- test scoreboard
