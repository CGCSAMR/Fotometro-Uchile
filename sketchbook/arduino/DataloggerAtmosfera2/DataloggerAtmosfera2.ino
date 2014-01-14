/*
  SD card datalogger
 
 This example shows how to log data from three analog sensors 
 to an SD card using the SD library.
 	
 The circuit:
 * analog sensors on analog ins 0, 1, and 2
 * SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13
 ** CS - pin 4
 
 created  24 Nov 2010
 modified 9 Apr 2012
 by Tom Igoe
 
 This example code is in the public domain.
 	 
 */

#include <SD.h>
#include <Time.h>  
#include <Wire.h>  
#include <DS1307RTC.h>  // a basic DS1307 library that returns time as a time_t

  //tiempo de exposiciÃ³n en milisegundos


// On the Ethernet Shield, CS is pin 4. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 4;

#define TIEMPO_MEDICION 3000
#define LARGO_MEDIDA 30
#define PIN_BUZZER 5
#define PIN_LED 7

// Se deben crear 1 nuevo buffer por cada canal

int buffer1[LARGO_MEDIDA];  // Guarda mediciones analogRead individuales del sensor 1 y 2
int buffer2[LARGO_MEDIDA];  // #filas = cantidad de canales y #columnas = cantidad de medidas individuales







void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);

  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  if(timeStatus()!= timeSet) 
    Serial.println("Unable to sync with the RTC");
  else
    Serial.println("RTC has set the system time");  

  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }


  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(8, OUTPUT);

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    errorSD();
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");

  // indica que contiene cada columna
  if(!SD.exists("datalog.txt"))
  {
    File dataFile = SD.open("datalog.txt", FILE_WRITE);
    dataFile.println("Year Month Day Hour Minute Second MeanSens1 MeanSens2 VarSens1 VarSens2");
    dataFile.close();
  }

  inicioBuzzer();

}



void loop()
{

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  // make a string for assembling the data to log:
  String dateString = "";

  dateString += String(year()) + " " + String(month()) + " " + String(day()) + " ";
  dateString += String(hour()) + " " + String(minute()) + " " + String(second()) + " "; 

  double promedio1 = 0.0;
  double promedioBuff1 = 0.0;
  
  double promedio2 = 0.0;
  double promedioBuff2 = 0.0;
  
  double varianza1 = 0.0;
  double varianza2 = 0.0;

  int inicio = millis();
  
  // Llena arreglo con promedios y varianzas de cada muestra
    while((millis() - inicio) < TIEMPO_MEDICION)
    {
    //Llena el bufferSensor con datos individuales
    for (int medidaIndividual = 0; medidaIndividual < LARGO_MEDIDA; medidaIndividual++){

      // lee los sensores y guarda un dato individual en cada Buffer:
      buffer1[medidaIndividual] = analogRead(A0);
      buffer2[medidaIndividual] = analogRead(A1);
    }
      
      promedioBuff1 = promedio(buffer1, LARGO_MEDIDA);
      promedioBuff2 = promedio(buffer2, LARGO_MEDIDA);
      
     if( promedio1 < promedioBuff1)
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
    
    
  String voltString =  doubleToString(promedio1) + " " + doubleToString(promedio2) + " "; 
  voltString += doubleToString(varianza1) + " " + doubleToString(varianza2) + " ";
  

  File dataFile = SD.open("datalog.txt", FILE_WRITE);


  // if the file is available, write to it:
  if (dataFile) {
    dataFile.print(dateString);
    dataFile.println(voltString);
    dataFile.close();
    // print to the serial port too:
    Serial.print(dateString);
    Serial.println(voltString);
    finBuzzer();
    
    while(1){
    }
  }  
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening datalog.txt");
  } 
}

double promedio(int datos[], int largo){

  double sum = 0;

  for(int i = 0; i < largo; i++){
    sum += datos[i];
  }

  return sum/(largo);
}

double varianza(int datos[], double promedio, int largo){

  double sum = 0;
  double aux = 0;

  for(int i = 0; i < largo; i++){
    aux = (datos[i] - promedio);
    aux = aux*aux;
    sum += aux;
  }

  return sum/(largo-1);
}

void inicioBuzzer(){

  tone(PIN_BUZZER, 622, 220); //tone(pin, frecuencia, duracion (milisegundos))
  digitalWrite(PIN_LED, HIGH);
  
}

void finBuzzer(){

  tone(PIN_BUZZER, 622);
  delay(220);
  noTone(PIN_BUZZER);
  tone(PIN_BUZZER, 622, 220);
  delay(220);
  digitalWrite(PIN_LED, LOW);
  
}

void errorSD(){
  
  while(true){
    
  tone(PIN_BUZZER, 698);
  digitalWrite(PIN_LED, HIGH);
  delay(300);
  noTone(PIN_BUZZER);
  digitalWrite(PIN_LED, LOW);
  
  delay(550);
 
  }
  
  
 
  
}

 String doubleToString(double num){
  
  char buf[32]; 
  String palabra;
  
  dtostrf(num,4,10,buf);
 // dtostrf( [doubleVar] , [sizeBeforePoint] , [sizeAfterPoint] , [WhereToStoreIt] )
    palabra = String(buf);  // cast it to string from char 
    return palabra;
  }



