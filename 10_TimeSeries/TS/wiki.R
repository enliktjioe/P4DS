library(wikipediatrend)
jokowi_en <- wp_trend(page="Joko_Widodo", from="2015-01-01", to="2018-08-31", lang="en")
jokowi_id <- wp_trend(page="Joko_Widodo", from="2015-01-01", to="2018-08-31", lang="id")

jokowi_combined <- data.frame(
  cbind(jokowi_en[,-2], jokowi_id[,"views"])
)
names(jokowi_combined)[7:8] <- c("en_views", "id_views")

write.csv(jokowi_combined, "data_input/wikiviews.csv", row.names = FALSE)