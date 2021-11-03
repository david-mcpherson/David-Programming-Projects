'''
David McPherson
24-Sep-2020

Pascal's Triangle

Part 1: create a function to generate the n'th layer
of Pascal's Triangle.

n   Pascal's triangle
0          1
1         1 1
2        1 2 1
3       1 3 3 1
4      1 4 6 4 1
5    1 5 10 10 5 1
6   1 6 15 20 15 6 1
'''
from math import *

triangleName = 'tri.dat'
rows = 2000 # triangleName length

print()
print("filerow(n) is the n'th layer of Pascal's Triangle.")
print("drawTri(n) draws Pascal's Triangle to n layers.")
print("pq(n) distributes the binomial (p + q)^n")
print("p(successes, attempts, p) calculates a success probability.")
print("Maximum " + str(rows) + " trials.")
print()


def filerow(row, filename = triangleName):
	f =open(filename, 'r')
	for row in range(row):
		f.readline()
	c = f.readline()
	f.close()
	return eval(c[:-1])

def saveRows(lastSaved = rows, newEnd = rows + 2, filename = triangleName):
    a = filerow(lastSaved)
    f = open(filename, 'a')
    for r in range(lastSaved + 1, newEnd + 1):
        b = [1]
        for i in range(r-1):
            b.append(a[i] + a[i+1])
        b.append(1)
        a = b
        rowList = str(b) + '\n'
        f.write(rowList)
    f.close()
     
       
def t(n):
    if n == 0:
        return [1]
    a = t(n-1)
    b = [1]
    for i in range(n-1):
        b.append(a[i] + a[i+1])
    b.append(1)
    return b


def drawTri(n):
    for y in range(n+1):
        print(t(y))
'''
Part 2:
Turn layer of pascal's triangle into pq format
ex: [1, 3, 3, 1]
->  [p^3 + 3p^2*q + 3p*q^2 + q^3]
'''

def pq(n):
    if n < 0 or n != int(n):
        return 'Input must be a positive integer.'
    if n == 0:
        return 1
    if n == 1:
        return 'p + q'
    c = filerow(n)
    s = '(p + q)^' + str(n) + ' = p^' + str(n)
    for term in range(1, n):
        px = n - term
        if px == 1:
            px = ''
        else:
            px = '^'+str(px)
        qx = term
        if qx == 1:
            qx = ''
        else:
            qx = '^'+str(qx)
        y = ' + '+str(c[term])+'p'+px + '*q'+qx
        s += y
    s += ' + q^' + str(n)
    return s


'''
Part 3:
What is the chance of getting at least p successes
out of p + q trials?
'''


def p(successes, trials, p = 0.5):
    probability = 0
    q = 1 - p
    c = filerow(trials)
    cases = trials - successes + 1
    for term in range(cases):
        sLog = (trials - term) * log(p)
        fLog = term * log(q)
        cLog = log(c[term])
        termLog = sLog + fLog + cLog
        termProbability = e**termLog
        probability += termProbability
    return round(probability, 9)

