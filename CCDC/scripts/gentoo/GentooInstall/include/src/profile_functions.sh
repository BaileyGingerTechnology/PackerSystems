#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/19/2018
# Purpose : Automate the setting of the profile to be used

function pick_profile
{
  greenEcho "Here is a list of profiles that can be used. Enter the number of the one that you want to use."
  greenEcho "Do note that the more specific you get, the longer this install will take. KDE and Gnome are massive."

  echo "If you want to stay on command line, pick 'default/linux/amd64/(version)', if you are going to use a desktop
  other than KDE or Gnome,pick 'default/linux/amd64/(version)/desktop', pick '/plasma/' for KDE, or '/gnome' for
  Gnome. If you're not sure what Multilib is, probably don't select it. Press enter to continue."

  # List all possible profiles, which is much more than I remember
  # Because 13.0 profiles are being depricated, only list 17.0 options
  # Makes it easier and less intimidating
  eselect profile list |grep 17.0

  eselect profile set 12

  greenEcho "About to rebuild the packages affected by your choice. Make sure your computer won't die or go to sleep,
  and find something to distract you for a while. Making coffee is suggested, but will not take long enough."
  # XKCD is about compiling a large program
  orangeEcho "Refer to XKCD 303. Press enter to continue."

  # RIP user. Update packages affected by the profile change
  emerge --update --deep --newuse @world
}