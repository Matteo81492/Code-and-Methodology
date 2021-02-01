`timescale 1ns / 1ps

module Decode(
       input logic [31:0] instruction, PC4_f, PC4_wb, res_wb,
       input logic clk, reset, prediction, link_wb, wr_reg_en_wb,
       input logic [4:0] wr_reg_addr_wb,
       output logic [4:0] shamt_ex, wr_reg_addr_ex, rs_ex, rt_ex,
       output logic [5:0] alu_control_ex,
       output logic [31:0] PC4_ex, RD1_ex, RD2_ex, NPC4, zero_imm_ex, upper_imm_ex, sign_imm_ex,
       output logic [1:0] alu_src_ex, mem_to_reg_ex,
       output logic branch, wr_reg_en_ex, link_ex, mem_wr_ex, hlt, NOP, sign_zero_ext_ex, store_hb_ex,  
       output logic beq_ex, bne_ex, blez_ex, bgtz_ex, bgez_ex, bltz_ex, div_ex, overflow_ex, mult_ex, mfhi_ex, mflo_ex, mthi_ex, mtlo_ex     
     
    );
    
        logic [1:0] mem_to_reg, alu_src;
        logic [31:0] zero_imm_d, upper_imm_d, sign_imm_d;             
        logic wr_reg_en_d, link_d, mem_wr, sign_zero_ext, store_hb, jump;  
        logic beq, bne, blez, bgtz, bgez, bltz, div, overflow,  mult, mfhi, mflo, mthi, mtlo;    
        logic [31:0] PC4_d, NPC4_d, wr_data, RD1, RD2;
        logic [4:0] A1, A2, wr_addr, wr_reg_addr_d, rs, rt, shamt_d;
        logic [5:0] alu_control;
        
        assign A1 = instruction[25:21];
        assign A2 = instruction[20:16];
        
        Control_Unit control_unit_1 (.*);             
        Reg_file reg_file_1 (.*);   
             
        assign NPC4 = jump ? RD1 : NPC4_d;                  // if this section causes a problem, take RD1 into ctrl unit and update NPC4 there, also change name of NPC4_d
       
        always_comb
        begin                      
        if (wr_reg_en_wb) 
        begin
            wr_addr = wr_reg_addr_wb;      
            if(link_wb)     
                assign wr_data = PC4_wb;
            else
                assign wr_data = res_wb;                                
        end        
        end
        
        always_ff@(posedge clk, posedge reset)
            if(reset)
            begin  
            mult_ex <= 0;
            div_ex <= 0;                           
            end
            else
                begin
                wr_reg_addr_ex <= wr_reg_addr_d;   
                sign_imm_ex <= sign_imm_d;
                rs_ex <= rs;
                rt_ex <= rt;
                zero_imm_ex <= zero_imm_d;
                upper_imm_ex <= upper_imm_d; 
                shamt_ex <= shamt_d;
                alu_control_ex <= alu_control;
                alu_src_ex <= alu_src;
                PC4_ex <= PC4_d;
                link_ex <= link_d;
                RD1_ex <= RD1;
                RD2_ex <= RD2;  
                wr_reg_en_ex <= wr_reg_en_d;
                mult_ex <= mult;
                div_ex <= div;
                mfhi_ex <= mfhi;
                overflow_ex <= overflow;
                mflo_ex <= mflo;
                mthi_ex <= mthi;
                mtlo_ex <= mtlo;
                mem_wr_ex <= mem_wr;
                sign_zero_ext_ex <= sign_zero_ext;  
                store_hb_ex <= store_hb;
                mem_to_reg_ex <= mem_to_reg;
                end                   
endmodule