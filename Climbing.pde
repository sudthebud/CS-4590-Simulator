float[] beatIntervalRangeClimbing = new float[]{250, 3000};
float[] frequencyRangeClimbing = new float[]{500, 750};




Clock elevationClock;
Glide elevationClockInterval;
boolean wavePausedClimbing = false;

WavePlayer wetnessWave;
Glide wetnessFrequencyGlide;

Reverb rigidityReverb;

SamplePlayer contactPointsPlayer;




void ClimbingWiring() {
  elevationClockInterval = new Glide(ac, 1000, 500);
  elevationClock = new Clock(ac, elevationClockInterval);
  elevationClock.setTicksPerBeat(2);
  ac.out.addDependent(elevationClock);
  
  wetnessFrequencyGlide = new Glide(ac, 500, 500);
  wetnessWave = new WavePlayer(ac, wetnessFrequencyGlide, Buffer.SINE);
  Bead wetnessMessageListener = new Bead() {
    public void messageReceived(Bead message) {
      wetnessWave.pause(!wavePausedClimbing);
      wavePausedClimbing = !wavePausedClimbing;
    }
  };
  elevationClock.addMessageListener(wetnessMessageListener);
  
  rigidityReverb = new Reverb(ac);
  rigidityReverb.setDamping(0);
  rigidityReverb.setSize(0);
  rigidityReverb.setLateReverbLevel(0);
  rigidityReverb.addInput(wetnessWave);
  
  contactPointsPlayer = getSamplePlayer(ttsMaker.createTTSWavFile("Please keep 3 limbs in contact with the wall."));
  contactPointsPlayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  contactPointsPlayer.pause(true);
  
  climbingGain.addInput(rigidityReverb);
  climbingGain.addInput(contactPointsPlayer);
}

void ClimbingChange() {
  float[] climbingData = getDataFromJSON ? ClimbingDataFromJSON() : ClimbingDataFromUI();
  
  int contactPoints = (int)climbingData[0];
  float elevationMax = climbingData[1];
  float elevation = climbingData[2] / elevationMax;
  float rigidity = climbingData[3] / 1000;
  float wetness = climbingData[4];
  
  if (contactPoints >= 3) {
    contactPointsPlayer.pause(true);
    contactPointsPlayer.setPosition(0);
  }
  else {
    contactPointsPlayer.pause(false);  
  }
  
  elevationClockInterval.setValue(beatIntervalRangeClimbing[0] + elevation * (beatIntervalRangeClimbing[1] - beatIntervalRangeClimbing[0]));
  
  wetnessFrequencyGlide.setValue(frequencyRangeClimbing[0] + wetness * (frequencyRangeClimbing[1] - frequencyRangeClimbing[0]));
  
  rigidityReverb.setDamping(rigidity);
  rigidityReverb.setSize((rigidity > 0) ? 0.2 : 0);
  rigidityReverb.setLateReverbLevel((rigidity > 0) ? 1 : 0);
}

float[] ClimbingDataFromJSON() {
  float[] climbingData = new float[5];
  
  ClimbingData[] allData = (ClimbingData[])climbingScenarioData[1];
  int index = currentClimbingScenarioIndex[1];
  ClimbingData leftData = allData[index % allData.length];
  ClimbingData rightData = allData[(index + 1) % allData.length];
  
  float time = currentClimbingScenarioTime;
  climbingData[0] = (float)leftData.getContactPoints();
  climbingData[1] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getElevationMax(), rightData.getElevationMax());
  climbingData[2] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getElevation(), rightData.getElevation());
  climbingData[3] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getRigidity(), rightData.getRigidity());
  climbingData[4] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getWetness(), rightData.getWetness());
  
  contactPointButtons.setValue(climbingData[0]);
  elevationMaxSlider.setValue(climbingData[1]);
  elevationSlider.setValue(climbingData[2]);
  rigiditySlider.setValue(climbingData[3]);
  wetnessSlider.setValue(climbingData[4]);
  
  return climbingData;
}

float[] ClimbingDataFromUI() {
  float[] climbingData = new float[5];
  
  climbingData[0] = contactPointButtons.getValue();
  climbingData[1] = elevationMaxSlider.getValue();
  climbingData[2] = elevationSlider.getValue();
  climbingData[3] = rigiditySlider.getValue();
  climbingData[4] = wetnessSlider.getValue();
  
  return climbingData;
}





ButtonBar contactPointButtons;

Slider elevationSlider;
Slider elevationMaxSlider;

Slider rigiditySlider;
Slider wetnessSlider;

void ClimbingUI(float x, float y) {
  contactPointButtons = p5.addButtonBar("ContactPointButtons")
                          .setPosition(x, y)
                          .setSize(150, 15)
                          .addItem("0", 0)
                          .addItem("1", 1)
                          .addItem("2", 2)
                          .addItem("3", 3)
                          .addItem("4", 4)
                          .setValue(3);
                          
  p5.addTextlabel("ContactPointsLabel")
    .setPosition(x + 150, y + 2)
    .setText("CONTACT POINTS");
                          
  elevationMaxSlider = p5.addSlider("ElevationMaxSlider")
                    .setPosition(x, y + 25 * 1)
                    .setSize(150, 15)
                    .setRange(1, 1600)
                    .setValue(1600)
                    .setLabel("Max Elevation");
                    
  elevationSlider = p5.addSlider("ElevationSlider")
                    .setPosition(x, y + 25 * 2)
                    .setSize(150, 15)
                    .setRange(0, elevationMaxSlider.getValue())
                    .setValue(100)
                    .setLabel("Current Elevation");
                    
  rigiditySlider = p5.addSlider("RigiditySlider")
                    .setPosition(x, y + 25 * 3)
                    .setSize(150, 15)
                    .setRange(0, 1000)
                    .setValue(100)
                    .setLabel("Rigidity");
                                     
  wetnessSlider = p5.addSlider("WetnessSlider")
                    .setPosition(x, y + 25 * 4)
                    .setSize(150, 15)
                    .setRange(0, 1)
                    .setValue(0.2)
                    .setLabel("Wetness");

}

void ContactPointButtons() {
  if (!getDataFromJSON) {
    OverallChange();
  }
}

void ElevationMaxSlider(float elevationMax) {
  if (!getDataFromJSON) {
    if (elevationSlider.getValue() >= elevationMax) {
      elevationSlider.setValue(elevationMax);    
    }
    elevationSlider.setRange(0, elevationMax);
    OverallChange();
  }
}

void ElevationSlider() {
  if (!getDataFromJSON) {
    OverallChange();
  }
}

void RigiditySlider() {
  if (!getDataFromJSON) {
    OverallChange();  
  }
}

void WetnessSlider() {
  if (!getDataFromJSON) {
    OverallChange();  
  }
}
