float timeInterval = 100;



Object[] distanceScenarioData;
Object[] crawlingScenarioData;
Object[] climbingScenarioData;



Clock distanceScenarioClock;
Clock crawlingScenarioClock;
Clock climbingScenarioClock;

int currentScenario = 1;

float currentDistanceScenarioTime = 0;
float currentCrawlingScenarioTime = 0;
float currentClimbingScenarioTime = 0;

int[] currentDistanceScenarioIndex = new int[]{0, 0};
int[] currentCrawlingScenarioIndex = new int[]{0, 0};
int[] currentClimbingScenarioIndex = new int[]{0, 0};


void LoadDistanceJSONData() {
  distanceScenarioData = DistanceScenarioData("distance_scenario_data.json");
  
  distanceScenarioClock = new Clock(ac, timeInterval);
  distanceScenarioClock.setTicksPerBeat(1);
  ac.out.addDependent(distanceScenarioClock);
  Bead distanceScenarioMessageListener = new Bead() {
    public void messageReceived(Bead message) {
      currentDistanceScenarioTime += timeInterval;
      scenarioSlider.setValue((currentDistanceScenarioTime <= scenarioSlider.getMax()) ? currentDistanceScenarioTime : scenarioSlider.getMax());
      
      if (((VitalsData[])distanceScenarioData[0])[currentDistanceScenarioIndex[0]+1].getTime() <= currentDistanceScenarioTime) {
        currentDistanceScenarioIndex[0]++;
        
        if (currentDistanceScenarioIndex[0] == ((VitalsData[])distanceScenarioData[0]).length - 1) {
          currentDistanceScenarioIndex[0] = 0;
        }
      }
      
      if (((DistanceData[][])distanceScenarioData[1])[currentDistanceScenarioIndex[1]+1][waypointsIndex].getTime() <= currentDistanceScenarioTime) {
        currentDistanceScenarioIndex[1]++;
        
        if (currentDistanceScenarioIndex[1] == ((DistanceData[][])distanceScenarioData[1]).length - 1) {
          currentDistanceScenarioIndex[1] = 0;
          currentDistanceScenarioIndex[0] = 0;
          currentDistanceScenarioTime = 0;
          distanceScenarioClock.pause(true);
          ScenarioPauseButton();
        }
      }
      
      OverallChange();
    }
  };
  distanceScenarioClock.addMessageListener(distanceScenarioMessageListener);
  distanceScenarioClock.pause(true);
}

void LoadCrawlingJSONData() {
  crawlingScenarioData = CrawlingScenarioData("crawling_scenario_data.json");
  
  crawlingScenarioClock = new Clock(ac, timeInterval);
  crawlingScenarioClock.setTicksPerBeat(1);
  ac.out.addDependent(crawlingScenarioClock);
  Bead crawlingScenarioMessageListener = new Bead() {
    public void messageReceived(Bead message) {
      currentCrawlingScenarioTime += timeInterval;
      scenarioSlider.setValue((currentCrawlingScenarioTime <= scenarioSlider.getMax()) ? currentCrawlingScenarioTime : scenarioSlider.getMax());
      
      if (((VitalsData[])crawlingScenarioData[0])[currentCrawlingScenarioIndex[0]+1].getTime() <= currentCrawlingScenarioTime) {
        currentCrawlingScenarioIndex[0]++;
        
        if (currentCrawlingScenarioIndex[0] == ((VitalsData[])crawlingScenarioData[0]).length - 1) {
          currentCrawlingScenarioIndex[0] = 0;
        }
      }
      
      if (((CrawlingData[])crawlingScenarioData[1])[currentCrawlingScenarioIndex[1]+1].getTime() <= currentCrawlingScenarioTime) {
        currentCrawlingScenarioIndex[1]++;
        
        if (currentCrawlingScenarioIndex[1] == ((CrawlingData[])crawlingScenarioData[1]).length - 1) {
          currentCrawlingScenarioIndex[1] = 0;
          currentCrawlingScenarioIndex[0] = 0;
          currentCrawlingScenarioTime = 0;
          crawlingScenarioClock.pause(true);
          ScenarioPauseButton();
        }
      }
      
      OverallChange();
    }
  };
  crawlingScenarioClock.addMessageListener(crawlingScenarioMessageListener);
  crawlingScenarioClock.pause(true);
}

void LoadClimbingJSONData() {
  climbingScenarioData = ClimbingScenarioData("climbing_scenario_data.json");
  
  climbingScenarioClock = new Clock(ac, timeInterval);
  climbingScenarioClock.setTicksPerBeat(1);
  ac.out.addDependent(climbingScenarioClock);
  Bead climbingScenarioMessageListener = new Bead() {
    public void messageReceived(Bead message) {
      currentClimbingScenarioTime += timeInterval;
      scenarioSlider.setValue((currentClimbingScenarioTime <= scenarioSlider.getMax()) ? currentClimbingScenarioTime : scenarioSlider.getMax());
      
      if (((VitalsData[])climbingScenarioData[0])[currentClimbingScenarioIndex[0]+1].getTime() <= currentClimbingScenarioTime) {
        currentClimbingScenarioIndex[0]++;
        
        if (currentClimbingScenarioIndex[0] == ((VitalsData[])climbingScenarioData[0]).length - 1) {
          currentClimbingScenarioIndex[0] = 0;
        }
      }
      
      if (((ClimbingData[])climbingScenarioData[1])[currentClimbingScenarioIndex[1]+1].getTime() <= currentClimbingScenarioTime) {
        currentClimbingScenarioIndex[1]++;
        
        if (currentClimbingScenarioIndex[1] == ((ClimbingData[])climbingScenarioData[1]).length - 1) {
          currentClimbingScenarioIndex[1] = 0;
          currentClimbingScenarioIndex[0] = 0;
          currentClimbingScenarioTime = 0;
          climbingScenarioClock.pause(true);
          ScenarioPauseButton();
        }
      }
      
      OverallChange();
    }
  };
  climbingScenarioClock.addMessageListener(climbingScenarioMessageListener);
  climbingScenarioClock.pause(true);
}




VitalsData[] VitalsScenarioData(JSONArray rawData) {
  VitalsData[] vitalsData = new VitalsData[rawData.size()];
  
  for (int i = 0; i < vitalsData.length; i++) {
    JSONObject vitalsRawDataObject = rawData.getJSONObject(i);
    
    vitalsData[i] = new VitalsData(vitalsRawDataObject);
  }
  
  return vitalsData;
}

Object[] DistanceScenarioData(String fileName) {
  JSONObject rawData = loadJSONObject(fileName);
  
  JSONArray vitalsRawData = rawData.getJSONArray("vitals");
  VitalsData[] vitalsData = VitalsScenarioData(vitalsRawData);
  
  JSONArray distanceRawData = rawData.getJSONArray("distance");
  DistanceData[][] distanceData = new DistanceData[distanceRawData.size()][5];
  for (int i = 0; i < distanceData.length; i++) {
    JSONArray distanceRawDataObject = distanceRawData.getJSONArray(i);
    for (int j = 0; j < distanceRawDataObject.size(); j++) {
      JSONObject waypointRawDataObject = distanceRawDataObject.getJSONObject(j);
      
      distanceData[i][j] = new DistanceData(waypointRawDataObject);
    }
  }
  
  return new Object[]{vitalsData, distanceData};
}

Object[] CrawlingScenarioData(String fileName) {
  JSONObject rawData = loadJSONObject(fileName);
  
  JSONArray vitalsRawData = rawData.getJSONArray("vitals");
  VitalsData[] vitalsData = VitalsScenarioData(vitalsRawData);
  
  JSONArray crawlingRawData = rawData.getJSONArray("crawling");
  CrawlingData[] crawlingData = new CrawlingData[crawlingRawData.size()];
  for (int i = 0; i < crawlingData.length; i++) {
    JSONObject crawlingRawDataObject = crawlingRawData.getJSONObject(i);
      
    crawlingData[i] = new CrawlingData(crawlingRawDataObject);
  }
  
  return new Object[]{vitalsData, crawlingData};
}

Object[] ClimbingScenarioData(String fileName) {
  JSONObject rawData = loadJSONObject(fileName);
  
  JSONArray vitalsRawData = rawData.getJSONArray("vitals");
  VitalsData[] vitalsData = VitalsScenarioData(vitalsRawData);
  
  JSONArray climbingRawData = rawData.getJSONArray("climbing");
  ClimbingData[] climbingData = new ClimbingData[climbingRawData.size()];
  for (int i = 0; i < climbingData.length; i++) {
    JSONObject climbingRawDataObject = climbingRawData.getJSONObject(i);
      
    climbingData[i] = new ClimbingData(climbingRawDataObject);
  }
  
  return new Object[]{vitalsData, climbingData};
}




float interpolate(float currTime, float leftTime, float rightTime, float leftVal, float rightVal) 
{
  return leftVal + (currTime - leftTime) * (rightVal - leftVal) / (rightTime - leftTime);
}





class VitalsData {
  
  float time;
  
  float heartRate;
  float rateWater;
  float bodyTemp;
  
  public VitalsData(JSONObject rawData) {
    this.time = rawData.getFloat("time");
    
    this.heartRate = rawData.getFloat("heartRate");
    this.rateWater = rawData.getFloat("rateWater");
    this.bodyTemp = rawData.getFloat("bodyTemp");
  }
  
  public float getTime() {
    return time;  
  }
  
  public float getHeartRate() {
    return heartRate;
  }
  
  public float getRateWater() {
    return rateWater;  
  }
  
  public float getBodyTemp() {
    return bodyTemp;  
  }
  
}

class DistanceData {
  
  float time;
  
  float magnitude;
  float eulerX;
  float eulerY;
  float eulerZ;
  
  public DistanceData(JSONObject rawData) {
    this.time = rawData.getFloat("time");
    
    this.magnitude = rawData.getFloat("magnitude");
    this.eulerX = rawData.getFloat("euler_x");
    this.eulerY = rawData.getFloat("euler_y");
    this.eulerZ = rawData.getFloat("euler_z");
  }
  
  public float getTime() {
    return time;  
  }
  
  public float getMagnitude() {
    return magnitude; 
  }
  
  public float getEulerX() {
    return eulerX;  
  }
  
  public float getEulerY() {
    return eulerY;  
  }
  
  public float getEulerZ() {
    return eulerZ;  
  }
  
}

class CrawlingData {
  
  float time;
  
  float squeezeSpace;
  float pressure;
  float narrowness;
  
  public CrawlingData(JSONObject rawData) {
    this.time = rawData.getFloat("time");
    
    this.squeezeSpace = rawData.getFloat("space");
    this.pressure = rawData.getFloat("pressure");
    this.narrowness = rawData.getFloat("narrow");
  }
  
  public float getTime() {
    return time;  
  }
  
  public float getSqueezeSpace() {
    return squeezeSpace;
  }
  
  public float getPressure() {
    return pressure;  
  }
  
  public float getNarrowness() {
    return narrowness;  
  }
  
}

class ClimbingData {
  
  float time;
  
  int contactPoints;
  float elevationMax;
  float elevation;
  float rigidity;
  float wetness;
  
  public ClimbingData(JSONObject rawData) {
    this.time = rawData.getFloat("time");
    
    this.contactPoints = rawData.getInt("points");
    this.elevationMax = rawData.getFloat("elevationMax");
    this.elevation = rawData.getFloat("elevation");
    this.rigidity = rawData.getFloat("rigidity");
    this.wetness = rawData.getFloat("wetness");
  }
  
  public float getTime() {
    return time;  
  }
  
  public int getContactPoints() {
    return contactPoints;  
  }
  
  public float getElevationMax() {
    return elevationMax;  
  }
  
  public float getElevation() {
    return elevation;  
  }
  
  public float getRigidity() {
    return rigidity;  
  }
  
  public float getWetness() {
    return wetness;  
  }
  
}






Button distanceScenarioButton;
Button crawlingScenarioButton;
Button climbingScenarioButton;
Slider scenarioSlider;
Button scenarioPauseButton;
Button scenarioReplayButton;

//PImage playIcon;
//PImage pauseIcon;
//PImage replayIcon;

void ScenarioUI(float x, float y) {
  //playIcon = loadImage("play_icon.png");
  //playIcon.resize(20, 20);
  //pauseIcon = loadImage("pause_icon.png");
  //pauseIcon.resize(20, 20);
  //replayIcon = loadImage("replay_icon.png");
  //replayIcon.resize(15, 15);
  
  p5.addTextlabel("JSONSectionText")
    .setPosition(x + width / 8 + 10, y - 25)
    .setText("JSON DATA CONTROLS:");
  
  distanceScenarioButton = p5.addButton("DistanceScenarioButton")
                             .setPosition(x, y)
                             .setSize(100, 30)
                             .activateBy((ControlP5.RELEASE))
                             .setLabel("Distance Scenario");
                             
  crawlingScenarioButton = p5.addButton("CrawlingScenarioButton")
                             .setPosition(x + (width / 4) / 3 * 1 + 50, y)
                             .setSize(100, 30)
                             .activateBy((ControlP5.RELEASE))
                             .setLabel("Crawling Scenario");
                             
  climbingScenarioButton = p5.addButton("ClimbingScenarioButton")
                             .setPosition(x + (width / 4) / 3 * 2 + 100, y)
                             .setSize(100, 30)
                             .activateBy((ControlP5.RELEASE))
                             .setLabel("Climbing Scenario");
                             
                             
  scenarioPauseButton = p5.addButton("ScenarioPauseButton")
                             .setPosition(x - 35, y + 50)
                             .setSize(50, 25)
                             .activateBy((ControlP5.RELEASE))
                             //.setSwitch(true)
                             //.setImage(playIcon, Controller.OVER);
                             .setLabel("Play");
                             
  scenarioReplayButton = p5.addButton("ScenarioReplayButton")
                             .setPosition(x + 35 - 15, y + 50)
                             .setSize(50, 25)
                             .activateBy((ControlP5.RELEASE))
                             //.setImage(replayIcon);
                             .setLabel("Replay");
                             
  scenarioSlider = p5.addSlider("ScenarioSlider")
                            .setPosition(x + 75, y + 55)
                            .setSize(325, 15)
                            .setRange(0, 1)
                            .setLock(true)
                            .setLabel("");
                            
  DistanceScenarioButton();
}

void ScenarioPauseButton() {
  if (getDataFromJSON) {
    getDataFromJSON = false;
    scenarioPauseButton.setLabel("Play");
    
    distanceScenarioClock.pause(true);
    crawlingScenarioClock.pause(true);
    climbingScenarioClock.pause(true);
  }
  else {
    getDataFromJSON = true;
    scenarioPauseButton.setLabel("Pause");
    
    switch (currentScenario) {
      case 1:
        distanceScenarioClock.pause(false);
        crawlingScenarioClock.pause(true);
        climbingScenarioClock.pause(true);
        DistanceButton();
        break;
      case 2:
        distanceScenarioClock.pause(true);
        crawlingScenarioClock.pause(false);
        climbingScenarioClock.pause(true);
        CrawlingButton();
        break;
      case 3:
        distanceScenarioClock.pause(true);
        crawlingScenarioClock.pause(true);
        climbingScenarioClock.pause(false);
        ClimbingButton();
        break;
    }
  }
}

void ScenarioReplayButton() {
  switch (currentScenario) {
    case 1:
      currentDistanceScenarioIndex[0] = 0;
      currentDistanceScenarioIndex[1] = 0;
      currentDistanceScenarioTime = 0;
      distanceScenarioClock.reset();
      if (scenarioSlider.getValue() != scenarioSlider.getMax()) {
        getDataFromJSON = !getDataFromJSON;
      }
      scenarioSlider.setValue(currentDistanceScenarioTime);
      ScenarioPauseButton();
      break;
    case 2:
      currentCrawlingScenarioIndex[0] = 0;
      currentCrawlingScenarioIndex[1] = 0;
      currentCrawlingScenarioTime = 0;
      crawlingScenarioClock.reset();
      if (scenarioSlider.getValue() != scenarioSlider.getMax()) {
        getDataFromJSON = !getDataFromJSON;
      }
      scenarioSlider.setValue(currentDistanceScenarioTime);
      ScenarioPauseButton();
      break;
    case 3:
      currentClimbingScenarioIndex[0] = 0;
      currentClimbingScenarioIndex[1] = 0;
      currentClimbingScenarioTime = 0;
      climbingScenarioClock.reset();
      if (scenarioSlider.getValue() != scenarioSlider.getMax()) {
        getDataFromJSON = !getDataFromJSON;
      }
      scenarioSlider.setValue(currentDistanceScenarioTime);
      ScenarioPauseButton();
      break;
  }
  
  OverallChange();
}

void DistanceScenarioButton() {
  currentScenario = 1;
  
  if (getDataFromJSON) {
    distanceScenarioClock.pause(false);
    crawlingScenarioClock.pause(true);
    climbingScenarioClock.pause(true);
    
    DistanceButton();
    
    OverallChange();
  }
  
  DistanceData[][] tempDistanceData = ((DistanceData[][])distanceScenarioData[1]);
  scenarioSlider.setRange(0, tempDistanceData[tempDistanceData.length - 1][0].getTime());
  scenarioSlider.setValue(currentDistanceScenarioTime);
}

void CrawlingScenarioButton() {
  currentScenario = 2;
  
  if (getDataFromJSON) {
    distanceScenarioClock.pause(true);
    crawlingScenarioClock.pause(false);
    climbingScenarioClock.pause(true);
    
    CrawlingButton();
    
    OverallChange();
  }
  
  CrawlingData[] tempCrawlingData = ((CrawlingData[])crawlingScenarioData[1]);
  scenarioSlider.setRange(0, tempCrawlingData[tempCrawlingData.length - 1].getTime());
  scenarioSlider.setValue(currentCrawlingScenarioTime);
}

void ClimbingScenarioButton() {
  currentScenario = 3;
  
  if (getDataFromJSON) {
    distanceScenarioClock.pause(true);
    crawlingScenarioClock.pause(true);
    climbingScenarioClock.pause(false);
    
    ClimbingButton();
    
    OverallChange();
  }
  
  ClimbingData[] tempClimbingData = ((ClimbingData[])climbingScenarioData[1]);
  scenarioSlider.setRange(0, tempClimbingData[tempClimbingData.length - 1].getTime());
  scenarioSlider.setValue(currentClimbingScenarioTime);
}
