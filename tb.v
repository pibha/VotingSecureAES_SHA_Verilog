//`timescale 1ns / 1ps

//module tb_Password_Verification;

//  // Inputs
//  reg [7:0] password;
//  //reg [7:0] enterpassword;
//  reg clk;
//  reg rst;
//  wire success;
 
  
//  Password_Verification dut (
//    .password(password),
//    //.enterpassword(enterpassword),
//    //.key(key),
//    .clk(clk),
//    .rst(rst),
//    .success(success),
//    .access(access)
//  );

//initial begin
//      clk = 0;
//      forever #1 clk = ~clk;
//    end
//  initial begin
   
//    rst = 1;                                //not edited
//    #5;
//  rst = 0;                                //edited
//#100;
////    password = 8'b11010101;
//password = 8'b11111111;
//    #100;

//    password = 8'b11011011;
//    #100;
//    //password=8'b01110010;
//    password=8'b00000000;
//    #100;
//    $finish;
//  end

//endmodule

`timescale 1ns/1ps

module Password_Verification_TB;
  reg clk;
  reg rst;
  reg [7:0] password;
  wire success;
  wire access;

  // Instantiate the DUT
  Password_Verification dut (
    .clk(clk),
    .rst(rst),
    .password(password),
    .success(success),
    .access(access)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    password = 8'b00000000;

    #10;

    // Release reset
    rst = 0;

    #10;

    // Test Case 1: Correct password (hashed_output_1)
    password = 8'b01110010;
    #10;
    if (success !== 1'b1 || access !== 1) $display("Test Case 1 Failed!");
     // Test Case 2: Correct password (hashed_output_2)
    password = 8'b11010101;
    #10;
    if (success !== 1'b1 || access !== 1) $display("Test Case 2 Failed!");
    $finish;
    // Test Case 3: Correct password (hashed_output_3)
    password = 8'b00101111;
    #10;
    if (success !== 1'b1 || access !== 1) $display("Test Case 3 Failed!");

    // Test Case 4: Incorrect password
    password = 8'b11111111;
    #10;
    if (success !== 1'b0) $display("Test Case 4 Failed!");
  end
endmodule
