import os
import sys

PREDEFINED_SYMBOLS = {
    "SP": 0,
    "LCL": 1,
    "ARG": 2,
    "THIS": 3,
    "THAT": 4,
    "SCREEN": 16384,
    "KBD": 24576,
}
for i in range(16):
    PREDEFINED_SYMBOLS[f"R{i}"] = i

COMP_TABLE = {
    "0": "0101010", "1": "0111111", "-1": "0111010",
    "D": "0001100", "A": "0110000", "!D": "0001101",
    "!A": "0110001", "-D": "0001111", "-A": "0110011",
    "D+1": "0011111", "A+1": "0110111", "D-1": "0001110",
    "A-1": "0110010", "D+A": "0000010", "D-A": "0010011",
    "A-D": "0000111", "D&A": "0000000", "D|A": "0010101",
    "M": "1110000", "!M": "1110001", "-M": "1110011",
    "M+1": "1110111", "M-1": "1110010", "D+M": "1000010", "M+D": "1000010",
    "D-M": "1010011", "M-D": "1000111", "D&M": "1000000","M&D": "1000000",
    "D|M": "1010101","M|D": "1010101",
}

DEST_TABLE = {
    "": "000", "M": "001", "D": "010", "MD": "011",
    "A": "100", "AM": "101", "AD": "110", "AMD": "111",
}

JUMP_TABLE = {
    "": "000", "JGT": "001", "JEQ": "010", "JGE": "011",
    "JLT": "100", "JNE": "101", "JLE": "110", "JMP": "111",
}


def clean_line(line: str) -> str:
    if "//" in line:
        line = line.split("//", 1)[0]
    return line.strip()


def first_pass(lines, symbols):
    instructions = []
    rom_address = 0

    for raw_line in lines:
        line = clean_line(raw_line)
        if not line:
            continue

        if line.startswith("(") and line.endswith(")"):
            label = line[1:-1].strip()
            if label and label not in symbols:
                symbols[label] = rom_address
        else:
            instructions.append(line)
            rom_address += 1

    return instructions

def second_pass(instructions, symbols):
    binary_lines = []
    next_ram = 16

    for line in instructions:
        if line.startswith("@"):
            target = line[1:].strip()
            if target.isdigit():
                addr = int(target)
            else:
                if target not in symbols:
                    symbols[target] = next_ram
                    next_ram += 1
                addr = symbols[target]
            binary_lines.append(format(addr, "016b"))
        else:
            if "=" in line:
                dest, rest = line.split("=", 1)
            else:
                dest, rest = "", line

            if ";" in rest:
                comp, jump = rest.split(";", 1)
            else:
                comp, jump = rest, ""

            c_bits = COMP_TABLE[comp.strip()]
            d_bits = DEST_TABLE[dest.strip()]
            j_bits = JUMP_TABLE[jump.strip()]
            binary_lines.append(f"111{c_bits}{d_bits}{j_bits}")

    return binary_lines

def write_symbols_file(symbols, output_path="symbols.txt"):
    with open(output_path, "w", encoding="utf-8") as f:
        for name, addr in sorted(symbols.items(), key=lambda item: (item[1], item[0])):
            f.write(f"{name}: {addr}\n")


def assemble(asm_path: str):
    symbols = PREDEFINED_SYMBOLS.copy()

    with open(asm_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    instructions = first_pass(lines, symbols)
    binary_lines = second_pass(instructions, symbols)

    base, _ = os.path.splitext(asm_path)
    hack_path = f"{base}.hack"
    with open(hack_path, "w", encoding="utf-8") as f:
        f.write("\n".join(binary_lines) + ("\n" if binary_lines else ""))

    symbols_path = os.path.join(os.path.dirname(os.path.abspath(asm_path)), "symbols.txt")
    write_symbols_file(symbols, symbols_path)
    print(f"Wrote {hack_path} and {symbols_path}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python assembler.py <program.asm>")
        sys.exit(1)
    assemble(sys.argv[1])