import android.view.View;


public class ModButton extends APButton {
  String oscString = "/unnasigned";
  Object value ;

  boolean sendValue = false;

  public ModButton (int x, int y, int w, int h, String title, String oscString) {
    super(x, y, w, h, title);
    this.oscString = oscString;
  }


  public void setValue(Object value) {
    this.value = value;
    println("setting: " + value.getClass().getSimpleName());
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
      
      if (value instanceof Integer) {

        m[0].add(((Integer)value).intValue());
      } 
      else if (value instanceof Float) {
        m[0].add(((Float)value).floatValue());
      } 
      else if( value instanceof String){
        m[0].add((String)value);
      }
    }
    return m;
  }
}


public class ModToggle extends APToggleButton {
  String oscString = "/unnasigned";
  String serverMessage = "";
  boolean inverted = false;

  boolean wasClicked = false;

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

  public void onClick(View view) {
    super.onClick(view);
    wasClicked = true;
  }


  public void setChecked(boolean checked) {
    if (wasClicked) {
      super.setChecked(checked);
      wasClicked = false;
    } 
    else {
      checked = checked;
    }
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

