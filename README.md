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

git lfs update && git lfs pull (gets files between 100mb and 2gb)

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

A Windows workstation:

    - I'm thinking either XP or Windows 7. I want to do Vista to be mean, but honestly it's too unrealistic and uses too much of the host's resources to actually function.

    - Both can be considered old at this point and have their share of vulnerablities that an automated pen testing system could make use of. It mainly depends on how difficult it is to Packer a Windows XP build.

A Linux workstation:

    - Fedora is the easy choice for this. Popular, but not as popular as Ubuntu.

    - I've been informed that ESXi and Fedora are not friends with each other. So maybe a different workstation. One of a more GENTlemanly flavor.

FreeBSD BAMP server:

    - BSD, Apache, MySQL, PHP

    - Theoretically best web server you can have. Also jails are fun. Gonna need to learn a way to automate this, but it should (in theory) not be too bad.

Either VyOS or pfSense router/firewall:

    - Not sure which I prefer. Depends on if I'm in a Debian or BSD mood when I get to this point.

I know I should have more machines, but it gets to a point where resource requirements will become prohibitive to some users. So we shall see. Feedback on this idea can be sent to me at bailey@gingertechnology.net, and I will likely make a more in depth write-up about it at https://blog.gingertechnology.net at some point.