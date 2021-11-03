import math
print("sci(x) turns decimal into scientific notation.")
def sci(x):
    if type(x) == bool:
        return("Try a bool? You're a fool.")
    
    try:
        x = float(x)
    except:
        return("Your input must be a number.")
    
    if x == 0:
        return(0)

##<Scientific Notation code>
    
    if x > 0:
        n = math.log(x, 10)
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
        n = math.log(x, 10)
        a = 10**(n - int(n))
        n = int(n)
        if a < 1:
            a = 10 * a
            n = n - 1
        a = round(a, 2)
        sci = '-' + str(a) + '*10^' + str(n)
    return(sci)
