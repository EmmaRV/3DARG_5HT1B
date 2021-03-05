adjust_size <- function(filepath, sourcefilename, targetfilename, newfilename, checkLines = F) {
  
  # install.packages("XML")
  # install.packages("methods")
  
  library("XML")
  library("methods")
  
  setwd(filepath)
  
  underscore_sfn <- grepRaw(x = sourcefilename, pattern='_')
  sourcenametag <- substr(x = sourcefilename, start = 1, stop=(underscore_sfn+7))
  
  target_xml <- xmlParse(targetfilename)
  rootnode_target <- xmlRoot(target_xml)
  node_target <- rootnode_target[["t2_layer_set"]]
  attr_target <- xmlAttrs(node_target)

  source_xml <- xmlParse(sourcefilename)
  rootnode_source <- xmlRoot(source_xml)
  node_source <- rootnode_source[["t2_layer_set"]]
  attr_source <- xmlAttrs(node_source)

  node_source_new <- node_source

  addAttributes(node_source_new, "layer_height" = attr_target[[8]], append = TRUE)
  addAttributes(node_source_new, "layer_width" = attr_target[[7]], append = TRUE)
  
  replaceNodes(node_source, node_source_new)
    
  attr_source_new <- xmlAttrs(node_source_new)
  print('width')
  print(attr_source[[7]])
  print(attr_target[[7]])
  print(attr_source_new[[7]])

  print('height')
  print(attr_source[[8]])
  print(attr_target[[8]])
  print(attr_source_new[[8]])

  saveXML(source_xml, file = newfilename)
    
  rm(list=ls())
 
}
