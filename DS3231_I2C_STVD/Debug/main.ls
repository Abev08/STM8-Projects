   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  63                     ; 13 void delay_us(unsigned int value)
  63                     ; 14 {
  65                     	switch	.text
  66  0000               _delay_us:
  68  0000 89            	pushw	x
  69       00000002      OFST:	set	2
  72                     ; 15 	unsigned int loops = (dly_const * value) * 1.174; // Times 1.174 to get closer to real value
  74  0001 cd0000        	call	c_uitof
  76  0004 ae0032        	ldw	x,#L73
  77  0007 cd0000        	call	c_fmul
  79  000a ae002e        	ldw	x,#L74
  80  000d cd0000        	call	c_fmul
  82  0010 cd0000        	call	c_ftoi
  84  0013 1f01          	ldw	(OFST-1,sp),x
  87  0015 2008          	jra	L75
  88  0017               L35:
  89                     ; 19 		_asm("nop");
  92  0017 9d            nop
  94                     ; 20 		loops--;
  96  0018 1e01          	ldw	x,(OFST-1,sp)
  97  001a 1d0001        	subw	x,#1
  98  001d 1f01          	ldw	(OFST-1,sp),x
 100  001f               L75:
 101                     ; 17 	while(loops)
 103  001f 1e01          	ldw	x,(OFST-1,sp)
 104  0021 26f4          	jrne	L35
 105                     ; 22 }
 108  0023 85            	popw	x
 109  0024 81            	ret
 144                     ; 24 void delay_ms(unsigned int value)
 144                     ; 25 {
 145                     	switch	.text
 146  0025               _delay_ms:
 148  0025 89            	pushw	x
 149       00000000      OFST:	set	0
 152  0026 200c          	jra	L301
 153  0028               L101:
 154                     ; 28 		delay_us(1000);
 156  0028 ae03e8        	ldw	x,#1000
 157  002b add3          	call	_delay_us
 159                     ; 29 		value--;
 161  002d 1e01          	ldw	x,(OFST+1,sp)
 162  002f 1d0001        	subw	x,#1
 163  0032 1f01          	ldw	(OFST+1,sp),x
 164  0034               L301:
 165                     ; 26 	while(value)
 167  0034 1e01          	ldw	x,(OFST+1,sp)
 168  0036 26f0          	jrne	L101
 169                     ; 31 }
 172  0038 85            	popw	x
 173  0039 81            	ret
 216                     ; 63 void LCD_GPIO_init(void)
 216                     ; 64 {
 217                     	switch	.text
 218  003a               _LCD_GPIO_init:
 222                     ; 65 	GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
 224  003a 4bf0          	push	#240
 225  003c 4b02          	push	#2
 226  003e ae500a        	ldw	x,#20490
 227  0041 cd0000        	call	_GPIO_Init
 229  0044 85            	popw	x
 230                     ; 66 	GPIO_Init(LCD_PORT, LCD_RW, GPIO_MODE_OUT_PP_HIGH_FAST);
 232  0045 4bf0          	push	#240
 233  0047 4b04          	push	#4
 234  0049 ae500a        	ldw	x,#20490
 235  004c cd0000        	call	_GPIO_Init
 237  004f 85            	popw	x
 238                     ; 67 	GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
 240  0050 4bf0          	push	#240
 241  0052 4b08          	push	#8
 242  0054 ae500a        	ldw	x,#20490
 243  0057 cd0000        	call	_GPIO_Init
 245  005a 85            	popw	x
 246                     ; 68 	GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
 248  005b 4bf0          	push	#240
 249  005d 4b10          	push	#16
 250  005f ae500a        	ldw	x,#20490
 251  0062 cd0000        	call	_GPIO_Init
 253  0065 85            	popw	x
 254                     ; 69 	GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
 256  0066 4bf0          	push	#240
 257  0068 4b20          	push	#32
 258  006a ae500a        	ldw	x,#20490
 259  006d cd0000        	call	_GPIO_Init
 261  0070 85            	popw	x
 262                     ; 70 	GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
 264  0071 4bf0          	push	#240
 265  0073 4b40          	push	#64
 266  0075 ae500a        	ldw	x,#20490
 267  0078 cd0000        	call	_GPIO_Init
 269  007b 85            	popw	x
 270                     ; 71 	GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
 272  007c 4bf0          	push	#240
 273  007e 4b80          	push	#128
 274  0080 ae500a        	ldw	x,#20490
 275  0083 cd0000        	call	_GPIO_Init
 277  0086 85            	popw	x
 278                     ; 72 	delay_ms(10);
 280  0087 ae000a        	ldw	x,#10
 281  008a ad99          	call	_delay_ms
 283                     ; 74 	GPIO_WriteLow(LCD_PORT, LCD_RW);
 285  008c 4b04          	push	#4
 286  008e ae500a        	ldw	x,#20490
 287  0091 cd0000        	call	_GPIO_WriteLow
 289  0094 84            	pop	a
 290                     ; 75 }
 293  0095 81            	ret
 321                     ; 78 void LCD_init(void)
 321                     ; 79 {
 322                     	switch	.text
 323  0096               _LCD_init:
 327                     ; 80 	LCD_GPIO_init();
 329  0096 ada2          	call	_LCD_GPIO_init
 331                     ; 81 	toggle_EN_pin();
 333  0098 cd0220        	call	_toggle_EN_pin
 335                     ; 83 	GPIO_WriteLow(LCD_PORT, LCD_RS);
 337  009b 4b02          	push	#2
 338  009d ae500a        	ldw	x,#20490
 339  00a0 cd0000        	call	_GPIO_WriteLow
 341  00a3 84            	pop	a
 342                     ; 84 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 344  00a4 4b80          	push	#128
 345  00a6 ae500a        	ldw	x,#20490
 346  00a9 cd0000        	call	_GPIO_WriteLow
 348  00ac 84            	pop	a
 349                     ; 85 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 351  00ad 4b40          	push	#64
 352  00af ae500a        	ldw	x,#20490
 353  00b2 cd0000        	call	_GPIO_WriteLow
 355  00b5 84            	pop	a
 356                     ; 86 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 358  00b6 4b20          	push	#32
 359  00b8 ae500a        	ldw	x,#20490
 360  00bb cd0000        	call	_GPIO_WriteHigh
 362  00be 84            	pop	a
 363                     ; 87 	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
 365  00bf 4b10          	push	#16
 366  00c1 ae500a        	ldw	x,#20490
 367  00c4 cd0000        	call	_GPIO_WriteHigh
 369  00c7 84            	pop	a
 370                     ; 88 	toggle_EN_pin();
 372  00c8 cd0220        	call	_toggle_EN_pin
 374                     ; 90 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 376  00cb 4b80          	push	#128
 377  00cd ae500a        	ldw	x,#20490
 378  00d0 cd0000        	call	_GPIO_WriteLow
 380  00d3 84            	pop	a
 381                     ; 91 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 383  00d4 4b40          	push	#64
 384  00d6 ae500a        	ldw	x,#20490
 385  00d9 cd0000        	call	_GPIO_WriteLow
 387  00dc 84            	pop	a
 388                     ; 92 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 390  00dd 4b20          	push	#32
 391  00df ae500a        	ldw	x,#20490
 392  00e2 cd0000        	call	_GPIO_WriteHigh
 394  00e5 84            	pop	a
 395                     ; 93 	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
 397  00e6 4b10          	push	#16
 398  00e8 ae500a        	ldw	x,#20490
 399  00eb cd0000        	call	_GPIO_WriteHigh
 401  00ee 84            	pop	a
 402                     ; 94 	toggle_EN_pin();
 404  00ef cd0220        	call	_toggle_EN_pin
 406                     ; 96 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 408  00f2 4b80          	push	#128
 409  00f4 ae500a        	ldw	x,#20490
 410  00f7 cd0000        	call	_GPIO_WriteLow
 412  00fa 84            	pop	a
 413                     ; 97 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 415  00fb 4b40          	push	#64
 416  00fd ae500a        	ldw	x,#20490
 417  0100 cd0000        	call	_GPIO_WriteLow
 419  0103 84            	pop	a
 420                     ; 98 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 422  0104 4b20          	push	#32
 423  0106 ae500a        	ldw	x,#20490
 424  0109 cd0000        	call	_GPIO_WriteHigh
 426  010c 84            	pop	a
 427                     ; 99 	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
 429  010d 4b10          	push	#16
 430  010f ae500a        	ldw	x,#20490
 431  0112 cd0000        	call	_GPIO_WriteHigh
 433  0115 84            	pop	a
 434                     ; 100 	toggle_EN_pin();
 436  0116 cd0220        	call	_toggle_EN_pin
 438                     ; 102 	GPIO_WriteLow(LCD_PORT, LCD_DB7);
 440  0119 4b80          	push	#128
 441  011b ae500a        	ldw	x,#20490
 442  011e cd0000        	call	_GPIO_WriteLow
 444  0121 84            	pop	a
 445                     ; 103 	GPIO_WriteLow(LCD_PORT, LCD_DB6);
 447  0122 4b40          	push	#64
 448  0124 ae500a        	ldw	x,#20490
 449  0127 cd0000        	call	_GPIO_WriteLow
 451  012a 84            	pop	a
 452                     ; 104 	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
 454  012b 4b20          	push	#32
 455  012d ae500a        	ldw	x,#20490
 456  0130 cd0000        	call	_GPIO_WriteHigh
 458  0133 84            	pop	a
 459                     ; 105 	GPIO_WriteLow(LCD_PORT, LCD_DB4);
 461  0134 4b10          	push	#16
 462  0136 ae500a        	ldw	x,#20490
 463  0139 cd0000        	call	_GPIO_WriteLow
 465  013c 84            	pop	a
 466                     ; 106 	toggle_EN_pin();
 468  013d cd0220        	call	_toggle_EN_pin
 470                     ; 108 	LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
 472  0140 ae2800        	ldw	x,#10240
 473  0143 ad10          	call	_LCD_send
 475                     ; 109 	LCD_send((display_on | cursor_off | blink_off), CMD);
 477  0145 ae0c00        	ldw	x,#3072
 478  0148 ad0b          	call	_LCD_send
 480                     ; 110 	LCD_send(clear_display, CMD);
 482  014a ae0100        	ldw	x,#256
 483  014d ad06          	call	_LCD_send
 485                     ; 111 	LCD_send((cursor_direction_inc | display_no_shift), CMD);
 487  014f ae0600        	ldw	x,#1536
 488  0152 ad01          	call	_LCD_send
 490                     ; 112 }
 493  0154 81            	ret
 539                     ; 115 void LCD_send(unsigned char value, unsigned char mode)
 539                     ; 116 {
 540                     	switch	.text
 541  0155               _LCD_send:
 543  0155 89            	pushw	x
 544       00000000      OFST:	set	0
 547                     ; 117 	switch(mode)
 549  0156 9f            	ld	a,xl
 551                     ; 127 			break;
 552  0157 4d            	tnz	a
 553  0158 270e          	jreq	L731
 554  015a 4a            	dec	a
 555  015b 2614          	jrne	L561
 556                     ; 121 			GPIO_WriteHigh(LCD_PORT, LCD_RS);
 558  015d 4b02          	push	#2
 559  015f ae500a        	ldw	x,#20490
 560  0162 cd0000        	call	_GPIO_WriteHigh
 562  0165 84            	pop	a
 563                     ; 122 			break;
 565  0166 2009          	jra	L561
 566  0168               L731:
 567                     ; 126 			GPIO_WriteLow(LCD_PORT, LCD_RS);
 569  0168 4b02          	push	#2
 570  016a ae500a        	ldw	x,#20490
 571  016d cd0000        	call	_GPIO_WriteLow
 573  0170 84            	pop	a
 574                     ; 127 			break;
 576  0171               L561:
 577                     ; 131 	LCD_4bit_send(value);
 579  0171 7b01          	ld	a,(OFST+1,sp)
 580  0173 ad02          	call	_LCD_4bit_send
 582                     ; 132 }
 585  0175 85            	popw	x
 586  0176 81            	ret
 622                     ; 135 void LCD_4bit_send(unsigned char lcd_data)       
 622                     ; 136 {
 623                     	switch	.text
 624  0177               _LCD_4bit_send:
 626  0177 88            	push	a
 627       00000000      OFST:	set	0
 630                     ; 137 	toggle_io(lcd_data, 7, LCD_DB7);
 632  0178 4b80          	push	#128
 633  017a ae0007        	ldw	x,#7
 634  017d 95            	ld	xh,a
 635  017e cd0239        	call	_toggle_io
 637  0181 84            	pop	a
 638                     ; 138 	toggle_io(lcd_data, 6, LCD_DB6);
 640  0182 4b40          	push	#64
 641  0184 7b02          	ld	a,(OFST+2,sp)
 642  0186 ae0006        	ldw	x,#6
 643  0189 95            	ld	xh,a
 644  018a cd0239        	call	_toggle_io
 646  018d 84            	pop	a
 647                     ; 139 	toggle_io(lcd_data, 5, LCD_DB5);
 649  018e 4b20          	push	#32
 650  0190 7b02          	ld	a,(OFST+2,sp)
 651  0192 ae0005        	ldw	x,#5
 652  0195 95            	ld	xh,a
 653  0196 cd0239        	call	_toggle_io
 655  0199 84            	pop	a
 656                     ; 140 	toggle_io(lcd_data, 4, LCD_DB4);
 658  019a 4b10          	push	#16
 659  019c 7b02          	ld	a,(OFST+2,sp)
 660  019e ae0004        	ldw	x,#4
 661  01a1 95            	ld	xh,a
 662  01a2 cd0239        	call	_toggle_io
 664  01a5 84            	pop	a
 665                     ; 141 	toggle_EN_pin();
 667  01a6 ad78          	call	_toggle_EN_pin
 669                     ; 142 	toggle_io(lcd_data, 3, LCD_DB7);
 671  01a8 4b80          	push	#128
 672  01aa 7b02          	ld	a,(OFST+2,sp)
 673  01ac ae0003        	ldw	x,#3
 674  01af 95            	ld	xh,a
 675  01b0 cd0239        	call	_toggle_io
 677  01b3 84            	pop	a
 678                     ; 143 	toggle_io(lcd_data, 2, LCD_DB6);
 680  01b4 4b40          	push	#64
 681  01b6 7b02          	ld	a,(OFST+2,sp)
 682  01b8 ae0002        	ldw	x,#2
 683  01bb 95            	ld	xh,a
 684  01bc ad7b          	call	_toggle_io
 686  01be 84            	pop	a
 687                     ; 144 	toggle_io(lcd_data, 1, LCD_DB5);
 689  01bf 4b20          	push	#32
 690  01c1 7b02          	ld	a,(OFST+2,sp)
 691  01c3 ae0001        	ldw	x,#1
 692  01c6 95            	ld	xh,a
 693  01c7 ad70          	call	_toggle_io
 695  01c9 84            	pop	a
 696                     ; 145 	toggle_io(lcd_data, 0, LCD_DB4);
 698  01ca 4b10          	push	#16
 699  01cc 7b02          	ld	a,(OFST+2,sp)
 700  01ce 5f            	clrw	x
 701  01cf 95            	ld	xh,a
 702  01d0 ad67          	call	_toggle_io
 704  01d2 84            	pop	a
 705                     ; 146 	toggle_EN_pin();
 707  01d3 ad4b          	call	_toggle_EN_pin
 709                     ; 147 }
 712  01d5 84            	pop	a
 713  01d6 81            	ret
 749                     ; 150 void LCD_putstr(char *lcd_string)
 749                     ; 151 {
 750                     	switch	.text
 751  01d7               _LCD_putstr:
 753  01d7 89            	pushw	x
 754       00000000      OFST:	set	0
 757  01d8               L322:
 758                     ; 154 		LCD_send(*lcd_string++, DAT);
 760  01d8 1e01          	ldw	x,(OFST+1,sp)
 761  01da 1c0001        	addw	x,#1
 762  01dd 1f01          	ldw	(OFST+1,sp),x
 763  01df 1d0001        	subw	x,#1
 764  01e2 f6            	ld	a,(x)
 765  01e3 ae0001        	ldw	x,#1
 766  01e6 95            	ld	xh,a
 767  01e7 cd0155        	call	_LCD_send
 769                     ; 155 	} while(*lcd_string != '\0');
 771  01ea 1e01          	ldw	x,(OFST+1,sp)
 772  01ec 7d            	tnz	(x)
 773  01ed 26e9          	jrne	L322
 774                     ; 156 }
 777  01ef 85            	popw	x
 778  01f0 81            	ret
 813                     ; 159 void LCD_putchar(char char_data)
 813                     ; 160 {
 814                     	switch	.text
 815  01f1               _LCD_putchar:
 819                     ; 161 	LCD_send(char_data, DAT);
 821  01f1 ae0001        	ldw	x,#1
 822  01f4 95            	ld	xh,a
 823  01f5 cd0155        	call	_LCD_send
 825                     ; 162 }
 828  01f8 81            	ret
 852                     ; 165 void LCD_clear_home(void)
 852                     ; 166 {
 853                     	switch	.text
 854  01f9               _LCD_clear_home:
 858                     ; 167 	LCD_send(clear_display, CMD);
 860  01f9 ae0100        	ldw	x,#256
 861  01fc cd0155        	call	_LCD_send
 863                     ; 168 	LCD_send(goto_home, CMD);
 865  01ff ae0200        	ldw	x,#512
 866  0202 cd0155        	call	_LCD_send
 868                     ; 169 }
 871  0205 81            	ret
 915                     ; 172 void LCD_goto(unsigned char x_pos, unsigned char y_pos)
 915                     ; 173 {
 916                     	switch	.text
 917  0206               _LCD_goto:
 919  0206 89            	pushw	x
 920       00000000      OFST:	set	0
 923                     ; 174 	if(y_pos == 0) LCD_send((0x80 | x_pos), CMD);
 925  0207 9f            	ld	a,xl
 926  0208 4d            	tnz	a
 927  0209 260a          	jrne	L103
 930  020b 9e            	ld	a,xh
 931  020c aa80          	or	a,#128
 932  020e 5f            	clrw	x
 933  020f 95            	ld	xh,a
 934  0210 cd0155        	call	_LCD_send
 937  0213 2009          	jra	L303
 938  0215               L103:
 939                     ; 175 	else LCD_send((0x80 | 0x40 | x_pos), CMD);
 941  0215 7b01          	ld	a,(OFST+1,sp)
 942  0217 aac0          	or	a,#192
 943  0219 5f            	clrw	x
 944  021a 95            	ld	xh,a
 945  021b cd0155        	call	_LCD_send
 947  021e               L303:
 948                     ; 176 }
 951  021e 85            	popw	x
 952  021f 81            	ret
 978                     ; 179 void toggle_EN_pin(void)
 978                     ; 180 {
 979                     	switch	.text
 980  0220               _toggle_EN_pin:
 984                     ; 181 	GPIO_WriteHigh(LCD_PORT, LCD_EN);
 986  0220 4b08          	push	#8
 987  0222 ae500a        	ldw	x,#20490
 988  0225 cd0000        	call	_GPIO_WriteHigh
 990  0228 84            	pop	a
 991                     ; 182 	delay_ms(2);
 993  0229 ae0002        	ldw	x,#2
 994  022c cd0025        	call	_delay_ms
 996                     ; 183 	GPIO_WriteLow(LCD_PORT, LCD_EN);
 998  022f 4b08          	push	#8
 999  0231 ae500a        	ldw	x,#20490
1000  0234 cd0000        	call	_GPIO_WriteLow
1002  0237 84            	pop	a
1003                     ; 184 }
1006  0238 81            	ret
1090                     ; 187 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
1090                     ; 188 {
1091                     	switch	.text
1092  0239               _toggle_io:
1094  0239 89            	pushw	x
1095  023a 88            	push	a
1096       00000001      OFST:	set	1
1099                     ; 189 	bool temp = FALSE;
1101                     ; 191 	temp = (0x01 & (lcd_data >> bit_pos));
1103  023b 9f            	ld	a,xl
1104  023c 5f            	clrw	x
1105  023d 97            	ld	xl,a
1106  023e 7b02          	ld	a,(OFST+1,sp)
1107  0240 5d            	tnzw	x
1108  0241 2704          	jreq	L43
1109  0243               L63:
1110  0243 44            	srl	a
1111  0244 5a            	decw	x
1112  0245 26fc          	jrne	L63
1113  0247               L43:
1114  0247 a401          	and	a,#1
1115  0249 6b01          	ld	(OFST+0,sp),a
1117                     ; 193 	switch(temp)
1119  024b 7b01          	ld	a,(OFST+0,sp)
1120  024d a101          	cp	a,#1
1121  024f 260c          	jrne	L713
1124  0251               L513:
1125                     ; 197 			GPIO_WriteHigh(LCD_PORT, pin_num);
1127  0251 7b06          	ld	a,(OFST+5,sp)
1128  0253 88            	push	a
1129  0254 ae500a        	ldw	x,#20490
1130  0257 cd0000        	call	_GPIO_WriteHigh
1132  025a 84            	pop	a
1133                     ; 198 			break;
1135  025b 200a          	jra	L563
1136  025d               L713:
1137                     ; 202 			GPIO_WriteLow(LCD_PORT, pin_num);
1139  025d 7b06          	ld	a,(OFST+5,sp)
1140  025f 88            	push	a
1141  0260 ae500a        	ldw	x,#20490
1142  0263 cd0000        	call	_GPIO_WriteLow
1144  0266 84            	pop	a
1145                     ; 203 			break;
1146  0267               L563:
1147                     ; 206 }
1150  0267 5b03          	addw	sp,#3
1151  0269 81            	ret
1197                     ; 209 void LCD_putint8(uint8_t number)
1197                     ; 210 {
1198                     	switch	.text
1199  026a               _LCD_putint8:
1201  026a 5204          	subw	sp,#4
1202       00000004      OFST:	set	4
1205                     ; 212 	uint8_to_string(number, temp);
1207  026c 96            	ldw	x,sp
1208  026d 1c0001        	addw	x,#OFST-3
1209  0270 89            	pushw	x
1210  0271 ad0b          	call	_uint8_to_string
1212  0273 85            	popw	x
1213                     ; 214 	LCD_putstr(temp);
1215  0274 96            	ldw	x,sp
1216  0275 1c0001        	addw	x,#OFST-3
1217  0278 cd01d7        	call	_LCD_putstr
1219                     ; 215 }
1222  027b 5b04          	addw	sp,#4
1223  027d 81            	ret
1293                     ; 11 void uint8_to_string(uint8_t val, char *ret)
1293                     ; 12 {
1294                     	switch	.text
1295  027e               _uint8_to_string:
1297  027e 88            	push	a
1298  027f 88            	push	a
1299       00000001      OFST:	set	1
1302                     ; 13 	uint8_t len = 1; // Starting input value length
1304  0280 a601          	ld	a,#1
1305  0282 6b01          	ld	(OFST+0,sp),a
1307                     ; 15 	ret[0] = 0x30; // Starting 0
1309  0284 1e05          	ldw	x,(OFST+4,sp)
1310  0286 a630          	ld	a,#48
1311  0288 f7            	ld	(x),a
1312                     ; 16 	ret[1] = 0x20; // Empty space
1314  0289 1e05          	ldw	x,(OFST+4,sp)
1315  028b a620          	ld	a,#32
1316  028d e701          	ld	(1,x),a
1317                     ; 17 	ret[2] = 0x20; // Empty space
1319  028f 1e05          	ldw	x,(OFST+4,sp)
1320  0291 a620          	ld	a,#32
1321  0293 e702          	ld	(2,x),a
1322                     ; 18 	ret[3] = '\0'; // End of string
1324  0295 1e05          	ldw	x,(OFST+4,sp)
1325  0297 6f03          	clr	(3,x)
1326                     ; 21 	if (val >= 100) len = 3;
1328  0299 7b02          	ld	a,(OFST+1,sp)
1329  029b a164          	cp	a,#100
1330  029d 2506          	jrult	L744
1333  029f a603          	ld	a,#3
1334  02a1 6b01          	ld	(OFST+0,sp),a
1337  02a3 2043          	jra	L754
1338  02a5               L744:
1339                     ; 22 	else if (val >= 10) len = 2;
1341  02a5 7b02          	ld	a,(OFST+1,sp)
1342  02a7 a10a          	cp	a,#10
1343  02a9 253d          	jrult	L754
1346  02ab a602          	ld	a,#2
1347  02ad 6b01          	ld	(OFST+0,sp),a
1349  02af 2037          	jra	L754
1350  02b1               L554:
1351                     ; 27 		ret[len-1] = (val % 10) + 0x30;
1353  02b1 7b01          	ld	a,(OFST+0,sp)
1354  02b3 5f            	clrw	x
1355  02b4 97            	ld	xl,a
1356  02b5 5a            	decw	x
1357  02b6 72fb05        	addw	x,(OFST+4,sp)
1358  02b9 7b02          	ld	a,(OFST+1,sp)
1359  02bb 905f          	clrw	y
1360  02bd 9097          	ld	yl,a
1361  02bf a60a          	ld	a,#10
1362  02c1 9062          	div	y,a
1363  02c3 905f          	clrw	y
1364  02c5 9097          	ld	yl,a
1365  02c7 909f          	ld	a,yl
1366  02c9 ab30          	add	a,#48
1367  02cb f7            	ld	(x),a
1368                     ; 28 		val -= (val % 10);
1370  02cc 7b02          	ld	a,(OFST+1,sp)
1371  02ce 5f            	clrw	x
1372  02cf 97            	ld	xl,a
1373  02d0 a60a          	ld	a,#10
1374  02d2 62            	div	x,a
1375  02d3 5f            	clrw	x
1376  02d4 97            	ld	xl,a
1377  02d5 9f            	ld	a,xl
1378  02d6 1002          	sub	a,(OFST+1,sp)
1379  02d8 40            	neg	a
1380  02d9 6b02          	ld	(OFST+1,sp),a
1381                     ; 29 		val = val / 10;
1383  02db 7b02          	ld	a,(OFST+1,sp)
1384  02dd 5f            	clrw	x
1385  02de 97            	ld	xl,a
1386  02df a60a          	ld	a,#10
1387  02e1 62            	div	x,a
1388  02e2 01            	rrwa	x,a
1389  02e3 6b02          	ld	(OFST+1,sp),a
1390  02e5 02            	rlwa	x,a
1391                     ; 30 		len--;
1393  02e6 0a01          	dec	(OFST+0,sp)
1395  02e8               L754:
1396                     ; 25 	while (val > 0)
1398  02e8 0d02          	tnz	(OFST+1,sp)
1399  02ea 26c5          	jrne	L554
1400                     ; 32 }
1403  02ec 85            	popw	x
1404  02ed 81            	ret
1457                     ; 37 void uint_to_string(uint16_t val, char *ret)
1457                     ; 38 {
1458                     	switch	.text
1459  02ee               _uint_to_string:
1461  02ee 89            	pushw	x
1462  02ef 88            	push	a
1463       00000001      OFST:	set	1
1466                     ; 39 	uint8_t len = 1; // Starting input value length
1468  02f0 a601          	ld	a,#1
1469  02f2 6b01          	ld	(OFST+0,sp),a
1471                     ; 41 	ret[0] = 0x30; // Starting 0
1473  02f4 1e06          	ldw	x,(OFST+5,sp)
1474  02f6 a630          	ld	a,#48
1475  02f8 f7            	ld	(x),a
1476                     ; 42 	ret[1] = 0x20; // Empty space
1478  02f9 1e06          	ldw	x,(OFST+5,sp)
1479  02fb a620          	ld	a,#32
1480  02fd e701          	ld	(1,x),a
1481                     ; 43 	ret[2] = 0x20; // Empty space
1483  02ff 1e06          	ldw	x,(OFST+5,sp)
1484  0301 a620          	ld	a,#32
1485  0303 e702          	ld	(2,x),a
1486                     ; 44 	ret[3] = 0x20; // Empty space
1488  0305 1e06          	ldw	x,(OFST+5,sp)
1489  0307 a620          	ld	a,#32
1490  0309 e703          	ld	(3,x),a
1491                     ; 45 	ret[4] = 0x20; // Empty space
1493  030b 1e06          	ldw	x,(OFST+5,sp)
1494  030d a620          	ld	a,#32
1495  030f e704          	ld	(4,x),a
1496                     ; 46 	ret[5] = '\0'; // End of string
1498  0311 1e06          	ldw	x,(OFST+5,sp)
1499  0313 6f05          	clr	(5,x)
1500                     ; 49 	if (val >= 10000) len = 5;
1502  0315 1e02          	ldw	x,(OFST+1,sp)
1503  0317 a32710        	cpw	x,#10000
1504  031a 2506          	jrult	L115
1507  031c a605          	ld	a,#5
1508  031e 6b01          	ld	(OFST+0,sp),a
1511  0320 2056          	jra	L135
1512  0322               L115:
1513                     ; 50 	else if (val >= 1000) len = 4;
1515  0322 1e02          	ldw	x,(OFST+1,sp)
1516  0324 a303e8        	cpw	x,#1000
1517  0327 2506          	jrult	L515
1520  0329 a604          	ld	a,#4
1521  032b 6b01          	ld	(OFST+0,sp),a
1524  032d 2049          	jra	L135
1525  032f               L515:
1526                     ; 51 	else if (val >= 100) len = 3;
1528  032f 1e02          	ldw	x,(OFST+1,sp)
1529  0331 a30064        	cpw	x,#100
1530  0334 2506          	jrult	L125
1533  0336 a603          	ld	a,#3
1534  0338 6b01          	ld	(OFST+0,sp),a
1537  033a 203c          	jra	L135
1538  033c               L125:
1539                     ; 52 	else if (val >= 10) len = 2;
1541  033c 1e02          	ldw	x,(OFST+1,sp)
1542  033e a3000a        	cpw	x,#10
1543  0341 2535          	jrult	L135
1546  0343 a602          	ld	a,#2
1547  0345 6b01          	ld	(OFST+0,sp),a
1549  0347 202f          	jra	L135
1550  0349               L725:
1551                     ; 57 		ret[len-1] = (val % 10) + 0x30;
1553  0349 1e02          	ldw	x,(OFST+1,sp)
1554  034b a60a          	ld	a,#10
1555  034d 62            	div	x,a
1556  034e 5f            	clrw	x
1557  034f 97            	ld	xl,a
1558  0350 1c0030        	addw	x,#48
1559  0353 7b01          	ld	a,(OFST+0,sp)
1560  0355 905f          	clrw	y
1561  0357 9097          	ld	yl,a
1562  0359 905a          	decw	y
1563  035b 72f906        	addw	y,(OFST+5,sp)
1564  035e 01            	rrwa	x,a
1565  035f 90f7          	ld	(y),a
1566  0361 02            	rlwa	x,a
1567                     ; 58 		val -= (val % 10);
1569  0362 1e02          	ldw	x,(OFST+1,sp)
1570  0364 a60a          	ld	a,#10
1571  0366 62            	div	x,a
1572  0367 5f            	clrw	x
1573  0368 97            	ld	xl,a
1574  0369 72f002        	subw	x,(OFST+1,sp)
1575  036c 50            	negw	x
1576  036d 1f02          	ldw	(OFST+1,sp),x
1577                     ; 59 		val = val / 10;
1579  036f 1e02          	ldw	x,(OFST+1,sp)
1580  0371 a60a          	ld	a,#10
1581  0373 62            	div	x,a
1582  0374 1f02          	ldw	(OFST+1,sp),x
1583                     ; 60 		len--;
1585  0376 0a01          	dec	(OFST+0,sp)
1587  0378               L135:
1588                     ; 55 	while (val > 0)
1590  0378 1e02          	ldw	x,(OFST+1,sp)
1591  037a 26cd          	jrne	L725
1592                     ; 62 }
1595  037c 5b03          	addw	sp,#3
1596  037e 81            	ret
1675                     .const:	section	.text
1676  0000               L05:
1677  0000 0000fde8      	dc.l	65000
1678                     ; 99 bool DS3231_Init(void)
1678                     ; 100 {
1679                     	switch	.text
1680  037f               _DS3231_Init:
1682  037f 89            	pushw	x
1683       00000002      OFST:	set	2
1686                     ; 101 	uint16_t error = 0; // Error counter
1688  0380 5f            	clrw	x
1689  0381 1f01          	ldw	(OFST-1,sp),x
1691                     ; 103 	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
1693  0383 a601          	ld	a,#1
1694  0385 cd0000        	call	_I2C_AcknowledgeConfig
1697  0388 2019          	jra	L575
1698  038a               L375:
1699                     ; 107 		error++; // Increment error counter
1701  038a 1e01          	ldw	x,(OFST-1,sp)
1702  038c 1c0001        	addw	x,#1
1703  038f 1f01          	ldw	(OFST-1,sp),x
1705                     ; 108 		if (error >= 65000) return TRUE; // Return from function
1707  0391 9c            	rvf
1708  0392 1e01          	ldw	x,(OFST-1,sp)
1709  0394 cd0000        	call	c_uitolx
1711  0397 ae0000        	ldw	x,#L05
1712  039a cd0000        	call	c_lcmp
1714  039d 2f04          	jrslt	L575
1717  039f a601          	ld	a,#1
1719  03a1 202a          	jra	L25
1720  03a3               L575:
1721                     ; 105 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
1723  03a3 ae0302        	ldw	x,#770
1724  03a6 cd0000        	call	_I2C_GetFlagStatus
1726  03a9 4d            	tnz	a
1727  03aa 26de          	jrne	L375
1728                     ; 110 	error = 0;
1730  03ac 5f            	clrw	x
1731  03ad 1f01          	ldw	(OFST-1,sp),x
1733                     ; 112 	I2C_GenerateSTART(ENABLE); // Generate I2C start
1735  03af a601          	ld	a,#1
1736  03b1 cd0000        	call	_I2C_GenerateSTART
1739  03b4 2019          	jra	L506
1740  03b6               L306:
1741                     ; 115 		error++; // Increment error counter
1743  03b6 1e01          	ldw	x,(OFST-1,sp)
1744  03b8 1c0001        	addw	x,#1
1745  03bb 1f01          	ldw	(OFST-1,sp),x
1747                     ; 116 		if (error >= 65000) return TRUE; // Return from function
1749  03bd 9c            	rvf
1750  03be 1e01          	ldw	x,(OFST-1,sp)
1751  03c0 cd0000        	call	c_uitolx
1753  03c3 ae0000        	ldw	x,#L05
1754  03c6 cd0000        	call	c_lcmp
1756  03c9 2f04          	jrslt	L506
1759  03cb a601          	ld	a,#1
1761  03cd               L25:
1763  03cd 85            	popw	x
1764  03ce 81            	ret
1765  03cf               L506:
1766                     ; 113 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Check if start was generated
1768  03cf ae0301        	ldw	x,#769
1769  03d2 cd0000        	call	_I2C_CheckEvent
1771  03d5 4d            	tnz	a
1772  03d6 27de          	jreq	L306
1773                     ; 118 	error = 0;
1775  03d8 5f            	clrw	x
1776  03d9 1f01          	ldw	(OFST-1,sp),x
1778                     ; 120 	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
1780  03db aed000        	ldw	x,#53248
1781  03de cd0000        	call	_I2C_Send7bitAddress
1784  03e1 2019          	jra	L516
1785  03e3               L316:
1786                     ; 123 		error++; // Increment error counter
1788  03e3 1e01          	ldw	x,(OFST-1,sp)
1789  03e5 1c0001        	addw	x,#1
1790  03e8 1f01          	ldw	(OFST-1,sp),x
1792                     ; 124 		if (error >= 65000) return TRUE; // Return from function
1794  03ea 9c            	rvf
1795  03eb 1e01          	ldw	x,(OFST-1,sp)
1796  03ed cd0000        	call	c_uitolx
1798  03f0 ae0000        	ldw	x,#L05
1799  03f3 cd0000        	call	c_lcmp
1801  03f6 2f04          	jrslt	L516
1804  03f8 a601          	ld	a,#1
1806  03fa 20d1          	jra	L25
1807  03fc               L516:
1808                     ; 121 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
1810  03fc ae0782        	ldw	x,#1922
1811  03ff cd0000        	call	_I2C_CheckEvent
1813  0402 4d            	tnz	a
1814  0403 27de          	jreq	L316
1815                     ; 126 	error = 0;
1817  0405 5f            	clrw	x
1818  0406 1f01          	ldw	(OFST-1,sp),x
1820                     ; 128 	I2C_SendData(adr_Control); // Send address of control register
1822  0408 a60e          	ld	a,#14
1823  040a cd0000        	call	_I2C_SendData
1826  040d 2019          	jra	L526
1827  040f               L326:
1828                     ; 131 		error++; // Increment error counter
1830  040f 1e01          	ldw	x,(OFST-1,sp)
1831  0411 1c0001        	addw	x,#1
1832  0414 1f01          	ldw	(OFST-1,sp),x
1834                     ; 132 		if (error >= 65000) return TRUE; // Return from function
1836  0416 9c            	rvf
1837  0417 1e01          	ldw	x,(OFST-1,sp)
1838  0419 cd0000        	call	c_uitolx
1840  041c ae0000        	ldw	x,#L05
1841  041f cd0000        	call	c_lcmp
1843  0422 2f04          	jrslt	L526
1846  0424 a601          	ld	a,#1
1848  0426 20a5          	jra	L25
1849  0428               L526:
1850                     ; 129 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
1852  0428 ae0784        	ldw	x,#1924
1853  042b cd0000        	call	_I2C_CheckEvent
1855  042e 4d            	tnz	a
1856  042f 27de          	jreq	L326
1857                     ; 134 	error = 0;
1859  0431 5f            	clrw	x
1860  0432 1f01          	ldw	(OFST-1,sp),x
1862                     ; 136 	I2C_SendData((uint8_t)0); // Send register value
1864  0434 4f            	clr	a
1865  0435 cd0000        	call	_I2C_SendData
1868  0438 2019          	jra	L536
1869  043a               L336:
1870                     ; 139 		error++; // Increment error counter
1872  043a 1e01          	ldw	x,(OFST-1,sp)
1873  043c 1c0001        	addw	x,#1
1874  043f 1f01          	ldw	(OFST-1,sp),x
1876                     ; 140 		if (error >= 65000) return TRUE; // Return from function
1878  0441 9c            	rvf
1879  0442 1e01          	ldw	x,(OFST-1,sp)
1880  0444 cd0000        	call	c_uitolx
1882  0447 ae0000        	ldw	x,#L05
1883  044a cd0000        	call	c_lcmp
1885  044d 2f04          	jrslt	L536
1888  044f a601          	ld	a,#1
1890  0451 200f          	jra	L45
1891  0453               L536:
1892                     ; 137 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
1894  0453 ae0784        	ldw	x,#1924
1895  0456 cd0000        	call	_I2C_CheckEvent
1897  0459 4d            	tnz	a
1898  045a 27de          	jreq	L336
1899                     ; 142 	error = 0;
1901                     ; 144 	I2C_GenerateSTOP(ENABLE); // End transmission
1903  045c a601          	ld	a,#1
1904  045e cd0000        	call	_I2C_GenerateSTOP
1906                     ; 146 	return FALSE;
1908  0461 4f            	clr	a
1910  0462               L45:
1912  0462 85            	popw	x
1913  0463 81            	ret
1976                     	switch	.const
1977  0004               L46:
1978  0004 05cf          	dc.w	L346
1979  0006 05db          	dc.w	L546
1980  0008 05e7          	dc.w	L746
1981  000a 05f3          	dc.w	L156
1982  000c 05ff          	dc.w	L356
1983  000e 0608          	dc.w	L556
1984  0010 061f          	dc.w	L756
1985  0012 0629          	dc.w	L166
1986  0014 0633          	dc.w	L366
1987  0016 063d          	dc.w	L566
1988  0018 0647          	dc.w	L766
1989  001a 0651          	dc.w	L176
1990  001c 065b          	dc.w	L376
1991  001e 0665          	dc.w	L576
1992  0020 066f          	dc.w	L776
1993  0022 0676          	dc.w	L107
1994  0024 067d          	dc.w	L307
1995  0026 0684          	dc.w	L507
1996  0028 068b          	dc.w	L707
1997                     ; 150 bool DS3231_ReadAll(void)
1997                     ; 151 {
1998                     	switch	.text
1999  0464               _DS3231_ReadAll:
2001  0464 5204          	subw	sp,#4
2002       00000004      OFST:	set	4
2005                     ; 152 	uint8_t numOfData = 19;
2007  0466 a613          	ld	a,#19
2008  0468 6b01          	ld	(OFST-3,sp),a
2010                     ; 153 	uint8_t i = 0;
2012                     ; 154 	uint16_t error = 0;
2014  046a 5f            	clrw	x
2015  046b 1f03          	ldw	(OFST-1,sp),x
2017                     ; 156 	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
2019  046d a601          	ld	a,#1
2020  046f cd0000        	call	_I2C_AcknowledgeConfig
2023  0472 2019          	jra	L347
2024  0474               L147:
2025                     ; 160 		error++; // Increment error counter
2027  0474 1e03          	ldw	x,(OFST-1,sp)
2028  0476 1c0001        	addw	x,#1
2029  0479 1f03          	ldw	(OFST-1,sp),x
2031                     ; 161 		if (error >= 65000) return TRUE; // Return from function
2033  047b 9c            	rvf
2034  047c 1e03          	ldw	x,(OFST-1,sp)
2035  047e cd0000        	call	c_uitolx
2037  0481 ae0000        	ldw	x,#L05
2038  0484 cd0000        	call	c_lcmp
2040  0487 2f04          	jrslt	L347
2043  0489 a601          	ld	a,#1
2045  048b 202a          	jra	L66
2046  048d               L347:
2047                     ; 158 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
2049  048d ae0302        	ldw	x,#770
2050  0490 cd0000        	call	_I2C_GetFlagStatus
2052  0493 4d            	tnz	a
2053  0494 26de          	jrne	L147
2054                     ; 163 	error = 0;
2056  0496 5f            	clrw	x
2057  0497 1f03          	ldw	(OFST-1,sp),x
2059                     ; 165 	I2C_GenerateSTART(ENABLE); // Generate I2C start
2061  0499 a601          	ld	a,#1
2062  049b cd0000        	call	_I2C_GenerateSTART
2065  049e 201a          	jra	L357
2066  04a0               L157:
2067                     ; 168 		error++; // Increment error counter
2069  04a0 1e03          	ldw	x,(OFST-1,sp)
2070  04a2 1c0001        	addw	x,#1
2071  04a5 1f03          	ldw	(OFST-1,sp),x
2073                     ; 169 		if (error >= 65000) return TRUE; // Return from function
2075  04a7 9c            	rvf
2076  04a8 1e03          	ldw	x,(OFST-1,sp)
2077  04aa cd0000        	call	c_uitolx
2079  04ad ae0000        	ldw	x,#L05
2080  04b0 cd0000        	call	c_lcmp
2082  04b3 2f05          	jrslt	L357
2085  04b5 a601          	ld	a,#1
2087  04b7               L66:
2089  04b7 5b04          	addw	sp,#4
2090  04b9 81            	ret
2091  04ba               L357:
2092                     ; 166 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Check if start was generated
2094  04ba ae0301        	ldw	x,#769
2095  04bd cd0000        	call	_I2C_CheckEvent
2097  04c0 4d            	tnz	a
2098  04c1 27dd          	jreq	L157
2099                     ; 171 	error = 0;
2101  04c3 5f            	clrw	x
2102  04c4 1f03          	ldw	(OFST-1,sp),x
2104                     ; 173 	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
2106  04c6 aed000        	ldw	x,#53248
2107  04c9 cd0000        	call	_I2C_Send7bitAddress
2110  04cc 2019          	jra	L367
2111  04ce               L167:
2112                     ; 176 		error++; // Increment error counter
2114  04ce 1e03          	ldw	x,(OFST-1,sp)
2115  04d0 1c0001        	addw	x,#1
2116  04d3 1f03          	ldw	(OFST-1,sp),x
2118                     ; 177 		if (error >= 65000) return TRUE; // Return from function
2120  04d5 9c            	rvf
2121  04d6 1e03          	ldw	x,(OFST-1,sp)
2122  04d8 cd0000        	call	c_uitolx
2124  04db ae0000        	ldw	x,#L05
2125  04de cd0000        	call	c_lcmp
2127  04e1 2f04          	jrslt	L367
2130  04e3 a601          	ld	a,#1
2132  04e5 20d0          	jra	L66
2133  04e7               L367:
2134                     ; 174 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
2136  04e7 ae0782        	ldw	x,#1922
2137  04ea cd0000        	call	_I2C_CheckEvent
2139  04ed 4d            	tnz	a
2140  04ee 27de          	jreq	L167
2141                     ; 179 	error = 0;
2143  04f0 5f            	clrw	x
2144  04f1 1f03          	ldw	(OFST-1,sp),x
2146                     ; 181 	I2C_SendData((uint8_t)adr_Seconds); // Send first data address
2148  04f3 4f            	clr	a
2149  04f4 cd0000        	call	_I2C_SendData
2152  04f7 2019          	jra	L377
2153  04f9               L177:
2154                     ; 184 		error++; // Increment error counter
2156  04f9 1e03          	ldw	x,(OFST-1,sp)
2157  04fb 1c0001        	addw	x,#1
2158  04fe 1f03          	ldw	(OFST-1,sp),x
2160                     ; 185 		if (error >= 65000) return TRUE; // Return from function
2162  0500 9c            	rvf
2163  0501 1e03          	ldw	x,(OFST-1,sp)
2164  0503 cd0000        	call	c_uitolx
2166  0506 ae0000        	ldw	x,#L05
2167  0509 cd0000        	call	c_lcmp
2169  050c 2f04          	jrslt	L377
2172  050e a601          	ld	a,#1
2174  0510 20a5          	jra	L66
2175  0512               L377:
2176                     ; 182 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for ACK
2178  0512 ae0784        	ldw	x,#1924
2179  0515 cd0000        	call	_I2C_CheckEvent
2181  0518 4d            	tnz	a
2182  0519 27de          	jreq	L177
2183                     ; 187 	error = 0;
2185  051b 5f            	clrw	x
2186  051c 1f03          	ldw	(OFST-1,sp),x
2188                     ; 189 	I2C_GenerateSTART(ENABLE); // Generate 2nd I2C start
2190  051e a601          	ld	a,#1
2191  0520 cd0000        	call	_I2C_GenerateSTART
2194  0523 201b          	jra	L3001
2195  0525               L1001:
2196                     ; 192 		error++; // Increment error counter
2198  0525 1e03          	ldw	x,(OFST-1,sp)
2199  0527 1c0001        	addw	x,#1
2200  052a 1f03          	ldw	(OFST-1,sp),x
2202                     ; 193 		if (error >= 65000) return TRUE; // Return from function
2204  052c 9c            	rvf
2205  052d 1e03          	ldw	x,(OFST-1,sp)
2206  052f cd0000        	call	c_uitolx
2208  0532 ae0000        	ldw	x,#L05
2209  0535 cd0000        	call	c_lcmp
2211  0538 2f06          	jrslt	L3001
2214  053a a601          	ld	a,#1
2216  053c acb704b7      	jpf	L66
2217  0540               L3001:
2218                     ; 190 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Check if start was generated
2220  0540 ae0301        	ldw	x,#769
2221  0543 cd0000        	call	_I2C_CheckEvent
2223  0546 4d            	tnz	a
2224  0547 27dc          	jreq	L1001
2225                     ; 195 	error = 0;
2227  0549 5f            	clrw	x
2228  054a 1f03          	ldw	(OFST-1,sp),x
2230                     ; 197 	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_RX); // Send DS3231 address with receive direction
2232  054c aed001        	ldw	x,#53249
2233  054f cd0000        	call	_I2C_Send7bitAddress
2236  0552 201b          	jra	L3101
2237  0554               L1101:
2238                     ; 200 		error++; // Increment error counter
2240  0554 1e03          	ldw	x,(OFST-1,sp)
2241  0556 1c0001        	addw	x,#1
2242  0559 1f03          	ldw	(OFST-1,sp),x
2244                     ; 201 		if (error >= 65000) return TRUE; // Return from function
2246  055b 9c            	rvf
2247  055c 1e03          	ldw	x,(OFST-1,sp)
2248  055e cd0000        	call	c_uitolx
2250  0561 ae0000        	ldw	x,#L05
2251  0564 cd0000        	call	c_lcmp
2253  0567 2f06          	jrslt	L3101
2256  0569 a601          	ld	a,#1
2258  056b acb704b7      	jpf	L66
2259  056f               L3101:
2260                     ; 198 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)) // Wait for ACK
2262  056f ae0302        	ldw	x,#770
2263  0572 cd0000        	call	_I2C_CheckEvent
2265  0575 4d            	tnz	a
2266  0576 27dc          	jreq	L1101
2267                     ; 203 	error = 0;
2269  0578 5f            	clrw	x
2270  0579 1f03          	ldw	(OFST-1,sp),x
2272                     ; 206 	for (i = 0; i < numOfData; i++)
2274  057b 0f02          	clr	(OFST-2,sp)
2277  057d ac970697      	jpf	L5201
2278  0581               L1301:
2279                     ; 210 			error++; // Increment error counter
2281  0581 1e03          	ldw	x,(OFST-1,sp)
2282  0583 1c0001        	addw	x,#1
2283  0586 1f03          	ldw	(OFST-1,sp),x
2285                     ; 211 			if (error >= 65000) return TRUE; // Return from function
2287  0588 9c            	rvf
2288  0589 1e03          	ldw	x,(OFST-1,sp)
2289  058b cd0000        	call	c_uitolx
2291  058e ae0000        	ldw	x,#L05
2292  0591 cd0000        	call	c_lcmp
2294  0594 2f06          	jrslt	L3301
2297  0596 a601          	ld	a,#1
2299  0598 acb704b7      	jpf	L66
2300  059c               L3301:
2301                     ; 208 		while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_RECEIVED)) // Wait for byte received
2303  059c ae0340        	ldw	x,#832
2304  059f cd0000        	call	_I2C_CheckEvent
2306  05a2 4d            	tnz	a
2307  05a3 27dc          	jreq	L1301
2308                     ; 213 		error = 0;
2310  05a5 5f            	clrw	x
2311  05a6 1f03          	ldw	(OFST-1,sp),x
2313                     ; 214 		if (i == numOfData - 1) I2C_AcknowledgeConfig(I2C_ACK_NONE); // When receiving last byte change ACK mode
2315  05a8 7b01          	ld	a,(OFST-3,sp)
2316  05aa 5f            	clrw	x
2317  05ab 97            	ld	xl,a
2318  05ac 5a            	decw	x
2319  05ad 7b02          	ld	a,(OFST-2,sp)
2320  05af 905f          	clrw	y
2321  05b1 9097          	ld	yl,a
2322  05b3 90bf00        	ldw	c_y,y
2323  05b6 b300          	cpw	x,c_y
2324  05b8 2604          	jrne	L1401
2327  05ba 4f            	clr	a
2328  05bb cd0000        	call	_I2C_AcknowledgeConfig
2330  05be               L1401:
2331                     ; 217 		switch (i)
2333  05be 7b02          	ld	a,(OFST-2,sp)
2335                     ; 324 				I2C_ReceiveData(); // Someting went wrong, just receive data
2336  05c0 a113          	cp	a,#19
2337  05c2 2407          	jruge	L26
2338  05c4 5f            	clrw	x
2339  05c5 97            	ld	xl,a
2340  05c6 58            	sllw	x
2341  05c7 de0004        	ldw	x,(L46,x)
2342  05ca fc            	jp	(x)
2343  05cb               L26:
2344  05cb ac920692      	jpf	L117
2345  05cf               L346:
2346                     ; 221 				DS3231_Data.TimeDate.Seconds = bcd2dec(I2C_ReceiveData()); // Receive seconds in BCD form
2348  05cf cd0000        	call	_I2C_ReceiveData
2350  05d2 cd0b4d        	call	_bcd2dec
2352  05d5 b723          	ld	L535_DS3231_Data,a
2353                     ; 222 				break;
2355  05d7 ac950695      	jpf	L5401
2356  05db               L546:
2357                     ; 226 				DS3231_Data.TimeDate.Minutes = bcd2dec(I2C_ReceiveData()); // Receive minutes in BCD form
2359  05db cd0000        	call	_I2C_ReceiveData
2361  05de cd0b4d        	call	_bcd2dec
2363  05e1 b724          	ld	L535_DS3231_Data+1,a
2364                     ; 227 				break;
2366  05e3 ac950695      	jpf	L5401
2367  05e7               L746:
2368                     ; 237 				else DS3231_Data.TimeDate.Hours = bcd2dec(I2C_ReceiveData()); // 24 Hour mode selected, receive hours in BCD form
2370  05e7 cd0000        	call	_I2C_ReceiveData
2372  05ea cd0b4d        	call	_bcd2dec
2374  05ed b725          	ld	L535_DS3231_Data+2,a
2375                     ; 238 				break;
2377  05ef ac950695      	jpf	L5401
2378  05f3               L156:
2379                     ; 242 				DS3231_Data.TimeDate.DayOfWeek = bcd2dec(I2C_ReceiveData()); // Receive day of week (1-7) in BCD form
2381  05f3 cd0000        	call	_I2C_ReceiveData
2383  05f6 cd0b4d        	call	_bcd2dec
2385  05f9 b727          	ld	L535_DS3231_Data+4,a
2386                     ; 243 				break;
2388  05fb ac950695      	jpf	L5401
2389  05ff               L356:
2390                     ; 247 				DS3231_Data.TimeDate.Day = I2C_ReceiveData(); // Receive day of month in BCD form
2392  05ff cd0000        	call	_I2C_ReceiveData
2394  0602 b728          	ld	L535_DS3231_Data+5,a
2395                     ; 248 				break;
2397  0604 ac950695      	jpf	L5401
2398  0608               L556:
2399                     ; 252 				DS3231_Data.TimeDate.Century = I2C_ReceiveData(); // Get whole century + month
2401  0608 cd0000        	call	_I2C_ReceiveData
2403  060b b72b          	ld	L535_DS3231_Data+8,a
2404                     ; 253 				DS3231_Data.TimeDate.Month = bcd2dec(DS3231_Data.TimeDate.Century & 0x1F); // Get rid of century bit
2406  060d b62b          	ld	a,L535_DS3231_Data+8
2407  060f a41f          	and	a,#31
2408  0611 cd0b4d        	call	_bcd2dec
2410  0614 b729          	ld	L535_DS3231_Data+6,a
2411                     ; 254 				DS3231_Data.TimeDate.Century = DS3231_Data.TimeDate.Century >> 7; // Shift century bit to 0 position
2413  0616 b62b          	ld	a,L535_DS3231_Data+8
2414  0618 49            	rlc	a
2415  0619 4f            	clr	a
2416  061a 49            	rlc	a
2417  061b b72b          	ld	L535_DS3231_Data+8,a
2418                     ; 255 				break;
2420  061d 2076          	jra	L5401
2421  061f               L756:
2422                     ; 259 				DS3231_Data.TimeDate.Year = bcd2dec(I2C_ReceiveData()); // Receive year in BCD form
2424  061f cd0000        	call	_I2C_ReceiveData
2426  0622 cd0b4d        	call	_bcd2dec
2428  0625 b72a          	ld	L535_DS3231_Data+7,a
2429                     ; 260 				break;
2431  0627 206c          	jra	L5401
2432  0629               L166:
2433                     ; 264 				DS3231_Data.Alarms.Alarm1_Seconds = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 seconds in BCD form
2435  0629 cd0000        	call	_I2C_ReceiveData
2437  062c cd0b4d        	call	_bcd2dec
2439  062f b72c          	ld	L535_DS3231_Data+9,a
2440                     ; 265 				break;
2442  0631 2062          	jra	L5401
2443  0633               L366:
2444                     ; 269 				DS3231_Data.Alarms.Alarm1_Minutes = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 minutes in BCD form
2446  0633 cd0000        	call	_I2C_ReceiveData
2448  0636 cd0b4d        	call	_bcd2dec
2450  0639 b72d          	ld	L535_DS3231_Data+10,a
2451                     ; 270 				break;
2453  063b 2058          	jra	L5401
2454  063d               L566:
2455                     ; 274 				DS3231_Data.Alarms.Alarm1_Hours = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 hours in BCD form
2457  063d cd0000        	call	_I2C_ReceiveData
2459  0640 cd0b4d        	call	_bcd2dec
2461  0643 b72e          	ld	L535_DS3231_Data+11,a
2462                     ; 275 				break;
2464  0645 204e          	jra	L5401
2465  0647               L766:
2466                     ; 279 				DS3231_Data.Alarms.Alarm1_DayOfWeek = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 day of week in BCD form
2468  0647 cd0000        	call	_I2C_ReceiveData
2470  064a cd0b4d        	call	_bcd2dec
2472  064d b72f          	ld	L535_DS3231_Data+12,a
2473                     ; 280 				break;
2475  064f 2044          	jra	L5401
2476  0651               L176:
2477                     ; 284 				DS3231_Data.Alarms.Alarm2_Minutes = bcd2dec(I2C_ReceiveData()); // Receive alarm 2 minutes in BCD form
2479  0651 cd0000        	call	_I2C_ReceiveData
2481  0654 cd0b4d        	call	_bcd2dec
2483  0657 b730          	ld	L535_DS3231_Data+13,a
2484                     ; 285 				break;
2486  0659 203a          	jra	L5401
2487  065b               L376:
2488                     ; 289 				DS3231_Data.Alarms.Alarm2_Hours = bcd2dec(I2C_ReceiveData()); // Receive alarm 2 hours in BCD form
2490  065b cd0000        	call	_I2C_ReceiveData
2492  065e cd0b4d        	call	_bcd2dec
2494  0661 b731          	ld	L535_DS3231_Data+14,a
2495                     ; 290 				break;
2497  0663 2030          	jra	L5401
2498  0665               L576:
2499                     ; 294 				DS3231_Data.Alarms.Alarm2_DayOfWeek = bcd2dec(I2C_ReceiveData()); // Receive alarm 2 day of week in BCD form
2501  0665 cd0000        	call	_I2C_ReceiveData
2503  0668 cd0b4d        	call	_bcd2dec
2505  066b b732          	ld	L535_DS3231_Data+15,a
2506                     ; 295 				break;
2508  066d 2026          	jra	L5401
2509  066f               L776:
2510                     ; 299 				DS3231_Data.Control.Control = I2C_ReceiveData(); // Receive control register
2512  066f cd0000        	call	_I2C_ReceiveData
2514  0672 b733          	ld	L535_DS3231_Data+16,a
2515                     ; 300 				break;
2517  0674 201f          	jra	L5401
2518  0676               L107:
2519                     ; 304 				DS3231_Data.Control.Status = I2C_ReceiveData(); // Receive status register
2521  0676 cd0000        	call	_I2C_ReceiveData
2523  0679 b734          	ld	L535_DS3231_Data+17,a
2524                     ; 305 				break;
2526  067b 2018          	jra	L5401
2527  067d               L307:
2528                     ; 309 				DS3231_Data.Control.Aging = I2C_ReceiveData(); // Receive aging register
2530  067d cd0000        	call	_I2C_ReceiveData
2532  0680 b735          	ld	L535_DS3231_Data+18,a
2533                     ; 310 				break;
2535  0682 2011          	jra	L5401
2536  0684               L507:
2537                     ; 314 				DS3231_Data.Temperature.cel = I2C_ReceiveData(); // Receive whole degrees of temperature sensor
2539  0684 cd0000        	call	_I2C_ReceiveData
2541  0687 b736          	ld	L535_DS3231_Data+19,a
2542                     ; 315 				break;
2544  0689 200a          	jra	L5401
2545  068b               L707:
2546                     ; 319 				DS3231_Data.Temperature.frac = I2C_ReceiveData(); // Receive fractions of temperature sensor
2548  068b cd0000        	call	_I2C_ReceiveData
2550  068e b737          	ld	L535_DS3231_Data+20,a
2551                     ; 320 				break;
2553  0690 2003          	jra	L5401
2554  0692               L117:
2555                     ; 324 				I2C_ReceiveData(); // Someting went wrong, just receive data
2557  0692 cd0000        	call	_I2C_ReceiveData
2559  0695               L5401:
2560                     ; 206 	for (i = 0; i < numOfData; i++)
2562  0695 0c02          	inc	(OFST-2,sp)
2564  0697               L5201:
2567  0697 7b02          	ld	a,(OFST-2,sp)
2568  0699 1101          	cp	a,(OFST-3,sp)
2569  069b 2403          	jruge	L07
2570  069d cc059c        	jp	L3301
2571  06a0               L07:
2572                     ; 329 	I2C_AcknowledgeConfig(I2C_ACK_NONE); // Change ACK mode
2574  06a0 4f            	clr	a
2575  06a1 cd0000        	call	_I2C_AcknowledgeConfig
2577                     ; 330 	I2C_GenerateSTOP(ENABLE); // End transmission
2579  06a4 a601          	ld	a,#1
2580  06a6 cd0000        	call	_I2C_GenerateSTOP
2582                     ; 332 	return FALSE;
2584  06a9 4f            	clr	a
2586  06aa acb704b7      	jpf	L66
2656                     ; 336 bool DS3231_SetTime(uint8_t hours, uint8_t minutes, uint8_t seconds)
2656                     ; 337 {
2657                     	switch	.text
2658  06ae               _DS3231_SetTime:
2660  06ae 89            	pushw	x
2661  06af 89            	pushw	x
2662       00000002      OFST:	set	2
2665                     ; 338 	uint16_t error = 0;
2667  06b0 5f            	clrw	x
2668  06b1 1f01          	ldw	(OFST-1,sp),x
2670                     ; 340 	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
2672  06b3 a601          	ld	a,#1
2673  06b5 cd0000        	call	_I2C_AcknowledgeConfig
2676  06b8 2019          	jra	L3011
2677  06ba               L1011:
2678                     ; 344 		error++; // Increment error counter
2680  06ba 1e01          	ldw	x,(OFST-1,sp)
2681  06bc 1c0001        	addw	x,#1
2682  06bf 1f01          	ldw	(OFST-1,sp),x
2684                     ; 345 		if (error >= 65000) return TRUE; // Return from function
2686  06c1 9c            	rvf
2687  06c2 1e01          	ldw	x,(OFST-1,sp)
2688  06c4 cd0000        	call	c_uitolx
2690  06c7 ae0000        	ldw	x,#L05
2691  06ca cd0000        	call	c_lcmp
2693  06cd 2f04          	jrslt	L3011
2696  06cf a601          	ld	a,#1
2698  06d1 202a          	jra	L47
2699  06d3               L3011:
2700                     ; 342 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
2702  06d3 ae0302        	ldw	x,#770
2703  06d6 cd0000        	call	_I2C_GetFlagStatus
2705  06d9 4d            	tnz	a
2706  06da 26de          	jrne	L1011
2707                     ; 347 	error = 0;
2709  06dc 5f            	clrw	x
2710  06dd 1f01          	ldw	(OFST-1,sp),x
2712                     ; 349 	I2C_GenerateSTART(ENABLE); // Generate start
2714  06df a601          	ld	a,#1
2715  06e1 cd0000        	call	_I2C_GenerateSTART
2718  06e4 201a          	jra	L3111
2719  06e6               L1111:
2720                     ; 352 		error++; // Increment error counter
2722  06e6 1e01          	ldw	x,(OFST-1,sp)
2723  06e8 1c0001        	addw	x,#1
2724  06eb 1f01          	ldw	(OFST-1,sp),x
2726                     ; 353 		if (error >= 65000) return TRUE; // Return from function
2728  06ed 9c            	rvf
2729  06ee 1e01          	ldw	x,(OFST-1,sp)
2730  06f0 cd0000        	call	c_uitolx
2732  06f3 ae0000        	ldw	x,#L05
2733  06f6 cd0000        	call	c_lcmp
2735  06f9 2f05          	jrslt	L3111
2738  06fb a601          	ld	a,#1
2740  06fd               L47:
2742  06fd 5b04          	addw	sp,#4
2743  06ff 81            	ret
2744  0700               L3111:
2745                     ; 350 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Wait for ACK
2747  0700 ae0301        	ldw	x,#769
2748  0703 cd0000        	call	_I2C_CheckEvent
2750  0706 4d            	tnz	a
2751  0707 27dd          	jreq	L1111
2752                     ; 355 	error = 0;
2754  0709 5f            	clrw	x
2755  070a 1f01          	ldw	(OFST-1,sp),x
2757                     ; 357 	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
2759  070c aed000        	ldw	x,#53248
2760  070f cd0000        	call	_I2C_Send7bitAddress
2763  0712 2019          	jra	L3211
2764  0714               L1211:
2765                     ; 360 		error++; // Increment error counter
2767  0714 1e01          	ldw	x,(OFST-1,sp)
2768  0716 1c0001        	addw	x,#1
2769  0719 1f01          	ldw	(OFST-1,sp),x
2771                     ; 361 		if (error >= 65000) return TRUE; // Return from function
2773  071b 9c            	rvf
2774  071c 1e01          	ldw	x,(OFST-1,sp)
2775  071e cd0000        	call	c_uitolx
2777  0721 ae0000        	ldw	x,#L05
2778  0724 cd0000        	call	c_lcmp
2780  0727 2f04          	jrslt	L3211
2783  0729 a601          	ld	a,#1
2785  072b 20d0          	jra	L47
2786  072d               L3211:
2787                     ; 358 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
2789  072d ae0782        	ldw	x,#1922
2790  0730 cd0000        	call	_I2C_CheckEvent
2792  0733 4d            	tnz	a
2793  0734 27de          	jreq	L1211
2794                     ; 363 	error = 0;
2796  0736 5f            	clrw	x
2797  0737 1f01          	ldw	(OFST-1,sp),x
2799                     ; 365 	I2C_SendData(adr_Seconds); // Send address of seconds register
2801  0739 4f            	clr	a
2802  073a cd0000        	call	_I2C_SendData
2805  073d 2019          	jra	L3311
2806  073f               L1311:
2807                     ; 368 		error++; // Increment error counter
2809  073f 1e01          	ldw	x,(OFST-1,sp)
2810  0741 1c0001        	addw	x,#1
2811  0744 1f01          	ldw	(OFST-1,sp),x
2813                     ; 369 		if (error >= 65000) return TRUE; // Return from function
2815  0746 9c            	rvf
2816  0747 1e01          	ldw	x,(OFST-1,sp)
2817  0749 cd0000        	call	c_uitolx
2819  074c ae0000        	ldw	x,#L05
2820  074f cd0000        	call	c_lcmp
2822  0752 2f04          	jrslt	L3311
2825  0754 a601          	ld	a,#1
2827  0756 20a5          	jra	L47
2828  0758               L3311:
2829                     ; 366 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
2831  0758 ae0784        	ldw	x,#1924
2832  075b cd0000        	call	_I2C_CheckEvent
2834  075e 4d            	tnz	a
2835  075f 27de          	jreq	L1311
2836                     ; 371 	error = 0;
2838  0761 5f            	clrw	x
2839  0762 1f01          	ldw	(OFST-1,sp),x
2841                     ; 373 	I2C_SendData(dec2bcd(seconds)); // Send new seconds value
2843  0764 7b07          	ld	a,(OFST+5,sp)
2844  0766 cd0b30        	call	_dec2bcd
2846  0769 cd0000        	call	_I2C_SendData
2849  076c 201b          	jra	L3411
2850  076e               L1411:
2851                     ; 376 		error++; // Increment error counter
2853  076e 1e01          	ldw	x,(OFST-1,sp)
2854  0770 1c0001        	addw	x,#1
2855  0773 1f01          	ldw	(OFST-1,sp),x
2857                     ; 377 		if (error >= 65000) return TRUE; // Return from function
2859  0775 9c            	rvf
2860  0776 1e01          	ldw	x,(OFST-1,sp)
2861  0778 cd0000        	call	c_uitolx
2863  077b ae0000        	ldw	x,#L05
2864  077e cd0000        	call	c_lcmp
2866  0781 2f06          	jrslt	L3411
2869  0783 a601          	ld	a,#1
2871  0785 acfd06fd      	jpf	L47
2872  0789               L3411:
2873                     ; 374 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
2875  0789 ae0784        	ldw	x,#1924
2876  078c cd0000        	call	_I2C_CheckEvent
2878  078f 4d            	tnz	a
2879  0790 27dc          	jreq	L1411
2880                     ; 379 	error = 0;
2882  0792 5f            	clrw	x
2883  0793 1f01          	ldw	(OFST-1,sp),x
2885                     ; 381 	I2C_SendData(dec2bcd(minutes)); // Send new minutes value
2887  0795 7b04          	ld	a,(OFST+2,sp)
2888  0797 cd0b30        	call	_dec2bcd
2890  079a cd0000        	call	_I2C_SendData
2893  079d 201b          	jra	L3511
2894  079f               L1511:
2895                     ; 384 		error++; // Increment error counter
2897  079f 1e01          	ldw	x,(OFST-1,sp)
2898  07a1 1c0001        	addw	x,#1
2899  07a4 1f01          	ldw	(OFST-1,sp),x
2901                     ; 385 		if (error >= 65000) return TRUE; // Return from function
2903  07a6 9c            	rvf
2904  07a7 1e01          	ldw	x,(OFST-1,sp)
2905  07a9 cd0000        	call	c_uitolx
2907  07ac ae0000        	ldw	x,#L05
2908  07af cd0000        	call	c_lcmp
2910  07b2 2f06          	jrslt	L3511
2913  07b4 a601          	ld	a,#1
2915  07b6 acfd06fd      	jpf	L47
2916  07ba               L3511:
2917                     ; 382 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
2919  07ba ae0784        	ldw	x,#1924
2920  07bd cd0000        	call	_I2C_CheckEvent
2922  07c0 4d            	tnz	a
2923  07c1 27dc          	jreq	L1511
2924                     ; 387 	error = 0;
2926  07c3 5f            	clrw	x
2927  07c4 1f01          	ldw	(OFST-1,sp),x
2929                     ; 389 	I2C_SendData(dec2bcd(hours)); // Send new hours value
2931  07c6 7b03          	ld	a,(OFST+1,sp)
2932  07c8 cd0b30        	call	_dec2bcd
2934  07cb cd0000        	call	_I2C_SendData
2937  07ce 201b          	jra	L3611
2938  07d0               L1611:
2939                     ; 392 		error++; // Increment error counter
2941  07d0 1e01          	ldw	x,(OFST-1,sp)
2942  07d2 1c0001        	addw	x,#1
2943  07d5 1f01          	ldw	(OFST-1,sp),x
2945                     ; 393 		if (error >= 65000) return TRUE; // Return from function
2947  07d7 9c            	rvf
2948  07d8 1e01          	ldw	x,(OFST-1,sp)
2949  07da cd0000        	call	c_uitolx
2951  07dd ae0000        	ldw	x,#L05
2952  07e0 cd0000        	call	c_lcmp
2954  07e3 2f06          	jrslt	L3611
2957  07e5 a601          	ld	a,#1
2959  07e7 acfd06fd      	jpf	L47
2960  07eb               L3611:
2961                     ; 390 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
2963  07eb ae0784        	ldw	x,#1924
2964  07ee cd0000        	call	_I2C_CheckEvent
2966  07f1 4d            	tnz	a
2967  07f2 27dc          	jreq	L1611
2968                     ; 395 	error = 0;
2970                     ; 397 	I2C_GenerateSTOP(ENABLE); // End transmission
2972  07f4 a601          	ld	a,#1
2973  07f6 cd0000        	call	_I2C_GenerateSTOP
2975                     ; 399 	return FALSE;
2977  07f9 4f            	clr	a
2979  07fa acfd06fd      	jpf	L47
3058                     ; 403 bool DS3231_SetDate(uint8_t day, uint8_t month, uint8_t year, uint8_t century)
3058                     ; 404 {
3059                     	switch	.text
3060  07fe               _DS3231_SetDate:
3062  07fe 89            	pushw	x
3063  07ff 5203          	subw	sp,#3
3064       00000003      OFST:	set	3
3067                     ; 405 	uint16_t error = 0;
3069  0801 5f            	clrw	x
3070  0802 1f02          	ldw	(OFST-1,sp),x
3072                     ; 407 	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
3074  0804 a601          	ld	a,#1
3075  0806 cd0000        	call	_I2C_AcknowledgeConfig
3078  0809 2019          	jra	L1321
3079  080b               L7221:
3080                     ; 411 		error++; // Increment error counter
3082  080b 1e02          	ldw	x,(OFST-1,sp)
3083  080d 1c0001        	addw	x,#1
3084  0810 1f02          	ldw	(OFST-1,sp),x
3086                     ; 412 		if (error >= 65000) return TRUE; // Return from function
3088  0812 9c            	rvf
3089  0813 1e02          	ldw	x,(OFST-1,sp)
3090  0815 cd0000        	call	c_uitolx
3092  0818 ae0000        	ldw	x,#L05
3093  081b cd0000        	call	c_lcmp
3095  081e 2f04          	jrslt	L1321
3098  0820 a601          	ld	a,#1
3100  0822 202a          	jra	L001
3101  0824               L1321:
3102                     ; 409 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
3104  0824 ae0302        	ldw	x,#770
3105  0827 cd0000        	call	_I2C_GetFlagStatus
3107  082a 4d            	tnz	a
3108  082b 26de          	jrne	L7221
3109                     ; 414 	error = 0;
3111  082d 5f            	clrw	x
3112  082e 1f02          	ldw	(OFST-1,sp),x
3114                     ; 416 	I2C_GenerateSTART(ENABLE); // Generate start
3116  0830 a601          	ld	a,#1
3117  0832 cd0000        	call	_I2C_GenerateSTART
3120  0835 201a          	jra	L1421
3121  0837               L7321:
3122                     ; 419 		error++; // Increment error counter
3124  0837 1e02          	ldw	x,(OFST-1,sp)
3125  0839 1c0001        	addw	x,#1
3126  083c 1f02          	ldw	(OFST-1,sp),x
3128                     ; 420 		if (error >= 65000) return TRUE; // Return from function
3130  083e 9c            	rvf
3131  083f 1e02          	ldw	x,(OFST-1,sp)
3132  0841 cd0000        	call	c_uitolx
3134  0844 ae0000        	ldw	x,#L05
3135  0847 cd0000        	call	c_lcmp
3137  084a 2f05          	jrslt	L1421
3140  084c a601          	ld	a,#1
3142  084e               L001:
3144  084e 5b05          	addw	sp,#5
3145  0850 81            	ret
3146  0851               L1421:
3147                     ; 417 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Wait for ACK
3149  0851 ae0301        	ldw	x,#769
3150  0854 cd0000        	call	_I2C_CheckEvent
3152  0857 4d            	tnz	a
3153  0858 27dd          	jreq	L7321
3154                     ; 422 	error = 0;
3156  085a 5f            	clrw	x
3157  085b 1f02          	ldw	(OFST-1,sp),x
3159                     ; 424 	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
3161  085d aed000        	ldw	x,#53248
3162  0860 cd0000        	call	_I2C_Send7bitAddress
3165  0863 2019          	jra	L1521
3166  0865               L7421:
3167                     ; 427 		error++; // Increment error counter
3169  0865 1e02          	ldw	x,(OFST-1,sp)
3170  0867 1c0001        	addw	x,#1
3171  086a 1f02          	ldw	(OFST-1,sp),x
3173                     ; 428 		if (error >= 65000) return TRUE; // Return from function
3175  086c 9c            	rvf
3176  086d 1e02          	ldw	x,(OFST-1,sp)
3177  086f cd0000        	call	c_uitolx
3179  0872 ae0000        	ldw	x,#L05
3180  0875 cd0000        	call	c_lcmp
3182  0878 2f04          	jrslt	L1521
3185  087a a601          	ld	a,#1
3187  087c 20d0          	jra	L001
3188  087e               L1521:
3189                     ; 425 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
3191  087e ae0782        	ldw	x,#1922
3192  0881 cd0000        	call	_I2C_CheckEvent
3194  0884 4d            	tnz	a
3195  0885 27de          	jreq	L7421
3196                     ; 430 	error = 0;
3198  0887 5f            	clrw	x
3199  0888 1f02          	ldw	(OFST-1,sp),x
3201                     ; 432 	I2C_SendData(adr_Day); // Send address of day register
3203  088a a604          	ld	a,#4
3204  088c cd0000        	call	_I2C_SendData
3207  088f 2019          	jra	L1621
3208  0891               L7521:
3209                     ; 435 		error++; // Increment error counter
3211  0891 1e02          	ldw	x,(OFST-1,sp)
3212  0893 1c0001        	addw	x,#1
3213  0896 1f02          	ldw	(OFST-1,sp),x
3215                     ; 436 		if (error >= 65000) return TRUE; // Return from function
3217  0898 9c            	rvf
3218  0899 1e02          	ldw	x,(OFST-1,sp)
3219  089b cd0000        	call	c_uitolx
3221  089e ae0000        	ldw	x,#L05
3222  08a1 cd0000        	call	c_lcmp
3224  08a4 2f04          	jrslt	L1621
3227  08a6 a601          	ld	a,#1
3229  08a8 20a4          	jra	L001
3230  08aa               L1621:
3231                     ; 433 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
3233  08aa ae0784        	ldw	x,#1924
3234  08ad cd0000        	call	_I2C_CheckEvent
3236  08b0 4d            	tnz	a
3237  08b1 27de          	jreq	L7521
3238                     ; 438 	error = 0;
3240  08b3 5f            	clrw	x
3241  08b4 1f02          	ldw	(OFST-1,sp),x
3243                     ; 440 	I2C_SendData(day); // Send new day value
3245  08b6 7b04          	ld	a,(OFST+1,sp)
3246  08b8 cd0000        	call	_I2C_SendData
3249  08bb 201b          	jra	L1721
3250  08bd               L7621:
3251                     ; 443 		error++; // Increment error counter
3253  08bd 1e02          	ldw	x,(OFST-1,sp)
3254  08bf 1c0001        	addw	x,#1
3255  08c2 1f02          	ldw	(OFST-1,sp),x
3257                     ; 444 		if (error >= 65000) return TRUE; // Return from function
3259  08c4 9c            	rvf
3260  08c5 1e02          	ldw	x,(OFST-1,sp)
3261  08c7 cd0000        	call	c_uitolx
3263  08ca ae0000        	ldw	x,#L05
3264  08cd cd0000        	call	c_lcmp
3266  08d0 2f06          	jrslt	L1721
3269  08d2 a601          	ld	a,#1
3271  08d4 ac4e084e      	jpf	L001
3272  08d8               L1721:
3273                     ; 441 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
3275  08d8 ae0784        	ldw	x,#1924
3276  08db cd0000        	call	_I2C_CheckEvent
3278  08de 4d            	tnz	a
3279  08df 27dc          	jreq	L7621
3280                     ; 446 	error = 0;
3282  08e1 5f            	clrw	x
3283  08e2 1f02          	ldw	(OFST-1,sp),x
3285                     ; 448 	I2C_SendData(dec2bcd(month) | (century << 7)); // Send new month + century value
3287  08e4 7b09          	ld	a,(OFST+6,sp)
3288  08e6 97            	ld	xl,a
3289  08e7 a680          	ld	a,#128
3290  08e9 42            	mul	x,a
3291  08ea 9f            	ld	a,xl
3292  08eb 6b01          	ld	(OFST-2,sp),a
3294  08ed 7b05          	ld	a,(OFST+2,sp)
3295  08ef cd0b30        	call	_dec2bcd
3297  08f2 1a01          	or	a,(OFST-2,sp)
3298  08f4 cd0000        	call	_I2C_SendData
3301  08f7 201b          	jra	L1031
3302  08f9               L7721:
3303                     ; 451 		error++; // Increment error counter
3305  08f9 1e02          	ldw	x,(OFST-1,sp)
3306  08fb 1c0001        	addw	x,#1
3307  08fe 1f02          	ldw	(OFST-1,sp),x
3309                     ; 452 		if (error >= 65000) return TRUE; // Return from function
3311  0900 9c            	rvf
3312  0901 1e02          	ldw	x,(OFST-1,sp)
3313  0903 cd0000        	call	c_uitolx
3315  0906 ae0000        	ldw	x,#L05
3316  0909 cd0000        	call	c_lcmp
3318  090c 2f06          	jrslt	L1031
3321  090e a601          	ld	a,#1
3323  0910 ac4e084e      	jpf	L001
3324  0914               L1031:
3325                     ; 449 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
3327  0914 ae0784        	ldw	x,#1924
3328  0917 cd0000        	call	_I2C_CheckEvent
3330  091a 4d            	tnz	a
3331  091b 27dc          	jreq	L7721
3332                     ; 454 	error = 0;
3334  091d 5f            	clrw	x
3335  091e 1f02          	ldw	(OFST-1,sp),x
3337                     ; 456 	I2C_SendData(dec2bcd(year)); // Send new year value
3339  0920 7b08          	ld	a,(OFST+5,sp)
3340  0922 cd0b30        	call	_dec2bcd
3342  0925 cd0000        	call	_I2C_SendData
3345  0928 201b          	jra	L1131
3346  092a               L7031:
3347                     ; 459 		error++; // Increment error counter
3349  092a 1e02          	ldw	x,(OFST-1,sp)
3350  092c 1c0001        	addw	x,#1
3351  092f 1f02          	ldw	(OFST-1,sp),x
3353                     ; 460 		if (error >= 65000) return TRUE; // Return from function
3355  0931 9c            	rvf
3356  0932 1e02          	ldw	x,(OFST-1,sp)
3357  0934 cd0000        	call	c_uitolx
3359  0937 ae0000        	ldw	x,#L05
3360  093a cd0000        	call	c_lcmp
3362  093d 2f06          	jrslt	L1131
3365  093f a601          	ld	a,#1
3367  0941 ac4e084e      	jpf	L001
3368  0945               L1131:
3369                     ; 457 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
3371  0945 ae0784        	ldw	x,#1924
3372  0948 cd0000        	call	_I2C_CheckEvent
3374  094b 4d            	tnz	a
3375  094c 27dc          	jreq	L7031
3376                     ; 462 	error = 0;
3378                     ; 464 	I2C_GenerateSTOP(ENABLE); // End transmission
3380  094e a601          	ld	a,#1
3381  0950 cd0000        	call	_I2C_GenerateSTOP
3383                     ; 466 	return FALSE;
3385  0953 4f            	clr	a
3387  0954 ac4e084e      	jpf	L001
3423                     ; 471 void DS3231_GetTimeFull(char *time)
3423                     ; 472 {
3424                     	switch	.text
3425  0958               _DS3231_GetTimeFull:
3427  0958 89            	pushw	x
3428       00000000      OFST:	set	0
3431                     ; 474 	if (DS3231_Data.TimeDate.Hours == 199)
3433  0959 b625          	ld	a,L535_DS3231_Data+2
3434  095b a1c7          	cp	a,#199
3435  095d 2609          	jrne	L5331
3436                     ; 476 		time[0] = 0x20;
3438  095f a620          	ld	a,#32
3439  0961 f7            	ld	(x),a
3440                     ; 477 		time[1] = 0x20;
3442  0962 a620          	ld	a,#32
3443  0964 e701          	ld	(1,x),a
3445  0966 201d          	jra	L7331
3446  0968               L5331:
3447                     ; 481 		time[0] = DS3231_Data.TimeDate.Hours / 10 + 0x30;
3449  0968 b625          	ld	a,L535_DS3231_Data+2
3450  096a 5f            	clrw	x
3451  096b 97            	ld	xl,a
3452  096c a60a          	ld	a,#10
3453  096e 62            	div	x,a
3454  096f 9f            	ld	a,xl
3455  0970 ab30          	add	a,#48
3456  0972 1e01          	ldw	x,(OFST+1,sp)
3457  0974 f7            	ld	(x),a
3458                     ; 482 		time[1] = DS3231_Data.TimeDate.Hours % 10 + 0x30;
3460  0975 b625          	ld	a,L535_DS3231_Data+2
3461  0977 5f            	clrw	x
3462  0978 97            	ld	xl,a
3463  0979 a60a          	ld	a,#10
3464  097b 62            	div	x,a
3465  097c 5f            	clrw	x
3466  097d 97            	ld	xl,a
3467  097e 9f            	ld	a,xl
3468  097f ab30          	add	a,#48
3469  0981 1e01          	ldw	x,(OFST+1,sp)
3470  0983 e701          	ld	(1,x),a
3471  0985               L7331:
3472                     ; 484 	time[2] = ':';
3474  0985 1e01          	ldw	x,(OFST+1,sp)
3475  0987 a63a          	ld	a,#58
3476  0989 e702          	ld	(2,x),a
3477                     ; 487 	if (DS3231_Data.TimeDate.Minutes == 199)
3479  098b b624          	ld	a,L535_DS3231_Data+1
3480  098d a1c7          	cp	a,#199
3481  098f 260e          	jrne	L1431
3482                     ; 489 		time[3] = 0x20;
3484  0991 1e01          	ldw	x,(OFST+1,sp)
3485  0993 a620          	ld	a,#32
3486  0995 e703          	ld	(3,x),a
3487                     ; 490 		time[4] = 0x20;
3489  0997 1e01          	ldw	x,(OFST+1,sp)
3490  0999 a620          	ld	a,#32
3491  099b e704          	ld	(4,x),a
3493  099d 201e          	jra	L3431
3494  099f               L1431:
3495                     ; 494 		time[3] = DS3231_Data.TimeDate.Minutes / 10 + 0x30;
3497  099f b624          	ld	a,L535_DS3231_Data+1
3498  09a1 5f            	clrw	x
3499  09a2 97            	ld	xl,a
3500  09a3 a60a          	ld	a,#10
3501  09a5 62            	div	x,a
3502  09a6 9f            	ld	a,xl
3503  09a7 ab30          	add	a,#48
3504  09a9 1e01          	ldw	x,(OFST+1,sp)
3505  09ab e703          	ld	(3,x),a
3506                     ; 495 		time[4] = DS3231_Data.TimeDate.Minutes % 10 + 0x30;
3508  09ad b624          	ld	a,L535_DS3231_Data+1
3509  09af 5f            	clrw	x
3510  09b0 97            	ld	xl,a
3511  09b1 a60a          	ld	a,#10
3512  09b3 62            	div	x,a
3513  09b4 5f            	clrw	x
3514  09b5 97            	ld	xl,a
3515  09b6 9f            	ld	a,xl
3516  09b7 ab30          	add	a,#48
3517  09b9 1e01          	ldw	x,(OFST+1,sp)
3518  09bb e704          	ld	(4,x),a
3519  09bd               L3431:
3520                     ; 497 	time[5] = ':';
3522  09bd 1e01          	ldw	x,(OFST+1,sp)
3523  09bf a63a          	ld	a,#58
3524  09c1 e705          	ld	(5,x),a
3525                     ; 500 	time[6] = DS3231_Data.TimeDate.Seconds / 10 + 0x30;
3527  09c3 b623          	ld	a,L535_DS3231_Data
3528  09c5 5f            	clrw	x
3529  09c6 97            	ld	xl,a
3530  09c7 a60a          	ld	a,#10
3531  09c9 62            	div	x,a
3532  09ca 9f            	ld	a,xl
3533  09cb ab30          	add	a,#48
3534  09cd 1e01          	ldw	x,(OFST+1,sp)
3535  09cf e706          	ld	(6,x),a
3536                     ; 501 	time[7] = DS3231_Data.TimeDate.Seconds % 10 + 0x30;
3538  09d1 b623          	ld	a,L535_DS3231_Data
3539  09d3 5f            	clrw	x
3540  09d4 97            	ld	xl,a
3541  09d5 a60a          	ld	a,#10
3542  09d7 62            	div	x,a
3543  09d8 5f            	clrw	x
3544  09d9 97            	ld	xl,a
3545  09da 9f            	ld	a,xl
3546  09db ab30          	add	a,#48
3547  09dd 1e01          	ldw	x,(OFST+1,sp)
3548  09df e707          	ld	(7,x),a
3549                     ; 502 	time[8] = '\0';
3551  09e1 1e01          	ldw	x,(OFST+1,sp)
3552  09e3 6f08          	clr	(8,x)
3553                     ; 503 }
3556  09e5 85            	popw	x
3557  09e6 81            	ret
3611                     ; 507 void DS3231_GetTemp(char *temp)
3611                     ; 508 {
3612                     	switch	.text
3613  09e7               _DS3231_GetTemp:
3615  09e7 89            	pushw	x
3616  09e8 89            	pushw	x
3617       00000002      OFST:	set	2
3620                     ; 509 	int8_t t = DS3231_Data.Temperature.cel;
3622  09e9 b636          	ld	a,L535_DS3231_Data+19
3623  09eb 6b02          	ld	(OFST+0,sp),a
3625                     ; 510 	uint8_t f = (DS3231_Data.Temperature.frac >> 6) * 25;
3627  09ed b637          	ld	a,L535_DS3231_Data+20
3628  09ef 4e            	swap	a
3629  09f0 44            	srl	a
3630  09f1 44            	srl	a
3631  09f2 a403          	and	a,#3
3632  09f4 97            	ld	xl,a
3633  09f5 a619          	ld	a,#25
3634  09f7 42            	mul	x,a
3635  09f8 9f            	ld	a,xl
3636  09f9 6b01          	ld	(OFST-1,sp),a
3638                     ; 513 	if (DS3231_Data.Temperature.cel < 0)
3640  09fb 9c            	rvf
3641  09fc b636          	ld	a,L535_DS3231_Data+19
3642  09fe a100          	cp	a,#0
3643  0a00 2e0c          	jrsge	L3731
3644                     ; 515 		temp[0] = '-';
3646  0a02 1e03          	ldw	x,(OFST+1,sp)
3647  0a04 a62d          	ld	a,#45
3648  0a06 f7            	ld	(x),a
3649                     ; 516 		t = DS3231_Data.Temperature.cel * -1;
3651  0a07 b636          	ld	a,L535_DS3231_Data+19
3652  0a09 40            	neg	a
3653  0a0a 6b02          	ld	(OFST+0,sp),a
3656  0a0c 2005          	jra	L5731
3657  0a0e               L3731:
3658                     ; 518 	else temp[0] = ' ';
3660  0a0e 1e03          	ldw	x,(OFST+1,sp)
3661  0a10 a620          	ld	a,#32
3662  0a12 f7            	ld	(x),a
3663  0a13               L5731:
3664                     ; 521 	temp[1] = t / 10 + 0x30;
3666  0a13 7b02          	ld	a,(OFST+0,sp)
3667  0a15 ae000a        	ldw	x,#10
3668  0a18 51            	exgw	x,y
3669  0a19 5f            	clrw	x
3670  0a1a 4d            	tnz	a
3671  0a1b 2a01          	jrpl	L601
3672  0a1d 5a            	decw	x
3673  0a1e               L601:
3674  0a1e 02            	rlwa	x,a
3675  0a1f cd0000        	call	c_idiv
3677  0a22 9f            	ld	a,xl
3678  0a23 ab30          	add	a,#48
3679  0a25 1e03          	ldw	x,(OFST+1,sp)
3680  0a27 e701          	ld	(1,x),a
3681                     ; 522 	temp[2] = t % 10 + 0x30;
3683  0a29 7b02          	ld	a,(OFST+0,sp)
3684  0a2b ae000a        	ldw	x,#10
3685  0a2e 51            	exgw	x,y
3686  0a2f 5f            	clrw	x
3687  0a30 4d            	tnz	a
3688  0a31 2a01          	jrpl	L011
3689  0a33 5a            	decw	x
3690  0a34               L011:
3691  0a34 02            	rlwa	x,a
3692  0a35 cd0000        	call	c_idiv
3694  0a38 909f          	ld	a,yl
3695  0a3a ab30          	add	a,#48
3696  0a3c 1e03          	ldw	x,(OFST+1,sp)
3697  0a3e e702          	ld	(2,x),a
3698                     ; 523 	temp[3] = '.';
3700  0a40 1e03          	ldw	x,(OFST+1,sp)
3701  0a42 a62e          	ld	a,#46
3702  0a44 e703          	ld	(3,x),a
3703                     ; 526 	temp[4] = f / 10 + 0x30;
3705  0a46 7b01          	ld	a,(OFST-1,sp)
3706  0a48 5f            	clrw	x
3707  0a49 97            	ld	xl,a
3708  0a4a a60a          	ld	a,#10
3709  0a4c 62            	div	x,a
3710  0a4d 9f            	ld	a,xl
3711  0a4e ab30          	add	a,#48
3712  0a50 1e03          	ldw	x,(OFST+1,sp)
3713  0a52 e704          	ld	(4,x),a
3714                     ; 527 	temp[5] = f % 10 + 0x30;
3716  0a54 7b01          	ld	a,(OFST-1,sp)
3717  0a56 5f            	clrw	x
3718  0a57 97            	ld	xl,a
3719  0a58 a60a          	ld	a,#10
3720  0a5a 62            	div	x,a
3721  0a5b 5f            	clrw	x
3722  0a5c 97            	ld	xl,a
3723  0a5d 9f            	ld	a,xl
3724  0a5e ab30          	add	a,#48
3725  0a60 1e03          	ldw	x,(OFST+1,sp)
3726  0a62 e705          	ld	(5,x),a
3727                     ; 528 	temp[6] = '\0';
3729  0a64 1e03          	ldw	x,(OFST+1,sp)
3730  0a66 6f06          	clr	(6,x)
3731                     ; 529 }
3734  0a68 5b04          	addw	sp,#4
3735  0a6a 81            	ret
3771                     ; 533 void DS3231_GetDateFull(char *date)
3771                     ; 534 {
3772                     	switch	.text
3773  0a6b               _DS3231_GetDateFull:
3775  0a6b 89            	pushw	x
3776       00000000      OFST:	set	0
3779                     ; 536 	if (DS3231_Data.TimeDate.Day == 199)
3781  0a6c b628          	ld	a,L535_DS3231_Data+5
3782  0a6e a1c7          	cp	a,#199
3783  0a70 2609          	jrne	L5141
3784                     ; 538 		date[0] = 0x20;
3786  0a72 a620          	ld	a,#32
3787  0a74 f7            	ld	(x),a
3788                     ; 539 		date[1] = 0x20;
3790  0a75 a620          	ld	a,#32
3791  0a77 e701          	ld	(1,x),a
3793  0a79 201d          	jra	L7141
3794  0a7b               L5141:
3795                     ; 543 		date[0] = DS3231_Data.TimeDate.Day / 10 + 0x30;
3797  0a7b b628          	ld	a,L535_DS3231_Data+5
3798  0a7d 5f            	clrw	x
3799  0a7e 97            	ld	xl,a
3800  0a7f a60a          	ld	a,#10
3801  0a81 62            	div	x,a
3802  0a82 9f            	ld	a,xl
3803  0a83 ab30          	add	a,#48
3804  0a85 1e01          	ldw	x,(OFST+1,sp)
3805  0a87 f7            	ld	(x),a
3806                     ; 544 		date[1] = DS3231_Data.TimeDate.Day % 10 + 0x30;
3808  0a88 b628          	ld	a,L535_DS3231_Data+5
3809  0a8a 5f            	clrw	x
3810  0a8b 97            	ld	xl,a
3811  0a8c a60a          	ld	a,#10
3812  0a8e 62            	div	x,a
3813  0a8f 5f            	clrw	x
3814  0a90 97            	ld	xl,a
3815  0a91 9f            	ld	a,xl
3816  0a92 ab30          	add	a,#48
3817  0a94 1e01          	ldw	x,(OFST+1,sp)
3818  0a96 e701          	ld	(1,x),a
3819  0a98               L7141:
3820                     ; 546 	date[2] = '.';
3822  0a98 1e01          	ldw	x,(OFST+1,sp)
3823  0a9a a62e          	ld	a,#46
3824  0a9c e702          	ld	(2,x),a
3825                     ; 549 	if (DS3231_Data.TimeDate.Month == 199)
3827  0a9e b629          	ld	a,L535_DS3231_Data+6
3828  0aa0 a1c7          	cp	a,#199
3829  0aa2 260e          	jrne	L1241
3830                     ; 551 		date[3] = 0x20;
3832  0aa4 1e01          	ldw	x,(OFST+1,sp)
3833  0aa6 a620          	ld	a,#32
3834  0aa8 e703          	ld	(3,x),a
3835                     ; 552 		date[4] = 0x20;
3837  0aaa 1e01          	ldw	x,(OFST+1,sp)
3838  0aac a620          	ld	a,#32
3839  0aae e704          	ld	(4,x),a
3841  0ab0 201e          	jra	L3241
3842  0ab2               L1241:
3843                     ; 556 		date[3] = DS3231_Data.TimeDate.Month / 10 + 0x30;
3845  0ab2 b629          	ld	a,L535_DS3231_Data+6
3846  0ab4 5f            	clrw	x
3847  0ab5 97            	ld	xl,a
3848  0ab6 a60a          	ld	a,#10
3849  0ab8 62            	div	x,a
3850  0ab9 9f            	ld	a,xl
3851  0aba ab30          	add	a,#48
3852  0abc 1e01          	ldw	x,(OFST+1,sp)
3853  0abe e703          	ld	(3,x),a
3854                     ; 557 		date[4] = DS3231_Data.TimeDate.Month % 10 + 0x30;
3856  0ac0 b629          	ld	a,L535_DS3231_Data+6
3857  0ac2 5f            	clrw	x
3858  0ac3 97            	ld	xl,a
3859  0ac4 a60a          	ld	a,#10
3860  0ac6 62            	div	x,a
3861  0ac7 5f            	clrw	x
3862  0ac8 97            	ld	xl,a
3863  0ac9 9f            	ld	a,xl
3864  0aca ab30          	add	a,#48
3865  0acc 1e01          	ldw	x,(OFST+1,sp)
3866  0ace e704          	ld	(4,x),a
3867  0ad0               L3241:
3868                     ; 559 	date[5] = '.';
3870  0ad0 1e01          	ldw	x,(OFST+1,sp)
3871  0ad2 a62e          	ld	a,#46
3872  0ad4 e705          	ld	(5,x),a
3873                     ; 562 	if (DS3231_Data.TimeDate.Year == 199)
3875  0ad6 b62a          	ld	a,L535_DS3231_Data+7
3876  0ad8 a1c7          	cp	a,#199
3877  0ada 261a          	jrne	L5241
3878                     ; 564 		date[6] = 0x20;
3880  0adc 1e01          	ldw	x,(OFST+1,sp)
3881  0ade a620          	ld	a,#32
3882  0ae0 e706          	ld	(6,x),a
3883                     ; 565 		date[7] = 0x20;
3885  0ae2 1e01          	ldw	x,(OFST+1,sp)
3886  0ae4 a620          	ld	a,#32
3887  0ae6 e707          	ld	(7,x),a
3888                     ; 566 		date[8] = 0x20;
3890  0ae8 1e01          	ldw	x,(OFST+1,sp)
3891  0aea a620          	ld	a,#32
3892  0aec e708          	ld	(8,x),a
3893                     ; 567 		date[9] = 0x20;
3895  0aee 1e01          	ldw	x,(OFST+1,sp)
3896  0af0 a620          	ld	a,#32
3897  0af2 e709          	ld	(9,x),a
3899  0af4 2034          	jra	L7241
3900  0af6               L5241:
3901                     ; 571 		date[6] = '2';
3903  0af6 1e01          	ldw	x,(OFST+1,sp)
3904  0af8 a632          	ld	a,#50
3905  0afa e706          	ld	(6,x),a
3906                     ; 572 		date[7] = DS3231_Data.TimeDate.Century % 10 + 0x30;
3908  0afc b62b          	ld	a,L535_DS3231_Data+8
3909  0afe 5f            	clrw	x
3910  0aff 97            	ld	xl,a
3911  0b00 a60a          	ld	a,#10
3912  0b02 62            	div	x,a
3913  0b03 5f            	clrw	x
3914  0b04 97            	ld	xl,a
3915  0b05 9f            	ld	a,xl
3916  0b06 ab30          	add	a,#48
3917  0b08 1e01          	ldw	x,(OFST+1,sp)
3918  0b0a e707          	ld	(7,x),a
3919                     ; 573 		date[8] = DS3231_Data.TimeDate.Year / 10 + 0x30;
3921  0b0c b62a          	ld	a,L535_DS3231_Data+7
3922  0b0e 5f            	clrw	x
3923  0b0f 97            	ld	xl,a
3924  0b10 a60a          	ld	a,#10
3925  0b12 62            	div	x,a
3926  0b13 9f            	ld	a,xl
3927  0b14 ab30          	add	a,#48
3928  0b16 1e01          	ldw	x,(OFST+1,sp)
3929  0b18 e708          	ld	(8,x),a
3930                     ; 574 		date[9] = DS3231_Data.TimeDate.Year % 10 + 0x30;
3932  0b1a b62a          	ld	a,L535_DS3231_Data+7
3933  0b1c 5f            	clrw	x
3934  0b1d 97            	ld	xl,a
3935  0b1e a60a          	ld	a,#10
3936  0b20 62            	div	x,a
3937  0b21 5f            	clrw	x
3938  0b22 97            	ld	xl,a
3939  0b23 9f            	ld	a,xl
3940  0b24 ab30          	add	a,#48
3941  0b26 1e01          	ldw	x,(OFST+1,sp)
3942  0b28 e709          	ld	(9,x),a
3943  0b2a               L7241:
3944                     ; 576 	date[10] = '\0';
3946  0b2a 1e01          	ldw	x,(OFST+1,sp)
3947  0b2c 6f0a          	clr	(10,x)
3948                     ; 577 }
3951  0b2e 85            	popw	x
3952  0b2f 81            	ret
3986                     ; 580 uint8_t dec2bcd(uint8_t dec)
3986                     ; 581 {
3987                     	switch	.text
3988  0b30               _dec2bcd:
3990  0b30 88            	push	a
3991  0b31 88            	push	a
3992       00000001      OFST:	set	1
3995                     ; 582 	return ((dec / 10) << 4) | (dec % 10);
3997  0b32 5f            	clrw	x
3998  0b33 97            	ld	xl,a
3999  0b34 a60a          	ld	a,#10
4000  0b36 62            	div	x,a
4001  0b37 5f            	clrw	x
4002  0b38 97            	ld	xl,a
4003  0b39 9f            	ld	a,xl
4004  0b3a 6b01          	ld	(OFST+0,sp),a
4006  0b3c 7b02          	ld	a,(OFST+1,sp)
4007  0b3e 5f            	clrw	x
4008  0b3f 97            	ld	xl,a
4009  0b40 a60a          	ld	a,#10
4010  0b42 62            	div	x,a
4011  0b43 9f            	ld	a,xl
4012  0b44 97            	ld	xl,a
4013  0b45 a610          	ld	a,#16
4014  0b47 42            	mul	x,a
4015  0b48 9f            	ld	a,xl
4016  0b49 1a01          	or	a,(OFST+0,sp)
4019  0b4b 85            	popw	x
4020  0b4c 81            	ret
4054                     ; 586 uint8_t bcd2dec(uint8_t bcd)
4054                     ; 587 {
4055                     	switch	.text
4056  0b4d               _bcd2dec:
4058  0b4d 88            	push	a
4059  0b4e 88            	push	a
4060       00000001      OFST:	set	1
4063                     ; 588 	return (((bcd >> 4) & 0x0F) * 10) + (bcd & 0x0F);
4065  0b4f a40f          	and	a,#15
4066  0b51 6b01          	ld	(OFST+0,sp),a
4068  0b53 7b02          	ld	a,(OFST+1,sp)
4069  0b55 4e            	swap	a
4070  0b56 a40f          	and	a,#15
4071  0b58 97            	ld	xl,a
4072  0b59 a60a          	ld	a,#10
4073  0b5b 42            	mul	x,a
4074  0b5c 9f            	ld	a,xl
4075  0b5d 1b01          	add	a,(OFST+0,sp)
4078  0b5f 85            	popw	x
4079  0b60 81            	ret
4326                     	bsct
4327  0000               _i:
4328  0000 00            	dc.b	0
4329  0001               _lcdUpdate:
4330  0001 03e8          	dc.w	1000
4331  0003               _setTime:
4332  0003 0000          	dc.w	0
4333  0005               _settingTime:
4334  0005 00            	dc.b	0
4335  0006               _setIndex:
4336  0006 00            	dc.b	0
4337  0007               _setNewVal:
4338  0007 ff            	dc.b	255
4339  0008               _setTimeNext:
4340  0008 00            	dc.b	0
4341  0009               _setTimeBlink:
4342  0009 0000          	dc.w	0
4343  000b               _setTimeBlinkB:
4344  000b 00            	dc.b	0
4345  000c               _setTimeUpdateLCD:
4346  000c 00            	dc.b	0
4347  000d               _setTimeIncrement:
4348  000d 00            	dc.b	0
4349  000e               _setTimeIncrementing:
4350  000e 00            	dc.b	0
4351  000f               _incrementTime:
4352  000f 32            	dc.b	50
4353  0010               _error:
4354  0010 00            	dc.b	0
4428                     ; 45 main()
4428                     ; 46 {
4429                     	switch	.text
4430  0b61               _main:
4434                     ; 48 	GPIO_setup();
4436  0b61 cd0f97        	call	_GPIO_setup
4438                     ; 49 	CLOCK_setup();
4440  0b64 cd0ff1        	call	_CLOCK_setup
4442                     ; 50 	I2C_setup();
4444  0b67 cd1054        	call	_I2C_setup
4446                     ; 52 	LCD_init(); // Initialize LCD
4448  0b6a cd0096        	call	_LCD_init
4450                     ; 53 	LCD_clear_home();
4452  0b6d cd01f9        	call	_LCD_clear_home
4454                     ; 55 	for (i = 0; i < 4; i++) // Blink LED 2 times when turning on
4456  0b70 3f00          	clr	_i
4457  0b72               L3461:
4458                     ; 57 		GPIO_WriteReverse(GPIOB, GPIO_PIN_2);
4460  0b72 4b04          	push	#4
4461  0b74 ae5005        	ldw	x,#20485
4462  0b77 cd0000        	call	_GPIO_WriteReverse
4464  0b7a 84            	pop	a
4465                     ; 58 		delay_ms(100);
4467  0b7b ae0064        	ldw	x,#100
4468  0b7e cd0025        	call	_delay_ms
4470                     ; 55 	for (i = 0; i < 4; i++) // Blink LED 2 times when turning on
4472  0b81 3c00          	inc	_i
4475  0b83 b600          	ld	a,_i
4476  0b85 a104          	cp	a,#4
4477  0b87 25e9          	jrult	L3461
4478                     ; 61 	delay_ms(2000); // Wait 2 sec for DS3231 module to turn on
4480  0b89 ae07d0        	ldw	x,#2000
4481  0b8c cd0025        	call	_delay_ms
4483                     ; 63 	error |= DS3231_Init(); // Initialize DS3231 (probably not required)
4485  0b8f cd037f        	call	_DS3231_Init
4487  0b92 ba10          	or	a,_error
4488  0b94 b710          	ld	_error,a
4489                     ; 64 	delay_us(10);
4491  0b96 ae000a        	ldw	x,#10
4492  0b99 cd0000        	call	_delay_us
4494                     ; 75 	enk_a = GPIO_ReadInputPin(GPIOD, GPIO_PIN_0) > 0; // ReadInputPin returns bit state shifted by its position - convert it to TRUE or FALSE
4496  0b9c 4b01          	push	#1
4497  0b9e ae500f        	ldw	x,#20495
4498  0ba1 cd0000        	call	_GPIO_ReadInputPin
4500  0ba4 5b01          	addw	sp,#1
4501  0ba6 4d            	tnz	a
4502  0ba7 2704          	jreq	L221
4503  0ba9 a601          	ld	a,#1
4504  0bab 2001          	jra	L421
4505  0bad               L221:
4506  0bad 4f            	clr	a
4507  0bae               L421:
4508  0bae b707          	ld	_enk_a,a
4509                     ; 76 	enk_a_prev = enk_a;
4511  0bb0 450706        	mov	_enk_a_prev,_enk_a
4512                     ; 77 	enk_b = GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) > 0;
4514  0bb3 4b10          	push	#16
4515  0bb5 ae500f        	ldw	x,#20495
4516  0bb8 cd0000        	call	_GPIO_ReadInputPin
4518  0bbb 5b01          	addw	sp,#1
4519  0bbd 4d            	tnz	a
4520  0bbe 2704          	jreq	L621
4521  0bc0 a601          	ld	a,#1
4522  0bc2 2001          	jra	L031
4523  0bc4               L621:
4524  0bc4 4f            	clr	a
4525  0bc5               L031:
4526  0bc5 b705          	ld	_enk_b,a
4527                     ; 78 	enk_b_prev = enk_b;
4529  0bc7 450504        	mov	_enk_b_prev,_enk_b
4530                     ; 79 	enk_btn = GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) > 0;
4532  0bca 4b80          	push	#128
4533  0bcc ae500f        	ldw	x,#20495
4534  0bcf cd0000        	call	_GPIO_ReadInputPin
4536  0bd2 5b01          	addw	sp,#1
4537  0bd4 4d            	tnz	a
4538  0bd5 2704          	jreq	L231
4539  0bd7 a601          	ld	a,#1
4540  0bd9 2001          	jra	L431
4541  0bdb               L231:
4542  0bdb 4f            	clr	a
4543  0bdc               L431:
4544  0bdc b703          	ld	_enk_btn,a
4545                     ; 80 	enk_btn_prev = enk_btn;
4547  0bde 450302        	mov	_enk_btn_prev,_enk_btn
4548  0be1               L1561:
4549                     ; 86 		enk_a = GPIO_ReadInputPin(GPIOD, GPIO_PIN_0) > 0;
4551  0be1 4b01          	push	#1
4552  0be3 ae500f        	ldw	x,#20495
4553  0be6 cd0000        	call	_GPIO_ReadInputPin
4555  0be9 5b01          	addw	sp,#1
4556  0beb 4d            	tnz	a
4557  0bec 2704          	jreq	L631
4558  0bee a601          	ld	a,#1
4559  0bf0 2001          	jra	L041
4560  0bf2               L631:
4561  0bf2 4f            	clr	a
4562  0bf3               L041:
4563  0bf3 b707          	ld	_enk_a,a
4564                     ; 87 		enk_btn = GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) > 0;
4566  0bf5 4b80          	push	#128
4567  0bf7 ae500f        	ldw	x,#20495
4568  0bfa cd0000        	call	_GPIO_ReadInputPin
4570  0bfd 5b01          	addw	sp,#1
4571  0bff 4d            	tnz	a
4572  0c00 2704          	jreq	L241
4573  0c02 a601          	ld	a,#1
4574  0c04 2001          	jra	L441
4575  0c06               L241:
4576  0c06 4f            	clr	a
4577  0c07               L441:
4578  0c07 b703          	ld	_enk_btn,a
4579                     ; 90 		lcdUpdateTime = 1000;
4581  0c09 ae03e8        	ldw	x,#1000
4582  0c0c bf00          	ldw	_lcdUpdateTime,x
4583                     ; 91 		if ((settingTime == TRUE) && (enk_btn == FALSE)) lcdUpdateTime = 40;
4585  0c0e b605          	ld	a,_settingTime
4586  0c10 a101          	cp	a,#1
4587  0c12 2609          	jrne	L5561
4589  0c14 3d03          	tnz	_enk_btn
4590  0c16 2605          	jrne	L5561
4593  0c18 ae0028        	ldw	x,#40
4594  0c1b bf00          	ldw	_lcdUpdateTime,x
4595  0c1d               L5561:
4596                     ; 93 		if ((lcdUpdate >= lcdUpdateTime) || (setTimeUpdateLCD == TRUE))
4598  0c1d be01          	ldw	x,_lcdUpdate
4599  0c1f b300          	cpw	x,_lcdUpdateTime
4600  0c21 2406          	jruge	L1661
4602  0c23 b60c          	ld	a,_setTimeUpdateLCD
4603  0c25 a101          	cp	a,#1
4604  0c27 264d          	jrne	L7561
4605  0c29               L1661:
4606                     ; 95 			setTimeUpdateLCD = FALSE; // Reset forced LCD update
4608  0c29 3f0c          	clr	_setTimeUpdateLCD
4609                     ; 96 			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Every LCD update blink LED, just for debugging
4611  0c2b 4b04          	push	#4
4612  0c2d ae5005        	ldw	x,#20485
4613  0c30 cd0000        	call	_GPIO_WriteReverse
4615  0c33 84            	pop	a
4616                     ; 98 			if (settingTime == FALSE) error |= DS3231_ReadAll(); // If setting time is not active then read DS3231 data
4618  0c34 3d05          	tnz	_settingTime
4619  0c36 2607          	jrne	L3661
4622  0c38 cd0464        	call	_DS3231_ReadAll
4624  0c3b ba10          	or	a,_error
4625  0c3d b710          	ld	_error,a
4626  0c3f               L3661:
4627                     ; 100 			DS3231_GetTimeFull(time); // Convert data from DS3231_Data variable to char arrays to put on LCD
4629  0c3f ae001a        	ldw	x,#_time
4630  0c42 cd0958        	call	_DS3231_GetTimeFull
4632                     ; 101 			DS3231_GetTemp(temp);
4634  0c45 ae0013        	ldw	x,#_temp
4635  0c48 cd09e7        	call	_DS3231_GetTemp
4637                     ; 102 			DS3231_GetDateFull(date);
4639  0c4b ae0008        	ldw	x,#_date
4640  0c4e cd0a6b        	call	_DS3231_GetDateFull
4642                     ; 105 			LCD_goto(0, 0);
4644  0c51 5f            	clrw	x
4645  0c52 cd0206        	call	_LCD_goto
4647                     ; 106 			LCD_putstr(time);
4649  0c55 ae001a        	ldw	x,#_time
4650  0c58 cd01d7        	call	_LCD_putstr
4652                     ; 108 			LCD_goto(10, 0);
4654  0c5b ae0a00        	ldw	x,#2560
4655  0c5e cd0206        	call	_LCD_goto
4657                     ; 109 			LCD_putstr(temp);
4659  0c61 ae0013        	ldw	x,#_temp
4660  0c64 cd01d7        	call	_LCD_putstr
4662                     ; 111 			LCD_goto(0, 1);
4664  0c67 ae0001        	ldw	x,#1
4665  0c6a cd0206        	call	_LCD_goto
4667                     ; 112 			LCD_putstr(date);
4669  0c6d ae0008        	ldw	x,#_date
4670  0c70 cd01d7        	call	_LCD_putstr
4672                     ; 114 			lcdUpdate = 0; // Reset LCD update interval
4674  0c73 5f            	clrw	x
4675  0c74 bf01          	ldw	_lcdUpdate,x
4676  0c76               L7561:
4677                     ; 119 		if (enk_a != enk_a_prev) {
4679  0c76 b607          	ld	a,_enk_a
4680  0c78 b106          	cp	a,_enk_a_prev
4681  0c7a 2713          	jreq	L5661
4682                     ; 120 			if (settingTime == FALSE) setTime++;
4684  0c7c 3d05          	tnz	_settingTime
4685  0c7e 2609          	jrne	L7661
4688  0c80 be03          	ldw	x,_setTime
4689  0c82 1c0001        	addw	x,#1
4690  0c85 bf03          	ldw	_setTime,x
4692  0c87 200d          	jra	L3761
4693  0c89               L7661:
4694                     ; 121 			else setTimeNext = TRUE;
4696  0c89 35010008      	mov	_setTimeNext,#1
4697  0c8d 2007          	jra	L3761
4698  0c8f               L5661:
4699                     ; 123 		else if (settingTime == FALSE) setTime = 0;
4701  0c8f 3d05          	tnz	_settingTime
4702  0c91 2603          	jrne	L3761
4705  0c93 5f            	clrw	x
4706  0c94 bf03          	ldw	_setTime,x
4707  0c96               L3761:
4708                     ; 127 		if (setTimeBlink >= 250)
4710  0c96 be09          	ldw	x,_setTimeBlink
4711  0c98 a300fa        	cpw	x,#250
4712  0c9b 2512          	jrult	L7761
4713                     ; 129 			setTimeBlinkB = !setTimeBlinkB;
4715  0c9d 3d0b          	tnz	_setTimeBlinkB
4716  0c9f 2604          	jrne	L641
4717  0ca1 a601          	ld	a,#1
4718  0ca3 2001          	jra	L051
4719  0ca5               L641:
4720  0ca5 4f            	clr	a
4721  0ca6               L051:
4722  0ca6 b70b          	ld	_setTimeBlinkB,a
4723                     ; 130 			setTimeBlink = 0; // Reset interval for blinking LCD character
4725  0ca8 5f            	clrw	x
4726  0ca9 bf09          	ldw	_setTimeBlink,x
4727                     ; 131 			setTimeUpdateLCD = TRUE; // Force LCD update
4729  0cab 3501000c      	mov	_setTimeUpdateLCD,#1
4730  0caf               L7761:
4731                     ; 136 		if ((setTime >= 2000) || (settingTime == TRUE))
4733  0caf be03          	ldw	x,_setTime
4734  0cb1 a307d0        	cpw	x,#2000
4735  0cb4 2409          	jruge	L3071
4737  0cb6 b605          	ld	a,_settingTime
4738  0cb8 a101          	cp	a,#1
4739  0cba 2703          	jreq	L651
4740  0cbc cc0f38        	jp	L1071
4741  0cbf               L651:
4742  0cbf               L3071:
4743                     ; 138 			enk_a_prev = enk_a; // Remember actual button state as previous
4745  0cbf 450706        	mov	_enk_a_prev,_enk_a
4746                     ; 139 			settingTime = TRUE; // Remember that setting time and date is active
4748  0cc2 35010005      	mov	_settingTime,#1
4749                     ; 140 			DS3231_Data.TimeDate.Seconds = 0; // I don't want to set actual seconds so reset it
4751  0cc6 3f23          	clr	L535_DS3231_Data
4752                     ; 143 			switch (setIndex)
4754  0cc8 b606          	ld	a,_setIndex
4756                     ; 323 					break;
4757  0cca 4d            	tnz	a
4758  0ccb 2724          	jreq	L1161
4759  0ccd 4a            	dec	a
4760  0cce 2603          	jrne	L061
4761  0cd0 cc0d5c        	jp	L3161
4762  0cd3               L061:
4763  0cd3 a009          	sub	a,#9
4764  0cd5 2603          	jrne	L261
4765  0cd7 cc0dc7        	jp	L5161
4766  0cda               L261:
4767  0cda 4a            	dec	a
4768  0cdb 2603          	jrne	L461
4769  0cdd cc0e30        	jp	L7161
4770  0ce0               L461:
4771  0ce0 4a            	dec	a
4772  0ce1 2603          	jrne	L661
4773  0ce3 cc0e99        	jp	L1261
4774  0ce6               L661:
4775  0ce6 a058          	sub	a,#88
4776  0ce8 2603          	jrne	L071
4777  0cea cc0f03        	jp	L3261
4778  0ced               L071:
4779  0ced ac380f38      	jpf	L1071
4780  0cf1               L1161:
4781                     ; 148 					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Hours; // Read previously set data from DS3231
4783  0cf1 b607          	ld	a,_setNewVal
4784  0cf3 a1ff          	cp	a,#255
4785  0cf5 2603          	jrne	L1171
4788  0cf7 452507        	mov	_setNewVal,L535_DS3231_Data+2
4789  0cfa               L1171:
4790                     ; 151 					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
4792  0cfa b603          	ld	a,_enk_btn
4793  0cfc a101          	cp	a,#1
4794  0cfe 2604          	jrne	L7171
4796  0d00 3d02          	tnz	_enk_btn_prev
4797  0d02 2706          	jreq	L5171
4798  0d04               L7171:
4800  0d04 b60d          	ld	a,_setTimeIncrement
4801  0d06 b10f          	cp	a,_incrementTime
4802  0d08 2527          	jrult	L3171
4803  0d0a               L5171:
4804                     ; 154 						if (setTimeBlinkB == FALSE)
4806  0d0a 3d0b          	tnz	_setTimeBlinkB
4807  0d0c 2609          	jrne	L1271
4808                     ; 156 							setTimeBlink = 0; // Reset blink timer
4810  0d0e 5f            	clrw	x
4811  0d0f bf09          	ldw	_setTimeBlink,x
4812                     ; 157 							setTimeBlinkB = FALSE; // Force LCD to show values
4814  0d11 3f0b          	clr	_setTimeBlinkB
4815                     ; 158 							setTimeUpdateLCD = TRUE; // Force LCD to update
4817  0d13 3501000c      	mov	_setTimeUpdateLCD,#1
4818  0d17               L1271:
4819                     ; 160 						setNewVal = (setNewVal + 1) % 24; // Increment new value for hours
4821  0d17 b607          	ld	a,_setNewVal
4822  0d19 5f            	clrw	x
4823  0d1a 97            	ld	xl,a
4824  0d1b 5c            	incw	x
4825  0d1c a618          	ld	a,#24
4826  0d1e cd0000        	call	c_smodx
4828  0d21 01            	rrwa	x,a
4829  0d22 b707          	ld	_setNewVal,a
4830  0d24 02            	rlwa	x,a
4831                     ; 161 						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
4833  0d25 b60d          	ld	a,_setTimeIncrement
4834  0d27 b10f          	cp	a,_incrementTime
4835  0d29 2504          	jrult	L3271
4838  0d2b 3501000e      	mov	_setTimeIncrementing,#1
4839  0d2f               L3271:
4840                     ; 162 						setTimeIncrement = 0; // Reset time for button holding incrementing
4842  0d2f 3f0d          	clr	_setTimeIncrement
4843  0d31               L3171:
4844                     ; 165 					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Hours = setNewVal; // Display new value
4846  0d31 3d0b          	tnz	_setTimeBlinkB
4847  0d33 2605          	jrne	L5271
4850  0d35 450725        	mov	L535_DS3231_Data+2,_setNewVal
4852  0d38 2004          	jra	L7271
4853  0d3a               L5271:
4854                     ; 166 					else DS3231_Data.TimeDate.Hours = 199; // Display blank space (handled in DS3231_GetTimeFull())
4856  0d3a 35c70025      	mov	L535_DS3231_Data+2,#199
4857  0d3e               L7271:
4858                     ; 169 					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
4860  0d3e b608          	ld	a,_setTimeNext
4861  0d40 a101          	cp	a,#1
4862  0d42 2703          	jreq	L271
4863  0d44 cc0f38        	jp	L1071
4864  0d47               L271:
4866  0d47 3d0b          	tnz	_setTimeBlinkB
4867  0d49 2703          	jreq	L471
4868  0d4b cc0f38        	jp	L1071
4869  0d4e               L471:
4870                     ; 171 						setTimeNext = FALSE; // Reset state machine traverse time
4872  0d4e 3f08          	clr	_setTimeNext
4873                     ; 172 						setNewVal = 255; // Reset new value
4875  0d50 35ff0007      	mov	_setNewVal,#255
4876                     ; 173 						setIndex = 1; // Traverse to next state
4878  0d54 35010006      	mov	_setIndex,#1
4879  0d58 ac380f38      	jpf	L1071
4880  0d5c               L3161:
4881                     ; 180 					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Minutes; // Read previously set data from DS3231
4883  0d5c b607          	ld	a,_setNewVal
4884  0d5e a1ff          	cp	a,#255
4885  0d60 2603          	jrne	L3371
4888  0d62 452407        	mov	_setNewVal,L535_DS3231_Data+1
4889  0d65               L3371:
4890                     ; 183 					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
4892  0d65 b603          	ld	a,_enk_btn
4893  0d67 a101          	cp	a,#1
4894  0d69 2604          	jrne	L1471
4896  0d6b 3d02          	tnz	_enk_btn_prev
4897  0d6d 2706          	jreq	L7371
4898  0d6f               L1471:
4900  0d6f b60d          	ld	a,_setTimeIncrement
4901  0d71 b10f          	cp	a,_incrementTime
4902  0d73 2527          	jrult	L5371
4903  0d75               L7371:
4904                     ; 186 						if (setTimeBlinkB == FALSE)
4906  0d75 3d0b          	tnz	_setTimeBlinkB
4907  0d77 2609          	jrne	L3471
4908                     ; 188 							setTimeBlink = 0; // Reset blink timer
4910  0d79 5f            	clrw	x
4911  0d7a bf09          	ldw	_setTimeBlink,x
4912                     ; 189 							setTimeBlinkB = FALSE; // Force LCD to show values
4914  0d7c 3f0b          	clr	_setTimeBlinkB
4915                     ; 190 							setTimeUpdateLCD = TRUE; // Force LCD to update
4917  0d7e 3501000c      	mov	_setTimeUpdateLCD,#1
4918  0d82               L3471:
4919                     ; 192 						setNewVal = (setNewVal + 1) % 60; // Increment new value for minutes
4921  0d82 b607          	ld	a,_setNewVal
4922  0d84 5f            	clrw	x
4923  0d85 97            	ld	xl,a
4924  0d86 5c            	incw	x
4925  0d87 a63c          	ld	a,#60
4926  0d89 cd0000        	call	c_smodx
4928  0d8c 01            	rrwa	x,a
4929  0d8d b707          	ld	_setNewVal,a
4930  0d8f 02            	rlwa	x,a
4931                     ; 193 						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
4933  0d90 b60d          	ld	a,_setTimeIncrement
4934  0d92 b10f          	cp	a,_incrementTime
4935  0d94 2504          	jrult	L5471
4938  0d96 3501000e      	mov	_setTimeIncrementing,#1
4939  0d9a               L5471:
4940                     ; 194 						setTimeIncrement = 0; // Reset time for button holding incrementing
4942  0d9a 3f0d          	clr	_setTimeIncrement
4943  0d9c               L5371:
4944                     ; 197 					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Minutes = setNewVal; // Display new value
4946  0d9c 3d0b          	tnz	_setTimeBlinkB
4947  0d9e 2605          	jrne	L7471
4950  0da0 450724        	mov	L535_DS3231_Data+1,_setNewVal
4952  0da3 2004          	jra	L1571
4953  0da5               L7471:
4954                     ; 198 					else DS3231_Data.TimeDate.Minutes = 199; // Display blank space (handled in DS3231_GetTimeFull())
4956  0da5 35c70024      	mov	L535_DS3231_Data+1,#199
4957  0da9               L1571:
4958                     ; 201 					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
4960  0da9 b608          	ld	a,_setTimeNext
4961  0dab a101          	cp	a,#1
4962  0dad 2703          	jreq	L671
4963  0daf cc0f38        	jp	L1071
4964  0db2               L671:
4966  0db2 3d0b          	tnz	_setTimeBlinkB
4967  0db4 2703          	jreq	L002
4968  0db6 cc0f38        	jp	L1071
4969  0db9               L002:
4970                     ; 203 						setTimeNext = FALSE; // Reset state machine traverse time
4972  0db9 3f08          	clr	_setTimeNext
4973                     ; 204 						setNewVal = 255; // Reset new value
4975  0dbb 35ff0007      	mov	_setNewVal,#255
4976                     ; 205 						setIndex = 10; // Traverse to next state
4978  0dbf 350a0006      	mov	_setIndex,#10
4979  0dc3 ac380f38      	jpf	L1071
4980  0dc7               L5161:
4981                     ; 212 					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Day; // Read previously set data from DS3231
4983  0dc7 b607          	ld	a,_setNewVal
4984  0dc9 a1ff          	cp	a,#255
4985  0dcb 2603          	jrne	L5571
4988  0dcd 452807        	mov	_setNewVal,L535_DS3231_Data+5
4989  0dd0               L5571:
4990                     ; 215 					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
4992  0dd0 b603          	ld	a,_enk_btn
4993  0dd2 a101          	cp	a,#1
4994  0dd4 2604          	jrne	L3671
4996  0dd6 3d02          	tnz	_enk_btn_prev
4997  0dd8 2706          	jreq	L1671
4998  0dda               L3671:
5000  0dda b60d          	ld	a,_setTimeIncrement
5001  0ddc b10f          	cp	a,_incrementTime
5002  0dde 2525          	jrult	L7571
5003  0de0               L1671:
5004                     ; 218 						if (setTimeBlinkB == FALSE)
5006  0de0 3d0b          	tnz	_setTimeBlinkB
5007  0de2 2609          	jrne	L5671
5008                     ; 220 							setTimeBlink = 0; // Reset blink timer
5010  0de4 5f            	clrw	x
5011  0de5 bf09          	ldw	_setTimeBlink,x
5012                     ; 221 							setTimeBlinkB = FALSE; // Force LCD to show values
5014  0de7 3f0b          	clr	_setTimeBlinkB
5015                     ; 222 							setTimeUpdateLCD = TRUE; // Force LCD to update
5017  0de9 3501000c      	mov	_setTimeUpdateLCD,#1
5018  0ded               L5671:
5019                     ; 224 						setNewVal++; // Increment new value for day
5021  0ded 3c07          	inc	_setNewVal
5022                     ; 225 						if (setNewVal >= 32) setNewVal = 1; // When passing 31 days reset days couting to 1
5024  0def b607          	ld	a,_setNewVal
5025  0df1 a120          	cp	a,#32
5026  0df3 2504          	jrult	L7671
5029  0df5 35010007      	mov	_setNewVal,#1
5030  0df9               L7671:
5031                     ; 226 						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
5033  0df9 b60d          	ld	a,_setTimeIncrement
5034  0dfb b10f          	cp	a,_incrementTime
5035  0dfd 2504          	jrult	L1771
5038  0dff 3501000e      	mov	_setTimeIncrementing,#1
5039  0e03               L1771:
5040                     ; 227 						setTimeIncrement = 0; // Reset time for button holding incrementing
5042  0e03 3f0d          	clr	_setTimeIncrement
5043  0e05               L7571:
5044                     ; 230 					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Day = setNewVal; // Display new value
5046  0e05 3d0b          	tnz	_setTimeBlinkB
5047  0e07 2605          	jrne	L3771
5050  0e09 450728        	mov	L535_DS3231_Data+5,_setNewVal
5052  0e0c 2004          	jra	L5771
5053  0e0e               L3771:
5054                     ; 231 					else DS3231_Data.TimeDate.Day = 199; // Display blank space (handled in DS3231_GetTimeFull())
5056  0e0e 35c70028      	mov	L535_DS3231_Data+5,#199
5057  0e12               L5771:
5058                     ; 234 					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
5060  0e12 b608          	ld	a,_setTimeNext
5061  0e14 a101          	cp	a,#1
5062  0e16 2703          	jreq	L202
5063  0e18 cc0f38        	jp	L1071
5064  0e1b               L202:
5066  0e1b 3d0b          	tnz	_setTimeBlinkB
5067  0e1d 2703          	jreq	L402
5068  0e1f cc0f38        	jp	L1071
5069  0e22               L402:
5070                     ; 236 						setTimeNext = FALSE; // Reset state machine traverse time
5072  0e22 3f08          	clr	_setTimeNext
5073                     ; 237 						setNewVal = 255; // Reset new value
5075  0e24 35ff0007      	mov	_setNewVal,#255
5076                     ; 238 						setIndex = 11; // Traverse to next state
5078  0e28 350b0006      	mov	_setIndex,#11
5079  0e2c ac380f38      	jpf	L1071
5080  0e30               L7161:
5081                     ; 245 					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Month; // Read previously set data from DS3231
5083  0e30 b607          	ld	a,_setNewVal
5084  0e32 a1ff          	cp	a,#255
5085  0e34 2603          	jrne	L1002
5088  0e36 452907        	mov	_setNewVal,L535_DS3231_Data+6
5089  0e39               L1002:
5090                     ; 248 					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
5092  0e39 b603          	ld	a,_enk_btn
5093  0e3b a101          	cp	a,#1
5094  0e3d 2604          	jrne	L7002
5096  0e3f 3d02          	tnz	_enk_btn_prev
5097  0e41 2706          	jreq	L5002
5098  0e43               L7002:
5100  0e43 b60d          	ld	a,_setTimeIncrement
5101  0e45 b10f          	cp	a,_incrementTime
5102  0e47 2525          	jrult	L3002
5103  0e49               L5002:
5104                     ; 251 						if (setTimeBlinkB == FALSE)
5106  0e49 3d0b          	tnz	_setTimeBlinkB
5107  0e4b 2609          	jrne	L1102
5108                     ; 253 							setTimeBlink = 0; // Reset blink timer
5110  0e4d 5f            	clrw	x
5111  0e4e bf09          	ldw	_setTimeBlink,x
5112                     ; 254 							setTimeBlinkB = FALSE; // Force LCD to show values
5114  0e50 3f0b          	clr	_setTimeBlinkB
5115                     ; 255 							setTimeUpdateLCD = TRUE; // Force LCD to update
5117  0e52 3501000c      	mov	_setTimeUpdateLCD,#1
5118  0e56               L1102:
5119                     ; 257 						setNewVal++; // Increment new value for month
5121  0e56 3c07          	inc	_setNewVal
5122                     ; 258 						if (setNewVal >= 13) setNewVal = 1; // If passed 12 months reset months counting to 1
5124  0e58 b607          	ld	a,_setNewVal
5125  0e5a a10d          	cp	a,#13
5126  0e5c 2504          	jrult	L3102
5129  0e5e 35010007      	mov	_setNewVal,#1
5130  0e62               L3102:
5131                     ; 259 						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
5133  0e62 b60d          	ld	a,_setTimeIncrement
5134  0e64 b10f          	cp	a,_incrementTime
5135  0e66 2504          	jrult	L5102
5138  0e68 3501000e      	mov	_setTimeIncrementing,#1
5139  0e6c               L5102:
5140                     ; 260 						setTimeIncrement = 0; // Reset time for button holding incrementing
5142  0e6c 3f0d          	clr	_setTimeIncrement
5143  0e6e               L3002:
5144                     ; 263 					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Month = setNewVal; // Display new value
5146  0e6e 3d0b          	tnz	_setTimeBlinkB
5147  0e70 2605          	jrne	L7102
5150  0e72 450729        	mov	L535_DS3231_Data+6,_setNewVal
5152  0e75 2004          	jra	L1202
5153  0e77               L7102:
5154                     ; 264 					else DS3231_Data.TimeDate.Month = 199; // Display blank space (handled in DS3231_GetTimeFull())
5156  0e77 35c70029      	mov	L535_DS3231_Data+6,#199
5157  0e7b               L1202:
5158                     ; 267 					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
5160  0e7b b608          	ld	a,_setTimeNext
5161  0e7d a101          	cp	a,#1
5162  0e7f 2703          	jreq	L602
5163  0e81 cc0f38        	jp	L1071
5164  0e84               L602:
5166  0e84 3d0b          	tnz	_setTimeBlinkB
5167  0e86 2703          	jreq	L012
5168  0e88 cc0f38        	jp	L1071
5169  0e8b               L012:
5170                     ; 269 						setTimeNext = FALSE; // Reset state machine traverse time
5172  0e8b 3f08          	clr	_setTimeNext
5173                     ; 270 						setNewVal = 255; // Reset new value
5175  0e8d 35ff0007      	mov	_setNewVal,#255
5176                     ; 271 						setIndex = 12; // Traverse to next state
5178  0e91 350c0006      	mov	_setIndex,#12
5179  0e95 ac380f38      	jpf	L1071
5180  0e99               L1261:
5181                     ; 278 					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Year; // Read previously set data from DS3231
5183  0e99 b607          	ld	a,_setNewVal
5184  0e9b a1ff          	cp	a,#255
5185  0e9d 2603          	jrne	L5202
5188  0e9f 452a07        	mov	_setNewVal,L535_DS3231_Data+7
5189  0ea2               L5202:
5190                     ; 281 					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
5192  0ea2 b603          	ld	a,_enk_btn
5193  0ea4 a101          	cp	a,#1
5194  0ea6 2604          	jrne	L3302
5196  0ea8 3d02          	tnz	_enk_btn_prev
5197  0eaa 2706          	jreq	L1302
5198  0eac               L3302:
5200  0eac b60d          	ld	a,_setTimeIncrement
5201  0eae b10f          	cp	a,_incrementTime
5202  0eb0 252e          	jrult	L7202
5203  0eb2               L1302:
5204                     ; 284 						if (setTimeBlinkB == FALSE)
5206  0eb2 3d0b          	tnz	_setTimeBlinkB
5207  0eb4 2609          	jrne	L5302
5208                     ; 286 							setTimeBlink = 0; // Reset blink timer
5210  0eb6 5f            	clrw	x
5211  0eb7 bf09          	ldw	_setTimeBlink,x
5212                     ; 287 							setTimeBlinkB = FALSE; // Force LCD to show values
5214  0eb9 3f0b          	clr	_setTimeBlinkB
5215                     ; 288 							setTimeUpdateLCD = TRUE; // Force LCD to update
5217  0ebb 3501000c      	mov	_setTimeUpdateLCD,#1
5218  0ebf               L5302:
5219                     ; 290 						setNewVal++; // Increment new value for year
5221  0ebf 3c07          	inc	_setNewVal
5222                     ; 291 						if (setNewVal >= 100)
5224  0ec1 b607          	ld	a,_setNewVal
5225  0ec3 a164          	cp	a,#100
5226  0ec5 250d          	jrult	L7302
5227                     ; 293 							DS3231_Data.TimeDate.Century = !DS3231_Data.TimeDate.Century; // If passed 100 years change state of century bit
5229  0ec7 3d2b          	tnz	L535_DS3231_Data+8
5230  0ec9 2604          	jrne	L251
5231  0ecb a601          	ld	a,#1
5232  0ecd 2001          	jra	L451
5233  0ecf               L251:
5234  0ecf 4f            	clr	a
5235  0ed0               L451:
5236  0ed0 b72b          	ld	L535_DS3231_Data+8,a
5237                     ; 294 							setNewVal = 0; // If passed 100 years reset years counting
5239  0ed2 3f07          	clr	_setNewVal
5240  0ed4               L7302:
5241                     ; 296 						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
5243  0ed4 b60d          	ld	a,_setTimeIncrement
5244  0ed6 b10f          	cp	a,_incrementTime
5245  0ed8 2504          	jrult	L1402
5248  0eda 3501000e      	mov	_setTimeIncrementing,#1
5249  0ede               L1402:
5250                     ; 297 						setTimeIncrement = 0; // Reset time for button holding incrementing
5252  0ede 3f0d          	clr	_setTimeIncrement
5253  0ee0               L7202:
5254                     ; 300 					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Year = setNewVal; // Display new value
5256  0ee0 3d0b          	tnz	_setTimeBlinkB
5257  0ee2 2605          	jrne	L3402
5260  0ee4 45072a        	mov	L535_DS3231_Data+7,_setNewVal
5262  0ee7 2004          	jra	L5402
5263  0ee9               L3402:
5264                     ; 301 					else DS3231_Data.TimeDate.Year = 199; // Display blank space (handled in DS3231_GetTimeFull())
5266  0ee9 35c7002a      	mov	L535_DS3231_Data+7,#199
5267  0eed               L5402:
5268                     ; 304 					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
5270  0eed b608          	ld	a,_setTimeNext
5271  0eef a101          	cp	a,#1
5272  0ef1 2645          	jrne	L1071
5274  0ef3 3d0b          	tnz	_setTimeBlinkB
5275  0ef5 2641          	jrne	L1071
5276                     ; 306 						setTimeNext = FALSE; // Reset state machine traverse time
5278  0ef7 3f08          	clr	_setTimeNext
5279                     ; 307 						setNewVal = 255; // Reset new value
5281  0ef9 35ff0007      	mov	_setNewVal,#255
5282                     ; 308 						setIndex = 100; // Traverse to next state
5284  0efd 35640006      	mov	_setIndex,#100
5285  0f01 2035          	jra	L1071
5286  0f03               L3261:
5287                     ; 316 					error |= DS3231_SetTime(DS3231_Data.TimeDate.Hours, DS3231_Data.TimeDate.Minutes, 0);
5289  0f03 4b00          	push	#0
5290  0f05 b624          	ld	a,L535_DS3231_Data+1
5291  0f07 97            	ld	xl,a
5292  0f08 b625          	ld	a,L535_DS3231_Data+2
5293  0f0a 95            	ld	xh,a
5294  0f0b cd06ae        	call	_DS3231_SetTime
5296  0f0e 5b01          	addw	sp,#1
5297  0f10 ba10          	or	a,_error
5298  0f12 b710          	ld	_error,a
5299                     ; 317 					delay_us(10);
5301  0f14 ae000a        	ldw	x,#10
5302  0f17 cd0000        	call	_delay_us
5304                     ; 318 					error |= DS3231_SetDate(DS3231_Data.TimeDate.Day, DS3231_Data.TimeDate.Month, DS3231_Data.TimeDate.Year, DS3231_Data.TimeDate.Century);
5306  0f1a 3b002b        	push	L535_DS3231_Data+8
5307  0f1d 3b002a        	push	L535_DS3231_Data+7
5308  0f20 b629          	ld	a,L535_DS3231_Data+6
5309  0f22 97            	ld	xl,a
5310  0f23 b628          	ld	a,L535_DS3231_Data+5
5311  0f25 95            	ld	xh,a
5312  0f26 cd07fe        	call	_DS3231_SetDate
5314  0f29 85            	popw	x
5315  0f2a ba10          	or	a,_error
5316  0f2c b710          	ld	_error,a
5317                     ; 319 					delay_us(10);
5319  0f2e ae000a        	ldw	x,#10
5320  0f31 cd0000        	call	_delay_us
5322                     ; 321 					setIndex = 0; // Reset state machine
5324  0f34 3f06          	clr	_setIndex
5325                     ; 322 					settingTime = FALSE; // Reset remembered setting time variable
5327  0f36 3f05          	clr	_settingTime
5328                     ; 323 					break;
5330  0f38               L7071:
5331  0f38               L1071:
5332                     ; 330 		if (error == TRUE) GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
5334  0f38 b610          	ld	a,_error
5335  0f3a a101          	cp	a,#1
5336  0f3c 260b          	jrne	L1502
5339  0f3e 4b08          	push	#8
5340  0f40 ae500f        	ldw	x,#20495
5341  0f43 cd0000        	call	_GPIO_WriteHigh
5343  0f46 84            	pop	a
5345  0f47 2009          	jra	L3502
5346  0f49               L1502:
5347                     ; 331 		else GPIO_WriteLow(GPIOD, GPIO_PIN_3);
5349  0f49 4b08          	push	#8
5350  0f4b ae500f        	ldw	x,#20495
5351  0f4e cd0000        	call	_GPIO_WriteLow
5353  0f51 84            	pop	a
5354  0f52               L3502:
5355                     ; 332 		if (enk_btn == FALSE) error = FALSE; // Reset error state when button was pressed
5357  0f52 3d03          	tnz	_enk_btn
5358  0f54 2602          	jrne	L5502
5361  0f56 3f10          	clr	_error
5362  0f58               L5502:
5363                     ; 335 		enk_btn_prev = enk_btn; // Remember actual button state as previous
5365  0f58 450302        	mov	_enk_btn_prev,_enk_btn
5366                     ; 338 		if (settingTime == TRUE)
5368  0f5b b605          	ld	a,_settingTime
5369  0f5d a101          	cp	a,#1
5370  0f5f 2625          	jrne	L7502
5371                     ; 340 			if (enk_btn == TRUE)
5373  0f61 b603          	ld	a,_enk_btn
5374  0f63 a101          	cp	a,#1
5375  0f65 2609          	jrne	L1602
5376                     ; 343 				setTimeBlink++; // Increment LCD character blinking
5378  0f67 be09          	ldw	x,_setTimeBlink
5379  0f69 1c0001        	addw	x,#1
5380  0f6c bf09          	ldw	_setTimeBlink,x
5381                     ; 344 				setTimeIncrementing = FALSE; // Reset flag for incrementing values while holding the button
5383  0f6e 3f0e          	clr	_setTimeIncrementing
5384  0f70               L1602:
5385                     ; 346 			if (enk_btn == FALSE)
5387  0f70 3d03          	tnz	_enk_btn
5388  0f72 2610          	jrne	L3602
5389                     ; 349 				if (setTimeIncrementing == TRUE) enk_btn_prev = TRUE; // While incrementing by button holding is active force previus button state
5391  0f74 b60e          	ld	a,_setTimeIncrementing
5392  0f76 a101          	cp	a,#1
5393  0f78 2604          	jrne	L5602
5396  0f7a 35010002      	mov	_enk_btn_prev,#1
5397  0f7e               L5602:
5398                     ; 351 				setTimeBlinkB = FALSE; // Force new value display on LCD
5400  0f7e 3f0b          	clr	_setTimeBlinkB
5401                     ; 352 				setTimeIncrement++; // Update button holding incrementing time
5403  0f80 3c0d          	inc	_setTimeIncrement
5405  0f82 2002          	jra	L7502
5406  0f84               L3602:
5407                     ; 354 			else setTimeIncrement = 0; // Reset button holding incrementing time
5409  0f84 3f0d          	clr	_setTimeIncrement
5410  0f86               L7502:
5411                     ; 356 		lcdUpdate++; // Update LCD update time
5413  0f86 be01          	ldw	x,_lcdUpdate
5414  0f88 1c0001        	addw	x,#1
5415  0f8b bf01          	ldw	_lcdUpdate,x
5416                     ; 357 		delay_ms(1); // Delay whole loop - every cycle will take ~1 ms
5418  0f8d ae0001        	ldw	x,#1
5419  0f90 cd0025        	call	_delay_ms
5422  0f93 ace10be1      	jpf	L1561
5447                     ; 361 void GPIO_setup(void)
5447                     ; 362 {
5448                     	switch	.text
5449  0f97               _GPIO_setup:
5453                     ; 363 	GPIO_DeInit(GPIOB);
5455  0f97 ae5005        	ldw	x,#20485
5456  0f9a cd0000        	call	_GPIO_DeInit
5458                     ; 364   GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // HEATING LED
5460  0f9d 4be0          	push	#224
5461  0f9f 4b04          	push	#4
5462  0fa1 ae5005        	ldw	x,#20485
5463  0fa4 cd0000        	call	_GPIO_Init
5465  0fa7 85            	popw	x
5466                     ; 365 	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_OUT_OD_HIZ_FAST); // I2C_SCL (Open Drain)
5468  0fa8 4bb0          	push	#176
5469  0faa 4b10          	push	#16
5470  0fac ae5005        	ldw	x,#20485
5471  0faf cd0000        	call	_GPIO_Init
5473  0fb2 85            	popw	x
5474                     ; 366 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_OD_HIZ_FAST); // I2C_SDA (Open Drain)
5476  0fb3 4bb0          	push	#176
5477  0fb5 4b20          	push	#32
5478  0fb7 ae5005        	ldw	x,#20485
5479  0fba cd0000        	call	_GPIO_Init
5481  0fbd 85            	popw	x
5482                     ; 368 	GPIO_DeInit(GPIOD);
5484  0fbe ae500f        	ldw	x,#20495
5485  0fc1 cd0000        	call	_GPIO_DeInit
5487                     ; 369 	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // TRIGGER LED
5489  0fc4 4be0          	push	#224
5490  0fc6 4b08          	push	#8
5491  0fc8 ae500f        	ldw	x,#20495
5492  0fcb cd0000        	call	_GPIO_Init
5494  0fce 85            	popw	x
5495                     ; 370 	GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_IN_FL_NO_IT); // ENK_A
5497  0fcf 4b00          	push	#0
5498  0fd1 4b01          	push	#1
5499  0fd3 ae500f        	ldw	x,#20495
5500  0fd6 cd0000        	call	_GPIO_Init
5502  0fd9 85            	popw	x
5503                     ; 371 	GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); // ENK_B
5505  0fda 4b00          	push	#0
5506  0fdc 4b10          	push	#16
5507  0fde ae500f        	ldw	x,#20495
5508  0fe1 cd0000        	call	_GPIO_Init
5510  0fe4 85            	popw	x
5511                     ; 372 	GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); // ENK_BTN
5513  0fe5 4b00          	push	#0
5514  0fe7 4b80          	push	#128
5515  0fe9 ae500f        	ldw	x,#20495
5516  0fec cd0000        	call	_GPIO_Init
5518  0fef 85            	popw	x
5519                     ; 373 }
5522  0ff0 81            	ret
5555                     ; 375 void CLOCK_setup(void)
5555                     ; 376 {
5556                     	switch	.text
5557  0ff1               _CLOCK_setup:
5561                     ; 377 	CLK_DeInit();
5563  0ff1 cd0000        	call	_CLK_DeInit
5565                     ; 378   CLK_HSECmd(DISABLE);
5567  0ff4 4f            	clr	a
5568  0ff5 cd0000        	call	_CLK_HSECmd
5570                     ; 379   CLK_LSICmd(DISABLE);
5572  0ff8 4f            	clr	a
5573  0ff9 cd0000        	call	_CLK_LSICmd
5575                     ; 380   CLK_HSICmd(ENABLE); // Enable High Speed Internal clock
5577  0ffc a601          	ld	a,#1
5578  0ffe cd0000        	call	_CLK_HSICmd
5581  1001               L3112:
5582                     ; 381   while (CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
5584  1001 ae0102        	ldw	x,#258
5585  1004 cd0000        	call	_CLK_GetFlagStatus
5587  1007 4d            	tnz	a
5588  1008 27f7          	jreq	L3112
5589                     ; 383 	CLK_ClockSwitchCmd(ENABLE);
5591  100a a601          	ld	a,#1
5592  100c cd0000        	call	_CLK_ClockSwitchCmd
5594                     ; 384   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // Prescaler = 1 -> 16 MHz clock
5596  100f 4f            	clr	a
5597  1010 cd0000        	call	_CLK_HSIPrescalerConfig
5599                     ; 385   CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
5601  1013 a680          	ld	a,#128
5602  1015 cd0000        	call	_CLK_SYSCLKConfig
5604                     ; 387 	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
5606  1018 4b01          	push	#1
5607  101a 4b00          	push	#0
5608  101c ae01e1        	ldw	x,#481
5609  101f cd0000        	call	_CLK_ClockSwitchConfig
5611  1022 85            	popw	x
5612                     ; 389 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE); // Enable I2C peripheral
5614  1023 ae0001        	ldw	x,#1
5615  1026 cd0000        	call	_CLK_PeripheralClockConfig
5617                     ; 390   CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
5619  1029 ae0100        	ldw	x,#256
5620  102c cd0000        	call	_CLK_PeripheralClockConfig
5622                     ; 391   CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
5624  102f ae0300        	ldw	x,#768
5625  1032 cd0000        	call	_CLK_PeripheralClockConfig
5627                     ; 392   CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
5629  1035 ae1200        	ldw	x,#4608
5630  1038 cd0000        	call	_CLK_PeripheralClockConfig
5632                     ; 393   CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE);
5634  103b ae1300        	ldw	x,#4864
5635  103e cd0000        	call	_CLK_PeripheralClockConfig
5637                     ; 394   CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
5639  1041 ae0701        	ldw	x,#1793
5640  1044 cd0000        	call	_CLK_PeripheralClockConfig
5642                     ; 395   CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
5644  1047 ae0500        	ldw	x,#1280
5645  104a cd0000        	call	_CLK_PeripheralClockConfig
5647                     ; 396   CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
5649  104d ae0400        	ldw	x,#1024
5650  1050 cd0000        	call	_CLK_PeripheralClockConfig
5652                     ; 397 }
5655  1053 81            	ret
5682                     	switch	.const
5683  002a               L022:
5684  002a 000f4240      	dc.l	1000000
5685                     ; 399 void I2C_setup(void)
5685                     ; 400 {
5686                     	switch	.text
5687  1054               _I2C_setup:
5691                     ; 401 	I2C_DeInit(); // Deinitialize I2C peripheral
5693  1054 cd0000        	call	_I2C_DeInit
5695                     ; 403 	I2C_Init((uint32_t)400000,	// Transmission frequency in Hz - 100 kHz
5695                     ; 404 					(uint16_t)0x0A,// My address - 0x0A = 10
5695                     ; 405 					I2C_DUTYCYCLE_2, // Transmission duty cycle
5695                     ; 406 					I2C_ACK_CURR, // ACK type
5695                     ; 407 					I2C_ADDMODE_7BIT, // 7 bit address
5695                     ; 408 					(uint8_t)(CLK_GetClockFreq() / 1000000)); // Frequency of peripheral clock in MHz
5697  1057 cd0000        	call	_CLK_GetClockFreq
5699  105a ae002a        	ldw	x,#L022
5700  105d cd0000        	call	c_ludv
5702  1060 b603          	ld	a,c_lreg+3
5703  1062 88            	push	a
5704  1063 4b00          	push	#0
5705  1065 4b01          	push	#1
5706  1067 4b00          	push	#0
5707  1069 ae000a        	ldw	x,#10
5708  106c 89            	pushw	x
5709  106d ae1a80        	ldw	x,#6784
5710  1070 89            	pushw	x
5711  1071 ae0006        	ldw	x,#6
5712  1074 89            	pushw	x
5713  1075 cd0000        	call	_I2C_Init
5715  1078 5b0a          	addw	sp,#10
5716                     ; 410 	I2C_Cmd(ENABLE); // Turn on I2C peripheral
5718  107a a601          	ld	a,#1
5719  107c cd0000        	call	_I2C_Cmd
5721                     ; 411 }
5724  107f 81            	ret
5991                     	xdef	_main
5992                     	xdef	_error
5993                     	xdef	_incrementTime
5994                     	xdef	_setTimeIncrementing
5995                     	xdef	_setTimeIncrement
5996                     	xdef	_setTimeUpdateLCD
5997                     	xdef	_setTimeBlinkB
5998                     	xdef	_setTimeBlink
5999                     	xdef	_setTimeNext
6000                     	xdef	_setNewVal
6001                     	xdef	_setIndex
6002                     	xdef	_settingTime
6003                     	xdef	_setTime
6004                     	switch	.ubsct
6005  0000               _lcdUpdateTime:
6006  0000 0000          	ds.b	2
6007                     	xdef	_lcdUpdateTime
6008                     	xdef	_lcdUpdate
6009  0002               _enk_btn_prev:
6010  0002 00            	ds.b	1
6011                     	xdef	_enk_btn_prev
6012  0003               _enk_btn:
6013  0003 00            	ds.b	1
6014                     	xdef	_enk_btn
6015  0004               _enk_b_prev:
6016  0004 00            	ds.b	1
6017                     	xdef	_enk_b_prev
6018  0005               _enk_b:
6019  0005 00            	ds.b	1
6020                     	xdef	_enk_b
6021  0006               _enk_a_prev:
6022  0006 00            	ds.b	1
6023                     	xdef	_enk_a_prev
6024  0007               _enk_a:
6025  0007 00            	ds.b	1
6026                     	xdef	_enk_a
6027  0008               _date:
6028  0008 000000000000  	ds.b	11
6029                     	xdef	_date
6030  0013               _temp:
6031  0013 000000000000  	ds.b	7
6032                     	xdef	_temp
6033  001a               _time:
6034  001a 000000000000  	ds.b	9
6035                     	xdef	_time
6036                     	xdef	_i
6037                     	xdef	_I2C_setup
6038                     	xdef	_CLOCK_setup
6039                     	xdef	_GPIO_setup
6040                     	xdef	_bcd2dec
6041                     	xdef	_dec2bcd
6042                     	xdef	_DS3231_GetDateFull
6043                     	xdef	_DS3231_GetTemp
6044                     	xdef	_DS3231_GetTimeFull
6045                     	xdef	_DS3231_SetDate
6046                     	xdef	_DS3231_SetTime
6047                     	xdef	_DS3231_ReadAll
6048                     	xdef	_DS3231_Init
6049  0023               L535_DS3231_Data:
6050  0023 000000000000  	ds.b	21
6051                     	xdef	_uint_to_string
6052                     	xdef	_toggle_io
6053                     	xdef	_toggle_EN_pin
6054                     	xdef	_LCD_goto
6055                     	xdef	_LCD_clear_home
6056                     	xdef	_LCD_putint8
6057                     	xdef	_LCD_putchar
6058                     	xdef	_LCD_putstr
6059                     	xdef	_LCD_4bit_send
6060                     	xdef	_LCD_send
6061                     	xdef	_LCD_init
6062                     	xdef	_LCD_GPIO_init
6063                     	xdef	_uint8_to_string
6064                     	xdef	_delay_ms
6065                     	xdef	_delay_us
6066                     	xref	_I2C_GetFlagStatus
6067                     	xref	_I2C_CheckEvent
6068                     	xref	_I2C_SendData
6069                     	xref	_I2C_Send7bitAddress
6070                     	xref	_I2C_ReceiveData
6071                     	xref	_I2C_AcknowledgeConfig
6072                     	xref	_I2C_GenerateSTOP
6073                     	xref	_I2C_GenerateSTART
6074                     	xref	_I2C_Cmd
6075                     	xref	_I2C_Init
6076                     	xref	_I2C_DeInit
6077                     	xref	_GPIO_ReadInputPin
6078                     	xref	_GPIO_WriteReverse
6079                     	xref	_GPIO_WriteLow
6080                     	xref	_GPIO_WriteHigh
6081                     	xref	_GPIO_Init
6082                     	xref	_GPIO_DeInit
6083                     	xref	_CLK_GetFlagStatus
6084                     	xref	_CLK_GetClockFreq
6085                     	xref	_CLK_SYSCLKConfig
6086                     	xref	_CLK_HSIPrescalerConfig
6087                     	xref	_CLK_ClockSwitchConfig
6088                     	xref	_CLK_PeripheralClockConfig
6089                     	xref	_CLK_ClockSwitchCmd
6090                     	xref	_CLK_LSICmd
6091                     	xref	_CLK_HSICmd
6092                     	xref	_CLK_HSECmd
6093                     	xref	_CLK_DeInit
6094                     	switch	.const
6095  002e               L74:
6096  002e 3f9645a1      	dc.w	16278,17825
6097  0032               L73:
6098  0032 3f800000      	dc.w	16256,0
6099                     	xref.b	c_lreg
6100                     	xref.b	c_x
6101                     	xref.b	c_y
6121                     	xref	c_ludv
6122                     	xref	c_smodx
6123                     	xref	c_idiv
6124                     	xref	c_lcmp
6125                     	xref	c_uitolx
6126                     	xref	c_ftoi
6127                     	xref	c_fmul
6128                     	xref	c_uitof
6129                     	end
