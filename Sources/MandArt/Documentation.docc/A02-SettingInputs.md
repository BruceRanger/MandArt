# Setting Inputs

Setting MandArt inputs to generate custom art.


## Overview

This article discusses each of the user-supplied inputs used to calculate MandArt.

![Example](mandart_a02.png)


## Discussion


### Mand App

This is an art app, not a math app.
It was specifically developed to generate pictures good enough to be printed, framed, and hung. 
You can completely ignore the math behind it, but it would help to have an idea of what’s going on. 
So, we’ll put all of the math at the end. 
This idea had to wait for modern computers to become available since the process requires a very great number of calculations. 
The app is written in the Swift computer language and uses SwiftUI for the interface.


### Mandelbrot and Mini-Mands

![Fig 1](Picture1.png)

Fig 1 shows us the region of the x-y plane where the action will take place. 
The black area in Fig 1 is the major part of the Mandelbrot set, but around it is an infinite number of smaller, distorted versions of that part. 
Since we will keep referring to these objects, we’ll call the black area in Fig 1 the Mandelbrot. 
The other versions of it, which we’ll see soon, we’ll call Mini-Mands.


### Welcome Screen

![Fig 2](Picture2.png)

Fig 2 shows the opening window in the app. Click on the Welcome to MandArt button.


### MandArt Main Window

![Fig 3](Picture3.png)

Fig 3 shows the window after opening. 
The window isn't big enough to show the whole picture, so draw the lower-right corner until it shows the whole picture. 


### Finding MandArt - Centering and Zooming

![Fig 4](Picture4.png)

We’ll use Fig 4 to explain centering and zooming. 

If you click anywhere in the right-hand image, 
the program will present a new image, centered on that location. 

If you press and hold the mouse button, you can drag the image. 
It will take a few seconds to recalculate and show it in the new location. 

You can zoom in or out by a factor of two by hitting the + or - buttons. 


### Customizing MandArt

A number of variables are listed in the buttons in the green area. 
You can change any of those values and hit return to use those new values. 

The screen goes blank when you start to enter any values, otherwise the program will update the image when each digit is entered. 
This is a problem that SwiftUI will solve, hopefully. 
This lets you fine-tune the image or input a set of values that you found in another reference.


### Coloring MandArt

The next set of variables relate to coloring the image. 

Default values were chosen so that the initial image would be colored. 

In order to reduce the number of colors that need to be entered, the program will cycle through the defined colors as many times as necessary. 

The region between each pair of numbers is called a block of colors. 

The program will also make a smooth gradient between each pair of colors. 

To emphasize the defined colors over the gradient colors, a slider is provided to define the fraction of a block that uses the defined color before starting the gradient. 

If a value near 1 is chosen, the blocks of colors will show up as solid bands. 

![Fig 5](Picture5.png)
