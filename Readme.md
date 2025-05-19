# **Set Associative Mapping in Cache Memory**

&nbsp;&nbsp;&nbsp;&nbsp;In modern computing systems, cache memory plays a crucial role in
bridging the speed gap between the processor and the main memory. Efficient cache
design is essential for enhancing system performance by reducing memory access
latency. Among various cache mapping techniques, set-associative mapping strikes a
balance between simplicity and flexibility, minimizing conflict misses while
maintaining manageable hardware complexity.

&nbsp;&nbsp;&nbsp;&nbsp; This project presents the design and simulation of a set-associative cache 
memory using Verilog Hardware Description Language (HDL). The implementation 
features a 4-set cache with 4 ways per set, enabling multiple blocks to reside in the 
same set to improve hit rates. Key functionalities such as read and write operations, 
tag comparison, valid bit checking, and FIFO (First-In-First-Out) replacement policy 
are modeled at the RTL level. A write-through policy is adopted to ensure data 
consistency between cache and main memory (RAM).

## **Introduction**
  &nbsp;&nbsp;&nbsp;&nbsp; Modern computer systems rely on fast memory access to maintain high performance. However, accessing data directly from main memory (RAM) is significantly slower than accessing data from the processor's cache. To bridge this speed gap, caches are employed. These are small, fast memory structures that store frequently accessed data.
  
 ![WNwait](https://github.com/JagadeeshAJK/Set-Associative-Mapping-in-Cache-Memory-/blob/main/Cache.jpg)

 &nbsp;&nbsp;&nbsp;&nbsp;  Cache leverages **temporal locality** by storing recently accessed data for quick reuse and **spatial locality** by fetching and storing nearby memory locations likely to be accessed soon.The efficiency of a cache system depends on the mapping strategy.
   
![Wwait](https://github.com/JagadeeshAJK/Set-Associative-Mapping-in-Cache-Memory-/blob/main/Types%20of%20Mapping.jpg)

**1. Direct Mapping :** Each memory block maps to exactly one cache line.<br>
**Advantages :** Simple hardware, fast access.<br>
**Disadvantages :** High rate of conflict misses — different blocks competing for the same cache line, even if others are empty.

**2. Fully Associative Mapping :** Any memory block can be stored in any cache line.<br>
**Advantages :** No conflict misses; highly flexible.<br>
**Disadvantages :** Expensive hardware; slower due to multiple tag comparisons.<br>

**3. Set-Associative Mapping :** A hybrid approach the cache is divided into multiple sets, and each set has multiple lines(ways).<br>
A memory block maps to a specific set, but within the set, it can occupy any line.

---

# SET-ASSOCIATIVE MAPPING

### PURPOSE : 
To design and simulate a set-associative cache memory using Verilog HDL to improve memory access speed and reduce processor-memory latency in digital systems.

### FEATURES :
• Implements a 4-set, 4-way associative cache.<br>
• Supports read and write operations with valid bit tracking.<br>
• Uses FIFO (First-In-First-Out) replacement policy.<br>
• Incorporates a write-through policy to update both cache and main memory.<br>
• Efficient handling of cache hits and misses.<br>

### HOW IT WORKS : 
&nbsp;&nbsp;&nbsp;&nbsp;Memory access requests (read/write) are compared with cache tags in the appropriate set.<br>
• If a tag match is found and valid, it results in a cache hit.<br>
• If no match is found, it results in a miss, and data is fetched from RAM and stored in the cache using FIFO replacement.<br>
• Writes update both the cache and RAM simultaneously.<br>
### WHERE IT'S USED : 
This type of cache structure is used in CPUs, DSPs, and SoCs to reduce average memory access time and improve overall system performance.

### PART OF MEMORY HIERARCHY : 
This cache design represents the Level 1 (L1) or Level 2 (L2) cache level in the processor’s memory hierarchy, acting  as a fast intermediary between registers and main memory (RAM).



# Set-Associative Mapping Implementation in Verilog :

Modules Used

### A. cache2.v:
  Main module implementing 4-set, 4-way associative cache

### B. ram_module.v: 
  Simulated main memory (RAM)

### C. testbench (cache2tb.v): 
  Stimulates and validates cache behavior.

## Cache Specifications

 Main Memory Blocks: 64           &          Cache Lines: 16

Physical Address (Block) - 6 bits        &       Tag bits (cache) – 4 bits

• Sets: 4 <br>
• Ways per Set: 4<br>
• Address Width: 6 bits<br>
• Data Width: 8 bits<br>
• Tag Width: 4 bits  (from address[5:2])<br>
• Index Width: 2 bits (from address[1:0])<br>

## Replacement Policy
• FIFO (First-In First-Out) per set<br>
• Managed via a simple counter (nf register) to track next victim in the set




![ARCH](https://github.com/JagadeeshAJK/Set-Associative-Mapping-in-Cache-Memory-/blob/main/Main%20memory%20to%20Cache%20Mapping.jpg)
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
handles the data trans
- **State Diagram :** A state machine manages the different phases of the APB protocol,
ensuring proper synchronization and data transfer.




 Mapping of Quantization Levels
| Set Index (Binary) | Set Number | Addresses that map to this set |
|----------------|-----------------|-----------------|
| 00         | Set 0               | 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 |
| 01     | Set 1               | 1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61 |
| 10   | Set 2               | 2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62 |
| 11  | Set 3               | 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63 |








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
![SD](g)

## **Project Structure**


## WRITE TRANSFER
This section describes the following types of write transfer:
-  With no wait states
-  With wait states
All signals shown in this section are sampled at the rising edge of Pclk.
## - Write Transfer with no wait state:

## - Write Transfer with wait state:


## READ TRANSFER
This section describes the following types of retransfer:
-  With no wait states
-  With wait states
All signals shown in this section are sampled at the rising edge of Pclk.
## Read Transfer with no wait state :
![RNwait](o)
## Read Transfer with no wait state :
![Rwait](r)
