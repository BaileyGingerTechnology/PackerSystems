package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os/exec"
	"strings"
)

// FTPChecks - Checks for best practices in vsftpd.conf
func FTPChecks(config string) {
	content, err := ioutil.ReadFile(config)
	if err != nil {
		log.Fatal(err)
	}
	var checkString = string(content)

	// Check for anonymous login
	if strings.Contains(checkString, "anonymous_enable=NO") || strings.Contains(checkString, "anonymous_enable=no") {
		AppendStringToFile("/etc/gingertechengine/post", "Anonymous FTP login disabled (1/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - Anonymous FTP is generally used for Linux update mirrors as an alternative to HTTP(S). So while it does have use cases, it is generally not something that you want in a web server that only a few people should have access to.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
	// Check that FTP is logging transfers
	if strings.Contains(checkString, "xferlog_enable=YES") || strings.Contains(checkString, "xferlog_enable=yes") {
		AppendStringToFile("/etc/gingertechengine/post", "FTP logging enabled (2/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - Logging for all vital systems is always a good idea.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
	// Check anonymous upload is disabled
	if strings.Contains(checkString, "anon_upload_enable=NO") || strings.Contains(checkString, "anon_upload_enable=no") {
		AppendStringToFile("/etc/gingertechengine/post", "Anonymous FTP upload disabled (3/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - Honestly, I have no idea if there is ever a situation in which one should have this enabled.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
	// Check SSL is enabled
	if strings.Contains(checkString, "ssl_enable=YES") || strings.Contains(checkString, "ssl_enable=yes") {
		AppendStringToFile("/etc/gingertechengine/post", "FTP SSL enabled (4/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - Essentially allows for HTTPS but FTP.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
}

func hostsCheck(config string) {
	content, err := ioutil.ReadFile(config)
	if err != nil {
		log.Fatal(err)
	}
	var checkString = string(content)

	var hostsCheckString = `
104.81.48.202 google.com
0.0.0.0 bing.com
0.0.0.0 yahoo.com
0.0.0.0 duckduckgo.com
0.0.0.0 startpage.com
0.0.0.0 aol.com
104.81.48.202 www.google.com
0.0.0.0 www.bing.com
0.0.0.0 www.yahoo.com
0.0.0.0 www.duckduckgo.com
0.0.0.0 www.startpage.com
0.0.0.0 www.aol.com`

	// Check hosts file is fixed
	if !strings.Contains(checkString, hostsCheckString) {
		AppendStringToFile("/etc/gingertechengine/post", "hosts file fixed (5/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - The hosts file is used to route domains to IP addresses. This can be used to block websites (I use it as a way to block ads, for examples) or to setup domains in an internal network. There are better ways to do these things, but the hosts file is an option.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
}

// SSHChecks - Checks for best practices in the sshd_config
func SSHChecks(config string) {
	content, err := ioutil.ReadFile(config)
	if err != nil {
		log.Fatal(err)
	}
	var checkString = string(content)

	// Check Protocol
	if strings.Contains(checkString, "Protocol 2") {
		AppendStringToFile("/etc/gingertechengine/post", "SSH set to protocol 2 (6/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - SSH protocol 2 is more secure than protocol 1. Not certain why, but theres no overhead as far as I know, so it is best to use it.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}

	// Check Password
	if strings.Contains(checkString, "PermitEmptyPasswords no") || strings.Contains(checkString, "PermitEmptyPasswords NO") {
		AppendStringToFile("/etc/gingertechengine/post", "SSH set to protocol 2 (7/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - SSH protocol 2 is more secure than protocol 1. Not certain why, but theres no overhead as far as I know, so it is best to use it.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
}

// PlatformCommon - The main function for running Linux checks
func PlatformCommon() {
	deleteFile("/etc/gingertechengine/post")
	createFile("/etc/gingertechengine/post")
	var args = []string{"bash", "-c", "chown $(whoami) /etc/gingertechengine/post"}
	exec.Command("sudo", args...)
	fmt.Println("Own post")

	// Do Linux checks
	FTPChecks("/etc/vsftpd.conf")
	// Do hosts check
	hostsCheck("/etc/hosts")
	// Do SSH checks
	SSHChecks("/etc/ssh/sshd_config")

	// Check VNC is dead
	args = []string{"list", "--installed"}
	var installedList = getCommandOutput("apt", args)
	if !strings.Contains(installedList, "tightvnc") {
		AppendStringToFile("/etc/gingertechengine/post", "Unauthorized VNC server removed (8/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - VNC is not bad when it is there by choice and is secured, but in this system, it is not there by choice and is not needed. So it would be better to get rid of it, since it just adds an extra attack vector.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}

	// Check Shellshock
	args = []string{"-c", "/etc/gingertechengine/notify.sh", "check"}
	var shellshock = getCommandOutput("bash", args)
	if !strings.Contains(shellshock, "VULN") {
		AppendStringToFile("/etc/gingertechengine/post", "Shellshock patched (9/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - Shellshock is a vulnerability in older versions of the Bash shell. Simple to exploit but also now simple to patch.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}

	// Check user privileges
	args = []string{"-c", "cat /etc/group | grep sudo"}
	var sudoers = getCommandOutput("bash", args)
	splitSudoers := strings.Fields(sudoers)
	if !stringInSlice("nuzumaki", splitSudoers) && !stringInSlice("jprice", splitSudoers) && !stringInSlice("lpena", splitSudoers) && !stringInSlice("rparker", splitSudoers) {
		if stringInSlice("bkasin", splitSudoers) && stringInSlice("acooper", splitSudoers) && stringInSlice("administrator", splitSudoers) {
			AppendStringToFile("/etc/gingertechengine/post", "User privileges fixed (10/12)")
			AppendStringToFile("/etc/gingertechengine/post", "  - Pretty self explanatory. Only trained and authorized users should have admin privileges, and minimize the amount of users with admin powers.")
			AppendStringToFile("/etc/gingertechengine/post", "")
		}
	}

	// Check for Wordpress being up to date
	args = []string{"-c", "cd /var/www/html && wp core check-update"}
	var wordpressVersion = getCommandOutput("bash", args)
	if strings.Contains(wordpressVersion, "Success") {
		AppendStringToFile("/etc/gingertechengine/post", "Wordpress updated (11/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  -  Keeping everything up to date is a very important part of staying secure. You should also have needed to fix permissions to complete this check, which is an important thing to know how to do.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}

	// Check for Wordfence being active
	args = []string{"-c", "cd /var/www/html && wp plugin status wordfence | grep Status"}
	var wordfence = getCommandOutput("bash", args)
	if strings.Contains(wordfence, "Active") {
		AppendStringToFile("/etc/gingertechengine/post", "Wordfence activated (12/12)")
		AppendStringToFile("/etc/gingertechengine/post", "  - When running a WordPress website, using Wordfence is good idea for many reasons. It blocks a tool from wpscan from being able to see large amount of info about your website, such as the version and a list of plugins and users. It also acts as a firewall and Intrusion Detection System. Quite useful.")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}

	fmt.Println("Forensics")
	ForensicQuestion()

	// Make post
	args = []string{"-c", "/usr/local/bin/post_score"}
	getCommandOutput("bash", args)
}

// ForensicQuestion - Checks for if forensic questions have been completed
func ForensicQuestion() {
	key := []byte("WjNJKFcSZejKNzPP")

	var args = []string{"-n1", "/etc/gingertechengine/key"}
	var questionOne = getCommandOutput("tail", args)

	args = []string{"-n1", "/etc/gingertechengine/key1"}
	var questionTwo = getCommandOutput("tail", args)

	answerOne, _ := decrypt(key, questionOne)
	answerTwo, _ := decrypt(key, questionTwo)

	content, err := ioutil.ReadFile("/home/administrator/Desktop/Forensic One.txt")
	if err != nil {
		log.Fatal(err)
	}
	content1, err := ioutil.ReadFile("/home/administrator/Desktop/Forensic Two.txt")
	if err != nil {
		log.Fatal(err)
	}
	questionOne = string(content)
	questionTwo = string(content1)

	if strings.Contains(questionOne, answerOne) {
		AppendStringToFile("/etc/gingertechengine/post", "Forensic Question One Complete (1/2)")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
	if strings.Contains(questionTwo, answerTwo) {
		AppendStringToFile("/etc/gingertechengine/post", "Forensic Question Two Complete (2/2)")
		AppendStringToFile("/etc/gingertechengine/post", "")
	}
}
