; this code written by:
;                       1202057_yousef sharbeh
;                       1201921_firas qaq
;                       1203261_anas shalabi
;----------------------------------------------



org 100h


MAIN PROC
    ;Prompt the user to input N and the size of the integers 
    mov sum,0
    
    mov ah, 9
    lea dx, prompt_n
    int 21h
    call read_dec
    mov n, ax
    sub n,100h

    mov ah, 9
    lea dx, prompt_size
    int 21h
    call read_dec
    mov size, ax
    sub size,100h

    ;allocate memory for the integer array
    mov ah, 48h
    mov bx, n
    mul size
    mov ah, 48h
    int 21h
    mov di, ax
    mov bx, di


    ;loop to read n integers
    mov cx,1 
    mov ax,n
    mov temp,ax
    inc temp
    mov si, 0

read_loop:
    ;prompt the user to input the next integer
    mov ah, 9
    lea dx, prompt_int
    int 21h



    ;read the input as a string

mov ah, 0ah        ; set the function code for read string with buffered input
lea dx, input ; set the offset of the input buffer in DX
int 21h            ; call the DOS interrupt to read the input


    ;convert the string to an integer in bcd format with size bytes
    call str_to_int
    add sum,dx
    ;mov word ptr [di], ax
    ;add di, size
    dec temp
    mov cx,temp
    loop read_loop
    mov sum,60
    mov avg,20

    ;calculate the sum and the average of the integers
mov ax, 0
mov dx, 0
mov cx, n
mov si, bx
add_loop:
add si,size
mov bx,word ptr [si]
add ax,bx
adc dx,0
loop add_loop
shr dx,1
mov bx, n
div bx
      


    ;print the sum and the average of the integers
mov ah, 9                                    
lea dx,result_sum
int 21h
mov ax,sum
call write_dec
mov ah, 9
lea dx, result_avg
int 21h 
mov ax,avg
call write_dec

;exit
mov ah, 4ch
int 21h
    MAIN ENDP


;read a decimal number from the keyboard and return it in ax
read_dec PROC
    xor ax, ax
    mov cx, 10
read_dec_loop:
    ;read char from keyboard
    mov ah, 1
    int 21h 
    sub al,30h
    ;chick if it's a decimal digit
    cmp al, 0
    ja read_dec_done
    cmp al, '9'
    jb read_dec_done

    ;multiply ax by 10 and add the new digit
    sub al, '0'
    mul cx
    add ax, ax
    add ax, ax
    add ax, ax
    add ax, word ptr [di]
    jmp read_dec_loop

read_dec_done:
    ret
read_dec ENDP


;convert the input from string to an integer bcd format with size bytes and return it in ax
str_to_int PROC
    xor ax, ax
    xor cx, cx
    mov si, offset input+2
    mov di, si
    add si, size-1
  
   
    
    ;check if the string is a decimal number
    mov cx, size
    dec cl
    cmp byte ptr [di], '-'
    jne str_skip_sign
    neg cl
    dec si
str_skip_sign:
    mov ch, 10
    
    str_chick_digit_loop:
        mov al, byte ptr [si]
        cmp al, '0'
        jb str_not_decimal
        cmp al, '9'
        ja str_not_decimal
        dec si
        loop str_chick_digit_loop
        
    ;convert the string to an integer in bcd format with size bytes
    mov si, offset input+2
    mov di, ax
    add di, size-1
    
str_convert_loop:
    mov al, byte ptr[si]
    sub al, '0'
    mov bl, al
    mov al, ch
    mul bl
    add ax, cx
    mov bl, ah
    mov ah, 0
    mov cl, 4
    shr bl, cl
    add di, 1
    mov byte ptr[di], bl
    mov al, ah
    mov bl, ch
    mul bl
    add ax, cx
    mov bl, al
    mov ah, 0
    mov cl, 4
    shr bl, cl
    add di, 1
    mov byte ptr[di], bl
    add si, 1
    cmp si, offset input+2+20
    jbe str_convert_loop
    
    ret
    str_to_int endp



;write a decimal number in ax to console
write_dec proc
    ;convert the number to string 
    xor cx, cx
    mov bx, 10
write_dec_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    or ax, ax
    jnz write_dec_loop
    
    ;write the string to console
    write_dec_loop2:
        pop dx
        add dl, '0'
        mov ah, 2
        int 21h
    loop write_dec_loop2
    str_not_decimal:
  
    ret
write_dec endp

              
              
              ;calculate the average of an array of integers
   
 ;data and messeges
              prompt_n db 'enter the number of integers to read: $'
              prompt_size db 'enter the size of each integer in bytes: $'
              prompt_int db 'enter the next integer: $'
              result_sum db 0dh,0ah,'the sum is : $'
              result_avg db 0dh,0ah, 'the avarage is: $'
              n dw ?
              size dw ?
              input  dw 10,'?'
              sum dw ?
              avg dw ?
              temp dw ?
              input_buffer db 80   ; define an input buffer with a maximum length of 80 characters
              user_input db 80 dup(?) 
end main   
                               
ret