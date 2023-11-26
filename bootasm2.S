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

real_start:
    movw    $boot_message, %si  # Display our boot message
    call    cons_writeline

    # Zero data segment registers DS, ES, and SS.
    xorw    %ax, %ax                 # Set %ax to zero
    movw    %ax, %ds                 # -> Data Segment
    movw    %ax, %es                 # -> Extra Segment
    movw    %ax, %ss                 # -> Stack Segment
    movw    $0, %sp                  # Set the stack to the top of the segment

read_sector:
    movw    $disk_address_packet, %si # Move address of the disk address packet into SI
    movw    $1, 2(%si)                # Set the number of blocks to read to be 1
    movw    $0xD000, 4(%si)           # Set the adddress to read into to be 0xD000
    movw    $0, 8(%si)                # Set the first block to read to be block 1
    int     $0x13                     # Read the disk
    call    cons_write_crlf
    movw    $16, %bx
    jmp     cons_write_offset
    jmp     write_byte

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

cons_write_hexbyte:
    movb    $0, %bh
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

write_byte:
    movw    $0, %dx 
    movw    %dx, %si
    movb    0xD000(%si), %bl 
    call    cons_write_hexbyte
    inc     %dx
    cmp     $16, %dx
    je      endless_loop
    jmp     write_byte

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

bad_read:
    .string "Unable to read from the sector"
boot_floppy:
    .string "Booted from Floppy disk"
boot_hdd:
    .string "Booted from Hard disk drive"
boot_message:
    .string "Stage 2 running"
