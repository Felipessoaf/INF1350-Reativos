#include "pindefs.h"

// globais

byte state = HIGH;
volatile int counter = 0;
volatile int buttonChanged = 0;
unsigned long previousMillis = 0;
unsigned long intervalBtn = 10;

void pciSetup (byte pin) {
  *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));  // enable pin
  PCIFR  |= bit (digitalPinToPCICRbit(pin)); // clear any outstanding interrupt
  PCICR  |= bit (digitalPinToPCICRbit(pin)); // enable interrupt for the group
}

ISR (PCINT1_vect) { // handle pin change interrupt for A0 to A5 here
  buttonChanged = 1;
}

void timerSetup () {
  TIMSK2 = (TIMSK2 & B11111110) | 0x01;
  TCCR2B = (TCCR2B & B11111000) | 0x07;
}

ISR(TIMER2_OVF_vect) {
  counter++;
}


void setup() {
  pinMode(LED1, OUTPUT); pinMode(LED2, OUTPUT);
  pinMode (LED3, OUTPUT); pinMode(LED4, OUTPUT);
  digitalWrite(LED1, HIGH); digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH); digitalWrite(LED4, HIGH);
  pinMode (KEY1, INPUT_PULLUP); pinMode (KEY2, INPUT_PULLUP); pinMode(KEY3, INPUT_PULLUP);
  pciSetup(KEY1); pciSetup(KEY2);
  Serial.begin(9600);
  pinMode(LED1, OUTPUT); digitalWrite(LED1, state);
  pinMode(LED2, OUTPUT); digitalWrite(LED2, state);
  pinMode(LED3, OUTPUT); digitalWrite(LED3, state);
  pinMode(LED4, OUTPUT); digitalWrite(LED4, state);
  timerSetup();
}

void loop() {
  unsigned long currentMillis = millis();
  Serial.print("!");
  if (counter >= intervalBtn) {
    if (buttonChanged and digitalRead(KEY1) == LOW) {
      digitalWrite(LED1, state);
      buttonChanged = 0;
      state = !state;
      counter = 0;
    }
  }
}
