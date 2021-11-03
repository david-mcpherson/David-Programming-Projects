'''
Game: Blackjack
Author: David McPherson
Created: 11 February 2020
Last Modified: 3 May 2021

Blackjack rules in play:
- Double down
- 5 Card Charlie - player wins if they obtain 5 cards without busting
- Splitting 2 cards of same rank is permitted


Cards: assume a deck of 52 cards indexed from 0 to 51.
 0 - 12: A 2 3 4 5 6 7 8 9 10 J Q K (♥)
13 - 25: A to K (♦)
26 - 38: A to K (♣)
39 - 51: A to K (♠)
'''

# 1. Libraries
from random import seed
from random import shuffle
from tkinter import *

# 2. Data Structures
seed()

deck = list(range(52))
shuffle(deck)

# 3. Variables

# Player's Hand
cardInd = [] # card index drawn from the deck
cardDsp = [] # card display (rank and suit)
cardVal = [] # card value (numeric value of rank)

# Split Hand
splitInd = []
splitDsp = []
splitVal = []
hasSplit = 0
h1 = 0

# Dealer's Hand
dlrInd = []
dlrDsp = ['?']
dlrVal = []

money = 1000
pot = 0

# 4. Functions
def cardDisplay(cardIndex):
    # converts cardIndex to cardDsp, e.g. 16 -> '4 ♦'
    suit = ""
    if cardIndex // 13 == 0:
        suit = "♥"
    if cardIndex // 13 == 1:
        suit = "♦"
    if cardIndex // 13 == 2:
        suit = "♣"
    if cardIndex // 13 == 3:
        suit = "♠"
    rank = cardIndex % 13 + 1
    if rank == 1:
        rank = 'A'
    if rank == 11:
        rank = 'J'
    if rank == 12:
        rank = 'Q'
    if rank == 13:
        rank = 'K'
    card = str(rank)+ " " + suit
    return card


def reset():
    global pot
    global hasSplit
    if dlrDsp[0] == '?' and cardInd != []:
        pot = 0
    potVar.set(pot)
    deck.extend(cardInd)
    deck.extend(dlrInd)
    deck.extend(splitInd)
    shuffle(deck)
    del cardInd[:]
    del cardDsp[:]
    del cardVal[:]
    del dlrInd[:]
    del dlrDsp[:]
    del dlrVal[:]
    del splitInd[:]
    del splitDsp[:]
    del splitVal[:]
    end0Lbl.grid_remove()
    end1Lbl.grid_remove()
    doubleDownBtn.grid_remove()
    hasSplit = 0
    splitBtn.grid_remove()
    playerLbl.grid(row = 0, column = 0)
    handDspLbl.grid(row = 0, column = 1)
    splitHandLbl.grid(row = 1, column = 1)
    playerHand.set(cardDsp)
    dealerHand.set(dlrDsp)
    splitHand.set(splitDsp)
    endMsg.set('')
    splitEndMsg.set('')
    splitEndLbl.grid_remove()
    
def sumCards(hand):
    # adds the total value of cards on hand
    # assume Ace = 11 if total <= 21; A = 1 otherwise
    total = sum(hand)
    if hand.count(1) > 0:
        # Check if there's an Ace
        if total <= 11:
            total += 10
    return total  

def playerDraw():
    card = deck.pop(0)
    cardInd.append(card)
    cardDsp.append(cardDisplay(card))
    cardVal.append(min((card % 13) + 1, 10))
    playerHand.set(cardDsp)

def dealerDraw():
    card = deck.pop(0)
    dlrInd.append(card)
    dlrDsp.append(cardDisplay(card))
    dlrVal.append(min((card % 13) + 1, 10))
    dealerHand.set(dlrDsp)

def splitBugFix():
    global cardInd
    global cardVal
    global cardDsp
    global splitInd
    global splitVal
    global splitDsp    
    if len(splitDsp) == 1:
        return None
    if len(cardInd) != len(cardVal):
        cardInd.pop(1)
        cardDsp.pop(1)
        x = cardDsp[0][0]
        splitInd.pop(0)
        splitDsp.pop(0)
        cardVal = []
        splitVal = []
        if cardInd == []:
            if x == 'J':
                cardInd.append(10)
                cardVal.append(10)
            elif x == 'Q':
                cardInd.append(11)
                cardVal.append(10)
            elif x == 'K':
                cardVal.append(10)
                cardInd.append(12)
            elif x == 'A':
                cardVal.append(1)
                cardInd.append(0)
            else:
                cardInd.append(int(x) - 1)
                cardVal.append(int(x))
            cardDsp = []
            cardDsp.append(cardDisplay(cardInd[0]))
            splitInd = cardInd
            splitVal = cardVal
            splitDsp = cardDsp
    if len(cardDsp) > 1:
        del cardInd[1:]
        del cardVal[1:]
        del cardDsp[1:]
        

def split():
    global money
    global pot
    global hasSplit
    splitBtn.grid_remove()
    end0Lbl.grid(row = 4, column = 2)
    end1Lbl.grid(row = 5, column = 2)
    hasSplit = 1
    splitInd.append(cardInd.pop(1))
    splitVal.append(cardVal.pop(1))
    splitDsp.append(cardDsp.pop(1))
    splitBugFix()
    splitEndLbl.grid(row = 4, column = 3)
    playerHand.set(cardDsp)
    splitHand.set(splitDsp)
    playerLbl.grid(row = 0, column = 0)
    money -= pot
    pot *= 2
    moneyVar.set(money)
    potVar.set(pot)
    end0.set('Hand 1: ')
    end1.set('Hand 2: ')
    doubleDownBtn.grid(row = 4, column = 1)

def deal():
    reset()
    card = deck.pop(0)
    dlrInd.append(card)
    dlrVal.append(min((card % 13) + 1, 10))
    dlrDsp.append('?')
    dealerHand.set(dlrDsp)
    
    playerDraw()
    dealerDraw()
    playerDraw()
    
    if sumCards(cardVal) == 21:
        endMsg.set(end(True))
    else:
        doubleDownBtn.grid(row = 4, column = 1)

    if cardDsp[0][0] == cardDsp[1][0]:
        splitBtn.grid(row = 2, column = 3)
        
    
def payout(result = 'l'):
    global money
    global pot
    if result == 'p':
        money += pot
    elif result == 'w':
        money += 2*pot
    elif result == 'b':
        money += 2.5*pot
    pot = 0
    money = int(money)
    potVar.set(pot)
    moneyVar.set(money)

def payout2(result = 'l'):
    global money
    global pot
    global hasSplit
    pot = int(pot/2)
    if result == 'p':
        money += pot
    elif result == 'w':
        money += 2*pot
    elif result == 'b':
        money += 2.5*pot
    pot = int(pot/2)
    money = int(money)
    potVar.set(pot)
    moneyVar.set(money)
    
def end(blackjack = False, s = False):
    doubleDownBtn.grid_remove()
    p = sumCards(cardVal)
    d = sumCards(dlrVal)
    if len(cardInd) == 2 or len(dlrInd) == 2:
        if p == d and len(cardInd) == 2 and len(dlrInd) == 2 and p == 21:# player blackjack should beat dealer 21
            if cardDsp[-1] != 'Blackjack!':
                cardDsp.append('Blackjack!')
            playerHand.set(cardDsp)
            if dlrDsp[-1] != 'Blackjack!':
                dlrDsp.append('Blackjack!')
            dlrDsp.pop(0)
            x = cardDisplay(dlrInd[0])
            dlrDsp.insert(0, x)
            dealerHand.set(dlrDsp)
            if len(cardInd) == 2 and len(dlrInd) == 2:
                payout('p')
                return 'Push.'
        if p == 21 and (p != d or len(dlrDsp) > 2):
            dlrDsp.pop(0)
            x = cardDisplay(dlrInd[0])
            dlrDsp.insert(0, x)
            dealerHand.set(dlrDsp)
            if len(cardDsp) == 2:
                if cardDsp[-1] != 'Blackjack!':
                    cardDsp.append('Blackjack!') # player achieves blackjack
                playerHand.set(cardDsp)
                payout('b')
                return 'You win!'
        if d == 21 and len(dlrInd) == 2 and (p != 21 or len(cardInd) > 2): # dealer achieves blackjack\
            if dlrDsp[-1] != 'Blackjack!':
                dlrDsp.append('Blackjack!')
            dlrDsp.pop(0)
            x = cardDisplay(dlrInd[0])
            dlrDsp.insert(0, x)
            dealerHand.set(dlrDsp)
            payout('l')
            return 'You lose!'
    if p > 21: # player busts
        payout('l')
        return 'You lose!'
    elif len(cardInd) == 5: # 5 card charlie
        payout('w')
        return 'You win!'
    if d > 21: # dealer busts
        payout('w')
        return 'You win!'
    if p == d: # push
        payout('p')
        return 'Push.'
    if p > d: # player beats dealer
        payout('w')
        return 'You win!'
    if p < d: # dealer beats player
        payout('l')
        return 'You lose!'

def end2(blackjack = False, s = False):
    doubleDownBtn.grid_remove()
    p = sumCards(splitVal)
    d = sumCards(dlrVal)
    if (len(splitInd) == 2 or len(dlrInd) == 2) and (p == 21 or d == 21):
        if p == d and len(splitInd) == 2 and len(dlrInd) == 2:
            if splitDsp[-1] != 'Blackjack!':
                splitDsp.append('Blackjack!')
            splitHand.set(splitDsp)
            if dlrDsp[-1] != 'Blackjack!':
                dlrDsp.append('Blackjack!')
            dlrDsp.pop(0)
            x = cardDisplay(dlrInd[0])
            dlrDsp.insert(0, x)
            dealerHand.set(dlrDsp)
            payout2('p')
            return 'Push.'
        if p == 21 and p != d:
            dlrDsp.pop(0)
            x = cardDisplay(dlrInd[0])
            dlrDsp.insert(0, x)
            dealerHand.set(dlrDsp)
            if len(splitDsp) == 2:
                if splitDsp[-1] != 'Blackjack!':
                    splitDsp.append('Blackjack!') # player achieves blackjack
                splitHand.set(splitDsp)
                payout2('b')
                return 'You win!'
        if d == 21 and len(splitDsp) != 2: # dealer achieves blackjack, beating player's 21
            if dlrDsp[-1] != 'Blackjack!':
                dlrDsp.append('Blackjack!')
            dlrDsp.pop(0)
            x = cardDisplay(dlrInd[0])
            dlrDsp.insert(0, x)
            payout2('l')
            return 'You lose!'
    if p > 21: # player busts
        payout2('l')
        return 'You lose!'
    elif len(splitInd) == 5: # 5 card charlie
        payout('w')
        return 'You win!'
    if d > 21: # dealer busts
        payout2('w')
        return 'You win!'
    if p == d: # push
        payout2()
        return 'Push.'
    if p > d: # player beats dealer
        payout2('w')
        return 'You win!'
    if p < d: # dealer beats player
        payout2('l')
        return 'You lose!'

def handSwap():
    global cardInd
    global cardVal
    global cardDsp
    global splitInd
    global splitVal
    global splitDsp
    global hasSplit
    global h1
    h1 = sumCards(cardVal)
    hasSplit = 2
    playerHand.set(splitDsp)
    splitHand.set(cardDsp)
    x = cardVal
    y = cardInd
    z = cardDsp
    cardInd = splitInd
    cardVal = splitVal
    cardDsp = splitDsp
    splitVal = x
    splitInd = y
    splitDsp = z
    if len(cardDsp) > 1:
        del cardInd[1:]
        del cardVal[1:]
        del cardDsp[1:]
        playerHand.set(cardDsp)
    handDspLbl.grid(row = 1, column = 1)
    splitHandLbl.grid(row = 0, column = 1)
    playerLbl.grid(row = 1, column = 0)
    
def stay():
    global hasSplit
    if hasSplit == 1:
        return handSwap()
    if dlrDsp[0] != '?':
        return None
    splitBtn.grid_remove()
    if dlrDsp[-1] == 'Bust!':
        return None
    elif sumCards(dlrVal) == 21:
        endMsg.set(end(True))
    dlrDsp.pop(0)
    x = cardDisplay(dlrInd[0])
    dlrDsp.insert(0, x)
    dealerHand.set(dlrDsp)
    while sumCards(dlrVal) < 17:
        dealerDraw()
    if sumCards(dlrVal) > 21:
        dlrDsp.append('Bust!')
        dealerHand.set(dlrDsp)
    if hasSplit == 2:
        splitEndMsg.set(end2())
    endMsg.set(end())
    
def hit():
    splitBtn.grid_remove()
    if dlrDsp[0] != '?':
        return None
    if sumCards(cardVal) >= 21:
        return None
    card = deck.pop(0)
    cardInd.append(card)
    cardDsp.append(cardDisplay(card))
    cardVal.append(min((card % 13) + 1, 10))
    playerHand.set(cardDsp)
    doubleDownBtn.grid_remove()
    if sumCards(cardVal) == 21:
        stay()
    elif sumCards(cardVal) > 21:
        cardDsp.append("Bust!")
        playerHand.set(cardDsp)
        stay()
    elif len(cardInd) == 5:
        cardDsp.append("5 card Charlie!")
        playerHand.set(cardDsp)
        stay()

def doubleDown():
    global money
    global pot
    money -= pot
    pot *= 2
    hit()
    stay()
    

def betInc():
    global money
    global pot
    if money < 10:
        return None
    if dlrDsp[0] == '?' and cardInd != []:
        return None
    pot += 10
    money -= 10
    potVar.set(pot)
    moneyVar.set(money)

def betDec():
    global money
    global pot
    if pot < 10:
        return None
    if dlrDsp[0] == '?' and cardInd != []:
        return None
    pot -= 10
    money += 10
    potVar.set(pot)
    moneyVar.set(money)

def bigInc():
    global money
    global pot
    if money < 100:
        return None
    if dlrDsp[0] == '?' and cardInd != []:
        return None
    pot += 100
    money -= 100
    potVar.set(pot)
    moneyVar.set(money)

def bigDec():
    global money
    global pot
    if pot < 100:
        return None
    if dlrDsp[0] == '?' and cardInd != []:
        return None
    pot -= 100
    money += 100
    potVar.set(pot)
    moneyVar.set(money)
        
# 5. Graphical User Interface

root = Tk()
root.geometry("600x400")
root.title("Pegasus Casino: Blackjack!")

playerLbl = Label(root, text = "Player's Hand: ")
playerLbl.grid(row = 0, column = 0)

dealerLbl= Label(root, text = "Dealer's Hand: ")
dealerLbl.grid(row = 2, column = 0)

playerHand = StringVar() 
playerHand.set("")
handDspLbl = Label(root, textvariable = playerHand)
handDspLbl.grid(row = 0, column = 1)

splitHand = StringVar() # shows the 2nd player hand
splitHand.set("")
splitHandLbl = Label(root, textvariable = splitHand)
splitHandLbl.grid(row = 1, column = 1)

dealerHand = StringVar()
dealerHand.set("")
dealerLbl = Label(root, textvariable = dealerHand)
dealerLbl.grid(row = 2, column = 1)

dealBtn = Button(root, text = "DEAL", command = deal)
dealBtn.grid(row = 3, column = 0)

splitBtn = Button(root, text = "Split", command = split)
splitBtn.grid(row = 3, column = 2)
splitBtn.grid_remove()

hitBtn = Button(root, text = "HIT", command = hit)
hitBtn.grid(row = 4, column = 0)

doubleDownBtn = Button(root, text = "DOUBLE DOWN", command = doubleDown)

stayBtn = Button(root, text = "STAY", command = stay)
stayBtn.grid(row = 5, column = 0)

#shuffleBtn = Button(root, text = "SHUFFLE", command = reset)
#shuffleBtn.grid(row = 6, column = 0)

quitBtn = Button(root, text = "QUIT", command = root.destroy)
quitBtn.grid(row = 7, column = 0) 

end0 = StringVar()
end0.set("")
end0Lbl = Label(root, textvariable = end0)
end0Lbl.grid(row = 4, column = 2)

end1 = StringVar()
end1.set("")
end1Lbl = Label(root, textvariable = end1)
end1Lbl.grid(row = 5, column = 2)

endMsg = StringVar()
endMsg.set("")
endLbl = Label(root, textvariable = endMsg)
endLbl.grid(row = 5, column = 3)


splitEndMsg = StringVar()
splitEndMsg.set("")
splitEndLbl = Label(root, textvariable = splitEndMsg)
splitEndLbl.grid(row = 4, column = 3)

moneyInfo = StringVar()
moneyInfo.set("Your money: ")
moneyInfoLbl = Label(root, textvariable = moneyInfo)
moneyInfoLbl.grid(row = 10, column = 0)

moneyVar = StringVar()
moneyVar.set(money)
moneyLbl = Label(root, textvariable = moneyVar)
moneyLbl.grid(row = 10, column = 1)

moneyInfo = StringVar()
moneyInfo.set("Your money: ")
moneyInfoLbl = Label(root, textvariable = moneyInfo)
moneyInfoLbl.grid(row = 10, column = 0)

potVar = StringVar()
potVar.set(pot)
potLbl = Label(root, textvariable = potVar)
potLbl.grid(row = 11, column = 1)

potInfo = StringVar()
potInfo.set("Pot: ")
potInfoLbl = Label(root, textvariable = potInfo)
potInfoLbl.grid(row = 11, column = 0)

betIncBtn = Button(root, text = "+10", command = betInc)
betIncBtn.grid(row = 11, column = 2)

betDecBtn = Button(root, text = "-10", command = betDec)
betDecBtn.grid(row = 11, column = 3)

betDecBtn = Button(root, text = "+100", command = bigInc)
betDecBtn.grid(row = 12, column = 2)

betDecBtn = Button(root, text = "-100", command = bigDec)
betDecBtn.grid(row = 12, column = 3)

root.mainloop()

print("You walk away with " + str(money) + " dollars.")
if money < 0:
    print("You're in debt!")
elif money > 1000:
    print("You made a profit!")
else:
    print("You lost money.")


'''
Rules for Blackjack!
1. First card is dealt to player, then to dealer,
   back to player, and finally to dealer.
   
2. Only dealer's second card faces up. Player's cards
   can both be faced up.
   
3. Player wins automatically if they get blackjacck
   (unless) dealer also gets blackjack: push = tie)
   ** Player wins 3:2 ($2 bet wins $3)
   Dealer wins with blackjack automatically over player's
   five card or 21 (unless player has blackjack).
   
4. ** Player beats dealer if the player has five cards
   under 21 (i.e. five card Charlie) UNLESS DEALER HAS BLACKJACK!
   
5. Dealer wins if player busts (i.e. over 21)
6. After player stays (i.e. no more cards), dealer
   must take a card if the total is 16 or under; stay
   if 17 or over.
   
7. ** Opt SPLIT: If you get two cards of the same rank.
8. ** Opt DOUBLE DOWN: Take one more card and stay.
9. ** Dealer can hit on SOFT 17 (ace)

Suggestions:
1. Create two hands: one for player and one for dealer.
2. Create a new variable for dealer's hidden card.
3. First deal to dealer first by deck.pop(1) and deck.pop(2)
   where deck.pop(1) is the hidden card and deck.pop(2)
   goes into dealer's visible hand.
4. Deal the next two cards to player.
5. See 3) Test Cases to modify test cases.
    deck = [0, 1, 10, 3, 5]
               ^      ^
               -> dealer cards

Tasks:
1. Implement a playable game. (Max 80%) -> done
2. Include bets if possible.  (Max 90%) -> done
3. Implement at least one ** (Full marks)

-> blackjack pays 3:2
-> split
-> 5 card charlie
'''
