module ram_module (
  input [5:0] cpu_address,input [7:0] data_in,input write_enable,input clk,output [7:0] data_out );
  reg [7:0] ram[0:63];
  assign data_out = ram[cpu_address];
  initial begin
    ram[0] = 8'd1;
    ram[1] = 8'd2;  
    ram[2] = 8'd3;  
    ram[3] = 8'd4; 
    ram[4] = 8'd5;  
    ram[5] = 8'd6;  
    ram[6] = 8'd7; 
    ram[7] = 8'd8; 
    ram[8] = 8'd9; 
    ram[9] = 8'd10;
    ram[10] = 8'd11;  
    ram[12] = 8'd13;  
    ram[36] = 8'd37;  
    ram[40] =8'd41;  
    ram[44] = 8'd45;  
    ram[48] = 8'd49;  
    ram[52] = 8'd53;  
    ram[54] = 8'd55;  
    ram[58] = 8'd59;  
    ram[60] = 8'd61;  
    ram[61] = 8'd62;  
    ram[62] = 8'd63;  
    ram[63] = 8'd64;  
  end
  always @(posedge clk) begin
    if (write_enable) 
    ram[cpu_address] = data_in;
  end
endmodule
