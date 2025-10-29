with open("data_mem_init.hex", "w") as f:
    for i in range(1024):
        f.write(f"{i & 0xFF:02X}\n")