#include <LiquidCrystal.h>
#include <SD.h>
#include <Wire.h> 
#include "RTClib.h"

LiquidCrystal lcd(9, 10, 6, 4, 3, 2);
RTC_DS1307 RTC;


int i=0;
void setup(){
  Serial.begin(9600);
  //Botones
  pinMode(A2,INPUT);
  pinMode(A3,INPUT);
  pinMode(7,INPUT);

  //RTCtime
  Wire.begin(); 
  RTC.begin(); 
  RTC.adjust(DateTime(__DATE__, __TIME__)); // Establece la fecha y hora (Comentar una vez establecida la hora)
  Serial.begin(9600);
  DateTime now = RTC.now(); //ajusta la hora a la hora actual 
  //lcd

}

void loop(){
  DateTime now = RTC.now();
  while (i==0){
    int ok=analogRead(A2);    //Valor del pin A3 para boton
    int b1=analogRead(A3);   //Valor del pin A2 para boton
    int b2=analogRead(7);   //Valor del pin 7 para boton
    lcd.clear();
    lcd.begin(15,2);
    lcd.print("Actualizar hora?");
    if (ok>0){
      i++;
    }
    if (b1>0){
      i=6;
      Wire.begin(); 
      RTC.begin();
      RTC.adjust(DateTime(__DATE__, __TIME__));
      DateTime now = RTC.now();
    }
    delay(500);
    Serial.println(ok);
    Serial.println(b1);
  }
  
  while (i<6){     //iteracion bellaca
  DateTime now = RTC.now(); //ajusta la hora a la hora actual
  
  int ayear = now.year();   //defino contadores
  int amonth = now.month();
  int aday = now.day();
  int ahour = now.hour();   
  int amin = now.minute();
  
  int ok=analogRead(A2);    //Valor del pin A3 para boton
  int b1=analogRead(A3);   //Valor del pin A2 para boton
  int b2=analogRead(7);   //Valor del pin 7 para boton
  Serial.print(b1);
  Serial.print("  ");
  Serial.print(b2);
  Serial.print("  ");
  Serial.println(ok);
    //inicializacion
    if (ok>0){
      i++;
    }
    //ajustar año
    if (i==1){
      if (b1>0){    
      ayear++;
      }
      //if(b2>0){
      //ayear--;
      //}
      //delay(500);
    }
    //ajustar mes
    if (i==2){
      if (b1>0){    
      amonth++;
      if (amonth==13){    
      amonth=1;
      }
      }
      //if (b2>0){
      //amonth--;
      //}
      //delay(500);
    }
    //ajustar dia
    if (i==3){
      if (b1>0){    
      aday++;
      if (aday==32){    
      aday=1;
      }
      }
    
      //if (b2>0){
      //aday--;
      //}
      //delay(500);
      
      //Hora
    }
          if (i==4){
      if (b1>0){    
      ahour++;
      if (ahour==25){
      ahour=0;
      }
      }
      //if(b2>0){
      //ayear--;
      //}
      //delay(500);
    }
    //ajustar mes
    if (i==5){
      if (b1>0){    
      amin++;
      if (amin==61){    
      amin=0;
      }
      }
      //if (b2>0){
      //amonth--;
      //}
      //delay(500);
    }

    lcd.clear();
    lcd.begin(15,2);
    lcd.print(now.year(), DEC); // Año
    lcd.print('/');
    lcd.print(now.month(), DEC); // Mes
    lcd.print('/');
    lcd.print(now.day(), DEC); // Dia
    lcd.setCursor(0,1);
    lcd.print(now.hour(), DEC); // Horas
    lcd.print(':');
    lcd.print(now.minute(), DEC); // Minutos
    lcd.print(':');
    lcd.print(now.second(), DEC); // Segundos   
    delay(500);
    

  }
  lcd.clear();
  lcd.begin(15,2);
  lcd.print(now.year(), DEC); // Año
  lcd.print('/');
  lcd.print(now.month(), DEC); // Mes
  lcd.print('/');
  lcd.print(now.day(), DEC); // Dia
  lcd.setCursor(0,1);
  lcd.print(now.hour(), DEC); // Horas
  lcd.print(':');
  lcd.print(now.minute(), DEC); // Minutos
  lcd.print(':');
  lcd.print(now.second(), DEC); // Segundos   
  delay(1000);
}
