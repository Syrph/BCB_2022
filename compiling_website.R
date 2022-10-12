###############################################################################
              #### Script for compiling the website ####


# This is an automatic script that should take R markdown documents, and convert
# them into a github markdown for publishing online. First it takes Rmd files
# and converts them into github markdown, so that it can be published. Because
# we include myst markdown formats (tips, images etc.) we have to use gsub on the
# markdown output to replace them with the correct fancy formatting. In particular,
# images are converted into myst formatting using a while loop, so that we can control
# the size and alignment. This could be done manually, but then we would have to redo
# every image after updating the Rmd files. We also generate R script files that can
# be given to demonstrators.

# After processing, I use the Windows Subsystem for Linux (WSL) to build the html
# site, using the ubuntu package jupyter-book. Then I push everything to my github,
# and then push the built html to the github pages. Do not edit the pages on github
# if you push this way, as it will remove an edits. It should be edited on the Rmd
# or md files on your laptop before pushing. I never pull anything from github for this.

# To update the practicals in the command line I first build the new book:
# jupyter-book build bcb_notebook_2021
# cd bcb_notebook_2021
# ghp-import -n -p -f _build/html

# Load libraries.
library(rmarkdown)
library(knitr)

# Make sure the working directory is where the script is saved.
getwd()




################################################################################
              # Convert .Rmd to .md using myst formatting #


##### Practical 1 #####

# Render the practical .Rmd as an .md with github formats.
render("markdowns/practical_1/practical_1.Rmd", md_document(variant = "gfm"))

# Read in the markdown.
prac_1_markdown  <- readLines("markdowns/practical_1/practical_1.md")

# Place curly brackets around the tips so that they match myst formatting.
prac_1_markdown <- gsub(pattern = "``` tip", replace = "```{tip}", x = prac_1_markdown)

# Images come out in the old school markdown formatting that we want to change to myst.
# We first change the first part of the line to replace with myst (easy bit).
prac_1_markdown <- gsub(pattern = "![](", replace = "```{image} ", x = prac_1_markdown, fixed = TRUE)

# This is quite hacky.
# We now find the lines of the text that have the end of the image we need to replace.
indexs <- grep(")<!-- -->", prac_1_markdown)

# Loop through these lines.
while(length(indexs > 0)){

  # First we remove the end of the line. We use fixed because there's some regexy stuff in there.
  prac_1_markdown[indexs[1]] <- gsub(pattern = ")<!-- -->", replace = "", x = prac_1_markdown[indexs[1]], fixed = TRUE)

  # Myst needs formatting on new lines. So we c() the new lines in which seems to work well enough!
  # We do this so we can center the images, and set the size so they aren't too big.
  prac_1_markdown <- c(prac_1_markdown[1:indexs[1]], ":align: center", ":width: 600px", "```", prac_1_markdown[(indexs[1]+1):length(prac_1_markdown)])

  # Reset the index for the next one. Also changed now we've added new lines!
  indexs <- grep(")<!-- -->", prac_1_markdown)
}

# Export the markdown, now with lovely Myst formatting!
writeLines(prac_1_markdown, con="markdowns/practical_1/practical_1.md")


##### Practical 2 #####

# Same code with some extra formatting after loop.
render("markdowns/practical_2/practical_2.Rmd", md_document(variant = "gfm"))
prac_2_markdown  <- readLines("markdowns/practical_2/practical_2.md")
prac_2_markdown <- gsub(pattern = "``` tip", replace = "```{tip}", x = prac_2_markdown)
prac_2_markdown <- gsub(pattern = "![](", replace = "```{image} ", x = prac_2_markdown, fixed = TRUE)
indexs <- grep(")<!-- -->", prac_2_markdown)
while(length(indexs > 0)){
  prac_2_markdown[indexs[1]] <- gsub(pattern = ")<!-- -->", replace = "", x = prac_2_markdown[indexs[1]], fixed = TRUE)
  prac_2_markdown <- c(prac_2_markdown[1:indexs[1]], ":align: center", ":width: 600px", "```", prac_2_markdown[(indexs[1]+1):length(prac_2_markdown)])
  indexs <- grep(")<!-- -->", prac_2_markdown)
}

# This adds the myst formatting for manually adding in a image (memes!) from file.
# Reminder: Add more memes!
prac_2_markdown <- gsub(pattern = "``` image", replace = "```{image} ../../memes/monster_for_loop.png", x = prac_2_markdown)

# Maths equations come out weird as normal so we myst them!
prac_2_markdown <- gsub(pattern = "``` math", replace = "```{math}", x = prac_2_markdown)
writeLines(prac_2_markdown, con="markdowns/practical_2/practical_2.md")




##### Practical 4 #####

# Last one.
render("markdowns/practical_3/practical_3.Rmd", md_document(variant = "gfm"))
prac_3_markdown  <- readLines("markdowns/practical_3/practical_3.md")
prac_3_markdown <- gsub(pattern = "``` tip", replace = "```{tip}", x = prac_3_markdown)
prac_3_markdown <- gsub(pattern = "![](", replace = "```{image} ", x = prac_3_markdown, fixed = TRUE)
indexs <- grep(")<!-- -->", prac_3_markdown)
while(length(indexs > 0)){
  prac_3_markdown[indexs[1]] <- gsub(pattern = ")<!-- -->", replace = "", x = prac_3_markdown[indexs[1]], fixed = TRUE)
  prac_3_markdown <- c(prac_3_markdown[1:indexs[1]], ":align: center", ":width: 600px", "```", prac_3_markdown[(indexs[1]+1):length(prac_3_markdown)])
  indexs <- grep(")<!-- -->", prac_3_markdown)
}
prac_3_markdown <- gsub(pattern = "``` math", replace = "```{math}", x = prac_3_markdown)
writeLines(prac_3_markdown, con="markdowns/practical_3/practical_3.md")




################################################################################
         # Convert to R scripts you can hand to demonstrators #


# Turn the markdowns into scripts. Not sure how it'll work with toggle stuff.
purl("markdowns/practical_1/practical_1.Rmd", output = "scripts/practical_1.R")
purl("markdowns/practical_2/practical_2.Rmd", output = "scripts/practical_2.R")
purl("markdowns/practical_3/practical_3.Rmd", output = "scripts/practical_3.R")

# Let you know when it's done.
beepr::beep(4)

