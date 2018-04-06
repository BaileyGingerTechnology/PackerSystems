package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"runtime"
)

// AppendStringToFile - Add string to the bottom of a file
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

func getCommandOutput(command string, args []string) (output string) {
	cmd := exec.Command(command, args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		log.Fatalf("cmd.Run() failed with %s\n", err)
	}
	sha := string(out)

	return sha
}

func main() {
	if runtime.GOOS == "linux" {
		os.Setenv("PATH", "/bin:/usr/bin:/sbin")
		deleteFile("/etc/gingertechengine/post")
		createFile("/etc/gingertechengine/post")
		PlatformCommon()
	} else if runtime.GOOS == "windows" {
		deleteFile("C:\\Users\\GingerTech\\Destop\\CurrentScore.html")
		createFile("C:\\Users\\GingerTech\\Destop\\CurrentScore.html")
		PlatformCommon()
	}
}
