package main

import (
	"fmt"
	"net"
	"os"
	"strconv"
	"time"
)

func main() {
	if len(os.Args) != 4 {
		fmt.Println("usage:", os.Args[0], "tcp address", "port", "timeout(ms)")
		return
	}
	address := fmt.Sprintf("%s:%s", os.Args[1], os.Args[2])
	tm, err := strconv.Atoi(os.Args[3])
	if err != nil {
		fmt.Println(err)
		return
	}
	connTimeout := time.Duration(tm) * time.Millisecond
	fmt.Println("connecting to address:", address)
	timeStart := time.Now()
	conn, err := net.DialTimeout("tcp", address, connTimeout)
	timeCost := time.Since(timeStart)
	if err != nil {
		fmt.Println(err, "time cost:", timeCost.String())
		return
	}
	defer conn.Close()
	fmt.Println("port is open", "time cost:", timeCost.String())

	return
}
