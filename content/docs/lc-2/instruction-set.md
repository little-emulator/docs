+++
title = "Instruction Set"
weight = 240

[[params.highlight.copy]]
enable = false
+++

The LC-2 is a very
[RISC](https://en.wikipedia.org/wiki/Reduced_instruction_set_computer) CPU,
composed only of 16 instructions.

When the CPU fetches a new instruction from the memory, the bits [15:12] (the
four most significant bits) are used as the **opcode** (operation code), and
the rest of the bits are used as parameters.[^1] [^2]

[^1]: Patt, Y. N., & Patel, S. J. (2001). 4.2 Instruction Processing. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 79-84). essay, McGraw Hill.

[^2]: Postiff, M. (n.d.). 2.2 Instruction Set. In _LC-2 Programmer’s Reference
      and User Guide_.
      [https://cs.utexas.edu/~fussell/courses/cs310h/simulator/lc2.pdf](https://web.archive.org/web/20240928102747/https://www.cs.utexas.edu/~fussell/courses/cs310h/simulator/lc2.pdf)
      (_Archived on 2024-09-28_)

In this page are listed all of the instructions.[^3]

[^3]: Patt, Y. N., & Patel, S. J. (2001). Appendix A.3 The Instruction Set. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 430-448). essay, McGraw Hill.

{{< cards cols="2" >}}
  {{< card
    title="LC-2 Instructions"
    link="../lc2-instructions.drawio.png"
    image="../lc2-instructions.drawio.png"
  >}}
{{< /cards >}}

{{% details title = "ADD" closed = "true" %}}

  > Addition
  
  ```asm
  ADD DR, SR1, SR2
  ADD DR, SR1, imm5
  ```
  
  ![ADD](../instructions/add.drawio.png)
  
  ```python { filename = "Operation" }
  if (bit[5] == 0)
    DR = SR1 + SR2;
  else
    DR = SR1 + sign_extend(imm5);
  
  set_conditon_codes(DR);
  ```
  
  If the bit [5] is `0`, the second operand is obtained from `SR2`. If the bit
  [5] is `1` the second operand is obtained from the [sign
  extension](https://en.wikipedia.org/wiki/Sign_extension) of the bit [4:0]
  (`imm5`).
  
  In both cases, the second source operand is added to the contents of `SR1`,
  and the result is stored in `DR`.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  Any carry generated is discarded and overflow is not signaled.
  
  ```asm { filename = "Example" }
  ADD R2, R3, R4    ; R2 ← R3 + R4
  ADD R2, R3, #7    ; R2 ← R3 + 7
  ```

{{% /details %}}

{{% details title = "AND" closed = "true" %}}

  > Bitwise AND
  
  ```asm
  AND DR, SR1, SR2
  AND DR, SR1, imm5
  ```
  
  ![AND](../instructions/and.drawio.png)
  
  ```python { filename = "Operation" }
  if (bit[5] == 0)
    DR = SR1 AND SR2;
  else
    DR = SR1 AND sign_extend(imm5);
  
  set_condition_codes(DR);;
  ```
  
  If the bit [5] is `0`, the second operand is obtained from `SR2`. If the bit
  [5] is `1` the second operand is obtained from the [sign
  extension](https://en.wikipedia.org/wiki/Sign_extension) of the bit [4:0]
  (`imm5`).
  
  In both cases, the second source operand is ANDed bitwise to the contents of
  `SR1`, and the result is stored in `DR`.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  AND R2, R3, R4    ; R2 ← R3 AND R4
  AND R2, R3, #7    ; R2 ← R3 AND 7
  ```

{{% /details %}}

{{% details title = "BR" closed = "true" %}}

  > Conditional Branch
  
  ```asm
                     ; Equivalent Mnemonics:
  BRn   pgoffset9    ; BRlt pgoffset9
  BRz   pgoffset9    ; BReq pgoffset9
  BRp   pgoffset9    ; BRgt pgoffset9
  BRnz  pgoffset9    ; BRle pgoffset9
  BRnp  pgoffset9    ; BRne pgoffset9
  BRzp  pgoffset9    ; BRge pgoffset9
  BRnzp pgoffset9    ; BR   pgoffset9
  BRNOP pgoffset9    ; NOP  pgoffset9
  ```
  
  ![BR](../instructions/br.drawio.png)
  
  ```python { filename = "Operation" }
  if ((n AND N) OR (z AND Z) OR (p AND P))
    PC = PC[15:9] @ pgoffset9;
  ```
  
  Test the condition codes specified by the state of bits [11:9].
  
  If bit [11] is set, test N; if bit [11] is clear, do not test N. If bit [10]
  is set, test Z, etc.
  
  If any of the condition code tested is set, branch to the location specified
  by combining the first 7 bits of the program counter with the last 9 bits of
  the instruction (`pgoffset9`).
  
  Given the instruction opcode and parameters we can deduce that, on the LC-2,
  the instruction `0x0000` (like every instruction that starts with `0000 000`)
  is a [NOP](https://en.wikipedia.org/wiki/NOP_(code)).
  
  ```asm { filename = "Example" }
  BRzp loop    ; Branch to the "loop" label if the last result was zero or positive
  ```

{{% /details %}}

{{% details title = "JMP & JSR" closed = "true" %}}

  > Unconditional Jump & Jump to Subroutine
  
  ```asm
  JMP pgoffset9    ; L = 0
  JSR pgoffset9    ; L = 1
  ```
  
  ![JMP & JSR](../instructions/jmp_jsr.drawio.png)
  
  ```python { filename = "Operation" }
  if (L == 1)
    R7 = PC;
  
  PC = PC[15:9] @ pgoffset9;
  ```
  
  Unconditionally jump to the location specified by `pgoffset9`.
  
  If the bit [11] is set, put the current value of the program counter into the
  `R7` register.
  
  ```asm { filename = "Example" }
  JMP loop          ; Jump to the "loop" label
  JSR subroutine    ; Jump to the "subroutine" label and save the current PC into R7
  ```

{{% /details %}}

{{% details title = "JMPR & JSRR" closed = "true" %}}

  > Jump through Register & Jump to Subroutine through Register
  
  ```asm
  JMPR BaseR, index6    ; L = 0
  JSRR BaseR, index6    ; L = 1
  ```
  
  ![JMPR & JSRR](../instructions/jmpr_jsrr.drawio.png)
  
  ```python { filename = "Operation" }
  if (L == 1)
    R7 = PC;
  
  PC = BaseR + zero_extend(index6);
  ```
  
  Unconditionally jump to the location specified by adding `BaseR` to the [zero
  extension](https://en.wikipedia.org/wiki/Sign_extension#Zero_extension) of
  `index6`.
  
  If the bit [11] is set, put the current value of the program counter into the
  `R7` register.
  
  ```asm { filename = "Example" }
  JMPR R2, #10    ; Jump to R2 + 10
  JSRR R4, #7     ; Jump to R4 + 7, save the current PC into R7
  ```

{{% /details %}}

{{% details title = "LD" closed = "true" %}}

  > Load Directly from Memory
  
  ```asm
  LD DR, pgoffset9
  ```
  
  ![LD](../instructions/ld.drawio.png)
  
  ```python { filename = "Operation" }
  DR = memory[PC[15:9] @ pgoffset9];
  set_condition_codes(DR);
  ```
  
  Load the register specified by `DR` with the word from the main memory
  pointed by the `pgoffset9`.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  LD R4, variable    ; Load the value pointed by the "variable" label into R4
  ```

{{% /details %}}

{{% details title = "LDI" closed = "true" %}}

  > Load Indirectly from Memory
  
  ```asm
  LDI DR, pgoffset9
  ```
  
  ![LDI](../instructions/ldi.drawio.png)
  
  ```python { filename = "Operation" }
  DR = memory[memory[PC[15:9] @ pgoffset9]];
  set_condition_codes(DR);
  ```
  
  Load the register specified by `DR` in this way: load the cell pointed by
  `pgoffset9` and use it as a pointer to the actual value to be loaded.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  LD R4, pointer    ; Use the value pointed by the "pointer" as an address and put the content of the cell into R4
  ```

{{% /details %}}

{{% details title = "LDR" closed = "true" %}}

  > Load from Memory through Register (Base + Offset)
  
  ```asm
  LDR DR, BaseR, index6
  ```
  
  ![LDR](../instructions/ldr.drawio.png)
  
  ```python { filename = "Operation" }
  DR = memory[BaseR + zero_extend(index6)];
  set_condition_codes(DR);
  ```
  
  Load the register specified by `DR` with the word from the main memory
  pointed by the content of the register `BaseR` plus the
  [zero-extension](https://en.wikipedia.org/wiki/Sign_extension#Zero_extension)
  of `index6`.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  LDR R4, R2, #10    ; Load the value pointed by the address stored in R2 + 10 into R4
  ```

{{% /details %}}

{{% details title = "LEA" closed = "true" %}}

  > Load Effective Address
  
  ```asm
  LEA DR, pgoffset9
  ```
  
  ![LEA](../instructions/lea.drawio.png)
  
  ```python { filename = "Operation" }
  DR = PC[15:9] @ pgoffset9;
  set_condition_codes(DR);
  ```
  
  Load the register specified by `DR` with the address formed by concetenating
  the top seven bits of the program counter with the `pgoffset9`.
  
  The condition codes are set, based on whether the result is negative, zero, or
  positive.
  
  ```asm { filename = "Example" }
  LEA R4, foo    ; Load the address of the "foo" label into R4
  ```

{{% /details %}}

{{% details title = "NOT" closed = "true" %}}

  > Bitwise Complement
  
  ```asm
  NOT DR, SR
  ```
  
  ![NOT](../instructions/not.drawio.png)
  
  ```python { filename = "Operation" }
  DR = !SR;
  set_condition_codes(DR);
  ```
  
  Perform the bitwise complement on the contents of `SR` and place the result
  in `DR`.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  
  ```

{{% /details %}}

{{% details title = "RET" closed = "true" %}}

  > Return from Subroutine
  
  ```asm
  RET
  ```
  
  ![RET](../instructions/ret.drawio.png)
  
  ```python { filename = "Operation" }
  PC = R7;
  ```
  
  Load the program counter with the value stored in `R7`.
  
  ```asm { filename = "Example" }
  RET    ; Put R7 contents into PC
  ```

{{% /details %}}

{{% details title = "RTI" closed = "true" %}}

  > Return from Interrupt
  
  ```asm
  RTI
  ```
  
  ![RTI](../instructions/rti.drawio.png)
  
  ```python { filename = "Operation" }
  condition_codes = memory[R6];
  R6 = R6 - 1;
  PC = memory[R6];
  R6 = R6 - 1;
  ```
  
  Pop the top two elements off the stack. Load the first one into the condition
  codes, and the second one into the program counter.
  
  {{< callout type="info" >}}
  For more information check the "[Interrupts](../interrupts)" chapter.
  {{< /callout >}}
  
  ```asm { filename = "Example" }
  RTI    ; Return from an interrupt subroutine
  ```

{{% /details %}}

{{% details title = "ST" closed = "true" %}}

  > Store Directly from Memory
  
  ```asm
  ST SR, pgoffset9
  ```
  
  ![ST](../instructions/st.drawio.png)
  
  ```python { filename = "Operation" }
  memory[PC[15:9] @ pgoffset9] = SR;
  ```
  
  Store the value in the `SR` register with the word from the main memory
  pointed by the `pgoffset9`.
  
  ```asm { filename = "Example" }
  ST R4, variable    ; Store the R4 register into "variable"
  ```

{{% /details %}}

{{% details title = "STI" closed = "true" %}}

  > Store Indirectly from Memory
  
  ```asm
  STI SR, pgoffset9
  ```
  
  ![STI](../instructions/sti.drawio.png)
  
  ```python { filename = "Operation" }
  memory[memory[PC[15:9] @ pgoffset9]] = SR;
  ```
  
  Store the content of the register specified by `SR` in this way: load the
  cell pointed by `pgoffset9` and use it as a pointer to the actual cell to be
  stored.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  
  ```

{{% /details %}}

{{% details title = "STR" closed = "true" %}}

  > Store from Memory through Register (Base + Offset)
  
  ```asm
  STR SR, BaseR, index6
  ```
  
  ![STR](../instructions/str.drawio.png)
  
  ```python { filename = "Operation" }
  memory[BaseR + zero_extend(index6)] = SR;
  ```
  
  Store the content of the register specified by `SR` with the word from the
  main memory pointed by the content of the register `BaseR` plus the
  [zero-extension](https://en.wikipedia.org/wiki/Sign_extension#Zero_extension)
  of `index6`.
  
  The condition codes are set, based on whether the result is negative, zero,
  or positive.
  
  ```asm { filename = "Example" }
  
  ```

{{% /details %}}

{{% details title = "TRAP" closed = "true" %}}

  > Operating System Call
  
  ```asm
  TRAP trapvec8
  ```
  
  ![TRAP](../instructions/trap.drawio.png)
  
  ```python { filename = "Operation" }
  R7 = PC;
  PC = memory[zero_extend(trapvec8)];
  ```
  
  Load the program counter with the content of the main memory pointed by the
  [zero-extension](https://en.wikipedia.org/wiki/Sign_extension#Zero_extension)
  of `trapvec8`.
  
  {{< callout type="info" >}}
  For more information check the "[Trap](../trap)" chapter.
  {{< /callout >}}
  
  ```asm { filename = "Example" }
  TRAP 0x23    ; Direct the OS to execute the "IN" system call
  ```

{{% /details %}}
