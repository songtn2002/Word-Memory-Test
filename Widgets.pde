class WidgetSet{
  
  ArrayList<Button> buttons;
  ArrayList<TextField> textFields;
  ArrayList<DropDownList> dropDownLists;
  
  public WidgetSet(){
    buttons = new ArrayList<Button>();
    textFields = new ArrayList<TextField>();
    dropDownLists = new ArrayList<DropDownList>();
  }
  
  public void add(Button b){
    buttons.add(b);
  }
  
  public void add(TextField tf){
    textFields.add(tf);
  }
  
  public void add(DropDownList ddl){
    dropDownLists.add(ddl);
  }
  
  public void display(){
    clickCheck();//对按钮进行控制，防止多次重按按钮
    maintainTextFields();
    for (Button b:buttons){
      b.display();
    }
    for (TextField tf:textFields){
      tf.display();
    }
    for (DropDownList ddl:dropDownLists){
      ddl.display();
    }
  }
  
  private void maintainTextFields(){
    int resetted = -1;
    for (int i =0; i<textFields.size(); i++){
      TextField tf = textFields.get(i);
      if (tf.isFocused()==true){
        resetted = i;
        break;
      }
    }
    if (resetted!=-1){
      //println("reset the focus");
      for (TextField tf:textFields){
        tf.setFocus(false);
      }
      textFields.get(resetted).setFocus(true);
    }
    inputCheck();//Be aware of this function, inputCheck, its critical to maintaining textFields
  }
  
  public String[] getTextFieldInputs(){
    String[] responses = new String[textFields.size()];
    for (int i =0; i<responses.length; i++){
      responses[i] = textFields.get(i).getTextInput();
    }
    return responses;
  }
  
  public String[] getDropDownListInputs(){
    String[] responses = new String[dropDownLists.size()];
    for (int i =0; i<responses.length; i++){
      responses[i] = dropDownLists.get(i).getCurrentInput();
    }
    return responses;
  }
  
  public void removeAll(){
    this.buttons = new ArrayList<Button>();
    this.textFields = new ArrayList<TextField>();
    this.dropDownLists = new ArrayList<DropDownList>();
  }
  
}//This is the end of the class WidgetSet

class Button{
  
  {
    name = "";
    textSize = 40;
    tc = color(0);
  }
  
  protected Drawable ra;
  protected PImage[] images;
  protected color fc;
  protected color bc;
  protected Action action;
  protected String name;
  protected int textSize;
  protected color tc;
  
  public Button(Drawable ra,PImage[] images){
    this.images = images;
    this.ra = ra;
    widgets.add(this);
  }
  
  public Button(Drawable ra, color fc, color bc){
    this.fc = fc;
    this.bc = bc;
    this.ra = ra;
    widgets.add(this);
  }
  
  
  public void display(){
    if (!ra.hasMouse()){
      if (images!=null){
        imageMode(CENTER);
        image(images[0],ra.getX(),ra.getY(),ra.getW(),ra.getH()-dph(1.5));
      }else{
        fill(bc);
        noStroke();
        ra.drawSelf();
        fill(tc);
        dpTextSize(textSize);
        textAlign(CENTER);
        text(name,ra.getX(),ra.getY()+dph(1.5*(g.textSize/((55.0/1920)*displayWidth))));
      }
    }else{
      if (images!=null){
        imageMode(CENTER);
        image(images[1],ra.getX(),ra.getY(),ra.getW(),ra.getH()-dph(1.5));
      }else{
        fill(fc);
        noStroke();
        ra.drawSelf();
        fill(tc);
        dpTextSize(textSize);
        textAlign(CENTER);
        text(name,ra.getX(),ra.getY()+dph(1.5*(g.textSize/((55.0/1920)*displayWidth))));
      }
      if (ra.hasMousePressed()&&clickThres == true){
        if (action!=null){
          action.perform();
        }
      }
    }
  }//The end of display
  
  public void setAction(Action a){
    this.action = a;
  }
  
  public void setText(String name, int textSize,color textColor){
    this.name = name;
    this.textSize = textSize;
    this.tc = textColor;
  }//The end of set Text
  
  public void setBackgroundColor(color c){
    this.bc=c;
  }
  
  public float getX(){
    return this.ra.getX();
  }
  
  public float getY(){
    return this.ra.getY();
  }
  
  public float getH(){
    return this.ra.getH();
  }
  
  public float getW(){
    return this.ra.getW();
  }
  
}//The end of class button






class TextField{
  
  {
    charLimit = 4;
  }
  
  private String textInput;
  private RectArea ra;
  private boolean focus;
  private int charLimit;
  
  public TextField(RectArea ra){
    this.ra = ra;
    this.focus = false;
    this.textInput = "";
    widgets.add(this);
  }
  
  public void display(){
    strokeWeight(dph(0.2));
    stroke(0);
    fill(255);
    ra.drawSelf();
    if (textInput.length()>charLimit){
      textInput = textInput.substring(0,charLimit);
    }//把textInput控制在charLimit之内
    String displayText;
    displayText = textInput;
    if (floor(millis()/500)%2==1&&focus==true){
      displayText=displayText+"|";
    }
    fill(0);
    dpTextSize(ra.getH()/1.9);
    textAlign(NORMAL);
    text(displayText,(ra.getX()-ra.getW()/2),ra.getY()+dph(0.8));
    if(focus==true){
      if (inputThres==true&&keyPressed){
        if (key=='\b'){
          if (textInput.length()>0){
            textInput = textInput.substring(0,textInput.length()-1);
          }
        }else if ( (key>='A'&&key<='Z') || (key>='a'&&key<='z')||(key>='0'&&key<='9') || key==' '){
          if (key!=' '){
            textInput = textInput+String.valueOf(key);
          }else{//也就是说key=='_'的时候
            textInput = textInput+String.valueOf("_");
          }
        }
      }
    }
  }
  
  public String getTextInput(){
    return this.textInput;
  }
  
  public void setFocus(boolean focus){
    this.focus = focus;
  }
  
  public boolean getFocus(){
    return this.focus;
  }
  
  public boolean isFocused(){
    return this.ra.hasMousePressed();
  }
  
  public void setCharLimit(int charLimit){
    this.charLimit = charLimit;
  }
}
//This is the end of the class TextField, extremely successful and useful

class DropDownList{
  
  {
    currentInput = "214";
    dropDownDisplay = false;
  }
  
  private RectArea inputButton;//
  private String [] dropDowns;//
  private String currentInput;//
  private RectArea[] dropDownButtons;//
  private boolean dropDownDisplay;//
  
  public DropDownList(RectArea ra, String[] dropDowns){
    this.inputButton = ra;
    this.dropDowns = dropDowns;
    this.dropDownButtons = new RectArea[dropDowns.length];
    for (int i =0; i<dropDownButtons.length; i++){
      dropDownButtons[i] = new RectArea(inputButton.getX() , inputButton.getY()+inputButton.getH()*(i+1), inputButton.getW(),inputButton.getH());
    }
    widgets.add(this);
  }
  
  public void display(){
    fill(255);
    stroke(0);
    inputButton.drawSelf();
    text(currentInput,inputButton.getX(),inputButton.getY()+dph(1));
    float rightVertexX = inputButton.getX()+inputButton.getW()/2.0-dpw(1);
    float rightVertexY = inputButton.getY()+dpw(1);
    fill(0);
    textAlign(CENTER);
    dpTextSize(30);
    text(currentInput,inputButton.getX()-dpw(1),inputButton.getY()+dph(0.75));
    triangle(rightVertexX+dpw(0.75),rightVertexY-dph(2.75),rightVertexX-dpw(0.75),rightVertexY-dph(2.75),rightVertexX,rightVertexY-dph(0.75));
    //画出那个三角形
    
    if(dropDownDisplay==false&&inputButton.hasMousePressed()&&clickThres==true){
      dropDownDisplay = true;
    }
    else if (dropDownDisplay==true&&clickThres==true&&mousePressed){
      float completeCenterY = inputButton.getY()+dropDownButtons.length/2.0*inputButton.getH();
      RectArea completeSpace = new RectArea(inputButton.getX(),completeCenterY,inputButton.getW(),(dropDownButtons.length+1)*inputButton.getH());
      if (!completeSpace.hasMousePressed()){
        dropDownDisplay = false;
      }
    }//在这里是为了将dropDownList收起来
    
    if (dropDownDisplay==true){//这个if语句用来显示下拉菜单
      //println("displayed");
      for (int i =0; i<dropDownButtons.length; i++){
        noStroke();
        if (dropDownButtons[i].hasMouse()){
          fill(LIGHTBLUE);
          if (mousePressed&&clickThres){
            currentInput = dropDowns[i];
            //println("chosen "+currentInput);  
          }
        }else{
          fill(255);
        }
        dropDownButtons[i].drawSelf();
        fill(0);
        textAlign(CENTER);
        text(dropDowns[i],dropDownButtons[i].getX(),dropDownButtons[i].getY()+dph(1));
      }
   }//这个if语句用来显示下拉菜单
   
  }//This is the end of display
  
  public String getCurrentInput(){
    return this.currentInput;
  }
}

class SButton extends Button{
  
  {
    this.isActivated = false;
  }
  
  private color bcActivated;
  private boolean isActivated;
  
  public SButton(Drawable ra, color fc, color bc , color bcActivated){
    super(ra, fc, bc);
    this.bcActivated = bcActivated;
  }
  
  public SButton (char choice){
    this(new RectArea(dpw(50),dph(25+(choice-'A')*15), dpw(100),dph(10)), LIGHTBLUE,ALPHA, YELLOW);
  }
  
  public char getChoiceIndex(){
    return (char)((this.getH()-25)/15+'A');
  }
  
  public void display(){
    if (!ra.hasMouse()){
      if (this.isActivated == true){
        fill(bcActivated);
      }else{
        fill(bc);
      }
      ra.drawSelf();
      fill(tc);
      dpTextSize(textSize);
      textAlign(CENTER);
      text(name,ra.getX(),ra.getY()+dph(1.5));
    }else{
      fill(fc);
      ra.drawSelf();
      fill(tc);
      dpTextSize(textSize);
      textAlign(CENTER);
      text(name,ra.getX(),ra.getY()+dph(1.5));
    }
    if (ra.hasMousePressed()&&clickThres == true){
        if (action!=null){
          action.perform();
        }
        this.isActivated = Boolean.logicalXor(isActivated,true);
    }
  }
  //The end of display 
  
  public boolean getIsActivated(){
    return this.isActivated;
  }
}