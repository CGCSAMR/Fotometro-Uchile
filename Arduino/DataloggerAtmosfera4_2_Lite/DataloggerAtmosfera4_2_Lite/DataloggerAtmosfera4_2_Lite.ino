
// VERSION CON INTERFAZ

/*
  SD card datalogger
 
 This example shows how to log data from three analog sensors 
 to an SD card using the SD library.
 	
 The circuit:
 * analog sensors on analog ins 0, 1 (Aerosol's sensors), 4 and 5 (BMP 085 or BMP 180 sensor)
 * SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13
 ** CS - pin 8
 ***LCD display connected to:
 ***RS - pin 9
 ***Enable -pin 10
 ***D4 - pin 6 
 ***D5 - pin 4 
 ***D5 - pin 3 
 ***D6 - pin 2 
 ****Buttons in pin 7, A2 and A3 (lite vertion only uses pin A2)
 *****Buzzer connected to pin 5
 
 created  24 Feb 2014
 by Somebody
 
 This example code is in the public domain.
 	 
 */
#include <LiquidCrystal.h>//The Arduino LiquidCrystal library
#include <SD.h>//SD library
#include <Time.h>//Time library  
#include <Wire.h>//I2C library  
#include <DS1307RTC.h>  // a basic DS1307 library that returns time as a time_t
#include <Adafruit_BMP085.h>
// initialize the LiquidCrystal library with the numbers of the interface pins
LiquidCrystal lcd(9, 10, 6, 4, 3, 2);
//Exposition time in millis
// On the olimex-MCI datalogger, CS is pin 8. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 4;//Constanst to use
const int buttonPin = A2; 
#define TIEMPO_MEDICION 10000//Time of a medition in millis
#define LARGO_MEDIDA 3//Number of meditions to take 
#define SEA_LEVEL_PRESSURE 101500//Sea level prssure
#define PIN_BUZZER 5//conetion to the pin buzzer

// One buffer by channel
int buffer1[LARGO_MEDIDA];  // Saves the meditions of the aerosols's sensor
int buffer2[LARGO_MEDIDA];  // #line = number of channels #columns = number of individual meditions
int buttonState = 0; // initial state of the A2 button
int inicio;// call int inicio
String data="";//call String data

Adafruit_BMP085 bmp;//call to BMP 085 sensor

void setup()
{

  inicioBuzzer();//Initial sound
  lcd.begin(16, 2);//Initial LiquidCrystal Hardware
  lcd.print("   Fotometro");//initial prin in LCD
  lcd.setCursor(0, 1);//resposion of a cursor
  lcd.print("Meteodata Uchile");
  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  if(timeStatus()!= timeSet) {//If the time can't work,it'll show the error in the LCD display
    lcd.clear();
    lcd.home();
    lcd.print("RTC Error");
  }
  pinMode(8, OUTPUT);//comunication with Olimex-MCI datalogger
  pinMode(buttonPin, INPUT);//comunication with the A2 button   
  // see if the card is present and can be initialized, if it isn't,it'll show an error in the display :
  if (!SD.begin(chipSelect)) {
    lcd.clear();
    lcd.home();
    lcd.print("SD card Error");
    errorSD();    
    // don't do anything more:, only sound the buzzer
    //return;
  }
  // indicate what havve every column
  if(!SD.exists("datalog.CSV"))//Verifies if exists the file where the information is saves, if don't exists,il'll create a new file and write a head line
  {
    File dataFile = SD.open("DATALOG.CSV", FILE_WRITE);
    dataFile.println("Year,Month,Day,Hour,Minute,Second,MeanSens1[V],MeanSens2[V],VarSens1[V],VarSens2[V],Temperature[°C],Pressure[Pa],Altitude[m]");
    dataFile.close();
  }
  if (!bmp.begin()) {//Check if the BMP 085 (BMP 180) is presentnt, if it isn't, it'll show an error.
    lcd.clear();
    lcd.home();
    lcd.print("BMP085 Error");
    while (1) {
    }
  }
  lcd.clear();//Prin in the display the first menu
  lcd.home();
  lcd.print("Medir");
  lcd.setCursor(14, 0);
  lcd.print("<>");
  lcd.setCursor(14, 1);
  lcd.print("ok");
}



void loop()
{
  buttonState = digitalRead(buttonPin);//read the button input
  if (buttonState == HIGH){ 
    //if the buttton is pushed,the photometer will begin to measure
     // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  // make a string for assembling the data to log:
    inicioBuzzer();//sound and changes the print in the display
    lcd.clear();
    lcd.home();
    lcd.print("Midiendo...");
    File dataFile = SD.open("DATALOG.CSV", FILE_WRITE);
  if (dataFile) {
  //write the date
  
  data += String(year()) + "," + String(month()) + "," + String(day()) + ",";
  data += String(hour()) + "," + String(minute()) + "," + String(second()) + ","; 

  dataFile.print(data);
  
  data = "";
//reset of all the variables of a medition
  double promedio1 = 0.0;
  double promedioBuff1 = 0.0;
  
  double promedio2 = 0.0;
  double promedioBuff2 = 0.0;
  
  double varianza1 = 0.0;
  double varianza2 = 0.0;

  long inicio = millis();//time of the begin
  
  // Llena arreglo con promedios y varianzas de cada muestra
    while((millis() - inicio) < TIEMPO_MEDICION)
    {
    //writes in bufferSensor all the information individualy
    for (int medidaIndividual = 0; medidaIndividual < LARGO_MEDIDA; medidaIndividual++){

      // read the sensors and saves one information individualy in every buffer
      buffer1[medidaIndividual] = analogRead(A0);
      buffer2[medidaIndividual] = analogRead(A1);
    }
      
      promedioBuff1 = promedio(buffer1, LARGO_MEDIDA);//takes a mean of the information of the sensor
      promedioBuff2 = promedio(buffer2, LARGO_MEDIDA);
      
     if( promedio1 < promedioBuff1)//search the high mean of all the groups of meditions and calcules the variance of the group
     {
       promedio1 = promedioBuff1;
       varianza1 = varianza(buffer1, promedio1, LARGO_MEDIDA);
       }
    if( promedio2 < promedioBuff2)
     {
       promedio2 = promedioBuff2;
       varianza2 = varianza(buffer2, promedio2, LARGO_MEDIDA);
       }
    }
    
  //writes the file with the information  
  data =  doubleToString(promedio1*5/1024) + "," + doubleToString(promedio2*5/1024) + ",";
  dataFile.print(data);  
  data = "";
  
  data += doubleToString(varianza1*5/1024) + "," + doubleToString(varianza2*5/1024) + ",";
  dataFile.print(data);  
  Serial.print(data);
  
  data = "";
  //read the temperature and pressure of the BMP 085 or BMP 180 sensor and writes these in the file
  data =  doubleToString(bmp.readTemperature()) + ","; 
  data += doubleToString(bmp.readPressure()) + ",";
  dataFile.print(data); 
  data = "";
  
  data = doubleToString(bmp.readAltitude(SEA_LEVEL_PRESSURE));
  dataFile.println(data);
  data = "";
  
    
  dataFile.close();
  
  finBuzzer();//final sound
    
  }  


    // if the file isn't open, pop up an error:
    else {
      lcd.clear();
      lcd.home();
      lcd.println("TXT error");
    }
//reset the initial metition information
    lcd.clear();
    lcd.home();
    lcd.print("Medir");
    lcd.setCursor(14, 0);
    lcd.print("<>");
    lcd.setCursor(14, 1);
    lcd.print("ok");
    
}
}

double promedio(int datos[], int largo){
//it calcules the mean of a group of numbers
  double sum = 0;

  for(int i = 0; i < largo; i++){
    sum += datos[i];
  }

  return sum/(largo);
}

double varianza(int datos[], double promedio, int largo){
//it calculetes the variance of a group of numbers
  double sum = 0;
  double aux = 0;

  for(int i = 0; i < largo; i++){
    aux = (datos[i] - promedio);
    aux = aux*aux;
    sum += aux;
  }

  return sum/(largo-1);
}



String doubleToString(double num){
  //it takes a double number and return it like a string

  char buf[32]; 
  String palabra;

  dtostrf(num,4,8,buf);
  // dtostrf( [doubleVar] , [sizeBeforePoint] , [sizeAfterPoint] , [WhereToStoreIt] )
  palabra = String(buf);  // cast it to string from char 
  return palabra;
}


void inicioBuzzer(){
 //configuration for the initial sound
  tone(PIN_BUZZER, 1046, 220); //tone(pin, frecuencia, duracion (milisegundos))

}


void finBuzzer(){
//configuration to the final sound
  tone(PIN_BUZZER, 1046);
  delay(220);
  noTone(PIN_BUZZER);
  tone(PIN_BUZZER, 1046, 220);
  delay(220);

}


void errorSD(){
//sound of the SD error
  while(true){

    tone(PIN_BUZZER, 698);
    delay(300);
    noTone(PIN_BUZZER);

    delay(550);

  }

}

