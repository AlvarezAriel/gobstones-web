#!/bin/bash

echo "REMEMBER TO USE NODE 7 (nvm use >=7) - ¿ARE YOU USING IT?"
read _NOTHING_

PACKAGE_VERSION=`git describe --tags $(git rev-list --tags --max-count=1)`

function commertialName() {
  if [ "$1" == "blocks" ] ; then
    echo "jr"
  fi

  if [ "$1" == "code" ] ; then
    echo "sr"
  fi

  if [ "$1" == "teacher" ] ; then
    echo "teacher"
  fi
}

function build() {
  rm -rf ./dist/
  yarn dist --mode "$TYPE" --platform linux --arch x64 --target AppImage
  yarn dist --mode "$TYPE" --platform win --arch ia32 --target nsis
  yarn dist --mode "$TYPE" --platform win --arch x64 --target nsis
}

# ---

TYPE="blocks"
echo "BUILDING '$TYPE' WITH ELECTRON..."
build

echo "CREATING '$TYPE' ONE-FILE PACKAGES..."
LINUX_NAME_1=gobstones-$(commertialName $TYPE)-linux-$PACKAGE_VERSION.zip
WINDOWS_NAME_1=gobstones-$(commertialName $TYPE)-windows-$PACKAGE_VERSION.exe
WINDOWS32_NAME_1=gobstones-$(commertialName $TYPE)-windows-ia32-$PACKAGE_VERSION.zip
cd ./dist/linux-unpacked ; zip -r ../../$LINUX_NAME_1 . ; cd ../..
cd ./dist/win-ia32-unpacked ; zip -r ../../$WINDOWS32_NAME_1 . ; cd ../..
cp "./dist/gobstones-$(commertialName $TYPE)_$(echo $PACKAGE_VERSION)_win.exe" $WINDOWS_NAME_1
mv "$LINUX_NAME_1" node_modules/
mv "$WINDOWS_NAME_1" node_modules/
mv "$WINDOWS32_NAME_1" node_modules/

# ---

TYPE="code"
echo "BUILDING '$TYPE' WITH ELECTRON..."
build

echo "CREATING '$TYPE' ONE-FILE PACKAGES..."
LINUX_NAME_2=gobstones-$(commertialName $TYPE)-linux-$PACKAGE_VERSION.zip
WINDOWS_NAME_2=gobstones-$(commertialName $TYPE)-windows-$PACKAGE_VERSION.exe
cd ./dist/linux-unpacked ; zip -r ../../$LINUX_NAME_2 . ; cd ../..
cp "./dist/gobstones-$(commertialName $TYPE)_$(echo $PACKAGE_VERSION)_win.exe" $WINDOWS_NAME_2
mv "$LINUX_NAME_2" node_modules/
mv "$WINDOWS_NAME_2" node_modules/

# ---

TYPE="teacher"
echo "BUILDING '$TYPE' WITH ELECTRON..."
build

echo "CREATING '$TYPE' ONE-FILE PACKAGES..."
LINUX_NAME_3=gobstones-$(commertialName $TYPE)-linux-$PACKAGE_VERSION.zip
WINDOWS_NAME_3=gobstones-$(commertialName $TYPE)-windows-$PACKAGE_VERSION.exe
cd ./dist/linux-unpacked ; zip -r ../../$LINUX_NAME_3 . ; cd ../..
cp "./dist/gobstones-$(commertialName $TYPE)_$(echo $PACKAGE_VERSION)_win.exe" $WINDOWS_NAME_3
mv "$LINUX_NAME_3" node_modules/
mv "$WINDOWS_NAME_3" node_modules/

# ---

mv "node_modules/$LINUX_NAME_1" "$LINUX_NAME_1"
mv "node_modules/$WINDOWS_NAME_1" "$WINDOWS_NAME_1"
mv "node_modules/$WINDOWS32_NAME_1" "$WINDOWS32_NAME_1"
mv "node_modules/$LINUX_NAME_2" "$LINUX_NAME_2"
mv "node_modules/$WINDOWS_NAME_2" "$WINDOWS_NAME_2"
mv "node_modules/$LINUX_NAME_3" "$LINUX_NAME_3"
mv "node_modules/$WINDOWS_NAME_3" "$WINDOWS_NAME_3"

# ---

echo "DEPLOYING DESKTOP VERSION $PACKAGE_VERSION..."

echo "GIVE ME THE GITHUB TOKEN"
read TOKEN

echo "PUBLISHING..."
./node_modules/.bin/publish-release --token $TOKEN --owner gobstones --repo gobstones-web-desktop --tag "$PACKAGE_VERSION" --name "$PACKAGE_VERSION" --assets $LINUX_NAME_1,$WINDOWS_NAME_1,$LINUX_NAME_2,$WINDOWS_NAME_2,$LINUX_NAME_3,$WINDOWS_NAME_3,$WINDOWS32_NAME_1 --notes "Gobstones Web - Desktop"

echo "DONE."
