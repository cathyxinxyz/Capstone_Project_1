library(plotly)
library(maps)
library(dplyr)
library(ggplot2)
library(devtools)
library(RColorBrewer)

county_df <- usmap::us_map(regions = "counties")
states_df <- usmap::us_map()

df <- read.csv("C:/Users/cathy/Capstone_Project_1/Datasets/combined.csv")
df_group<-read.csv("C:/Users/cathy/Capstone_Project_1/Datasets/diabetes_obesity_groups.csv")
#rownames(df) <- df$FIPS

#cluster_group <-read.csv('C:/Users/cathy/Capstone_project_1/Datasets/cluster_groups_diabetic_obese.csv', sep=',',header=T,stringsAsFactors=FALSE)
transform<-function (x) {if (x<=9999) {paste('0',as.character(x),sep='')} else {as.character(x)}}
#state_county_name<-read.csv("C:/Users/cathy/Capstone_project_1/Datasets/state_county_name.csv",sep=',',stringsAsFactors=FALSE)

#state_county_name$FIPS
#rownames(state_county_name)<-state_county_name$FIPS
data<-subset(df, select = c("FIPS", 'prevalence.of.diabetes'))
df_group<-df_group[df_group$groups=='only obese',]
colnames(data)<-c('fips', 'disease')
colnames(df_group)<-c('fips','groups')
data$fips<-sapply(data$fips, transform)
df_group$fips<-sapply(df_group$fips, transform)
#county_fips<-subset(state_county_name, select = c("State", "FIPS", "County"))

choropleth <- full_join(county_df, data, by = c('fips'))
db_county<- county_df[county_df$fips %in% df_group$fips, ]

choropleth <- choropleth[!duplicated(choropleth$order), ]


colors=c("cluster_1"='yellow',
         "cluster_2"='green',
         "cluster_3"='red',
         "cluster_4"='turquoise',
         "cluster_5"='purple',
         "cluster_6"='pink',
         "cluster_7"='orange',
         "cluster_8"='grey',
          "cluster_9"='blue')

colors=c("cluster_0"='lightgrey',
         "cluster_1"='yellow',
         "cluster_2"='red',
         "cluster_3"='purple')

library(scales)


p <-  ggplot(choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill =disease),colour = alpha("white", 1/2), size = 0.1)  +
  scale_colour_gradient2()+
  geom_polygon(data = state_df, colour = "black", fill = NA) +
  geom_polygon(data = db_county, aes(x=long, y=lat, group = group), fill = NA, color = "yellow")+
  
  #scale_fill_manual(values = colors)+
  theme_void()
print (p)

#p<-p+scale_colour_gradient2(low=muted("red"), high=muted("blue"))

p <- ggplotly(p, tooltip = 'text') %>% 
  layout(
    hovermode = 'x',
    margin = list(
      t = 20,
      b = 20,
      l = 20,
      r = 20),
    legend = list(
      orientation = 'v',
      x = 1.2,
      y = 0.4,
      xanchor = 'center'))
      
print (p)
