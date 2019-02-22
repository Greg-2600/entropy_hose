#!/bin/bash

# To satiate my own curiosity, I was interested in testing a theory that Matt Blaze spoke about.
# With the amount of imbeded, virtualized, containerized, etcetera environments out there... 
# Is it possible to create arbitrarily random numbers without access to a hardware clock?

tight_loop() {
# enter tight_loop() name space scope

  # how many trips through the loop
  iterator=60000

  # time in nanoseconds when we enter the loop
  start_time=$(date +%s%N)

  for ((i=1; i<=$iterator; i++)) {  # START for loop 
    : 			                        # \0x90 noop
  }				                          # END for loop

  # time in nanoseconds when we exit the loop
  end_time=$(date +%s%N) 

  # temperal differntial while noop looping
  let delta_time=$end_time-$start_time

  # substring last 4 int from differential
  entropy=${delta_time:(-4)}

  # send entropy to pool via STDOUT
  # remove trailing newline
  # remove squeeze repeat
  echo $entropy|tr -d "\n"|tr -s '0-9'

# END tight_loop namespace scope
}  

threading() {
# enter threading namespace

  # ask the kernel for the number of cores
  core_count=$(grep "model name" /proc/cpuinfo|wc -l)

  # set an iterator and subtract one core
  iterator=$(seq 2 $core_count)

    for core_id in $iterator; do
      tight_loop &
    done
    wait
# END threading() namespace
}

main() {
# enter main namespace

  while [ 1 ]; do  # while loop start
    threading	     # actually forking, but whatever
  done		         # exit while loop

# END main() namespace
}

# init
main
