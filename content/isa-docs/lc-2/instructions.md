+++
title = "Instructions"
weight = 120
+++

{{% instruction
  mnemonic="ADD"
  short="Addition"

  formats=`ADD DR, SR1, SR2
ADD DR, SR1, imm5`

  encoding="../imgs/add.drawio.png"
  encoding-dark="../imgs/add-dark.drawio.png"

  operation=`if (bit[5] == 0) {
    DR = SR1 + SR2;
} else {
    DR = SR1 + SEXT(imm5);
}

setcc(DR);`

  examples=`ADD R2, R3, R4    ;  R2 ← R3 + R4
ADD R2, R3, #7    ;  R2 ← R3 + 7`

%}}
If bit [5] is 0, the second-source operand is obtained from SR2. If bit [5] is
1, the second-source operand is obtained by sign-extending the imm5 field to 16
bits. In both cases, the second source operand is added to the contents of SR1,
and the result stored in DR. The condition codes are set, based on whether the
result is negative, zero, or positive.
{{% /instruction %}}

{{% instruction
  mnemonic="AND"
  short="Bitwise logical AND"

  formats=`AND DR, SR1, SR2
AND DR, SR1, imm5`

  encoding="../imgs/and.drawio.png"
  encoding-dark="../imgs/and-dark.drawio.png"

  operation=`if (bit[5] == 0) {
    DR = SR1 & SR2;
} else {
    DR = SR1 & SEXT(imm5);
}

setcc(DR);`

  examples=`AND R2, R3, R4    ;  R2 ← R3 AND R4
AND R2, R3, #7    ;  R2 ← R3 AND 7`

%}}
If bit [5] is 0, the second-source operand is obtained from SR2. If bit [5] is
1, the second-source operand is obtained by sign-extending the imm5 field to 16
bits. In either case, the second-source operand and the contents of SR1 are
bitwise ANDed, and the result stored in DR. The condition codes are set, based
on whether the binary value produced, taken as a 2's complement integer, is
negative, zero, or positive.
{{% /instruction %}}

{{% instruction
  mnemonic="BR"
  short="Conditional Branch"

  formats=`BR    LABEL
BRn   LABEL
BRz   LABEL
BRp   LABEL
BRnz  LABEL
BRnp  LABEL
BRzp  LABEL
BRnzp LABEL`

  encoding="../imgs/br.drawio.png"
  encoding-dark="../imgs/br-dark.drawio.png"

  operation=`if ((n && N) || (z && Z) || (p && P)) {
    PC = PC[15:9] @ pgoffset9;
}`

  examples=`BRzp  LOOP    ;  Branch to LOOP if the last result was zero or positive.`

%}}
Test the condition codes specified by the state of bits [11:9]. If bit [11] is
set, test N; if bit [11] is clear, do not test N. If bit [10] is set, test Z,
etc. If any of the condition codes tested is set, branch to the location
specified by pgoffset9 on the same page as the branch instruction,
{{% /instruction %}}

{{% instruction
  mnemonic=`JMP / JSR`
  short=`Jump / Jump to Subroutine`

  formats=`JMP LABEL    (L = 0)
JSR LABEL    (L = 1)`

  encoding="../imgs/jmp-jsr.drawio.png"
  encoding-dark="../imgs/jmp-jsr-dark.drawio.png"

  operation=`if (L == 1) {
    R7 = PC;
}

PC = PC[15:9] @ pgoffset9;`

  examples=`JMP FOO    ;  Jump to FOO.
JSR FOO    ;  Jump to FOO, put return PC into R7.`

%}}
Unconditionally jump to the location specified by pgoffset9 on the same page as
the JSR/JMP instruction. If the link bit L is set, the PC is saved in R7,
enabling a subsequent return to the instruction physically following the JSR
instruction.
{{% /instruction %}}

{{% instruction
  mnemonic=`JMPR / JSRR`
  short=`Jump, Base + Offset / Jump to Subroutine, Base + Offset`

  formats=`JMPR BaseR, index6    (L = 0)
JSRR BaseR, index6    (L = 1)`

  encoding="../imgs/jmpr-jsrr.drawio.png"
  encoding-dark="../imgs/jmpr-jsrr-dark.drawio.png"

  operation=`if (L == 1) {
    R7 = PC;
}

PC = BaseR + ZEXT(index6);`

  examples=`JMPR R2, #10    ;  Jump to R2 + #10.
JSRR R2, #10    ;  Jump to R2 + #10, put return PC into R7.`

%}}
Unconditionally jump to the location specified by adding ZEXT(index6) to the
contents of the base register. If the link bit L is set, the PC is saved in R7,
enabling a subsequent return to the instruction physically following the JSRR
instruction.
{{% /instruction %}}

{{% instruction
  mnemonic="LD"
  short="Load Direct"

  formats=`LD DR, LABEL`

  encoding="../imgs/ld.drawio.png"
  encoding-dark="../imgs/ld-dark.drawio.png"

  operation=`DR = mem[PC[15:9] @ pgoffset9];

setcc(DR);`

  examples=`LD R4, COUNT    ;  R4 ← mem[COUNT].`

%}}
Load the register specified by DR from the location specified by pgoffset9 on
the same page as the LD instruction. The condition codes are set, based on
whether the value loaded is negative, zero, or positive.
{{% /instruction %}}

{{% instruction
  mnemonic="LDI"
  short="Load Indirect"

  formats=`LDI DR, LABEL`

  encoding="../imgs/ldi.drawio.png"
  encoding-dark="../imgs/ldi-dark.drawio.png"

  operation=`DR = mem[mem[PC[15:9] @ pgoffset9]];

setcc(DR);`

  examples=`LDI R4, POINTER    ;  R4 ← mem[mem[POINTER]].`

%}}
Load the register specified by DR as follows: Construct an address by
concatenating the top seven bits of the program counter with the pgoffset9
field of the LDI instruction. The contents of memory at that address is the
address of the data to be loaded into DR. The condition codes are set, based on
whether the value loaded is negative, zero, or positive.
{{% /instruction %}}

{{% instruction
  mnemonic="LDR"
  short="Load Base + Offset"

  formats=`LDR DR, BaseR, index6`

  encoding="../imgs/ldr.drawio.png"
  encoding-dark="../imgs/ldr-dark.drawio.png"

  operation=`DR = mem[BaseR + ZEXT(index6)];

setcc(DR);`

  examples=`LDR R4, R2, #10    ;  R4 ← contents of mem[R2 + #10].`

%}}
Load the register specified by DR from the location specified by a base
register and index, as follows: The index is zero-extended to 16 bits and added
to the contents of BaseR to form a memory address. The contents of memory at
this address are loaded into DR. The condition codes are set, based on whether
the value loaded is negative, zero, or positive.
{{% /instruction %}}

{{% instruction
  mnemonic="LEA"
  short="Load Effective Address"

  formats=`LEA DR, LABEL`

  encoding="../imgs/lea.drawio.png"
  encoding-dark="../imgs/lea-dark.drawio.png"

  operation=`DR = PC[15:9] @ pgoffset9;

setcc(DR);`

  examples=`LEA R4, FOO    ;  R4 ← address of FOO.`

%}}
Load the register specified by DR with the address formed by concatenating the
top seven bits of the program counter with the pgoffset9 field of the
instruction. The condition codes are set, based on whether the value loaded is
negative, zero, or positive.
{{% /instruction %}}

{{% instruction
  mnemonic="NOT"
  short="Bitwise Complement"

  formats=`NOT DR, SR`

  encoding="../imgs/not.drawio.png"
  encoding-dark="../imgs/not-dark.drawio.png"

  operation=`DR = ~SR;

setcc(DR);`

  examples=`NOT R4, R2    ;  R4 ← NOT(R2).`

%}}
Perform the bitwise complement operation on the contents of SR and place the
result in DR. The condition codes are set.
{{% /instruction %}}

{{% instruction
  mnemonic="RET"
  short="Return from Subroutine"

  formats=`RET`

  encoding="../imgs/ret.drawio.png"
  encoding-dark="../imgs/ret-dark.drawio.png"

  operation=`PC = R7;`

  examples=`RET    ;  PC ← R7.`

%}}
Load the PC with the value in R7. This causes a return from a previous JSR or
JSRR instruction.
{{% /instruction %}}

{{% instruction
  mnemonic="RTI"
  short="Return from Interrupt"

  formats=`RTI`

  encoding="../imgs/rti.drawio.png"
  encoding-dark="../imgs/rti-dark.drawio.png"

  operation=`NZP = mem[R6];
R6 = R6 - 1;
PC = mem[R6];
R6 = R6 - 1;`

  examples=`RTI    ;  NZP, PC ← top two values popped off stack.`

%}}
Pop the top two elements off the stack; load them into NZP, PC.

<h4>Notes</h4>

On an external interrupt, the initiating sequence pushes the current PC onto
the stack before loading the PC with the starting address of the service
routine. The last instruction in the service routine is RTI, which returns
control to the interrupted program by popping the stack and loading the value
popped into the PC. (This instruction is included in this appendix for
completeness. Its purpose and use are beyond the scope of what is normally
covered in an introductory textbook.)
{{% /instruction %}}

{{% instruction
  mnemonic="ST"
  short="Store Direct"

  formats=`ST SR, LABEL`

  encoding="../imgs/st.drawio.png"
  encoding-dark="../imgs/st-dark.drawio.png"

  operation=`mem[PC[15:9] @ pgoffset9] = SR;`

  examples=`ST R4, COUNT    ;  mem[COUNT] ← R4.`

%}}
Store the contents of the register specified by SR into the memory location
specified by pgoffset9 on the same page as the ST instruction.
{{% /instruction %}}

{{% instruction
  mnemonic="STI"
  short="Store Indirect"

  formats=`STI SR, LABEL`

  encoding="../imgs/sti.drawio.png"
  encoding-dark="../imgs/sti-dark.drawio.png"

  operation=`mem[mem[PC[15:9] @ pgoffset9]] = SR;`

  examples=`STI R4, POINTER    ;  mem[mem[POINTER]] ← R4.`

%}}
Store the contents of the register specified by SR into the memory location
whose address is obtained as follows: Construct an address by concatenating the
top seven bits of the program counter with the pgoffset9 field of the STI
instruction. The contents of memory at that address is the address of the
location to which the data in SR is to be stored.
{{% /instruction %}}

{{% instruction
  mnemonic="STR"
  short="Store Base+Offset"

  formats=`STR SR, BaseR, index6`

  encoding="../imgs/str.drawio.png"
  encoding-dark="../imgs/str-dark.drawio.png"

  operation=`mem[BaseR + ZEXT(index6)] = SR;`

  examples=`STR R4, R2, #10    ;  mem[R2 + #10] ← R4.`

%}}
Store the contents of the register specified by SR into the memory location
whose address is specified as follows: The six-bit offset is zero-extended to
16 bits and added to the contents of BaseR to form a memory address. This is
the address of the location into which the contents of SR is to be stored.
{{% /instruction %}}

{{% instruction
  mnemonic="TRAP"
  short="Operating System Call"

  formats=`TRAP trapvec8`

  encoding="../imgs/trap.drawio.png"
  encoding-dark="../imgs/trap-dark.drawio.png"

  operation=`R7 = PC;
PC = mem[ZEXT(trapvect8)];`

  examples=`TRAP x23    ;  Direct the operating system to execute the "IN" system call.`

%}}
Load the PC with the contents of the memory location obtained by zero-extending
trapvec8 to 16 bits. This is the starting address of the system call
specified by trapvec8. Load R7 with the PC, which enables a return to the
instruction physically following the TRAP instruction in the original program
after the service routine has completed.

<h4>Notes</h4>

Memory locations x0020 through x00FF, 192 in all, are available to contain
starting addresses for system calls specified by their corresponding
trap vectors. This region of memory is called the trap vector table. See Table
A.3. Memory locations x0000 through x001F are not part of the trap vector
table; therefore, x00 through x1F may not be used as trap vectors.
{{% /instruction %}}
