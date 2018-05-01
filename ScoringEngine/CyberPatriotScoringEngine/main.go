package main

import (
	"os"
	"runtime"
	"time"
)

// doEvery - Run function f every d length of time
func doEvery(d time.Duration, f func(time.Time)) {
	for x := range time.Tick(d) {
		f(x)
	}
}

func check(t time.Time) {
	PlatformCommon()
}

func main() {
	if runtime.GOOS == "linux" {
		os.Setenv("PATH", "/bin:/usr/bin:/sbin:/usr/local/bin")
		deleteFile("/etc/gingertechengine/post")
		createFile("/etc/gingertechengine/post")
	} else if runtime.GOOS == "windows" {
		deleteFile("C:\\Users\\GingerTech\\Destop\\CurrentScore.html")
		createFile("C:\\Users\\GingerTech\\Destop\\CurrentScore.html")
	}
	doEvery(2*time.Minute, check)
}
