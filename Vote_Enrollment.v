
`timescale 1ns / 1ps
module Vote_Enrollment(
     input clk,
     input rst,
  output reg [127:0]hashed_output_1,
  output reg [127:0]hashed_output_2,
  output reg [127:0]hashed_output_3
);


 wire [255:0] hash_data1;
  wire output_valid1;
  wire [127:0] encrypted_output1;
  
wire [255:0] hash_data2;
  wire output_valid2;
  wire [127:0] encrypted_output2;
  
  wire [255:0] hash_data3;
  wire output_valid3;
  wire [127:0] encrypted_output3;
  sha256 s1(
    .input_data({8'b01110010 ,24'b000100110111101000011111}),//password(r)
    .input_valid(1'b1),
    //.input_ready(),
    //.last_word(1'b1),
    .clk(clk),
    .rst(rst),
    .output_valid(output_valid1),
    .hash_data(hash_data1)
  );
  // Instantiate the AES module
  aescipher a1(
    .clk(clk),
    .datain(hash_data1[255:128]),
    //.key(key),
    .dataout(encrypted_output1)
  );
// 2nd password
  sha256 s2(
    .input_data({8'b11010101,24'b000100110111101000011111}),// Õ([password2)
    .input_valid(1'b1),
    //.input_ready(),
    //.last_word(1'b1),
    .clk(clk),
    .rst(rst),
    .output_valid(output_valid2),
    .hash_data(hash_data2)
  );
  // Instantiate the AES module
  aescipher a2(
    .clk(clk),
    .datain(hash_data2[255:128]),
    //.key(key),
    .dataout(encrypted_output2)
  );
 
 
  sha256 s3(
  .input_data({8'b00101111, 24'b000100110111101000011111}),//(-password3)    
     .input_valid(1'b1),
    //.input_ready(),
    //.last_word(1'b1),
    .clk(clk),
    .rst(rst),
    .output_valid(output_valid3),
    .hash_data(hash_data3)
  );

  // Instantiate the AES module
  aescipher a3(
    .clk(clk),
    .datain(hash_data3[255:128]),
    //.key(key),
    .dataout(encrypted_output3)
  );
  always@(posedge clk) begin
  hashed_output_1 = encrypted_output1;
  hashed_output_2 = encrypted_output2;
  hashed_output_3 = encrypted_output3;
  end

endmodule