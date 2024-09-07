Gain allSelectableModesGain;
Gain distanceGain;
Gain crawlingGain;
Gain climbingGain;
Gain vitalsGain;

Glide allSelectableModesGainGlide;
Glide distanceGainGlide;
Glide crawlingGainGlide;
Glide climbingGainGlide;
Glide vitalsGainGlide;

void OverallWiring() {
  allSelectableModesGainGlide = new Glide(ac, 1, 500);
  allSelectableModesGain = new Gain(ac, 3, allSelectableModesGainGlide);
  
  distanceGainGlide = new Glide(ac, 0.4, 500);
  distanceGain = new Gain(ac, 1, distanceGainGlide);
  allSelectableModesGain.addInput(distanceGain);
  
  crawlingGainGlide = new Glide(ac, 0, 500);
  crawlingGain = new Gain(ac, 1, crawlingGainGlide);
  allSelectableModesGain.addInput(crawlingGain);
  
  climbingGainGlide = new Glide(ac, 0, 500);
  climbingGain = new Gain(ac, 2, climbingGainGlide);
  allSelectableModesGain.addInput(climbingGain);
  
  vitalsGainGlide = new Glide(ac, 0, 500);
  vitalsGain = new Gain(ac, 3, vitalsGainGlide);
  
  ac.out.addInput(allSelectableModesGain);
  ac.out.addInput(vitalsGain);
}

void OverallChange() {
  VitalsChange();
  DistanceChange();
  CrawlingChange();
  ClimbingChange();
  
  if ((heartbeatPriority || rateWaterPriority || bodyTempPriority) && vitalsOn) {
    vitalsGainGlide.setValue(1);
    allSelectableModesGainGlide.setValue(0.001f);
  }
  else {
    vitalsGainGlide.setValue(0);
    allSelectableModesGainGlide.setValue(1);
  }
}





Button distanceButton;
Button crawlingButton;
Button climbingButton;
int mode = 1;

void OverallUI(float x, float y) {
  p5.addTextlabel("OverallSectionText")
    .setPosition(x + 20, y - 25)
    .setText("MODES:");
  
  distanceButton = p5.addButton("DistanceButton")
                     .setPosition(x, y)
                     .setSize(80, 30)
                     .activateBy((ControlP5.RELEASE))
                     .setLabel("Distance Mode");
                     
  crawlingButton = p5.addButton("CrawlingButton")
                     .setPosition(x, y + 40 * 1)
                     .setSize(80, 30)
                     .activateBy((ControlP5.RELEASE))
                     .setLabel("Crawling Mode");
                     
  climbingButton = p5.addButton("ClimbingButton")
                     .setPosition(x, y + 40 * 2)
                     .setSize(80, 30)
                     .activateBy((ControlP5.RELEASE))
                     .setLabel("Climbing Mode");
}

void DistanceButton() {
  distanceGainGlide.setValue(0.4);
  crawlingGainGlide.setValue(0);
  climbingGainGlide.setValue(0);
  mode = 1;
}

void CrawlingButton() {
  distanceGainGlide.setValue(0);
  crawlingGainGlide.setValue(0.4);
  climbingGainGlide.setValue(0);
  mode = 2;
}

void ClimbingButton() {
  distanceGainGlide.setValue(0);
  crawlingGainGlide.setValue(0);
  climbingGainGlide.setValue(1);
  mode = 3;
}
