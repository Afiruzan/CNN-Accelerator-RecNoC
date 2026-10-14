# Complete Guide to Running the CNN Accelerator Simulation

This guide explains how to get the CNN accelerator project based on the RecNoC architecture from GitHub and run the simulation.

**Repository:** [https://github.com/Afiruzan/CNN-Accelerator-RecNoC](https://github.com/Afiruzan/CNN-Accelerator-RecNoC)

---

## 1. Project Structure

After cloning or downloading, the project structure is:

```
CNN-Accelerator-RecNoC/
├── rtl/
│   ├── mac_unit.sv
│   ├── conv_pe.sv
│   ├── config_switch.sv
│   ├── bus_arbiter.sv
│   ├── router.sv
│   ├── cluster.sv
│   └── cnn_accel_top.sv
├── tb/
│   └── tb_cnn_accel.sv
├── scripts/
│   ├── run_sim.sh      (Linux/macOS)
│   └── run_sim.bat     (Windows)
├── README.md
├── SIMULATION_GUIDE.md
├── LICENSE
└── .gitignore
```

- **`rtl/`**: Main hardware source files (SystemVerilog)
- **`tb/`**: Testbench for simulation
- **`scripts/`**: Simulation run scripts

---

## 2. Prerequisites

You need one of the following tools to run the simulation.

### Option A: Icarus Verilog (Free and Lightweight) - Recommended

- **Windows:** Download from [http://bleyer.org/icarus/](http://bleyer.org/icarus/)
- **Linux:** `sudo apt install iverilog`
- **macOS:** `brew install icarus-verilog`

After installation, verify in a terminal:

```cmd
iverilog -V
```

It should display the Icarus Verilog version (e.g., `Icarus Verilog version 12.0`).

### Option B: EDA Playground (Online, No Installation)

If you don't want to install anything, use [https://www.edaplayground.com](https://www.edaplayground.com). See Section 6.

### Option C: Vivado / ModelSim (Professional)

If you have Vivado or ModelSim, you can import the project. See Section 7.

---

## 3. Getting the Code from GitHub

### Method 1: Using Git (Recommended)

```cmd
cd C:\Users\Zarnegar\Desktop
git clone https://github.com/Afiruzan/CNN-Accelerator-RecNoC.git
cd CNN-Accelerator-RecNoC
```

### Method 2: Download ZIP

1. Go to the repository page.
2. Click the green **Code** button.
3. Select **Download ZIP**.
4. Extract the ZIP file.

---

## 4. Running the Simulation with Icarus Verilog (Windows)

### Step 1: Open cmd in the project folder

```cmd
cd C:\Users\Zarnegar\Desktop\CNN-Accelerator-RecNoC
```

### Step 2: Run the provided script

```cmd
cd scripts
run_sim.bat
```

The script automatically:
1. Compiles the RTL files and testbench.
2. Creates the executable `sim.exe`.
3. Runs the simulation.

### Step 3: Manual run (if the script fails)

```cmd
iverilog -g2012 -o sim.exe tb\tb_cnn_accel.sv rtl\*.sv
vvp sim.exe
```

| Command | Description |
|---------|-------------|
| `iverilog` | Verilog compiler |
| `-g2012` | Enable SystemVerilog-2012 features |
| `-o sim.exe` | Output executable name |
| `tb\tb_cnn_accel.sv` | Testbench file |
| `rtl\*.sv` | All RTL files |
| `vvp sim.exe` | Run the simulation |

### Step 4: Expected Output

```
=== CNN Accelerator Test Results ===
PE[0] result = 0
PE[1] result = 0
...
PE[31] result = 0
=== Test Complete ===
```

**Note:** In this testbench, the PE inputs are zero by default, so the outputs are zero. This test only verifies that the circuit functions correctly. To see real outputs, initialize `pix` and `wgt` in `cluster.sv`.

### Step 5: Viewing Waveforms (Optional)

Add these lines in the testbench before `$finish`:

```systemverilog
$dumpfile("wave.vcd");
$dumpvars(0, tb_cnn_accel);
```

Then run:

```cmd
gtkwave wave.vcd
```

---

## 5. Running the Simulation on Linux/macOS

```bash
cd CNN-Accelerator-RecNoC/scripts
chmod +x run_sim.sh
./run_sim.sh
```

Or manually:

```bash
cd CNN-Accelerator-RecNoC
iverilog -g2012 -o sim tb/tb_cnn_accel.sv rtl/*.sv
vvp sim
```

---

## 6. Running Online with EDA Playground

### Step 1: Sign in

Go to [https://www.edaplayground.com](https://www.edaplayground.com) and create a free account.

### Step 2: Create a new playground

1. Click **Create new playground**.
2. Under **Tools & Simulators**, select **Icarus Verilog 12.0**.
3. Check **SystemVerilog/Verilog**.

### Step 3: Copy the files

1. Click **+** next to **Files**.
2. Enter the exact filename (e.g., `mac_unit.sv`).
3. Copy the content from GitHub and paste it.
4. Repeat for all 7 RTL files and the testbench.

**Note:** In EDA Playground, the testbench must be placed in `testbench.sv`.

### Step 4: Run

Click the **Run** button at the top.

---

## 7. Running with Vivado (Optional)

1. Open Vivado.
2. **Create Project** -> **RTL Project**.
3. In **Add Sources**, add all `rtl/*.sv` files.
4. In **Add Sources** -> **Add Simulation Sources**, add `tb/tb_cnn_accel.sv`.
5. Click **Run Simulation** -> **Run Behavioral Simulation**.

---

## 8. Troubleshooting Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `iverilog: command not found` | Icarus not installed or not in PATH | Reinstall or use EDA Playground |
| `error: Unable to open file ...` | Wrong file path | Use `dir` to check |
| `error: Unknown module type: mac_unit` | RTL file not compiled | Ensure `rtl/*.sv` is in the compile command |
| `syntax error` | Old Icarus version | Use `-g2012` or update |
| `vvp: command not found` | vvp not installed | Reinstall Icarus |
| `$finish called at time ...` | Simulation finished | Normal, not an error |

---

## 9. Brief Explanation of the Code and Testbench

### Main Modules

- **`mac_unit`**: Multiply-Accumulate
- **`conv_pe`**: Convolution PE with 9 MACs (3x3 kernel) and ReLU
- **`config_switch`**: 4x4 crossbar for reconfigurable inter-cluster connections
- **`bus_arbiter`**: FIFO bus arbiter for intra-cluster communication
- **`router`**: Routes packets between PE, local bus, and NoC
- **`cluster`**: A cluster with 8 PEs + arbiter + router
- **`cnn_accel_top`**: Connects 4 clusters (2x2) with configuration switches

### Testbench

- Generates a clock with 2 ns period (500 MHz).
- Asserts and then deasserts `rst_n`.
- Pulses `start` to begin computation.
- After 50 cycles, displays results.
- In this version, inputs are zero, so outputs are zero.

---

## 10. Next Steps (Project Development)

To make the simulation produce meaningful outputs:

1. In `cluster.sv`, initialize `pix` and `wgt` with real values.
2. Add a weight memory and an input buffer.
3. Implement the mapping and topology generation algorithm in Python.
4. Use BookSim to model NoC traffic.

---

## 11. References

- **GitHub Repository:** [https://github.com/Afiruzan/CNN-Accelerator-RecNoC](https://github.com/Afiruzan/CNN-Accelerator-RecNoC)
- **Original Paper:** IEEE 07238097
- **Icarus Verilog:** [http://iverilog.icarus.com](http://iverilog.icarus.com)
- **EDA Playground:** [https://www.edaplayground.com](https://www.edaplayground.com)
- **GTKWave:** [http://gtkwave.sourceforge.net](http://gtkwave.sourceforge.net)

---

If you encounter any error, please share the full error message.
