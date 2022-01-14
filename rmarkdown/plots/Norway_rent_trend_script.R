library(tidyverse)

library(readr)
Norway_rent <- read_delim("rmarkdown/plots/Norway_rent.csv",
delim = "\t", escape_double = FALSE,
trim_ws = TRUE)

gg_rent<-Norway_rent %>% 
  # manual/crafty recoding for category labels
  mutate(Locations=c("Norway","Oslo and Bærum","Akershus except Bærum","Bergen","Trondheim","Stavanger",">20k","2000-19999","<1,999"))%>% 
  # Convenient reshaping for ploting
  pivot_longer(cols = where(is.numeric),names_to = "year",values_to = "average.rent") %>%
  ggplot(.,aes(year,average.rent,color=Locations,group=Location))+
  geom_line()+
  scale_color_brewer(palette="Paired")+
  theme(legend.position = "bottom")
ggsave("./rmarkdown/plots/Norway_rent_trend.png",gg_rent)
