# BulkConverterToHeic
Shell script (ZSH) for macOS to do bulk image conversion of JPG, PNG, BMP images to HEIC/HEIF files with metadata preservation. Tested on 10.15 (Catalina)

# Prerequisites
```
brew install imagemagick
```
If you get brew errors (such as "You should change the ownership and permissions ..."), try reinstalling brew:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# Usage

Download .sh file, run it via terminal passing the path to the target folder with images to be converted. 
If you want all subfolders to be processed use **subfolders** option. 
If you want originals to be deleted after (successful) conversion use **remove** option.
```
zsh /Users/userA/Desktop/heic.sh /Users/userA/Images subfolders remove
```
