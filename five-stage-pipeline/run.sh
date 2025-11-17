clear
iverilog -g2005-sv alu_op1_mux.v alu.v branch_taken.v control_unit.v data_mem.v ex_mem.v id_ex.v if_id.v imm_gen.v instruction_mem.v mem_wb.v pc_4_add.v pc_add_imm.v pc_change.v \
pc_jump.v pc_next_mux.v pc_reg.v reg_file.v tb.v top_module.v wb_mux.v forwarding_unit.v forward_mux.v -o fivestage_pipeline.vvp hazard_unit.v
vvp fivestage_pipeline.vvp