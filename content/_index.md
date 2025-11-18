+++
layout = "wide"
+++

{{< hextra/hero-container cols="1">}}

{{< hextra/hero-badge link="#licensing" >}}
  <div class="hx:w-2 hx:h-2 hx:rounded-full hx:bg-primary-400"></div>
  <span>An open-source learning project</span>
  {{< icon name="book-open" attributes="height=14" >}}
{{< /hextra/hero-badge >}}

<div class="hx:mt-6 hx:mb-6">
{{< hextra/hero-headline >}}
  Build computing from the ground up
{{< /hextra/hero-headline >}}

{{< hextra/hero-section heading="h3" >}}
  *From bits and gates to OSes & beyond*
{{< /hextra/hero-section >}}
</div>

<div class="hx:mb-6">
{{< hextra/hero-subtitle >}}
  An open-source learning suite that reveals how complexity arises from
  simplicity.
  <br>
  A complete journey through the foundations of computer architecture for
  students, educators, and the endlessly curious.
{{< /hextra/hero-subtitle >}}
</div>

{{< hextra/hero-button    text="🚧 Learn"                  link="#" style="margin: calc(var(--hx-spacing)*2)" >}}
{{< hero-button-secondary text="🚧 ISA Documentation"      link="#" style="margin: calc(var(--hx-spacing)*2)" >}}
{{< hero-button-secondary text="🚧 Software Documentation" link="#" style="margin: calc(var(--hx-spacing)*2)" >}}

<div class="hx:mb-12">&nbsp;</div>

{{< /hextra/hero-container >}}

<div class="hx:mx-auto hx:mb-12" style="max-width: min(70rem, var(--hextra-max-page-width))">
  <div class="hx:mt-12">
  {{< hextra/hero-section heading="h2" >}}What is this thing?{{< /hextra/hero-section >}}
  </div>

  If you're curious about how computers really work under the hood, the *Little
  Computer* family is a great place to start.

  The *Little Computer* is a family of *Instruction Set Architectures*
  ([ISAs](https://en.wikipedia.org/wiki/Instruction_set_architecture)) based on
  the Von Neumann model, created by [Yale N.
  Patt](https://users.ece.utexas.edu/~patt/) and [Sanjay J.
  Patel](https://sjp.ece.illinois.edu/) to help students learn the fundamentals
  of computer architecture in a clear and approachable way.

  These architectures are intentionally simple. They use a *very*
  [RISC](https://en.wikipedia.org/wiki/RISC) instruction set, a linear memory
  model, and a small number of registers and addressing modes. Their design
  focuses on being **understandable rather than realistic**, making them ideal
  for learning how a CPU works from the inside out.

  Across the different iterations -- from the early LC-2 to the LC-3 and LC-3b
  -- the overall structure stays consistent. Each version slightly expands on
  the previous one, adding refinements such as new instructions or different bus
  widths while preserving the same conceptual model.

  The most famous ISA in the family is without a doubt the **LC-3**, widely used
  in universities around the world. It has inspired a
  [subreddit](https://reddit.com/r/lc3), a [Wikipedia
  page](https://en.wikipedia.org/wiki/Little_Computer_3), online tools such as
  [lc3web](https://wchargin.com/lc3web/), and countless course materials. Yet
  despite its popularity, complete and freely accessible documentation for these
  architectures is surprisingly fragmented or hard to find.

  This project aims to bring everything together in one place - a clean, open,
  and modern documentation that makes the Little Computer family easier to
  study, explore, and build upon.

  <div class="hx:mt-12">
  {{< hextra/hero-section heading="h2" >}}Why am I doing this?{{< /hextra/hero-section >}}
  </div>

  If you want to learn computer architecture today, you usually face two
  options: either you study a full CISC architecture like x86, which is
  enormously powerful but incredibly complex, or you work with a simplified
  subset of an existing architecture, such as Tiny MC68000, which often removes
  or abstracts away the very mechanisms you're trying to understand.

  By instead learning a compact, coherent, and intentionally simple
  architecture, students can genuinely grasp how computation works --
  instruction execution, addressing, control flow, data movement -- without
  being overwhelmed by historical baggage or modern optimizations. This is
  exactly what makes the Little Computer family so valuable: it provides a
  complete, understandable model of a real CPU without unnecessary complexity.

  I'm building this project to make these ISAs easier to discover and study.
  Much of the existing material is scattered, incomplete, or tied to specific
  textbooks, so offering modern, open, and well-organized documentation felt
  necessary.

  There's also a personal side to it. I'm using this project as a way to learn
  too, both to deepen my understanding of how computers operate at a fundamental
  level and, as a newcomer to retro computing, to explore the kind of
  transparent, elegant designs that defined early systems. The Little Computer
  family captures that spirit perfectly.

  <div class="hx:mt-12">
  {{< hextra/hero-section heading="h2" >}}Roadmap{{< /hextra/hero-section >}}
  </div>

  This project is highly a **work in progress**: things will grow, change, and
  refine as the documentation evolves.

  Before diving into details, here's a high-level overview of where the project
  is heading.

  ### Legend

  * 🛠️ **Work in Progress** - currently being worked on
  * 🎯 **Planned** - part of the main roadmap, not started yet
  * 🚀 **Ambitious** - long-term ideas that would be amazing to explore

  {{% steps %}}

  ### 🛠️ Write clear, complete documentation

  I'd like to explain the basics of computer architecture from the ground up -
  starting with boolean logic and binary representation, then slowly building
  the components of a CPU. It won't be a full university-level architecture
  course, but it will cover the foundations clearly and accessibly.

  I also want the documentation to be filled with citations, so anyone can
  verify sources and understand where each detail comes from. The existing LC
  material is scattered or unclear, so consolidating everything into one open,
  trustworthy reference is essential.

  ### 🎯 Build a basic development suite

  Once the docs are solid, the next step is creating simple command-line tools:

  * An **emulator**,
  * An **assembler**,
  * A **linker**,
  * And **small utilities** for experimenting with programs.

  The idea is to offer lightweight, modern, educational tools that don't depend
  on outdated software.

  ### 🎯 Create a graphical learning environment

  After the CLI tools are stable, the goal is to develop a GUI environment with:

  * An integrated **editor**,
  * A **register/memory inspector**,
  * And a **step-by-step execution view**.

  Everything in one cohesive, clean, **expandable** application.

  ### 🚀 Build a physical implementation (FPGA)

  Inspired by projects like [Ben Eater's "Building a 6502 computer from scratch"
  series](https://youtube.com/playlist?list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH),
  a long-term goal is to bring the LC architecture into real hardware using an
  [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array).

  The idea is to recreate the experience of wiring the datapath by hand: LEDs
  for registers, switches for inputs, clock controls, memory chips, and a
  physical layout where you can literally trace how instructions move through
  the system. It would be an incredible way for students (and for me!) to *see*
  the CPU come alive, one wire at a time.

  ### 🚀 Port classic software

  Porting small classic programs: DOOM, Tetris, MS-BASIC, tiny shells, demos, or
  classic educational tools

  This would be a fun and effective way to stress-test both the architecture and
  the entire toolchain.

  The goal isn't just to "make things run", but to explore what it means to
  adapt real software to a minimal ISA: rewriting rendering loops, designing
  tiny I/O layers, optimizing for limited memory, and understanding how classic
  programs were structured on simple computers of the past.

  These ports would also serve as great examples for students, showing how
  real-world logic and old-school game mechanics map onto assembly instructions,
  registers, control flow, and memory access patterns.

  ### 🚀 Porting a compiler toolchain

  A long-term goal is to experiment with bringing a modern compilation toolchain
  to the platform, for example by developing a minimal LLVM backend. This would
  make it possible to compile higher-level languages and would open the door to
  teaching concepts like code generation, optimization, and compiler design in a
  very approachable way.

  ### 🚀 Build a small UNIX-like operating system

  With a stable architecture and toolchain, building a tiny operating system
  becomes a realistic and exciting challenge. The idea is not to recreate a full
  modern OS, but to implement the core concepts that made early UNIX systems
  elegant and teachable: a simple process model, a basic exception/interrupt
  system, low-level device drivers, a minimal filesystem, and a tiny shell to
  run programs.

  Such an OS would act as the "glue" that ties together everything learned so
  far -- instruction execution, memory management, I/O routines, and
  system-level programming -- while giving students a clear view of how
  operating systems are structured at their simplest and most transparent level.

  {{% /steps %}}

  <div class="hx:mt-12" id="licensing">
  {{< hextra/hero-section heading="h2" >}}Licensing{{< /hextra/hero-section >}}
  </div>

  This project is entirely open source!

  The documentation is distributed under the [Creative Commons
  Attribution-NonCommercial-ShareAlike
  4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) license, and the
  source code is distributed under the [GNU Affero General Public License
  v3.0](https://choosealicense.com/licenses/agpl-3.0/). Feel free to take this
  work, study it, modify it, improve it, and redistribute it &nbsp;;&nbsp;)

  If you feel generous, please consider opening a PR on the project's GitHub
  page so that everyone can benefit from your contributions.

  <br>
  <br>

  {{< hextra/feature-grid cols=2 >}}
    {{< hextra/feature-card
      title="Little Emulator"
      icon="github"
      subtitle="Check out the project's code!"
      link="https://github.com/little-emulator"
    >}}
  {{< /hextra/feature-grid >}}

</div>
