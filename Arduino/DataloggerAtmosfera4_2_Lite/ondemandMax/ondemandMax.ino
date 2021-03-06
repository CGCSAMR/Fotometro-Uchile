/*
  AnalogReadSerial
  Reads an analog input on pin 0, prints the result to the serial monitor.
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.
 
 This example code is in the public domain.
 */
#include <LiquidCrystal.h>

#define PIN_BUZZER 5

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(9, 10, 6, 4, 3, 2);
// the setup routine runs once when you press reset:
int maxAmarillo = 0;
int maxAzul = 0;
int amarillo;
int azul;

void setup() {
    lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("Yellow");
  lcd.setCursor(8, 0);
  lcd.print("Blue");
  tone(PIN_BUZZER, 698);
  delay(300);
  noTone(PIN_BUZZER);
}

// the loop routine runs over and over again forever:
void loop() {
  
  amarillo = analogRead(A0);
  azul = analogRead(A1);
  
  if(maxAmarillo < amarillo)
  {
      maxAmarillo = amarillo;
      tone(PIN_BUZZER, 1046);
      delay(20);
      noTone(PIN_BUZZER);
  }
  
  if(maxAzul < azul)
  {
      maxAzul = azul;
      tone(PIN_BUZZER, 1046);
      delay(20);
      noTone(PIN_BUZZER);
  }
  
  lcd.setCursor(0, 1);
  lcd.print("    ");
  lcd.setCursor(0, 1);
  lcd.print(maxAmarillo*5.0/1024);
  lcd.setCursor(6, 1);
  lcd.print("V");
  lcd.setCursor(8, 1);
  lcd.print("    ");
  lcd.setCursor(8, 1);
  lcd.print(maxAzul*5.0/1024);
  lcd.setCursor(14, 1);
  lcd.print("V");
  delay(100);
   
}  // delay in between reads for stability
