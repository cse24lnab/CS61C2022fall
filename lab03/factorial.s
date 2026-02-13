.globl factorial

.data
n: .word 8

.text
# Don't worry about understanding the code in main
# You'll learn more about function calls in lecture soon
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial takes one argument:
# a0 contains the number which we want to compute the factorial of
# The return value should be stored in a0
factorial:
    # YOUR CODE HERE
    #可能不是正确的版本
    # 你的初始化代码
    addi t0, zero, 1      # 删掉了 ;
    addi t1, zero, 0      # 删掉了 ;
        
    Loop:
        beq t0, a0, Finish    # 删掉了 ; 这里的标签现在是 Finish
        addi t2, t1, zero     # 删掉了 ;
        
    Multi:
        beq t2, zero, Next    # 删掉了 ;
        add t1, t1, t2        # 删掉了 ; 这里的寄存器现在是 t2
        addi t2, t2, -1       # 删掉了 ;
        j Multi               # 删掉了 ;
        
    Next:
        addi t0, t0, 1        # 删掉了 ;
        j Loop                # 删掉了 ;
        
    Finish:
        add a0, a0, zero      # 删掉了 ;
        add a0, a0, t1        # 删掉了 ;
    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra
