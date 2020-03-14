#include "pindefs.h"

int state = 1;
int countSequencia = 0;
int acertou = 0;

unsigned long previousMillis = 0;
unsigned long interval = 500;
unsigned long ledInterval = 500;

int sequenciaResposta[5];
int sequenciaUsuario[5];

void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
}

void loop () {
  unsigned long currentMillis = millis();

  switch (state) {
    case 1:
      //piscar leds 1,2,3 5 vezes aleatoriamente
      if (countSequencia < 5) {
        //randomizando o led
        int randLed = random(LED1, LED3 + 1);

        //piscando o led
        digitalWrite(randLed, LOW);
        delay(ledInterval);
        digitalWrite(randLed, HIGH);

        //salvando na sequencia e aumentando contador
        sequenciaResposta[countSequencia] = randLed;
        countSequencia++;
      }
      else {
        state = 2;
        countSequencia = 0;
      }
      break;
    case 2:
      //esperar input do usuario
      if (countSequencia < 5) {
        if (currentMillis - previousMillis >= interval) {
          previousMillis = currentMillis;

          if (digitalRead(KEY1) == LOW) {
            //salvando na sequencia e aumentando contador
            sequenciaUsuario[countSequencia] = KEY1;
            countSequencia++;

            if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
              state = 3;
              acertou = 0;
            }
          }
          if (digitalRead(KEY2) == LOW) {
            //salvando na sequencia e aumentando contador
            sequenciaUsuario[countSequencia] = KEY2;
            countSequencia++;

            if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
              state = 3;
              acertou = 0;
            }
          }
          if (digitalRead(KEY3) == LOW) {
            //salvando na sequencia e aumentando contador
            sequenciaUsuario[countSequencia] = KEY3;
            countSequencia++;

            if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
              state = 3;
              acertou = 0;
            }
          }
        }
      }
      else {
        state = 3;
        countSequencia = 0;
        acertou = 1;
      }
      break;
    case 3:
      //mostra resultados
      digitalWrite(LED1, HIGH);
      if (acertou) {
        digitalWrite(LED2, HIGH);
        digitalWrite(LED3, HIGH);
      }

      //input para resetar
      if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis;

        if (digitalRead(KEY1) == LOW) {
          RestartSequence();
        }
      }
      break;
    default:
      RestartSequence();
      break;
  }

  /*  if (currentMillis >= old + ledInterval and canBlink) { // hora de piscar?
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
    }*/
}

void RestartSequence() {
  state = 1;
  countSequencia = 0;
  acertou = 1;
  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
}
