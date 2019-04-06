set ns [new Simulator]

set namfile [open ip.nam w]
$ns namtrace-all $namfile
set tracefile [open ip.tr w]
$ns trace-all $tracefile

proc finish {} {
        global ns namfile tracefile
        $ns flush-trace
        close $namfile
        close $tracefile
	
        exit 0
}

set node1 [$ns node]
$ns at 0.0 "$node1 label localhost"

set ipfile [open "ip.txt" r]
set ipurl [read $ipfile]


set j 0
set count 3
foreach i $ipurl {
		if {$count%3==0} {
			set iparr $i
			set n($iparr) [$ns node]
 			$ns at 0.0 "$n($iparr) label $iparr"
			$ns duplex-link $n($iparr) $node1 10Mb 10ms DropTail
                        puts n($iparr)			
	} else {
		set m($i) [$ns node]
		puts m($i)
		$ns at 0.0 "$m($i) label $i"
		$ns duplex-link $m($i) $n($iparr) 10Mb 10ms DropTail
                }
	incr count
	
}
puts $iparr



$ns run
