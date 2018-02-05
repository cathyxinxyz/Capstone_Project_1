library(plotly)
library(maps)
library(dplyr)
library(ggplot2)

county_df <- map_data("county")
state_df <- map_data("state")

full_df <- read.csv("C:/Users/cathy/Capstone_project_1/Datasets/Combined_data_new.csv")
#rownames(df) <- df$FIPS

state_county_name<-read.csv("C:/Users/cathy/Capstone_project_1/Datasets/geography/state_county_codes_names.csv")

#state_county_name$FIPS
#rownames(state_county_name)<-state_county_name$FIPS
data<-subset(full_df, select = c("FIPS", "Division"))
county_fips<-subset(state_county_name, select = c("State_name", "FIPS", "county_name"))
county_fips$State_name<-tolower(county_fips$State_name)

df<-merge(data, county_fips, by='FIPS')

df$county_name
df$county_name %<>%
  gsub(" County", "", .) %>%
  gsub(" county", "", .) %>%
  gsub(" parish", "", .) %>%
  gsub(" ", "", .) %>%
  gsub("[.]", "", .)

df$county_name<-tolower(df$county_name)

county_df$subregion <- gsub(" ", "", county_df$subregion)

colnames(df)<-c("FIPS","Division","region","subregion")

choropleth <- inner_join(county_df, df, by = c("region", "subregion"))
choropleth <- choropleth[!duplicated(choropleth$order), ]

p <- ggplot(choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = Division), 
               colour = alpha("white", 1/2), size = 0.1)  +
  geom_polygon(data = state_df, colour = "white", fill = NA) +
  scale_fill_manual(values = c('blue','red','yellow','pink','orange','green','turquoise', "darkmagenta", "salmon"))+
  theme_void()
print(p)
