la r31,32768
la r30,36864
la r29,45056
la r28,4096
la r27,4096
la r22,40960
la r26,0
la r25,0
la r23,1
la r17,WAIT_LOOP_START
la r16,63
la r15,62
la r14,61
la r10,1
la r3,3
la r0,0
S1: ld r1,r31
andi r2,1(r1)
la r21,S1
brzr r21,r2
S2: ld r1,r30
andi r1,255(r1)
addi r2,-112(r1)
la r21,START_RECEIVING
brzr r21,r2
addi r2,-63(r1)
la r21,IS_ALIVE
brzr r21,r2
la r21,S1
st r3,r29
st r10,r22
br r21
IS_ALIVE: st r10,r29
st r10,r22
la r21,S1
br r21
START_RECEIVING: la r24,SET_LENGTH
la r20,PLACE_BYTE
la r21,GET_BYTE_1
st r10,r29 
st r10,r22
br r21
SET_LENGTH: addi r26,0(r5)
la r23,0
st r26,r29
st r10,r22
la r21,GET_BYTE_1
br r17
PLACE_BYTE: st r5,r27
addi r27,4(r27)
addi r25,1(r25)
sub r12,r26,r25
st r8,r29
st r10,r22
brzr r28,r12
la r21,GET_BYTE_1
br r17
GET_BYTE_1: ld r1,r31
andi r2,1(r1)
brzr r21,r2
ld r5,r30
andi r5,255(r5)
brnz r24,r23
st r5,r29
st r10,r22
la r21,GET_BYTE_2
br r17
GET_BYTE_2: ld r1,r31
andi r2,1(r1)
brzr r21,r2
ld r6,r30
andi r6,255(r6)
st r6,r29
st r10,r22
la r21,GET_BYTE_3
br r17
GET_BYTE_3: ld r1,r31
andi r2,1(r1)
brzr r21,r2
ld r7,r30
andi r7,255(r7)
st r7,r29
st r10,r22
la r21,GET_BYTE_4
br r17
GET_BYTE_4: ld r1,r31
andi r2,1(r1)
brzr r21,r2
ld r8,r30
andi r8,255(r8)
COMBINER: shl r6,r6,8
shl r7,r7,16
shl r8,r8,24
or r5,r5,r6
or r5,r5,r7
or r5,r5,r8
br r20
WAIT_LOOP_START: la r18,100
WAIT_LOOP_LOOP: addi r18,-1(r18)
la r19,WAIT_LOOP_LOOP
brnz r19,r18
br r21
