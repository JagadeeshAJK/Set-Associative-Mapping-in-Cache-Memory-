# **APB Protocol**

This project implements the Advanced Peripheral Bus (APB) protocol for interfacing peripherals in ARM-based systems. The APB protocol is designed for low power, low bandwidth applications and is ideal for connecting peripherals like timers, UARTs, and other simple devices in embedded systems.

## **Overview**
The **APB Protocol Project** provides a Verilog/VHDL-based implementation of the APB protocol, including both master and slave interfaces. This project is designed to be flexible and easily integrated into larger systems. It includes:
- Master and slave APB interface models.
- Verilog/VHDL code for the APB protocol.
- A testbench for simulation and verification.

---

## **Features**
- **Master and Slave APB Interface:** Implementations for both the master and slave sides of the protocol.
- **Low Power Operation:** Designed with low-power operation in mind.

## APB Interface Block Diagram With Slaves :
![ARCH](https://github.com/JagadeeshAJK/APB_master_slave_protocol/blob/main/APB_architecture.png)
## APB Protocol Implementation using Verilog :
Implementing the APB protocol in Verilog involves defining the bus signals and designing
the master and slave modules. Verilog provides a robust framework for describing hardware designs
at the register-transfer level (RTL).
- **Master Module :** The APB master module initiates the data transfers by generating read
and write requests.
- **MUX Module :** The APB MUX module initiates the slave selection by generating Psel<br>
  ---> It takes the address (Paddr) and selects the appropriate slave based on the range
of addresses assigned to each peripheral.<br>
  ---> It forwards the correct peripheral’s data lines (Prdata/Pwdata) to/from the
master.<br>
**Pslave1** - 000(0) to 011(3) <br>
**Pslave2** - 100(4) to 111(7)
- **Slave Modules (2-slaves) :** The APB slave module responds to the master's requests and
handles the data transactions.
- **State Diagram :** A state machine manages the different phases of the APB protocol,
ensuring proper synchronization and data transfer.




## APB Protocol Architecture and Signals :
### Address Signals :
The APB protocol defines a set of signals for communication between the
master and slave modules.
- **Paddr[2:0] :** Specifies the address of the slave device.
- **Psel :** Activates the selected slave device.
### Control Signals :
- **Pwrite :** Indicates whether the transaction is a write or read operation.
- **Pready :** Indicates that the slave is ready to accept or provide data.
### Data Signals :
- **Pwdata[15:0] :** Contains the data to be written to the slave.
- **Prdata[15:0] :** Contains the data read from the slave.

## State Diagram
![SD](https://github.com/JagadeeshAJK/APB_master_slave_protocol/blob/main/statediagram.png)

## **Project Structure**


## WRITE TRANSFER
This section describes the following types of write transfer:
-  With no wait states
-  With wait states
All signals shown in this section are sampled at the rising edge of Pclk.
## - Write Transfer with no wait state:
![WNwait](https://github.com/JagadeeshAJK/APB_master_slave_protocol/blob/main/Write_nowait_state.png)
## - Write Transfer with wait state:
![Wwait](https://github.com/JagadeeshAJK/APB_master_slave_protocol/blob/main/Write_wait_state.png)


## READ TRANSFER
This section describes the following types of read transfer:
-  With no wait states
-  With wait states
All signals shown in this section are sampled at the rising edge of Pclk.
## Read Transfer with no wait state :
![RNwait](https://github.com/JagadeeshAJK/APB_master_slave_protocol/blob/main/Read_nowait_state.png)
## Read Transfer with no wait state :
![Rwait](https://github.com/JagadeeshAJK/APB_master_slave_protocol/blob/main/Read_wait_state.png)
