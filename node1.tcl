set ns [new Simulator]

#Fixing the co-ordinate of simutaion area
set val(x) 500
set val(y) 500
# Define options
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model

set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 2 ;# number of mobilenodes
set val(rp) AODV ;# routing protocol
set val(x) 500 ;# X dimension of topography
set val(y) 400 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Nam File Creation nam – network animator
set namfile [open node.nam w]

#Tracing all the events and cofiguration
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#Trace File creation
set tracefile [open node.tr w]

#Tracing all the events and cofiguration
$ns trace-all $tracefile

# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

# Node Creation
set node(1) [$ns node]
# Initial color of the node
$node(1) color black
set node(2) [$ns node]
$node(2) color black
#Location fixing for a single node
for {set i 1} {$i < 3} {incr i} {
$node($i) set X_ [expr rand()*500]
$node($i) set Y_ [expr rand()*400]
$node($i) set Z_ 0

}
# Label and coloring
$ns at 0.1 "$node(1) color blue"
$ns at 0.1 "$node(1) label Node1"
$ns at 0.1 "$node(2) label Node2"
#Size of the node
$ns initial_node_pos $node(1) 30
$ns initial_node_pos $node(2) 30
set udp [new Agent/UDP]

# Attaching transport agent to sender node
$ns attach-agent $node(1) $udp

# Defining a transport agent for receiving
set null [new Agent/Null]

# Attaching transport agent to receiver node
$ns attach-agent $node(2) $null

#Connecting sending and receiving transport agents
$ns connect $udp $null

#Defining Application instance
set cbr [new Application/Traffic/CBR]

# Attaching transport agent to application agent
$cbr attach-agent $udp

#Packet size in bytes and interval in seconds definition
$cbr set packetSize_ 512
$cbr set interval_ 0.1

# data packet generation starting time
$ns at 1.0 "$cbr start"

# data packet generation ending time
#$ns at 6.0 "$cbr stop"
# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"

#Stopping the scheduler
$ns at 10.01 "puts \"end simulation\" ; $ns halt"
#$ns at 10.01 "$ns halt"
proc stop {} {
global namfile tracefile ns
$ns flush-trace
close $namfile
close $tracefile
#executing nam file
exec nam node.nam &
}

#Starting scheduler
$ns run
