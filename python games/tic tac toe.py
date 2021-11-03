# Tic tac toe - David McPherson

# 1. Libraries
from tkinter import *
from random import seed, randint

# 2. Data Structures
seed()

# 3. Variables
global gameOn, lastStartAI, wins, losses, draws
gameOn = True
lastStartAI = False
wins = 0
losses = 0
draws = 0

# 4. Functions
def endgame(L):
    global gameOn, wins, losses
    gameOn = False
    s = status.get()
    if L == " X ":
        s = "You Win!"
        wins += 1
        win.set(wins)
    elif L == " O ":
        s = "You Lose!"
        losses += 1
        loss.set(losses)
    status.set(s)
    newGameBtn.grid(row = 2, column = 4)

def checkWin(ai = False):
    n = ['']
    for k in range(1, 10):
        nx = 'n.append(b' + str(k) + '.get())'
        exec(nx)
    if ai == True:
        L = " O "
    else:
        L = " X "
    if n[1]==L and n[2]==L and n[3]==L:
        return endgame(L)
    if n[4]==L and n[5]==L and n[6]==L:
        return endgame(L)
    if n[7]==L and n[8]==L and n[9]==L:
        return endgame(L)
    if n[1]==L and n[4]==L and n[7]==L:
        return endgame(L)
    if n[2]==L and n[5]==L and n[8]==L:
        return endgame(L)
    if n[3]==L and n[6]==L and n[9]==L:
        return endgame(L)
    if n[1]==L and n[5]==L and n[9]==L:
        return endgame(L)
    if n[3]==L and n[5]==L and n[7]==L:
        return endgame(L)
    if ai == False:
        checkWin(True)

def checkDraw():
    global draws
    s = status.get()
    if s != "Your turn.":
        return None
    for x in range(1, 10):
        y = 'b' + str(x) + '.get() == "     "'
        if eval(y) == True:
            return None
    status.set("Draw.")
    draws += 1
    draw.set(draws)
    newGameBtn.grid(row = 2, column = 4)

def winningMove(ai = False):
    n = ['']
    for k in range(1, 10):
        nx = 'n.append(b' + str(k) + '.get())'
        exec(nx)
    if ai == True:
        L = " O "
    else:
        L = " X "
    if n[1]=='     ' and(n[2]==L and n[3]==L or n[4]==L and n[7]==L or n[5]==L and n[9]==L):
        return 1
    if n[2]=='     ' and(n[1]==L and n[3]==L or n[5]==L and n[8]==L):
        return 2
    if n[3]=='     ' and(n[1]==L and n[2]==L or n[5]==L and n[7]==L or n[6]==L and n[9]==L):
        return 3
    if n[4]=='     ' and(n[1]==L and n[7]==L or n[5]==L and n[6]==L):
        return 4
    if n[5]=='     ' and(n[1]==L and n[9]==L or n[2]==L and n[8]==L or n[3]==L and n[7]==L or n[4]==L and n[6]==L):
        return 5
    if n[6]=='     ' and(n[3]==L and n[9]==L or n[4]==L and n[5]==L):
        return 6
    if n[7]=='     ' and(n[1]==L and n[4]==L or n[3]==L and n[5]==L or n[8]==L and n[9]==L):
        return 7
    if n[8]=='     ' and(n[2]==L and n[5]==L or n[7]==L and n[9]==L):
        return 8
    if n[9]=='     ' and(n[1]==L and n[5]==L or n[3]==L and n[6]==L or n[7]==L and n[8]==L):
        return 9
    return 10

def aiClick(b, overflow = False):
    global gameOn, draws
    n = 'b' + str(b)
    m = n + '.get()'
    m = eval(m)
    if m == " X " or m == " O ": # BUG
        if b < 9:
            b += 1
            aiClick(b, overflow)
        elif overflow == False:
            aiClick(1, True)
        else:
            status.set("Draw.")
            draws += 1
            draw.set(draws)
            newGameBtn.grid(row = 2, column = 4)
            gameOn = False
        return None
    n += '.set(" O ")'
    eval(n)

def aiTurn():
    global gameOn  
    if gameOn == False:
        newGameBtn.grid(row = 2, column = 4)
        return None
    x = winningMove(True)
    if x == 10:
        x = winningMove()
    if x == 10:
        x = randint(1, 9) # Minimax alg goes here
    aiClick(x)
    checkWin(True)
    checkDraw()

def playerClick(b):
    global gameOn
    if gameOn == False:
        newGameBtn.grid(row = 2, column = 4)
        return None
    n = 'b' + str(b)
    m = n + '.get()'
    m = eval(m)
    if m == " X " or m == " O ":
        return None
    n += '.set(" X ")'
    eval(n)
    checkWin()
    aiTurn()
    
def newGame():
    global gameOn, lastStartAI
    for x in range(1, 10):
        y = 'b' + str(x) + '.set("     ")'
        eval(y)
    gameOn = True
    if lastStartAI == False:
        aiTurn()
    lastStartAI = not lastStartAI
    status.set("Your turn.")
    newGameBtn.grid_remove()
        
# 5. Graphical User Interface
root = Tk()
root.title("Tic-Tac-Toe")
root.geometry("300x105")

b1 = StringVar()
b1.set("     ")
button1 = Button(root, textvariable = b1, command = lambda: playerClick(1))
button1.grid(row = 0, column = 0)

b2 = StringVar()
b2.set("     ")
button2 = Button(root, textvariable = b2, command = lambda: playerClick(2))
button2.grid(row = 0, column = 1)

b3 = StringVar()
b3.set("     ")
button3 = Button(root, textvariable = b3, command = lambda: playerClick(3))
button3.grid(row = 0, column = 2)

b4 = StringVar()
b4.set("     ")
button4 = Button(root, textvariable = b4, command = lambda: playerClick(4))
button4.grid(row = 1, column = 0)

b5 = StringVar()
b5.set("     ")
button5 = Button(root, textvariable = b5, command = lambda: playerClick(5))
button5.grid(row = 1, column = 1)

b6 = StringVar()
b6.set("     ")
button6 = Button(root, textvariable = b6, command = lambda: playerClick(6))
button6.grid(row = 1, column = 2)

b7 = StringVar()
b7.set("     ")
button7 = Button(root, textvariable = b7, command = lambda: playerClick(7))
button7.grid(row = 2, column = 0)

b8 = StringVar()
b8.set("     ")
button8 = Button(root, textvariable = b8, command = lambda: playerClick(8))
button8.grid(row = 2, column = 1)

b9 = StringVar()
b9.set("     ")
button9 = Button(root, textvariable = b9, command = lambda: playerClick(9))
button9.grid(row = 2, column = 2)

status = StringVar()
status.set("Your turn.")
statusLbl = Label(root, textvariable = status)
statusLbl.grid(row = 0, column = 4)

scoreboard = Label(root, text = "Wins/Losses/Draws:")
scoreboard.grid(row = 1, column = 4)

win = StringVar()
win.set("0")
winLbl = Label(root, textvariable = win)
winLbl.grid(row = 1, column = 5)

loss = StringVar()
loss.set("0")
lossLbl = Label(root, textvariable = loss)
lossLbl.grid(row = 1, column = 6)

draw = StringVar()
draw.set("0")
drawLbl = Label(root, textvariable = draw)
drawLbl.grid(row = 1, column = 7)

newGameBtn = Button(root, text = "New Game", command = newGame)
#newGameBtn.grid(row = 2, column = 4) # Uncomment me if "New Game" button won't reappear when it should.

root.mainloop()
