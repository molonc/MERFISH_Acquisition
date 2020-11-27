// MEGA, not being used if used with MATLAB
#define killSwitch_inter 21
#define ON_OFF 10
#define STATE1 39
#define STATE2 41
#define SPEED1 43
#define SPEED2 45

byte message = 0b00000000;
volatile bool killed = false;

void setup() {
  Serial.begin(9600);

  // INPUTS
  pinMode(killSwitch_inter, INPUT);
  attachInterrupt(digitalPinToInterrupt(killSwitch_inter), sendToNano, CHANGE);
  
  // OUTPUTS
  pinMode(ON_OFF, OUTPUT);
  pinMode(STATE1, OUTPUT);
  pinMode(STATE2, OUTPUT);
  pinMode(SPEED1, OUTPUT);
  pinMode(SPEED2, OUTPUT);
}

void loop() {
  if (Serial.available() > 0 && !killed) {
        message = Serial.read();
        received = true;
        
      // message: 8-bit
      // [5-7][3-4][1-2][0]
      // 0: ON/OFF bit, 0-OFF, 1-ON
      // 1-2: STATE bits
      // 3-4: SPEED bits
      // 5-7: always LOW
      int on_off = (message & 0b00000001);
      int state1 = (message & 0b00000010);
      int state2 = (message & 0b00000100);
      int speed1 = (message & 0b00001000);
      int speed2 = (message & 0b00010000);
      digitalWrite(STATE1, state1);
      digitalWrite(STATE2, state2);
      digitalWrite(SPEED1, speed1);
      digitalWrite(SPEED2, speed2);
      digitalWrite(ON_OFF, on_off);   
  }
}

// ISR
void sendToNano() {
    if (digitalRead(killSwitch_inter) == HIGH) {
        // that means it was a RISING edge
        // stop NANO immediately, until kill switch is OFF again
        digitalWrite(ON_OFF, LOW);  
        killed = true;
    } 
    else {
        // that means it was a FALLING edge
        // resume NANO immediately
        killed = false;
    } 
}
