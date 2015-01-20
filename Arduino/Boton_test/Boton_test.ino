/*
  DigitalReadSerial
 Reads a digital input on pin 2, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

// digital pin 2 has a pushbutton attached to it. Give it a name:
int pushButton0 = A2;
int pushButton1 = A3;
int pushButton2 = 7;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  // make the pushbutton's pin an input:
  pinMode(pushButton0, INPUT);
  pinMode(pushButton1, INPUT);
  pinMode(pushButton2, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  int buttonState0 = digitalRead(pushButton0);
  int buttonState1 = digitalRead(pushButton1);
  int buttonState2 = digitalRead(pushButton2);
  // print out the state of the button:
  Serial.print(buttonState0);
  Serial.print(buttonState1);
  Serial.println(buttonState2);
  delay(1);        // delay in between reads for stability
}



