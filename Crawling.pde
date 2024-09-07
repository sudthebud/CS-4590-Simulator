float[] frequencyRangeCrawling = new float[]{100, 500};
int pressureWaveCount = 9;




WavePlayer narrownessWave;
Glide narrownessFrequencyGlide;

WavePlayer pressureWaves[] = new WavePlayer[pressureWaveCount];
Glide pressureFrequencyGlide[] = new Glide[pressureWaveCount];
Gain pressureGain[] = new Gain[pressureWaveCount];
Glide pressureGainGlide[] = new Glide[pressureWaveCount];

Reverb squeezeReverb;




void CrawlingWiring() {
  squeezeReverb = new Reverb(ac);
  squeezeReverb.setDamping(0);
  squeezeReverb.setSize(0);
  squeezeReverb.setLateReverbLevel(0);
  
  narrownessFrequencyGlide = new Glide(ac, 1000, 500);
  narrownessWave = new WavePlayer(ac, narrownessFrequencyGlide, Buffer.SINE);
  squeezeReverb.addInput(narrownessWave);
  
  for (int i = 0; i < pressureWaveCount; i++) {
    pressureFrequencyGlide[i] = new Glide(ac, 1000 * (i+2), 500);
    pressureWaves[i] = new WavePlayer(ac, pressureFrequencyGlide[i], Buffer.SINE);
    
    pressureGainGlide[i] = new Glide(ac, (i % 2 == 1) ? (1.0/(i+1)) : 0, 500);
    pressureGain[i] = new Gain(ac, 1, pressureGainGlide[i]);
    pressureGain[i].addInput(pressureWaves[i]);
    
    squeezeReverb.addInput(pressureGain[i]);
  }
  
  crawlingGain.addInput(squeezeReverb);
}

void CrawlingChange() {
  float[] crawlingData = getDataFromJSON ? CrawlingDataFromJSON() : CrawlingDataFromUI();
  
  float narrowness = crawlingData[0];
  float pressure = crawlingData[1] / 300;
  float squeeze = crawlingData[2] / 10;
  
  float fundamentalFrequency = frequencyRangeCrawling[0] + narrowness * (frequencyRangeCrawling[1] - frequencyRangeCrawling[0]);
  
  narrownessFrequencyGlide.setValue(fundamentalFrequency);
  
  for (int i = 0; i < pressureWaveCount; i++) {
    pressureFrequencyGlide[i].setValue(fundamentalFrequency * (i+2));
    
    pressureGainGlide[i].setValue((i % 2 == 0) ? (1.0/(i+1) + float(i)/(i+1) * pressure) : 0);
  }
  
  squeezeReverb.setDamping(squeeze);
  squeezeReverb.setSize((squeeze > 0) ? 0.2 : 0);
  squeezeReverb.setLateReverbLevel((squeeze > 0) ? 1 : 0);
}

float[] CrawlingDataFromJSON() {
  float[] crawlingData = new float[3];
  
  CrawlingData[] allData = (CrawlingData[])crawlingScenarioData[1];
  int index = currentCrawlingScenarioIndex[1];
  CrawlingData leftData = allData[index % allData.length];
  CrawlingData rightData = allData[(index + 1) % allData.length];
  
  float time = currentCrawlingScenarioTime;
  crawlingData[0] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getNarrowness(), rightData.getNarrowness());
  crawlingData[1] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getPressure(), rightData.getPressure());
  crawlingData[2] = interpolate(time, leftData.getTime(), rightData.getTime(), leftData.getSqueezeSpace(), rightData.getSqueezeSpace());
  
  narrownessSlider.setValue(crawlingData[0]);
  pressureSlider.setValue(crawlingData[1]);
  squeezeSlider.setValue(crawlingData[2]);
  
  return crawlingData;
}

float[] CrawlingDataFromUI() {
  float[] crawlingData = new float[3];
  
  crawlingData[0] = narrownessSlider.getValue();
  crawlingData[1] = pressureSlider.getValue();
  crawlingData[2] = squeezeSlider.getValue();
  
  return crawlingData;
}




Slider squeezeSlider;
Slider pressureSlider;
Slider narrownessSlider;

void CrawlingUI(float x, float y) {
  squeezeSlider = p5.addSlider("SqueezeSlider")
                    .setPosition(x, y)
                    .setSize(150, 15)
                    .setRange(0, 10)
                    .setValue(0)
                    .setLabel("Squeeze Space");
                    
  pressureSlider = p5.addSlider("PressureSlider")
                    .setPosition(x, y + 25 * 1)
                    .setSize(150, 15)
                    .setRange(0, 300)
                    .setValue(300)
                    .setLabel("Highest Pressure Level");
                    
  narrownessSlider = p5.addSlider("NarrownessSlider")
                    .setPosition(x, y + 25 * 2)
                    .setSize(150, 15)
                    .setRange(0, 1)
                    .setValue(1000 / (frequencyRangeCrawling[1] - frequencyRangeCrawling[0]))
                    .setLabel("Narrowness");
}

void SqueezeSlider() {
  if (!getDataFromJSON) {
    OverallChange();  
  }
}

void PressureSlider() {
  if (!getDataFromJSON) {
    OverallChange();  
  }
}

void NarrownessSlider() {
  if (!getDataFromJSON) {
    OverallChange();  
  }
}
