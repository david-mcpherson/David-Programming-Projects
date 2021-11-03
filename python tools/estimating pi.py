'''
David McPherson
28 Sep 2020

Estimating Pi

- Make a circle in a 2x2 square (r=1)
- Generate a 100 000 random points in the square
- Calculate what fraction were in the circle
- Multiply by four


NEW IDEA:
Draw a semi-circle with radius one and area pi/2: y = sqrt(1 - (x-1)**2)
Use the integral function to get this area and find pi.

'''

from random import *
seed()

print("Type 'pi()' to approximate pi")
print()

def gen():
    x = -1 + 2*random()
    y = -1 + 2*random()
    r = (x**2 + y**2)**(1/2)
    return r

def oldPi(n = 1000000):
    p = 0
    for t in range(n):
        if gen() < 1:
            p += 1
    
    return round(4*p/n, int(len(str(n))/2)+1)



def s(n = 1000000):
    z = 0
    p = 0
    while z < n:
        x = -1 + 2*random()
        y = -1 + 2*random()
        if (x**2 + y**2)**(1/2) < 1:
            p += 1
        z += 1
    return round(4*p/n, int(len(str(n))/2)+1)
    

def integral(y = 'x + 1', start = 0, end = 1, n = 100):
    n = int(n) # can input n = 1e6; this float becomes an int
    area = 0
    dx = (end - start)/n
    for i in range(n):
        x = start + (0.5 + i)*dx
        area += eval(y)*dx
    return round(area, 13)

def pi(n = 1e5):
    return integral('(1 - x**2)**0.5', 0, 1, n)*4

def newPi(n = 10000000):
    approxPi = 0
    for k in range(1, n):
        approxPi += 1/k**2
    approxPi = (6*approxPi)**0.5
    return round(approxPi, 10)

def clp(n = 10000):
    aprxPi = 0
    for k in range(1, n):
        aprxPi += (-1)**(n+1) / n**2
    return aprxPi**0.5*12
        

        
