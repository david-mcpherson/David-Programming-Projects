'''
2048
David McPherson 17-Jan-2021
'''

# 1. Data Libraries
from tkinter import *
from random import *


# 2. Data Structures
seed()


# 3. Variables
empty = "      "


# 4. Functions
def labeler(n = 2):
    n = str(n)
    k = len(n)
    if k == 1:
        label = '  ' + n + '  '
    if k == 2:
        label = ' ' + n + ' '
    if k >= 3:
        label = n
    return label

def quicksave(save):
    for n in range(16):
        a = 's' + str(n+1) + '.set(labeler(save[' + str(n) + ']))'
        eval(a)

def over():
    for n in range(1, 17):
        if eval('s' + str(n) + '.get()') == empty:
            return False
    save = []
    for n in range(1, 17):
        a = 's' + str(n) + '.get()'
        x = int(eval(a))
        save.append(x)
    rowMerger()
    columnMerger()
    for n in range(1, 17):
        if eval('s' + str(n) + '.get()') == empty:
            quicksave(save)
            return False
    for n in range(16):
        a = 's' + str(n+1) + '.get()'
        x = int(eval(a))
        if save[n] != x:
            quicksave()
            return False
    return True
    
def numGen():    
    k = randint(1, 16)
    s = 's' + str(k) + '.get()'
    while eval(s) != empty:
        k = randint(1, 16)
        s = 's' + str(k) + '.get()'
    n = randint(1, 10)
    if n == 1:
        n = 4
    else:
        n = 2
    n = labeler(n)
    p = 's' + str(k) + '.set("' + n + '")'
    eval(p)
    if over() == True:
        win.set("Game over.")
        return None 

def checkFilled(rowPic, left):
    changes = False
    if left == True:
        e = 5
        f = -1
        for k in range(4):
            if rowPic[k] == 0:
                e = k
                break
        for k in range(4):
            if rowPic[3-k] == 1:
                f = 3-k
                break
        if e < f:
            changes = True
    elif left == False:
        e = -1
        f = 5
        for k in range(4):
            if rowPic[3-k] == 0:
                e = 3-k
                break
        for k in range(4):
            if rowPic[k] == 1:
                f = k
                break
        if e > f:
            changes = True
    return changes


def rowMerger(left = True):
    h = int(highScore.get())
    doesStuff = False
    for r in range(1, 5):
        row = []
        filled = []
        for column in range(r, 17, 4):
            i = 's' + str(column) + '.get()'
            i = eval(i)
            if i != empty:
                row.append(int(i))
                filled.append(1)
            else:
                filled.append(0)
        if checkFilled(filled, left) == True:
            doesStuff = True
                  
        allowMove = True
        if len(row) == 4:
            if row[2] == row[3] and (left  == False or (row[1] != row[2] or row[0] == row[1])):
                row.pop(3)
                row[2] = 2*row[2]
                if row[2] > h:
                    h = row[2]
                allowMove = False
                doesStuff = True
        if len(row) >= 3:
            if (row[0] != row[1] or left == False) and row[1] == row[2] and allowMove == True:
                row.pop(2)
                row[1] = 2*row[1]
                if row[1] > h:
                    h = row[1]
                allowMove = False
                doesStuff = True
            else:
                allowMove = True
        if len(row) >= 2:
            if row[0] == row[1] and allowMove == True:
                row.pop(1)
                row[0] = 2*row[0]
                if row[0] > h:
                    h = row[0]
                allowMove = False
                doesStuff = True
        for column in range(4):
            a = 's' + str(r+4*column) + '.set(empty)'
            eval(a)
        for column in range(len(row)):
            if left == True:
                q = r+4*column
            else:
                numEmpty = 4 - len(row)
                q = r+4*(column + numEmpty)
            a = 's'+str(q)+'.set("'+labeler(row[column])+'")'
            eval(a)
    highScore.set(str(h))
    if h == 2048:
        win.set("You win!")
    return doesStuff

def columnMerger(down = True):
    h = int(highScore.get())
    doesStuff = False
    for c in range(4):
        column = []
        filled = []
        for row in range(4*c+1, 4*c+5):
            i = 's' + str(row) + '.get()'
            i = eval(i)
            if i != empty:
                column.append(int(i))
                filled.append(1)
            else:
                filled.append(0)
        if checkFilled(filled, not down) == True:
            doesStuff = True

        allowMove = True
        if len(column) == 4:
            if column[2] == column[3] and (down == True or (column[1] != column[2] or column[0] == column[1])):
                column.pop(3)
                column[2] = 2*column[2]
                if column[2] > h:
                    h = column[2]
                allowMove = False
                doesStuff = True
        if len(column) >= 3:
            if (column[0] != column[1] or down == True) and column[1] == column[2] and allowMove == True:
                column.pop(2)
                column[1] = 2*column[1]
                if column[1] > h:
                    h = column[1]
                allowMove = False
                doesStuff = True
            else:
                allowMove = True
        if len(column) >= 2:
            if column[0] == column[1] and allowMove == True:
                column.pop(1)
                column[0] = 2*column[0]
                if column[0] > h:
                    h = column[0]
                allowMove = False
                doesStuff = True
        for row in range(1, 5):
            a = 's' + str(4*c+row) + '.set(empty)'
            eval(a)
        for row in range(len(column)):
            if down == False:
                q = c*4 + row + 1
            else:
                numEmpty = 4 - len(column)
                q = c*4 + 1 + row + numEmpty
            a = 's'+str(q)+'.set("'+labeler(column[row])+'")'
            eval(a)
    highScore.set(str(h))
    if h == 2048:
        win.set("You win!")
    return doesStuff


def left():
    if rowMerger(True) == True:
        numGen()
    
def right():
    if rowMerger(False) == True:
        numGen()
    
def up():
    if columnMerger(False) == True:    
        numGen()
    
def down():
    if columnMerger(True) == True:
        numGen()


def reset():
    for n in range(1, 17):
        a = 's' + str(n) + '.set(empty)'
        eval(a)
    highScore.set("2")
    win.set("")
    numGen()
      

# 5. Graphical User Interface
r = Tk()
r.title("2048")
r.geometry("250x175")

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

sq1 =Label(r, borderwidth=2, textvariable= s1, relief="groove").grid(row=1, column=0)
sq2 =Label(r, borderwidth=2, textvariable= s2, relief="groove").grid(row=2, column=0)
sq3 =Label(r, borderwidth=2, textvariable= s3, relief="groove").grid(row=3, column=0)
sq4 =Label(r, borderwidth=2, textvariable= s4, relief="groove").grid(row=4, column=0)
sq5 =Label(r, borderwidth=2, textvariable= s5, relief="groove").grid(row=1, column=1)
sq6 =Label(r, borderwidth=2, textvariable= s6, relief="groove").grid(row=2, column=1)
sq7 =Label(r, borderwidth=2, textvariable= s7, relief="groove").grid(row=3, column=1)
sq8 =Label(r, borderwidth=2, textvariable= s8, relief="groove").grid(row=4, column=1)
sq9 =Label(r, borderwidth=2, textvariable= s9, relief="groove").grid(row=1, column=2)
sq10=Label(r, borderwidth=2, textvariable=s10, relief="groove").grid(row=2, column=2)
sq11=Label(r, borderwidth=2, textvariable=s11, relief="groove").grid(row=3, column=2)
sq12=Label(r, borderwidth=2, textvariable=s12, relief="groove").grid(row=4, column=2)
sq13=Label(r, borderwidth=2, textvariable=s13, relief="groove").grid(row=1, column=3)
sq14=Label(r, borderwidth=2, textvariable=s14, relief="groove").grid(row=2, column=3)
sq15=Label(r, borderwidth=2, textvariable=s15, relief="groove").grid(row=3, column=3)
sq16=Label(r, borderwidth=2, textvariable=s16, relief="groove").grid(row=4, column=3)

resetB=Button(r, text="AC", command=reset).grid(row=5, column=0) # delete this in the final game

highScore = StringVar()
highLbl = Label(r, textvariable = highScore).grid(row = 2, column = 5)
 
scoreLbl = Label(r, text = "Highest # ").grid(row = 2, column = 4)

win = StringVar()
winLbl = Label(r, textvariable = win).grid(row = 4, column = 4)
# add a score label showing the highest number
# if the highest score is 2048 then show a "You Win!" dialogue

upB   =Button(r, text=" ↑ ", command=up).grid(row=5, column=2)
downB =Button(r, text=" ↓ ", command=down).grid(row=6, column=2)
leftB =Button(r, text=" ← ", command=left).grid(row=6, column=1)
rightB=Button(r, text=" → ", command=right).grid(row=6, column=3)

r.bind('<Left>', lambda x:left())
r.bind('<Right>', lambda x:right())
r.bind('<Up>', lambda x:up())
r.bind('<Down>', lambda x:down())

r.bind('<a>', lambda x:left())
r.bind('<d>', lambda x:right())
r.bind('<w>', lambda x:up())
r.bind('<s>', lambda x:down())

reset()


r.mainloop()


k = 2
for i in range(1, 17):
    s = 's' + str(i) + '.get()'
    s = eval(s)
    if s != empty:
        s = int(s)
        if s > k:
            k = s
print('Your highest value was ' + str(k) + '.')
if k < 2048:
    print('You lose!')
else:
    print('You win!')
