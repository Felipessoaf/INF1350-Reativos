#include "pindefs.h"

// globais

int state = 0;
volatile int buttonChanged = 0;
unsigned long previousMillis = 0;
unsigned long intervalBtn = 200;

void pciSetup (byte pin) {
  *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));  // enable pin
  PCIFR  |= bit (digitalPinToPCICRbit(pin)); // clear any outstanding interrupt
  PCICR  |= bit (digitalPinToPCICRbit(pin)); // enable interrupt for the group
}

ISR (PCINT1_vect) { // handle pin change interrupt for A0 to A5 here
  buttonChanged = 1;
}

void setup() {
  pinMode(LED1, OUTPUT); pinMode(LED2, OUTPUT);
  pinMode (LED3, OUTPUT); pinMode(LED4, OUTPUT);
  digitalWrite(LED1, HIGH); digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH); digitalWrite(LED4, HIGH);
  pinMode (KEY1, INPUT_PULLUP); pinMode (KEY2, INPUT_PULLUP); pinMode(KEY3, INPUT_PULLUP);
  pciSetup(KEY1); pciSetup(KEY2);
  Serial.begin(9600);
}

void loop() {
  unsigned long currentMillis = millis();
  Serial.print("!");
  if (currentMillis - previousMillis >= intervalBtn) {
    if (buttonChanged and digitalRead(KEY1) == LOW) {
      digitalWrite(LED1, state);
      buttonChanged = 0;
      state = !state;
      previousMillis = currentMillis;
    }
  }
}
