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

func getQuestions() []Question {
	raw, err := ioutil.ReadFile("./questions.json")
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}

	var c []Question
	json.Unmarshal(raw, &c)

	rand.Seed(time.Now().UnixNano())

	for i := 0; i < len(c); i++ {
		if c[i].OS != runtime.GOOS && c[i].OS != "either" {
			c = append(c[:i])
		}
	}

	p := rand.Perm(len(c))

	var questionPicked = []Question{
		c[p[1]],
		c[p[2]],
	}

	return questionPicked
}

func main() {
	questions := getQuestions()

	Deploy(questions[0])
	Deploy(questions[1])
}
