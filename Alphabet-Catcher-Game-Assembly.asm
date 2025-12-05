[org 0x100]
jmp start

line2: db 'SCORE: ', 0
starterString: db'Start'
endStirng: db 'Game Over'
PressMorS:db'Press S for SinglePlayer and M for MultiPlayer '
line3: db 'MISSED: ', 0
ScoreStr:db'SCORE '
MissedStr:db'MISSED '
len1 :dw 5
len2: dw 9
len3:dw 47
len4:dw 6
len5: dw 7
rand: dw 0
randnum: dw 0
char1_offset: dw 0
char2_offset: dw 0
char3_offset: dw 0
char4_offset: dw 0
char5_offset: dw 0

character1: dw '0'
character2: dw '0'
character3: dw '0'
character4: dw '0'
character5: dw '0'

char1time:dw 0
char2time:dw 0
char3time:dw 0
char4time:dw 0
char5time:dw 0


position1:dw 24
position2:dw 24
position3:dw 24
position4:dw 24
position5:dw 24


oldkbisr: dw 0
oldtimer: dw 0

boxP: dw 3920
boxP2: dw 3910
flag1: dw 0
flag2: dw 0
flag3: dw 0
flag4: dw 0
flag5: dw 0
score_count: dw 0
missed_alphabets: dw 0
bool_first: dw 0
bool_second:dw 0
bool_third: dw 0
bool_fourth: dw 0
bool_fifth:dw 0
; taking n as parameter, generate random number from 0 to n nad return in the stack

bool_loose: dw 0
bool_win: dw 0
bool_esc: dw 0

bool_shift: dw 0
bool_multiplayer: dw 0
clrscr:
push bp
mov bp,sp
push es
push ax
push di
push cx

mov ax,0xb800
mov es,ax
mov ax,0x0720
xor di,di
mov cx,4000

rep stosw

pop cx
pop di
pop ax
pop es
pop bp
ret

;KBISR
kbisr:
push ax



in al, 0x60

cmp al, 0x01
je endgameEsc


CheckRightShift:
cmp byte al,0x36
jne CheckLeftShift
mov word[bool_shift],1
jmp endKB

CheckLeftShift:
cmp al,0x2A
jne RightRelease
mov word[bool_shift],1
jmp endKB

RightRelease:
cmp al, 0xB6
jne LeftRelease
mov word [bool_shift], 0
jmp endKB

LeftRelease:
cmp al, 0xAA
jne NoShift
mov word [bool_shift], 0
jmp endKB


NoShift:
cmp byte al, 0x4b
jz moveBoxLeft
cmp byte al, 0x4d
jz moveBoxRight
jmp exitKB

moveBoxLeft:
mov di,[boxP]
mov ax,0xb800
mov es,ax
mov word[es:di],0x720
mov word[es:3838],0x720

cmp word di,3840
jz rightMost

cmp word di,3838
jz rightMost   
sub di,2
cmp word[bool_shift],1
jne skipDoubleL
sub di,2
skipDoubleL:

mov word[boxP],di
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB

rightMost:
mov word[boxP],3998
mov word di, 3998
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB


moveBoxRight:
mov di,[boxP]
mov ax,0xb800
mov es,ax
mov word[es:di],0x720


cmp word di,3998
jz leftMost
cmp word di,4000
jz leftMost
add di,2
cmp word[bool_shift],1
jne skipDoubleR
add di,2
skipDoubleR:

mov word[boxP],di
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB

leftMost:
mov word[boxP],3840
mov word di, 3840
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB
endgameEsc:
inc word[bool_esc]


endKB:

 

exitKB:

mov al, 0x20
out 0x20, al
pop ax
;jmp far[cs:oldkbisr]
iret



; 

Multiplayer_KBISR:
push ax



in al, 0x60

cmp al, 0x01
je endgameEsc_multi


CheckRightShift1:
cmp byte al,0x36
jne CheckLeftShift1
mov word[bool_shift],1
jmp exitKB_multi

CheckLeftShift1:
cmp al,0x2A
jne RightRelease1
mov word[bool_shift],1
jmp exitKB_multi

RightRelease1:
cmp al, 0xB6
jne LeftRelease1
mov word [bool_shift], 0
jmp exitKB_multi

LeftRelease1:
cmp al, 0xAA
jne NoShift1
mov word [bool_shift], 0
jmp exitKB_multi


 NoShift1:
cmp byte al, 0x4b
jz moveBoxLeft1
cmp byte al, 0x4d
jz moveBoxRight1
cmp byte al,0x1E
jz moveBoxLeft2
cmp byte al,0x20
jz moveBoxRight2
jmp exitKB_multi

;_
moveBoxLeft1:
mov di,[boxP]
mov ax,0xb800
mov es,ax
mov word[es:di],0x720

cmp word di,3838
jz rightMost_1
cmp word di,3840
jz rightMost_1

sub di,2
cmp word[bool_shift],1
jne skipDoubleL1
sub di,2
skipDoubleL1:
; cmp word[bool_shift],1
; jne skipDoubleL
; sub di,2
;skipDoubleL:

mov word[boxP],di
mov ah, 07
mov al, 0xDC
mov [es:di], ax


jmp endKB_multi

rightMost_1:
mov word[boxP],3998
mov word di, 3998
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB_multi



;----------------------

moveBoxRight1:
mov di,[boxP]
mov ax,0xb800
mov es,ax
mov word[es:di],0x720


cmp word di,3998
jz leftMost_1
cmp word di,4000
jz leftMost_1
add di,2
cmp word[bool_shift],1
jne skipDoubleR1
add di,2
skipDoubleR1:
; cmp word[bool_shift],1
; jne skipDoubleL
; sub di,2
;skipDoubleL:

mov word[boxP],di
mov ah, 07
mov al, 0xDC
mov [es:di], ax


jmp endKB_multi

leftMost_1:
mov word[boxP],3840
mov word di, 3840
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB_multi


;-------------------------------------------------------




; moveBoxRight1:
; mov di,[boxP]
; mov ax,0xb800
; mov es,ax
; mov word[es:di],0x720


; cmp word di,3998
; jz leftMost_1
; mov word[boxP],di
; mov ah, 07
; mov al, 0xDC
; mov [es:di], ax
; jmp endKB_multi

; leftMost_1:
; mov word[boxP],3840
; mov word di, 3840
; mov ah, 07
; mov al, 0xDC
; mov [es:di], ax
; jmp endKB_multi


;_
moveBoxLeft2:
mov di,[boxP2]
mov ax,0xb800
mov es,ax
mov word[es:di],0x720


cmp word di,3838
jz rightMost_2

cmp word di,3840
jz rightMost_2
sub di,2
cmp word[bool_shift],1
jne skipDoubleL2
sub di,2
skipDoubleL2:
; cmp word[bool_shift],1
; jne skipDoubleL
; sub di,2
;skipDoubleL:

mov word[boxP2],di
mov ah, 07
mov al, 0xDC
mov [es:di], ax


jmp endKB_multi

rightMost_2:
mov word[boxP2],3998
mov word di, 3998
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB_multi


;----------------------------------
moveBoxRight2:
mov di,[boxP2]
mov ax,0xb800
mov es,ax
mov word[es:di],0x720


cmp word di,3998
jz leftMost_2

cmp word di,4000
jz leftMost_2
add di,2
cmp word[bool_shift],1
jne skipDoubleR2
add di,2
skipDoubleR2:
; cmp word[bool_shift],1
; jne skipDoubleL
; sub di,2
;skipDoubleL:

mov word[boxP2],di
mov ah, 07
mov al, 0xDC
mov [es:di], ax


jmp endKB_multi

leftMost_2:
mov word[boxP2],3840
mov word di, 3840
mov ah, 07
mov al, 0xDC
mov [es:di], ax
jmp endKB_multi



; moveBoxRight2:
; mov di,[boxP2]
; mov ax,0xb800
; mov es,ax
; mov word[es:di],0x720


; cmp word di,3998
; jz leftMost_2
; mov word[boxP2],di
; mov ah, 07
; mov al, 0xDC
; mov [es:di], ax
; jmp endKB_multi

; leftMost_2:
; mov word[boxP2],3840
; mov word di, 3840
; mov ah, 07
; mov al, 0xDC
; mov [es:di], ax
; jmp endKB_multi








endgameEsc_multi:
inc word[bool_esc]


endKB_multi:

; jmp far [cs: oldKeyboard]

exitKB_multi:

mov al, 0x20
out 0x20, al
pop ax
iret




printBox:
push bp
mov bp, sp
push ax
push di
mov ax, 0xb800
mov es, ax
mov di, [boxP]
mov ah, 07
mov al, 0xDC
mov [es:di], ax
pop di
pop ax
pop bp
ret

printBox2:
push bp
mov bp, sp
push ax
push di
mov ax, 0xb800
mov es, ax
mov di, [boxP2]
mov ah, 07
mov al, 0xDC
mov [es:di], ax
pop di
pop ax
pop bp
ret


;TIMER

timer:
push ax
call scoreline
call missedline

call move1
call move2
call move3
call move4
call move5
call printScore
call printMissed
call printBox

cmp word [bool_multiplayer],1
jne skipbox2
call printBox2
skipbox2:


mov al, 0x20
out 0x20, al
pop ax
iret


printMissed:
cmp word[missed_alphabets],25
je endMissed

push 36
push word[missed_alphabets]
call printNumber
ret
endMissed:
inc word[bool_loose]
ret



printScore:
cmp word[score_count],15
je endScore


push 128
push word[score_count]
call printNumber
ret
endScore:
inc word[bool_win]
ret


starter:

push bp
mov bp,sp
push es
push ax
push di
push cx

mov si,starterString
mov ax,0xb800
mov es,ax


mov di,1836
mov cx,[len1]
mov ah,0x1E
printnext:
mov al,[si]
stosw
add si,1
loop printnext

mov ah, 0 ; wait for key stroke
Int 16h; scan code of pressed key will be returned in AH
cmp ah,1
je end
mov di,1836
mov cx,[len1]
mov ax,0x720
removenext:

stosw
add si,1
loop removenext
end:
pop cx
pop di
pop ax
pop es
pop bp
ret

S_or_M:

push bp
mov bp,sp
push es
push ax
push di
push cx

mov si,PressMorS
mov ax,0xb800
mov es,ax


mov di,1790
mov cx,[len3]
mov ah,0x1E
printN:
mov al,[si]
stosw
add si,1
loop printN

l1:
mov ah,0x00
int 16h
cmp ah,0x32
jne skip1
inc word[bool_multiplayer]
jmp l2
skip1:
cmp ah,0x1f
jne l1
mov word[bool_multiplayer],0


l2:
call clrscr
pop cx
pop di
pop ax
pop es
pop bp
ret


 PrintScore_str:
 push bp
 mov bp,sp
 push es
 push ax
 push di
 push cx
push si
 mov si,ScoreStr
 mov ax,0xb800
 mov es,ax


 mov di,2138
 mov cx,[len4]
 mov ah,07
 ScoreL1:
 mov al,[si]
 stosw
 add si,1
 loop ScoreL1


push 2150
push word[score_count]
call printNumber


; ;call clrscr
pop si
 pop cx
 pop di
 pop ax
 pop es
 pop bp
 ret


 PrintMissed_str:
 push bp
 mov bp,sp
 push es
 push ax
 push di
 push cx
push si
 mov si,MissedStr
 mov ax,0xb800
 mov es,ax


 mov di,2168
 mov cx,[len5]
 mov ah,07
 MissedL1:
 mov al,[si]
 stosw
 add si,1
 loop MissedL1


push 2182
push word[missed_alphabets]
call printNumber


; ;call clrscr
pop si
 pop cx
 pop di
 pop ax
 pop es
 pop bp
 ret









scoreline:
push ax
push si
push di
push bx
push cx
mov ax, 0xb800
mov es, ax
mov di, 114
mov cx, 7
mov ah, 0x1E
mov si, line2
cld
p2:
lodsb
stosw
loop p2
pop cx
pop bx
pop di
pop si
pop ax
ret

missedline:
push ax
push si
push di
push bx
push cx
mov ax, 0xb800
mov es, ax
mov di, 20
mov cx, 8
mov ah, 0x1E
mov si, line3
cld
p3:
lodsb
stosw
loop p3
pop cx
pop bx
pop di
pop si
pop ax
ret


ender:
push bp
mov bp,sp
push es
push ax
push di
push cx

mov si,endStirng
mov ax,0xb800
mov es,ax


mov di,1832
mov cx,[len2]
mov ah,0x0C
printnext2:
mov al,[si]
stosw
add si,1
loop printnext2

; call PrintScore_str


pop cx
pop di
pop ax
pop es
pop bp
ret


sleep: pusha
mov cx, 0xFFFF
delay: loop delay
popa
ret

randGnum:
mov word [rand],0
mov word [randnum],0
push bp
mov bp, sp
pusha
cmp word [rand], 0
jne nextt
MOV AH, 00h 
INT 1AH
inc word [rand]
mov [randnum], dx
jmp next2
nextt:
mov ax, 25173         
mul word  [randnum]   
add ax, 13849     
mov [randnum], ax
next2:xor dx, dx
mov ax, [randnum]
mov cx, [bp+4]
inc cx
div cx
mov [bp+6], dx
popa
pop bp
ret 2

;---------------------------------------------------------------------------

randG:
   push bp
   mov bp, sp
   pusha
   cmp word [rand], 0
   jne next

  MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
  INT     1AH
  inc word [rand]
  mov     [randnum], dx
  jmp next1

  next:
  mov     ax, 25173          ; LCG Multiplier
  mul     word  [randnum]     ; DX:AX = LCG multiplier * seed
  add     ax, 13849          ; Add LCG increment value
  ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
  mov     [randnum], ax          ; Update seed = return value

 next1:xor dx, dx
 mov ax, [randnum]
 mov cx, [bp+4]
 inc cx
 div cx
 
 mov [bp+6], dx
 popa
 pop bp
 ret 2

RANDNUM:
   push bp
   mov bp,sp
   push ax
   push cx
   push dx
   
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      
   mov  ax, dx
   xor  dx, dx
   mov  cx, [bp+4] 
   inc cx   
   div  cx       ; here dx contains the remainder of the division - from 0 to 9
   mov [bp+6], dx
   pop dx
   pop cx
   pop ax
   pop bp   
   ret 2   


;printchar:
;push bp
;mov bp,sp
;push es
;pusha

printNumber:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
	push 0xb800
	pop es
    mov ax, [bp+4] ; load number in ax
    mov bx, 10 ; use base 10 for division
    mov cx, 0 ; initialize count of digits
	
nextDigit:
    mov dx, 0 ; zero upper half of dividend
    div bx ; divide by 10
    add dl, 0x30 ; convert digit into ascii value
    push dx ; save ascii value on stack
    inc cx ; increment count of values
    cmp ax, 0 ; is the quotient zero
    jnz nextDigit ; if no divide it again
    mov di, [bp+6] ; point di to 70th column
	
nextPosition:
    pop dx ; remove a digit from the stack
    mov dh, 0x07 ; use normal attribute
    mov [es:di], dx ; print char on screen
    add di, 2 ; move to next screen location
    loop nextPosition ; repeat for all digits on stack
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 4

;mov ax,0xb800
;mov es,ax

;-----------------------------------------



printchar1:
push bp
mov bp,sp
push es
pusha



mov ax,0xb800
mov es,ax


mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,128
add ax,320
mov word[char1_offset],ax
mov di,ax
mov ax,0

sub sp,2
push 25
call randG
pop dx


mov ax,dx
mov ah,0x0C
add al,'A'
mov word[character1],ax 
stosw
mov dx,0



popa
pop es
pop bp
ret
;_________
printchar2:
push bp
mov bp,sp
push es
pusha



mov ax,0xb800
mov es,ax


mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,128
add ax,320
mov word[char2_offset],ax
mov di,ax
mov ax,0

sub sp,2
push 25
call randG
pop dx


mov ax,dx
mov ah,0x0C
add al,'A'
mov word[character2],ax 
stosw
mov dx,0



popa
pop es
pop bp
ret

;_________
;------------------------------
printchar3:
push bp
mov bp,sp
push es
pusha



mov ax,0xb800
mov es,ax


mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,96
add ax,320
mov word[char3_offset],ax
mov di,ax
mov ax,0

sub sp,2
push 25
call randG
pop dx


mov ax,dx
mov ah,0x0D
add al,'A'
mov word[character3],ax 
stosw
mov dx,0


mov dx,0

popa
pop es
pop bp
ret

;_________

;--------------------------
printchar4:
push bp
mov bp,sp
push es
pusha



mov ax,0xb800
mov es,ax

mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,96
add ax,320
mov word[char4_offset],ax
mov di,ax
mov ax,0

sub sp,2
push 25
call randG
pop dx


mov ax,dx
mov ah,0x0F
add al,'A'
mov word[character4],ax 
stosw
mov dx,0

mov dx,0

popa
pop es
pop bp
ret

;_________

;----------------------------
printchar5:
push bp
mov bp,sp
push es
pusha



mov ax,0xb800
mov es,ax


mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,128
add ax,320
mov word[char5_offset],ax
mov di,ax
mov ax,0

sub sp,2
push 25
call randG
pop dx


mov ax,dx
mov ah,0x0A
add al,'A'
mov word[character5],ax 
stosw
mov dx,0



popa
pop es
pop bp
ret


;movedown:

;push bp
;mov bp,sp
;push es
;pusha
;


;mov cx,25
move1:
inc word[char1time]
cmp word[score_count],8
jb nochangeSpeed1
cmp word[char1time],4
jbe endmove1
jmp skipspeed1

nochangeSpeed1:
cmp word[char1time],8
jbe endmove1

skipspeed1:
mov word[char1time],0
inc word[position1]
cmp word [position1],25
jne skipnew1
cmp word[flag1],1
je nomiss1
inc word[missed_alphabets]
nomiss1:
cmp word[bool_first],1
je do
mov word[missed_alphabets],0
mov word[bool_first],1
do:
call printchar1
mov word[flag1],0
mov word[position1],0
jmp endmove1

skipnew1:

mov ax,0xb800
mov es,ax
mov di,[char1_offset]
mov ax,0x0720
mov [es:di],ax
;call sleep

add di,160
mov ax,[character1]
mov [es:di],ax
mov [char1_offset],di
mov ax,di

cmp word[bool_multiplayer],1
jne no_multi1
cmp ax,[boxP2]
jne no_multi1
inc word[score_count]
mov word[flag1],1


no_multi1:
cmp ax,[boxP]
jne endmove1
inc word[score_count]
mov word[flag1],1


endmove1:

;popa
;pop es
;pop bp
ret

move2:
inc word[char2time]
cmp word[score_count],8
jb nochangeSpeed2
cmp word[char2time],2
jbe endmove2
jmp skipspeed2

nochangeSpeed2:
cmp word[char2time],5
jbe endmove2

skipspeed2:
mov word[char2time],0
inc word[position2]
cmp word [position2],25
jne skipnew2
cmp word[flag2],1
je nomiss2
inc word[missed_alphabets]
nomiss2:
cmp word[bool_second],1
je do2
mov word[missed_alphabets],0
mov word[bool_second],1
do2:
call printchar2
mov word[flag2],0
mov word[position2],0
jmp endmove2

skipnew2:

mov ax,0xb800
mov es,ax
mov di,[char2_offset]
mov ax,0x0720
mov [es:di],ax
;call sleep

add di,160
mov ax,[character2]
mov [es:di],ax
mov [char2_offset],di
mov ax,di

cmp word[bool_multiplayer],1
jne no_multi2
cmp ax,[boxP2]
jne no_multi2
inc word[score_count]
mov word[flag2],1


no_multi2:


cmp ax,[boxP]
jne endmove2
inc word[score_count]
mov word[flag2],1


endmove2:

;popa
;pop es
;pop bp
ret


move3:
inc word[char3time]
cmp word[score_count],8
jb nochangeSpeed3
cmp word[char3time],3
jbe endmove3
jmp skipspeed3

nochangeSpeed3:
cmp word[char3time],6
jbe endmove3

skipspeed3:

mov word[char3time],0
inc word[position3]
cmp word [position3],25
jne skipnew3
cmp word[flag3],1
je nomiss3
inc word[missed_alphabets]
nomiss3:
cmp word[bool_third],1
je do3
mov word[missed_alphabets],0
mov word[bool_third],1
do3:
call printchar3
mov word[flag3],0
mov word[position3],0
jmp endmove3

skipnew3:

mov ax,0xb800
mov es,ax
mov di,[char3_offset]
mov ax,0x0720
mov [es:di],ax
;call sleep

add di,160
mov ax,[character3]
mov [es:di],ax
mov [char3_offset],di
mov ax,di

cmp word[bool_multiplayer],1
jne no_multi3
cmp ax,[boxP2]
jne no_multi3
inc word[score_count]
mov word[flag3],1


no_multi3:


cmp ax,[boxP]
jne endmove3
inc word[score_count]
mov word[flag3],1


endmove3:

;popa
;pop es
;pop bp
ret



move4:
inc word[char4time]
cmp word[score_count],8
jb nochangeSpeed4
cmp word[char4time],5
jbe endmove4
jmp skipspeed4

nochangeSpeed4:
cmp word[char4time],10
jbe endmove4


skipspeed4:
mov word[char4time],0
inc word[position4]
cmp word [position4],25
jne skipnew4
cmp word[flag4],1
je nomiss4
inc word[missed_alphabets]
nomiss4:
cmp word[bool_fourth],1
je do4
mov word[missed_alphabets],0
mov word[bool_fourth],1
do4:
call printchar4
mov word[flag4],0
mov word[position4],0
jmp endmove4

skipnew4:

mov ax,0xb800
mov es,ax
mov di,[char4_offset]
mov ax,0x0720
mov [es:di],ax
;call sleep

add di,160
mov ax,[character4]
mov [es:di],ax
mov [char4_offset],di
mov ax,di

cmp word[bool_multiplayer],1
jne no_multi4
cmp ax,[boxP2]
jne no_multi4
inc word[score_count]
mov word[flag4],1


no_multi4:



cmp ax,[boxP]
jne endmove4
inc word[score_count]
mov word[flag4],1


endmove4:

;popa
;pop es
;pop bp
ret



move5:
inc word[char5time]
cmp word[score_count],8
jb nochangeSpeed5
cmp word[char5time],1
jbe endmove5
jmp skipspeed5

nochangeSpeed5:
cmp word[char5time],2
jbe endmove5


skipspeed5:
mov word[char5time],0
inc word[position5]
cmp word [position5],25
jne skipnew5
cmp word[flag5],1
je nomiss5
inc word[missed_alphabets]
nomiss5:
cmp word[bool_fifth],1
je do5
mov word[missed_alphabets],0
mov word[bool_fifth],1
do5:
call printchar5
mov word[flag5],0
mov word[position5],0
jmp endmove5

skipnew5:

mov ax,0xb800
mov es,ax
mov di,[char5_offset]
mov ax,0x0720
mov [es:di],ax
;call sleep

add di,160
mov ax,[character5]
mov [es:di],ax
mov [char5_offset],di
mov ax,di

cmp word[bool_multiplayer],1
jne no_multi5
cmp ax,[boxP2]
jne no_multi5
inc word[score_count]
mov word[flag5],1


no_multi5:



cmp ax,[boxP]
jne endmove5
inc word[score_count]
mov word[flag5],1


endmove5:

;popa
;pop es
;pop bp
ret






runfunction:
pusha
mov cx,10

je enddd

L:


loop L

enddd:
call clrscr
call ender
popa
ret

escapeLoop:
   hey:
   cmp word[bool_esc],1
   je endEscLoop
    cmp word[bool_win],1
je endEscLoop	
   cmp word[bool_loose],1 
   jne hey
   endEscLoop:
   call clrscr
   call PrintScore_str 
   call PrintMissed_str
   call ender
   ret
   
ReInitialise:


mov word[char1_offset],0
mov word[char2_offset],0
mov word[char3_offset],0
mov word[char4_offset],0
mov word[char5_offset],0


mov word[character1],'0'
mov word[character2],'0'
mov word[character3],'0'
mov word[character4],'0'
mov word[character5],'0'


mov word[char1time],0
mov word[char2time],0
mov word[char3time],0
mov word[char4time],0
mov word[char5time],0



mov word[position1],24
mov word[position2],24
mov word[position3],24
mov word[position4],24
mov word[position5],24




mov word[oldkbisr],0
mov word[oldtimer],0

mov word[boxP],3920
mov word[boxP2],3910
mov word[flag1],0
mov word[flag2],0
mov word[flag3],0
mov word[flag4],0
mov word[flag5],0

mov word[score_count],0
mov word[missed_alphabets],0
mov word[bool_first],0
mov word[bool_second],0
mov word[bool_third],0
mov word[bool_fourth],0
mov word[bool_fifth],0
; taking n as parameter, generate random number from 0 to n nad return in the stack

mov word[bool_loose],0
mov word[bool_win],0
mov word[bool_esc],0

mov word[bool_shift],0
mov word[bool_multiplayer],0

ret   
   
   
start: 
LL:
call clrscr

call ReInitialise
call starter
;call printBox

mov word[bool_multiplayer],0


call S_or_M

hooking:

;l1: call move5
;jmp l1
xor ax,ax
mov es,ax


;---------------------
mov ax,[es:8*4]          ; saving old timer 
mov word[oldtimer],ax
mov ax,[es:8*4+2]
mov word[oldtimer+2],ax


mov ax,[es:9*4]         ; saving old kbisr
mov word[oldkbisr],ax
mov ax,[es:9*4+2]
mov word[oldkbisr+2],ax

;-----------------------
cli
cmp word[bool_multiplayer],1
je skip2

mov word [es:9*4], kbisr
mov [es:9*4+2], cs
jmp skip3
skip2:
mov word [es:9*4], Multiplayer_KBISR
mov [es:9*4+2], cs
skip3:
mov word [es:8*4], timer
mov [es:8*4+2], cs
sti
;---------------------------

mov word[boxP],3920
call printBox
call escapeLoop

cli
xor ax, ax
mov es, ax
mov ax, [oldtimer]
mov [es:8*4], ax
mov ax, [oldtimer+2]
mov [es:8*4+2], ax
mov ax, [oldkbisr]
mov [es:9*4], ax
mov ax, [oldkbisr+2]
mov [es:9*4+2], ax
sti
	
	

mov dx, start
add dx,15
mov cl, 4
shr dx, cl




mov ax, 0x3100
int 21h