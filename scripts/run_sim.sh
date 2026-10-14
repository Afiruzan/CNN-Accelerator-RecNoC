#!/bin/bash
iverilog -g2012 -o sim ../tb/tb_cnn_accel.sv ../rtl/*.sv
vvp sim
