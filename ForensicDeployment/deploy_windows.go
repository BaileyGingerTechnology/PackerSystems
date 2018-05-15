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

	createFile("C:\\Users\\administrator\\Desktop\\Forensic One.txt")
	if _, err := os.Stat("C:\\Users\\administrator\\Desktop\\Forensic One.txt"); err == nil {
		createFile("C:\\Users\\administrator\\Desktop\\Forensic Two.txt")
	}

	AppendStringToFile("C:\\Users\\administrator\\Desktop\\Forensic One.txt", strconv.Itoa(toDeploy.ID)+"\n"+toDeploy.Question)
	if _, err := os.Stat("C:\\Users\\administrator\\Desktop\\Forensic Two.txt"); err == nil {
		AppendStringToFile("C:\\Users\\administrator\\Desktop\\Forensic Two.txt", strconv.Itoa(toDeploy.ID)+"\n"+toDeploy.Question)
	}

	key := []byte("WjNJKFcSZejKNzPP")
	answer, _ := encrypt(key, toDeploy.Answer)

	if _, err := os.Stat("C:\\Users\\administrator\\Desktop\\Forensic Two.txt"); err == nil {
		AppendKeyToFile("C:\\ProgramData\\gingertechengine\\key", "\n"+answer)
	} else {
		createFile("C:\\ProgramData\\gingertechengine\\key")
		AppendKeyToFile("C:\\ProgramData\\gingertechengine\\key", answer)
	}
}
