'''
David McPherson's math shortcuts
2020W Term 2

These functions should help me with math and physics homework
'''

print()
print("dot(a, b)")
print("norm(a) computes a vector length")
print("unit(a) turns a vector into a unit vector")
print("proj(a, b) projects vector a onto vector b")
print("angle(a, b) finds the angle between two vectors")
print("integral(y, start, end)")
print("vol(y, start, end) computes the volume of a solid of revolution")
print("det(a, b) computes a determinant")
print("cross(a, b)")
print("planeIntersect(plane 1, plane 2)")
print("toGeneral(parametric_form)")
print("sci(x)")

print()

'''
STUFF TO ADD:
- linDependent([[x1], [x2], [x3])
- row echelon form
'''

from math import *

def dot(a = [1, 2], b = [2, 1]):
    n = len(a)
    if n != len(b):
        return 'Vectors must be the same length'
    s = 0
    for c in range(n):
        s += a[c]*b[c]
    return s


def norm(a = [3, 4]):
    n = len(a)
    s = 0
    for c in range(n):
        s += a[c]**2
    s = s**0.5
    return s


def unit(a = [3, 4]):
    r = norm(a)
    n = len(a)
    v = []
    for k in range(n):
        v.append(round(a[k]/r, 6))
    return v


def proj(a = [1, 1], b = [1, 0]):
    # projection of vector a onto vector b
    direction = unit(b)
    magnitude = dot(a, direction)
    direction[0] = round(direction[0]*magnitude, 6)
    direction[1] = round(direction[1]*magnitude, 6)
    return direction


def angle(a = [1, 1, 1], b = [1, 2, 3], radians = False):
    ang = acos(dot(a,b)/(norm(a)*norm(b)))
    if radians == False:
        ang = ang*180/pi
    ang = round(ang, 6)
    return ang


def integral(y = 'x + 1', start = 0, end = 1, n = 100000):
    area = 0
    dx = (end - start)/n
    for i in range(n):
        x = start + (0.5 + i)*dx
        area += eval(y)*dx
    return round(area, 9)

def rIntegral(y = 'x + 1', start = 0, end = 1, n = 100):
    area = 0
    dx = (end - start)/n
    for i in range(n):
        x = start + (1 + i)*dx
        area += eval(y)*dx
    return round(area, 9)

def lIntegral(y = 'x + 1', start = 0, end = 1, n = 100):
    area = 0
    dx = (end - start)/n
    for i in range(n):
        x = start + i*dx
        area += eval(y)*dx
    return round(area, 9)

def vol(y = 'x + 1', start = 0, end = 1, n = 10000):
    volume = 0
    dx = (end - start)/n
    for i in range(n):
        x = start + (0.5 + i)*dx
        volume += pi*eval(y)**2*dx
    return round(volume, 9)


def avg(y = 'x + 1', start = 0, end = 1, n = 10000):
    return round(integral(y, start, end, n)/(end-start), 9)

def det(a = [1, 2], b = [5, 2], c = []):
    i = len(a)
    j = len(b)
    k = len(c)
    if i == 2 and j == 2 and k == 0:
        x = a[0]*b[1] - a[1]*b[0]
    elif i == 3 and j == 3 and k == 3:
        x = a[0]*(b[1]*c[2]-b[2]*c[1]) - a[1]*(b[0]*c[2]-b[2]*c[0]) + a[2]*(b[0]*c[1]-b[1]*c[0])
    return x 

def cross(a = [1, 2, 0], b = [-4, 1, -1]):
    i = a[1]*b[2]-a[2]*b[1]
    j = a[2]*b[0]-a[0]*b[2]
    k = a[0]*b[1]-a[1]*b[0]
    return[i, j, k]


# This function has not been properly tested yet
def planeIntersect(x1=1, y1=-2, z1=3, d1=0, x2=4, y2=-3, z2=2, d2=5):
    norm1 = [x1, y1, z1]
    norm2 = [x2, y2, z2]
    direction = unit(cross(norm1, norm2))

    ''' find a point on both planes:
     assume z = 0, giving this system of equations:
     x1*x + y1*y = d1
     x2*x + y2*y = d2
     y = (d1 - x1*x)/y1
     x2*x + y2/y1*(d1-x1*x) = d2
     x2*x + d1*y2/y1 - x*x1*y2/y1 = d2
     x*(x2 - x1*y2/y1) = d2 - d1*y2/y1 '''
        
    x = (d2 - d1*y2/y1)/(x2 - x1*y2/y1)
    y = (d1 - x1*x)/y1
    point = [x, y, 0]
    equation = str(point) + ' + s'+ str(direction)
    return equation


def toGeneral(point, vector1, vector2):
    normalVector = cross(vector1, vector2)
    a = normalVector[0]
    b = normalVector[1]
    c = normalVector[2]
    d = a * point[0] + b * point[1] + c * point[2]
    equation = str(a)+'x + '+str(b)+'y + '+str(c)+ 'z = ' + str(d)
    # 'ax + by + cz = d'
    return equation


def rowEch(equations = [[], [], []]):
    ''' Pseudo code:
    find out how many rows there are
    last row: set leading coef to 0
        find the coef ratio between last row and first row
        add the last row to a multiple of that row to kill the first coef
    next to last row: kill leading coef with previous row
    keep going until there's only 1 equation left with a first coef
    go to next row, kill second coef
    keep going until there are 2 equations with second coef
    keep going until you reach the last coef

    figure out how to print the matrix, one row at a time
    '''
    
    return None

def sci(x):  
    try:
        x = float(x)
    except:
        return("Your input must be a number.")
    
    if x == 0:
        return(0)

##<Scientific Notation code>
    
    if x > 0:
        n = log(x, 10)
        a = 10**(n - int(n))
        n = int(n)
        if a < 1:
            a = 10 * a
            n = n - 1
        a = round(a, 2)
        sci = str(a) + '*10^' + str(n)
        
##</Scientific Notation code>
        
    if x < 0:
        x = -x  
        n = log(x, 10)
        a = 10**(n - int(n))
        n = int(n)
        if a < 1:
            a = 10 * a
            n = n - 1
        a = round(a, 2)
        sci = '-' + str(a) + '*10^' + str(n)
    return(sci)

