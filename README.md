# PackerSystems

The goal of this project is to eventually provide practice environments for things such as:

1. CyberPatriot for high school students
2. CCDC for college students
3. And an example of a small environment that one might find in the real world

Long term goals for the first two are to have a basic scoring engine that will give points as the player fixes bad practices and implements good ones
and I hope to be able to keep the example of a real environment up to date.

## Progress so far:

### CyberPatriot:

Ubuntu and Windows 10 are both functional and build the base of what I want. But only in Virtualbox for Windows 10, so now my goal is to get it working in VMware and KVM.

For Ubuntu:
    - Has KDE for the desktop, since I'm nice. That can be changed in the ubuntu.sh script
    - It sets up a LAMP stack
    - Puts Wordpress on that stack
    - Installs a version of bash vulnerable to Shellshock

For Windows 10:
    - Installs updates that are the latest at the time of building
    - Runs most of the scripts from https://github.com/W4RH4WK/Debloat-Windows-10
    - Shares the whole C:\ drive to all the people

For Windows Server 2012r2:
    - Ehhh... It might build sometimes

## Build instructions:

Install packer (packer-io on Arch Linux) and a hypervisor (Virtualbox, KVM, or VMware. I might support Parallels and Hyper-V in the future, but not yet).

Download the Windows 10 and Windows Server 2012r2 ISOs. The Ubuntu one will be gotten later.

Clone the repo and cd into it

git lfs update && git lfs pull (gets files between 100mb and 2gb)

cd into the directory of the environment you are building out

packer build -only=(virtualbox-iso, vmware-iso, or qemu) ./(machine).json

And then wait. A really long time. Repeat the last step for each image you want. If you have the resources, you can do several builds at once. If you do not specify -only, it will build all the platforms.