# Harvard Five-Stage Pipeline Processor

## Overview
This project implements a Harvard architecture-based five-stage pipeline processor that supports exception and interrupt handling, along with an assembler.

## Table of Contents
- [Introduction](#introduction)
- [Pipeline Stages](#pipeline-stages)
- [Exception and Interrupt Handling](#exception-and-interrupt-handling)
- [Assembler](#assembler)
- [Installation](#installation)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction
This project demonstrates a Harvard five-stage pipeline processor designed for educational purposes. The processor can handle various types of instructions, manage exceptions and interrupts effectively, and includes an assembler to convert assembly language code into machine code.

## Pipeline Stages
The processor consists of the following stages:
1. **Fetch (IF)**: Instruction fetch stage.
2. **Decode (ID)**: Instruction decode stage.
3. **Execute (EX)**: Execution of the instruction.
4. **Memory (MEM)**: Memory access stage.
5. **Write Back (WB)**: Writing the results back to the register.

## Exception and Interrupt Handling
The processor is capable of handling:
- **Exceptions**: Conditions such as divide by zero, overflow, invalid instructions.
- **Interrupts**: External events that temporarily halt the current execution to service the interrupt.

## Assembler
The assembler translates assembly language instructions into machine code that the processor can execute. It supports a predefined set of instructions and directives specific to this processor's architecture.

## Installation
To set up the project locally, follow these steps:
1. Clone the repository:
   ```sh
   git clone https://github.com/mohamed07abdelaziz/HarveredProcessor.git
