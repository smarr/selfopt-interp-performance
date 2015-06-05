options(scipen=5)

# prints stack trace on error, from: http://stackoverflow.com/a/2000757/916546
options(warn = 2, keep.source = TRUE, error = 
  quote({ 
    cat("Environment:\n", file=stderr()); 

    # TODO: setup option for dumping to a file (?)
    # Set `to.file` argument to write this to a file for post-mortem debugging    
    dump.frames();  # writes to last.dump

    #
    # Debugging in R
    #   http://www.stats.uwo.ca/faculty/murdoch/software/debuggingR/index.shtml
    #
    # Post-mortem debugging
    #   http://www.stats.uwo.ca/faculty/murdoch/software/debuggingR/pmd.shtml
    #
    # Relation functions:
    #   dump.frames
    #   recover
    # >>limitedLabels  (formatting of the dump with source/line numbers)
    #   sys.frame (and associated)
    #   traceback
    #   geterrmessage
    #
    # Output based on the debugger function definition.

    n <- length(last.dump)
    calls <- names(last.dump)
    cat(paste("  ", 1L:n, ": ", calls, sep = ""), sep = "\n", file=stderr())
    cat("\n", file=stderr())

    if (!interactive()) {
      q(status=1) # indicate error
    }
  }))


source("libraries.R",   chdir=TRUE)

do_load <- function(file_name) {
  data <- load_data_file(file_name, row_names)
  data <- data[relevant_columns]
  data <- prepare_vm_names(data)
  data <- prepare_exp_names(data)
  
  ## Add a time series id
  data <- ddply(data, timeseries_formulae, transform,
                Iteration = rid - min(rid))
  data
}

data <- do_load(data_file)
#data <- do_load(data_file)
#data2 <- do_load(data2_file)
#data3 <- do_load(data3_file)

