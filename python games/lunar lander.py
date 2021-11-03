# Lunar Lander (command line game)
# Game created: January, 2020
# Last updated: March, 2021
# David McPherson

# This game will run in Python 3 and in Visual Studio.

# Solutions are commented at the bottom of this code.

# The last burn will show 2 values: one for a hard landing
# (maximimum fuel savings) and one for a smooth landing
# (skilled piloting).


# Intro info
print()
print('Welcome to Lunar Lander!')
print('The goal is to land at under 5 m/s, using the throttle.')
print('The throttle goes from 0 to 75.')
print()
print('Level 1: easy()')
print('Level 2: normal()')
print('Level 3: moderate()')
print('Level 4: hard()')
print()


# Prints navigation info after each throttle input
def nav(altitude = 2500, velocity = -600, fuel = -650, throttle = 0, printThrottle = False):
    if printThrottle == True:
        print('Throttle: ' + str(throttle))
    print('Altitude: ' + str(altitude) + ' m.')
    print('Velocity: ' + str(velocity) + ' m/s.')
    print('Fuel: ' + str(fuel) + ' kg.')
    print()
    

# Takes a throttle input, checks if it's valid (between 0 and 75 and 
# enough fuel is available) and returns the corrected throttle/fuel values.
def fuel(throttle, petrol, printThrottle = False):
    if throttle > 75:
        throttle = 75
        printThrottle = True
        
    if throttle < 0:
        return 0, petrol, True
    
    if throttle >= petrol:
        throttle = petrol
        print('Out of fuel!')
        print('Throttle: ' + str(throttle))
        return throttle, throttle, False
    return throttle, petrol, printThrottle


# This is the main function that controls the game.
# Parameter a: altitude (ground is 0)
# Parameter b: vertical velocity (down is negative)
# Parameter f: fuel
def play(a = 2500, v = -600, f = 650, achievement = False):
    # Achievement should only be activated on hard() mode.
    
    print()
    altitude = a
    velocity = v
    petrol = f
    t = 0
    noInput = False
    
    while a > 0:
        nav(a, v, f, t, noInput)
        noInput = False
        if f > 0:
            try:
                t = float(input('Throttle (0-75): '))
                if round(t) != t:
                    noInput = True
                t = round(t)
            except:
                noInput = True
            x = fuel(t, f, noInput)
            t = x[0]
            f = x[1]
            noInput = x[2]
        else:
            f = 0
            t = 0   
        f -= t
        v += t - 5
        a += v
        
    a -= v
    v += 5
    v = abs(v)
    a = abs(a)
    v += a
    speed = ' m/s'
    if v == 1:
        speed = ' m/s, the lowest possible speed'
    landed = "You've landed safely at " + str(v) + speed + ", with " + str(f)+ " kg of fuel left."
    crash = "You hit the ground at " + str(v) + " m/s."
    if v > 5:
        print("You've crashed!")
        print(crash)
    else:
        print(landed)
        if achievement == True:
            print("Achievement unlocked: 'Suicide burn'")
    print()
    level = input("Enter a difficult level (1-4) or enter 0 to quit: ")
    if level == '1':
        easy()
    elif level == '2':
        normal()
    elif level == '3':
        moderate()
    elif level == '4':
        hard()

def easy():
    play(1000, -100, 1000)
    # Optimal burn sequence: 0*7, 26, 74, 41/45

def normal():
    play(1500, -400, 600)
    # Optimal burn sequence: 0, 53, 75*4, 73, 5/9

def moderate():
    play()
    # Optimal burn sequence: 48, 75*4, 74, 75*2, 64/68

def hard():
    play(5000, -750, 806, True)
    # Optimal burn sequence: 0, 25, 75, 74, 75*9 (fuel will run out)


level = input("Enter a difficult level (1-4) or enter 0 to quit: ")
if level == '1':
    easy()
elif level == '2':
    normal()
elif level == '3':
    moderate()
elif level == '4':
    hard()
