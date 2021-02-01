`timescale 1ns / 1ps

module ALU(
        input logic [31:0] sourceB_ex1, sourceA_ex,
        input logic [5:0] alu_control_ex,
        input logic [4:0] shamt_ex, 
        input logic beq_ex, bne_ex, blez_ex, bgez_ex, bgtz_ex, bltz_ex, overflow_ex,         
        output logic overflow_trap_alu, taken,    
        output logic [31:0] res_ex
    );
    
    
    always_comb
    begin
        case(alu_control_ex)
            6'h02:                                      // ADD operation
                res_ex = sourceB_ex1 + sourceA_ex;
                
            6'h12:
                res_ex = sourceA_ex - sourceB_ex1;      // SUB operation
                
            6'h00:
                res_ex = sourceA_ex & sourceB_ex1;     // AND operation
            
            6'h01:
                res_ex = sourceA_ex | sourceB_ex1;     // OR operation
                
            6'h05:
                res_ex = sourceA_ex ^ sourceB_ex1;     // XOR operation         

            6'h13:
                if (sourceA_ex < sourceB_ex1)            // SLT operation     
                    res_ex = 32'b01;
            6'h06:
                res_ex = ~(sourceA_ex | sourceB_ex1);     // NOR operation   
                
            6'h04:
                res_ex = sourceB_ex1 << shamt_ex;          // SLL operation   

            6'h07:
                res_ex = sourceB_ex1 >> shamt_ex;           // SRL operation                 

            6'h08:
                res_ex = sourceB_ex1 >>> shamt_ex;           // SRA operation   

            6'h24:
                res_ex = sourceB_ex1 >> sourceA_ex;       // SLLV operation                
                
            6'h27:
                res_ex = sourceB_ex1 << sourceA_ex;        // SRLV operation    
                
            6'h27:
                res_ex = sourceB_ex1 >>> sourceA_ex;        // SRAV operation   

            6'h27:
                res_ex = sourceB_ex1 >>> sourceA_ex;         // SRAV operation  
            
            default:
                    ; // No operation in the default state                                                                                                                        
    endcase
    
        if ((beq_ex) & (res_ex == 32'b0))                // After checking the branch the taken bit is sent to the prediction unit
            taken = 1;
        else if ((bne_ex) & (res_ex != 32'b0))
            taken = 1;
        else if ((blez_ex) & ~(res_ex > 32'b0))              
            taken = 1;  
        else if ((bltz_ex) & (res_ex < 32'b0))
            taken = 1; 
        else if ((bgtz_ex) & (res_ex > 32'b0))
            taken = 1;  
        else if ((bgez_ex) & ~(res_ex < 32'b0))
                taken = 1;                
        else
            taken = 0;                             
        
        if((overflow_ex)&((sourceB_ex1[31] == sourceA_ex[31]) & (sourceB_ex1[31] == ~res_ex[31]))) // overflow detection
            overflow_trap_alu = 1;
        else
            overflow_trap_alu = 0;  
        
    end
endmodule
