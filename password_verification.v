
`timescale 1ns / 1ps
module Password_Verification (
  input clk,rst,
  input [7:0] password,
 // input last_word,
  output reg success,
  output reg access
);


  wire [255:0] hash_data;
  wire output_valid;
  wire [127:0] encrypted_output;
  wire [127:0]hashed_output_1;
  wire [127:0]hashed_output_2;
  wire [127:0]hashed_output_3;
  reg count_1=0;
  reg count_2=0;
  reg count_3=0;
Vote_Enrollment V1(
.clk(clk),
.rst(rst),
.hashed_output_1(hashed_output_1),
.hashed_output_2(hashed_output_2),
.hashed_output_3(hashed_output_3)
);

  sha256 sha(
    .input_data({password, 24'b000100110111101000011111}),
    .input_valid(1'b1),
    //.input_ready(),
    //.last_word(1'b1),
    .clk(clk),
    .rst(rst),
    .output_valid(output_valid),
    .hash_data(hash_data)
  );

  aescipher aes(
    .clk(clk),
    .datain(hash_data[255:128]),
    //.key(key),
    .dataout(encrypted_output)
  );

 always@(posedge clk)
 begin
 if(encrypted_output == (hashed_output_1))
        if(count_1==0)
        begin
         success=1'b1;
         access=1;
         count_1=1;
       end
       else
       begin
         access=0;
         end
 else if( encrypted_output == hashed_output_2 )
        if(count_2==0)
        begin
         success=1'b1;
         access=1;
         count_2=1;
       end
              else
       begin
         access=0;
         end
 else if(encrypted_output == hashed_output_3)
        if(count_3==0)
        begin
         success=1'b1;
         access=1;
         count_3=1;
       end
      
       else
       begin
         access=0;
         end
 else
     success=1'b0;
 end
endmodule

