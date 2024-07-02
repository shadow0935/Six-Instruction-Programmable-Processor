# Six Instruction Programmable Processor

## Introduction

This project implements a six-instruction programmable processor with gate-level implementation in **Verilog**. The processor supports a basic set of instructions to demonstrate the functionality of a simple CPU.

## Processor Details

The processor is designed to handle the following instructions:
- **MOV Ra, d**: Move the value from data memory at address `d` to register `Ra`.
- **MOV d, Ra**: Move the value from register `Ra` to data memory at address `d`.
- **ADD Ra, Rb, Rc**: Add the values in registers `Rb` and `Rc`, and store the result in register `Ra`.
- **MOV Ra, #C**: Move the constant value `C` to register `Ra`.
- **SUB Ra, Rb, Rc**: Subtract the value in register `Rc` from the value in register `Rb`, and store the result in register `Ra`.
- **JMPZ Ra, offset**: Jump to the instruction at the current program counter plus `offset` if the value in register `Ra` is zero.

## Data Path

The data path consists of the following components:
- **Data Memory**: Stores the data that can be accessed by the instructions.
- **n-bit 2x1 MUX**: Used for selecting inputs based on control signals.
- **Register File**: Contains the registers used by the processor.
- **ALU (Arithmetic Logic Unit)**: Performs arithmetic and logical operations.

## Controller

The controller part includes:
- **Instruction Memory**: Stores the instructions to be executed by the processor.
- **Program Counter (PC)**: Keeps track of the address of the next instruction to be executed.
- **Instruction Registers**: Holds the current instruction being executed.
- **Controller**: Manages the control signals for the data path components based on the current instruction.

## Finite State Machine (FSM)

The FSM is used to control the sequence of operations in the processor. The FSM ensures that each instruction is executed correctly by generating the appropriate control signals at each clock cycle.

## Data Path Diagram

![image](https://github.com/shadow0935/Six-Instruction-Programmable-Processor/assets/169816376/278ece69-048b-4eaa-8e6a-c61cc3a1bb83)

## FSM Diagram

![image](https://github.com/shadow0935/Six-Instruction-Programmable-Processor/assets/169816376/16ef8584-b831-4468-ad49-66a39f161048)

## Usage

1. Clone the repository.
2. Open the project in your preferred FPGA/ASIC design software.
3. Load the provided design files.
4. Simulate or synthesize the design to observe the processor in action.
