library(dplyr)
library(tidyr)

ComputeDistance <- function(a,b){
  library(philentropy)
  
  genA <- a[5:23]
  genB <- b[5:23]
  genreDist <- distance(as.matrix(rbind(genA,genB)), method = "jaccard")
  
  popA <- a[2:3]
  popB <- b[2:3]
  popDist <- distance(as.matrix(rbind(popA,popB)), method = "euclidean")
  return(genreDist + popDist)
  
}

getNeigbors <- function(title, K){
  for(i in 1:nrow(movies.rat.views)){
    if(i==1){
      dist <- ComputeDistance(movies.rat.views[movies.rat.views$title==title,],movies.rat.views[i,])
    } else {
      dist <- c(dist, ComputeDistance(movies.rat.views[movies.rat.views$title==title,],movies.rat.views[i,]))
    }
  }
  movies.rat.views$distance <- dist
  head(arrange(movies.rat.views[,c("title","distance")], distance),K)
}

ratings <- read.csv('C:/Users/teama/Downloads/DataScience-Python3/ml-100k/u.data', sep = '\t')[,1:3]
names(ratings) <- c("movie_id","user_id","rating")

movies <- read.csv('C:/Users/teama/Downloads/DataScience-Python3/ml-100k/u.item', sep = '|')[,c(1,2,6:24)]
names(movies) <- c("movie_id","title", seq(19))

ratings <- ratings %>% left_join(movies, by="movie_id") %>% filter(!is.na(title))


movies.rat.views <- ratings %>% 
  group_by(title) %>% 
  summarise(rating = mean(rating),
            reviews = n()) %>% 
  left_join(movies, by="title") %>% 
  glimpse()

movies.rat.views$rating <- scale(movies.rat.views$rating)
movies.rat.views$reviews <- scale(movies.rat.views$reviews)

getNeigbors("Titanic (1997)",10)