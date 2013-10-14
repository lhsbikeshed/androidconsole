

public class HyperPanel extends ControlPanel {
  int secondsUntilExit = 0;
  long exitTime = 0;
  boolean exiting = false;
  boolean failedExit = false;

  public HyperPanel(String title, PApplet parent) {
    super(title, parent);

    setSceneNumber(1);
  }

  public void show() {
    super.show();
    secondsUntilExit = 0;
    exitTime = 0;
    exiting = false;
    failedExit = false;
  }

  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 15);
    if (exiting) {

      text("State : Exiting!", 10, 130);
      text("exiting in: " + (secondsUntilExit*1000 - (millis() - exitTime)), 10, 145);
      if (failedExit) {
        text("FAILED JUMP - WARN PLAYERS OF ROUGH RIDE AND DAMAGE", 10, 1260);
      }
    } 
    else {
      text("State : In Jump", 10, 130);
    }
  }

  public  void oscReceive(OscMessage msg) {

    if (msg.checkAddrPattern("/scene/warp/failjump")) {
      exiting = true;
      failedExit = true;
      secondsUntilExit = msg.get(0).intValue();
      exitTime = millis();
    } 
    else if (msg.checkAddrPattern("/warpscene/exitjump")) {
      exiting = true;
      failedExit = false;
      exitTime = millis();
      secondsUntilExit = msg.get(0).intValue();
    }
  }
}

