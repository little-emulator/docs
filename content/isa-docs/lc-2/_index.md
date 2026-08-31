+++
title = "LC-2"
weight = 100
+++

LC-2 is the first architecture in the Little Computer family that looks like a
real ISA. Built as a successor to the minimalist LC-1,[^lc1-successor] it
introduced eight general-purpose registers and a three-state condition code
system, the foundation that every subsequent architecture in the family would
inherit.[^lc-family-evolution]

[^lc1-successor]: {{< cite-ics edition="1" chapter="1. Welcome Aboard" page="2" >}}
[^lc-family-evolution]: {{< cite-talk
  author="Patt, Yale N."
  title="LC-3, x86, or MIPS: The First ISA for Students to Study"
  type="Keynote"
  event="Workshop on Computer Architecture Education"
  location="San Diego, CA"
  date="June 9, 2007"
  url="https://www.csc2.ncsu.edu/faculty/efg/wcae/ISCA2007/FinalProgram.html"
  format="PowerPoint presentation"
  accessed="June 8, 2026"
  url-archived="https://web.archive.org/web/20250129103001/https://www.csc2.ncsu.edu/faculty/efg/wcae/ISCA2007/FinalProgram.html"
  url-archived-date="January 29, 2025"
>}}

LC-2 operates on a 16-bit data bus and a 16-bit address bus, giving a linear
address space of 65,536 word-sized locations, 128 KiB of addressable memory in
total. Every instruction is exactly 16 bits wide, with the top 4 bits reserved
for the opcode. This fixed encoding means that the opcode, operands, and any
immediate values must all fit within those 16 bits, a constraint that shapes the
design of every instruction in the set.[^lc2-overview]

[^lc2-overview]: {{< cite-ics edition="1" chapter="Appendix A: The LC-2 ISA" page="429" >}}

## Registers

LC-2 has a small but complete set of registers. All registers are 16 bits wide,
matching the data bus width of the architecture.

### General-Purpose Registers

LC-2 provides eight general-purpose registers, named R0 through R7. They are
symmetric: no register has a special hardware role, and any of them can be used
as a source or destination in any instruction that operates on
registers.[^lc2-overview] That said, two registers have a conventional role: R6
is typically used as the stack pointer,[^lc2-stack] [^lc2-rti] and R7 is used
by some instructions to store the return address.[^lc2-jsr-jsrr] [^lc2-ret]
[^lc2-trap] See the [instructions page](instructions/) for details.

[^lc2-stack]: {{< cite-ics edition="1" chapter="10.1.3 Implementation in Memory" page="197" page-end="200" >}}
[^lc2-rti]: {{< cite-ics edition="1" chapter="Appendix A.3 The Instruction Set" page="444" >}}
[^lc2-jsr-jsrr]: {{< cite-ics edition="1" chapter="Appendix A.3 The Instruction Set" page="436" page-end="437" >}}
[^lc2-ret]: {{< cite-ics edition="1" chapter="Appendix A.3 The Instruction Set" page="443" >}}
[^lc2-trap]: {{< cite-ics edition="1" chapter="Appendix A.3 The Instruction Set" page="448" >}}

### Special-Purpose Registers

Beyond the general-purpose registers, LC-2 has some special-purpose registers
that control the execution of the processor. None of these registers are
directly accessible from assembly, with the exception of the CC, which is
implicitly read by conditional branch instructions.

* The **Program Counter** (**PC**) holds the address of the next instruction to
  be fetched from memory. It is incremented by 1 after each fetch, before the
  instruction is executed, so that by the time the instruction runs, the PC
  already points to the following one.[^lc2-fetch]

  [^lc2-fetch]: {{< cite-ics edition="1" chapter="4.2.2 The Instruction Cycle" page="82" page-end="83" >}}

* The **Instruction Register** (**IR**) holds the instruction currently being
  executed. After the PC is used to fetch an instruction from memory, the
  instruction is loaded into the IR, where it remains for the duration of the
  decode and execute phases.[^lc2-fetch]

* The **Memory Address Register** (**MAR**) holds the address of the memory
  location to be accessed. Before any memory operation, the address is loaded
  into the MAR, which then drives the address bus during the read or write
  cycle.[^lc2-memory]

  [^lc2-memory]: {{< cite-ics edition="1" chapter="4.1.1 Memory" page="75" page-end="77" >}}

* The **Memory Data Register** (**MDR**) holds the data being transferred to or
  from memory. On a read, the MDR receives the value fetched from the location
  addressed by the MAR. On a write, the MDR holds the value to be stored before
  it is placed onto the data bus.[^lc2-memory]

* The **Condition Code** register (**CC**) is a 3-bit register that tracks the
  sign of the last value written to any general-purpose register. It has three
  mutually exclusive states: N (negative), Z (zero), and P (positive). Exactly
  one of the three bits is set at any given time.[^lc2-overview]

  Not all instructions update the CC. Only instructions that write a value to a
  general-purpose register will modify it. As an example, an `ADD` instruction
  that stores its result in R0 will update the CC based on the sign of that
  result, while a `STR` instruction that writes to memory will
  not.[^lc2-condition-codes]

  [^lc2-condition-codes]: {{< cite-ics edition="1" chapter="5.1.7 Condition Codes" page="95" >}}

## Startup Behavior

The ISA does not specify a default starting address or reset vector. Where the
PC is initialized when the processor powers on or resets is left entirely to
the implementation. {{< citation-needed >}}

## Interrupt Support

LC-2 provides support for vectored interrupts. When an interrupt is serviced,
the processor pushes the current PC and CC onto the stack, then reads an 8-bit
value from the interrupting device, called the interrupt vector (`INTV`).
`INTV` is zero-extended to 16 bits and used as a memory address into the
interrupt table: the value stored at that address is loaded into the PC,
transferring control to the interrupt handler.{{< citation-needed >}}

The `RTI` (Return from Interrupt) instruction reverses this process, popping
the PC and CC from the stack to resume the interrupted
program.{{< citation-needed >}}

Beyond this, the ISA does not specify the interrupt protocol in further detail:
the bus signaling and acknowledgment mechanism used to deliver `INTV` are left
to the implementation.
