# IIR Filter on FPGA
This project has been developed for the course of *Digital Systems Design*, *Master of Engineering in Embedded Computing Systems* (*University of Pisa and Sant'Anna School of Advanced Studies*).


## Requirements
Design a digital circuit which implements a simple IIR filter for audio applications

y[n] = y[n-1] - 0.25·x[n] + 0.25·x[n-4]

Such filter allows to attenuate signal components which have half the frequency of the sampling one.

Refer to a possible 16-bit wav format.

## Tools
The tools used for the project were
* [MATLAB R2017a](https://it.mathworks.com/products/matlab.html) for modeling
* [Active-HDL Student Edition](https://www.aldec.com/en/products/fpga_simulation/active_hdl_student) for VHDL implementation and testbenches
* [Vivado HLx Edition 2017.1](https://www.xilinx.com/products/design-tools/vivado.html) for synthesis on FPGA

## Project structure
The project folder resembles the following structure:

* matlab: MATLAB design files
* report: .pdf report file
* db
  * src: VHDL source files
  * tb: VHDL testbench files
* active_hdl: Active-HDL project folder
* vivado_synth: Vivado project folder

The design workflow can be found in the <report> file

## License
This project is licensed under the * License - see the <LICENSE_link> file for details