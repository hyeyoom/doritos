%include "boot.mac"

[org 0]
[bits 16]

jmp CODE_SEG: entry

entry:
    mov ax, CODE_SEG
    mov ds, ax
    mov ax, VMEM_SEG
    mov es, ax

    call clear_screen

    push BOOT_MESSAGE   ; bp + 8
    push 0              ; bp + 6, pos y
    push 0              ; bp + 4, pos x
    call printxy
    add sp, 6

    jmp stuck_in_here

printxy:
.print_init:
    push bp     ; store base pointer
    mov bp, sp

    ; store the context
    push es
    push di 
    push si
    push dx
    push cx
    push bx
    push ax

    ; set video memory, es = VMEM_SEG(0xb800)
    mov ax, VMEM_SEG
    mov es, ax

    ; calculate x pos for video memory
    mov ax, word[bp + 4]
    mov si, 2   ; si = 2
    mul si      ; ax *= si
    add di, ax

    ; calculate y pos for video memory
    mov ax, word[bp + 6]
    mov si, 160 ; si = 160
    mul si      ; ax *= si
    mov di, ax  ; di = ax

    ; store string address in si(source index)
    mov si, word[bp + 8]
.print_loop:
    mov cl, byte[ si ]
    mov byte[es:di], cl
    add si, 1
    add di, 2
    cmp cl, 0
    jnz .print_loop
.print_return:
    pop ax
    pop bx
    pop cx
    pop dx
    pop si
    pop di
    pop es
    ret

clear_screen:
    mov byte[es:si], 0
    mov byte[es:si + 1], SET_FONT(BLACK, GREEN)
    add si, 2
    cmp si, VMEM_SIZE
    jl clear_screen
    ret

stuck_in_here:  ; infinite loop
    jmp $

BOOT_MESSAGE db "[!] doritos dummy bootloader", 0
times 510 - ($ - $$) db 0
dw 0xaa55