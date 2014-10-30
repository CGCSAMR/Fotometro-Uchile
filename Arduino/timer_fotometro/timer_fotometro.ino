#include <LiquidCrystal.h>
#include <SD.h>
#include <Time.h>
LiquidCrystal lcd(9, 10, 6, 4, 3, 2);

//int button1 = A3
//int buttonok = A2
int asec = 0;
int amin = 0;
int ahour = 0;
int i=0;
void setup(){
  Serial.begin(9600);
  pinMode(A2,INPUT);
  lcd.clear();
  lcd.begin(15,2);
  lcd.print("Ajuste hora");
  lcd.setCursor(0,1);
  lcd.print(ahour);
  lcd.print(":");
  lcd.print(amin);
  lcd.print(":");
  lcd.print(asec);
  const int entrada=analogRead(A3);  //
  const int ok=analogRead(A2);
  
}

void loop(){
  while (i<3){
  int ok=analogRead(A2);    //Valor del pin A3 para boton
  int entrada=analogRead(A3);   //Valor del pin A2 para boton
  Serial.print(entrada);
    //inicializacion
    if (ok>0){
      i++;
      delay(600);
    }
    //segundero
    if (i==0){
    if (entrada>0){            
    lcd.setCursor(4,1);
    asec++;
    if(asec==60){
    amin++;
    }
    lcd.print(asec);
    delay(600);
    lcd.print(asec);
    }
    }
    
    //minutero
    if (i==1){
    if (entrada>0){            
    lcd.setCursor(2,1);
    amin++;
    if(amin==60){
    ahour++;
    }
    lcd.print(amin);
    lcd.print(":");
    lcd.print(asec);
    delay(600);
    }
    }
    //horario
    if (i==2){
    if (entrada>0){            
    lcd.setCursor(0,1);
    ahour++;
    if(ahour==25){
    ahour=0;
    }
    lcd.print(ahour);
    lcd.print(":");
    lcd.print(amin);
    lcd.print(":");
    lcd.print(asec);
    delay(600);
    }
    }
    

  }
  
}

  
  

  

