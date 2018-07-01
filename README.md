# PackerSystems

The goal of this project is to eventually provide practice environments for things such as:

1. CyberPatriot for high school students
2. CCDC for college students

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

    - https://blog.gingertechnology.net/2018/05/28/ubuntu-1-0-a-cyberpatriot-practice-image/

For Windows 10:

    - Installs updates that are the latest at the time of building

    - Runs most of the scripts from https://github.com/W4RH4WK/Debloat-Windows-10

        - This causes Windows Update to break and uber disables Windows Defender

    - Shares the whole C:\ drive to all the people

    - Puts the eicar test file (file that gets flagged as malware but actually does nothing) in SysWOW64

    - Makes a few users

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

Creds for all these boxes is going to be "administrator" and "password" for Linux and "GingerTech" and "password" on Windows.

The codenames of the machines are the lastnames of authors that I like. When I make blog posts for them, I'll probably briefly mention the author.

My current plans are something along the lines of:

Arch Database (Codename="Maas"):

    - Of all the Linux OSes I have used, Arch has been the worst when it comes to hosting a database server. So it's an easy pick.

    - Most people panic when they see Arch or Gentoo because of their reputation. So of course I need at least one of them in here.

Windows 2012r2 Server (Codename="Riordan"):

    - Going to do AD and potentially have it be a monolithic Exchange box.

Debian workstation (Codename="Blake"):

    - Was gonna do Fedora, but I guess it has really bad ESXi support (or vice versa), so I'll do Debian instead.

    - I dub thee "Tuna Linux" because it's friggen stupid. I install Arch alongside Debian, and it auto-chroots into the Arch install whenever one opens Bash.

Windows 8.1 workstation (Codename="Ee"):

    - Pretty standard.

FreeBSD BAMP server (Codename="Beddor"):

    - BSD, Apache, MySQL, PHP

    - Theoretically best web server you can have. Also jails are fun. Specifically iocage ones.

VyOS router/firewall (Codename="Schwab"):

    - Gonna have to git gud at networking I guess.

Gentoo Webserver (Codename="dLacey"):
    
    - Gentoo is a pretty good webserver, and I automated building it, so why not?

    - People get so scared when they see Gentoo, and need to get over it.

    - Set default shell to "oh" which is a shell built in Go, and Go is great.

LFS Webserver (Codename="White"):

    - Yep.

    - Was originally gonna do something with RPM, and I still might, but it currently seems like that won't work as planned.
        - Now looking at DPKG (Debian/Ubuntu) or libzypp (Suse).

CentOS Docker (Codename="Falls"):

    - Docker host. Makes sense enough I think.

Kali Scoring Box (Codename="Ward"):

    - Will not have an account for the player to use.

    - Will write more about the scoring engine in a blog post, but at the moment it's a tag team Golang/Dotnet app.

    - Automated attack engine that will not damage the boxes too badly, but will send info to the webapp about how it got in.

Feedback on this idea can be sent to me at bailey@gingertechnology.net, and I will likely make a more in depth write-up about it at https://blog.gingertechnology.net at some point.

### Scoring Engine:

My goal is to have a scoring engine for the CyberPatriot machines, and then another that checks whether services are running on the CCDC environment. I'll probably host the CCDC one on the attacking system that I plan to make.

The Linux CyberPatriot one is almost done. The Windows one is also functional, I just need to make the checks for it.

### Support this project:

I plan to keep this project completely free to make use of. If you wish to support me in some way, you can become a patron of mine on Patreon here:

https://www.patreon.com/GingerTechnology