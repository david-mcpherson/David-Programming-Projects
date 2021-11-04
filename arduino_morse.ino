/*Author: David McPherson
* Last modified: 04-Nov-2021
* 
* This program takes its inputs under the #define statements.
* When it runs, it blinks a message in morse code.
*/

// SETTINGS: 
#define message "hiccup and toothless"   // this message gets outputted in morse code; no upper case letters permitted
#define wordSpeed 8                          // morse speed in wpm; only used to define dotTime
#define dotTime 1200/wordSpeed                // set the time of a single dot in milliseconds; default is 100 ms for 12 wpm
#define light 13                              // the output pin; for the light on the board use light = 13


// function flashes a single dot
void dot(){
  digitalWrite(light, 1);
  delay(dotTime);
  digitalWrite(light, 0);
  delay(dotTime);
  }

// function flashes a single dash
void dash(){
  digitalWrite(light, 1);
  delay(3*dotTime);
  digitalWrite(light, 0);
  delay(dotTime);
  }
  

// function outputs the defined message in morse code.
void setup() {
  pinMode(light, OUTPUT);

  int messageLength = strlen(message);
  delay(1000);

  //for(int k = 0; k < messageLength; k++){
  for(char letter : message){
    //char letter = message[k];
    switch (letter){
      case ' ': delay(4*dotTime); break;     
      case 'a': dot(); dash(); break;
      case 'b': dash(); dot(); dot(); dot(); break;
      case 'c': dash(); dot(); dash(); dot(); break;
      case 'd': dash(); dot(); dot(); break;
      case 'e': dot(); break;
      case 'f': dot(); dot(); dash(); dot(); break;
      case 'g': dash(); dash(); dot(); break;
      case 'h': dot(); dot(); dot(); dot(); break;
      case 'i': dot(); dot(); break;
      case 'j': dot(); dash(); dash(); dash(); break;
      case 'k': dash(); dot(); dash(); break;
      case 'l': dot(); dash(); dot(); dot(); break;
      case 'm': dash(); dash(); break;
      case 'n': dash(); dot(); break;
      case 'o': dash(); dash(); dash(); break;
      case 'p': dot(); dash(); dash(); dot(); break;
      case 'q': dash(); dash(); dot(); dash(); break;
      case 'r': dot(); dash(); dot(); break;
      case 's': dot(); dot(); dot(); break;
      case 't': dash(); break;
      case 'u': dot(); dot(); dash(); break;
      case 'v': dot(); dot(); dot(); dash(); break;
      case 'w': dot(); dash(); dash(); break;
      case 'x': dash(); dot(); dot(); dash(); break;
      case 'y': dash(); dot(); dash(); dash(); break;
      case 'z': dash(); dash(); dot(); dot(); break;
      case '0': dash(); dash(); dash(); dash(); dash(); break;
      case '1': dot(); dash(); dash(); dash(); dash(); break;
      case '2': dot(); dot(); dash(); dash(); dash(); break;
      case '3': dot(); dot(); dot(); dash(); dash(); break;
      case '4': dot(); dot(); dot(); dot(); dash(); break;
      case '5': dot(); dot(); dot(); dot(); dot(); break;
      case '6': dash(); dot(); dot(); dot(); dot(); break;
      case '7': dash(); dash(); dot(); dot(); dot(); break;
      case '8': dash(); dash(); dash(); dot(); dot(); break;
      case '9': dash(); dash(); dash(); dash(); dot(); break;
      case '.': dot(); dash(); dot(); dash(); dot(); dash(); break;
      case ',': dash(); dash(); dot(); dot(); dash(); dash(); break;
      case '?': dot(); dot(); dash(); dash(); dot(); dot(); break;
      case '!': dash(); dot(); dash(); dot(); dash(); dash(); break;
      case '"': dot(); dash(); dot(); dot(); dash(); dot(); break;
      case '\'': dot(); dash(); dash(); dash(); dash(); dot(); break;
      case '=': dash(); dot(); dot(); dot(); dash(); break;
      case ':': dash(); dash(); dash(); dot(); dot(); dot(); break;
      case '/': dash(); dot(); dot(); dash(); dot(); break;
      case '(': dash(); dot(); dash(); dash(); dot(); break;
      case ')': dash(); dot(); dash(); dash(); dot(); dash(); break;
      case '&': dot(); dash(); dot(); dot(); dot(); break;
      case '+': dot(); dash(); dot(); dash(); dot(); break;
      case '-': dash(); dot(); dot(); dot(); dot(); dot(); dash(); break;
      case '$': dot(); dot(); dot(); dash(); dot(); dot(); dash(); break;
      case '@': dot(); dash(); dash(); dot(); dash(); dot(); break;
      case '_': dot(); dot(); dash(); dash(); dot(); dash(); break;
      case ';': dash(); dot(); dash(); dot(); dash(); dot(); break;
      
      // add more characters down here
    }
    delay(2*dotTime);
  }
}

void loop() {}
