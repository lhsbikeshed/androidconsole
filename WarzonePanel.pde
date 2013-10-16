

public class WarzonePanel extends ControlPanel {


  String[] beamExcuses = { 
    "Beamed aboard, waiting for airlock..", "Beam blocked", "You broke in, prepare to shoot", "you were dumped out of airlock"
  };
  int currentExcuse = -1;

  long beamFailTime = 0;

  int missileDifficulty = 1;
  APButton diffUp, diffDown;

  public WarzonePanel(String title, PApplet parent) {
    super(title, parent);


    buttonList.add( new ModButton(20, 50, "Start War", "/scene/warzone/warzonestart") );
    buttonList.add( new ModButton(110, 50, "Beam Attempt", "/system/transporter/startBeamAttempt") );
    buttonList.add( new ModButton(20, 100, "Spawn Gate", "/scene/warzone/spawnGate") );
    buttonList.add( new ModButton(120, 100, "Shoot at ship", "/scene/warzone/createBastard") );

    buttonList.add( new ModToggle(20, 150, "Missiles?", "/scene/warzone/missileLauncherStatus", false) );

    /*
    buttonList.add( new ModToggle(80, 100, "Missiles?", "/scene/launchland/trainingMissiles", false) );
     
     buttonList.add( new ModButton(20, 250, "Launch NPC", "/scene/launchland/launchOtherShip") );
     buttonList.add( new ModButton(120, 250, "NPC to gate", "/scene/launchland/otherShipToGate") );
     buttonList.add( new ModButton(20, 300, "NPC hyper", "/scene/launchland/otherShipHyperspace") );*/

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    diffUp = new APButton(180, 200, 40, 40, "+");
    diffDown = new APButton(20, 200, 40, 40, "-");
    widgetContainer.addWidget(diffUp);
    widgetContainer.addWidget(diffDown);


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
    text("Diffuculty: " + missileDifficulty, 60, 220);

    text("Beam status:", 10, 250 );
    if (currentExcuse!=-1) {
      fill(255, 255, 255);


      if (currentExcuse == 2) {
        int ran = (int)random(255);
        fill(ran,0,0);
        text("SHOOT THE PLAYERS: " + (5 - (millis() - beamFailTime) / 1000), 10, 280);
        fill(255,255,255);
      } 
      else {
        text(beamExcuses[currentExcuse], 10, 280);
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
  }


  public  void oscReceive(OscMessage message) {


    //loop through togglelist to see if the osc message appears there, if it does set the controls state
    for (APWidget w : buttonList) {
      try {
        ModToggle b = (ModToggle)w;
        if (b.getOscString().equals(message.addrPattern())) {
          int val = message.get(0).intValue();
          if (val == 0) {
            b.setChecked(false & !b.isInverted());
          } 
          else {
            b.setChecked(true & !b.isInverted());
          }
        }
      } 
      catch (ClassCastException e) {
      }
    }

    if (message.checkAddrPattern("/system/transporter/beamAttemptResult")) {
      int p = message.get(0).intValue();
      currentExcuse = p;
      if (p == 2) {
        beamFailTime = millis();
      }
    }
  }
}

