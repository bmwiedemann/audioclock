DESTDIR?=/usr
DATADIR?=/share/audioclock
BINDIR?=/bin
run:
	./audioclock

install:
	install -d ${DESTDIR}${DATADIR} ${DESTDIR}${BINDIR}
	install -p -m 644 *.wav ${DESTDIR}${DATADIR}
	install -p -m 755 audioclock ${DESTDIR}${BINDIR}
