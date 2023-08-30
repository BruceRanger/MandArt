# Care and Feeding of MandArt

## Working in XCode

- Menu / Source Control / Pull - first, before starting
- Menu / Source Control / Commit - after changes (check Push, add message)

## Time for a New Release? XCode 

- XCode / Search / "version" - update version number in 3 places:

1. MandArt / MandArt / Info.plist - Build Version
2. MandArt / MandArt / Info.plist - Bundle versions string, short
3. MandArt / MandArt / Build Settings / Marketing Version

- Menu / Product / Destination / set to "Any Mac"
- Menu / Product / Archive

It will take a while. After a few minutes, you'll see it in the Archives List. 

In the Archives List

- The new archive will be highlighted at the top of the list. (You can delete old ones.)
- Select "Distribute App".
- Select "App Store Connect". Click Next.
- Select "Upload". Click Next. It'll take a while. 
- Check both "Upload your app's symbols" and "Manage Version and Build Number". Click Next.
- Select "Automatically manage signing". Click Next. It'll take a while.
- Verify Version and Architectures (multiple). Click Upload.
- When you get the green checkmark, select "Done". 

You were successful! Now you can go to App Store Connect and submit your uploaded app as a new version. 

## App Store Connect - Submitting a New Release

- Open Safari and go to App Store Connect.
- Select "My Apps".
- Click on the "MandArt" app name.
- Click on the blue plus sign in the upper left corner (to add a new version).
- Put in the new version number (e.g. 7) and click "Create".
- Add something in the "Describe What's New" box (e.g. "New art!").
- Scroll down to the "Build Section" and click the blue plus sign.
- Select the build you just uploaded (should match the version number). Hit "Done".
- Manage missing compliance (no encryption)
- Go back to the "App Store" tab and click "Save".
- Click "Submit for Review".
