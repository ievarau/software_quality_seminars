# --------------- #
# Define S4 class #
# --------------- #

# This is the definition of the ProteasomeCleavage class (S4 object)
#
# 1) slots: define the slots (a.k.a. fields) included in the new class, each slot with its own class
#
# 2) prototype: default values, NA otherwise.
#
# The names in 'slots' and 'prototype' must be the same, otherwise, there will
# be an error.
setClass("ProteasomeCleavage",
         
         slots     = c(id                 = "character",
                       sequence           = "character",
                       sequence_length    = "numeric",
                       linker             = "character",
                       nb_linkers         = "numeric",
                       cleavage_threshold = "numeric",
                       nb_sites           = "numeric",
                       # new_ID             = "character",  # Uncomment for example that will fail
                       fragments_imm      = "data.table"),
         
         prototype = list(id                 = NA_character_,
                          sequence           = NA_character_,
                          sequence_length    = NA_real_,
                          linker             = NA_character_,
                          nb_linkers         = NA_real_,
                          cleavage_threshold = 0.5,
                          nb_sites           = NA_real_,
                          # new_ID2            = NA_real_, # Uncomment for example that will fail
                          fragments_imm      = data.table())
)



# Use this function to verify the data format is correct
# Ideally, you want to verify each slot
check_ProteasomeCleavage <- function(object) {
  
  # Collect error messages in this vector
  errors <- character()
  
  # ID
  length.id <- length(object@id)
  if (length.id != 1) {
    msg <- paste("ID is length ", length.id, ".  Should be 1", sep = "")
    errors <- c(errors, msg)
  }
  
  
  # Sequence
  if (!is.na(object@sequence)) {
    
    nchar.seq <- nchar(object@sequence)
    
    if (nchar.seq < 1) {
      msg <- paste("Sequence length ", nchar.seq, ".  Should be a positive integer", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  
  # Sequence length
  length.seq <- length(object@sequence_length)
  if (length.seq != 1) {
    msg <- paste("The number of sequence lengths is ", length.seq, ".  Should be 1", sep = "")
    errors <- c(errors, msg)
  }
  
  
  # Linker
  if (!is.na(object@linker)) {
    
    length.linker <- length(object@linker)
    
    if (length.linker != 1) {
      msg <- paste("The number of linkers is ", length.linker, ".  Should be 1", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  
  # Number of Linkers
  if (!is.na(object@nb_linkers)) {
    
    length.nb_linkers <- length(object@nb_linkers)
    
    if (length.nb_linkers != 1) {
      msg <- paste("The number of linker lengths is ", length.linker, ".  Should be 1", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  # Treshold
  if (!is.na(object@cleavage_threshold)) {
    
    length.cleavage_threshold <- length(object@cleavage_threshold)
    
    if (length.cleavage_threshold != 1) {
      msg <- paste("The number of thresholds is ", length.seq, ".  Should be 1", sep = "")
      errors <- c(errors, msg)
    }
    
    if (object@cleavage_threshold < 0 | object@cleavage_threshold > 1){
      msg <- paste("The threshold value is ", object@cleavage_threshold, ".  Should be between 0-1", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  
  # Number of sites
  if (!is.na(object@nb_sites)) {
    
    length.nb_sites <- length(object@nb_sites)
    
    if (length.nb_sites != 1) {
      msg <- paste("The number of sites length is ", length.nb_sites, ".  Should be 1", sep = "")
      errors <- c(errors, msg)
    }
    
    if (object@nb_sites < 1){
      msg <- paste("The number of sites value is ", object@nb_sites, ".  Should be a positive integer.", sep = "")
      errors <- c(errors, msg)
    }
    
    if (!is.integer(object@nb_sites)) {
      msg <- paste("The number of sites value is of class ", class(object@nb_sites), ".  Should be a positive integer.", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  
  # Cleavage score
  if (!length(object@cleavage_score)) {
    
    length.cleavage_score <- length(object@cleavage_score)
    
    if (length.cleavage_score < 1){
      msg <- paste("The number of cleavage scores is ", length.cleavage_score, ".  Should be a positive integer", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  
  # Fragments
  if (nrow(object@fragments_imm)) {
    
    ncol.fragments_imm <- ncol(object@fragments_imm)
    nrow.fragments_imm <- nrow(object@fragments_imm)
    
    if (nrow.fragments_imm < 1){
      msg <- paste("The number of rows in the fragments table is ", nrow.fragments_imm, ".  Should be a positive integer", sep = "")
      errors <- c(errors, msg)
    }
    
    if (ncol.fragments_imm != 6) {
      msg <- paste("The number of rows in the fragments table is ", ncol.fragments_imm, ".  Should be 6", sep = "")
      errors <- c(errors, msg)
    }
  }
  
  # In case of errors, return the collected messages
  if (length(errors) == 0) TRUE else errors
}



# Given a data.frame object (input.df), a column name (colname) and a class name (classname, optional)
# show an error message when the given colname does not exist in input.df
# Optionally, we can also verify if the class of the given column (classname) is
# similar to the one provided in the 'classname' argument
#
# No output, it will return an error message only if the colname or classname are not found
check.column.and.class.exists <- function(input.df  = NULL,
                                          colname   = NULL,
                                          classname = NULL) {
  
  input.df <- data.frame(input.df)
  
  ## First the whether the specified column exists
  colnames.df <- colnames(input.df)
  if (!colname %in% colnames.df) {
    stop("The column '", colname, "' was not found in the input table. Column names: ", paste(colnames.df, collapse = ", "))
  }
  
  ## Then check if the specified class corresponds to specified column
  ## run this pnly if the 'classname' argument is provided
  if (!is.null(classname)) {
    col.nb <- which(colnames.df %in% colname)
    class.colname.df <- class(input.df[[col.nb]])
    if (!classname %in% class.colname.df) { 
      stop("Class '", classname, "' not found. The column '", colname, "' has the following classes: ", paste(class.colname.df, collapse = ", "))
    }
  }
}



# Create a list of ProteasomeCleavage from the pepsickle results
# Expected columns in 'df' with the following names:
# 1. position
# 2. residue
# 3. cleav_prob
# 4. protein_id

CreateProteasomeCleavageFeatures <- function(in.df = NULL) {
  
  # Verify that the required columns exist
  check.column.and.class.exists(input.df = in.df, colname = "position", classname = "integer")
  check.column.and.class.exists(input.df = in.df, colname = "residue", classname = "character")
  check.column.and.class.exists(input.df = in.df, colname = "cleav_prob", classname = "numeric")
  check.column.and.class.exists(input.df = in.df, colname = "protein_id", classname = "character")
  
  # Each entry in the list corresponds to the results (all models, all tools) of a given protein ID
  # This list will be parsed and converted in a 'CleavageFeatures' object
  df.split <- split(in.df, f = in.df$protein_id)
  
  purrr::map(df.split, FillCleavageFeatureObject)
}



# Fill the CleavageFeatures object from the data.frame information
FillCleavageFeatureObject <- function(df = NULL) {
  
  # Get name
  protein.name <- unique(df$protein_id)
  
  # Get sequence
  protein.seq        <- paste0(df$residue, collapse = "")
  protein.seq.length <- nchar(protein.seq)
  
  # Cleavage scores
  cleav.score <- df$cleav_prob
  
  # This is an initialization, the remaining fields will be filled up afterwards
  seq.cleavage.features <- new("ProteasomeCleavage",
                               id               = protein.name,
                               sequence         = protein.seq,
                               sequence_length  = protein.seq.length,
                               cleavage_score   = cleav.score)
  
  # str(seq.cleavage.features)
  return(seq.cleavage.features)
}


# Define the generic
# 
# Requires two arguments:
# 1) The generic/method name
# 2) The method arguments
setGeneric("set_nb_linkers", function(x, value) standardGeneric("set_nb_linkers"))


# Define the method
#
# Requires three arguments:
#
# 1) Method name: Same name as in its corresponding 'setGeneric'
# 2) Class name: S4 class name
# 3) Arguments: similar when defining a function 
setMethod("set_nb_linkers", "ProteasomeCleavage", function(x, value) {
  x@nb_linkers <- value
  x 
  # Returns the updated version of the instance
})



setGeneric("count_linkers_in_seq", function(x) standardGeneric("count_linkers_in_seq"))

setMethod("count_linkers_in_seq", "ProteasomeCleavage", function(x) {
  
  # First claculate the number of linkers ...
  if (x@linker != "") {
    
    # The sequence and linkers are taken from the CleavageFeatures instance ('x')
    nb.linkers <- str_count(x@sequence, pattern = x@linker)
    
    # If no linker sequence is provided, then the number of linkers becomes 0 
  } else {
    nb.linkers <- 0
  }
  
  # ... then write it
  x <- set_nb_linkers(x     = x,
                      value = nb.linkers)
  
  x
})



setGeneric("set_nb_sites", function(x, value) standardGeneric("set_nb_sites"))
setGeneric("set_fragments_imm", function(x, value) standardGeneric("set_fragments_imm"))
setGeneric("get_fragments", function(x) standardGeneric("get_fragments"))


setMethod("set_nb_sites", "ProteasomeCleavage", function(x, value) {
  x@nb_sites <- value
  x 
})


setMethod("set_fragments_imm", "ProteasomeCleavage", function(x, value) {
  x@fragments_imm <- value
  x 
})


setMethod("get_fragments", "ProteasomeCleavage", function(x) {
  
  # Get the number of sites with a score equal/greater than the threshold
  sites.pos <- which(x@cleavage_score >= x@cleavage_threshold)
  nb.sites  <- length(sites.pos) 
  
  x <- set_nb_sites(x     = x,
                    value = nb.sites)
  
  
  # Get the position of the fragments
  fragments.coordinates.df <- get.fragments.coordinates(cleavage.scores = x@cleavage_score,
                                                        thr             = x@cleavage_threshold,
                                                        proteinseq      = x@sequence,
                                                        name            = x@id)
  
  x <- set_fragments_imm(x     = x,
                         value = fragments.coordinates.df)
  x
})



get.fragments.coordinates <- function(cleavage.scores = NULL,
                                      thr             = 0.5,
                                      proteinseq      = NULL,
                                      name            = "A") {
  
  # Get the index of the selected positions 
  cleavage.sites.pos = which(cleavage.scores >= thr)
  
  # Creates a basic IRanges object with the cleavage sites (each fragment is of width = 1)
  fragments.IR <- IRanges(start = cleavage.sites.pos,
                          end   = cleavage.sites.pos,
                          names = name)
  
  # Obtain the coordinates of the gaps, that is the fragments within the cleavage sites
  # We extend the ends by 1 position because the original fragments (cleavage sites of size 1)
  # are not returned when the function gaps is applied
  fragments.IR.gaps <- IRanges::gaps(fragments.IR, start = 1, end = nchar(proteinseq))
  end(fragments.IR.gaps) <- end(fragments.IR.gaps)  + 1
  end(fragments.IR.gaps) <- ifelse(end(fragments.IR.gaps) > nchar(proteinseq), yes = nchar(proteinseq), no = end(fragments.IR.gaps))
  
  
  # In some cases many cleavage sites are contiguous and they are lost after
  # we applied the function 'gaps'. 
  # The following section returns the coordinates of those contiguous cleavage
  # sites that were removed.
  #
  # 1. We inverse the gaps, to obtain the fragments that were removed/lost after applying the method 'gaps' for the 1st time
  # 2. We map the lost positions within the original set of cleavage sites (fragments.IR object)
  # 3. We retrieve the coordinates of these positions
  lost.coordinates.fragments     <- IRanges::gaps(fragments.IR.gaps, start = 1, end = nchar(proteinseq))
  lost.coordinates.fragments     <- data.frame(IRanges::findOverlaps(query = lost.coordinates.fragments, subject = fragments.IR))
  lost.coordinates.ind.fragments <- fragments.IR[lost.coordinates.fragments$subjectHits, ]
  
  # Concatenate the fragments
  cleavage.fragments.IR <- sort(c(fragments.IR.gaps, lost.coordinates.ind.fragments))
  cleavage.fragments.df <- cleavage.fragments.IR %>% 
    data.frame() %>% 
    dplyr::select(start,end, width) %>% 
    data.table()
  
  # To verify that the entire sequence is present in the coordinates
  # This must produce a single fragment, from 1 to nchar(proteinseq)
  # If 2 or more fragments are returned it is an indication there are some positions not
  # considered and this may cause problems
  merged.fragments <- IRanges::reduce(cleavage.fragments.IR)
  if (length(merged.fragments) > 1)  {
    stop("There are missing ranges in the sequence. Please verify: ", merged.fragments)
  }
  
  
  ## Add missing fragment at the C terminal (special case when the C terminal is not a cleavage sites)
  fragment.scores <- cleavage.scores[cleavage.sites.pos]
  if (length(fragment.scores) == nrow(cleavage.fragments.df) - 1) {
    fragment.scores <- c(fragment.scores, 0.5)
  }
  
  if (length(fragment.scores) != nrow(cleavage.fragments.df)) {
    stop("The number of fragments does not coincide with the number of cleavage sites.")
  }
  
  cleavage.fragments.df <- cleavage.fragments.df %>% 
    mutate(cleav_prob = fragment.scores,
           proteasome = name)
  
  # Add a column with the sequence of detected fragment
  cleavage.fragments.df$sequence <- purrr::map2_chr(.x = cleavage.fragments.df$start,
                                                    .y = cleavage.fragments.df$end,
                                                    .f = ~substr(proteinseq, start = .x, stop = .y))
  
  return(cleavage.fragments.df)
}
