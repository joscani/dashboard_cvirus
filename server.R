

function(input, output, session) {
    
    # Load files with server code
    
    dir_files <- paste0(getwd(), "/server_dir")
    ficheros <- dir(dir_files, full.names = T )
    
    lapply(ficheros, function(x)
        source(x, local = TRUE)$value)

}