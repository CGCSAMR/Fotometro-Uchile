
// VERSION SIN INTERFAZ

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
#include <Adafruit_BMP085.h>

  //tiempo de exposiciÃ³n en milisegundos


// On the Ethernet Shield, CS is pin 4. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 4;

#define TIEMPO_MEDICION 3000
#define LARGO_MEDIDA 30
#define SEA_LEVEL_PRESSURE 101500

// Se deben crear 1 nuevo buffer por cada canal

int buffer1[LARGO_MEDIDA];  // Guarda mediciones analogRead individuales del sensor 1 y 2
int buffer2[LARGO_MEDIDA];  // #filas = cantidad de canales y #columnas = cantidad de medidas individuales

int inicio;
String data="";

Adafruit_BMP085 bmp;

void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);

  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  if(timeStatus()!= timeSet) 
    Serial.println("Unable to sync with the RTC");
  else
    Serial.println("RTC has set the system time");  


  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(8, OUTPUT);

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");

  // indica que contiene cada columna
  if(!SD.exists("datalog.txt"))
  {
    File dataFile = SD.open("datalog.txt", FILE_WRITE);
    dataFile.println("Year Month Day Hour Minute Second MeanSens1[V] MeanSens2[V] VarSens1[V] VarSens2[V] Temperature[°C] Pressure[Pa]");
    dataFile.close();
  }
  
  if (!bmp.begin()) {
	Serial.println("Could not find a valid BMP085 sensor, check wiring!");
	while (1) {}
  }

}



void loop()
{

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  // make a string for assembling the data to log:

  File dataFile = SD.open("datalog.txt", FILE_WRITE);

  if (dataFile) {
  
  
  data += String(year()) + " " + String(month()) + " " + String(day()) + " ";
  data += String(hour()) + " " + String(minute()) + " " + String(second()) + " "; 

  dataFile.print(data);
  Serial.print(data);
  
  data = "";

  double promedio1 = 0.0;
  double promedioBuff1 = 0.0;
  
  double promedio2 = 0.0;
  double promedioBuff2 = 0.0;
  
  double varianza1 = 0.0;
  double varianza2 = 0.0;

  inicio = millis();
  
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
    
    
  data =  doubleToString(promedio1*5/1024) + " " + doubleToString(promedio2*5/1024) + " "; 
  data += doubleToString(varianza1*5/1024) + " " + doubleToString(varianza2*5/1024) + " ";
  dataFile.print(data);  
  Serial.print(data);
  
  data = "";
  
  data =  doubleToString(bmp.readTemperature()) + " "; 
  data += doubleToString(bmp.readPressure());
  dataFile.println(data);  
  Serial.println(data);
  
  data = doubleToString(bmp.readAltitude(SEA_LEVEL_PRESSURE));
  

  
    
  dataFile.close();

    
  }  
  
  
  // if the file isn't open, pop up an error:
    else {
      Serial.println("error opening datalog.txt");
    }
    
    while(1){}
  
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
 
  

 String doubleToString(double num){
  
  char buf[32]; 
  String palabra;
  
  dtostrf(num,4,8,buf);
 // dtostrf( [doubleVar] , [sizeBeforePoint] , [sizeAfterPoint] , [WhereToStoreIt] )
    palabra = String(buf);  // cast it to string from char 
    return palabra;
  }



