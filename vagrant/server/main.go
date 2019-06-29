package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

var (
	counter = make(chan string)
	done    = make(chan struct{})
	num     int
)

func sayHello(w http.ResponseWriter, r *http.Request) {
	message := r.URL.Path
	message = strings.TrimPrefix(message, "/")
	message = "Hello " + message
	w.Write([]byte(message))

	counter <- r.RemoteAddr + " for " + r.URL.Path
}

func main() {
	defer func() { done <- struct{}{} }()
	go func() {
		for {
			select {
			case addr := <-counter:
				num += 1
				fmt.Fprintf(os.Stdout, "serving request #%d from %s\n", num, addr)
			case <-done:
				break
			}
		}
	}()

	http.HandleFunc("/", sayHello)
	if err := http.ListenAndServe(":12345", nil); err != nil {
		log.Fatalf("Failed: %+v\n", err)
	}
}
