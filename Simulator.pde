import controlP5.*;
import beads.*;
import java.util.Arrays;


boolean getDataFromJSON = false;


AudioContext ac;
TextToSpeechMaker ttsMaker;
ControlP5 p5;




void setup() {
  size(1000, 800);
  background(0);
  noStroke();
  
  ac = new AudioContext();
  ttsMaker = new TextToSpeechMaker();
  p5 = new ControlP5(this);
  
  OverallWiring();
  DistanceWiring();
  CrawlingWiring();
  ClimbingWiring();
  VitalsWiring();
  
  OverallUI(width / 4 - 175, height / 4 - 90);
  VitalsUI(width / 4 - 50, height / 4 - 85);
  p5.addTextlabel("DistanceSectionText")
    .setPosition(3 * width / 4 - 30, 25)
    .setText("DISTANCE MODE:");
  DistanceUI(3 * width / 4 - 75, height / 4 - 75);
  p5.addTextlabel("CrawlingSectionText")
    .setPosition(width / 4 - 30, height / 2 + 25)
    .setText("CRAWLING MODE:");
  CrawlingUI(width / 4 - 125, 3 * height / 4 - 25);
  p5.addTextlabel("ClimbingSectionText")
    .setPosition(3 * width / 4 - 30, height / 2 + 25)
    .setText("CLIMBING MODE:");
  ClimbingUI(3 * width / 4 - 75, 3 * height / 4 - 50);
  distanceImg = loadImage("distance.png");
  crawlingImg = loadImage("crawling.jpg");
  climbingImg = loadImage("climbing.jpg");
  
  LoadDistanceJSONData();
  LoadCrawlingJSONData();
  LoadClimbingJSONData();
  ScenarioUI(65, height / 4 + 100);
  
  ac.start();
  OverallChange();
}



PImage distanceImg;
PImage crawlingImg;
PImage climbingImg;

void draw() {
  background(0);
  
  tint(100, 100, 100);
  if (mode == 1) {
    image(distanceImg, width / 2, 0, width / 2, height / 2);
    if (getDataFromJSON) {
      fill(0, 255, 0);
      rect(width / 2, 0, width / 2, 10);
      rect(width / 2, height / 2 - 15, width / 2, 15);
      rect(width / 2, 0, 15, height / 2);
      rect(width - 10, 0, 10, height / 2);
    }
  }
  else if (mode == 2) {
    image(crawlingImg, 0, height / 2, width / 2, height / 2);
    if (getDataFromJSON) {
      fill(0, 255, 0);
      rect(0, height / 2, width / 2, 15);
      rect(0, height - 10, width / 2, 10);
      rect(0, height / 2, 10, height / 2);
      rect(width / 2 - 15, height / 2, 15, height / 2);
    }
  }
  else if (mode == 3) {
    image(climbingImg, width / 2, height / 2, width / 2, height / 2);
    if (getDataFromJSON) {
      fill(0, 255, 0);
      rect(width / 2, height / 2, width / 2, 15);
      rect(width / 2, height - 10, width / 2, 10);
      rect(width / 2, height / 2, 15, height / 2);
      rect(width - 10, height / 2, 10, height / 2);
    }
  }
  
  fill(255, 255, 255);
  rect(width / 2 - 5, 0, 10, height);
  rect(0, height / 2 - 5, width, 10);
}
