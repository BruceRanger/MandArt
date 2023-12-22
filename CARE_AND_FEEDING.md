# Care and Feeding of MandArt

-----

## When Making Changes in XCode

1. Menu / Source Control / Pull: always pull first, before starting work
1. Menu / Source Control / Commit: after changes (check **Push**, add message)

-----

## When Making a New Release 

### 1. In XCode, Increment Build Number by 1 and Create Archive

1. XCode / Search / "version". Increment version number in 3 places:
   - Info.plist - **Build Version**
   - Info.plist - **Bundle versions string, short**
   - MandArt.xcodeproj / Build Settings / **Marketing Version**
1. Menu / Product / Destination - set to **Any Mac**
1. Menu / Product / **Archive**

It will take a while to create the build bundle. 
After a few minutes, you'll see it in the Archives List. 
The new archive will be highlighted at the top of the list. 
You can delete old ones whenever you like.

### 2. In XCode, Archives List, Upload the Build Bundle to App Store Connect

1. Click **Distribute App**. Verify "App Store Connect" is selected. 
1. Click **Next**. Verify "Upload" is selected. 
1. Click **Next**. It may take a while. Verify both "Upload your app's symbols" and "Manage Version and Build Number" are selected.
1. Click **Next**. Verify "Automatically manage signing" is selected.
1. Click **Next**. It'll take a while. Verify Architectures lists both kinds. 
1. Click **Upload**. When you get the green checkmark, you're good.
1. Click **Done**. 

You were successful! 

### 3. Go to App Store Connect and Prepare and Submit a New Release

1. Open Safari.
1. Go to **App Store Connect**.
1. Select **My Apps**.
1. Click on **MandArt app name**.
1. Click on blue plus sign in the upper left corner. A window will pop up.
1. Type new store version number (e.g. 7.1) and click **Create**.
1. Update **Describe What's New** text, other content. Screenshots must be 1440x900px.
1. Scroll down to **Build Section**. It won't appear until it finishes processing. You can see status on the TestFlight tab. When it is ready, the button will appear.
1. Click **Add Build** button. 
1. Select the incremented build bundle recently uploaded. 
1. Click **Done**.
1. Manage missing compliance (no encryption), so select "None..". Click **Save**.
1. On the "App Store" tab, click **Save** (in upper right).
1. Click **Add for Review**. 
1. Click **Submit to App Review**. Verify process is complete.

### 4. In XCode, Commit and Push the Changed Project Info to GitHub

1. XCode menu / Source Control / Commit ... check push, type message, click button to send changes to GitHub. 

-----


## Reminders

- The build / bundle must be incremented by one whole number (e.g. 7, 8, 9...)
- The marketing version number in App Store Connect can be whatever you like (e.g. 7.1)

## Screenshots (1440x900)

- Use Command + Shift 5 to set the clipped window size to 1440 x 900.
- Capture the screenshots you like. 
- Upload them in the order to display, e.g. first uploaded will appear first. 

## Source 

Source: <https://denisecase.github.io/MandArt/CARE_AND_FEEDING.html>
