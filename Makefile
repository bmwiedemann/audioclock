run:
	cat *.wav > /dev/null
	taskset 1 ./clock.pl
