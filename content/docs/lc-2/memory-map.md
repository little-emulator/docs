+++
title = "Memory Map"
weight = 230
+++

The memory on the LC-2 is divided in 2¹⁶ cells of 16-bit words each, for a
grand total of 1Mb (with the small "b" for *bits*, not *bytes*).[^1]

[^1]: Patt, Y. N., & Patel, S. J. (2001). Appendix A.1 Overview. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., p. 429). essay, McGraw Hill.

The **first 256 words** (`0x0000`-`0x00FF`) of memory contain the **trap
vector**.[^2] For more informations check the ["Instruction
Set"](../instruction-set) and the ["Trap" chapters](../trap).

[^2]: Patt, Y. N., & Patel, S. J. (2001). 5.4.5 The TRAP Instruction. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 106-107). essay, McGraw Hill.

The I/O is **memory mapped** (see the [dedicated chapter](../i-o)) and usually
the lower portion of the addressing space is reserved to the **peripherals**.
For example the memory range `0xF3FC`-`0xF401` is reserved for the **monitor
output** and the **keyboard input**.[^3] [^4]

[^3]: Patt, Y. N., & Patel, S. J. (2001). 8.2 Input from the Keyboard. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 160-161). essay, McGraw Hill.

[^4]: Patt, Y. N., & Patel, S. J. (2001). 8.3 Output to the Monitor. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 162-163). essay, McGraw Hill.

Even the **halt logic** is memory mapped to address `0xFFFF`[^5] (More info on
the ["I/O" chapter](../i-o)).

[^5]: Patt, Y. N., & Patel, S. J. (2001). 4.4 Stopping the Computer. In
      _Introduction to Computing Systems: from Bits & Gates to C & Beyond_ (1st
      ed., pp. 85-86). essay, McGraw Hill.

The **user code** usually starts at address `0x3000` and ends at `0xCFFF` for a
total of **40k words**.[^6]

[^6]: Postiff, M. (n.d.). 2.8 The LC-2 Memory Map. In _LC-2 Programmer’s
      Reference and User Guide_.
      [https://cs.utexas.edu/~fussell/courses/cs310h/simulator/lc2.pdf](https://web.archive.org/web/20240928102747/https://www.cs.utexas.edu/~fussell/courses/cs310h/simulator/lc2.pdf)
      (_Archived on 2024-09-28_)

The **operating system** code is usually placed into the address range
`0x0100`-`0x2FFF` (~12k words) and it usually contains the **trap routines**,
even if --- on the original emulator --- the `HALT` trap subroutine and the
"Invalid Trap" subroutine are placed at `0xFD70` and `0xFD00` respectively.

If you want a dump of the **original emulator memory** contents you can
download the version I extracted below:

{{< cards cols="2" >}}
  {{< card
    link="../lc2-memory-dump.bin.gz"
    title="LC-2 Memory Dump"
    icon="download"
  >}}
{{< /cards >}}

To sum up, this is the complete memory map:

{{< cards cols="2" >}}
  {{< card
    title="LC-2 Memory Map"
    link="../lc2-memory-map.drawio.png"
    image="../lc2-memory-map.drawio.png"
  >}}
{{< /cards >}}
