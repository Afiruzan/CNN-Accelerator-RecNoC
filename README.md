# CNN Accelerator based on RecNoC Architecture

This repository contains a SystemVerilog implementation of a CNN accelerator
based on the reconfigurable cluster-based Network-on-Chip (RecNoC) architecture
presented in A. Firuzan, M. Modarressi and M. Daneshtalab, "Reconfigurable communication fabric for efficient implementation of neural networks," 2015 10th International Symposium on Reconfigurable Communication-centric Systems-on-Chip (ReCoSoC), Bremen, Germany, 2015, pp. 1-8, doi: 10.1109/ReCoSoC.2015.7238097. keywords: {Neural networks;Neurons;Topology;Network topology;Computer architecture;Program processors;Clustering algorithms;Network-on-Chip;Neural Networks;Hardware Accelerator;Reconfivuration},

.

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
- A. Firuzan, M. Modarressi and M. Daneshtalab, "Reconfigurable communication fabric for efficient implementation of neural networks," 2015 10th International Symposium on Reconfigurable Communication-centric Systems-on-Chip (ReCoSoC), Bremen, Germany, 2015, pp. 1-8, doi: 10.1109/ReCoSoC.2015.7238097. keywords: {Neural networks;Neurons;Topology;Network topology;Computer architecture;Program processors;Clustering algorithms;Network-on-Chip;Neural Networks;Hardware Accelerator;Reconfivuration},



## License
MIT License
