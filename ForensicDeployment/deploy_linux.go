package main

import (
	"fmt"
	"os"
	"strconv"
)

// Deploy - Function to handle any needed deployment of a forensic question
func Deploy(toDeploy Question) {
	if toDeploy.Deployment == "none" {
		fmt.Println("Done")
	} else if toDeploy.Deployment != "none" {
		fmt.Println("Not yet implemented")
	}

	createFile("/home/administrator/Desktop/Forensic One.txt")
	if _, err := os.Stat("/home/administrator/Desktop/Forensic One.txt"); err == nil {
		createFile("/home/administrator/Desktop/Forensic Two.txt")
	}

	AppendStringToFile("/home/administrator/Desktop/Forensic One.txt", strconv.Itoa(toDeploy.ID)+"\n"+toDeploy.Question)
	if _, err := os.Stat("/home/administrator/Desktop/Forensic Two.txt"); err == nil {
		AppendStringToFile("/home/administrator/Desktop/Forensic Two.txt", strconv.Itoa(toDeploy.ID)+"\n"+toDeploy.Question)
	}

	key := []byte("WjNJKFcSZejKNzPP")
	var answer = encrypt(key, toDeploy.Answer)

	if _, err := os.Stat("/home/administrator/Desktop/Forensic Two.txt"); err == nil {
		AppendKeyToFile("/etc/gingertechengine/key", "\n"+answer)
	} else {
		AppendKeyToFile("/etc/gingertechengine/key", answer)
	}
}