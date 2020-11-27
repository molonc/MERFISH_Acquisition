#define DIR 6
#define STEP 7
#define GO_UP LOW
#define GO_DOWN HIGH

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  // INPUTS
  pinMode(DIR, OUTPUT);
  pinMode(STEP, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  goToTop(1000, 1);
  delay(3000);
  goToBottom(1000, 1);
  delay(3000);
}

void runMotor(int delayTime, int iter) {
    digitalWrite(STEP, HIGH);
    for (int i = 0; i < iter; ++i) delayMicroseconds(delayTime);
    digitalWrite(STEP, LOW);
    for (int i = 0; i < iter; ++i) delayMicroseconds(delayTime);  
}

void goToTop(int delayTime, int iter) {
    digitalWrite(DIR, GO_UP);
//    Serial.println("go to top");
    for (int i = 0; i < 2000; ++i) runMotor(delayTime, iter);
    digitalWrite(STEP, LOW);
}

void goToBottom(int delayTime, int iter) {
    digitalWrite(DIR, GO_DOWN);
//    Serial.println("go to bottom");
    for (int i = 0; i < 2000; ++i) runMotor(delayTime, iter);
    digitalWrite(STEP, LOW);
}
