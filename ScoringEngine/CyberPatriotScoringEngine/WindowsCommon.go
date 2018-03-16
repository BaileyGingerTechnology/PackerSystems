package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"text/template"

	"golang.org/x/sys/windows/registry"
)

func WindowsType() {
	k, err := registry.OpenKey(registry.LOCAL_MACHINE, `SOFTWARE\Microsoft\Windows NT\CurrentVersion`, registry.QUERY_VALUE)
	if err != nil {
		log.Fatal(err)
	}
	defer k.Close()

	s, _, err := k.GetStringValue("EditionID")
	if err != nil {
		log.Fatal(err)
	}

	if strings.Contains(s, "Server") {
		WindowsServerChecks()
	} else {
		WindowsWorkstationChecks()
	}
}

var templates *template.Template

func FinishWindows() {
	var allFiles []string
	files, err := ioutil.ReadDir("./templates")
	if err != nil {
		fmt.Println(err)
	}
	for _, file := range files {
		filename := file.Name()
		if strings.HasSuffix(filename, ".tmpl") {
			allFiles = append(allFiles, "./templates/"+filename)
		}
	}

	templates, err = template.ParseFiles(allFiles...) //parses all .tmpl files in the 'templates' folder

	s1 := templates.Lookup("header.tmpl")
	s1.ExecuteTemplate(os.Stdout, "header", nil)
	fmt.Println()
	s2 := templates.Lookup("content.tmpl")
	s2.ExecuteTemplate(os.Stdout, "content", nil)
	fmt.Println()
	s3 := templates.Lookup("footer.tmpl")
	s3.ExecuteTemplate(os.Stdout, "footer", nil)
	fmt.Println()
	s3.Execute(os.Stdout, nil)
}

func WindowsCommonChecks() {
	// TODO: Have checks for Windows insert a line into content.tmpl each pass
	// Will have to find a way to reset content.tmpl each time. Maybe overwrite with
	// a literal string like the Linux hosts variable.
	// Check shares
	var args = []string{"get-WmiObject", "-class", "Win32_Share"}
	var shares = getCommandOutput("powershell.exe", args)
	if !strings.Contains(shares, "FullDrive") {
		AppendStringToFile("C:\\Users\\GingerTech\\Destop\\CurrentScore.html", "Unauthorized VNC server removed")
		AppendStringToFile("/etc/gingertechengine/post", "  - VNC is not bad when it is there by choice and is secured, but in this system, it is not there by choice and is not needed. So it would be better to get rid of it, since it just adds an extra attack vector.")
	}

	WindowsType()
}
