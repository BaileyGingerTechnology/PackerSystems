package main

import (
	"fmt"
	"os"
)

func AppendStringToFile(path, text string) error {
	f, err := os.OpenFile(path, os.O_APPEND|os.O_WRONLY, os.ModeAppend)
	if err != nil {
		return err
	}
	defer f.Close()

	_, err = f.WriteString("\n" + text)
	if err != nil {
		return err
	}
	return nil
}

func deleteFile(path string) {
	// delete file
	var err = os.Remove(path)
	if err != nil {
		return
	}

	fmt.Println("==> done deleting file")
}

func createFile(path string) {
	// detect if file exists
	var _, err = os.Stat(path)

	// create file if not exists
	if os.IsNotExist(err) {
		var file, err = os.Create(path)
		if err != nil {
			return
		}
		defer file.Close()
	}

	fmt.Println("==> done creating file", path)
}

func main() {
	// +build linux
	os.Setenv("PATH", "/bin:/usr/bin:/sbin")
	deleteFile("/etc/gingertechengine/post")
	createFile("/etc/gingertechengine/post")
	LinuxChecks()
}
