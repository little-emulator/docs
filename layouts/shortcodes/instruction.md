{{- /*
instruction - Standardized instruction reference card, following the layout
used in the Patt & Patel textbook: mnemonic title, short description, assembler
formats, encoding diagram, high-level operation, and usage examples.

@param {string} mnemonic       Instruction mnemonic(s), comma-separated if more
                               than one (e.g. "ADD" or "JSR, JSRR").
@param {string} short          Short two-to-three word description (e.g.
                               "Addition").
@param {string} formats        Assembler format(s). Use a backtick-quoted
                               string for multiple lines.
@param {string} encoding       Filename of the encoding diagram
@param {string} encoding-dark  Optional dark mode variant of the encoding
                               diagram. If set, `encoding` is only shown in
                               light mode and this is shown in dark mode.
@param {string} operation      High-level operation, typically pseudo-C. Use a
                               backtick-quoted string for multiple lines.
@param {string} examples       Usage examples in LC-2 assembly. Use a
                               backtick-quoted string for multiple lines.

@example {{% instruction
  mnemonic="ADD"
  short="Addition"

  formats=`ADD DR, SR1, SR2
ADD DR, SR1, imm5`

  encoding="add.drawio.png"
  encoding-dark="add-dark.drawio.png"

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

*/ -}}

{{- $mnemonic     := .Get "mnemonic" -}}
{{- $short        := .Get "short" -}}
{{- $formats      := .Get "formats" -}}
{{- $encoding     := .Get "encoding" -}}
{{- $encodingDark := .Get "encoding-dark" -}}
{{- $operation    := .Get "operation" -}}
{{- $examples     := .Get "examples" -}}
{{- $description  := .Inner -}}

### {{ $mnemonic }}

> {{ $short }}

<h4>Assembler Formats</h4>

```
{{ $formats }}
```

<h4>Encoding</h4>

{{ if $encodingDark }}
<img src="{{ $encoding }}" alt="{{ $mnemonic }} instruction encoding" class="hx:dark:hidden">
<img src="{{ $encodingDark }}" alt="{{ $mnemonic }} instruction encoding" class="hx:hidden hx:dark:block">
{{ else }}
<img src="{{ $encoding }}" alt="{{ $mnemonic }} instruction encoding">
{{ end }}

<h4>Operation</h4>

```c
{{ $operation }}
```

<h4>Description</h4>

{{ $description }}

<h4>Examples</h4>

```
{{ $examples }}
```
