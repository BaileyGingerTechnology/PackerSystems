package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

type Checks struct {
	ID      int    `json:"id"`
	Type    string `json:"type"`
	Command string `json:"command"`
}

func (c Checks) toString() string {
	return toJson(c)
}

func toJson(p interface{}) string {
	bytes, err := json.Marshal(p)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}

	return string(bytes)
}

func main() {

	checks := getChecks()
	for _, c := range checks {
		fmt.Println(c.toString())
	}

	fmt.Println(toJson(checks))
}

func getChecks() []Checks {
	raw, err := ioutil.ReadFile("./ubuntu.json")
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}

	var c []Checks
	json.Unmarshal(raw, &c)
	return c
}
