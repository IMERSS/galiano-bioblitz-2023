library(dplyr)
library(plotly)

# Load data
source("scripts/loadData.R")

# Vector of plant families (All families you want to include)
plant_families <- c("Pinaceae", "Sapindaceae", "Berberidaceae", "Fabaceae", "Asteraceae", 
                    "Poaceae", "Lamiaceae", "Rosaceae", "Amaryllidaceae", "Betulaceae", 
                    "Apiaceae", "Orobanchaceae", "Ericaceae", "Aspleniaceae", "Athyriaceae", 
                    "Amaranthaceae", "Asparagaceae", "Brassicaceae", "Orchidaceae", "Cyperaceae", 
                    "Caryophyllaceae", "Montiaceae", "Thymelaeaceae", "Ranunculaceae", 
                    "Dryopteridaceae", "Onagraceae", "Equisetaceae", "Geraniaceae", "Phrymaceae", 
                    "Liliaceae", "Rubiaceae", "Saxifragaceae", "Aquifoliaceae", "Caprifoliaceae", 
                    "Juncaceae", "Araceae", "Primulaceae", "Malvaceae", "Boraginaceae", 
                    "Celastraceae", "Pteridaceae", "Plantaginaceae", "Polypodiaceae", 
                    "Dennstaedtiaceae", "Fagaceae", "Grossulariaceae", "Polygonaceae", 
                    "Salicaceae", "Viburnaceae", "Crassulaceae", "Selaginellaceae", 
                    "Blechnaceae", "Taxaceae", "Cupressaceae", "Melanthiaceae", "Violaceae", "Zosteraceae")

# Combine all plant families' data in a single dataframe
combined_data <- bind_rows(
  confirmed %>% mutate(Status = 'confirmed'),
  reported %>% mutate(Status = 'historical'),
  new %>% mutate(Status = 'new')
)

# Filter data to include only selected plant families
combined_data <- combined_data %>%
  filter(Family %in% plant_families)

# Aggregate data by family and status
agg_data <- combined_data %>%
  group_by(Family, Status) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  ungroup()

# Clean and explicitly set the Family factor levels in alphabetical order
agg_data$Family <- agg_data$Family %>%
  trimws() %>%  # Remove any leading or trailing spaces
  factor(levels = sort(unique(agg_data$Family)))  # Set levels alphabetically

# Generate the stacked bar plot with horizontal bars
stacked_bar_plot <- plot_ly(data = agg_data, y = ~Family, x = ~Count, color = ~Status, type = 'bar', 
                            orientation = 'h',  # Set orientation to 'h' for horizontal bars
                            colors = c('confirmed' = '#5a96d2', 'historical' = '#decb90', 'new' = '#7562b4'),
                            text = ~paste("Family: ", Family, "<br>Status: ", Status, "<br>Count: ", Count),
                            hoverinfo = 'text', textposition = 'inside', width = 670, height = 1000) %>%
  layout(barmode = 'stack', 
         xaxis = list(title = 'Count', 
                      titlefont = list(size = 18)),  # Increase x-axis label font size
         yaxis = list(
           title = 'Family', 
           tickangle = 0, 
           autorange = "reversed",  # Reverse the y-axis and show all labels
           tickvals = agg_data$Family,  # Explicitly set the tick values
           ticktext = agg_data$Family,  # Explicitly set the tick text for y-axis
           showticklabels = TRUE,
           tickfont = list(size = 10)  # Increase font size for y-axis tick labels
         ),
         title = 'Species Reporting Status by Family', 
         font = list(size = 16),  # Increase font size for the title
         margin = list(l = 0, r = 0, t = 50, b = 100)  # Increase margins for better spacing
         )

# Show the figure
stacked_bar_plot
