processFunction <- function(indexIn, argument = ""){
  w <- script[(as.integer(allbounds[indexIn,1])+1):(as.integer(allbounds[indexIn,2])- 1),]
  
  if(script[titleRows[indexIn],] == "**R"){
    # Write to file and run
    file.create("runner.R")
    writeLines(as.character(w), con = "runner.R", sep = "\n",  useBytes = FALSE) # auto indents lines
    result <- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), "runner.R", argument), intern = T)
    file.remove("runner.R")
    #print(result)
    return(substring(result, 5,1000000L)) # This removes the [1] R console prefix that will mess up other funct args
  }
  if(script[titleRows[indexIn],] == "**python"){
    # Write to file and run
    file.create("runner.py")
    writeLines(as.character(w), con = "runner.py", sep = "\n",  useBytes = FALSE) 
    result <- shell(paste("python runner.py", argument), intern = T)
    file.remove("runner.py")
    #print(result)
    return(result)
    
  }
  if(script[titleRows[indexIn],] == "**js"){
    file.create("runner.js")
    writeLines(as.character(w), con = "runner.js", sep = "\n", useBytes = FALSE)
    result <- cat(shell(paste("node runner.js", argument), intern = T))
    file.remove("runner.js")
    #print(result)
    return(result)
    
  }
  if(script[titleRows[indexIn],] == "**lua"){
    file.create("runner.lua")
    writeLines(as.character(w), con = "runner.lua", sep = "\n", useBytes = FALSE)
    result <- shell(paste("lua runner.lua", argument), intern = T)
    file.remove("runner.lua")
    return(result)
  }
  if(script[titleRows[indexIn],] == "**go"){
    file.create("runner.go")
    writeLines(as.character(w), con = "runner.go", sep = "\n", useBytes = FALSE)
    result <- shell(paste("go run runner.go", argument), intern = T)
    file.remove("runner.go")
    return(result)
  }
  if(script[titleRows[indexIn],] == "**Elixir"){
    file.create("runner.exs")
    writeLines(as.character(w), con = "runner.exs", sep = "\n", useBytes = FALSE)
    result <- shell(paste("elixir runner.exs", argument), intern = T)
    file.remove("runner.exs")
    return(result)
    
  }
  if(script[titleRows[indexIn],] == "**bat"){
    file.create("runner.bat")
    writeLines(as.character(w), con = "runner.bat", sep = "\n", useBytes = FALSE)
    result <- shell(paste("runner.bat", argument), intern = T)
    file.remove("runner.bat")
    try(
      for(i in 1:length(result)){  #This is to remove the spacing & console prompt output
        if(result[i] == ""){
          result = result[-(i:(i+1))]
        }
      },
      silent=TRUE)
    return(result)
  }
  if(script[titleRows[indexIn],] == "**rust"){
    file.create("runner.rs")
    writeLines(as.character(w), con = "runner.rs", sep = "\n", useBytes = FALSE)
    shell("rustc runner.rs", intern = T)
    result <- shell(paste("runner.exe", argument), intern = T)
    
    file.remove("runner.exe") # .rs files compile into .exe and .pdb which tha can be run
    file.remove("runner.pdb")
    file.remove("runner.rs")
    return(result)
  }
}
