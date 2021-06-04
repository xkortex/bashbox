// Copyright 2020 Michael McDermott MIT License

package main

import (
	"fmt"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"
)


var (
	TIME_FMT = "2006-01-02 15:04:05.0000"
	BLOCK = '█'
	FLASH_LEN = 5
	CURSOR_RESET = "\033[0;0H"
	RULER_LEN = 100
	RULE_B = "├"
	RULE_M1 = "┴"
	RULE_M2 = "┬"
	RULE_E = "┤"
	BASE_RULER = "├┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┸┬┴┬┴┬┴┬┴┬┤"
	BASE_RULER60 = "├┴┬┴┬┸┬┴┬┴┰┴┬┴┬┸┬┴┬┴┰┴┬┴┬┸┬┴┬┴┰┴┬┴┬┸┬┴┬┴┰┴┬┴┬┸┬┴┬┴┰┴┬┴┬┸┬┴┬┤"
	FLASHRULER = "████████████████████████████████████████████████████████████████████████████████████████████████████"
	FLASH = "██████████"
	BLANK = "          "
	TEN_MS = int(time.Duration(10000000).Nanoseconds())
)

// Make a 100-tick ruler and draw the cursor at the appropriate location
func make_ruler(idx int) string {
	rs := []rune(BASE_RULER)
	rs[idx] = BLOCK
	return string(rs)
}

// Make a 60-tick ruler and draw the cursor at the appropriate location
func make_ruler60(idx int) string {
	rs := []rune(BASE_RULER60)
	rs[idx] = BLOCK
	return string(rs)
}

// "Render" the status bar according to the time passed in
func make_statbar(now time.Time) string {
	just_ns := now.Nanosecond()
	idx := just_ns / TEN_MS
	sec := int(now.Unix() % 60)

	i := idx % RULER_LEN
	flash := BLANK
	if i <= FLASH_LEN {
		flash = FLASH
	}
	if i < 0 {
		i = 0
	}

	dts := fmt.Sprintf("\r %s % 6d % 25s %s %s %s\r", flash, idx, now.Format(TIME_FMT), make_ruler60(sec), make_ruler(i), flash)
	return dts
}

// Sleep until the next round-number (multiple of granularity)
// granularity is
func wait_until_next_edge(granularity time.Duration, thresh time.Duration) {
	now := time.Now()
	nowns := now.UnixNano()
	dt := granularity.Nanoseconds()

	m := nowns % dt
	delay_ns := dt - m
	delay_ns -= 123000 // account for predicted time lapse
	if delay_ns < 0 {
		delay_ns += dt
	}
	delay := time.Duration(delay_ns)

	if delay > thresh {
		time.Sleep(delay)
	}
}

func main() {
	//println(make_ruler(0))
	//println(make_ruler(99))
	//println(make_ruler(50))
	//println(make_statbar(0))
	//delay, _ := time.ParseDuration("100ms")

	s_delay := "10ms"

	if len(os.Args) > 1 {
		s_delay = os.Args[1]
	}
	delay, err := time.ParseDuration(s_delay)
	if err != nil {
		println("Unable to ParseDuration for time interval: ", s_delay)
	}
	thresh, _ := time.ParseDuration("0.1ms")

	// Using goroutines and channels so we can catch
	wg := sync.WaitGroup{}
	wg.Add(1)
	sigs := make(chan os.Signal, 1)
	done := make(chan bool, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-sigs
		wg.Done()
		done <- true
	}()

	defer fmt.Printf("\r%s\r", strings.Repeat(" ", 208)) // clear the bar when done
	go func() {

		for i := 0; ; i++ {
			select {
				case <- done:
					break
				default:
					wait_until_next_edge(delay, thresh)
					now := time.Now()
					fmt.Print(make_statbar(now))
			}
		}
	}()
	wg.Wait()
}