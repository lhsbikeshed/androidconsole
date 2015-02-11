

public class DropPanel extends ControlPanel {


  float altitude = 0;
  float[] temps = new float[6];
  String[] tempNames = {
    "Top Temp", "Bottom Temp", "Left Temp", "Right Temp", "Front Temp", "Back Temp"
  };

  boolean panelRepaired = false;
  boolean codeOk = false;


  public DropPanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "drop";

    ModButton m =  new ModButton(20, 50, "Repair Panel", "/scene/drop/droppanelrepaired");
    m.setValue(1);
    buttonList.add( m );
    ModButton m2 =  new ModButton(150, 50, "Auth Code", "/scene/drop/droppanelrepaired");
    m2.setValue(2);
    buttonList.add(m2 );


    ModButton m3 =  new ModButton(10, 380, "JumpHere", "/game/takeMeTo");
    m3.setValue(sceneTag);
    buttonList.add( m3 );
    

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }


  }

  public void show() {
    super.show();
    panelRepaired = false;
    codeOk = false;
  }

  public  void initGui() {
  }

  public  void draw() {

    textFont(globalFont, 15);

    for (int i = 0; i < 6; i++) {
      if (temps[i] < 200) {
        fill(0, 255, 0);
      } 
      else if (temps[i] >=200 && temps[i] <= 250) {
        fill(255, 255, 0);
      } 
      else {
        fill(255, 0, 0);
      }
      text(tempNames[i] + " : " + (int)temps[i], 10, 230 + i * 15);
    }

    fill(255, 255, 255);

    text("Altitude : " + altitude, 10, 210);
    if (panelRepaired) {
      text("Broken panel repaired, waiting for code", 10, 110);
    } 
    else {
      text("Waiting for panel repair", 10, 110);
    }
    if (codeOk) {
      text("CODE OK! Jump enabled", 10, 130);
    } 
    else {
      text("Waiting for code....", 10, 130);
    }
  }


  public  void oscReceive(OscMessage msg) {

    //loop through togglelist to see if the osc message appears there, if it does set the controls state
    for (APWidget w : buttonList) {
      try {
        ModToggle b = (ModToggle)w;
        if (b.getOscString().equals(msg.addrPattern())) {
          int val = msg.get(0).intValue();
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


    if (msg.checkAddrPattern("/scene/drop/statupdate")==true) {
      altitude = msg.get(0).floatValue();
      for (int t = 0; t < 6; t++) {
        temps[t] = msg.get(1+t).floatValue();
      }
    } 
    else if (msg.checkAddrPattern("/scene/drop/droppanelrepaired")==true) {
      int dat = msg.get(0).intValue();
      if (dat == 1) {
        panelRepaired = true;
      } 
      else if (dat == 2) {
        codeOk = true;
      }
    }
  }
}

