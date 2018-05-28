Produce a visualization of the winner of the book of the month
==============================================================

Each month, a random [Locke Data](https://twitter.com/LockeData) follower wins a book! See it for yourself in [this Twitter moment](https://twitter.com/i/moments/982169969008918528), and follow Locke Data if you want to try and win a book next month!

Winners have always been sampled via R ( `twitteR` and now `rtweet`). Since 2018/03, the winner is announced with a fun R viz as well! This repo contains the code for such visualizations.



# Results!

## 2018-06-01

```r
# devtools::install_github("lockedata/twitterbookdraw")
# draw winner
winner <- twitterbookdraw::draw_winner()

# prepare tweet text
book <- 'An Introduction to Statistical Learning: with Applications in R'
book_url <- "http://geni.us/introtostatslearning"
twitterbookdraw::announce_winner(winner, book, book_url)

# save gif as "june.gif"
twitterbookdraw::show_june_winner(winner = winner, path = "june.gif")

```

## 2018-05-01

[Code](inst/legacy/2018-05-01-tidytext.R)

That month's creation was also described more thoroughly in [a blog post, "A particles-arly fun book draw"](https://itsalocke.com/blog/a-particles-arly-fun-book-draw/).

<blockquote class="twitter-tweet" data-lang="ca"><p lang="en" dir="ltr"><a href="https://twitter.com/SQLBob?ref_src=twsrc%5Etfw">@SQLBob</a> won <a href="https://twitter.com/juliasilge?ref_src=twsrc%5Etfw">@juliasilge</a> and <a href="https://twitter.com/drob?ref_src=twsrc%5Etfw">@drob</a> fantastic book on NLP <a href="https://t.co/DEM04WY9W4">https://t.co/DEM04WY9W4</a>! :closed_book: Bob, DM us!<br><br>&quot;Bag of followers&quot; code <a href="https://t.co/L20gPDzLj6">https://t.co/L20gPDzLj6</a> thanks to <a href="https://twitter.com/thomasp85?ref_src=twsrc%5Etfw">@thomasp85</a>&#39;s particles <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> package <a href="https://t.co/GybtPcfMMI">pic.twitter.com/GybtPcfMMI</a></p>&mdash; Locke Data (@LockeData) <a href="https://twitter.com/LockeData/status/991401888057880576?ref_src=twsrc%5Etfw">1 de maig de 2018</a></blockquote>


## 2018-04-01

[Code](inst/legacy/2018-04-01-dear-data.R)

<blockquote class="twitter-tweet" data-lang="ca"><p lang="en" dir="ltr">The winner 🏆 of our March Book 📕 giveaway is <a href="https://twitter.com/sqlStride?ref_src=twsrc%5Etfw">@sqlStride</a>! <br>Simon, you&#39;ve won a copy of Dear Data - DM us so we can get your address<br><br>📕: <a href="https://t.co/wQvFeiesaT">https://t.co/wQvFeiesaT</a><br>👩
💻: <a href="https://t.co/UZT0o5VoUv">https://t.co/UZT0o5VoUv</a> <a href="https://t.co/zmCrQwT4ZL">pic.twitter.com/zmCrQwT4ZL</a></p>&mdash; Locke Data (@LockeData) <a href="https://twitter.com/LockeData/status/980753545262661634?ref_src=twsrc%5Etfw">2 d’abril de 2018</a></blockquote>

## 2018-03-01

[Code](inst/legacy/2018-03-01-allaire.R)

<blockquote class="twitter-tweet" data-lang="ca"><p lang="en" dir="ltr">This month&#39;s book 📕 winner is <a href="https://twitter.com/kevbros93?ref_src=twsrc%5Etfw">@kevbros93</a>! 🏆<br><br>Kevin, DM us to give us your address :)<a href="https://t.co/ZPfNzJlrdD">https://t.co/ZPfNzJlrdD</a> <a href="https://t.co/zc0IePm96q">pic.twitter.com/zc0IePm96q</a></p>&mdash; Locke Data (@LockeData) <a href="https://twitter.com/LockeData/status/969167624847462400?ref_src=twsrc%5Etfw">1 de març de 2018</a></blockquote>
