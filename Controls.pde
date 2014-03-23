
public class ModButton extends APButton {
  String oscString = "/unnasigned";
  int value = 0;
  boolean sendValue = false;

  public ModButton (int x, int y, int w, int h, String title, String oscString) {
    super(x, y, w, h, title);
    this.oscString = oscString;
  }

  public void setValue(int value) {
    this.value = value;
    sendValue = true;
  }

  public ModButton(int x, int y, String title, String oscString) {

    super(x, y, title);
    this.oscString = oscString;
  }

  public OscMessage[] getOscMessages() {
    OscMessage m[] = new OscMessage[1];
    m[0] =  new OscMessage(oscString);
    if (sendValue) {
      m[0].add(value);
    }
    return m;
  }
}


public class ModToggle extends APToggleButton {
  String oscString = "/unnasigned";
  String serverMessage = "";
  boolean inverted = false;

  public ModToggle (int x, int y, int w, int h, String titleOn, String titleOff, String oscString, boolean startState) {
    super(x, y, w, h, titleOn);
    setChecked(startState);
    this.oscString = oscString;
    serverMessage = oscString;
    setTextOn(titleOn);
    setTextOff(titleOff);
    if (startState) {
      setText(titleOn);
    }
    else {
      setText(titleOff);
    }
  }

  public ModToggle (int x, int y, int w, int h, String title, String oscString, boolean startState) {
    super(x, y, w, h, title);
    setChecked(startState);
    this.oscString = oscString;
    serverMessage = oscString;
  }

  public ModToggle(int x, int y, String titleOn, String titleOff, String oscString, boolean startState) {
    super(x, y, titleOn);
    setChecked(startState);
    this.oscString = oscString;
    serverMessage = oscString;
    setTextOn(titleOn);
    setTextOff(titleOff);
    if (startState) {
      setText(titleOn);
    }
    else {
      setText(titleOff);
    }
  }

  public ModToggle(int x, int y, String title, String oscString, boolean startState) {
    super(x, y, title);
    setChecked(startState);
    this.oscString = oscString;
    serverMessage = oscString;
  }

  public void setInverted(boolean state) {
    inverted = state;
  }

  public boolean isInverted() {
    return inverted;
  }


  public OscMessage[] getOscMessages() {
    OscMessage m[] = new OscMessage[1];
    m[0] =  new OscMessage(oscString);
    m[0].add( isChecked() == (true & !inverted) ? 1 : 0 );
    return m;
  }

  public void setServerMessage(String s) {
    serverMessage = s;
  }

  public String getServerMessage() {
    return serverMessage;
  }

  public String getOscString() {
    return oscString;
  }
}

