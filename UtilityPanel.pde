
public class UtilityPanel extends ControlPanel {

  APEditText edit;

  APButton setIpButton;


  public UtilityPanel(String title, PApplet parent) {
    super(title, parent);
    setIpButton = new APButton(150, 110, "Set Server IP"); 
    edit = new APEditText(10, 110, 100, 40);

    widgetContainer.addWidget(setIpButton); 
    widgetContainer.addWidget(edit);
  }


  public void onClickWidget(APWidget widget) {
    if (widget == setIpButton) { //if it was SetIpButton that was clicked
      //set server ip;
      serverIP = edit.getText();
      println("server ip set to: " + serverIP);
    }

    //check to see if its an OSC sending control
    try {
      ModButton mb = (ModButton)widget;
      new SendOSCTask().execute(mb.getOscMessages());
    } 
    catch (ClassCastException e) {
    }
  }

  public  void initGui() {
  }

  public  void draw() {
  }

  public  void oscReceive(OscMessage message) {
  }
}

