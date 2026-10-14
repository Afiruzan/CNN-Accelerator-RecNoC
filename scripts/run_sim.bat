@echo off
iverilog -g2012 -o sim.exe ..\tb\tb_cnn_accel.sv ..\rtl\*.sv
vvp sim.exe
pause
