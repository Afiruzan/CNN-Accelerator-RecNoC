# CNN Accelerator based on RecNoC Architecture

This repository contains a SystemVerilog implementation of a CNN accelerator
based on the reconfigurable cluster-based Network-on-Chip (RecNoC) architecture
presented in IEEE paper 07238097.

## Architecture
- Intra-cluster: Bus-based multicast for efficient neuron communication
- Inter-cluster: Reconfigurable configuration switches for low-latency long links
- PE: Convolutional Processing Element with MAC array and ReLU activation

## File Structure
- rtl/ - SystemVerilog source files
- tb/ - Testbench for simulation
- scripts/ - Simulation scripts

## Simulation
Run the following command in the scripts directory:

    iverilog -g2012 -o sim ../tb/tb_cnn_accel.sv ../rtl/*.sv
    vvp sim

## Synthesis
Tested with Xilinx Vivado 2023.2 targeting Artix-7 FPGA.

## Reference
- IEEE 07238097: Reconfigurable NoC for Neural Networks

## License
MIT License
