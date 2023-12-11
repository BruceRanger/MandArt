# Choosing Colors

Choose a small, ordered, set of colors to work with

## Overview

You have to pick the the colors to be used in the picture and see if the gradient between adjoining colors looks good to you.
![Example](mandart_a03.png)

## Discussion

### Picking Colors

This app uses the RBG color model, which uses red, green (actually lime), and blue componenents to define the color of a given pixel on the screen.
Each component has a range of 0 to 255.
The R, G, and B components can be thought of as forming a cube.
The pre-selected six colors shown are the six corners of the color cube, without the black and white corners.

### Checking the gradient between adjacent colors

The app makes a smooth gradient between adjacent colors.
You can see what that gradient will look like by selecting a color number in the "From:" box.
The app automatically chooses the next  higher color number and shows a picture of that color gradient.
Depending on the colors chosen, the gradient may pass through a region of color that doesn't look good to you.
In that case, you'll have to change one or both colors, or put in an intermediant color.

### Changing Colors

To change one of the existing colors, click in the colored box.
A color picker will pop up and you have a number of ways to define the new color.
To the right of a colored box, there might be a button with an exclamation point in a circle.
If you click on that button, you'll get a warning that the color might not print very well.
You can adjust the color to make the warning disappear or just ignore it.
Predicting how true a given color will print is far beyong the scope of this app.

As noted, you can click on and drag a color number to reorder the colors.

You can click on the "Add New Color" box to get a new coloe.
The color will be white and will go at the end of the color list.
Then you can change the color and its place in the list.

### Color popups

An easy way to add a color is to select one of the 12 buttons that will bring up a popup with a array of colors to select from.

The popups are based on a selection of 512 colors that look good on the screen. 
These colors only use R, G, and B values of 0, 36, 73, 109, 146, 182, 219, and 255, 
but it is difficult to distinguish between adjacent colors, so they may be adequate.

And, of course, the colors can be changed to look better to the artist.

### 

### Color Profile

To get the printable colors to work, you may need to adjust your Color Profile.

Open System Settings / Displays / Color Profile - and on the drop-down, 
select the sRGB option as shown below. 

![Color Profile](SystemSettings-Displays-ColorProfile-sRGB.png)

### Visible Scroll Bars

There's typically a scroll bar on the right side of the input area,
unless your monitor is tall enough to see all the inputs without it. 

If you'd like to make your scrollbar visible all the time 
(rather than just when working in the input area), you'll use
Mac settings again.

Open System Settings / Appearance / Show Scroll Bars - and select always.

![Show Scrollbars](SystemSettings-Appearance-Scrollbar.png)

### Exploration

For help getting started see <doc:A01-GettingStarted>.

Learn about all the ways to explore custom MandArt at <doc:A02-SettingInputs>.

Read more about the math and the Mandlebrot set at <doc:A04-MoreAboutTheMath>.


