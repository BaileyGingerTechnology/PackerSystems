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
		if _, err := os.Stat("/usr/local/bin/ForensicDeployment"); err == nil {
			exec.Command("sudo", "/usr/local/bin/ForensicDeployment")
			exec.Command("sudo", "rm", "/usr/local/bin/ForensicDeployment")
			deleteFile("/etc/gingertechengine/questions.json")
		}
		var args = []string{"bash", "-c", "chown $(whoami) /etc/gingertechengine/key"}
		exec.Command("sudo", args...)
		doEvery(2*time.Minute, check)
	} else if runtime.GOOS == "windows" {
		PlatformCommon()
	}
}
