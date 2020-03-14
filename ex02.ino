#include "pindefs.h"
int ledOn = 0;
unsigned long previousMillis = 0;
unsigned long interval = 1000;
unsigned long botao = 0;
unsigned long interBot = 400;

void setup() {
  pinMode(LED1, OUTPUT);;
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
}


void loop () {
  unsigned long currentMillis = millis();
  unsigned long currentBotao = millis();
  if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;
      ledOn = !ledOn;
      digitalWrite(LED1, ledOn);

      if(currentBotao - botao >= interBot){
        if (digitalRead(KEY1) == LOW) {
        interval = interval/2;
      }
        if(digitalRead(KEY2) == LOW){
        interval = interval*2;
      }
      
    }
    
  }
}

/*void loop() {
  digitalWrite(LED1, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);                       // wait for a second
  digitalWrite(LED1, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);                       // wait for a second
}*/

/*void loop() {
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    ledOn = !ledOn;
    digitalWrite(LED1, ledOn);
  }
}*/
