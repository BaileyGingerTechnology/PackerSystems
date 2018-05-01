package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/faiface/pixel"
	"github.com/faiface/pixel/pixelgl"
	"github.com/faiface/pixel/text"
	"golang.org/x/image/colornames"
	"golang.org/x/image/font/basicfont"
	"golang.org/x/sys/windows/registry"
)

var basicAtlas = text.NewAtlas(basicfont.Face7x13, text.ASCII)
var basicTxt = text.New(pixel.V(20, 748), basicAtlas)

// WindowsType - Determine which second set of checks to run based on whether Registry claims it is a server
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

func run() {
	cfg := pixelgl.WindowConfig{
		Title:  "Scoring Engine",
		Bounds: pixel.R(0, 0, 1024, 768),
		VSync:  true,
	}

	win, err := pixelgl.NewWindow(cfg)
	if err != nil {
		panic(err)
	}

	fmt.Fprintln(basicTxt, "Current Score:")

	// Check shares
	var args = []string{"get-WmiObject", "-class", "Win32_Share"}
	var shares = getCommandOutput("powershell.exe", args)
	if !strings.Contains(shares, "FullDrive") {
		fmt.Fprintln(basicTxt, "Full Drive Share Removed")
		fmt.Fprintln(basicTxt, "  - Generally, it is a really bad idea to share your Entire C drive across the network you are on.")
	}

	WindowsType()

	for !win.Closed() {
		win.Clear(colornames.Black)
		basicTxt.Draw(win, pixel.IM)
		win.Update()
	}
}

// PlatformCommon - Checks that will work for both Server and Windows 10
func PlatformCommon() {
	pixelgl.Run(run)
}

// WindowsServerChecks - Checks for just server
func WindowsServerChecks() {

}

// WindowsWorkstationChecks - Checks for just the workstation
func WindowsWorkstationChecks() {

}
