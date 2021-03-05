change_stack_size <- function(filepath, sourcefilename, targetfilename, checkLines = F) {
  
  # install.packages("XML")
  # install.packages("methods")
  
  library("XML")
  library("methods")
  
  setwd(filepath)
  
  underscore <- grepRaw(x = sourcefilename, pattern='_')
  nametag <- substr(x = sourcefilename, start = 1, stop=(underscore+1))
  newfilename = paste(nametag, "_stack_adjsize.xml", sep="") 
  
  target_xml <- xmlParse(targetfilename)
  rootnode_target <- xmlRoot(target_xml)
  node_target <- rootnode_target[["t2_layer_set"]]
  attr_target <- xmlAttrs(node_target)
  
  source_xml <- xmlParse(sourcefilename)
  rootnode_source <- xmlRoot(source_xml)
  node_source <- rootnode_source[["t2_layer_set"]]
  attr_source <- xmlAttrs(node_source)
  
  node_source_new <- node_source
  
  # Change size for whole file (can also be easily done in the GUI)
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
  
  # Change size for all single slices
    i <- (xmlSize(rootnode_source[["t2_layer_set"]]))
  
    for (j in 1:i) { 
    
    k = j+1  
    l = j+1
    
    { print(paste('slice ', j, sep="")) }
    
    slice_node_target <- rootnode_target[[2]][[k]][[1]] 
    print(rootnode_target[[2]][[k]][[1]])
    attr_slice_target <- xmlAttrs(slice_node_target)
    
    slice_node_source <- rootnode_source[[2]][[l]][[1]] 
    print(rootnode_source[[2]][[l]][[1]])
    slice_node_source_new <- slice_node_source  
    
    addAttributes(slice_node_source_new, "o_width" = attr_slice_target[[10]], append = TRUE)
    addAttributes(slice_node_source_new, "width" = attr_slice_target[[2]], append = TRUE)
    addAttributes(slice_node_source_new, "o_height" = attr_slice_target[[11]], append = TRUE)
    addAttributes(slice_node_source_new, "height" = attr_slice_target[[3]], append = TRUE)
    
    print(slice_node_source_new)
    
    replaceNodes(slice_node_source, slice_node_source_new)
    
    saveXML(source_xml, file = newfilename)
    
    rm(slice_node_target)
    rm(attr_slice_target)
    rm(slice_node_source)
    rm(slice_node_source_new)
    rm(k)
    rm(l)
  }
  
  
}
