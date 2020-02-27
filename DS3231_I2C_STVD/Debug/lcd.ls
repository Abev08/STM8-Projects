   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  45                     ; 6 void LCD_GPIO_init(void)
  45                     ; 7 {
  47                     	switch	.text
  48  0000               _LCD_GPIO_init:
  52                     ; 8 	GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
  54  0000 4bf0          	push	#240
  55  0002 4b02          	push	#2
  56  0004 ae500a        	ldw	x,#20490
  57  0007 cd0000        	call	_GPIO_Init
  59  000a 85            	popw	x
  60                     ; 9 	GPIO_Init(LCD_PORT, LCD_RW, GPIO_MODE_OUT_PP_HIGH_FAST);
  62  000b 4bf0          	push	#240
  63  000d 4b04          	push	#4
  64  000f ae500a        	ldw	x,#20490
  65  0012 cd0000        	call	_GPIO_Init
  67  0015 85            	popw	x
  68                     ; 10 	GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
  70  0016 4bf0          	push	#240
  71  0018 4b08          	push	#8
  72  001a ae500a        	ldw	x,#20490
  73  001d cd0000        	call	_GPIO_Init
  75  0020 85            	popw	x
  76                     ; 11 	GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
  78  0021 4bf0          	push	#240
  79  0023 4b10          	push	#16
  80  0025 ae500a        	ldw	x,#20490
  81  0028 cd0000        	call	_GPIO_Init
  83  002b 85            	popw	x
  84                     ; 12 	GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
  86  002c 4bf0          	push	#240
  87  002e 4b20          	push	#32
  88  0030 ae500a        	ldw	x,#20490
  89  0033 cd0000        	call	_GPIO_Init
  91  0036 85            	popw	x
  92                     ; 13 	GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
  94  0037 4bf0          	push	#240
  95  0039 4b40          	push	#64
  96  003b ae500a        	ldw	x,#20490
  97  003e cd0000        	call	_GPIO_Init
  99  0041 85            	popw	x
 100                     ; 14 	GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
 102  0042 4bf0          	push	#240
 103  0044 4b80          	push	#128
 104  0046 ae500a        	ldw	x,#20490
 105  0049 cd0000        	call	_GPIO_Init
 107  004c 85            	popw	x
 108                     ; 15 	delay_ms(10);
 110  004d ae000a        	ldw	x,#10
 111  0050 cd0000        	call	_delay_ms
 113                     ; 17 	GPIO_WriteLow(LCD_PORT, LCD_RW);
 115  0053 4b04          	push	#4
 116  0055 ae500a        	ldw	x,#20490
 117  0058 cd0000        	call	_GPIO_WriteLow
 119  005b 84            	pop	a
 120                     ; 18 }
 123  005c 81            	ret
 151                     ; 20 void LCD_init(void)
 151                     ; 21 {
 152                     	switch	.text
 153  005d               _LCD_init:
 157                     ; 22 	LCD_GPIO_init();
 159  005d ada1          	call	_LCD_GPIO_init
 161                     ; 23 	toggle_EN_pin();
 163  005f cd01e7        	call	_toggle_EN_pin
 165                     ; 25 	GPIO_WriteLow(LCD_PORT, LCD_RS);
 167  0062 4b02          	push	#2
 168  0064 ae500a        	ldw	x,#20490
 169  0067 cd0000        	call	_GPIO_WriteLow
 171  006a 84            	pop	a
 172                     ; 26 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 174  006b 4b80          	push	#128
 175  006d ae500a        	ldw	x,#20490
 176  0070 cd0000        	call	_GPIO_WriteLow
 178  0073 84            	pop	a
 179                     ; 27 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 181  0074 4b40          	push	#64
 182  0076 ae500a        	ldw	x,#20490
 183  0079 cd0000        	call	_GPIO_WriteLow
 185  007c 84            	pop	a
 186                     ; 28 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 188  007d 4b20          	push	#32
 189  007f ae500a        	ldw	x,#20490
 190  0082 cd0000        	call	_GPIO_WriteHigh
 192  0085 84            	pop	a
 193                     ; 29 	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
 195  0086 4b10          	push	#16
 196  0088 ae500a        	ldw	x,#20490
 197  008b cd0000        	call	_GPIO_WriteHigh
 199  008e 84            	pop	a
 200                     ; 30 	toggle_EN_pin();
 202  008f cd01e7        	call	_toggle_EN_pin
 204                     ; 32 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 206  0092 4b80          	push	#128
 207  0094 ae500a        	ldw	x,#20490
 208  0097 cd0000        	call	_GPIO_WriteLow
 210  009a 84            	pop	a
 211                     ; 33 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 213  009b 4b40          	push	#64
 214  009d ae500a        	ldw	x,#20490
 215  00a0 cd0000        	call	_GPIO_WriteLow
 217  00a3 84            	pop	a
 218                     ; 34 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 220  00a4 4b20          	push	#32
 221  00a6 ae500a        	ldw	x,#20490
 222  00a9 cd0000        	call	_GPIO_WriteHigh
 224  00ac 84            	pop	a
 225                     ; 35 	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
 227  00ad 4b10          	push	#16
 228  00af ae500a        	ldw	x,#20490
 229  00b2 cd0000        	call	_GPIO_WriteHigh
 231  00b5 84            	pop	a
 232                     ; 36 	toggle_EN_pin();
 234  00b6 cd01e7        	call	_toggle_EN_pin
 236                     ; 38 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 238  00b9 4b80          	push	#128
 239  00bb ae500a        	ldw	x,#20490
 240  00be cd0000        	call	_GPIO_WriteLow
 242  00c1 84            	pop	a
 243                     ; 39 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 245  00c2 4b40          	push	#64
 246  00c4 ae500a        	ldw	x,#20490
 247  00c7 cd0000        	call	_GPIO_WriteLow
 249  00ca 84            	pop	a
 250                     ; 40 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 252  00cb 4b20          	push	#32
 253  00cd ae500a        	ldw	x,#20490
 254  00d0 cd0000        	call	_GPIO_WriteHigh
 256  00d3 84            	pop	a
 257                     ; 41 	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
 259  00d4 4b10          	push	#16
 260  00d6 ae500a        	ldw	x,#20490
 261  00d9 cd0000        	call	_GPIO_WriteHigh
 263  00dc 84            	pop	a
 264                     ; 42 	toggle_EN_pin();
 266  00dd cd01e7        	call	_toggle_EN_pin
 268                     ; 44 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 270  00e0 4b80          	push	#128
 271  00e2 ae500a        	ldw	x,#20490
 272  00e5 cd0000        	call	_GPIO_WriteLow
 274  00e8 84            	pop	a
 275                     ; 45 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 277  00e9 4b40          	push	#64
 278  00eb ae500a        	ldw	x,#20490
 279  00ee cd0000        	call	_GPIO_WriteLow
 281  00f1 84            	pop	a
 282                     ; 46 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 284  00f2 4b20          	push	#32
 285  00f4 ae500a        	ldw	x,#20490
 286  00f7 cd0000        	call	_GPIO_WriteHigh
 288  00fa 84            	pop	a
 289                     ; 47 	GPIO_WriteLow(LCD_PORT, LCD_DB4);
 291  00fb 4b10          	push	#16
 292  00fd ae500a        	ldw	x,#20490
 293  0100 cd0000        	call	_GPIO_WriteLow
 295  0103 84            	pop	a
 296                     ; 48 	toggle_EN_pin();
 298  0104 cd01e7        	call	_toggle_EN_pin
 300                     ; 50 	LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
 302  0107 ae2800        	ldw	x,#10240
 303  010a ad10          	call	_LCD_send
 305                     ; 51 	LCD_send((display_on | cursor_off | blink_off), CMD);
 307  010c ae0c00        	ldw	x,#3072
 308  010f ad0b          	call	_LCD_send
 310                     ; 52 	LCD_send(clear_display, CMD);
 312  0111 ae0100        	ldw	x,#256
 313  0114 ad06          	call	_LCD_send
 315                     ; 53 	LCD_send((cursor_direction_inc | display_no_shift), CMD);
 317  0116 ae0600        	ldw	x,#1536
 318  0119 ad01          	call	_LCD_send
 320                     ; 54 }
 323  011b 81            	ret
 369                     ; 56 void LCD_send(unsigned char value, unsigned char mode)
 369                     ; 57 {
 370                     	switch	.text
 371  011c               _LCD_send:
 373  011c 89            	pushw	x
 374       00000000      OFST:	set	0
 377                     ; 58 	switch(mode)
 379  011d 9f            	ld	a,xl
 381                     ; 68 			break;
 382  011e 4d            	tnz	a
 383  011f 270e          	jreq	L33
 384  0121 4a            	dec	a
 385  0122 2614          	jrne	L16
 386                     ; 62 			GPIO_WriteHigh(LCD_PORT, LCD_RS);
 388  0124 4b02          	push	#2
 389  0126 ae500a        	ldw	x,#20490
 390  0129 cd0000        	call	_GPIO_WriteHigh
 392  012c 84            	pop	a
 393                     ; 63 			break;
 395  012d 2009          	jra	L16
 396  012f               L33:
 397                     ; 67 			GPIO_WriteLow(LCD_PORT, LCD_RS);
 399  012f 4b02          	push	#2
 400  0131 ae500a        	ldw	x,#20490
 401  0134 cd0000        	call	_GPIO_WriteLow
 403  0137 84            	pop	a
 404                     ; 68 			break;
 406  0138               L16:
 407                     ; 72 	LCD_4bit_send(value);
 409  0138 7b01          	ld	a,(OFST+1,sp)
 410  013a ad02          	call	_LCD_4bit_send
 412                     ; 73 }
 415  013c 85            	popw	x
 416  013d 81            	ret
 452                     ; 75 void LCD_4bit_send(unsigned char lcd_data)       
 452                     ; 76 {
 453                     	switch	.text
 454  013e               _LCD_4bit_send:
 456  013e 88            	push	a
 457       00000000      OFST:	set	0
 460                     ; 77 	toggle_io(lcd_data, 7, LCD_DB7);
 462  013f 4b80          	push	#128
 463  0141 ae0007        	ldw	x,#7
 464  0144 95            	ld	xh,a
 465  0145 cd0200        	call	_toggle_io
 467  0148 84            	pop	a
 468                     ; 78 	toggle_io(lcd_data, 6, LCD_DB6);
 470  0149 4b40          	push	#64
 471  014b 7b02          	ld	a,(OFST+2,sp)
 472  014d ae0006        	ldw	x,#6
 473  0150 95            	ld	xh,a
 474  0151 cd0200        	call	_toggle_io
 476  0154 84            	pop	a
 477                     ; 79 	toggle_io(lcd_data, 5, LCD_DB5);
 479  0155 4b20          	push	#32
 480  0157 7b02          	ld	a,(OFST+2,sp)
 481  0159 ae0005        	ldw	x,#5
 482  015c 95            	ld	xh,a
 483  015d cd0200        	call	_toggle_io
 485  0160 84            	pop	a
 486                     ; 80 	toggle_io(lcd_data, 4, LCD_DB4);
 488  0161 4b10          	push	#16
 489  0163 7b02          	ld	a,(OFST+2,sp)
 490  0165 ae0004        	ldw	x,#4
 491  0168 95            	ld	xh,a
 492  0169 cd0200        	call	_toggle_io
 494  016c 84            	pop	a
 495                     ; 81 	toggle_EN_pin();
 497  016d ad78          	call	_toggle_EN_pin
 499                     ; 82 	toggle_io(lcd_data, 3, LCD_DB7);
 501  016f 4b80          	push	#128
 502  0171 7b02          	ld	a,(OFST+2,sp)
 503  0173 ae0003        	ldw	x,#3
 504  0176 95            	ld	xh,a
 505  0177 cd0200        	call	_toggle_io
 507  017a 84            	pop	a
 508                     ; 83 	toggle_io(lcd_data, 2, LCD_DB6);
 510  017b 4b40          	push	#64
 511  017d 7b02          	ld	a,(OFST+2,sp)
 512  017f ae0002        	ldw	x,#2
 513  0182 95            	ld	xh,a
 514  0183 ad7b          	call	_toggle_io
 516  0185 84            	pop	a
 517                     ; 84 	toggle_io(lcd_data, 1, LCD_DB5);
 519  0186 4b20          	push	#32
 520  0188 7b02          	ld	a,(OFST+2,sp)
 521  018a ae0001        	ldw	x,#1
 522  018d 95            	ld	xh,a
 523  018e ad70          	call	_toggle_io
 525  0190 84            	pop	a
 526                     ; 85 	toggle_io(lcd_data, 0, LCD_DB4);
 528  0191 4b10          	push	#16
 529  0193 7b02          	ld	a,(OFST+2,sp)
 530  0195 5f            	clrw	x
 531  0196 95            	ld	xh,a
 532  0197 ad67          	call	_toggle_io
 534  0199 84            	pop	a
 535                     ; 86 	toggle_EN_pin();
 537  019a ad4b          	call	_toggle_EN_pin
 539                     ; 87 }
 542  019c 84            	pop	a
 543  019d 81            	ret
 579                     ; 89 void LCD_putstr(char *lcd_string)
 579                     ; 90 {
 580                     	switch	.text
 581  019e               _LCD_putstr:
 583  019e 89            	pushw	x
 584       00000000      OFST:	set	0
 587  019f               L711:
 588                     ; 93 		LCD_send(*lcd_string++, DAT);
 590  019f 1e01          	ldw	x,(OFST+1,sp)
 591  01a1 1c0001        	addw	x,#1
 592  01a4 1f01          	ldw	(OFST+1,sp),x
 593  01a6 1d0001        	subw	x,#1
 594  01a9 f6            	ld	a,(x)
 595  01aa ae0001        	ldw	x,#1
 596  01ad 95            	ld	xh,a
 597  01ae cd011c        	call	_LCD_send
 599                     ; 94 	} while(*lcd_string != '\0');
 601  01b1 1e01          	ldw	x,(OFST+1,sp)
 602  01b3 7d            	tnz	(x)
 603  01b4 26e9          	jrne	L711
 604                     ; 95 }
 607  01b6 85            	popw	x
 608  01b7 81            	ret
 643                     ; 97 void LCD_putchar(char char_data)
 643                     ; 98 {
 644                     	switch	.text
 645  01b8               _LCD_putchar:
 649                     ; 99 	LCD_send(char_data, DAT);
 651  01b8 ae0001        	ldw	x,#1
 652  01bb 95            	ld	xh,a
 653  01bc cd011c        	call	_LCD_send
 655                     ; 100 }
 658  01bf 81            	ret
 682                     ; 102 void LCD_clear_home(void)
 682                     ; 103 {
 683                     	switch	.text
 684  01c0               _LCD_clear_home:
 688                     ; 104 	LCD_send(clear_display, CMD);
 690  01c0 ae0100        	ldw	x,#256
 691  01c3 cd011c        	call	_LCD_send
 693                     ; 105 	LCD_send(goto_home, CMD);
 695  01c6 ae0200        	ldw	x,#512
 696  01c9 cd011c        	call	_LCD_send
 698                     ; 106 }
 701  01cc 81            	ret
 745                     ; 108 void LCD_goto(unsigned char x_pos, unsigned char y_pos)
 745                     ; 109 {
 746                     	switch	.text
 747  01cd               _LCD_goto:
 749  01cd 89            	pushw	x
 750       00000000      OFST:	set	0
 753                     ; 110 	if(y_pos == 0) LCD_send((0x80 | x_pos), CMD);
 755  01ce 9f            	ld	a,xl
 756  01cf 4d            	tnz	a
 757  01d0 260a          	jrne	L571
 760  01d2 9e            	ld	a,xh
 761  01d3 aa80          	or	a,#128
 762  01d5 5f            	clrw	x
 763  01d6 95            	ld	xh,a
 764  01d7 cd011c        	call	_LCD_send
 767  01da 2009          	jra	L771
 768  01dc               L571:
 769                     ; 111 	else LCD_send((0x80 | 0x40 | x_pos), CMD);
 771  01dc 7b01          	ld	a,(OFST+1,sp)
 772  01de aac0          	or	a,#192
 773  01e0 5f            	clrw	x
 774  01e1 95            	ld	xh,a
 775  01e2 cd011c        	call	_LCD_send
 777  01e5               L771:
 778                     ; 112 }
 781  01e5 85            	popw	x
 782  01e6 81            	ret
 808                     ; 114 void toggle_EN_pin(void)
 808                     ; 115 {
 809                     	switch	.text
 810  01e7               _toggle_EN_pin:
 814                     ; 116 	GPIO_WriteHigh(LCD_PORT, LCD_EN);
 816  01e7 4b08          	push	#8
 817  01e9 ae500a        	ldw	x,#20490
 818  01ec cd0000        	call	_GPIO_WriteHigh
 820  01ef 84            	pop	a
 821                     ; 117 	delay_ms(2);
 823  01f0 ae0002        	ldw	x,#2
 824  01f3 cd0000        	call	_delay_ms
 826                     ; 118 	GPIO_WriteLow(LCD_PORT, LCD_EN);
 828  01f6 4b08          	push	#8
 829  01f8 ae500a        	ldw	x,#20490
 830  01fb cd0000        	call	_GPIO_WriteLow
 832  01fe 84            	pop	a
 833                     ; 119 }
 836  01ff 81            	ret
 920                     ; 121 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
 920                     ; 122 {
 921                     	switch	.text
 922  0200               _toggle_io:
 924  0200 89            	pushw	x
 925  0201 88            	push	a
 926       00000001      OFST:	set	1
 929                     ; 123 	bool temp = FALSE;
 931                     ; 125 	temp = (0x01 & (lcd_data >> bit_pos));
 933  0202 9f            	ld	a,xl
 934  0203 5f            	clrw	x
 935  0204 97            	ld	xl,a
 936  0205 7b02          	ld	a,(OFST+1,sp)
 937  0207 5d            	tnzw	x
 938  0208 2704          	jreq	L03
 939  020a               L23:
 940  020a 44            	srl	a
 941  020b 5a            	decw	x
 942  020c 26fc          	jrne	L23
 943  020e               L03:
 944  020e a401          	and	a,#1
 945  0210 6b01          	ld	(OFST+0,sp),a
 947                     ; 127 	switch(temp)
 949  0212 7b01          	ld	a,(OFST+0,sp)
 950  0214 a101          	cp	a,#1
 951  0216 260c          	jrne	L312
 954  0218               L112:
 955                     ; 131 			GPIO_WriteHigh(LCD_PORT, pin_num);
 957  0218 7b06          	ld	a,(OFST+5,sp)
 958  021a 88            	push	a
 959  021b ae500a        	ldw	x,#20490
 960  021e cd0000        	call	_GPIO_WriteHigh
 962  0221 84            	pop	a
 963                     ; 132 			break;
 965  0222 200a          	jra	L162
 966  0224               L312:
 967                     ; 136 			GPIO_WriteLow(LCD_PORT, pin_num);
 969  0224 7b06          	ld	a,(OFST+5,sp)
 970  0226 88            	push	a
 971  0227 ae500a        	ldw	x,#20490
 972  022a cd0000        	call	_GPIO_WriteLow
 974  022d 84            	pop	a
 975                     ; 137 			break;
 976  022e               L162:
 977                     ; 140 }
 980  022e 5b03          	addw	sp,#3
 981  0230 81            	ret
1027                     ; 142 void LCD_putint8(uint8_t number)
1027                     ; 143 {
1028                     	switch	.text
1029  0231               _LCD_putint8:
1031  0231 5204          	subw	sp,#4
1032       00000004      OFST:	set	4
1035                     ; 145 	uint8_to_string(number, temp);
1037  0233 96            	ldw	x,sp
1038  0234 1c0001        	addw	x,#OFST-3
1039  0237 89            	pushw	x
1040  0238 cd0000        	call	_uint8_to_string
1042  023b 85            	popw	x
1043                     ; 147 	LCD_putstr(temp);
1045  023c 96            	ldw	x,sp
1046  023d 1c0001        	addw	x,#OFST-3
1047  0240 cd019e        	call	_LCD_putstr
1049                     ; 148 }
1052  0243 5b04          	addw	sp,#4
1053  0245 81            	ret
1066                     	xref	_uint8_to_string
1067                     	xref	_delay_ms
1068                     	xdef	_toggle_io
1069                     	xdef	_toggle_EN_pin
1070                     	xdef	_LCD_goto
1071                     	xdef	_LCD_clear_home
1072                     	xdef	_LCD_putint8
1073                     	xdef	_LCD_putchar
1074                     	xdef	_LCD_putstr
1075                     	xdef	_LCD_4bit_send
1076                     	xdef	_LCD_send
1077                     	xdef	_LCD_init
1078                     	xdef	_LCD_GPIO_init
1079                     	xref	_GPIO_WriteLow
1080                     	xref	_GPIO_WriteHigh
1081                     	xref	_GPIO_Init
1100                     	end
