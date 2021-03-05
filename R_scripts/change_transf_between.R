change_transf_between<- function(filepath, sourcefilename, targetfilename, newfilename, checkLines = F) {
  
  # install.packages("XML")
  # install.packages("methods")
  
  library("XML")
  library("methods")
  
  setwd(filepath)
  
source_xml <- xmlParse(sourcefilename)
rootnode_source <- xmlRoot(source_xml)
node_source <- rootnode_source[["t2_layer_set"]]

target_xml <- xmlParse(targetfilename)
rootnode_target <- xmlRoot(target_xml)
node_target <- rootnode_target[["t2_layer_set"]]

source_slice <- rootnode_source[[2]][[2]][[1]]
target_slice <- rootnode_target[[2]][[2]][[1]]

attr_target_slice <- xmlAttrs(target_slice) 

source_slice_new <- source_slice

addAttributes(source_slice_new, "transform" = attr_target_slice[[4]], append = TRUE)

print(source_slice_new)

replaceNodes(source_slice, source_slice_new)

saveXML(source_xml, file = newfilename)

}
