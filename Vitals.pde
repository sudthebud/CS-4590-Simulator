float[] frequencyRangeVitalsRateWater = new float[]{10, 10000};
float heartbeatThreshold = 140;
float rateWaterThreshold = 100;
float bodyTempThreshold = 96;



boolean heartbeatPriority = false;
boolean rateWaterPriority = false;
boolean bodyTempPriority = false;
boolean vitalsOn = true;



Clock heartbeatClock;
Glide heartbeatClockInterval;
WavePlayer heartbeatWave;
SamplePlayer heartbeatSpeech;
Gain heartbeatGain;
Glide heartbeatGainGlide;
boolean heartbeatPulse = false;

SamplePlayer rateWaterPlayer;
SamplePlayer rateWaterSpeech;
BiquadFilter rateWaterFilter;
Glide rateWaterFilterGlide;
Gain rateWaterGain;
Glide rateWaterGainGlide;

SamplePlayer bodyTempPlayer;
SamplePlayer bodyTempSpeech;
Gain bodyTempPlayerGain;
Glide bodyTempPlayerGainGlide;
Gain bodyTempGain;
Glide bodyTempGainGlide;


void VitalsWiring() {
  heartbeatClockInterval = new Glide(ac, 60 / 100.0 * 1000, 500);
  heartbeatClock = new Clock(ac, heartbeatClockInterval);
  heartbeatClock.setTicksPerBeat(2);
  ac.out.addDependent(heartbeatClock);
  heartbeatWave = new WavePlayer(ac, 1000, Buffer.SINE);
  Bead heartbeatMessageListener = new Bead() {
    public void messageReceived(Bead message) {
      heartbeatWave.pause(!heartbeatPulse);
      heartbeatPulse = !heartbeatPulse;
    }
  };
  heartbeatClock.addMessageListener(heartbeatMessageListener);
  heartbeatSpeech = getSamplePlayer(ttsMaker.createTTSWavFile("Calm your breathing."));
  heartbeatSpeech.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  heartbeatSpeech.pause(true);
  Glide heartbeatWaveGainGlide = new Glide(ac, 0.4, 500);
  Gain heartbeatWaveGain = new Gain(ac, 1, heartbeatWaveGainGlide);
  heartbeatWaveGain.addInput(heartbeatWave);
  heartbeatGainGlide = new Glide(ac, 0, 500);
  heartbeatGain = new Gain(ac, 2, heartbeatGainGlide);
  heartbeatGain.addInput(heartbeatWaveGain);
  heartbeatGain.addInput(heartbeatSpeech);
  
  rateWaterPlayer = getSamplePlayer("vitals_rate_water_flow.wav");
  rateWaterPlayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  rateWaterFilterGlide = new Glide(ac, 9000, 500);
  rateWaterFilter = new BiquadFilter(ac, BiquadFilter.Type.HP, rateWaterFilterGlide, 10.0);
  rateWaterFilter.addInput(rateWaterPlayer);
  rateWaterSpeech = getSamplePlayer(ttsMaker.createTTSWavFile("Potential flood risk."));
  rateWaterSpeech.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  rateWaterSpeech.pause(true);
  rateWaterGainGlide = new Glide(ac, 0, 500);
  rateWaterGain = new Gain(ac, 2, rateWaterGainGlide);
  rateWaterGain.addInput(rateWaterFilter);
  rateWaterGain.addInput(rateWaterSpeech);
  
  bodyTempPlayer = getSamplePlayer("vitals_body_temperature.wav");
  bodyTempPlayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  bodyTempPlayerGainGlide = new Glide(ac, 1 - (98.7 - 90)/20, 500);
  bodyTempPlayerGain = new Gain(ac, 1, bodyTempPlayerGainGlide);
  bodyTempPlayerGain.addInput(bodyTempPlayer);
  bodyTempSpeech = getSamplePlayer(ttsMaker.createTTSWavFile("Hypoh thermee uh risk imminent."));
  bodyTempSpeech.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  bodyTempSpeech.pause(true);
  bodyTempGainGlide = new Glide(ac, 0, 500);
  bodyTempGain = new Gain(ac, 2, bodyTempGainGlide);
  bodyTempGain.addInput(bodyTempPlayerGain);
  bodyTempGain.addInput(bodyTempSpeech);
  
  vitalsGain.addInput(heartbeatGain);
  vitalsGain.addInput(rateWaterGain);
  vitalsGain.addInput(bodyTempGain);
}

void VitalsChange() {
  float[] vitalsData = getDataFromJSON ? VitalsDataFromJSON() : VitalsDataFromUI();
  
  float heartRate = vitalsData[0] / 200;
  float rateWaterFlow = vitalsData[1] / 300;
  float bodyTemp = (vitalsData[2] - 90) / 20;
  
  heartbeatClockInterval.setValue(60 / (heartRate * 200) * 1000);
  rateWaterFilterGlide.setValue(frequencyRangeVitalsRateWater[1] - rateWaterFlow * (frequencyRangeVitalsRateWater[1] - frequencyRangeVitalsRateWater[0]));
  bodyTempPlayerGainGlide.setValue(1 - bodyTemp);
  
  if (heartRate >= (heartbeatThreshold / 200)) {
    heartbeatSpeech.pause(false);
    heartbeatPriority = true;
  }
  else {
    heartbeatSpeech.pause(true);
    heartbeatSpeech.setPosition(0);
    heartbeatPriority = false;
  }
  
  if (rateWaterFlow >= (rateWaterThreshold / 300)) {
    rateWaterSpeech.pause(false);
    rateWaterPriority = true;
  }
  else {
    rateWaterSpeech.pause(true);
    rateWaterSpeech.setPosition(0);
    rateWaterPriority = false;
  }
  
  if (bodyTemp <= ((bodyTempThreshold - 90)/20)) {
    bodyTempSpeech.pause(false);
    bodyTempPriority = true;
  }
  else {
    bodyTempSpeech.pause(true);
    bodyTempSpeech.setPosition(0);
    bodyTempPriority = false;
  }
  
  if (heartbeatPriority) {
    heartbeatGainGlide.setValue(1);
    rateWaterGainGlide.setValue(0);
    bodyTempGainGlide.setValue(0);
  }
  else if (rateWaterPriority) {
    heartbeatGainGlide.setValue(0);
    rateWaterGainGlide.setValue(1);
    bodyTempGainGlide.setValue(0);  
  }
  else if (bodyTempPriority) {
    heartbeatGainGlide.setValue(0);
    rateWaterGainGlide.setValue(0);
    bodyTempGainGlide.setValue(1); 
  }
  else {
    heartbeatGainGlide.setValue(0);
    rateWaterGainGlide.setValue(0);
    bodyTempGainGlide.setValue(0);  
  }
}

float[] VitalsDataFromJSON() {
  float[] vitalsData = new float[3];
  
  VitalsData[] allData = (currentScenario == 1) ? (VitalsData[])distanceScenarioData[0] : ((currentScenario == 2) ? (VitalsData[])crawlingScenarioData[0] : (VitalsData[])climbingScenarioData[0]);
  int index = (currentScenario == 1) ? currentDistanceScenarioIndex[0] : ((currentScenario == 2) ? currentCrawlingScenarioIndex[0] : currentClimbingScenarioIndex[0]); 
  VitalsData leftData = allData[index % allData.length];
  VitalsData rightData = allData[(index + 1) % allData.length];
  
  float time = (currentScenario == 1) ? currentDistanceScenarioTime : ((currentScenario == 2) ? currentCrawlingScenarioTime : currentClimbingScenarioTime); 
  vitalsData[0] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getHeartRate(), rightData.getHeartRate());
  vitalsData[1] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getRateWater(), rightData.getRateWater());
  vitalsData[2] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getBodyTemp(), rightData.getBodyTemp());
  
  heartbeatSlider.setValue(vitalsData[0]);
  rateWaterSlider.setValue(vitalsData[1]);
  bodyTempSlider.setValue(vitalsData[2]);
  
  return vitalsData;
}

float[] VitalsDataFromUI() {
  float[] vitalsData = new float[3];
  
  vitalsData[0] = heartbeatSlider.getValue();
  vitalsData[1] = rateWaterSlider.getValue();
  vitalsData[2] = bodyTempSlider.getValue();
  
  return vitalsData;  
}




Slider heartbeatSlider;
Slider rateWaterSlider;
Slider bodyTempSlider;
Button vitalsButton;

void VitalsUI(float x, float y) {
   p5.addTextlabel("VitalsSectionText")
    .setPosition(x + 70, y - 30)
    .setText("VITALS:");
  
  heartbeatSlider = p5.addSlider("HeartbeatSlider")
                      .setPosition(x, y)
                      .setSize(150, 15)
                      .setRange(1, 200)
                      .setValue(100)
                      .setNumberOfTickMarks(201)
                      .showTickMarks(false)
                      .setLabel("Heart Rate");

  rateWaterSlider = p5.addSlider("RateWaterSlider")
                      .setPosition(x, y + 25 * 1)
                      .setSize(150, 15)
                      .setRange(0, 300)
                      .setValue((1 - 9000 / (frequencyRangeVitalsRateWater[1] - frequencyRangeVitalsRateWater[0])) * 300)
                      .setLabel("Rate of Water Flow");

  bodyTempSlider = p5.addSlider("BodyTempSlider")
                      .setPosition(x, y + 25 * 2)
                      .setSize(150, 15)
                      .setRange(90, 110)
                      .setValue(98.7)
                      .setLabel("Body Temperature");
                      
  vitalsButton = p5.addButton("VitalsButton")
                   .setPosition(x, y + 25 * 3)
                   .setSize(80, 30)
                   .activateBy((ControlP5.RELEASE))
                   .setLabel("Turn Off Vitals");
}

void HeartbeatSlider() {
  if (!getDataFromJSON) {
    OverallChange();
  }
}

void RateWaterSlider() {
  if (!getDataFromJSON) {
    OverallChange();
  }
}

void BodyTempSlider() {
  if (!getDataFromJSON) {
    OverallChange();  
  }
}

void VitalsButton() {
  if (vitalsOn) {
    vitalsOn = false;
    vitalsButton.setLabel("Turn On Vitals");
  }
  else {
    vitalsOn = true;
    vitalsButton.setLabel("Turn Off Vitals");
  }
  OverallChange();
}
