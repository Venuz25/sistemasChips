
	ldi r16, $fa
	ldi r17, $f0

	cp r16, r17	
	breq suma

	fin:
		rjmp fin

	suma:
		add r16, r17
		rjmp fin
