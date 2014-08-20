#include <LiquidCrystal.h>
LiquidCrystal lcd(9, 10, 6, 4, 3, 2);
const int buttonPin1 = 7; //Anterior
const int buttonPin2 = A3;  //Siguiente
const int buttonPin3 = A2; //Enter/Esc
int buttonState1 = 0; 
int buttonState2 = 0; 
int buttonState3 = 0; 
int mprincipal = 0; 
int acceso = 0;    
int subm = 0; 
void setup() {
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);   
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin1, INPUT); 
  pinMode(buttonPin2, INPUT); 
  pinMode(buttonPin3, INPUT); 
  lcd.clear();
  lcd.home();
  lcd.print("Medir");
  lcd.setCursor(14,0);
  lcd.print("<>");
  lcd.setCursor(14,1);
  lcd.print("ok");
}
void loop(){
  // read the state of the pushbutton value:
  buttonState1 = digitalRead(buttonPin1);
  buttonState2 = digitalRead(buttonPin2);
  buttonState3 = digitalRead(buttonPin3);
  if (buttonState1 == HIGH) {     
    switch(mprincipal){
    case 0:
      mprincipal=4;
      break;
    default:
      mprincipal -= 1;
    }
    acceso=0;
    delay(500);
  }
  if (buttonState2 == HIGH) {     
    switch(mprincipal){
    case 4:
      mprincipal=0;
      break;
    default:
      mprincipal += 1;
    }
    acceso=0;
    delay(500);
  }
  if (buttonState3 == HIGH) {     
    switch(acceso){
    case 1:
      acceso += 1;
      break;
    case 2:
      acceso=0;
    }
    delay(500);    
  }   
  switch(mprincipal){
  case 0:
    switch (acceso) {
    case 0:
      lcd.clear();
      lcd.home();
      lcd.print("Medir");
      lcd.setCursor(14,0);
      lcd.print("<>");
      lcd.setCursor(14,1);
      lcd.print("ok");
      acceso=1;
      break;
    case 1:
      break;
    case 2:
      break;
    }
  case 1:
    switch (acceso) {
    case 0:
      lcd.clear();
      lcd.home();
      lcd.print("Mediciones");
      lcd.setCursor(0,1);
      lcd.print("Anteriores");
      lcd.setCursor(14,0);
      lcd.print("<>");
      lcd.setCursor(14,1);
      lcd.print("ok");
      acceso=1;
      break;
    case 1:
      break;
    case 2:
      break;
    }
  case 2:
    switch (acceso) {
    case 0:
      lcd.clear();
      lcd.home();
      lcd.print("Test");
      lcd.setCursor(14,0);
      lcd.print("<>");
      lcd.setCursor(14,1);
      lcd.print("ok");
      acceso=1;
      break;
    case 1:
      break;
    case 2:
      break;
    }
  case 3:
    switch (acceso) {
    case 0:
      lcd.clear();
      lcd.home();
      lcd.print("Pres, Temp");
      lcd.setCursor(0,1);
      lcd.print("y alt.");
      lcd.setCursor(14,0);
      lcd.print("<>");
      lcd.setCursor(14,1);
      lcd.print("ok");
      acceso=1;
      break;
    case 1:
      break;
    case 2:
      break;
    }
  case 4:
    switch (acceso) {
    case 0:
      lcd.clear();
      lcd.home();
      lcd.print("Tracker");
      lcd.setCursor(14,0);
      lcd.print("<>");
      lcd.setCursor(14,1);
      lcd.print("ok");
      acceso=1;
      break;
    case 1:
      break;
    case 2:
      break;
    }
  case 5:
    switch (acceso) {
    case 0:
      lcd.clear();
      lcd.home();
      lcd.print("Info");
      lcd.setCursor(14,0);
      lcd.print("<>");
      lcd.setCursor(14,1);
      lcd.print("ok");
      acceso=1;
      break;
    case 1:
      break;
    case 2:
      break;
    }
  }

}


