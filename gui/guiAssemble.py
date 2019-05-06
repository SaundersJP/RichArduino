import sys
from collections import defaultdict

#file_name = sys.argv[1]

symbol_table = defaultdict(lambda: -1)
k = 1
def switch(operator):
    return {
        'ld':   1,
        'ldr':  2,
        'st':   3,
        'str':  4,
        'la':   5,
        'lar':  6,
        'br':   8,
        'brz':  8,
        'brnz': 88,
        'brzr': 888,
        'brl':  9,
        'brlnz': 99,
        'add':  12,
        'addi': 13,
        'sub':  14,
        'neg':  15,
        'and':  20,
        'andi': 21,
        'or':   22,
        'ori':  23,
        'not':  24,
        'shr':  26,
        'shra': 27,
        'shl': 28,
        'shc': 29,
        '.org': -1
        }.get(operator, 0)

def intRegister(reg):
    val = {
        'r0':0,
        'r1':1,
        'r2':2,
        'r3':3,
        'r4':4,
        'r5':5,
        'r6':6,
        'r7':7,
        'r8':8,
        'r9':9,
        'r10':10,
        'r11':11,
        'r12':12,
        'r13':13,
        'r14':14,
        'r15':15,
        'r16':16,
        'r17':17,
        'r18':18,
        'r19':19,
        'r20':20,
        'r21':21,
        'r22':22,
        'r23':23,
        'r24':24,
        'r25':25,
        'r26':26,
        'r27':27,
        'r28':28,
        'r29':29,
        'r30':30,
        'r31':31
        }.get(reg)
    return format(val, '05b')

def generate_c2(val):
    if val < 0:
        return str(bin(val & 0b11111111111111111))[2:]
    return format(val, '017b')

def generate_c1(val):
    if val < 0:
        return str(bin(val & 0b1111111111111111111111))[2:]
    return format(val, '022b')

def generate_byte_string(line, PC):
    getOpCode = lambda x: format(x, '05b')
    case = switch(line[0])
    print(case)
    #if its invalid and not in symbol table
    if case == 0 and symbol_table[line[0][:-1]] == -1:
        raise ValueError("invalid op code")
    #if our first thing is in symbol table move over one
    elif symbol_table[line[0][:-1]] != -1:
        case = switch(line[1])
        reg = line[2].split(',')
    #otherwise we fine
    else:
        reg = line[1].split(',')
    for i in range(len(reg)):
        slot = reg[i]
        if symbol_table[slot] != -1:
            reg[i] = symbol_table[slot]
    print(line)
    ra = ''
    rb = ''
    rc = ''
    c2 = ''
    #load, addi, andi, ori, st, la
    if (case == 1 or case == 3 or case == 5 or
        case == 13 or case == 21 or case == 23):
        opcode = str(getOpCode(case))
        ra = intRegister(reg[0])
        disp = reg[1]
        locationOfDisp= disp.find('(')
        if locationOfDisp >= 0:
            endOfDisp = disp.find(')')
            rb = intRegister(disp[locationOfDisp + 1 : endOfDisp])
            c2 = generate_c2(int(disp[0:locationOfDisp]))
        else:
            if disp[0] == 'r':
                rb = intRegister(disp)
                c2 = generate_c2(0)
            else:
                rb = intRegister('r0')
                c2 = generate_c2(int(disp))

        return opcode+ra+rb+c2
    #load relative
    elif case == 2 or case == 4 or case == 6:
        opcode = getOpCode(case)
        ra = intRegister(reg[0])
        c1 = generate_c1(int(reg[1])-PC)
        return opcode+ra+c1

    #branch
    elif case == 8:
        opcode =getOpCode(case)
        rb = intRegister(reg[0])
        return opcode+format(0,'05b')+rb+format(0,'05b')+format(0,'09b')+format(1,'03b')
    elif case == 88:
        opcode = getOpCode(8)
        rb = intRegister(reg[0])
        rc = intRegister(reg[1])
        return opcode+format(0,'05b')+rb+rc+format(0,'09b')+format(3,'03b')
    elif case == 888:
        opcode = getOpCode(8)
        rb = intRegister(reg[0])
        rc = intRegister(reg[1])
        return opcode+format(0,'05b')+rb+rc+format(0,'09b')+format(2,'03b')
    #branch less
    elif case == 9:
        opcode = getOpCode(case)
        ra = intRegister(reg[0])
        rb = intRegister(reg[1])
        rc = intRegister(reg[2])
        return opcode+ra+rb+rc+format(0,'09b')+format(1,'03b')
    elif case == 99:
        opcode = getOpCode(9)
        ra = intRegister(reg[0])
        rb = intRegister(reg[1])
        rc = intRegister(reg[2])
        return opcode+ra+rb+rc+format(0,'09b')+format(3,'03b')
    #add
    elif case == 12 or case == 14 or case == 20 or case ==22:
        opcode = getOpCode(case)
        ra = intRegister(reg[0])
        rb = intRegister(reg[1])
        rc = intRegister(reg[2])
        return opcode+ra+rb+rc+format(0, '012b')
    #negate
    elif case == 15 or case == 24:
        opcode = getOpCode(case)
        ra = intRegister(reg[0])
        rb = intRegister('r0')
        rc = intRegister(reg[1])
        return opcode+ra+rb+rc+format(0, '012b')

    #shift cases
    # bit more complex inside
    elif case == 26 or case == 27 or case == 28 or case == 29:
        opcode = getOpCode(case)
        ra = intRegister(reg[0])
        rb = intRegister(reg[1])
        nextField = reg[2]
        if nextField[0] == 'r':
            rc = intRegister(nextField)
            return opcode+ra+rb+rc+format(0, '012b')
        else:
            
            return opcode+ra+rb+format(0,'012b')+intRegister('r' + str(reg[2]))

def assemble(filename):
    file_name = filename
    with open(file_name, 'r') as infile:
        lines1 = infile.readlines()

    program_counter = 0
    # first pass
    for i in range(len(lines1)):
        lines1[i] = lines1[i][:-1]
        lines1[i] = lines1[i].split(' ')
        potential_op = switch(lines1[i][0])
        if potential_op == -1:
            program_counter = int(lines1[i][1])
            continue

        elif not potential_op:
            symbol_table[lines1[i][0][:-1]] = str(program_counter)
        program_counter += 4
    # for i in range(len(lines)):
    #    generate_byte_string(line)
    results = []
    program_counter = 0
    lineNum = 1
    for i in range(len(lines1)):
        line = lines1[i]
        try:
            result = generate_byte_string(line, program_counter)
        except:
            #raise exception for ft230x
            print("error at line number: " + str(lineNum))
            return

        lineNum += 1
        if result:
            program_counter += 4
            results.append(result)
    returnList = []
    for result in results:
        res = hex(int(result, 2))
        res = str(res)[2:]
        if len(res) != 8:
            res = '0' + res
        print(res)
        returnList.append(bytes.fromhex(res))
    return returnList


if __name__=='__main__':
    file_name = sys.argv[1]
    lines = []
    with open(file_name, 'r') as infile:
        lines = infile.readlines()

    program_counter = 0
    #first pass
    for i in range(len(lines)):
        if not lines[i]:
            lines.pop(i)
        lines[i] = lines[i][:-1]
        lines[i] = lines[i].split(' ')
        potential_op = switch(lines[i][0])
        if potential_op == -1:
            program_counter =  int(lines[i][1])
            continue

        elif not potential_op:
            symbol_table[lines[i][0][:-1]] = str(program_counter)
        program_counter += 4
    #for i in range(len(lines)):
    #    generate_byte_string(line)
    results = []
    print(lines)
    program_counter = 0
    lineNum = 1
    for i in range(len(lines)):
        line = lines[i]
        try:
            result = generate_byte_string(line, program_counter)
        except:
            print("error at line number: " + str(lineNum))
            sys.exit()

        lineNum += 1
        if result:
            program_counter += 4
            results.append(result)
    with open("bytefile.out", 'wb') as outfile:
        count = 0
        for result in results:
            res = hex(int(result,2))
            res = str(res)[2:]
            if len(res) != 8:
                res = '0' + res
            #print(count)
            print('X"' + res + '"' + " WHEN " + '"'+ '{0:010b}'.format(count) + '",')
            outfile.write(bytes.fromhex(res))
            count += 1

