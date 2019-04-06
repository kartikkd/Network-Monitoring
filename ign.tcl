set ns [new Simulator]

set namfile [open ign.nam w]
$ns namtrace-all $namfile
set tracefile [open ign.tr w]
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
set ipadd [read $ipfile]
puts $ipadd
set count1 1
set count 2
set urlfile [open "imp.txt" r]
set urladd [read $urlfile]
puts $urladd

array set ip {}
array set url {}

foreach j $ipadd {
	set end($j) [$ns node]
	$ns duplex-link $end($j) $node1 10Mb 10ms DropTail
	$ns at 0.0 "$end($j) label end-point($count1)"
	incr count1
	foreach i $urladd {
		if {$count%2!=0} {
			set n($i) [$ns node]
			puts n($i)
			$ns at 0.0 "$n($i) label $i"
			$ns duplex-link $n($i) $end($j) 10Mb 10ms DropTail
	} 
	incr count
	
}

}

for {set n 0} {n < 

#set count 2
#array set id {}
#array set url {}
#foreach i $content {
#	if {$count%2!=0} {
#		set n($i) [$ns node]
#		puts n($i)
#		$ns at 0.0 "$n($i) label $i"
#		$ns duplex-link $n($i) $end 10Mb 10ms DropTail
#	} 
#	incr count
	
#}



set num [lindex $argv 0]
#for {set i 0} {$i < $num } { incr i} {
#	set n($i) [$ns node]
#	puts n($i)
#	$ns at 0.0 "$n($i) label node($i)"
#	$ns duplex-link $n($i) $node1 10Mb 10ms DropTail
#}




$ns run

