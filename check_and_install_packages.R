# check and install packages
getpkg <- function(package) {
    if (!require(package, character.only = TRUE)) {
        install.packages(package)
        library(package,character.only = TRUE)
    }
}
getpkg("")