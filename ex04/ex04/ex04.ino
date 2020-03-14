#include "pindefs.h"
int ledOn = 0;
int canBlink = 1;
unsigned long previousMillis = 0;
unsigned long interval = 500;
unsigned long ledInterval = 500;
unsigned long old = 0;

unsigned long minimo = 125;
unsigned long maximo = 1000;


void setup() {
  pinMode(LED1, OUTPUT);;
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
}


void loop () {
  unsigned long currentMillis = millis();

  if (currentMillis >= old + ledInterval and canBlink) { // hora de piscar?
    old = currentMillis;
    ledOn = !ledOn;
    digitalWrite(LED1, ledOn);
  }

  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    if (digitalRead(KEY1) == LOW and ledInterval > minimo) {
      ledInterval = ledInterval / 2;
    }
    if (digitalRead(KEY2) == LOW and ledInterval < maximo) {
      ledInterval = ledInterval * 2;
    }
    if (digitalRead(KEY1) == LOW and digitalRead(KEY2) == LOW) {
      canBlink = !canBlink;
    }
  }
}
