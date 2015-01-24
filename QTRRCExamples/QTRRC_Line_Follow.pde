#include "config.h"
#include "engine.h"
#include "PololuQTRSensors.h"
#include "navigation.h"
PololuQTRSensorsRC qtr((unsigned char[]) {2,4,5,6,7,8,9,10}, NUM_OF_SENSORS);

void setup(){
#ifdef DEBUG
  Serial.begin(9600);
#endif
  engineSetup();
  calibrate(&qtr);
  delay(2000);

  motor(MotorA,FORWARD_MAX);
  motor(MotorB,FORWARD_MAX);
}

void loop(){
  int pos = readLine(&qtr);

if (pos != LINE_LOST){

    if (pos == EDGE_RIGHT){
      motor(MotorA,REVERSE_MAX);
      motor(MotorB,FORWARD_MAX);
    }else if (pos == EDGE_LEFT){
      motor(MotorA,FORWARD_MAX);
      motor(MotorB,REVERSE_MAX);
    }else{

      int error = pos - MIDDLE_POS;
      int m1Speed = FORWARD_MAX;
      int m2Speed = FORWARD_MAX;

      if (error < 0)
	m1Speed = map(error,-MIDDLE_POS,0,REVERSE_MAX,FORWARD_MAX);
      else
	m2Speed = map(error,0,MIDDLE_POS,FORWARD_MAX,REVERSE_MAX);

#ifdef DEBUG
      Serial.print(error);   Serial.print(" ");
      Serial.print(m1Speed); Serial.print(" "); Serial.println(m2Speed);
#endif

      motor(MotorA,m1Speed);
      motor(MotorB,m2Speed);
    }
  }
}
