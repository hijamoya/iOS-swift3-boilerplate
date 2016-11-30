#!/bin/bash
git=$(sh /etc/profile; which git)
major="2"
minor="0"
number_of_commits=$(printf "%05d" $("$git" rev-list HEAD --count))
commit_hash=$("$git" log --pretty=format:%h -n 1)
decimal=$(echo $((0x${commit_hash})))
commit_decimal=$(printf "%09d" ${decimal})
version_code="${major}.${minor}.${number_of_commits}${commit_decimal}"

echo "Version Code: ${version_code}"
echo "Short Version String: ${version_code}"

target_plist="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
dsym_plist="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"

for plist in "$target_plist" "$dsym_plist"; do
  if [ -f "$plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $version_code" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${version_code}" "$plist"
  fi
done
