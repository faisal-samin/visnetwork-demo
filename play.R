# Read in packages

library(tidyverse)
library(visNetwork)


# Read in data ------------------------------------------------------------

nodes = read_csv(
  "got-nodes.csv",
  col_names = c("id", "label"),
  # set name of columns
  skip = 1 # skip column headers
)
  
edges = read_csv(
  "got-edges.csv",
  col_names = c("from", "to", "weight"),
  skip = 1
)
  
# preview network
visNetwork(nodes,
         edges,
         height = "500px",
         width = "100%")
  
# Add features to nodes ---------------------------------------------------
  
# add houses
# Stark - Arya, Bran, Jon, Rickon, Catelyn, Robb, Sansa, Eddard
# Lannister - Tywin, Tyrion, Jaime, Cersei
  
nodes_h = nodes %>%
  mutate(house = case_when(
    id %in% c("Arya", "Bran", "Jon", "Catelyn", "Robb", "Sansa", "Eddard") ~ "Stark",
    id %in% c("Tywin", "Tyrion", "Jaime", "Cersei") ~ "Lannister"
    ))

nodes_c = nodes_h %>%
  mutate(color = case_when(
    house == "Stark" ~ "darkred",
    house == "Lannister" ~ "gold",
    TRUE ~ "lightgrey"
  ),
  size = case_when(
    house %in% c("Stark", "Lannister") ~ 30,
    TRUE ~ 10
  ),
  font.size = case_when(
    house %in% c("Stark", "Lannister") ~ 50,
    TRUE ~ 15
  )
  )

nodes_i = nodes_c %>%
  mutate(
    shape = "image"
    ,
    image = case_when(
      id == "Arya" ~ "https://pngimage.net/wp-content/uploads/2018/05/arya-stark-png-2.png"
      )
 )


edges_l = edges %>%
  mutate(width = weight/5)
 
visNetwork(nodes_i, edges_l, width = "100%") %>%
  visNodes(shapeProperties = list(useBorderWithImage = TRUE))

