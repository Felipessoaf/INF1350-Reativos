#include "pindefs.h"
int ledOn = 0;
unsigned long previousMillis = 0;
unsigned long interval = 500;
unsigned long botao = 0;
unsigned long interBot = 400;

unsigned long minimo = 125;
unsigned long maximo = 1000;

//teste
//outro teste

void setup() {
  pinMode(LED1, OUTPUT);;
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
}


void loop () {
  unsigned long currentMillis = millis();
  unsigned long currentBotao = millis();
  unsigned long aux;
  if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;
      ledOn = !ledOn;
      digitalWrite(LED1, ledOn);

      if(currentBotao - botao >= interBot){
        if (digitalRead(KEY1) == LOW and interval > minimo) {
        interval = interval/2;
      }
        if(digitalRead(KEY2) == LOW and interval < maximo){
          interval = interval*2;
      }
        if(digitalRead(KEY3) == LOW){
          if(interval != 0){
            aux = interval;
            interval = 0;
          }
          if(interval == 0){
            interval = aux;
          }
      }
    }
  }
}
