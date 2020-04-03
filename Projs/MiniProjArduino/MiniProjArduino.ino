/*
  Nome: Felipe Pessoa e Guilherme Bizzo
  Matricula: 1411716 e 1710563
*/
//TODO:
//1- Botar sons de acerto e erro
//2- Ver quanto tempo cada jogador levou para acertar a sequencia, e usar isso para desempate da rodada e desempate final
//3- Botar para piscar o resultado no final e botar um som?
//4- Separar previousMillis para cada key (pode ver o exemplo no event driven)


#include "pindefs.h"

/* Define shift register pins used for seven segment display */
#define LATCH_DIO 4
#define CLK_DIO 7
#define DATA_DIO 8

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0X80, 0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1, 0xF2, 0xF4, 0xF8};

int state = 1;
int countSequencia = 0;
int acertou = 0;
int turnCount = 1;
int pontos1 = 0;
int pontos2 = 0;
int turnPlayer = 1;

unsigned long previousMillis = 0;
unsigned long interval = 200;
unsigned long ledInterval = 1000;

int sequenciaResposta[5];
int sequenciaUsuario[5];

void setup() {
  /* Set DIO pins to outputs */
  pinMode(LATCH_DIO, OUTPUT);
  pinMode(CLK_DIO, OUTPUT);
  pinMode(DATA_DIO, OUTPUT);

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

  WriteNumberToSegment(0 , turnCount);
  WriteNumberToSegment(1 , turnPlayer);
  WriteNumberToSegment(2 , pontos1);
  WriteNumberToSegment(3 , pontos2);

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
        if (currentMillis - previousMillis >= interval and (digitalRead(KEY1) == LOW or digitalRead(KEY2) == LOW or digitalRead(KEY3) == LOW)){
          previousMillis = currentMillis;

          if (digitalRead(KEY1) == LOW) {
            checkSequencia(LED1);
          }
          if (digitalRead(KEY2) == LOW) {
            checkSequencia(LED2);

          }
          if (digitalRead(KEY3) == LOW) {
            checkSequencia(LED3);
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
      if (acertou) {
        //Ativa som de acerto
        //tone(3, 32, 100);
        //tone(3, 49, 100);
        if (turnPlayer == 1) {
          pontos1 += 1;
        }
        else {
          pontos2 += 1;
        }
      }
      else {
        //Ativa som de erro
        //tone(3, 20, 100);
        //tone(3, 20, 100);
      }

      turnPlayer = (turnPlayer == 1) ? 2 : 1;

      if (turnCount < 5) {
        if(turnPlayer == 1){
          turnCount += 1; 
        }
        RestartSequence();
      }
      else {
        //input para resetar
        if (currentMillis - previousMillis >= interval) {
          previousMillis = currentMillis;

          if (digitalRead(KEY1) == LOW and digitalRead(KEY2) == LOW and digitalRead(KEY3) == LOW) {
            RestartGame();
          }
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
  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
}

void RestartGame() {
  turnCount = 1;
  pontos1 = 0;
  pontos2 = 0;
  turnPlayer = 1;
  RestartSequence();
}

void checkSequencia(int led) {
  //salvando na sequencia e aumentando contador
  sequenciaUsuario[countSequencia] = led;
  Serial.println("Usuario apertou ");
  Serial.println(led);
  if (sequenciaUsuario[countSequencia] != sequenciaResposta[countSequencia]) {
    state = 3;
    acertou = 0;
  }

  countSequencia++;
}

/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToSegment(byte Segment, byte Value) {
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment] );
  digitalWrite(LATCH_DIO, HIGH);
}
