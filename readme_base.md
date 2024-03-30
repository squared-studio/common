# SystemVerilog IP Design & Verification
Absolutely, here's a more detailed explanation of your directory structure:

## Directory Structure
This repository is organized into several directories, each serving a specific purpose:

- **docs**: This directory houses all documentation files. These could include design specifications, user manuals, and other resources that provide more information about the project.

- **include**: This directory contains 'include' files. These are files that are included in other SystemVerilog files using the `include` directive. They may or may not be part of the Register-Transfer Level (RTL) design. These files are further organized into folders based on their protocol or use case. Note: This excludes certain include files located in the Testbench directory.

- **intf**: This directory stores SystemVerilog interfaces. These are essentially collections of signals, bundled together under a single name, complete with their own driving and monitoring tasks. These interfaces are recommended for verification purposes only, not for RTL design. We prefer structured IOs for requests and responses to expedite connections, rather than using interfaces.

- **rtl**: All design source files reside here. These could include modules, packages, and other SystemVerilog files that make up the design.

- **sub**: This directory contains all submodules. Submodules are typically separate projects that are included in the main project as a Git submodule. Please note that submodule files are not automatically compiled. They must be manually added in compile order within the `config/*/xvlog` for each Testbench (TB). This file is auto-generated next to the TB top file.

- **tb**: This is where all the Testbenches (TBs) are stored. Each TB should be in a separate directory that matches the name of the Device Under Test (DUT) module, ending with `_tb`. The Testbenches are used to verify the functionality of the design under different scenarios.

## How-to
To know how to use different commands on this repo, type `make help` or just `make` at the repo root and further details with be printed on the terminal.
