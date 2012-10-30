//  From digitalwestie on github
//  Plan to edit to include other weapons and tests
//  Foilbox.pde


int offTargetA = 10;        // Off Target A Light
int offTargetB = 11;        // Off Target B Light
int onTargetA  = 12;        // On Target A Light
int onTargetB  = 13;        // On Target B Light

int weaponPinA = 0;         // Weapon A pin
int weaponPinB = 1;         // Weapon B pin
int lamePinA   = 2;         // Lame A pin
int lamePinB   = 3;         // Lame B pin

int lameA = 0;
int lameB = 0;
int weaponA = 0;
int weaponB = 0;

long millisPastA = 0;
long millisPastB = 0;
long millisPastFirst = 0;

boolean hitA = false;
boolean hitB = false;

boolean isFirstHit = true;


void setup() {
  pinMode(offTargetA, OUTPUT);
  pinMode(offTargetB, OUTPUT);
  pinMode(onTargetA,  OUTPUT);
  pinMode(onTargetB,  OUTPUT);
  
  pinMode(weaponPinA, INPUT);     
  pinMode(weaponPinB, INPUT);     
  pinMode(lamePinA,   INPUT);    
  pinMode(lamePinB,   INPUT);
  
  Serial.begin(9600);
  Serial.println("Start");
}

void loop()
{
  weaponA = analogRead(weaponPinA);
  weaponB = analogRead(weaponPinB);
  lameA   = analogRead(lamePinA);
  lameB   = analogRead(lamePinB);
  
  signalHits();  
 
  // weapon A 
  if (hitA == false) //ignore if we've hit
  {
    if (weaponA < 500)
    {
        if((isFirstHit == true) || ((isFirstHit == false) && (millisPastA+300 > millis())))
        {
            if  (millis() <= (millisPastA + 14)) // if 14ms or more have past we have a hit
            {
                hitA = true;
                if(isFirstHit)
                {
                  millisPastFirst = millis();
                }
                if (lameB > 500)
                {
                  //onTarget
                  digitalWrite(onTargetA, HIGH);
                }
                else
                {
                  //offTarget
                  digitalWrite(offTargetA, HIGH);
                }
            }
        } 
    }
    else // Nothing happening
    {
        millisPastA = millis();
    }
  }
  
  // weapon B
  if (hitB == false) // ignore if we've hit
  {
    if (weaponB < 500)
    {
        if((isFirstHit == true) || ((isFirstHit == false) && (millisPastA+300 > millis())))
        {
            if  (millis() <= (millisPastB + 14)) // if 14ms or more have past we have a hit
            {
                if(isFirstHit)
                {
                  millisPastFirst = millis();
                }
                if (lameA > 500)
                {
                  // onTarget
                  digitalWrite(onTargetB, HIGH);
                }
                else
                {
                  // offTarget
                  digitalWrite(offTargetB, HIGH);
                }
            }
        }
    }
    else // nothing happening
    {
        millisPastB = millis();
    }
  }
}

void signalHits()
{
  
  if (hitA || hitB)
  {
    if (millis() >= (millisPastFirst + 300))
    {
      // time for next action is up!
      delay(1500); 
      resetValues();      
    }
  }

}

void resetValues()
{
   // red side wont reset without fiddling with other side!!
   digitalWrite(offTargetA, LOW);
   digitalWrite(onTargetA, LOW);
   digitalWrite(offTargetB, LOW);
   digitalWrite(onTargetB, LOW);
     
   millisPastA = millis();
   millisPastB = millis();
   millisPastFirst = 0;

   hitA = false;
   hitB = false;

   isFirstHit = true;
   
   delay(500);
}
