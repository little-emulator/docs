+++
title = "ISA Documentation"

comments = false
breadcrumbs = false

cascade.type = "docs"
+++

The best way to understand a CPU is to take one apart. The Little Computer
family was designed with exactly that in mind: every detail is intentional,
every constraint has a reason. The three canonical architectures (LC-2, LC-3,
and LC-3b) were built to be studied, not just used, and their internal structure
reflects that philosophy at every level.

At the core, all three share the same foundation. The address bus is 16 bits
wide, giving a linear address space of 65,536 locations, no segmentation, no
paging, no virtual memory. Each architecture uses eight general-purpose
registers (R0-R7), a program counter (PC), and a 3-bit condition code register
(CC) that tracks the sign of the last result written to a register: negative,
zero, or positive. Every instruction is exactly 16 bits wide, with the top 4
bits reserved for the opcode, a constraint that shapes the design of every
instruction in the set.

Each successive version refines this foundation rather than replacing it. LC-2
and LC-3 pair the 16-bit address bus with a 16-bit data bus, meaning each memory
location holds a full 16-bit word - 128 KiB of addressable memory in total.
LC-3b narrows the data bus to 8 bits: memory locations hold a single byte,
halving the addressable memory to 64 KiB and introducing byte-level memory
operations absent in the other two. LC-3 and LC-3b also add privilege levels - a
distinction between user mode and supervisor mode - which the original LC-2 does
not have.

What none of them have is equally telling: no flags register, no status
register, no variable-length instructions, no complex addressing hierarchies.
The simplicity is not a limitation, it is the point.

Beyond the canonical three, two other architectures are documented here. LC-1
predates LC-2 and represents the earliest iteration of the family: simpler, more
constrained, and rarely discussed today. LC-3.2 sits at the other end: an
unofficial extension that expands the address space to 32 bits and reduces the
word size to 8 bits, bringing the family closer to the real-world architectures
it was never meant to replicate.



## How the Family Evolved

{{% steps %}}

### LC-1

The starting point of the family. An accumulator-based architecture with a
single register, a 13-bit address space, and just 8 instructions. Extremely
minimal by design. Closer to a teaching toy than a real CPU.

### LC-2

LC-2 marks the transition from a single-accumulator model to a proper register
file. The initial revision introduced 4 registers and N,Z condition codes. This
is a first step away from the extreme minimalism of LC-1.

The final revision settled on 8 registers (R0-R7) and three condition codes (N,
Z, P), the blueprint that all subsequent canonical architectures would inherit.
The result is an architecture that feels closer to early 8-bit CPUs like the
Intel 8080: still simple, but no longer a toy.

### LC-3

The most widely known architecture in the family. The initial revision
introduced a stack that grows toward zero, PC-relative offsets using sign
extension instead of zero extension, and register-relative addressing with
signed offsets.

The revised version added privileged memory, available in two models: fixed and
selectable. LC-3 has been adopted by numerous universities as the basis for
introductory computer architecture courses.

### LC-3b

A variant of LC-3 with an 8-bit data bus instead of 16-bit, halving the
addressable memory to 64 KiB but introducing byte-level memory operations.

Working at the byte level makes LC-3b the closest of the canonical architectures
to how real-world CPUs actually handle memory.

### LC-3.2

An unofficial extension, not created by Patt and Patel, that expands the address
bus to 32 bits and narrows the data bus to 8 bits - the same combination used by
early x86 processors. It is the only architecture in the family that bridges the
gap between the LC teaching model and real-world CPU design, which is what makes
it worth studying.

{{% /steps %}}



## At a Glance

| ISA    | Data Bus Width | Address Bus Width | Memory  | Registers                          | Instruction Width         | Privilege Levels | Status      |
|:------:|:--------------:|:-----------------:|:-------:|:----------------------------------:|:-------------------------:|:----------------:|:-----------:|
| LC-1   | 16-bit         | **13-bit**        | 16 kiB  | **One 16-bit accumulator**         | 16-bit (**3-bit** opcode) | No               | **Legacy**  |
| LC-2   | 16-bit         | 16-bit            | 128 kiB | Eight 16-bit registers (R0-R7)     | 16-bit (4-bit opcode)     | No               | Canonical   |
| LC-3   | 16-bit         | 16-bit            | 128 kiB | Eight 16-bit registers (R0-R7)     | 16-bit (4-bit opcode)     | Yes (2)          | Canonical   |
| LC-3b  | **8-bit**      | 16-bit            | 64 kiB  | Eight 16-bit registers (R0-R7)     | 16-bit (4-bit opcode)     | Yes (2)          | Canonical   |
| LC-3.2 | **8-bit**      | **32-bit**        | 4 GiB   | **Eight 32-bit registers** (R0-R7) | 16-bit (4-bit opcode)     | Yes (2)          | **Variant** |



## A Note on Sources

All data in this section is sourced from primary references: the original books,
course materials, and official publications by Patt and Patel. Every claim is
cited. If you spot an error or know of a better source, contributions are
[welcome via GitHub](https://github.com/little-emulator/docs/issues).



## Explore the Architectures

Each architecture in the family has its own dedicated reference page,
documenting the instruction set, registers, memory model, and encoding in full
detail.

### Core Architectures

<br>
{{< hextra/feature-grid cols="2" >}}
  {{< hextra/feature-card title="LC-2"  icon="chip" link="lc-2" >}}
  {{< hextra/feature-card title="LC-3"  icon="chip" link="lc-3" >}}
  {{< hextra/feature-card title="LC-3b" icon="chip" link="lc-3b" >}}
{{< /hextra/feature-grid >}}

### Beyond the Canon

<br>
{{< hextra/feature-grid cols="2" >}}
  {{< hextra/feature-card title="LC-1"   icon="bookmark" link="lc-1"   subtitle="**Legacy**: The accumulator-based predecessor" >}}
  {{< hextra/feature-card title="LC-3.2" icon="cube"     link="lc-3.2" subtitle="**Variant**: An unofficial 32-bit extension" >}}
{{< /hextra/feature-grid >}}
