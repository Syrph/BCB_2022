---
title: ""
permalink: /Intro/
excerpt: ""
last_modified_at: 2020-07-27
redirect_from:
  - /theme-setup/
layout: single
classes: wide
sidebar:
  nav: docs
---


## Introduction


The practicals for Biodiversity and Conservation Biology aim to introduce basic concepts and skills to conduct macroecology research. Each practical will introduce new skills using the computing language `R`, popular among ecologists. Most focus is on phylogenetic methods used in comparative analysis between species, but you will also learn the basics of GIS in `R`, a highly valued skill in research and conservation.


### Getting started

There is a single zip folder containing all the data for the practicals that you should download first (ideally before the first practical). This also contains the install.R script that will help set up your `R` session for macroecology research.

Mac users may need to install `GDAL` on their laptop. This is software for 
handling spatial data, which R uses and is preinstalled on Windows. This can be 
installed from the Mac terminal using homebrew:

First install homebrew if you haven't by copying this code into your terminal:

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

Then install GDAL by running this code:

`brew install gdal`

Don't be afraid to ask for help installing homebrew if you need it for a mac! 

### Practical layout

Practicals will be in the format of notebooks, split into text sections and 
blocks of code. Each block of code looks like this:
  
```
print("hello world")
```

You should *type* each block of code into your own `RStudio` environment rather 
than copying and pasting. You will learn much more from manually typing, because 
every typo is a chance to learn, so try not to be tempted! 

There will also be tips to pay attention to! They will look like this:

```{tip}
This is a tip
```

Here is your first and most important tip!

```{tip}
**Don't get stressed!**  
Coding is hard! It's okay to not understand everything straight away. Even the most experienced coders make easy mistakes all the time. These practicals are meant to help you begin to build the skills needed for macro-ecology, but they are just the start. Most importantly, **you won't be assessed on your ability to code**, so there's no need to worry! 
```
```{image} memes/using_r.jpeg
:align: center
:width: 600px
```  
<br /><br />  

There will also be some extra tasks where you can try your own coding, with a hidden example you can see if you're stuck.

::::{admonition} Show the answer...    
:class: dropdown

There's no correct answer as long as the code works!

::::


```{tip} 
**Google is your friend!**  
If you get stuck, don't be afraid to google your problem! Demonstrators will be on hand to help out, but sometimes you can learn the most from taking a second to think about the problem, and then search online. Most ecologists can't remember most of their code, and constantly google "how to ... in R" on a daily basis! Learning how to search effectively will be a valuable skill in your academic journey!
```
