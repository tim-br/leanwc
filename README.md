# leanwc

A Lean 4 implementation of the Unix `wc` (word count) command.

## Overview

This project implements a basic version of `wc` that counts lines, words, and bytes in text files. It demonstrates file I/O, stream processing, and recursive parsing in Lean 4.

## Features

- Count lines, words, and bytes in files
- Read from stdin or file arguments
- Process multiple files with totals
- Output format matches standard `wc`: `lines words bytes`

## Installation

Build the project using Lake:

```bash
lake build
```

## Usage

Count from a file:
```bash
lake exe leanwc <FILENAME>
```

Count from multiple files:
```bash
lake exe leanwc file1.txt file2.txt
```

Count from stdin:
```bash
echo "hello world" | lake exe leanwc
cat myfile.txt | lake exe leanwc
```

## Implementation Notes

The implementation uses:
- Byte-by-byte stream processing with partial recursive functions
- Whitespace detection to delimit words
- Newline counting for line numbers
- Accumulation across multiple files

Word boundaries are detected by whitespace transitions, similar to the standard `wc` behavior.
