# PackerSystems

The goal of this project is to eventually provide practice environments for things such as:

1. CyberPatriot for high school students
2. CCDC for college students
3. And an example of a small environment that one might find in the real world

Long term goals for the first two are to have a basic scoring engine that will give points as the player fixes bad practices and implements good ones
and I hope to be able to keep the example of a real environment up to date.

3/3/2018: I am making a file server to host the Windows ISO's on, and am moving the ISO's that I was keeping in the git repo to being downloads again because git lfs is painful.

## Build instructions:

Install packer (packer-io on Arch Linux) and a hypervisor (Virtualbox, KVM, or VMware. I might support Parallels and Hyper-V in the future, but not yet).

Download the Windows 10 and Windows Server 2012r2 ISOs. The Ubuntu one will be gotten later.

Clone the repo and cd into it

cd into the directory of the environment you are building out

packer build -only=(virtualbox-iso, vmware-iso, or qemu) ./(machine).json

And then wait. A really long time. Repeat the last step for each image you want. If you have the resources, you can do several builds at once. If you do not specify -only, it will build all the platforms.

## Progress so far:

### CyberPatriot:

Ubuntu and Windows 10 are both functional and build the base of what I want. But only in Virtualbox for Windows 10, so now my goal is to get it working in VMware and KVM.

For Ubuntu:

    - Installs VMware/Vbox tools

    - Has KDE for the desktop, since I'm nice. That can be changed in the ubuntu.sh script

    - It sets up a LAMP stack

    - Puts Wordpress on that stack

    - Installs a version of bash vulnerable to Shellshock

    - Installs tigervnc

    - Installs and makes vsftpd not very secure

    - Makes SSH super insecure

    - Makes some users with weak passwords and adds them to sudo

    - Uses the hosts file to route search engines to localhost, except for Google which goes to ask.com's IP

For Windows 10:

    - Installs updates that are the latest at the time of building

    - Runs most of the scripts from https://github.com/W4RH4WK/Debloat-Windows-10

        - This causes Windows Update to break and uber disables Windows Defender

    - Shares the whole C:\ drive to all the people

    - Puts the eicar test file (file that gets flagged as malware but actually does nothing) in SysWOW64

    - Makes a few fake users

    - Disables password policy

    - Sets proxy.google.com to be a web proxy

    - Routes search engines to localhost in the hosts file (except Google, which goes to ask.com's IP)

    - Disables Windows firewall

    - Installs scoop package manager for future use

For Windows Server 2012r2:

    - Does not install updates

    - Shares the whole C:\ drive to all the people

    - Puts the eicar test file (file that gets flagged as malware but actually does nothing) in system32

    - Disables password policy

    - Sets proxy.google.com to be a web proxy

    - Routes search engines to localhost in the hosts file (except Google, which goes to ask.com' IP)

    - Disables Windows firewall

    - Installs scoop package manager for future use

    - I need to research some AD PowerShell tricks to better mess up this box

### CCDC:

So I already know that getting a faithful CCDC environemnt to be built through an automated process is going to be extremely difficult. The things they do to those boxes make grown men cry (literally). But I shall do the best I can.

My current plans are something along the lines of:

An Arch Database:

    - Of all the Linux OSes I have used, Arch has been the worst when it comes to hosting a database server. So it's an easy pick.

    - Most people panic when they see Arch or Gentoo because of their reputation. So of course I need at least one of them in here.

A Windows Server:

    - I'm thinking either 2008r2 or 2016. It's tempting to do a non r2, but that would mean that I'd have to use one.

    - 2016 carries with it the same issues that Windows 10 has, and 2008r2 (while good) is old at this point.

    - I'll probably make it a domain controller and/or Exchange server.

A Linux workstation:

    - Was gonna do Fedora, but I guess it has really bad ESXi support (or vice versa), so I'll do Debian instead.

    - Or an LFS thing. Depends on if I can implement an idea I have for Debian.

A Windows workstation:

    - Windows 8 if I can find the ISO, Windows 7 if not.

    - Pretty standard.

FreeBSD BAMP server:

    - BSD, Apache, MySQL, PHP

    - Theoretically best web server you can have. Also jails are fun. Gonna need to learn a way to automate this, but it should (in theory) not be too bad.

Either VyOS or pfSense router/firewall:

    - Not sure which I prefer. Depends on if I'm in a Debian or BSD mood when I get to this point.

I know I should have more machines, but it gets to a point where resource requirements will become prohibitive to some users. So we shall see. Feedback on this idea can be sent to me at bailey@gingertechnology.net, and I will likely make a more in depth write-up about it at https://blog.gingertechnology.net at some point.

### Scoring Engine:

My goal is to have a scoring engine for the CyberPatriot machines, and then another that checks whether services are running on the CCDC environment. I'll probably host the CCDC one on the attacking system that I plan to make.

The CyberPatriot one is being built in Go, because Go is basically magic. Not sure how I'll do the CCDC one.

### Support this project:

I plan to keep this project completely free to make use of. If you wish to support me in some way, you can become a patron of mine on Patreon here:

https://www.patreon.com/GingerTechnology

You can also do a one-off donation through PayPal:

<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----
">
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>