package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

//RegistryCreds holds auth info for a registry
type RegistryCreds struct {
	Username string
	Password string
	Registry   string
}

// ConfigFile holds a config file
type ConfigFile struct{
	Auths map[string]ConfigFileAuth `json:"auths"`
}

// ConfigFileAuth holds a config file entry
type ConfigFileAuth struct {
	Auth string `json:"auth"`
}

func main() {
	registryCreds := []RegistryCreds{}
	registryCredsJSON := os.Getenv("registryCreds")
	err := json.Unmarshal([]byte(registryCredsJSON), &registryCreds)
	if nil != err {
		panic(err)
	}

	auths := map[string]ConfigFileAuth{}

	for _, creds := range registryCreds {
		auths[creds.Registry] = ConfigFileAuth{
			Auth: base64.StdEncoding.EncodeToString([]byte(fmt.Sprintf("%s:%s", creds.Username, creds.Password))),
		}
	}

	configFile := ConfigFile{
		Auths: auths,
	}

	configFileBytes, err := json.Marshal(configFile)
	if nil != err {
		panic(err)
	}

	err = os.MkdirAll("/root/.docker", 0777)
	if nil != err {
		panic(err)
	}

	err = ioutil.WriteFile(
		"/root/.docker/config.json",
		configFileBytes,
		0777,
	)
	if nil != err {
		panic(err)
	}
}
