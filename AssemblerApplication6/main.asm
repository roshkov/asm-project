;
; AssemblerApplication6.asm
;
; Created: 11/14/2018 3:39:07 PM
; Author : Michal Ciebien
;


; Replace with your application code

.ORG 0
JMP MAIN

 .ORG 0x02 ; vector interrupt for INT0 = 0x02
	call int_detect_wave_from_sensor

	main :
	.ORG 0x100
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, LOW(RAMEND)
	OUT SPL, R16 ; initialize stack pointer
	clr r16
	
	ldi r16, 0xFF ;
	out DDRA, r16 ; port A output
	ldi r16, 0x00 
	out DDRD, r16 ; port D input
	
	ldi r16, 0x01
	STS EICRA, r16 ; make INT0 rising edge triggered
	clr r16

	ldi r16, 0x01
	OUT EIMSK, r16 ; enable INT0 interrupt
	SEI ; enable interrupts
	clr r16

	ldi r16, 1<<PA0
	out PORTA, r16 // Send HIGH on PA0 to start the detect
	ldi r16, 0
	out PORTA, r16 // clear the PA0
	clr r16


	; get data from ultrasonic sensor

	call delay_detection_60ms
	
	
	; sbic PIND, PD7  ; get high from aultrasonic sensor
	
	ldi r21, 1<<PD0

	delay_detection_60ms: ; delay by 750x800x32 = 19.2 10^6 clock cycles, which is  around 1.2s
	ldi r17, 250
	
	again:
	dec r17 ; 1 c
	brne again ; 2c
	ldi r17, 80
	again2:
	dec r17
	brne again2
	ret
	
		; R20 responsible for holding data time for buzzer
	; send High Time
	
    rjmp main

	
	int_detect_wave_from_sensor:

	 ldi r19, 1<<PA2 ; high on PA2 for buzzer 
	 out PORTA, r19
	 call delay_detection_60ms
	 clr r19
	 reti


