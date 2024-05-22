# Script to convert a program.hex file to a list of actual RV32I instructions w/ instruction count

from collections import namedtuple, defaultdict

InstructionFormat = namedtuple('InstructionFormat', ['name', 'opcode', 'funct3', 'funct7'])

rv32i_instructions = {
    0x33: [InstructionFormat('ADD', 0x33, 0x0, 0x00), InstructionFormat('SUB', 0x33, 0x0, 0x20),
           InstructionFormat('SLL', 0x33, 0x1, 0x00), InstructionFormat('SLT', 0x33, 0x2, 0x00),
           InstructionFormat('SLTU', 0x33, 0x3, 0x00), InstructionFormat('XOR', 0x33, 0x4, 0x00),
           InstructionFormat('SRL', 0x33, 0x5, 0x00), InstructionFormat('SRA', 0x33, 0x5, 0x20),
           InstructionFormat('OR', 0x33, 0x6, 0x00), InstructionFormat('AND', 0x33, 0x7, 0x00)],
    0x13: [InstructionFormat('ADDI', 0x13, 0x0, None), InstructionFormat('SLLI', 0x13, 0x1, 0x00),
           InstructionFormat('SLTI', 0x13, 0x2, None), InstructionFormat('SLTIU', 0x13, 0x3, None),
           InstructionFormat('XORI', 0x13, 0x4, None), InstructionFormat('SRLI', 0x13, 0x5, 0x00),
           InstructionFormat('SRAI', 0x13, 0x5, 0x20), InstructionFormat('ORI', 0x13, 0x6, None),
           InstructionFormat('ANDI', 0x13, 0x7, None)],
    0x03: [InstructionFormat('LB', 0x03, 0x0, None), InstructionFormat('LH', 0x03, 0x1, None),
           InstructionFormat('LW', 0x03, 0x2, None), InstructionFormat('LBU', 0x03, 0x4, None),
           InstructionFormat('LHU', 0x03, 0x5, None)],
    0x23: [InstructionFormat('SB', 0x23, 0x0, None), InstructionFormat('SH', 0x23, 0x1, None),
           InstructionFormat('SW', 0x23, 0x2, None)],
    0x63: [InstructionFormat('BEQ', 0x63, 0x0, None), InstructionFormat('BNE', 0x63, 0x1, None),
           InstructionFormat('BLT', 0x63, 0x4, None), InstructionFormat('BGE', 0x63, 0x5, None),
           InstructionFormat('BLTU', 0x63, 0x6, None), InstructionFormat('BGEU', 0x63, 0x7, None)],
    0x17: [InstructionFormat('AUIPC', 0x17, None, None)],
    0x37: [InstructionFormat('LUI', 0x37, None, None)],
    0x6F: [InstructionFormat('JAL', 0x6F, None, None)],
    0x67: [InstructionFormat('JALR', 0x67, 0x0, None)],
    0x73: [InstructionFormat('ECALL', 0x73, None, None), InstructionFormat('EBREAK', 0x73, None, None)]
}

def decode_instruction(instruction_hex):
    instruction_bin = f'{int(instruction_hex, 16):032b}'
    
    opcode = int(instruction_bin[25:], 2)
    funct3 = int(instruction_bin[17:20], 2)
    funct7 = int(instruction_bin[:7], 2)
    
    if opcode in rv32i_instructions:
        for instr in rv32i_instructions[opcode]:
            if (instr.funct3 == funct3 or instr.funct3 is None) and (instr.funct7 == funct7 or instr.funct7 is None):
                return instr.name
    return 'Unknown Instruction'

def decode_instructions(hex_list):
    decoded_instructions = []
    instruction_count = defaultdict(int)
    for hex_inst in hex_list:
        decoded_inst = decode_instruction(hex_inst)
        decoded_instructions.append(decoded_inst)
        instruction_count[decoded_inst] += 1
    return decoded_instructions, instruction_count

def decode_instructions_from_file(file_path):
    with open(file_path, 'r') as file:
        hex_instructions = [line.strip() for line in file.readlines()]
    
    decoded_instructions, instruction_count = decode_instructions(hex_instructions)
    with open("instruction_list.txt", "w") as f:
        for hex_inst, decoded_inst in zip(hex_instructions, decoded_instructions):
            f.write(hex_inst + " -> " + decoded_inst)
            f.write("\n")
        
        f.write("\n")
        
        f.write(f"Number of instructions used: {len(instruction_count.items()) - 1}")
        f.write("\n")
        
        f.write("\nInstruction Counts:\n")
        for instr, count in instruction_count.items():
            f.write(f"{instr}: {count}\n")
        

if __name__ == '__main__':
    file_path = 'program.hex'
    decode_instructions_from_file(file_path)
