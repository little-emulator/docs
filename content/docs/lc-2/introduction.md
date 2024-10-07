+++
title = "Introduction"
weight = 210
+++

The **LC-2** is a theorical CPU created by [Yale N.
Patt](https://users.ece.utexas.edu/~patt/) and [Sanjay J.
Patel](https://sjp.ece.illinois.edu/) in their book "_Introduction to Computing
Systems: from Bits & Gates to C & Beyond (1st edition)_" (ISBN 9780072376906).

It's the evolution of the **LC-1**, another theoretical created by the same
authors.[^1] [^2]

[^1]: Patt, Y. N., & Patel, S. J. (2001). 1.2 How We Will Get There. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., p. 2). essay, McGraw Hill.

[^2]: Patt, Y. N. (2007, June 9). LC-3: How it has evolved. In _LC-3, x86, or
      ???: The first ISA for students_.
      [https://www.csc2.ncsu.edu/faculty/efg/wcae/ISCA2007/patt.ppt](https://web.archive.org/web/20240413163221/https://www.csc2.ncsu.edu/faculty/efg/wcae/ISCA2007/patt.ppt)
      The University of Texas at Austin WCAE Workshop, ISCA (_Archived on
      2024-04-13_)

On the official book's website,
[mhhe.com/patt](https://web.archive.org/web/20170421220229/http://www.mhhe.com/engcs/compsci/patt/)
(_Archived on 2017-04-21_), it is possible to download the **original
assembler** and **emulator** for Windows and UNIX-based operating systems.

## The LC-2 structure

The LC-2 is a **16-bit word** CPU composed of: [^3]

[^3]: Patt, Y. N., & Patel, S. J. (2001). Appendix A: The LC-2 ISA. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 429–449). essay, McGraw Hill.

* Eight 16-bit **general purpose registers**;
* A 16-bit **program counter**;
* A **16-bit address bus** with a **16-bit data bus** for interfacing with the
  main memory and I/O peripherals;
* Three flags, named "**condition codes**", that indicate if the result of the
  last instruction is negative (`N`), zero (`Z`) or positive (`P`). They are
  **mutually exclusive**;
* A very slim instruction set: every instruction has a **4-bit opcode**, for a
  total of 16 instructions.

The instructions are divided in three categories:

* Three **arithmetical instructions**: `ADD` and `AND`, both with an
  **immediate** 5-bit sign-extended value or with **another register**, and
  `NOT`;
* Six instructions that **change the program counter**: `BR`, `JMP`/`JSR`,
  `JMPR`/`JSRR`, `TRAP`, `RET` and `RTI`;
* Seven instruction for **loading** and **storing** data into the **memory**:
  `LD`, `LDI`, `LDR`, `LEA`, `ST`, `STI` and `STR`.

{{< callout type="info" >}}
For more information check the "[Intruction Set](../instruction-set)" chapter.
{{< /callout >}}

Every arithmetical operation can be obtained through [De Morgan's
laws](https://en.wikipedia.org/wiki/De_Morgan's_laws) and subtraction can be
implemented by using [two's
complement](https://en.wikipedia.org/wiki/Two's_complement) representation.

The addressing space is divided in 2⁷ **pages** of 2⁹ words each for
convenience.

The CPU supports **vectored interrupts**, by asking for a 8-bit index into the
**interrupt vector** (INTV) when it's interrupted.[^4] More informations about
interrupts are available at the [dedicated chapter](../interrupts).

[^4]: Patt, Y. N., & Patel, S. J. (2001). Appendix C.6: Interrupt Control. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 481–485). essay, McGraw Hill.
