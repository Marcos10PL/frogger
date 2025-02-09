//frog
PImage frogTop, frogLeft, frogRight, frogDown, lastPosition;
int frogX = 421, frogY = 781;
int frogSpeed = 34, frogSize = 58;

//backgorund
PImage grass, road, river;

//cars
PImage greenLeft, greenRight, blueLeft, blueRight, redLeft, redRight;
int[] carX = {0, 600, 200, 700, 150, 450, 650, 750, 100};
int[] carY = {372, 372, 508, 508, 644, 644, 644, 712, 712};
int numOfLeftCars = 4;
int carSpeed = 4;

//trucks
PImage truckLeft, truckRight;
int[] truckX = {400, 100};
int[] truckY = {440, 576};
int numOfLeftTrucks = 1;
int truckSpeed = 3;

//log and woods
PImage log, wood;
int[] woodX = {200, 700, 50};
int[] woodY = {238, 102, 102};
int[] woodLong = {350, 400, 250};
int logX = 200, logY = 170;
int logSpeed = 5;

//other
PImage heart;
int lives = 5;
int bestSeconds = 0, bestMinutes = 0;
int startTime, currentTime, seconds, minutes;
boolean gameStarted = true;

void setup()
{
  size(900, 840);
  frameRate(60);
  
  //frog
  frogTop = loadImage("frog/frog.png");
  frogLeft = loadImage("frog/frog-left.png");
  frogRight = loadImage("frog/frog-right.png");
  frogDown = loadImage("frog/frog-down.png"); 
  lastPosition = frogTop;
  
  //background
  grass = loadImage("background/grass.png");
  river = loadImage("background/river.png");
  road = loadImage("background/road.png"); 
  
  //cars
  greenLeft = loadImage("cars/green-left.png");
  greenRight = loadImage("cars/green-right.png");
  blueLeft = loadImage("cars/blue-left.png");
  blueRight = loadImage("cars/blue-right.png");
  redLeft = loadImage("cars/red-left.png");
  redRight = loadImage("cars/red-right.png");
  
  //trucks
  truckLeft = loadImage("cars/truck-left.png");
  truckRight = loadImage("cars/truck-right.png");
  
  //on river
  wood = loadImage("on-river/wood.png");
  log = loadImage("on-river/log.png");
  
  //heart
  heart = loadImage("other/heart.png");
  startTime = millis();
}

void draw()
{
  background(50);
  
  if(gameStarted)
  {
    //lives
    int offset = 0;
    for(int i = 0; i < lives; i++)
    {
      image(heart, 864 - offset, 2, 32, 28);
      offset += 38;
    }
    
    //time
    currentTime = millis() - startTime;
    minutes = (currentTime / (1000 * 60)) % 60;
    seconds = (currentTime / 1000) % 60;
    
    textSize(20);
    textAlign(CENTER);
    text("CZAS - " + nf(minutes, 2) + ":" + nf(seconds, 2), 60, 22);
    
    if(bestMinutes == 0 && bestSeconds == 0)
      text("NAJLEPSZY CZAS   - - : - -", width/2, 22);
    else
      text("NAJLEPSZY CZAS - " + nf(bestMinutes, 2) + ":" + nf(bestSeconds, 2), width/2, 22);
    
    //background
    image(grass, 0, 304, 900, 60);
    image(road, 0, 364, 900, 416);
    image(river, 0, 92, 900, 212);
    image(grass, 0, 32, 900, 60);
    
    //log and woods
    boolean isOnWood = false; 
    
    image(log, logX, logY, 500, 60);
    image(wood, woodX[0], woodY[0], woodLong[0], 60);
    image(wood, woodX[1], woodY[1], woodLong[1], 60);
    image(wood, woodX[2], woodY[2], woodLong[2], 60);
    
    if(logX <= 0) logSpeed = abs(logSpeed);
    else if(logX + 500 >= width) logSpeed *= -1;
    
    logX += logSpeed;
    
    for(int i = 0; i < woodX.length; i++)
      if((frogX + frogSize/2 > woodX[i] && frogX + frogSize/2 < woodX[i] + woodLong[i] && frogY + frogSize > woodY[i] && frogY < woodY[i] + 60))
          isOnWood = true;
    
    if(frogX + frogSize/2 > logX && frogX + frogSize/2 < logX + 500 && frogY + frogSize > logY && frogY < logY + 60) 
    {
      frogX += logSpeed;
      isOnWood = true;
    }
    
    if(!isOnWood && frogY + frogSize > 92 && frogY < 304)
      reset();
    
    //frog
    image(lastPosition, frogX, frogY, frogSize, frogSize);
    
    if(frogY <= 237) frogSpeed = 68;
    else frogSpeed = 34;
    
    //road left
    image(greenLeft, carX[0], carY[0], 120, 60);
    image(redLeft, carX[1], carY[1], 120, 60);
    image(truckLeft, truckX[0], truckY[0], 160, 60);
    image(blueLeft, carX[2], carY[2], 120, 60);
    image(greenLeft, carX[3], carY[3], 120, 60);
   
    //road right
    image(truckRight, truckX[1], truckY[1], 160, 60);
    image(blueRight, carX[4], carY[4], 120, 60);
    image(greenRight, carX[5], carY[5], 120, 60);
    image(redRight, carX[6], carY[6], 120, 60);
    image(blueRight, carX[7], carY[7], 120, 60);
    image(redRight, carX[8], carY[8], 120, 60);
      
    //cars
    for(int i = 0; i < carX.length; i++)
    {
      if(i > numOfLeftCars - 1)
      {
        carX[i] += carSpeed;
        if(carX[i] > width) 
          carX[i] = -120;
      }
      else
      {
        carX[i] -= carSpeed;
        if(carX[i] <= -120) 
          carX[i] = width;
      }
  
      if (frogX + frogSize > carX[i] && frogX < carX[i] + 120 && frogY + frogSize > carY[i] && frogY < carY[i] + 60) 
        reset();
    }
    
    //truck
    for(int i = 0; i < truckX.length; i++)
    {
      if(i > numOfLeftTrucks - 1)
      {
        truckX[i] += truckSpeed;
        if(truckX[i] > width) 
          truckX[i] = -160;
      }
      else
      {
        truckX[i] -= truckSpeed;
        if(truckX[i] <= -160) 
          truckX[i] = width;
      }
  
      if (frogX + frogSize > truckX[i] && frogX < truckX[i] + 160 && frogY + frogSize > truckY[i] && frogY < truckY[i] + 60) 
        reset();
    }
  }
  
  // end
  if(lives == 0) endGame(false);
  else if(frogY + frogSize > 32 && frogY < 92) endGame(true);
}

void keyPressed()
{
  if(gameStarted)
  {
    if (keyCode == UP || key == 'w')
    {
      frogY -= frogSpeed;
      lastPosition = frogTop;
    }
    else if ((keyCode == DOWN || key == 's') && frogY < height - frogSize * 1.5) 
    {
      frogY += frogSpeed;
      lastPosition = frogDown;
    }
    else if ((keyCode == LEFT || key == 'a') && frogX - frogSize/2 > 0) 
    {
      frogX -= frogSpeed;
      lastPosition = frogLeft;
    }
    else if ((keyCode == RIGHT || key == 'd') && frogX < width - frogSize * 1.5)
    {
      frogX += frogSpeed;
      lastPosition = frogRight;
    }
  }
  else if (keyCode == ENTER)
    newGame();
}

void endGame(boolean isWin)
{
    gameStarted = false;

    fill(0);
    rect(0, 0, 900, 840);
    fill(255);
    textSize(40);
    textAlign(CENTER, CENTER);

    if(isWin) 
    {
      int lastTime = currentTime;
      int endMinutes = (lastTime / (1000 * 60)) % 60;
      int endSeconds = (lastTime / 1000) % 60;
      
      if(bestMinutes == 0 && bestSeconds == 0)
      {
        bestMinutes = endMinutes;
        bestSeconds = endSeconds;
      }
      else if(endMinutes < bestMinutes || (endMinutes == bestMinutes && endSeconds < bestSeconds)) 
      {
        bestMinutes = endMinutes;
        bestSeconds = endSeconds;
      }
      
      text("Wygrałeś!", width/2, height/2-120);
      text("Twój czas: " + nf(endMinutes, 2) + ":" + nf(endSeconds, 2), width/2, height/2-60);
      text("Najlepszy czas: " + nf(bestMinutes, 2) + ":" + nf(bestSeconds, 2), width/2, height/2);
    }
    else
      text("Przegrałeś.", width/2, height/2);
      
    text("Aby zagrać ponownie, naciśnij ENTER!", width/2, height/2+60); 
}

void reset()
{
  frogY = 781;
  frogX = 421;
  lastPosition = frogTop;
  lives--;
}

void newGame()
{
  frogY = 781;
  frogX = 421;
  lastPosition = frogTop;
  lives = 5;
  gameStarted = true;
  currentTime = 0;
  startTime = millis();
}
