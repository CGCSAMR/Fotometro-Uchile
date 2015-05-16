
#define PIN_TERMOMETRO 0
int pwm, signo, delta_pwm;

float temp_actual, temp_Objetivo, err_temp;

void setup() {                
  
	pwm = 0;
	delta_pwm = 1;
	
	temp_Objetivo = 15.0;
  	err_temp = 0.5;
  	
  	signo = 1; //Indica si peltier debe calentar o enfriar
  
	init_PuenteH();
	encendido_PuenteH(1);
   
       
}


void loop() {
  
  	
  	temp_actual = leer_Temperatura(PIN_TERMOMETRO);
  	
  	if ( temp_actual > (temp_Objetivo + err_temp) )
  		pwm += -1 * delta_pwm;
  		
  	else if (temp_actual < (temp_Objetivo - err_temp) )
  		pwm += delta_pwm;
  
  	if ( pwm > 255)	pwm = 255;
  	
  	else if (pwm < -255) pwm = -255;
  	
  	if (pwm < 0)	signo = -1;
  	
  	else if(pwm > 0)	signo = 1;
  
	control_motor_PuenteH( 1 , abs(pwm) , signo);
  
  	Serial.print("Temp = ");
  	Serial.print(temp_actual);
  	
  	Serial.print("  pwm = ");
  	Serial.println(pwm);
  	  
	delay(4000); 

  
	//delay(1000);               // wait for a second

}


void encendido_PuenteH(int encender){

	if(encender == 0)
		digitalWrite (6, LOW);  /*Se Deshabilita el motor shield*/
	else
		digitalWrite (6, HIGH); /*Se Habilita la salida del motor Shield */
}

void control_motor_PuenteH(int motor, int pwm, int sentido)
{
	/* Permite controlar motores
	Valores aceptados:
		motor: {1,2}
		pwm: [0,255] 0% a 100%
		sentido: {-1,+1}
	*/
	
	if(pwm > 255)	pwm = 255;
		
	else if(pwm < 0)	pwm = 0;
		
	if(motor == 1)
	{
		if(sentido > 0) // Girar derecha
		{
			digitalWrite (4, LOW);			
			digitalWrite (5, HIGH);
		}
		
		else if(sentido < 0) // Girar izquierda
		{
			digitalWrite (4, HIGH);
			digitalWrite (5, LOW);
		}	
		
		analogWrite (9, pwm); /*Se establece la velocidad Motor1 */
		
	}
	
	else if(motor == 2)
	{
		if(sentido > 0) // Girar derecha
		{
			digitalWrite (7, LOW);			
			digitalWrite (8, HIGH);
		}
		
		else if(sentido < 0) // Girar izquierda
		{
			digitalWrite (7, HIGH);
			digitalWrite (8, LOW);
		}	
		
		analogWrite (10, pwm); /*Se establece la velocidad Motor1 */
		
	}
		
} 

void init_PuenteH(){
  
  	Serial.begin(9600);
	pinMode (4, OUTPUT); /*Se configura el pin 4 (1A) como salida */ 
	pinMode (5, OUTPUT); /*Se configura el pin 5 (1B) como salida */
	pinMode (9, OUTPUT); /*Se configura el pin 9 (P1) como salida */
	pinMode (7, OUTPUT); /*Se configura el pin 7 (2A) como salida */
	pinMode (8, OUTPUT); /*Se configura el pin 8 (2B) como salida */
	pinMode (10, OUTPUT); /*Se configura el pin 10 (P2) como salida */
	pinMode (6, OUTPUT); /*Se configura el pin 6 (SE) como salida */
}

float leer_Temperatura(int analog_pin)
{
	float tempC = analogRead(analog_pin);
	tempC = (5.0 * tempC * 100.0)/1024.0; 
	return tempC;	
}
