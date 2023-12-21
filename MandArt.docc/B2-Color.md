# Choosing Colors

Choose a small, ordered, set of colors to work with

## Overview

In section 2.Color you get to pick the the colors to be used in the picture and see if the gradient between adjoining colors looks good to you.

## Discussion

### Picking Colors

This app uses the RBG color model, which uses red, green (actually lime), and blue componenents to define the color of a given pixel on the screen.
Each component has a range of 0 to 255.
The R, G, and B components can be thought of as forming a cube.
The pre-selected six colors shown are the six corners of the color cube, without the black and white corners. They are lime, yellow, red, magenta, blue, and cyan.

### Checking the gradient between adjacent colors

The app makes a smooth gradient between adjacent selected colors.
You can see what that gradient will look like by selecting a color number in the "From:" box.
The app automatically chooses the next  higher color number and shows a picture of that color gradient.
Depending on the colors chosen, the gradient may pass through a region of color that doesn't look good to you.
In that case, you'll have to change one or both colors, or put in an intermediant color.

To see the picture again, instead of the gradient, click on the "Display Art" button.

### Changing Colors

To change one of the selected colors, click in that colored box.
A color picker will pop up and you have a number of ways to define the new color.
To the right of a colored box, there might be a button with an exclamation point in a circle.
If you click on that button, you'll get a warning that the color might not print very well.
You can adjust the color to make the warning disappear or just ignore it.
Predicting how true a given color will print is far beyong the scope of this app.

As noted, you can click on and drag a color number to reorder the colors.

You can click on the "Add New Color" box to get a new coloe.
The color will be white and will go at the end of the color list.
Then you can change the color and its place in the list.

### Eyedropper

An interesting and useful feature of the color picker is the eyedropper.
It's near the lower-left of the color picker popup and looks like an eyedropper.

![Color Picker](ColorPicker.png)

If you click on its icon, the pointer changes to a circle with a small square in the middle.
As you move the pointer around, you see a greatly magnified view of what's under it, either within the app or outside it.

![Eyedropper Tool](Eyedropper.png)

When you click again, the color under the pointer is selected.

### Color popups

An easy way to add a color is to select one of the 12 buttons that will bring up a popup with an array of colors to select from.

The popups are based on a selection of 512 colors that look good on the screen. 
These colors only use R, G, and B values of 0, 36, 73, 109, 146, 182, 219, and 255, giving a total of 512 colors.
Thats a very small fraction of the 256 cubed = 16,777,216 colors available, but it is difficult to distinguish between adjacent colors, so they may be adequate.

And, of course, the colors can be changed to look better to the artist.

### Color Profile

To get the printable colors to work best, you may need to adjust your Color Profile.

Open System Settings / Displays / Color Profile - and on the drop-down, 
select the sRGB option as shown below. 

![Color Profile](SystemSettings-Displays-ColorProfile-sRGB.png)

### Visible Scroll Bars

There may be a scroll bar on the right side of the input area,
unless your monitor is tall enough to see all the inputs without it. 

If you'd like to make your scrollbar visible all the time 
(rather than just when working in the input area), you'll use
Mac settings again.

Open System Settings / Appearance / Show Scroll Bars - and select always.

![Show Scrollbars](SystemSettings-Appearance-Scrollbar.png)



