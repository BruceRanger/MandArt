# Tuning the Coloring of the Picture

Changing how the selected colors are applied.

## Overview

More ways to adjust the coloring of your picture.

## Discussion

### Using the color tuning sliders.

Once you've selected the colors to be used in your picture, you might think you've run out of options, but the five sliders in section B3-Tune.md can greatly change the coloring of your picture.

![Example](mandart2.jpg)

In the picture shown, you can see what appear to be flow paths starting at an edge and ending at a Mini-Mand, which may be too small to be seen.
Along a flow path, the fractional number of tries keeps increasing.

The color at any pixel location is determined solely by the recorded fractional number of tries at that location.
Near the edges, the number of tries increases slowly along a flow line, but increases very rapidly near the Mini-Mand.
The app uses a math function with two inputs to relate the change in coloring to the change in number of tries.
The first slider controls the color spacing near the edge of the picture.
The second slider controls the color spacing near the Mini-Mand.

These flow lines start well outside of the picture.
So as not to waste some of your colors on areas outside of the picture, the app finds the minimum number of tries anywhere in the picture and subtracts that number from  all of the recorded values.

You can change the number subtracted with the third slider.
If you enter a negative value, you can see where the minimum number of tries occurs by one or more white areas showing up in the picture.
If you enter a positive value, you can change what color will start the coloring in the picture.

In order to color the picture with a few defined colors, the app treats the input colors and the gradients between them as a block of colors.
You get to define the number of those blocks with the fourth slider.
When the last color of a block is used, the app goes on to the first color of the next block.
This not only allows you to only pick a few input colors, but also helps show the flow paths.

With the color smoothing used by the app, none of the defined colors actually are seen in the picture.
Every pixel will be show a color part way between the bracketing defined colors.
In order to show regions of each of the defined colors, you can use the fifth slider to hold that color for a fraction of the distance between the two bracketing colors.
If you move the slider up to 1.0, there won't be any color smoothing.

Each slider covers a range with a minimum and a maximum value.
In some cases, a number outside of that range can be entered in the button on the right.
Limits on input values will be listed in the Limits of Values article.


