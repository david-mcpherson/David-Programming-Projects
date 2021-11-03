import random as r
r.seed()
# a101 conventions key: 9315083109571099


encryptionKey = str(r.randint(0, 1e+5))
print()
print("encode(plaintext, key)")
print("decode(ciphertext, key)")
print("crack(ciphertext, crib)")
print("encryptFile(filename, key)")
print("decryptFile(filename, key)")
print()
def encode(aStr, key = encryptionKey):
  key = str(key)
  k = len(key)
  dStr = ''
  n = len(aStr)
  s = 0
  while s < n:
    overflow = 'F'
    c = aStr[s]
    c = ord(c)
    p = s % k
    x = int(key[p])
    if c + x > 122 and c <= 122: # corrects lowercase overflow
      c -= 26
      overflow = 'T'
    elif c <= 90 and c + x > 90: # corrects capital overflow
      c -= 26
      overflow = 'T' 
    if (c > 64 and c < 91) or (c > 96 and c < 123) or overflow == 'T':
      c += x
    c = chr(c)
    dStr = dStr + c
    s += 1
  return dStr

# Part B - Write decode(dStr, key)


def decode(dStr, key = encryptionKey):
  key = str(key)
  k = len(key)
  aStr = ''
  n = len(dStr)
  s = 0
  while s < n:
    underflow = 'F'
    c = dStr[s]
    c = ord(c)
    p = s % k
    x = int(key[p])
    if c - x < 97 and c > 90: # corrects lowercase overflow
      c += 26
      underflow = 'T'
    elif c >= 65 and c - x < 65: # corrects capital overflow
      c += 26
      underflow = 'T' 
    if (c > 64 and c < 91) or (c > 96 and c < 123) or underflow == 'T':
      c -= x
    c = chr(c)
    aStr += c
    s += 1
  return aStr

def encryptFile(filename, key = encryptionKey):
    plainTxt = open(filename, 'r')
    txt = plainTxt.readlines()
    plainTxt.close()
    cipherTxt = open(filename, 'w')
    n = len(txt)
    for line in range(n):
        cipherTxt.write(encode(txt[line], key))
    cipherTxt.close()

def decryptFile(filename, key = encryptionKey):
    cipherTxt = open(filename, 'r')
    txt = cipherTxt.readlines()
    cipherTxt.close()
    plainTxt = open(filename, 'w')
    n = len(txt)
    for line in range(n):
        plainTxt.write(decode(txt[line], key))
    plainTxt.close()
  

# This function will take a ciphertext and a crib and find the first (lowest)
# decryption key which has the crib in its plaintext.
# ex: encode('Friend Cicero.', 12312) -> 'Gtlfpe Fjeftr.'
#     crack('Gtlfpe Fjeftr.', 'Cicero')  -> 12312

def crack(ciphertext, crib, maxSize = 1000000):
  key = 0
  while key < maxSize:
    if decode(ciphertext, key).count(crib) > 0:
      return key
    key += 1
