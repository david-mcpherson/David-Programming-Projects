# Connect Four - David McPherson

# 1. Data Libraries
from tkinter import *
from random import *


# 2. Data Structures
seed()


# 3. Variables
empty = "          "
x = "    x    " # player
o = "    o    " # ai
global lastStartAI, gameOn, board
gameOn = True
lastStartAI = False
board = [[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]]

# 4. Functions
def endgame(ai = False):
    global gameOn
    gameOn = False
    if ai == False:
        win.set(win.get()+1)
        status.set("You Win!")
    else:
        loss.set(loss.get()+1)
        status.set("You Lose!")

def checkDraw():
    for k in range(1, 43):
        e = 's' + str(k) + '.get() == empty'
        if eval(e) == True:
            return None
    global gameOn
    gameOn = False
    draw.set(draw.get()+1)
    status.set("Draw.")

def checkWin(r, ai = False):
    if ai == False:
        q = x
    else:
        q = o
    row = r % 6
    if row == 0:
        row = 6
    column = r // 7 + 1
    column = (r-1)//6 + 1
    # vertical
    rowLength = 1
    if row >= 2: # above
        e = 's' + str(r-1) + '.get() == q'
        if eval(e) == True:
            rowLength = 2
            if row >= 3:
                e = 's' + str(r-2) + '.get() == q'
                if eval(e) == True:
                    rowLength = 3
                    if row >= 4:
                        e = 's' + str(r-3) + '.get() == q'
                        if eval(e) == True:
                            rowLength = 4
    if row <= 5 and row != 0: # below
        e = 's' + str(r+1) + '.get() == q'
        if eval(e) == True:
            rowLength += 1
            if row <= 4:
                e = 's' + str(r+2) + '.get() == q'
                if eval(e) == True:
                    rowLength += 1
                    if row <= 3:
                        e = 's' + str(r+3) + '.get() == q'
                        if eval(e) == True:
                            rowLength += 1
    if rowLength >= 4:
        endgame(ai)
        return None
                    
    # horizontal
    rowLength = 1
    if column >= 2: # right
        e = 's' + str(r-6) + '.get() == q'
        if eval(e) == True:
            rowLength = 2
            if column >= 3:
                e = 's' + str(r-12) + '.get() == q'
                if eval(e) == True:
                    rowLength = 3
                    if column >= 4:
                        e = 's' + str(r-18) + '.get() == q'
                        if eval(e) == True:
                            rowLength = 4
    if column <= 6: # left
        e = 's' + str(r+6) + '.get() == q'
        if eval(e) == True:
            rowLength += 1
            if column <= 5:
                e = 's' + str(r+12) + '.get() == q'
                if eval(e) == True:
                    rowLength += 1
                    if column <= 4:
                        e = 's' + str(r+18) + '.get() == q'
                        if eval(e) == True:
                            rowLength += 1
    if rowLength >= 4:
        endgame(ai)
        return None
    '''
    Bug: connect 4 horizontal all on right side
    final square isn't the right edge
    '''
    # diagonal(\)
    rowLength = 1 # up-left
    if row >= 2 and column >= 2:
        e = 's' + str(r-7) + '.get() == q'
        if eval(e) == True:
            rowLength = 2
            if row >= 3 and column >= 3:
                e = 's' + str(r-14) + '.get() == q'
                if eval(e) == True:
                    rowLength = 3
                    if row >= 4 and column >= 4:
                        e = 's' + str(r-21) + '.get() == q'
                        if eval(e) == True:
                            rowLength = 4
    if row <= 5 and column <= 6: # down-right
        e = 's' + str(r+7) + '.get() == q'
        if eval(e) == True:
            rowLength += 1
            if row <= 4 and column <= 5:
                e = 's' + str(r+14) + '.get() == q'
                if eval(e) == True:
                    rowLength += 1
                    if row <= 3 and column <= 4:
                        e = 's' + str(r+21) + '.get() == q'
                        if eval(e) == True:
                            rowLength += 1
    if rowLength >= 4:
        endgame(ai)
        return None
    
    # diagonal(/)
    rowLength = 1 # up-right
    if row >= 2 and column <= 6:
        e = 's' + str(r+5) + '.get() == q'
        if eval(e) == True:
            rowLength = 2
            if row >= 3 and column <= 5:
                e = 's' + str(r+10) + '.get() == q'
                if eval(e) == True:
                    rowLength = 3
                    if row >= 4 and column <= 4:
                        e = 's' + str(r+15) + '.get() == q'
                        if eval(e) == True:
                            rowLength = 4
    if row <= 5 and column >= 2: # down-left
        e = 's' + str(r-5) + '.get() == q'
        if eval(e) == True:
            rowLength += 1
            if row <= 4 and column >= 3:
                e = 's' + str(r-10) + '.get() == q'
                if eval(e) == True:
                    rowLength += 1
                    if row <= 3 and column >= 4:
                        e = 's' + str(r-15) + '.get() == q'
                        if eval(e) == True:
                            rowLength += 1
    if rowLength >= 4:
        endgame(ai)
        return None

def undoDrop(c):
    m = 6 * c
    s = m - 5
    e = 's' + str(s) + '.get()'
    while eval(e) == empty and s <= m:
        s += 1
        e = 's' + str(s) + '.get()'
    n = 's' + str(s) + '.set(empty)'
    exec(n)
    
def winningMove(ai = False):
    global gameOn
    for c in range(1, 8):
        e = 's' + str(6*c-5) + '.get() == empty'
        if eval(e) == True:
            drop(c, ai, True)
            if eval('status.get() == "Your turn."') == True:
                undoDrop(c)
            else:
                if ai == False:
                    win.set(win.get()-1)
                    status.set("Your turn.")
                    gameOn = True
                    undoDrop(c)
                    drop(c, True)
                return True
    return False
    
def aiTurn():
    t = winningMove(True)
    if t == False:
        t = winningMove()
    if t == False:
        t = randint(1, 7) # Minimax goes here
        drop(t, True)
        
def drop(c, ai = False, check = False, overflow = False):
    global gameOn
    if gameOn == False:
        return None
    r = 6 * c
    k = r - 6
    e = 's' + str(r) + '.get() == empty'
    while r > k and eval(e) == False:
        r -= 1
        e = 's' + str(r) + '.get() == empty'
    if r == k or r == 0:
        if ai == False:
            return None
        if c == 7 and overflow == False:
            drop(1, True, check, True)
            return None
        elif c == 7 and overflow == True:
            draw.set(draw.get()+1)
            status.set("Draw.")
            gameOn = False
            return None
        else:
            c += 1
            drop(c, True, check, overflow)
            return None
    if ai == False:
        f = x
    else:
        f = o
    n = 's' + str(r) + '.set(f)'
    exec(n)
    checkWin(r, ai)
    if ai == False and check == False:
        aiTurn()
    else:
        checkDraw()
        
def reset():
    global lastStartAI, gameOn
    gameOn = True
    status.set("Your turn.")
    n = 1
    while n <= 42:
        e = 's' + str(n) + '.set(empty)'
        eval(e)
        n += 1
    if lastStartAI == False:
        lastStartAI = True
        aiTurn()
    else:
        lastStartAI = False

# 5. Graphical User Interface
r = Tk()
r.title("Connect Four")
r.geometry("510x190")

status = StringVar()
status.set("Your turn.")
statusLbl = Label(r, textvariable = status).grid(row=2, column=7)

scoreboard = Label(r, text = "Wins/Losses/Draws:").grid(row=4, column=7)
win = IntVar()
loss = IntVar()
draw = IntVar()
winLbl = Label(r, textvariable=win).grid(row=4, column=8)
lossLbl = Label(r, textvariable=loss).grid(row=4, column=9)
drawLbl = Label(r, textvariable=draw).grid(row=4, column=10)

reset=Button(r, text="New Game", command = reset).grid(row=0, column=7)

d1=Button(r, text="Drop", command=lambda:drop(1)).grid(row=0, column=0)
d2=Button(r, text="Drop", command=lambda:drop(2)).grid(row=0, column=1)
d3=Button(r, text="Drop", command=lambda:drop(3)).grid(row=0, column=2)
d4=Button(r, text="Drop", command=lambda:drop(4)).grid(row=0, column=3)
d5=Button(r, text="Drop", command=lambda:drop(5)).grid(row=0, column=4)
d6=Button(r, text="Drop", command=lambda:drop(6)).grid(row=0, column=5)
d7=Button(r, text="Drop", command=lambda:drop(7)).grid(row=0, column=6)

s1 = StringVar()
s1.set(empty)
s2 = StringVar()
s2.set(empty)
s3 = StringVar()
s3.set(empty)
s4 = StringVar()
s4.set(empty)
s5 = StringVar()
s5.set(empty)
s6 = StringVar()
s6.set(empty)
s7 = StringVar()
s7.set(empty)
s8 = StringVar()
s8.set(empty)
s9 = StringVar()
s9.set(empty)
s10 = StringVar()
s10.set(empty)
s11 = StringVar()
s11.set(empty)
s12 = StringVar()
s12.set(empty)
s13 = StringVar()
s13.set(empty)
s14 = StringVar()
s14.set(empty)
s15 = StringVar()
s15.set(empty)
s16 = StringVar()
s16.set(empty)
s17 = StringVar()
s17.set(empty)
s18 = StringVar()
s18.set(empty)
s19 = StringVar()
s19.set(empty)
s20 = StringVar()
s20.set(empty)
s21 = StringVar()
s21.set(empty)
s22 = StringVar()
s22.set(empty)
s23 = StringVar()
s23.set(empty)
s24 = StringVar()
s24.set(empty)
s25 = StringVar()
s25.set(empty)
s26 = StringVar()
s26.set(empty)
s27 = StringVar()
s27.set(empty)
s28 = StringVar()
s28.set(empty)
s29 = StringVar()
s29.set(empty)
s30 = StringVar()
s30.set(empty)
s31 = StringVar()
s31.set(empty)
s32 = StringVar()
s32.set(empty)
s33 = StringVar()
s33.set(empty)
s34 = StringVar()
s34.set(empty)
s35 = StringVar()
s35.set(empty)
s36 = StringVar()
s36.set(empty)
s37 = StringVar()
s37.set(empty)
s38 = StringVar()
s38.set(empty)
s39 = StringVar()
s39.set(empty)
s40 = StringVar()
s40.set(empty)
s41 = StringVar()
s41.set(empty)
s42 = StringVar()
s42.set(empty)

sq1 =Label(r, borderwidth=2, textvariable= s1, relief="groove").grid(row=1, column=0)
sq2 =Label(r, borderwidth=2, textvariable= s2, relief="groove").grid(row=2, column=0)
sq3 =Label(r, borderwidth=2, textvariable= s3, relief="groove").grid(row=3, column=0)
sq4 =Label(r, borderwidth=2, textvariable= s4, relief="groove").grid(row=4, column=0)
sq5 =Label(r, borderwidth=2, textvariable= s5, relief="groove").grid(row=5, column=0)
sq6 =Label(r, borderwidth=2, textvariable= s6, relief="groove").grid(row=6, column=0)
sq7 =Label(r, borderwidth=2, textvariable= s7, relief="groove").grid(row=1, column=1)
sq8 =Label(r, borderwidth=2, textvariable= s8, relief="groove").grid(row=2, column=1)
sq9 =Label(r, borderwidth=2, textvariable= s9, relief="groove").grid(row=3, column=1)
sq10=Label(r, borderwidth=2, textvariable=s10, relief="groove").grid(row=4, column=1)
sq11=Label(r, borderwidth=2, textvariable=s11, relief="groove").grid(row=5, column=1)
sq12=Label(r, borderwidth=2, textvariable=s12, relief="groove").grid(row=6, column=1)
sq13=Label(r, borderwidth=2, textvariable=s13, relief="groove").grid(row=1, column=2)
sq14=Label(r, borderwidth=2, textvariable=s14, relief="groove").grid(row=2, column=2)
sq15=Label(r, borderwidth=2, textvariable=s15, relief="groove").grid(row=3, column=2)
sq16=Label(r, borderwidth=2, textvariable=s16, relief="groove").grid(row=4, column=2)
sq17=Label(r, borderwidth=2, textvariable=s17, relief="groove").grid(row=5, column=2)
sq18=Label(r, borderwidth=2, textvariable=s18, relief="groove").grid(row=6, column=2)
sq19=Label(r, borderwidth=2, textvariable=s19, relief="groove").grid(row=1, column=3)
sq20=Label(r, borderwidth=2, textvariable=s20, relief="groove").grid(row=2, column=3)
sq21=Label(r, borderwidth=2, textvariable=s21, relief="groove").grid(row=3, column=3)
sq22=Label(r, borderwidth=2, textvariable=s22, relief="groove").grid(row=4, column=3)
sq23=Label(r, borderwidth=2, textvariable=s23, relief="groove").grid(row=5, column=3)
sq24=Label(r, borderwidth=2, textvariable=s24, relief="groove").grid(row=6, column=3)
sq25=Label(r, borderwidth=2, textvariable=s25, relief="groove").grid(row=1, column=4)
sq26=Label(r, borderwidth=2, textvariable=s26, relief="groove").grid(row=2, column=4)
sq27=Label(r, borderwidth=2, textvariable=s27, relief="groove").grid(row=3, column=4)
sq28=Label(r, borderwidth=2, textvariable=s28, relief="groove").grid(row=4, column=4)
sq29=Label(r, borderwidth=2, textvariable=s29, relief="groove").grid(row=5, column=4)
sq30=Label(r, borderwidth=2, textvariable=s30, relief="groove").grid(row=6, column=4)
sq31=Label(r, borderwidth=2, textvariable=s31, relief="groove").grid(row=1, column=5)
sq32=Label(r, borderwidth=2, textvariable=s32, relief="groove").grid(row=2, column=5)
sq33=Label(r, borderwidth=2, textvariable=s33, relief="groove").grid(row=3, column=5)
sq34=Label(r, borderwidth=2, textvariable=s34, relief="groove").grid(row=4, column=5)
sq35=Label(r, borderwidth=2, textvariable=s35, relief="groove").grid(row=5, column=5)
sq36=Label(r, borderwidth=2, textvariable=s36, relief="groove").grid(row=6, column=5)
sq37=Label(r, borderwidth=2, textvariable=s37, relief="groove").grid(row=1, column=6)
sq38=Label(r, borderwidth=2, textvariable=s38, relief="groove").grid(row=2, column=6)
sq39=Label(r, borderwidth=2, textvariable=s39, relief="groove").grid(row=3, column=6)
sq40=Label(r, borderwidth=2, textvariable=s40, relief="groove").grid(row=4, column=6)
sq41=Label(r, borderwidth=2, textvariable=s41, relief="groove").grid(row=5, column=6)
sq42=Label(r, borderwidth=2, textvariable=s42, relief="groove").grid(row=6, column=6)

r.mainloop()
