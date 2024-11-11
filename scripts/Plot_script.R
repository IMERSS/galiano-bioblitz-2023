library(plotly)

source("scripts/loadData.R")

y <- c('records')
confirmed.no <- c(nrow(confirmed))
historic.no <- c(nrow(reported))
new.no <- c(nrow(new))

reporting.status <- data.frame(y, confirmed.no, historic.no, new.no)

reportingStatusFig <- plot_ly(height = 140, reporting.status, x = ~confirmed.no, y = ~y, type = 'bar', orientation = 'h', name = 'confirmed',
                      marker = list(color = '#5a96d2',
                             line = list(color = '#5a96d2',
                                         width = 1)))

# These names need to agree with those applied as labels to the map regions
reportingStatusFig <- reportingStatusFig %>% add_trace(x = ~historic.no, name = 'historic',
                         marker = list(color = '#decb90',
                                       line = list(color = '#decb90',
                                                   width = 1)))
reportingStatusFig <- reportingStatusFig %>% add_trace(x = ~new.no, name = 'new',
                         marker = list(color = '#7562b4',
                                       line = list(color = '#7562b4',
                                                   width = 1)))
reportingStatusFig <- reportingStatusFig %>% layout(barmode = 'stack', autosize=T, height=140, showlegend=FALSE,
                      xaxis = list(title = "Species Reporting Status"),
                      yaxis = list(title = "Records")) %>% 
  layout(meta = list(mx_widgetId = "reportingStatus")) %>%
  layout(yaxis = list(showticklabels = FALSE)) %>%
  layout(yaxis = list(title = "")) %>%
  config(displayModeBar = FALSE, responsive = TRUE)

reportingStatusFig

reportingPal <- list("confirmed" = "#5a96d2", "historic" = "#decb90", "new" = "#7562b4")

# Convert taxa to named list so that JSON can recognise it
#statusTaxa <- split(x = taxa.status$taxa, f=taxa.status$status)

# Write summarised plants to JSON file for viz 
# (selection states corresponding with bar plot selections: 'new', 'historic','confirmed')
statusData <- structure(list(palette = reportingPal, mapTitle = "Map 3. Species Reporting Status"))
