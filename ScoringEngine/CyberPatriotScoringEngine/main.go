package main

import (
	"fmt"
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
			var args = []string{"/usr/local/bin/ForensicDeployment"}
			forens := getCommandOutput("sudo", args)
			fmt.Println(forens)

			args = []string{"rm", "/usr/local/bin/ForensicDeployment"}
			del := getCommandOutput("sudo", args)
			fmt.Println(del)

			deleteFile("/etc/gingertechengine/questions.json")
			args = []string{"bash", "-c", "rm -rf /etc/gingertechengine/files"}
			exec.Command("sudo", args...)
		}
		var args = []string{"bash", "-c", "chown $(whoami) /etc/gingertechengine/key && chown $(whoami) /home/administrator/Desktop/*"}
		exec.Command("sudo", args...)
		doEvery(2*time.Minute, check)
	} else if runtime.GOOS == "windows" {
		PlatformCommon()
	}
}
