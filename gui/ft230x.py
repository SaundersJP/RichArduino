from pyftdi.ftdi import Ftdi
from tkinter import messagebox
from tkinter import filedialog
from tkinter import *
from guiAssemble import *
from time import sleep
import binascii

top = Tk()

def clearCallback():
    f1.write_data(str.encode('c'))
    f1.read_data_bytes(1, attempt=1000)
def callback():
    toSend = strVariable.get()
    msgLength = len(toSend)
    msgAsBytes = str.encode(toSend)

    if toSend == '?':
        print(msgAsBytes)
        f1.write_data(msgAsBytes)
        data =  f1.read_data_bytes(msgLength, attempt=1000)
        print(len(data))

        print(data)
        return

    else:
        f1.write_data(bytes([109]))
        while(True):
            a = f1.read_data_bytes(1, attempt=1000)
            if len(a):
                print(a)
                break
        f1.write_data(bytes([len(msgAsBytes)]))
        while (True):
            a = f1.read_data_bytes(1, attempt=1000)
            if len(a):
                print(a)
                break
        for character in msgAsBytes:
            f1.write_data(bytes([character]))
            while (True):
                a = f1.read_data_bytes(1, attempt=1000)
                if len(a):
                    print(a)
                    break

def fileButtonCallback():
    top.filename = filedialog.askopenfilename(initialdir = '/home/jonny/cse462/', title='Select .asm program', filetypes = [('assembly file','*.asm')])
    if top.filename:
        top.assembly = assemble(top.filename)
        print("sending program signal")
        f1.write_data(str.encode('p'))
        #f1.write_data(len(top.assembly))
        print(f1.read_data_bytes(1, attempt=100))
        print("sending length data" + str(len(top.assembly)))
        f1.write_data(bytes([len(top.assembly)]))
        print(f1.read_data_bytes(1, attempt=100))
        i = 0
        for line in top.assembly:
            print("line " + str(i) + " of assembly" )
            j = 1
            for byte1 in reversed(line):
                # print("Sending byte " + str(j))
                f1.write_data(bytes([byte1]))
                dout = f1.read_data_bytes(1, attempt=10000)
                # print("data sent = " + str(int(byte1)) + ". Recieved back " + str(dout))
                # print()
                j+=1
            i += 1

strVariable = StringVar(top)

L1 = Label(top, text="Serial Terminal")
L1.grid(row=0, column=0)
E1 = Entry(top, textvariable=strVariable,bd = 5)
E1.grid(row=0, column=1)

MyButton1 = Button(top, text="Submit", width=10, command=callback)
MyButton1.grid(row=1, column=1)
fileButton = Button(top, text="Select program", width=10, command=fileButtonCallback)
fileButton.grid(row=2, column=1)
clearButton = Button(top, text="Clear", width=10, command=clearCallback)
clearButton.grid(row=3, column=1)
f1 = Ftdi.create_from_url('ftdi:///1')
f1.set_baudrate(115200)
data1 = f1.modem_status()
print(data1)
top.mainloop()


