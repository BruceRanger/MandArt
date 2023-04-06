# Use this to generate docs for MandArt

# Before Running
# Have MandArt cloned to your local machine
# chmod +x docs.sh
# Finish making your documentation changes

# This script will:
# 1. Clone MandArt-Docs repo into MandArt parent folder
# 2. Move Documenation.docc to MandArt/Sources/Mandart
# 3. Rename Package.txt to Package.swift
# 4. Generate new documentation in MandArt/docs
# 5. Delete prior MandArt-Docs/docs folder
# 6. Copy docs folder from MandArt to MandArt-Docs
# 7. Delete generated docs folder from MandArt
# 8. Return Documenation.docc
# 9. Return Package.swift to Package.txt in MandArt
# 10. Change "Framwork" to "Application" in index.json
# 11. Git add and commit MandArt-Docs
# 12. Delete MandArt-Docs folder

echo "changing to parent folder"
cd ..

echo "cloning MandArt-Docs repo to parent folder"
git clone https://github.com/denisecase/MandArt-Docs

echo "Returning to MandArt folder"
cd MandArt

echo "Moving Documentation.docc to MandArt/Sources/Mandart"
mv Documentation.docc Sources/Mandart/

echo "Renaming Package.txt to Package.swift"
mv Package.txt Package.swift

echo "Generating new documentation"
swift package --allow-writing-to-directory ./docs \
  generate-documentation --target MandArt --output-path ./docs \
  --disable-indexing \
  --transform-for-static-hosting  \
  --emit-digest \
  --target MandArt \
  --hosting-base-path 'MandArt-Docs'

echo "Deleting prior MandArt-Docs/docs folder"
rm -r ../MandArt-Docs/docs

echo "Copying docs folder from MandArt to MandArt-Docs"
cp -R docs ../MandArt-Docs/docs

echo "Deleting generated docs folder from MandArt"
rm -r docs

echo "Returning Documentation.docc"
mv Sources/Mandart/Documentation.docc Documentation.docc
      
echo "Returning Package.swift to Package.txt"
mv Package.swift Package.txt

echo "Changing to MandArt-Docs folder"
cd ../MandArt-Docs

echo "Changing 'Framework' to 'Application' in  index.json"
sed -i '' '$/"roleHeading": "Framework"/"roleHeading": "Application"/' docs/index.json

echo "Git add and commit MandArt-Docs"
git add .
git commit -m "Update docs"

echo "Pushing MandArt-Docs to GitHub"
git push origin main

echo "Moving to parent and deleting MandArt-Docs folder"
cd ..
rm -r -rf MandArt-Docs

echo "Returning to MandArt folder"
cd MandArt
echo "Script Complete"
