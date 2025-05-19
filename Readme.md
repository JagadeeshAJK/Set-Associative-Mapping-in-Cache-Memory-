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
### A. ram_module.v: 
  Simulated main memory (RAM)
  
### B. cache2.v:
  Main module implementing 4-set, 4-way associative cache


### C. testbench (cache2tb.v): 
  Stimulates and validates cache behavior.

## Cache Specifications

 Main Memory Blocks: 64           &          Cache Lines: 16
 
![ARCH](https://github.com/JagadeeshAJK/Set-Associative-Mapping-in-Cache-Memory-/blob/main/Main%20memory%20to%20Cache%20Mapping.jpg)

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


# Set Mapping

We use the last 2 bits (address[1:0]) to decide the set.

  *Set Index = (Address) mod (Number of Sets)*



| Set Index (Binary) | Set Number | Addresses that map to this set |
|----------------|-----------------|-----------------|
| 00         | Set 0               | 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 |
| 01     | Set 1               | 1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61 |
| 10   | Set 2               | 2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62 |
| 11  | Set 3               | 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63 |








# A. RAM Module

This ram_module simulates a 64-location main memory, where each location holds 8-bit data. It supports read and write operations based on a 6-bit address input.When write_enable is high, the input data is written to the specified address. On read,the data at that address is continuously available at the output. The initial block preloads specific addresses for testing. This RAM serves as the backend memory for the cache in a write-through cache system.


## Module Instantiation Explanation:
The ram_module is instantiated as ram_inst inside the cache module to simulate main memory. It takes the following 

inputs:<br>
• cpu_address (6-bit): Address for memory access<br>
• data_in (8-bit): Data to be written<br>
• write_enable (1-bit): Enables write operation<br>

It outputs:<br>
• data_out (8-bit): Data read from RAM<br>

This module provides data on a cache miss and stores data on a write-through,enabling interaction between cache and RAM.




# B. Cache Module (Cache2.v)
## Write Operation Logic (Verilog):

This always block handles cache write operations. If the address tag matches one in the cache set, it's a cache hit, and data is written to both the cache and RAM (write-through policy).<br>
• On a miss, the cache looks for an empty (invalid) line to write the data and update the tag and valid bit.<br>
• If the set is full, it uses FIFO replacement to evict an old entry and store the new data.<br>
  Since the design uses a write-through policy, all writes go directly to RAM as well, and no dirty bit is required.


## Read Operation Logic (Verilog):

This always block handles cache read operations on each clock or reset. Upon reset, all cache blocks are invalidated.<br>
During a read, the set index is extracted from the address, and the cache checks all 4 ways for a tag match.<br>
• If a match is found (valid tag), it's a cache hit, and data is returned from the cache.<br>
• If no match, it's a cache miss. The code then looks for an empty (invalid) line in the set to store data fetched from RAM.<br>
• If all lines are valid, it uses FIFO replacement to evict an old entry and bring in the new data.

# C. Test Bench (Cache2tb.v)
This testbench simulates the cache system by generating clock, reset, and read/write control signals. It initializes the cache, performs several read and write operations using different addresses, and records signal activity using VCD output.<br>
The $dumpvars statements help trace internal cache states, such as data, valid bits, and cache hits or misses during simulation.

# Simulation & Output Analysis

The waveform generated using GTKWave displays the functional behavior of a 4-way set-associative cache system during read and write operations. Initially, a reset is applied to invalidate all cache entries and clear previous data. During the simulation,various 6-bit physical addresses are provided for both read and write operations.

When a read operation is performed, the cache checks for a tag match within the selected set (based on index bits). If a match is found, it's a cache hit, and the data is directly retrieved from the cache (hit=1). If not found, a cache miss occurs (miss=1),and data is fetched from RAM and stored into the cache. In case of a write operation, data is written both to the RAM and into the cache, updating the corresponding line and tag.

The simulation also shows the FIFO replacement mechanism in action when all four ways in a set are occupied. The nf pointer determines the next cache line to be replaced.
