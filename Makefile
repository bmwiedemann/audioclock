PREFIX?=/usr
DATADIR?=${PREFIX}/share/audioclock
BINDIR?=${PREFIX}/bin

.PHONY: run install
run:
	./audioclock

install:
	install -d ${DESTDIR}${DATADIR} ${DESTDIR}${BINDIR}
	install -p -m 644 *.wav ${DESTDIR}${DATADIR}
	install -p -m 755 audioclock ${DESTDIR}${BINDIR}
