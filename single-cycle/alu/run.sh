clear
iverilog -g2005-sv tb_ri_load_s_b.v reg_file.v control_unit.v imm_gen.v alu.v top_module.v data_mem.v pc_reg.v pc_change.v instruction_mem.v branch_taken.v alu_op1_mux.v
vvp a.out