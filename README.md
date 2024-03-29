# Bulk Image Converter to HEIF/HEIC Format
Shell script (ZSH) for macOS to do bulk image conversion of JPG, PNG, BMP, DNG, ARW, TIFF images to HEIC/HEIF files (2-3x times smaller than same dimension/quality JPGs) with metadata preservation (EXIF). Original files can be deleted after the conversion is over. Tested on 11.0 (Big Sur), 10.15 (Catalina) and 10.14 (Mojave).

# Usage

Download **heic_sips.sh** (or **heic_magick.sh**) file, run it via terminal passing the path to the target folder with images to be converted. 
If you want all subfolders to be processed use **subfolders** option. 
If you want originals to be deleted after (successful) conversion use **remove** option (individual files that were not converted wouldn't be deleted).
```
zsh /Users/userA/Desktop/heic_sips.sh /Users/userA/Images subfolders remove
```

# 2 scripts, 2 Flavours
* [DEFAULT] SIPS (heic_sips.sh) - based on Apple's Scriptable Image Processing System.
  * Works only on 10.15+
  * Only 8 bit per channel (as of 2021, limmited by capabilities of SIPS)
  * There's a SIPS error message always shown (as of November 2019? might be fixed in future releases of macOS): AVEBridge Info: AVEEncoder_CreateInstance: ... - you can ignore the message   
  * 2-3x times faster than ImageMagick
* ImageMagick (heic_magick.sh) -  based on open source command line tool https://imagemagick.org
  * Works on both 10.14 and 10.15 macOS
  * Greater compression ratio
  * As of November 2019 there're troubles opening produced files in Photoshop and Lightroom (works fine in other apps)
  * Can have trouble in case a folder has a file with same name but different extension (e.g. 1.png and 1.jpg)


# Prerequisites for ImageMagick
```
brew install imagemagick
```
If you get brew errors (such as "You should change the ownership and permissions ..."), try reinstalling brew:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
