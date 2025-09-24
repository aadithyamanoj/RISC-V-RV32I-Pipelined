# Comprehensive RV32I Hazard Testing Program
# Tests: RAW forwarding, load-use hazards, and branch flushing

.section .text
.global _start

_start:

     li sp, (0x00030000 - 16)
     call    main
    li   x1, 0x2FFFD       # Halt address for success
    li   x2, 0xC0DE        # Success code
    sw   x2, 0(x1)

     # # Initialize base registers
    # li x1, 0x1000          # Base address = 0x1000
    # li x2, 0x100           # Test value 1 = 0x100
    # li x3, 0x200           # Test value 2 = 0x200  
    # li x4, 0x300           # Test value 3 = 0x300
    
    # #======================================================================
    # # TEST 1: EX/MEM to EX Forwarding (EX-EX forwarding)
    # #======================================================================
    # addi x5, x2, 100       # x5 = 0x100 + 100 = 0x164
    # add  x6, x5, x3        # x6 = 0x164 + 0x200 = 0x364 (forwards x5 from EX/MEM)
    
    # # Verify TEST 1: x6 should be 0x364
    # li   x28, 0x364        # Use x28 instead of x31 to avoid conflicts
    # bne  x6, x28, test_failed
    
    # #======================================================================
    # # TEST 2: MEM/WB to EX Forwarding (MEM-EX forwarding)  
    # #======================================================================
    # addi x7, x3, 50        # x7 = 0x200 + 50 = 0x232
    # add  x8, x7, x4        # x8 = 0x232 + 0x300 = 0x532 (forwards x7 from MEM/WB)
    
    # # Verify TEST 2: x8 should be 0x532
    # li   x27, 0x532        # Use x27 instead of x31
    # bne  x8, x27, test_failed
    
    # #======================================================================
    # # TEST 3: Load-Use Hazard (should cause stall)
    # #======================================================================
    # sw   x2, 0(x1)         # Store 0x100 to memory[0x1000]
    # lw   x9, 0(x1)         # Load 0x100 from memory[0x1000] into x9
    # add  x10, x9, x3       # x10 = 0x100 + 0x200 = 0x300 (stalls, then forwards)
    
    # # Verify TEST 3: x10 should be 0x300 (critical load-use test)
    # li   x26, 0x300        # Use x26 instead of x31
    # bne  x10, x26, test_failed
    
    # #======================================================================
    # # TEST 4: Load-Use with forwarding after stall
    # #======================================================================
    # sw   x3, 4(x1)         # Store 0x200 to memory[0x1004]
    # lw   x11, 4(x1)        # Load 0x200 from memory[0x1004] into x11  
    # add  x12, x11, x4      # x12 = 0x200 + 0x300 = 0x500 (forwards from MEM/WB)

    # # Verify TEST 4: x12 should be 0x500
    # li   x25, 0x500        # Use x25 instead of x31
    # bne  x12, x25, test_failed

    # #======================================================================
    # # TEST 5: Simple JAL test  
    # #======================================================================
    # jal  x18, jump_target   # Test JAL with jump and link
    # addi x19, x0, 123       # This should be FLUSHED by branch predictor
    # j    test_failed        # Should never reach here

# jump_target:
    # # Verify we jumped correctly
    # addi x20, x0, 0x123     # Set marker to prove we reached target
    
    # #======================================================================
    # # TEST 6: JAL with return using JALR
    # #======================================================================
    # jal  x21, jal_target2   # x21 = return address
    # addi x22, x0, 0x222     # x22 = marker after return
    # j    test7_start        # Skip to next test
    
# jal_target2:
    # # Set marker to prove we reached this target
    # addi x23, x0, 0x333     # x23 = 0x333 (proves we reached target)
    
    # # Return using JALR (jump to address in x21)
    # jalr x24, 0(x21)        # x24 = return address, jump to x21
    # addi x30, x0, 111       # This should be FLUSHED
    
# test7_start:
    # # Verify x22 was set (proves we returned correctly)
    # li   x29, 0x222
    # bne  x22, x29, test_failed
    
    # # Verify x23 was set (proves we reached jal_target2)
    # li   x29, 0x333
    # bne  x23, x29, test_failed
    
    # #======================================================================
    # # TEST 7: JALR with computed address
    # #======================================================================
    # # Calculate target address using PC-relative addressing
    # auipc x13, 0              # x13 = current PC
    # addi  x13, x13, 16        # x13 = PC + 16 (points to jalr_target3)
    # jalr  x14, 0(x13)         # x14 = return address, jump to x13
    # addi  x15, x0, 111        # This should be FLUSHED

    # # Verify we returned (x16 should be set by jalr_target3)
    # li   x29, 0x444
    # bne  x16, x29, test_failed
    # j    all_tests_passed

# jalr_target3:
    # # Set marker to prove we reached this target
    # addi x16, x0, 0x444       # x16 = 0x444 (proves we reached target)

    # # Return using JALR
    # jalr x17, 0(x14)          # Return to caller
    # addi x31, x0, 111         # This should be FLUSHED
    
    # #======================================================================
    # # All tests passed!
    # #======================================================================
# all_tests_passed:
# test_passed:
    # li   x1, 0x2FFFD       # Halt address for success
    # li   x2, 0xC0DE        # Success code
    # sw   x2, 0(x1)
    # j    end_program

# test_failed:
    # li   x1, 0x2FFFD       # Halt address for failure  
    # li   x2, 0xDEAD        # Failure code
    # sw   x2, 0(x1)

# end_program:
    # j    end_program       # Infinite loop

