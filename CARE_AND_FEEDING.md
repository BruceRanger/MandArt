# Care and Feeding of MandArt

## Each Time in XCode

1. Menu / Source Control / Pull - first, before starting
1. Menu / Source Control / Commit - after changes (check Push, add message)

## Time for a New Release? 

### XCode 

1. XCode / Search / "version" - update version number in 3 places:
1. MandArt / MandArt / Info.plist - Build Version
1. MandArt / MandArt / Info.plist - Bundle versions string, short
1. MandArt / MandArt / Build Settings / Marketing Version
1. Menu / Product / Destination / set to "Any Mac"
1. Menu / Product / Archive

It will take a while. After a few minutes, you'll see it in the Archives List. 

### XCode Archives List

1. The new archive will be highlighted at the top of the list. (You can delete old ones.)
1. Select "Distribute App".
1. Select "App Store Connect". Click Next.
1. Select "Upload". Click Next. It'll take a while. 
1. Check both "Upload your app's symbols" and "Manage Version and Build Number". Click Next.
1. Select "Automatically manage signing". Click Next. It'll take a while.
1. Verify Version and Architectures (multiple). Click Upload.
1. When you get the green checkmark, select "Done". 

You were successful! Now you can go to App Store Connect and submit your uploaded app as a new version. 

### App Store Connect - Submitting a New Release

1. Open Safari and go to App Store Connect.
1. Select "My Apps".
1. Click on the "MandArt" app name.
1. Click on the blue plus sign in the upper left corner (to add a new version).
1. Put in the new version number (e.g. 7) and click "Create".
1. Add something in the "Describe What's New" box (e.g. "New art!").
1. Scroll down to the "Build Section" and click the blue plus sign.
1. Select the build you just uploaded (should match the version number). Hit "Done".
1. Manage missing compliance (no encryption) - select "None..". Hit "Save".
1. Go back to the "App Store" tab and click "Save" (in upper right).
1. Click "Add for Review". Click "Submit to App Review". Verify process is complete.

Source: https://github.com/brucehjohnson/MandArt/blob/main/CARE_AND_FEEDING.md
