row_names <- c("TimeStamp", "Value", "Unit", "Criterion", "Benchmark",
               "VM", "Suite", "Extra", "Warmup", "Cores", "InputSize",
               "Var")
relevant_columns <- c("Value", "Unit", "Benchmark", "VM", "Suite", "Var", "Cores", "Extra", "rid")

timeseries_formulae <- ~ Benchmark + VM + Var + Extra + Cores

# TODO: should also configure the benchmark names and VM names, etc...
