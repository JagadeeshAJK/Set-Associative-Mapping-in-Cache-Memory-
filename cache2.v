`include "ram_module.v"
module cache(
  input clk,
  input reset,
  input read, write,
  input [7:0] data_write_cache,
  input [5:0] cpu_address,
  output reg hit,
  output reg miss,
  output reg [7:0] cache_output,
  output reg [1:0] index
);

  reg [7:0] ram_cac_data;
  reg [7:0] cache_hit_data;
  reg [7:0] cache_data[3:0][3:0];
  reg [3:0] cache_tag[3:0][3:0];
  reg valid[3:0][3:0];
  reg found, count;
  reg [1:0] mem, nf;
  wire [7:0] ram_data;

  integer i, j;


  // Instantiate RAM module
  reg ram_write_enable;
  reg [7:0] ram_data_in;
  ram_module ram_inst (
    .cpu_address(cpu_address),
    .data_in(ram_data_in),
    .clk(clk),
    .write_enable(ram_write_enable),
    .data_out(ram_data)
  );

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < 4; i = i + 1)
        for (j = 0; j < 4; j = j + 1) begin
          cache_data[i][j] <= 8'bx;
          cache_tag[i][j] <= 4'bx;
          valid[i][j] <= 0;
        end
      hit <= 0;
      miss <= 0;
      ram_cac_data <= 8'bx;
      cache_output<=8'bx;
      nf <= 0;
    end 
    
    else if (read && !write) begin
      index = cpu_address[1:0];  
      found = 0;
      count = 0;
      mem = 0;
      ram_write_enable = 0;

      for (i = 0; i < 4; i = i + 1) begin           //   4 way checking
        if (!found && cache_tag[i][index] == cpu_address[5:2]) begin
          hit = 1;
          miss = 0;
          cache_hit_data = cache_data[i][index];
          ram_cac_data=8'bx;
          found = 1;
        end
      end
      

      if (!found) begin     // 4 way checking with empty cache
        for (i = 0; i < 4; i = i + 1) begin
          if (!count && valid[i][index] == 0) begin
            miss = 1;
            hit = 0;
            count = 1;
            mem = i;
            valid[i][index] = 1;
            cache_tag[mem][index] = cpu_address[5:2];
            cache_data[mem][index] = ram_data;
            ram_cac_data = cache_data[mem][index]; 
          end
        end
        
        if (!count) begin // if both fails then replacement(FIFO)
          miss = 1;
          hit = 0;
          count <= 1;
          mem = nf; 
          nf = nf + 1; 
          cache_tag[mem][index] = cpu_address[5:2];
          cache_data[mem][index] = ram_data;
          ram_cac_data = cache_data[mem][index];  
        end
      end
    end 



    else if (!read && write) begin // write operation
      index = cpu_address[1:0];  
      found = 0;
      count = 0;
      mem = 0;
      ram_data_in = data_write_cache;
      ram_write_enable = 1;

      for (i = 0; i < 4; i = i + 1) begin
        if (!found && cache_tag[i][index] == cpu_address[5:2]) begin
          hit = 1;
          miss = 0;
          cache_data[i][index] = data_write_cache;
          ram_cac_data=8'bx;
          cache_hit_data = cache_data[i][index];
          found = 1;
        end
      end

      if (!found) begin
        for (i = 0; i < 4; i = i + 1) begin
          if (!count && valid[i][index] == 0) begin
            miss = 1;
            hit = 0;
            count = 1;
            mem = i;
            valid[i][index] = 1;
            cache_tag[mem][index] = cpu_address[5:2];
            cache_data[mem][index] = data_write_cache;
            ram_cac_data =cache_data[mem][index]; 
          end
        end

        if (!count) begin
          miss = 1;
          hit = 0;
          count <= 1;
          mem = nf; 
          nf = nf + 1; 
          cache_tag[mem][index] = cpu_address[5:2];
          cache_data[mem][index] = data_write_cache;
          ram_cac_data = cache_data[mem][index]; 
        end
      end
    end
    
  if(!hit)
  cache_output=ram_cac_data;
  
  else
  cache_output=cache_hit_data;
  
  
  end
endmodule

