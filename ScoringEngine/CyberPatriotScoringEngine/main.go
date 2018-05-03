package main

import (
	"os"
	"os/exec"
	"runtime"
	"time"
)

func check(t time.Time) {
	PlatformCommon()
}

func main() {
	if runtime.GOOS == "linux" {
		os.Setenv("PATH", "/bin:/usr/bin:/sbin:/usr/local/bin")
		var args = []string{"bash", "-c", "chown $(whoami) /etc/gingertechengine/key"}
		exec.Command("sudo", args...)
		doEvery(2*time.Minute, check)
	} else if runtime.GOOS == "windows" {
		PlatformCommon()
	}
}
