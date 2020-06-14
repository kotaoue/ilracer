Racer _hero_racer;
Racer[] _rival_racers;
float _innerDiameter, _outerDiameter;
boolean savePng = true;

void setup() {
  colorMode(RGB);
  size(255, 255);
  smooth();
  frameRate(30);

  _innerDiameter = width * 0.8;
  _outerDiameter = width * 0.9;

  _hero_racer = new Racer(-3, 0, _innerDiameter);
  _rival_racers = new Racer[12];
  for (int $i = 0; $i < _rival_racers.length; $i++) {
    float diameter = _innerDiameter;
    if (round(random(0, 1)) == 1) {
      diameter = _outerDiameter;
    }
    _rival_racers[$i] = new Racer(3, ((360 / _rival_racers.length) * $i), diameter);
  }
}


void draw() {
  background(255);  
  strokeWeight(3);  
  noFill();
  circuit(_innerDiameter);
  circuit(_outerDiameter);

  strokeWeight(1);  
  for (int i = 0; i < _rival_racers.length; i++) {
    _rival_racers[i].drawMe();
  }
  _hero_racer.drawMe();

  int checkFrame = 2;
  for (int i = 0; i < _rival_racers.length; i++) {
    if (_hero_racer.getExtent() == _rival_racers[i].getExtent()) {
      float minAngle = _rival_racers[i].currentAngle() ;
      float maxAngle = _rival_racers[i].nextAngle(checkFrame) ;

      if ( minAngle > maxAngle) {
        float tempAngle = minAngle;
        minAngle = maxAngle ;
        maxAngle = tempAngle;
      }

      // println(str(minAngle) + ' ' + str(maxAngle) + ' ' + str(_hero_racer.currentAngle() ));
      if (minAngle <= _hero_racer.currentAngle() && _hero_racer.currentAngle() <= maxAngle) {
        if (_hero_racer.getExtent() == _innerDiameter) {
          _hero_racer.setExtent(_outerDiameter) ;
        } else {
          _hero_racer.setExtent(_innerDiameter) ;
        }
      }
    }
  }

  if (_hero_racer.currentAngle() < _hero_racer.absSpeed()) {
    savePng = false;
    saveFrame("frames/result.png");
  }

  if (savePng) {
    saveFrame("frames/####.png");
  }
}

void circuit(float extent) {
  float x, y;
  float centerX = width / 2;
  float centerY = height /2;
  float lastx = width;
  float lasty = height;

  for (float ang = 0; ang <= 360; ang += 5) {
    float rad = radians(ang);
    x = centerX + ((extent / 2) * cos(rad));
    y = centerY + ((extent / 2) * sin(rad));

    if (lastx < width) {
      line(x, y, lastx, lasty);
    }

    lastx = x;
    lasty = y;
  }
}

class Racer {
  float x, y;
  float speed;
  float angle;
  float extent;
  float centerX = width / 2;
  float centerY = height /2;

  Racer(float s, float a, float e) {
    speed = s;
    angle = a;
    extent = e;
  }

  void drawMe() {
    float rad = radians(angle);
    x = centerX + ((extent / 2) * cos(rad));
    y = centerY + ((extent / 2) * sin(rad));

    if (speed > 0 ) {
      fill(255, 0, 0);
    } else {
      fill(0, 0, 255);
    }
    circle(x, y, 10);

    angle = nextAngle();
  }

  float getExtent() {
    return extent;
  }

  void setExtent(float e) {
    extent = e;
  }

  float currentAngle() {
    return angle;
  }

  float nextAngle() {
    return nextAngle(1);
  }

  float nextAngle(int f) {
    float a = currentAngle() + (speed * f);
    if (a > 360) {
      a -= 360;
    }
    if (a < 0) {
      a += 360;
    }
    return a;
  }

  float absSpeed() {
    return abs(speed);
  }
}
