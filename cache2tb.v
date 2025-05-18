module qwe();
  reg reset, clk, read, write;
  reg [5:0] cpu_address;
  reg [7:0] data_write_cache;
  wire hit, miss;
  wire [7:0]cache_output;
  wire [1:0] index;

  // Instantiate the cache (which internally uses the RAM module)
  cache dut (
    .reset(reset),
    .clk(clk),
    .read(read),
    .write(write),
    .data_write_cache(data_write_cache),
    .cpu_address(cpu_address),
    .hit(hit),
    .miss(miss),
    .cache_output(cache_output),
    .index(index)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;

    $dumpfile("cache4.vcd");    // Output VCD file
    $dumpvars(0, qwe);
    
    // Dump internal variables of cache
    $dumpvars(1, dut.cache_data[0][0], dut.cache_data[0][1], dut.cache_data[0][2], dut.cache_data[0][3]);
    $dumpvars(1, dut.cache_data[1][0], dut.cache_data[1][1], dut.cache_data[1][2], dut.cache_data[1][3]);
    $dumpvars(1, dut.cache_data[2][0], dut.cache_data[2][1], dut.cache_data[2][2], dut.cache_data[2][3]);
    $dumpvars(1, dut.cache_data[3][0], dut.cache_data[3][1], dut.cache_data[3][2], dut.cache_data[3][3]);
    $dumpvars(1, dut.ram_cac_data);
    $dumpvars(1, dut.valid[0][0], dut.valid[1][0], dut.valid[2][0], dut.valid[3][0]);
    $dumpvars(1, dut.valid[0][1]);

    #15 reset = 0;

    // READ operations
    read = 1; write = 0;
    cpu_address = 6'b000000; //0
    #10 cpu_address = 6'b000001; //01
    #10 cpu_address = 6'b000000; //0
    #10 
    
    read = 0; 
    write = 1;
    
    cpu_address = 6'b000000; //0
    data_write_cache = 8'b11111111; //255
   #10 read = 1; write = 0;
    cpu_address = 6'b000100;//4
    #10 cpu_address = 6'b001000;//8
    #10 cpu_address = 6'b001100;//12
    #10 cpu_address = 6'b100100;//36
    #10 cpu_address = 6'b101000;//40
    

    #120 $finish;
  end
endmodule

