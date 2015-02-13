

public class LaunchPanel extends ControlPanel {


  public LaunchPanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "launch";
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);
    
    //------------launch-----------
    buttonList.add( new ModButton(20, 50, "Launch", "/scene/launchland/startLaunch") );   
    buttonList.add( new ModButton(90, 50, "Launch\r\n NPC", "/scene/launchland/launchOtherShip") );
    buttonList.add( new ModButton(160, 50, "clamp\r\nrelease", "/scene/launchland/releaseClamp") );
    
    buttonList.add( new ModToggle(20, 110, "Missiles\r\nOn", "Missiles\r\nOff", "/scene/launchland/trainingMissiles", false) );


    //----------landing---------
    buttonList.add( new ModToggle(20, 200, "Docking\r\nComp\r\non", "Docking\r\nComp\r\noff", "/scene/launchland/dockingCompState", false) );
    buttonList.add( new ModButton(90, 200, "WIN THE GAME", "/game/gameWin") );

    //------common------
    buttonList.add( new ModToggle(20, 300, "Bay Doors\r\nOpen", "Bay Doors\r\nClosed", "/scene/launchland/dockingBay", false) );
    buttonList.add( new ModToggle(110, 300, "Grav\r\nOn", "Grav\r\nOff", "/scene/launchland/bayGravity", true) );

    ModButton m3 =  new ModButton(10, 380, "JumpHere", "/game/takeMeTo");
    m3.setValue(sceneTag);
    buttonList.add( m3 );
    
    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

  
  }



  public  void initGui() {
  }

  public  void draw() {
    text("LAUNCH", 20,20);
    text("LANDING", 20,190);
    text("COMMON", 20,290);

  }


  public  void oscReceive(OscMessage message) {
  }
}

