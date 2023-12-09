# Background

A general idea of the Mandelbrot set.

## Overview

This article gives you an idea of what the Mandelbrot set is.

![Example](mandart_a02.png)

## Discussion

### MandArt app

This is an art app, not a math app, so there won't be any equations.
We initially set out to develop an app that would generate pictures good enough to be printed, framed, and hung.
Since then, we realized that printers can't show nearly the full range of colors that are available on a computer, so now it is more of a computer app.
The pictures can also display well on a TV screen.

### Welcome Screen

The app opens with the window shown below.

![Welcome Screen](WindowWelcome.png)

Click where indicated and a new window pops up as shown below.

![Mandelbrot](MandArtDefaultExample.png)

Only the upper-left part of the window shows up, so move the window up and left.
Then, grab the lower-right corner of the window and move it down and right so you can see the whole picture.

### Mandelbrot and Mini-Mands

This picture shows us the region where the action will take place. 
The black area is the major part of the Mandelbrot set, 
but around it are an infinite number of smaller, distorted, versions of that part,
which we can't see unless we zoom in. 
Since we will keep referring to these objects, 
we’ll call the black area in the picture the **Mandelbrot**. 
The other versions of it that we'll see later we’ll call **Mini-Mands**.

The center of the Mandelbrot universe is somewhere inside the Mandelbrot. The exact location isn't important to us.

At every pixel location in the picture, the app uses a fairly simple formula to calculate a new location and keeps on finding new locations until one of two things happens.

If the new location is far enough from the center of the Mandelbrot universe, the app stops and remembers that number of tries.

If the number of tries reaches some maximum defined value without reaching the distance limit, it remembers that number of tries.

The app uses those remembered of tries to help define a color for that location.

If we just used the recorded number of tries at each location to define a color, we'd get bands of color in the picture.
We would need another bit of information to adjust the integer number of tries to something like a fractional number of tries, but how?

It has been proven that any time a location exceeds a distance of two from the center of the Mandelbrot universe, the following tries will rapidly move out to infinity.
But there is a maximum distance that the next try can reach.
We can use that information to define a fraction to tack onto the recorded value of number of tries.
That allows us to vary the colors in the picture from pixel to pixel by such a small amount that we can't notice it.

