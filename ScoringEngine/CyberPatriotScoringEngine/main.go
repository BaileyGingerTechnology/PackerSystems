package main

import (
	"os"
	"runtime"
	"time"
)

func check(t time.Time) {
	PlatformCommon()
}

func main() {
	if runtime.GOOS == "linux" {
		os.Setenv("PATH", "/bin:/usr/bin:/sbin:/usr/local/bin")
		doEvery(2*time.Minute, check)
	} else if runtime.GOOS == "windows" {
		PlatformCommon()
	}
}
