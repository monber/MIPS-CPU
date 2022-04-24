module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  wire output0;
  wire output1;
  wire output2;
  wire output3;
  wire actA, actB;

  assign actA = ( invertA == 1) ? ~a : a ; 
  assign actB = ( invertB == 1) ? ~b : b ; 


  assign output0 = actA & actB;
  assign output1 = actA | actB;
  assign output2 = actA ^ actB ^ carryIn;
  assign carryOut = ( actA & actB ) | ( carryIn & actB ) | ( carryIn & actA );
  assign output3 = less;

  assign result = ( operation == 2'b00 ) ? output0 :
		  ( operation == 2'b01 ) ? output1 :
		  ( operation == 2'b10 ) ? output2 : output3;
endmodule