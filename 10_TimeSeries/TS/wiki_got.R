library(pageviews)
got_en <- article_pageviews(project = "en.wikipedia", article = "Game_of_Thrones",
                            start = as.Date("2011-04-17"), end = as.Date("2019-03-17"))
write.csv(got_en, "data_input/wiki_got_views.csv", row.names = FALSE)

str(got_en)
