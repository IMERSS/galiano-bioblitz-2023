library(dplyr)
library(plotly)

# Load data
source("scripts/loadData.R")

# Vector of plant families
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
  summarise(Count = n()) %>%
  ungroup()

# Ensure Family is a factor ordered alphabetically (reversed order for plotting top-to-bottom)
agg_data$Family <- factor(agg_data$Family, levels = rev(sort(unique(agg_data$Family))))

# Generate the stacked bar plot with horizontal bars
stacked_bar_plot <- plot_ly(data = agg_data, y = ~Family, x = ~Count, color = ~Status, type = 'bar', 
                            orientation = 'h',  # Set orientation to 'h' for horizontal bars
                            colors = c('confirmed' = '#5a96d2', 'historical' = '#decb90', 'new' = '#7562b4'),
                            text = ~paste(Status, ": ", Count),
                            hoverinfo = 'text') %>%
  layout(barmode = 'stack', 
         xaxis = list(title = 'Count'),  # Count on the x-axis
         yaxis = list(title = 'Family'),  # Family on the y-axis
         title = 'Species Reporting Status by Family')  # Main title for the figure

# Show the figure
stacked_bar_plot
