; Register A: 30118712
; Register B: 0
; Register C: 0

; Program: 2,4,1,3,7,5,4,2,0,3,1,5,5,5,3,0

2,4, b = a & 7
1,3, b ^= 3
7,5, c = a >> b
4,2, b ^= c
0,3, a >>= 3
1,5, b ^= 5
5,5, out b
3,0  loop

b = a & 7 ^ 3
b ^= a >> b
b ^= 5
