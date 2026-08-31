+++
title = "Memory"
weight = 110
+++

LC-2 has a 16-bit address bus, giving a linear address space of 65,536
locations, numbered from `0x0000` to `0xFFFF`. Memory is canonically divided
into 2<sup>7</sup> pages of 2<sup>9</sup> words each. There is no segmentation,
no paging, and no virtual memory: every address maps directly to a physical
location.[^lc2-overview]

[^lc2-overview]: {{< cite-ics edition="1" chapter="Appendix A: The LC-2 ISA" page="429" >}}

Addressability is 16 bits: each location in memory holds exactly one word,
matching the width of the data bus. A single memory access always transfers a
full 16-bit value, never a partial word, which is also why the concept of
endianness does not apply here: there is no multi-byte value to order within a
single access.

## Memory Map

The memory map below reflects the conventions of the standard LC-2 operating
system, not the ISA itself. The ISA only defines the trap vector table at
`0x0000 - 0x00FF`. Everything else, from the location of the OS to the boundary
of userspace, is a software convention rather than a hardware requirement.

| Range               | Purpose                                                                       |
|:-------------------:|:-----------------------------------------------------------------------------:|
| `0x0000` - `0x00FF` | Trap Vector Table[^lc2-trap] / [Interrupt Vector Table](..#interrupt-support) |
| `0x0100` - `0x2FFF` | Operating System[^matt-postiff-guide]                                         |
| `0x3000` - `0xCFFF` | Userspace                                                                     |
| `0xD000` - `0xFFFF` | Device Registers                                                              |

[^lc2-trap]: {{< cite-ics edition="1" chapter="Appendix A.3 The Instruction Set" page="448" page-end="449" >}}
[^matt-postiff-guide]: {{< cite-web
  author="Postiff, Matthew A."
  title="LC-2 Programmer's Reference and User Guide"
  site="University of Texas"
  url="https://www.cs.utexas.edu/~fussell/courses/cs310h/simulator/lc2.pdf"
  format="PDF"
  accessed="August 31, 2026"
  url-archived="https://web.archive.org/web/20251205052350/https://www.cs.utexas.edu/~fussell/courses/cs310h/simulator/lc2.pdf"
  url-archived-date="December 05, 2025"
>}}

## Stack

The ISA does not define a stack as a distinct hardware structure, but it
assumes one exists by convention. R6 is used as the stack pointer, and the
stack is assumed to grow toward `0xFFFF`.

This convention is not optional in practice: the `RTI` instruction relies on it
directly. When an interrupt is serviced, the CC and PC are pushed onto the
stack. `RTI` pops them back in reverse order to resume execution. Any deviation
from the R6 convention would break interrupt handling.[^lc2-rti]

[^lc2-rti]: {{< cite-ics edition="1" chapter="Appendix A.3 The Instruction Set" page="444" >}}

## Memory-Mapped I/O

LC-2 uses memory-mapped I/O: devices are accessed using the same load and store
instructions used for regular memory, with no dedicated I/O instructions in the
ISA.[^lc2-mmio]

[^lc2-mmio]: {{< cite-ics edition="1" chapter="8.1.2 Memroy Mapped I/O Versus Special Input/Output Instructions" page="158" >}}

The standard LC-2 operating system maps the following devices into the top of
the address space. These are not defined by the ISA: they are the devices
assumed by the reference implementation and its OS.

| Address  | Register                                                | Description                                                                                                             |
|:--------:|:-------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------|
| `0xF3FC` | Video Status Register (`CRTSR`)[^lc2-devices-registers] | Bit 15, the ready bit, indicates whether the video device is ready to receive another character to print on the screen. |
| `0xF3FD` | Horizontal Screen Position[^matt-postiff-guide]         | Not implemented.                                                                                                        |
| `0xF3FE` | Vertical Screen Position                                | Not implemented.                                                                                                        |
| `0xF3FF` | Video Data Register (`CRTDR`)                           | A character written in the low byte of this register will be displayed on screen.                                       |
| `0xF400` | Keyboard Status Register (`KBSR`)                       | Bit 15, the ready bit, indicates whether the keyboard has received a new character.                                     |
| `0xF401` | Keyboard Data Register (`KBDR`)                         | The lower byte contain the last character typed on the keyboard.                                                        |
| `0xFFFF` | Machine Control Register (`MCR`)                        | Bit 15 is the clock enable bit. When cleared, instruction processing stops because the clock signal stops pulsing.      |

[^lc2-devices-registers]: {{< cite-ics edition="1" chapter="Appendix A: The LC-2 ISA" page="430" >}}
