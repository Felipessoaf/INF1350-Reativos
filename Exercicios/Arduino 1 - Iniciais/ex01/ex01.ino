#include "pindefs.h"
int ledOn = 0;
unsigned long previousMillis = 0;
unsigned long interval = 400;

void setup() {
  // put your setup code here, to run once:
  pinMode(LED1, OUTPUT);;
  pinMode(KEY1, INPUT_PULLUP);

}


void loop() {
  unsigned long currentMillis = millis();
  // if time enough has elapsed, check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (currentMillis - previousMillis >= interval) {
    if (digitalRead(KEY1) == LOW) {
      // save the last time you read LOW
      previousMillis = currentMillis;
      ledOn = !ledOn;
      digitalWrite(LED1, ledOn);
    }
  }
}

