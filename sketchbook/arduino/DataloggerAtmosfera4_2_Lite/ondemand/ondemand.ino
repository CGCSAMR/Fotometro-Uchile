/*
  AnalogReadSerial
  Reads an analog input on pin 0, prints the result to the serial monitor.
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.
 
 This example code is in the public domain.
 */
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(9, 10, 6, 4, 3, 2);
// the setup routine runs once when you press reset:
void setup() {
    lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("m1");
  lcd.setCursor(7, 0);
  lcd.print("m2");
}

// the loop routine runs over and over again forever:
void loop() {

   lcd.setCursor(0, 1);
  lcd.print(analogRead(A0));
  lcd.print("mV")
  lcd.setCursor(7, 1);
  lcd.print(analogRead(A1));
  lcd.print("mV")
  delay(1); 
}  // delay in between reads for stability
