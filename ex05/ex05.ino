/*
Nome: Felipe Pessoa e Guilherme Bizzo
Matricula: 1411716 e 1710563

*/

#include "pindefs.h"

int state = 1;
int countSequencia = 0;
int acertou = 0;

unsigned long previousMillis = 0;
unsigned long interval = 500;
unsigned long ledInterval = 1000;

int sequenciaResposta[5];
int sequenciaUsuario[5];

void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  RestartSequence();
  randomSeed(analogRead(0));
  Serial.begin(9600);
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
        delay(ledInterval);
        Serial.println(randLed);

        //salvando na sequencia e aumentando contador
        sequenciaResposta[countSequencia] = randLed;
        countSequencia++;
      }
      else {
        state = 2;
        countSequencia = 0;
        digitalWrite(LED1, HIGH);
        digitalWrite(LED2, HIGH);
        digitalWrite(LED3, HIGH);
      }
      break;
    case 2:
      //esperar input do usuario
      if (countSequencia < 5) {
        if (currentMillis - previousMillis >= interval) {
          previousMillis = currentMillis;

          if (digitalRead(KEY1) == LOW) {
            //salvando na sequencia e aumentando contador
            sequenciaUsuario[countSequencia] = LED1;
            Serial.println("Usuario apertou 1");
            Serial.println(sequenciaResposta[countSequencia]);

            if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
              state = 3;
              acertou = 0;
            }
            countSequencia++;
          }
          if (digitalRead(KEY2) == LOW) {
            //salvando na sequencia e aumentando contador
            sequenciaUsuario[countSequencia] = LED2;
            Serial.println("Usuario apertou 2");
            Serial.println(sequenciaResposta[countSequencia]);

            if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
              state = 3;
              acertou = 0;
            }
            countSequencia++;
          }
          if (digitalRead(KEY3) == LOW) {
            //salvando na sequencia e aumentando contador
            sequenciaUsuario[countSequencia] = LED3;
            Serial.println("Usuario apertou 3");
            Serial.println(sequenciaResposta[countSequencia]);

            if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
              state = 3;
              acertou = 0;
            }
            countSequencia++;
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
      digitalWrite(LED1, LOW);
      if (acertou) {
        digitalWrite(LED2, LOW);
        digitalWrite(LED3, LOW);
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

  
}

void RestartSequence() {
  state = 1;
  countSequencia = 0;
  acertou = 1;
  Serial.println("Resetando sequencia");
  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
}
