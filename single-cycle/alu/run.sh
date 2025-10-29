clear
iverilog -g2005-sv tb_r_i_load_store.v reg_file.v control_unit.v imm_gen.v alu.v top_module.v data_mem.v
vvp a.out