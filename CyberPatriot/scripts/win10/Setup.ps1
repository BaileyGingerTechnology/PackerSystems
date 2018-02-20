# Author: Bailey Kasin
# This script setups/messes up the Windows 10 image

# Share the C:\ drive, because duh, that's a great idea
NET SHARE FullDrive=C:\ /GRANT:Everyone,Full
