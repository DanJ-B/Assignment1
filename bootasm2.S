.code16                         # Assemble for 16-bit mode
.globl start
start:
    jmp     real_start

# Write to the console using BIOS.
# 
# Input: SI contains the address of the null-terminated string to be displayed

cons_write:
    movb    $0x0e, %ah           # 0x0e is the INT 10h BIOS call to output the value contained in AL to screen

cons_write_rpt:
    movb    (%si), %al          # Load the byte at the location contained in the SI register into AL   
    inc     %si                 # Add 1 to the value in SI
    cmp     $0, %al             # Compare the value in AL with 0
    jz      cons_write_done     # If it is zero, then we are done
    int     $0x10               # Output the character in AL to the screen
    jmp     cons_write_rpt      # and continue

cons_write_done:                # Something that is called will never return 
    ret                         # until a 'ret' instruction is encountered.  Labels do 
                                # not give a program any structure.  They just give a 
                                # memory location a name that we can use in our code. 

cons_write_crlf:
    movb    $0x0e, %ah          # Output CR
    movb    $0x0d, %al
    int     $0x10
    movb    $0x0a, %al          # Output LF
    int     $0x10
    ret

cons_writeline:
    call    cons_write
    call    cons_write_crlf
    ret    

write_line_num:
    movw    %dx, %bx            # move the value of the offset (dx) into bx and display it as 2 byte hex value at the start of the next line
    call    cons_write_crlf
    call    cons_write_offset
    ret

real_start:
    movw    $boot_message, %si  # Display our boot message
    call    cons_writeline

    call    read_sector

read_sector:
    movw    $disk_address_packet, %si # Move address of the disk address packet into SI
    movw    $1, 2(%si)                # Set the number of blocks to read to be 1
    movw    $0xD000, 4(%si)           # Set the adddress to read into to be 0xD000
    movw    $0, 8(%si)                # Set the first block to read to be block 1
    movb    $0x42, %ah                # 0x42 is the int 13h BIOS function to read the disk using LBA addressing
    int     $0x13                     # Read the disk
    call    cons_write_crlf
    movw    $0, %dx                   # clear the dx register so it can be used as an index for the offset into the sector 
    call    write_line_num            # call a function to display the offset into the sector every 16 bytes

write_line:

    movw    %dx, %si                 # move dx into si so it can be used as an index into the memory location
    movb    0xD000(%si), %bl         # move the value stored at the byte address into an 8 bit register 
    call    cons_write_hexbyte       # output the 1 byte hex value at the location 
    inc     %dx                     
    cmp     $16, %dx                 
    jl      write_line               # if we haven't reached the 16th byte, loop around
    call    write_line_num           # if we have reached the 16th byte, write the next line number using dx as an index

write_line1:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $32, %dx
    jl      write_line1
    call    write_line_num

write_line2:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $48, %dx
    jl      write_line2
    call    write_line_num

write_line3:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $64, %dx
    jl      write_line3
    call    write_line_num

write_line4:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $80, %dx
    jl      write_line4
    call    write_line_num

write_line5:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $96, %dx
    jl      write_line5
    call    write_line_num

write_line6:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $112, %dx
    jl      write_line6
    call    write_line_num

write_line7:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $128, %dx
    jl      write_line7
    call    write_line_num

write_line8:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $144, %dx
    jl      write_line8
    call    write_line_num

write_line9:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $160, %dx
    jl      write_line9
    call    write_line_num

write_line10:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $176, %dx
    jl      write_line10
    call    write_line_num

write_line11:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $192, %dx
    jl      write_line11
    call    write_line_num

write_line12:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $208, %dx
    jl      write_line12
    call    write_line_num

write_line13:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $224, %dx
    jl      write_line13
    call    write_line_num

write_line14:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $240, %dx
    jl      write_line14
    call    write_line_num

write_line15:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $256, %dx
    jl      write_line15
    call    write_line_num

write_line16:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $272, %dx
    jl      write_line16
    call    write_line_num

write_line17:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $288, %dx
    jl      write_line17
    call    write_line_num

write_line18:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $304, %dx
    jl      write_line18
    call    write_line_num

write_line19:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $320, %dx
    jl      write_line19
    call    write_line_num

write_line20:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $336, %dx
    jl      write_line20
    call    write_line_num

write_line21:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $352, %dx
    jl      write_line21
    call    write_line_num

write_line22:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $368, %dx
    jl      write_line22
    call    write_line_num

write_line23:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $384, %dx
    jl      write_line23
    call    write_line_num

write_line24:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $400, %dx
    jl      write_line24
    call    write_line_num

write_line25:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $416, %dx
    jl      write_line25
    call    write_line_num

write_line26:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $432, %dx
    jl      write_line26
    call    write_line_num

write_line27:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $448, %dx
    jl      write_line27
    call    write_line_num

write_line28:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $464, %dx
    jl      write_line28
    call    write_line_num

write_line29:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $480, %dx
    jl      write_line29
    call    write_line_num

write_line30:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $496, %dx
    jl      write_line30
    call    write_line_num

write_line31:

    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $512, %dx
    jl      write_line31
    jmp     endless_loop


# write the 2 byte hex value for start of each line

HexChars: .ascii "0123456789ABCDEF"

cons_write_offset:
    movw    $4, %cx                          
    movb    $0x0E, %ah      

offset_hexloop:
    rol     $4, %bx
    movw    %bx, %si
    and     $0x000F, %si            
    movb    HexChars(%si), %al     
    int     $0x10                  
    loop    offset_hexloop                 
    ret

# adapted version of the above to only write one byte at a time

cons_write_hexbyte:
    movb    $0, %bh             #clear the %bh register to ensure no issues while using %bl to output a hex value
    movw    $2, %cx                           
    movb    $0x0E, %ah      

hexloop:
    rol     $4, %bl
    movw    %bx, %si
    and     $0x000F, %si            
    movb    HexChars(%si), %al
    int     $0x10                  
    loop    hexloop                 
    ret


disk_address_packet:
    .byte   0x10
    .byte   0
    .word   0
    .long   0
    .long   0
    .long   0

endless_loop:                         # Loop forever more
    jmp     endless_loop    

floppy_message:
    movw    $boot_floppy, %si
    call    cons_writeline

read_failed:
    movw    $bad_read, %si
    call    cons_writeline

# Format of disk address packet
#
# Offset	Size	Description
#  0          1     size of packet (16 bytes)
#  1          1     always 0
#  2          2     number of sectors to transfer (max 127 on some BIOSes)
#  4          4     transfer buffer (first 2 bytes is 16-bit offset, next 2 bytes is 16 bit segment)
#  8          4     lower 32-bits of 48-bit starting LBA (starting from 0)
#  12         4     upper 16-bits of 48-bit starting LBA (will always be 0 for us)

space:
    .string " "
bad_read:
    .string "Unable to read from the sector"
boot_floppy:
    .string "Booted from Floppy disk"
boot_hdd:
    .string "Booted from Hard disk drive"
boot_message:
    .string "Stage 2 running"
