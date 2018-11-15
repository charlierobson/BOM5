;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;
.module WHIMSY


START1 = 0
LEN1 = 18
START2 = 23
LEN2 = 10

updatecloud:
	ld		a,(frames)
	and		a
	ret		nz

	ld		a,(cldfrm)
	inc		a
	and		63
	ld		(cldfrm),a
	or		clouds & 255
	ld		l,a
	ld		h,clouds / 256
	ld		de,dfile+1+START1
	ld		bc,LEN1
	ldir
	inc		hl
	inc		hl
	inc		hl
	inc		hl
	inc		de
	inc		de
	inc		de
	inc		de
	ld		bc,LEN2
	ldir
	ret


lorryfill:
	ld		a,(fuelchar)				; show fuel pumping into lorry
	xor		FUEL1 ^ FUEL2
	ld		(fuelchar),a
	ld		(dfile+FUELLING_OFFS),a
	ret


showwinch:
	ld		a,(winchframe)
	and		3
	rlca
	or		winchanim & 255
	ld		l,a
	ld		h,winchanim / 256
	ld		b,(hl)
	inc		hl
	ld		c,(hl)
	ld		hl,dfile+WINCH_OFFS
	ld		(hl),b
	inc		hl
	ld		(hl),c
	ret


gameoverscreen: 
	ld		hl,scnEnd
	ld		de,dfile
	call	decrunch

;;	call	init_stc
;;	ld		a,16
;;	ld		(pl_current_position),a
;;	call	next_pattern

	ld		a,150
	ld		(timeout),a

_endloop:
	call	copyDFile
	call	readGameInput

;;	ld		a,(pl_current_position)
;;	cp		18
;;	call	z,initsfx

	ld		a,(ctlFire)
	and		3
	cp		1
	ret		z

	ld		a,(timeout)
	dec		a
	ld		(timeout),a
	jr		nz,_endloop
	ret
