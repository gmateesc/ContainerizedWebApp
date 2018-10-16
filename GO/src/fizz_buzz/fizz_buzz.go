package main

import "fmt"

func main() {

    // Compute the Fizz Buzz answers up to 39
    for out := range FizzBuzz(39) {
       fmt.Println(out)
    }
}


//
// This function creates a channel
// and uses a goroutine that computes 
// the Fizz Buzz output and writes 
// to the channel.
//
// The called of FizzBuzz reads the 
// output from the channel.
//
func FizzBuzz(count int) <-chan string {

    ch := make(chan string, count)

    go func() {

        for i := 1; i <= count; i++ {

            output := ""

            if i%3 == 0 { 
                output += "Fizz" 
            }

            if i%5 == 0 { 
                output += "Buzz" 
            }

            if output == "" { 
                output = fmt.Sprintf("%v", i) 
            }

            ch <- output
        }

        close(ch)
    }()

    return ch
}


