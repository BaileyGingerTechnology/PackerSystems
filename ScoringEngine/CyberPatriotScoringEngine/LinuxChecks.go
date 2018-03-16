package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
	"time"
)

func FTPChecks(config string) {
	content, err := ioutil.ReadFile(config)
	if err != nil {
		log.Fatal(err)
	}
	var checkString = string(content)

	// Check for anonymous login
	if strings.Contains(checkString, "anonymous_enable=NO") {
		AppendStringToFile("/etc/gingertechengine/post", "Anonymous FTP login disabled")
		AppendStringToFile("/etc/gingertechengine/post", "  - Anonymous FTP is generally used for Linux update mirrors as an alternative to HTTP(S). So while it does have use cases, it is generally not something that you want in a web server that only a few people should have access to.")
	}
	// Check that FTP is logging transfers
	if strings.Contains(checkString, "xferlog_enable=YES") {
		AppendStringToFile("/etc/gingertechengine/post", "FTP logging enabled")
		AppendStringToFile("/etc/gingertechengine/post", "  - Logging for all vital systems is always a good idea.")
	}
	// Check anonymous upload is disabled
	if strings.Contains(checkString, "anon_upload_enable=NO") {
		AppendStringToFile("/etc/gingertechengine/post", "Anonymous FTP upload disabled")
		AppendStringToFile("/etc/gingertechengine/post", "  - Honestly, I have no idea if there is ever a situation in which one should have this enabled.")
	}
	// Check SSL is enabled
	if strings.Contains(checkString, "ssl_enable=YES") {
		AppendStringToFile("/etc/gingertechengine/post", "FTP SSL enabled")
		AppendStringToFile("/etc/gingertechengine/post", "  - Essentially allows for HTTPS but FTP.")
	}
}

func hostsCheck(config string) {
	content, err := ioutil.ReadFile(config)
	if err != nil {
		log.Fatal(err)
	}
	var checkString = string(content)

	var hostsCheckString = `34.196.155.28 google.com
	0.0.0.0 bing.com
	0.0.0.0 yahoo.com
	0.0.0.0 duckduckgo.com
	0.0.0.0 startpage.com
	0.0.0.0 aol.com
	34.196.155.28 www.google.com
	0.0.0.0 www.bing.com
	0.0.0.0 www.yahoo.com
	0.0.0.0 www.duckduckgo.com
	0.0.0.0 www.startpage.com
	0.0.0.0 www.aol.com`

	// Check hosts file is fixed
	if !strings.Contains(checkString, hostsCheckString) {
		AppendStringToFile("/etc/gingertechengine/post", "hosts file fixed")
		AppendStringToFile("/etc/gingertechengine/post", "  - The hosts file is used to route domains to IP addresses. This can be used to block websites (I use it as a way to block ads, for examples) or to setup domains in an internal network. There are better ways to do these things, but the hosts file is an option.")
	}
}

func SSHChecks(config string) {
	content, err := ioutil.ReadFile(config)
	if err != nil {
		log.Fatal(err)
	}
	var checkString = string(content)

	// Check Protocol
	if strings.Contains(checkString, "Protocol 2") {
		AppendStringToFile("/etc/gingertechengine/post", "SSH set to protocol 2")
		AppendStringToFile("/etc/gingertechengine/post", "  - SSH protocol 2 is more secure than protocol 1. Not certain why, but theres no overhead to my knowledge, so it is best to use it.")
	}
}

func stringInSlice(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}

func LinuxChecks() {
	// Do Linux checks
	FTPChecks("/etc/vsftpd.conf")
	// Do SSH checks
	SSHChecks("/etc/ssh/sshd_config")
	// Do hosts check
	hostsCheck("/etc/hosts")

	// Check VNC is dead
	var args = []string{"list", "--installed"}
	var installedList = getCommandOutput("apt", args)
	if strings.Contains(installedList, "tightvnc") {
		AppendStringToFile("/etc/gingertechengine/post", "Unauthorized VNC server removed")
		AppendStringToFile("/etc/gingertechengine/post", "  - VNC is not bad when it is there by choice and is secured, but in this system, it is not there by choice and is not needed. So it would be better to get rid of it, since it just adds an extra attack vector.")
	}

	// Check Shellshock
	args = []string{"-c", "x='() { :;}; echo VULN' bash -c :"}
	var shellshock = getCommandOutput("bash", args)
	if strings.Contains(shellshock, "VULN") {
		AppendStringToFile("/etc/gingertechengine/post", "Shellshock patched")
		AppendStringToFile("/etc/gingertechengine/post", "  - Shellshock is a vulnerability in older versions of the Bash shell. Simple to exploit but also now simple to patch.")
	}

	// Check user privileges
	args = []string{"/etc/group", "|", "grep", "sudo"}
	var sudoers = getCommandOutput("cat", args)
	splitSudoers := strings.Fields(sudoers)
	if stringInSlice("nuzumaki", splitSudoers) || stringInSlice("jprice", splitSudoers) || stringInSlice("lpena", splitSudoers) || stringInSlice("rparker", splitSudoers) {
		if stringInSlice("bkasin", splitSudoers) && stringInSlice("acooper", splitSudoers) && stringInSlice("administrator", splitSudoers) {
			AppendStringToFile("/etc/gingertechengine/post", "User privileges fixed")
			AppendStringToFile("/etc/gingertechengine/post", "  - Pretty self explanatory. Only trained and authorized users should have admin privileges, and minimize the amount of users with admin powers.")
		}
	}

	// Make post
	t := time.Now()
	args = []string{"/var/www/html", "&&", "wp", "post", "create", "/etc/gingertechengine/post", "--post_title=" + t.Format("20060102150405") + " Checks", "--post_type=post", "--post_status=publish", "--post_author=2"}
	var post = getCommandOutput("cd", args)
	fmt.Println(post)
}
