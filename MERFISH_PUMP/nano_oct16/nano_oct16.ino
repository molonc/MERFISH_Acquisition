#define power_inter 2           // power outage interrupt
#define emergency_inter 3       // other interrupts (leakage, etc.)
#define TOP_SWITCH 4            // top limit switch (connects to both Mega and Nano)
#define BOT_SWITCH 5            // bottom limit switch (connects to both Mega and Nano)
#define DIR 6                   // direction pin on motor driver
#define STEP 7                  // step pin on motor driver
#define SPEED1 8                // first speed bit
#define SPEED2 9                // second speed bit
#define LED 10                  // LED for showing state
#define TAPPER 11               // tapper motor PWM pin
#define STATE1 12               // first state pin
#define STATE2 13               // second state pin

#define UP LOW
#define DOWN HIGH

const int speedChart[] = {1000, 5000, 10000, 12500};        // TODO: this set of speeds is for 10mL syringe. find another set for 30mL syringe
volatile bool killed = false;     // other emergency
volatile bool paused = false;     // power outage pause

enum STATES {
  GO_TO_BOTTOM,
  GO_TO_TOP,
  GO_DOWN,
  STOP
};

void setup() {
//    INPUTS
    pinMode(power_inter, INPUT);
    pinMode(emergency_inter, INPUT);
    attachInterrupt(digitalPinToInterrupt(power_inter), power_action, CHANGE);
    attachInterrupt(digitalPinToInterrupt(emergency_inter), emergency_action, CHANGE);
    pinMode(TOP_SWITCH, INPUT);
    pinMode(BOT_SWITCH, INPUT);
    pinMode(STATE1, INPUT_PULLUP);
    pinMode(STATE2, INPUT_PULLUP);
    pinMode(SPEED1, INPUT_PULLUP);
    pinMode(SPEED2, INPUT_PULLUP);
    
//    OUTPUTS
    pinMode(LED, OUTPUT);
    pinMode(STEP, OUTPUT);
    pinMode(DIR, OUTPUT);
    pinMode(TAPPER, OUTPUT);

//    Initialization
    init_blink();
    goToBottom(speedChart[0], 1);
    no_blink();
}

void loop() {
  if (!paused && !killed) {
      no_blink();

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
      if (delayTime > 15000) {      // simply because delayMicroseconds doesn't work too well with the delayTime being too large
          delayTime = delayTime / 2;
          iter = 2;  
      }

      // switch states:
      switch (run_state) {
          case GO_TO_BOTTOM:
              tap(100);             // TODO: define a good PWM wave for the tapper, 100 is default value for now
              goToBottom(delayTime, iter);
              break;
          case GO_TO_TOP:
              tap(100);
              goToTop(delayTime, iter);
              break;
          case GO_DOWN:
              tap(100);
              goDown(delayTime, iter);
              break;
          case STOP:
              tap(0);
              stop();
              break;
      }
  }
  else {
      if (paused) slow_blink();
      if (killed) fast_blink();
  }
}

void blink(int delayTime) {
  // overwrite the built-in blink library function
  // blink the LED with delayTime in millisecond
    digitalWrite(LED, HIGH);
    delay(delayTime);
    digitalWrite(LED, LOW);
    delay(delayTime);
}

void init_blink() {
  // indicate that system is initializing
    blink(500);
}

void no_blink() {
  // steady LED light with no blink
    digitalWrite(LED, HIGH);
}

void slow_blink() {
  // slow blinking when system is paused
    blink(1000);
}

void fast_blink() {
  // fast blinking when an emergency has occured (leakage)
    blink(250);
}

void tap(int dutyCycle) {
  // dutyCycle: 0-255 inclusive
    analogWrite(TAPPER, dutyCycle);  
}

void runMotor(int delayTime, int iter) {
  // run motor driver with delayTime in microseconds, iterate for iter times
    digitalWrite(STEP, HIGH);
    for (int i = 0; i < iter; ++i) delayMicroseconds(delayTime);
    digitalWrite(STEP, LOW);
    for (int i = 0; i < iter; ++i) delayMicroseconds(delayTime);  
}

void goToTop(int delayTime, int iter) {
  // drive motor up until the top switch has been triggered
    digitalWrite(DIR, UP);
    while (digitalRead(TOP_SWITCH) != HIGH && !killed && !paused) {
        runMotor(delayTime, iter);  
    }
    digitalWrite(STEP, LOW);
}

void goToBottom(int delayTime, int iter) {
  // drive motor down until the bottom switch has been triggered
    digitalWrite(DIR, DOWN);
    while (digitalRead(BOT_SWITCH) != HIGH && !killed && !paused) {
        runMotor(delayTime, iter);
    }  
    digitalWrite(STEP, LOW);
}

void goDown(int delayTime, int iter) {
  // driver motor down
    digitalWrite(DIR, DOWN);
    runMotor(delayTime, iter);  
}

void stop() {
  // stop motor
    digitalWrite(STEP, LOW);  
}

// ISR
void power_action() {
    if (digitalRead(power_inter) == HIGH) {
        // this means it was a RISING edge
        // pause motor immediately, until kill switch is off again
        stop(); 
        tap(0);
        paused = true;
    }  
    else {
        // this means it was a FALLING edge
        // resume program immediately  
        paused = false;
    }
}

// ISR
void emergency_action() {
    if (digitalRead(emergency_inter) == HIGH) {
        // this means emergency has been triggered
        // stop the motor immediately, until issue has been solved  
        // (usually leakage)
        stop();
        tap(0);
        killed = true;
    }  

    else {
        // this means leakage has been cleared
        // resume program
        killed = false;
    }
}
