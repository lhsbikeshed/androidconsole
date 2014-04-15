
public class LightPanel extends ControlPanel {

  String[] lightingNames = {
    "idle", "warp", "red alert", "briefing"
  };
  int currentLightMode = 0;

  APRadioGroup lightGroup;
  APRadioButton[] radioList;
  ModToggle powerToggle;
  ModToggle prayToggle, seatbeltToggle;


  public LightPanel(String title, PApplet parent) {
    super(title, parent);
    lightGroup = new APRadioGroup(10, 100);
    lightGroup.setOrientation(APRadioGroup.VERTICAL);
    radioList = new APRadioButton[lightingNames.length];
    for (int i = 0; i < lightingNames.length; i++) {
      radioList[i] = new APRadioButton(lightingNames[i]);
      lightGroup.addRadioButton(radioList[i]);
    }
    radioList[0].setChecked(true);
    widgetContainer.addWidget(lightGroup);

    powerToggle = new ModToggle(10, 60, "lightpower", "/system/effect/lightingPower", false);
    buttonList.add(powerToggle);

    prayToggle = new ModToggle(150, 60, "pray", "/system/effect/prayLight", false);
    seatbeltToggle = new ModToggle(150, 160, "seatbelt", "/system/effect/seatbeltLight", false);
    buttonList.add(prayToggle);
    buttonList.add(seatbeltToggle);  
    
    widgetContainer.addWidget(prayToggle);
    widgetContainer.addWidget(seatbeltToggle);
    widgetContainer.addWidget(powerToggle);
  }


  public void onWidget(APWidget widget) {
    super.onWidget(widget);

    if (widget instanceof APRadioButton) {
      String t = ((APRadioButton)widget).getText();
      for (int i = 0; i < lightingNames.length; i++) {
        if (lightingNames[i].equals(t)) {
          OscMessage m = new OscMessage("/system/effect/lightingMode");
          m.add(i);
          new SendOSCTask().execute(m);
          break;
        }
      }
    }
  }

  public  void initGui() {
  }

  public  void draw() {
    text(lightingNames[currentLightMode], 10, 50);
  }

  public  void oscReceive(OscMessage message) {
  }
}

