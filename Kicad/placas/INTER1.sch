EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:INTER1-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "noname.sch"
Date "26 feb 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L R R3
U 1 1 52DD279F
P 5550 3950
F 0 "R3" V 5630 3950 40  0000 C CNN
F 1 "22 Omn" V 5557 3951 40  0000 C CNN
F 2 "~" V 5480 3950 30  0000 C CNN
F 3 "~" H 5550 3950 30  0000 C CNN
	1    5550 3950
	0    -1   -1   0   
$EndComp
$Comp
L R R2
U 1 1 52DD27A5
P 4750 3950
F 0 "R2" V 4830 3950 40  0000 C CNN
F 1 "1K" V 4757 3951 40  0000 C CNN
F 2 "~" V 4680 3950 30  0000 C CNN
F 3 "~" H 4750 3950 30  0000 C CNN
	1    4750 3950
	0    -1   -1   0   
$EndComp
$Comp
L R R1
U 1 1 52DD27AB
P 4050 3950
F 0 "R1" V 4130 3950 40  0000 C CNN
F 1 "1K" V 4057 3951 40  0000 C CNN
F 2 "~" V 3980 3950 30  0000 C CNN
F 3 "~" H 4050 3950 30  0000 C CNN
	1    4050 3950
	0    -1   -1   0   
$EndComp
$Comp
L R R4
U 1 1 52DD2923
P 7650 2750
F 0 "R4" V 7730 2750 40  0000 C CNN
F 1 "10K" V 7657 2751 40  0000 C CNN
F 2 "~" V 7580 2750 30  0000 C CNN
F 3 "~" H 7650 2750 30  0000 C CNN
	1    7650 2750
	0    -1   -1   0   
$EndComp
NoConn ~ 2300 3550
NoConn ~ 2300 3450
NoConn ~ 2300 3350
NoConn ~ 2300 2850
NoConn ~ 2300 2750
NoConn ~ 2300 2650
NoConn ~ 2300 2550
Wire Wire Line
	2300 5400 2200 5400
Wire Wire Line
	2300 5300 2200 5300
Wire Wire Line
	2300 5200 2200 5200
Wire Wire Line
	2300 5100 2200 5100
Wire Wire Line
	2300 5000 2200 5000
Wire Wire Line
	2300 4900 2200 4900
Wire Wire Line
	2300 4800 2200 4800
Wire Wire Line
	2300 4700 2200 4700
Wire Wire Line
	2300 4600 2200 4600
Wire Wire Line
	2300 4500 2200 4500
Wire Wire Line
	2300 4400 2200 4400
Wire Wire Line
	2300 4300 2200 4300
Wire Wire Line
	2300 4200 2200 4200
Wire Wire Line
	2300 3250 2200 3250
Wire Wire Line
	2300 3150 2200 3150
Wire Wire Line
	2300 3050 2200 3050
Wire Wire Line
	2300 2950 2200 2950
Wire Wire Line
	2300 2450 2200 2450
Wire Wire Line
	2300 2350 2200 2350
Wire Wire Line
	2300 2250 2200 2250
Wire Wire Line
	2300 2150 2200 2150
Wire Wire Line
	2300 2050 2200 2050
Wire Wire Line
	2300 1950 2200 1950
Wire Wire Line
	7900 2750 8450 2750
Wire Wire Line
	5800 3950 5900 3950
Wire Wire Line
	3800 3950 3700 3950
Wire Wire Line
	5000 3950 5300 3950
Wire Wire Line
	4300 3950 4500 3950
Text Label 2200 1950 0    60   ~ 0
GND
Text Label 2200 2050 0    60   ~ 0
+5V
Text Label 2200 2250 0    60   ~ 0
9
Text Label 2200 2350 0    60   ~ 0
GND
Text Label 2200 2450 0    60   ~ 0
10
Text Label 2200 2950 0    60   ~ 0
6
Text Label 2200 3050 0    60   ~ 0
4
Text Label 2200 3150 0    60   ~ 0
3
Text Label 2200 3250 0    60   ~ 0
2
Text Label 2200 4500 0    60   ~ 0
GND
Text Label 2200 4600 0    60   ~ 0
+5V
Text Label 2200 4700 0    60   ~ 0
9
Text Label 2200 4800 0    60   ~ 0
10
Text Label 2200 2150 0    60   ~ 0
R
Text Label 3700 3950 0    60   ~ 0
R
Text Label 5900 3950 0    60   ~ 0
GND
Text Label 2200 4900 0    60   ~ 0
6
Text Label 2200 5000 0    60   ~ 0
4
Text Label 2200 5100 0    60   ~ 0
3
Text Label 2200 5200 0    60   ~ 0
2
Wire Wire Line
	7400 2750 7300 2750
Text Label 2200 5300 0    60   ~ 0
7
Text Label 2200 5400 0    60   ~ 0
A3
Text Label 2200 5500 0    60   ~ 0
A2
$Comp
L GND #PWR01
U 1 1 52DD3153
P 5200 2750
F 0 "#PWR01" H 5200 2750 30  0001 C CNN
F 1 "GND" H 5200 2680 30  0001 C CNN
F 2 "" H 5200 2750 60  0000 C CNN
F 3 "" H 5200 2750 60  0000 C CNN
	1    5200 2750
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR02
U 1 1 52DD3162
P 4150 2800
F 0 "#PWR02" H 4150 2890 20  0001 C CNN
F 1 "+5V" H 4150 2890 30  0000 C CNN
F 2 "" H 4150 2800 60  0000 C CNN
F 3 "" H 4150 2800 60  0000 C CNN
	1    4150 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4150 2800 4150 2850
Text Label 4150 2850 0    60   ~ 0
+5V
Wire Wire Line
	5200 2650 5200 2750
Text Label 5200 2650 0    60   ~ 0
GND
$Comp
L R R7
U 1 1 52DD336B
P 8700 2750
F 0 "R7" V 8780 2750 40  0000 C CNN
F 1 "BTN" V 8707 2751 40  0000 C CNN
F 2 "~" V 8630 2750 30  0000 C CNN
F 3 "~" H 8700 2750 30  0000 C CNN
	1    8700 2750
	0    -1   -1   0   
$EndComp
$Comp
L R R8
U 1 1 52DD3371
P 8700 3000
F 0 "R8" V 8780 3000 40  0000 C CNN
F 1 "BTN" V 8707 3001 40  0000 C CNN
F 2 "~" V 8630 3000 30  0000 C CNN
F 3 "~" H 8700 3000 30  0000 C CNN
	1    8700 3000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8450 3000 8300 3000
$Comp
L R R5
U 1 1 52DD38C9
P 7650 3650
F 0 "R5" V 7730 3650 40  0000 C CNN
F 1 "10K" V 7657 3651 40  0000 C CNN
F 2 "~" V 7580 3650 30  0000 C CNN
F 3 "~" H 7650 3650 30  0000 C CNN
	1    7650 3650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7900 3650 8450 3650
Wire Wire Line
	7400 3650 7300 3650
$Comp
L R R9
U 1 1 52DD38D4
P 8700 3650
F 0 "R9" V 8780 3650 40  0000 C CNN
F 1 "BTN" V 8707 3651 40  0000 C CNN
F 2 "~" V 8630 3650 30  0000 C CNN
F 3 "~" H 8700 3650 30  0000 C CNN
	1    8700 3650
	0    -1   -1   0   
$EndComp
$Comp
L R R10
U 1 1 52DD38DA
P 8700 3900
F 0 "R10" V 8780 3900 40  0000 C CNN
F 1 "BTN" V 8707 3901 40  0000 C CNN
F 2 "~" V 8630 3900 30  0000 C CNN
F 3 "~" H 8700 3900 30  0000 C CNN
	1    8700 3900
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8450 3900 8300 3900
$Comp
L R R6
U 1 1 52DD38E3
P 7700 4850
F 0 "R6" V 7780 4850 40  0000 C CNN
F 1 "10K" V 7707 4851 40  0000 C CNN
F 2 "~" V 7630 4850 30  0000 C CNN
F 3 "~" H 7700 4850 30  0000 C CNN
	1    7700 4850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7950 4850 8500 4850
Wire Wire Line
	7450 4850 7350 4850
Text Label 7350 4850 0    60   ~ 0
GND
$Comp
L R R12
U 1 1 52DD38F4
P 8750 5100
F 0 "R12" V 8830 5100 40  0000 C CNN
F 1 "BTN" V 8757 5101 40  0000 C CNN
F 2 "~" V 8680 5100 30  0000 C CNN
F 3 "~" H 8750 5100 30  0000 C CNN
	1    8750 5100
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8500 5100 8350 5100
Text Label 8300 3900 0    60   ~ 0
+5V
NoConn ~ 8950 3900
NoConn ~ 8950 3000
Text Label 7300 3650 0    60   ~ 0
GND
Text Label 7300 2750 0    60   ~ 0
GND
Text Label 8300 3000 0    60   ~ 0
+5V
$Comp
L R R11
U 1 1 52DD3A3B
P 8750 4850
F 0 "R11" V 8830 4850 40  0000 C CNN
F 1 "BTN" V 8757 4851 40  0000 C CNN
F 2 "~" V 8680 4850 30  0000 C CNN
F 3 "~" H 8750 4850 30  0000 C CNN
	1    8750 4850
	0    -1   -1   0   
$EndComp
Text Label 8350 5100 0    60   ~ 0
+5V
Text Label 8950 2750 0    60   ~ 0
7
Text Label 8950 3650 0    60   ~ 0
A3
Text Label 9000 4850 0    60   ~ 0
A2
Text Notes 2600 1650 0    60   ~ 0
LCD
Text Notes 2650 3950 0    60   ~ 0
EXT\n
Text Notes 4600 2400 0    60   ~ 0
PWR
Text Notes 4700 3650 0    60   ~ 0
CTL
Text Notes 8150 2250 0    60   ~ 0
BTN
$Comp
L CONN_2 P3
U 1 1 52DFEF81
P 2600 6150
F 0 "P3" V 2550 6150 40  0000 C CNN
F 1 "CONN_2" V 2650 6150 40  0000 C CNN
F 2 "" H 2600 6150 60  0000 C CNN
F 3 "" H 2600 6150 60  0000 C CNN
	1    2600 6150
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 P4
U 1 1 52DFEFA3
P 4000 5750
F 0 "P4" H 4080 5750 40  0000 L CNN
F 1 "CONN_1" H 4000 5805 30  0001 C CNN
F 2 "" H 4000 5750 60  0000 C CNN
F 3 "" H 4000 5750 60  0000 C CNN
	1    4000 5750
	1    0    0    -1  
$EndComp
Text Label 2250 6050 0    60   ~ 0
Vin
Text Label 2250 6250 0    60   ~ 0
BAT
Text Label 3850 5750 0    60   ~ 0
Vin
$Comp
L CONN_6 P6
U 1 1 52E190A8
P 4200 4900
F 0 "P6" V 4150 4900 60  0000 C CNN
F 1 "CONN_6" V 4250 4900 60  0000 C CNN
F 2 "" H 4200 4900 60  0000 C CNN
F 3 "" H 4200 4900 60  0000 C CNN
	1    4200 4900
	1    0    0    -1  
$EndComp
Text Label 3850 4650 0    60   ~ 0
GND
Text Label 3850 4750 0    60   ~ 0
GND
Text Label 3850 4950 0    60   ~ 0
TX1
$Comp
L CONN_14 P2
U 1 1 52E191A3
P 2650 4850
F 0 "P2" V 2620 4850 60  0000 C CNN
F 1 "CONN_14" V 2730 4850 60  0000 C CNN
F 2 "" H 2650 4850 60  0000 C CNN
F 3 "" H 2650 4850 60  0000 C CNN
	1    2650 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 5500 2200 5500
Text Label 2200 4400 0    60   ~ 0
TX1
Text Label 2200 4300 0    60   ~ 0
RX0
Text Label 2200 4200 0    60   ~ 0
RST
$Comp
L CONN_19 P1
U 1 1 52E194F0
P 2650 2850
F 0 "P1" V 2600 2850 60  0000 C CNN
F 1 "CONN_19" V 2700 2850 60  0000 C CNN
F 2 "" H 2650 2850 60  0000 C CNN
F 3 "" H 2650 2850 60  0000 C CNN
	1    2650 2850
	1    0    0    -1  
$EndComp
Text Label 2300 3650 0    60   ~ 0
BAT
NoConn ~ 2300 3750
NoConn ~ 9000 5100
NoConn ~ 3850 4850
$Comp
L R R13
U 1 1 52FE4F86
P 5550 4700
F 0 "R13" V 5630 4700 40  0000 C CNN
F 1 "10K" V 5557 4701 40  0000 C CNN
F 2 "~" V 5480 4700 30  0000 C CNN
F 3 "~" H 5550 4700 30  0000 C CNN
	1    5550 4700
	0    -1   -1   0   
$EndComp
$Comp
L C C1
U 1 1 52FE4F8E
P 5550 5400
F 0 "C1" H 5550 5500 40  0000 L CNN
F 1 "0.1 uF" H 5556 5315 40  0000 L CNN
F 2 "~" H 5588 5250 30  0000 C CNN
F 3 "~" H 5550 5400 60  0000 C CNN
	1    5550 5400
	0    -1   -1   0   
$EndComp
Text Label 5300 4700 0    60   ~ 0
+5V
Text Label 5750 5400 0    60   ~ 0
DTR
Text Label 3850 5150 0    60   ~ 0
DTR
Text Label 3850 5050 0    60   ~ 0
RX0
Text Label 5800 4700 0    60   ~ 0
RST
Text Label 5350 5400 0    60   ~ 0
RST
$EndSCHEMATC
