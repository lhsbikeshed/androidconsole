

public class CometPanel extends ControlPanel {


  float altitude = 0;


  public CometPanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "comet-tunnel";

    ModButton m =  new ModButton(20, 50, "Fix Cables", "/system/cablePuzzle/cancelPuzzle");
    m.setValue(0);
    buttonList.add( m );
    
    ModButton m2 =  new ModButton(150, 50, "Auth Code", "/system/authsystem/codeOk");
    m2.setValue(0);
    buttonList.add(m2 );

    ModButton m4 =  new ModButton(20, 100, "Fire!", "/scene/CometScene/bastard");
    m4.setValue(1);
    buttonList.add(m4 );


    ModButton m5 =  new ModButton(20, 100, "Escape scene", "/scene/CometScene/escape");
    m5.setValue(3);
    buttonList.add(m5 );

    ModButton m3 =  new ModButton(10, 380, "JumpHere", "/game/takeMeTo");
    m3.setValue(sceneTag);
    buttonList.add( m3 );
    

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }


  }

  public void show() {
    super.show();
  }

  public  void initGui() {
  }

  public  void draw() {

    textFont(globalFont, 15);

    
    fill(255, 255, 255);

    text("Altitude : " + altitude, 10, 210);
    
  }


  public  void oscReceive(OscMessage msg) {

    


    if (msg.checkAddrPattern("/ship/state/altitude")==true) {
      altitude = msg.get(0).floatValue();
 
    } 
    
    
  }
}

