float[] frequencyRangeDistance = new float[]{100, 500};
float[] harmonicMultiplesDistance = new float[]{2, 3, 4};



WavePlayer distanceWave;
Glide distanceFrequencyGlide;

WavePlayer eulerXWave;
WavePlayer eulerYWave;
WavePlayer eulerZWave;
Glide eulerXWaveFrequencyGlide;
Glide eulerYWaveFrequencyGlide;
Glide eulerZWaveFrequencyGlide;
Gain eulerXWaveGain;
Gain eulerYWaveGain;
Gain eulerZWaveGain;
Glide eulerXWaveGainGlide;
Glide eulerYWaveGainGlide;
Glide eulerZWaveGainGlide;




void DistanceWiring() {
  distanceFrequencyGlide = new Glide(ac, 440, 500);
  distanceWave = new WavePlayer(ac, distanceFrequencyGlide, Buffer.SINE);
  Glide distanceWaveGainGlide = new Glide(ac, 1.0, 500);
  Gain distanceWaveGain = new Gain(ac, 1, distanceWaveGainGlide);
  distanceWaveGain.addInput(distanceWave);
  
  eulerXWaveFrequencyGlide = new Glide(ac, 880, 500);
  eulerXWave = new WavePlayer(ac, eulerXWaveFrequencyGlide, Buffer.SINE);
  eulerXWaveGainGlide = new Glide(ac, 1.0, 500);
  eulerXWaveGain = new Gain(ac, 1, eulerXWaveGainGlide);
  eulerXWaveGain.addInput(eulerXWave);
  
  eulerYWaveFrequencyGlide = new Glide(ac, 440 * 3, 500);
  eulerYWave = new WavePlayer(ac, eulerYWaveFrequencyGlide, Buffer.SINE);
  eulerYWaveGainGlide = new Glide(ac, 1.0, 500);
  eulerYWaveGain = new Gain(ac, 1, eulerYWaveGainGlide);
  eulerYWaveGain.addInput(eulerYWave);
  
  eulerZWaveFrequencyGlide = new Glide(ac, 440 * 4, 500);
  eulerZWave = new WavePlayer(ac, eulerZWaveFrequencyGlide, Buffer.SINE);
  eulerZWaveGainGlide = new Glide(ac, 1.0, 500);
  eulerZWaveGain = new Gain(ac, 1, eulerZWaveGainGlide);
  eulerZWaveGain.addInput(eulerZWave);
  
  distanceGain.addInput(distanceWaveGain);
  distanceGain.addInput(eulerXWaveGain);
  distanceGain.addInput(eulerYWaveGain);
  distanceGain.addInput(eulerZWaveGain);
}

void DistanceChange() {
  float[] distanceData = getDataFromJSON ? DistanceDataFromJSON() : DistanceDataFromUI();
  
  float distance = distanceData[0] / 1600;
  float eulerX = distanceData[1] / 360;
  float eulerY = distanceData[2] / 360;
  float eulerZ = distanceData[3] / 360;
  
  float fundamentalFrequency = frequencyRangeDistance[0] + distance * (frequencyRangeDistance[1] - frequencyRangeDistance[0]);
  
  distanceFrequencyGlide.setValue(fundamentalFrequency);
  eulerXWaveFrequencyGlide.setValue(fundamentalFrequency * harmonicMultiplesDistance[0]);
  eulerYWaveFrequencyGlide.setValue(fundamentalFrequency * harmonicMultiplesDistance[1]);
  eulerZWaveFrequencyGlide.setValue(fundamentalFrequency * harmonicMultiplesDistance[2]);
  
  eulerXWaveGainGlide.setValue(eulerX);
  eulerYWaveGainGlide.setValue(eulerY);
  eulerZWaveGainGlide.setValue(eulerZ);
}

float[][] waypoints = new float[5][4];
int waypointsIndex = 0;

float[] DistanceDataFromJSON() {
  float[] distanceData = new float[4];
  
  DistanceData[][] allData = (DistanceData[][])distanceScenarioData[1];
  int index = currentDistanceScenarioIndex[1];
  DistanceData leftData = allData[index % allData.length][waypointsIndex];
  DistanceData rightData = allData[(index + 1) % allData.length][waypointsIndex];
  
  float time = currentDistanceScenarioTime;
  waypoints[waypointsIndex][0] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getMagnitude(), rightData.getMagnitude());
  waypoints[waypointsIndex][1] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getEulerX(), rightData.getEulerX()) % 360;
  waypoints[waypointsIndex][2] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getEulerY(), rightData.getEulerY()) % 360;
  waypoints[waypointsIndex][3] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getEulerZ(), rightData.getEulerZ()) % 360;
  
  distanceData[0] = waypoints[waypointsIndex][0];
  distanceData[1] = waypoints[waypointsIndex][1];
  distanceData[2] = waypoints[waypointsIndex][2];
  distanceData[3] = waypoints[waypointsIndex][3];
  
  distanceSlider.setValue(distanceData[0]);
  eulerXSlider.setValue(distanceData[1]);
  eulerYSlider.setValue(distanceData[2]);
  eulerZSlider.setValue(distanceData[3]);
  
  return distanceData;
}

float[] DistanceDataFromUI() {
  float[] distanceData = new float[4];
  
  distanceData[0] = waypoints[waypointsIndex][0];
  distanceData[1] = waypoints[waypointsIndex][1];
  distanceData[2] = waypoints[waypointsIndex][2];
  distanceData[3] = waypoints[waypointsIndex][3];
  
  return distanceData;
}




ButtonBar waypointButtonBar;
Slider distanceSlider;
Slider eulerXSlider;
Slider eulerYSlider;
Slider eulerZSlider;

void DistanceUI(float x, float y) {
  distanceSlider = p5.addSlider("DistanceSlider")
                    .setPosition(x, y)
                    .setSize(150, 15)
                    .setRange(0, 1600)
                    .setValue(500)
                    .setLabel("Distance");
                    
  eulerXSlider = p5.addSlider("EulerXSlider")
                    .setPosition(x, y + 25 * 1)
                    .setSize(150, 15)
                    .setRange(0, 360)
                    .setValue(30)
                    .setLabel("Euler Angle (X)");
                    
  eulerYSlider = p5.addSlider("EulerYSlider")
                    .setPosition(x, y + 25 * 2)
                    .setSize(150, 15)
                    .setRange(0, 360)
                    .setValue(30)
                    .setLabel("Euler Angle (Y)");
                    
  eulerZSlider = p5.addSlider("EulerZSlider")
                    .setPosition(x, y + 25 * 3)
                    .setSize(150, 15)
                    .setRange(0, 360)
                    .setValue(30)
                    .setLabel("Euler Angle (Z)");
                    
  for (float[] waypoint : waypoints) {
    waypoint[0] = distanceSlider.getValue();
    waypoint[1] = eulerXSlider.getValue();
    waypoint[2] = eulerYSlider.getValue();
    waypoint[3] = eulerZSlider.getValue();
  }
  waypointButtonBar = p5.addButtonBar("WaypointButtonBar")
                        .setPosition(x, y + 25 * 4)
                        .setSize(150, 15)
                        .addItem("1", 0)
                        .addItem("2", 1)
                        .addItem("3", 2)
                        .addItem("4", 3)
                        .addItem("5", 4)
                        .setValue(0);
                        
  p5.addTextlabel("WaypointsLabel")
    .setPosition(x + 150, y + 25 * 4 + 2)
    .setText("WAYPOINT");
}

void DistanceSlider(float value) {
  if (!getDataFromJSON) {
    waypoints[waypointsIndex][0] = value;
    OverallChange();
  }
}

void EulerXSlider(float value) {
  if (!getDataFromJSON) {
    waypoints[waypointsIndex][1] = value;
    OverallChange();
  }
}

void EulerYSlider(float value) {
  if (!getDataFromJSON) {
    waypoints[waypointsIndex][2] = value;
    OverallChange();
  }
}

void EulerZSlider(float value) {
  if (!getDataFromJSON) {
    waypoints[waypointsIndex][3] = value;
    OverallChange();
  }
}

void WaypointButtonBar(int value) {
  waypointsIndex = value;

  distanceSlider.setValue(waypoints[waypointsIndex][0]);
  eulerXSlider.setValue(waypoints[waypointsIndex][1]);
  eulerYSlider.setValue(waypoints[waypointsIndex][2]);
  eulerZSlider.setValue(waypoints[waypointsIndex][3]);
  
  OverallChange();
}
