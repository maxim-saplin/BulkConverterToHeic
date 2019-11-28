# Bulk Image Converter To Heic
Shell script (ZSH) for macOS to do bulk image conversion of JPG, PNG, BMP images to HEIC/HEIF files with metadata preservation. Original files can be deleted after the conversion is over. Tested on 10.15 (Catalina) and 10.14 (Mojave).

# 2 SCRIPTS
* SIPS (heic_sips.sh) - based on Apple's Scriptable Image Processing System.
  * Works only on 10.15
  * There's a SIPS error message always showin (as of November 2019? might be fixed in future releases of macOS): AVEBridge Info: AVEEncoder_CreateInstance: ...
  * 2-3x times faster tham ImageMagick
* ImageMagick (heic_magick.sh) - based on open source command line tool https://imagemagick.org
  * Works on both 10.14 and 10.15 macOS
  * Greater compression ratio
  * As of November 2019 there're troubles opening produced files in Photoshop and Lightroom (works fine in other apps)

# Prerequisites for ImageMagick
```
brew install imagemagick
```
If you get brew errors (such as "You should change the ownership and permissions ..."), try reinstalling brew:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# Usage

Download **heic_sips.sh** or **heic_magick.sh**file, run it via terminal passing the path to the target folder with images to be converted. 
If you want all subfolders to be processed use **subfolders** option. 
If you want originals to be deleted after (successful) conversion use **remove** option.
```
zsh /Users/userA/Desktop/heic_sips.sh /Users/userA/Images subfolders remove
```
