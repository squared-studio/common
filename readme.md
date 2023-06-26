# SystemVerilog RTL Design & Verification

## Directory structure
This section describes the purpose of individual folders in this repository

- **include** : Contains all the files that can be called using to include with the exception of some include for a specific testbench. The include file here may or may not be a part of RTL. All files here are expected to be inside a folder signifying their protocol or use case. 

- **intf** : Contains all interface. We recommend interfaces have their driving and monitoring tasks. We recommended interfaces for verification purposes only, not for RTL design.

- **rtl** : Contains all synthesizable IPs.

- **sub** : Contains all submodules.

- **tb** : Contains all the TestBench (TB). The TBs are to be in same directory stucture as the top RTL under testing. In addition, each TB has to be inside a separate directory matching the name with the top module.


## How to simulate
In order to run simulation, the testbench must be placed inside a sub-directory in the `tb` folder. <br>
For example, we want to simulate `fifo_tb.sv` located at `tb/buffers/fifo/fifo_tb/fifo_tb.sv`. <br>
Therefore, we only need to run the following command:
```
make simulate TOP=fifo_tb
```
