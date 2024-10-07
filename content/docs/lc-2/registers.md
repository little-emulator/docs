+++
title = "Registers"
weight = 220
+++

The LC-2 has eight 16-bit wide **general purpose registers** (**GPR**), named
from `R0` to `R7`.

In the instructions they are represented as a number from `000₂` (`R0`) to
`111₂` (`R7`).[^1]

[^1]: Patt, Y. N., & Patel, S. J. (2001). Appendix A.1 Overview. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., p. 429). essay, McGraw Hill.

None of the registers has a **special meaning**, except for:

* `R6`, that is used as the **stack pointer**.

  In the LC-2 architecture the stack is used when an **interrupt is triggered**
  or when the `RTI` **instruction is executed**[^2] [^3] and it grows towards
  `0xFFFF`;[^4]

  More informations about interrupts are available at the [dedicated
  chapter](../interrupts).

  [^2]: Patt, Y. N., & Patel, S. J. (2001). Appendix A.3 The Instruction Set.
        In _Introduction to Computing Systems: from Bits & Gates to C & Beyond_
        (1st ed., p. 444). essay, McGraw Hill.

  [^3]: Patt, Y. N., & Patel, S. J. (2001). Appendix C.1 Interrupt Control.
        In _Introduction to Computing Systems: from Bits & Gates to C & Beyond_
        (1st ed., pp. 481-485). essay, McGraw Hill.

  [^4]: Patt, Y. N., & Patel, S. J. (2001). 10.1 The Stack - A Very Important
        Storage Structure. In _Introduction to Computing Systems: from Bits &
        Gates to C & Beyond_ (1st ed., pp. 195-201). essay, McGraw Hill.

* `R7`, that contains the **return pointer** when a subroutine is called.

  When a subroutine is called with the `JSR`, `JSRR` or `TRAP` instructions the
  value of the **program counter** is saved into `R7` and it's restored with
  the `RET` instruction.[^5] [^6]

  [^5]: Patt, Y. N., & Patel, S. J. (2001). 9.2 Subroutine Calls/Returns. In
        _Introduction to Computing Systems: from Bits & Gates to C & Beyond_
        (1st ed., pp. 181-184). essay, McGraw Hill.

  [^6]: Patt, Y. N., & Patel, S. J. (2001). Appendix A.3 The Instruction Set.
        In _Introduction to Computing Systems: from Bits & Gates to C & Beyond_
        (1st ed., pp. 436-437-443-448). essay, McGraw Hill.

## Non-general purpose registers

Other than the **GPRs**, a few other register exist:

* The **program counter** (**PC**), a 16-bit register that contains the
  **address** of the next instruction to be executed;
* The **instruction register** (**IR**), a 16-bit register that stores the
  **instruction** that is being run;

* The **memory address register** (**MAR**), a 16-bit register that stores the
  **address** to be sent on the address bus;[^7]
* The **memory data register** (**MDR**), a 16-bit register that stores the
  **word** to be sent or to be received on the data bus;[^7]

  [^7]: Patt, Y. N., & Patel, S. J. (2001). 4.1.1 Memory. In _Introduction to
        Computing Systems: from Bits & Gates to C & Beyond_ (1st ed., pp.
        75-77). essay, McGraw Hill.

* The **condition codes** (**CC**), a 3-bit register that is updated whenever a
  GPR is updated.[^8]

  [^8]: Patt, Y. N., & Patel, S. J. (2001). 5.1.7 Condition Codes. In
        _Introduction to Computing Systems: from Bits & Gates to C & Beyond_
        (1st ed., p. 95). essay, McGraw Hill.
