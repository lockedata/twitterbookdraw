Produce a visualization of the winner of the book of the month
==============================================================



# March code

[Here](code.R)

# April code

[Here](code_with_particles.R)

* Install dependencies stated in [DESCRIPTION](DESCRIPTION)

* Prepare [`rtweet` authentication](http://rtweet.info/articles/auth.html).

* Run and change the random seed in set.seed if the winner is a previous winner or someone who works for Locke Data or a bot.

* Also tweak if the winner name is too long. Tweak `par(bg = "#2165B6", family = "contrail", cex = 1.7)` with a different value of `cex` (text size) and `legend(-52, 0` with a different position (x, y, with the origin being somewhere in the middle, sorry haven't thought about it more). When tweaking make `evolve(120` `evolve(1` this way it's faster. It shows only the first frame, and the book should hide the name.

# May code

[here](R/1st_may_code.R)

# Future plans

* Make it a package

* Winner drawing would be a separate function (and could use a black list made of people working for Locke Data, and could also use Mike Kearney's `botornot` to see if an account is likely to be a bot, in order to warn the person running the code)

* Add the data about previous winners to the package
