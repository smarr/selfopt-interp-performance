## This file defines common functions used for data processing.

load_data_file <- function (file, row_names) {  
  bench <- read.table(file, sep="\t", header=FALSE, col.names=row_names, fill=TRUE)
  bench$rid = seq_len(nrow(bench))
  bench
}

prepare_vm_names <- function(data) {
  name_map <-     list("Java"                  = "Java",
                       "PyPy"                  = "PyPy",
                       "RPySOM-recursive-jit"  = "RPySOM",
                       "RPySOM-jit"            = "RPySOM",
                       "RTruffleSOM-jit"       = "RTruffleSOM",
                       
                       "TruffleSOM-graal"      = "TruffleSOM",
                       "TruffleSOM-graal-no-split" = "TruffleSOM.ns",
                       "SOMpp"                 = "SOM++")
  # Rename
  levels(data$VM)  <- map_names(
    levels(data$VM),
    name_map)
  data
}

prepare_exp_names <- function(data) {
    name_map <- list("baseline"                               = "baseline",
                     "without-args-in-frame"                  = "typed args",
                     "without-array-strategies"               = "array strategies",
                     "without-blocks-without-context"         = "min. escaping closures",
                     "without-catch-nonlocal-return-node"     = "catch-return nodes",
                     "without-control-specialization"         = "lower control structures",
                     "without-custom-PICs"                    = "inline caching",
                     "without-eager-primitives"               = "inline basic ops.",
                     "without-execute-void"                   = "opt. side-effect-free",
                     "without-global-caching-and-opt"         = "cache globals",
                     "without-local-nonlocal-var-distinction" = "opt. local vars",
                     "without-object-layout"                  = "typed fields",
                     "without-splitting-frame-variables"      = "min. escaping vars",
                     "without-unessential-lowering-prims"     = "lower common ops",
                     "without-var-access-specialization"      = "typed vars")
    levels(data$Var) <- map_names(levels(data$Var), name_map)
    data
}

map_names <- function(old_names, name_map) {
  for (i in 1:length(old_names)) {
    old_name <- old_names[[i]]
    if (!is.null(name_map[[old_name]])) {
      old_names[i] <- name_map[[old_name]]
    }
  }
  old_names
}
