################################
## Export the object as RData ##
################################

create_output_path = function(path) {
  parts = unlist(strsplit(path, ".", fixed = T))
  parts[length(parts)] = "RData"
  output.file = paste(parts, collapse = ".")
  #output.file = gsub(x = path, pattern = "\\.[Aa-Zz]+$", replacement = "\\.RData")
  return(output.file)
}

convert_file = function(inputfile, quit_on_fail=TRUE){
  if (file.exists(inputfile) & file.size(inputfile) > 0) {
    input.table = fread(inputfile, fill=TRUE) # Fills missing values with NA
    out_path = create_output_path(inputfile)
    save(input.table, file = out_path)
    return(out_path)
  } else {
    message("Input file does not exist or is empty!!")
    if (quit_on_fail) {quit(status = 1)}
  }
}
