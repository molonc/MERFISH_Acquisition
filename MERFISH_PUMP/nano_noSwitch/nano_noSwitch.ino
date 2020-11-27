#define killSwitch_inter 2
//#define interruptPin 3
#define DIR 6   // TODO: update all the pins
#define STEP 7
#define ON_OFF 8
#define STATE1 9
#define STATE2 10
#define SPEED1 11
#define SPEED2 12
#define GO_UP LOW
#define GO_DOWN HIGH

int speedChart[] = {1000, 6000, 10000, 12500};
volatile bool killed = false;

void setup() {
    Serial.begin(9600);
//    INPUTS
    pinMode(killSwitch_inter, INPUT);
    attachInterrupt(digitalPinToInterrupt(killSwitch_inter), action, CHANGE);
    pinMode(ON_OFF, INPUT);
    pinMode(STATE1, INPUT_PULLUP);
    pinMode(STATE2, INPUT_PULLUP);
    pinMode(SPEED1, INPUT_PULLUP);
    pinMode(SPEED2, INPUT_PULLUP);
    
//    OUTPUTS
    pinMode(STEP, OUTPUT);
    pinMode(DIR, OUTPUT);

//    Initialization
    Serial.println("initializing");
    goToBottom(speedChart[0], 1);
    Serial.println("done initializing");
}

void loop() {

  if (digitalRead(ON_OFF) == HIGH && !killed) {
      // states:
      // 00: go to bottom ONLY
      // 01: go to top ONLY
      // 10: go down
      // 11: stop motor
      int state1bit = (digitalRead(STATE1) == HIGH) ? 1 : 0;
      int state2bit = (digitalRead(STATE2) == HIGH) ? 2 : 0;
      int speed1bit = (digitalRead(SPEED1) == HIGH) ? 1 : 0;
      int speed2bit = (digitalRead(SPEED2) == HIGH) ? 2 : 0;

      int run_state = (state1bit | state2bit);
      int run_speed = (speed1bit | speed2bit);
      int iter = 1;
      int delayTime = speedChart[run_speed];
      if (delayTime > 15000) {
          delayTime = delayTime / 2;
          iter = 2;  
      }

      // switch states:
      switch (run_state) {
          case 0:
              goToBottom(delayTime, iter);
              delay(60000);
              break;
          case 1:
              goToTop(delayTime, iter);
              delay(60000);
              break;
          case 2:
              goDown(delayTime, iter);
              break;
          case 3:
              stop();
              break;
      }
  }
}

void runMotor(int delayTime, int iter) {
    digitalWrite(STEP, HIGH);
    for (int i = 0; i < iter; ++i) delayMicroseconds(delayTime);
    digitalWrite(STEP, LOW);
    for (int i = 0; i < iter; ++i) delayMicroseconds(delayTime);  
}

void goToTop(int delayTime, int iter) {
    digitalWrite(DIR, GO_UP);
    for (int i = 0; i < 5000; ++i) {
        runMotor(delayTime, iter);  
    }
    digitalWrite(STEP, LOW);
}

void goToBottom(int delayTime, int iter) {
    digitalWrite(DIR, GO_DOWN);
    for (int i = 0; i < 5000; ++i) {
        runMotor(delayTime, iter);
    }  
    digitalWrite(STEP, LOW);
}

void goDown(int delayTime, int iter) {
    digitalWrite(DIR, GO_DOWN);
    while (digitalRead(STATE1) != HIGH) runMotor(delayTime, iter);  
}

void stop() {
    digitalWrite(STEP, LOW);  
}

// ISR
void action() {
    if (digitalRead(killSwitch_inter) == HIGH) {
        // this means it was a RISING edge
        // stop motor immediately, until kill switch is off again
        stop();
        killed = true;
        Serial.println("killed");
    }  
    else {
        // this means it was a FALLING edge
        // resume program immediately  
        killed = false;
        Serial.println("resume");
    }
}
