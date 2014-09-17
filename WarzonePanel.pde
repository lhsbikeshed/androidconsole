

public class WarzonePanel extends ControlPanel {


  String[] beamExcuses = { 
    "Beamed aboard, waiting for airlock..", "Beam blocked", "You broke in, prepare to shoot", "you were dumped out of airlock"
  };
  int currentExcuse = -1;

  long beamFailTime = 0;

  int missileDifficulty = 1;
  int beamDifficulty = 1;
  APButton diffUp, diffDown;
  APButton beamUp, beamDown;
  APButton beamButton;

  public WarzonePanel(String title, PApplet parent) {
    super(title, parent);


    buttonList.add( new ModButton(20, 50, "Start War", "/scene/warzone/warzonestart") );
    //buttonList.add( new ModButton(110, 50, "Beam Attempt", "/system/transporter/startBeamAttempt") );
    buttonList.add( new ModButton(20, 100, "Spawn Gate", "/scene/warzone/spawnGate") );
    buttonList.add( new ModButton(120, 100, "Shoot at ship", "/scene/warzone/createBastard") );

    buttonList.add( new ModToggle(20, 150, "Missiles?", "/scene/warzone/missileLauncherStatus", false) );
    buttonList.add( new ModButton(120, 150, "missile", "/scene/warzone/spawnMissile") );

    ModButton m3 =  new ModButton(10, 380, "JumpHere", "/game/takeMeTo");
    m3.setValue(3);
    buttonList.add( m3 );

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    diffUp = new APButton(120, 200, 40, 40, "+");
    diffDown = new APButton(20, 200, 40, 40, "-");
    widgetContainer.addWidget(diffUp);
    widgetContainer.addWidget(diffDown);

    beamUp = new APButton(180, 300, 40, 40, "+");
    beamDown = new APButton(20, 300, 40, 40, "-");
    widgetContainer.addWidget(beamUp);
    widgetContainer.addWidget(beamDown);

    beamButton = new APButton(110, 340, "Beam Attempt");
    widgetContainer.addWidget(beamButton);

    //map this tab to a scene number from the game
    setSceneNumber(3);
  }

  public void show() {
    super.show();
    currentExcuse = -1;
  }


  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 13);
    long t = countdownDuration - (millis() - countdownStartTime) ;

    long min = (t / 1000 / 60);
    String minString = "" + min;
    if (min <= 0) {
      minString = "00";
    } 
    else if (min < 10) {
      minString = "0" + min;
    }

    long sec = (t / 1000) % 60;
    String secString = "" + sec;
    if (sec <= 0) {
      secString = "00";
    } 
    else if (sec < 10) {
      secString = "0" + secString;
    }
    text("evac: " + minString + ":" + secString, 120, 180);

      text("Missile\r\nDiff: " + missileDifficulty, 60, 216);
    text("count: " + missilesInPlay, 170, 216);

    textFont(globalFont, 13);
    text("Beam\r\nDifficulty: " + beamDifficulty, 60, 320);


    text("Beam status:", 10, 260 );
    if (currentExcuse!=-1) {
      fill(255, 255, 255);


      if (currentExcuse == 2) {
        int ran = (int)random(255);
        fill(ran, 0, 0);
        text("SHOOT THE PLAYERS: " + (5 - (millis() - beamFailTime) / 1000), 10, 290);
        fill(255, 255, 255);
      } 
      else {
        text(beamExcuses[currentExcuse], 10, 290);
      }
    }
  }

  public void onWidget(APWidget widget) {
    super.onWidget(widget);
    if (widget == diffUp) {
      missileDifficulty += 1;
      if (missileDifficulty >= 10) {
        missileDifficulty = 10;
      }
      OscMessage m = new OscMessage("/scene/warzone/missileRate");
      m.add(missileDifficulty);
      new SendOSCTask().execute(m);
    } 
    else if (widget == diffDown) {
      missileDifficulty -= 1;
      if (missileDifficulty < 1) {
        missileDifficulty = 1;
      }
      OscMessage m = new OscMessage("/scene/warzone/missileRate");
      m.add(missileDifficulty);
      new SendOSCTask().execute(m);
    } 
    else if (widget == beamDown) {
      beamDifficulty -= 1;
      if (beamDifficulty < 1) {
        beamDifficulty = 1;
      }
    } 
    else if (widget == beamUp) {
      beamDifficulty += 1;
      if (beamDifficulty > 10) {
        beamDifficulty = 10;
      }
    }
    else if (widget == beamButton) {
      OscMessage m = new OscMessage("/system/transporter/startBeamAttempt");
      m.add(beamDifficulty);
      new SendOSCTask().execute(m);
    }
  }

  public  void oscReceive(OscMessage message) {



    if (message.checkAddrPattern("/system/transporter/beamAttemptResult")) {
      int p = message.get(0).intValue();
      currentExcuse = p;
      if (p == 2) {
        beamFailTime = millis();
      }
    }
  }
}

