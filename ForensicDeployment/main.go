package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"runtime"
	"time"
)

// Question - struct to give a format for the potential questions
type Question struct {
	ID         int    `json:"id"`
	OS         string `json:"os"`
	Question   string `json:"question"`
	Answer     string `json:"answer"`
	Deployment string `json:"deployment"`
}

func (p Question) toString() string {
	return toJSON(p)
}

func toJSON(p interface{}) string {
	bytes, err := json.Marshal(p)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}

	return string(bytes)
}

func getQuestions(raw []byte) []Question {
	var c []Question
	var e []Question
	json.Unmarshal(raw, &c)

	rand.Seed(time.Now().UnixNano())

	for i := 0; i < len(c); i++ {
		if c[i].OS == runtime.GOOS || c[i].OS == "either" {
			e = append(e, c[i])
		}
	}

	p := rand.Perm(len(e))
	var questionPicked = []Question{
		e[p[1]],
		e[p[2]],
	}

	return questionPicked
}

func main() {
	questions := []Question{}
	if runtime.GOOS == "linux" {
		os.Setenv("PATH", "/bin:/usr/bin:/sbin:/usr/local/bin")
		raw, err := ioutil.ReadFile("/etc/gingertechengine/questions.json")
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
		}
		questions = getQuestions(raw)
	} else if runtime.GOOS == "windows" {
		raw, err := ioutil.ReadFile(".\\questions.json")
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
		}
		questions = getQuestions(raw)
	}

	Deploy(questions[0])
	Deploy(questions[1])
}
