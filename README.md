# README

Attempting to make the party game "Mafia" in Ruby-on-Rails

### TODO
* ~~There is a great deal of duplicate code in the show html.erb file for "games". Let's look into a way to cut this down.~~
* The way we are doing role assignment is a little wonky.
* The player patch contains game phase update logic. Ruby has something analogous to a service class, let's look into that.
* ~~More robust action choices~~
    * ~~We may want to give options such as the mafiosi being given a second chance to choose a target if they fail to reach consensus~~
* Track what happened each round
* Clean up games some time after they have ended
* ~~Display username for logged-in user~~
* ~~New user registration~~
* Am I using variables correctly in the controllers?
* ~~Handle tie on daytime votes~~
    * ~~Currently if two villagers get exactly 50% of the votes one will be chosen arbitrarily by the server~~
* Set up config to limit number of concurrent games