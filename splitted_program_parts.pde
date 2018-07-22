 //The splited program parts
void titleBar(){
  fill(255,25,25);
  noStroke();
  rectMode(NORMAL);
  rect(0,0,dpw(100),dph(20));
  imageMode(NORMAL);
  image(logo, 0,0,dph(20), dph(20));
  fill(255);
  textAlign(CENTER);
  dpTextSize(80);
  text("Word Memory Test",dpw(50),dph(12));
}

void dpTextSize(float textSize){
  textSize((textSize/1920)*displayWidth);
}

float dpt(float textSize){
  return (textSize/1920.0)*displayWidth;
}

String folderPath(){
  String dp = dataPath("");
  dp = dp.substring(0,dp.length()-5);
  return dp;
}

String encode (String unEncoded) {
  byte[] uncoded = unEncoded.getBytes();
  int len = uncoded.length;
  byte[] encoded = new byte[len];
  for (int count = 0; count < len; count++){
    byte unCByte = uncoded[count];
    int i = unCByte+128;
    i = i*2 + 1;
    if (i >= 256){
      i--;
    }
    byte CByte = (byte)(i%256-128);
    encoded[count] = CByte;
  }
  return new String (encoded);
}

String decode (String encoded){
  byte[] toDecode = encoded.getBytes();
  int len = toDecode.length;
  byte[] decoded = new byte[len];
  for (int count = 0; count < len; count++){
    byte CByte = toDecode[count];
    int i = CByte + 128;
    if (i%2==0) {
      i = (i+256)/2;
    }else{
      i = (i-1)/2;
    }
    byte unCByte = (byte)(i-128);
    decoded[count] = unCByte;
  }
  return new String (decoded);
}

void txtRecord(){
  try{
    File testerHistory = new File(folderPath()+"\\history\\"+testerName+".txt");
    File generalHistory = new File(folderPath()+"\\history\\"+"General History.txt");
    testerHistory.setWritable(true);
    generalHistory.setWritable(true);
    PrintWriter recorder = new PrintWriter(new BufferedWriter(new FileWriter(testerHistory,true)));
    StringBuilder builder = new StringBuilder();
    builder.append(year()+"/"+month()+"/"+day()+"\n");
    builder.append(hour()+":"+minute()+"\n");
    builder.append(selectedBookName+" from list "+lowerLimit+" to list "+upperLimit+"\n");
    builder.append("Total word count: "+String.valueOf(correct+wrong)+"\n");
    builder.append("Correct rate: "+String.valueOf((correct/(float)(correct+wrong))*100)+"%");
    builder.append("\n");
    String unEncodedRec = builder.toString();
    recorder.println(unEncodedRec);
    recorder.close();
    testerHistory.setWritable(false);
    testerHistory.setReadOnly();
    PrintWriter generalRecorder = new PrintWriter(new BufferedWriter(new FileWriter(generalHistory,true)));
    String monthString = "0"+month();
    monthString = monthString.substring(monthString.length()-2);
    String dayString = "0"+day();
    dayString = dayString.substring(dayString.length()-2);
    String dateString = year()+"/"+monthString+"/"+dayString;
    String hourString = "0"+hour();
    hourString = hourString.substring(hourString.length()-2);
    String minString = "0"+minute();
    minString = minString.substring(minString.length()-2);
    String timeString = hourString+":"+minString;
    String bookName = selectedBookName+"    ";
    bookName = bookName.substring(0,4);
    String testString = bookName+" list"+lowerLimit+" to list"+upperLimit;
    String scoreString = correct+"/"+String.valueOf(correct+wrong);
    String nameString = testerName;
    for (int i = 0; i<14; i++){
      nameString = nameString.concat(" ");
    }
    nameString = nameString.substring(0,13);
    println("name length: "+nameString.length());
    generalRecorder.println(dateString+"\t"+timeString+"\t"+nameString+"\t"+testString+"\t"+scoreString);
    generalRecorder.close();
  }catch(IOException e){
    e.printStackTrace();
  }
}

void clearAll(){//这个函数一定要谨慎使用，务必放在每个Page切换到其他Page的地方
  widgets.removeAll();
  background(255);
  widgetThres = false;
}


void check(){
    boolean checkResult = true;
    try{
      BufferedReader checker = new BufferedReader(new InputStreamReader(Runtime.getRuntime().exec("ping www.baidu.com").getInputStream()));
      String netResponse = checker.readLine();
      if ((!netResponse.contains("找不到"))&&(!netResponse.contains("not"))){
        //println("Network Connection Error");
        checkResult =  false;
      }
      checker = new BufferedReader(new InputStreamReader(Runtime.getRuntime().exec("tasklist").getInputStream()));
      Stream<String> lines = checker.lines();
      Object[] programs = lines.toArray();
      for (Object o:programs) {
        String pName = (String) o;
        //println(pName);
        if (pName.contains("PowerWord")||pName.contains("Lingoes")){
          checkResult = false;
          break;
        }
      }
    }catch(IOException e){
      e.printStackTrace();
    }
    //checkResult = true;
    /*
    记得修改这里，把checkResult=false删掉
    */
    //println(checkResult);
    if (checkResult == false){
      runStatus = "error";
      clearAll();
    }
}//This is the end of the function check

void inputCheck(){
  if (keyPressed){
    char currentK = key;
    long curKPressed = millis();
    int gap = 400;
    if (key=='\b') gap = 100;
    if ((currentK!=prevK&&curKPressed-lastKPressed>50)||curKPressed-lastKPressed>gap){
      prevK = currentK;
      lastKPressed = curKPressed;
      inputLock = false;
      inputThres = false;
    }else{
      inputThres = false;
    }
    if (currentK==prevK&&curKPressed-lastKPressed>10){
      if (inputLock==false){
        inputThres = true;
        prevK = currentK;
        lastKPressed = curKPressed;
        inputLock = true;
      }
    }
  }else{
    inputThres = false;
  }
}

void clickCheck(){
  prevMousePressed = curMousePressed;
  curMousePressed = mousePressed;
  if (curMousePressed != prevMousePressed){
    clickThres = true;
  }else{
    clickThres = false;
  }
}

void checkAnswer(){
  if (questionType.equals("multiple")){ //<>//
    ArrayList<WordUnit> yourDefs = new ArrayList<WordUnit>();
    char[] chars = mChoosed.toCharArray();
    println(mChoosed);
    for (char c: chars){
      yourDefs.add(choices[c-'A']);
    }//把所有你选则的意象读到yourDefs里面
    println(yourDefs.size()+" vs "+correctDefs.size() );
    if (mChoosed.length()!= correctDefs.size()){
      wrong++;
      String errors = "";
      for(WordUnit wu : correctDefs){
        if (!WordUnit.FContainsL(yourDefs,wu)){
          println("miss");
          errors = errors + wu.getDefinition()+"和" ;
        }
      }
      if (!errors.equals("")) errors = errors.substring(0,errors.length()-1);
      mistakes.add(new MistakeRecord(recorder.size(), currentTested,MAnswer, mChoosed, questionType, choices));
    }else{
      boolean checkResult = true;
      for (char c : chars){
        if (!WordUnit.FContainsL(correctDefs,choices[c-'A'])){
          checkResult =false;
          println(currentTested.getWord()+" : "+choices[c-'A'].getDefinition());
          break;
        }
      }
      if (checkResult==true){
        correct++;
      }else{
        wrong++;
        String errors = "";
        for(WordUnit wu : correctDefs){
          if (!WordUnit.FContainsL(yourDefs,wu)){
            errors.concat(wu.getDefinition()+"和");
          }
        }
        if (!errors.equals("")) errors = errors.substring(0,errors.length()-1);
        mistakes.add(new MistakeRecord(recorder.size(), currentTested,MAnswer, mChoosed, questionType, choices));
      }
    }
  }else{
     if (choosed!=' '){
          if (choices[choosed-'A'].equals(currentTested)){
            correct++;
          }else{
            wrong++;
            mistakes.add(new MistakeRecord(recorder.size(), currentTested,String.valueOf(answer), String.valueOf(choosed),questionType, choices));
          }
     }else{
        wrong++;
        mistakes.add(new MistakeRecord(recorder.size(), currentTested,String.valueOf(answer), String.valueOf(choosed),questionType, choices));
     }
  }
}

boolean isLegalName(String bookName){
  for (String n:vocabBooks){
    if (n.equals(bookName)){
      return true;
    }
  }
  return false;
}

void loadWords() throws IOException{
  BufferedReader reader = new BufferedReader(new InputStreamReader(createInput("Dictionaries\\"+selectedBookName+".dict"),"Unicode"));
  boolean stop = false;
  while(stop==false){
    String tested =reader.readLine();
    if (tested==null){
      break;
    }
    String[] checkSplit = tested.split("\t");
    while(checkSplit.length<4){
      if (!WordUnit.isNumber(checkSplit[checkSplit.length-1])){
        tested = tested +reader.readLine();
      }else{
        break;
      }
      checkSplit = tested.split("\t");
    }
    //println(tested);
    //println(tested);
    WordUnit read = WordUnit.parseWord(tested);
    //println("The list number is "+read.getListNumber());
    if (read.getListNumber()>=lowerLimit&&read.getListNumber()<=upperLimit){
      //println("A word");
      testedWords.add(read);
      //println(read.toString());
    }
    entireBook.add(read);
  }
  reader.close();
  if (nChoiceMode.equals("number")){
    totalWordCount = (int) nChoiceInput;
    if (totalWordCount>testedWords.size()){
      runStatus = "rangeChoice";
      //println("too many words:"+ totalWordCount+" vs "+testedWords.size());
    }
  }else{
    totalWordCount = (int) ((nChoiceInput/100.0)*testedWords.size());
  }
}

void takeOneWord(){
  choosed = ' ';
  mChoosed = "";//必须在每次出题前把多选的答案记录清空，否则上一题的记录会到下一题去，影响下一题
  choices = new WordUnit[5];
  boolean stop = false;
  dice1 = -1;
  while(stop==false){
    dice1 = (int)random(0,testedWords.size()-0.0001);
    if (!recorder.contains(dice1)){
      stop = true;
    }
  }
  currentTested = testedWords.get(dice1);
  recorder.add(dice1);//record all the tested words by recording their indices in testedWords
  //println("A word "+currentTested.getWord()+" is picked for testing, haven't load the choices yet");
  if(randint(1,3)<2){//千万记得改回来
    MInit();
    return;
  }
  if (selectedBookName.equals("HS")||selectedBookName.equals("CET4")||selectedBookName.equals("CET6")){
    float dice2 = random(0,2);
    if (dice2<1){
      CtoEInit();
    }else{
      EtoCInit();
    }
  }else{
    EtoCInit();
  }
}

void CtoEInit(){//这两个函数作用是相同的，把choices数组填满，并设定好题型
  questionType = "CtoE";
  int[] book = new int[5];
  answerP = randint(0,4);
  answer = (char)('A'+answerP);
  book[answerP] = 1;
  choices[answerP] = currentTested;//第一步，确定选项的位置
  ArrayList<WordUnit> choiceRange = new ArrayList<WordUnit>();
  for (WordUnit wu:entireBook){//这个修改把寻找相似词的范围扩大到了整本书
    if (wu.getWord().length()==0||wu.getDefinition().length()==0){
      //println("Word Error: splitted: "+wu.toString());
      continue;
    }
    if (wu.getWord().charAt(0)==currentTested.getWord().charAt(0)){
      choiceRange.add(wu);
    }
  }
  int compIndex = 0;
  while (choiceRange.size()>12){
    compIndex ++;
    ArrayList<WordUnit> al = new ArrayList<WordUnit>();
    for (WordUnit wu:choiceRange){
      if (wu.getWord().charAt(compIndex)==currentTested.getWord().charAt(compIndex)){
        al.add(wu);
      }
    }
    choiceRange = al;
  }
  //println("The scope is already made smaller");
  Comparator<WordUnit> comp = new WordSimComp(currentTested,compIndex+1);
  PriorityQueue<WordUnit> maxSimSelection = new PriorityQueue<WordUnit>(comp);
  for (WordUnit wu:choiceRange){
    //println("The word is"+ wu.getWord());
    if (maxSimSelection.size()==4){ //<>//
      if (!wu.equals(currentTested)&&comp.compare(wu,maxSimSelection.peek())>0) {
        maxSimSelection.add(wu);
      }else{
        continue;
      }
    }else{
      if (!wu.equals(currentTested)) {
        maxSimSelection.add(wu);
      }
    }
    if (maxSimSelection.size()>4){
      maxSimSelection.poll();
    }
  }
  //println("Already choosed the closest 4 words");
  while (maxSimSelection.size()<4){
    int appendDice = randint(0, testedWords.size()-1);
    WordUnit appended = testedWords.get(appendDice);
    if (!maxSimSelection.contains(appended)){
      maxSimSelection.add(appended);
    }
  }
  //println("The length of the array has already been appended to 4");
  Iterator<WordUnit> iter = maxSimSelection.iterator();
  for (int i =0; i<5; i++){
    if (book[i]==0){
      book[i]=1;
      choices[i]=iter.next();
    }
  }//fill the array choices
}

void EtoCInit(){//这两个函数作用是相同的，把choices数组填满，并设定好题型
  questionType = "EtoC";
  int[] book = new int[5];
  answerP = randint(0,4);
  answer = (char)('A'+answerP);
  book[answerP] = 1;
  choices[answerP] = currentTested;//也是一样，第一步，确定选项的位置
  for (int i =0; i<4; i++){
    int c= randint(0, testedWords.size()-1);
    WordUnit chosen = testedWords.get(c);
    if (!WordUnit.isInChoices(chosen,choices)){
      int index = -1;
      for (int j =0; j<book.length; j++){
        if (book[j]==0){
          index = j;
          break;
        }
      }
      book[index]=1;
      choices[index]=chosen;
    }else{
      i--;
    }
    //println("i: "+i);
  }
}//This is the end of initializing single choice question part

void MInit(){//这个函数作用也是相同的，把choices数组填满，并设定好题型
  MAnswer = "";
  questionType = "multiple";
  ArrayList<WordUnit> defs = currentTested.getDefAsWordUnits();
  correctDefs = new ArrayList<WordUnit>();
  for (int i =0; i<5; i++){
    if (i>defs.size()-1){
      break;
    }
    int ranP =randint(0,4);
    if (choices[ranP]==null){
      MAnswer = MAnswer.concat(String.valueOf( (char)('A'+ranP) ));
      choices[ranP] = defs.get(i);
      correctDefs.add(defs.get(i));
    }else{
      i--;
    }
  }
  //以上一段用这个词的意项填充choices
  for (int j =0; j<5; j++){
    if (choices[j]==null){
      WordUnit apDefTarget = testedWords.get(randint(0,testedWords.size()-1));
      if (apDefTarget.equals(currentTested)){
        j--;
        continue;
      }
      ArrayList<WordUnit> apDefs = apDefTarget.getDefAsWordUnits();
      boolean flag = false;
      for (WordUnit wu:apDefs){
        if (!WordUnit.isInChoices(wu,choices)){
          choices[j] = wu;
          flag = true;
          break;
        }
      }
      if (flag==false) j--;
    }
  }
  char[] MAnswerChars = MAnswer.toCharArray();//这一段把多选题的答案字母顺序理好
  Arrays.sort(MAnswerChars);
  MAnswer = new String (MAnswerChars);
  println("MAnswer: "+MAnswer);
  //这一段用随机的定义WordUnit来把choices填满，这样一来,init函数的工作就完成了
}

void initializeSingleChoiceWidgets(){//双击，作为单选题的一大特点，也被加入到了这个函数中
  doubleClickSensor =new DoubleClickSensor();
    doubleClickSensor.setAction(new Action(){
      public void perform(){
        checkAnswer();
        clearAll();
      }
  });
  buttonA = new Button(new RectArea(dpw(50),dph(25),dpw(100),dph(10)),TRANSBLUE,ALPHA);
  buttonB = new Button(new RectArea(dpw(50),dph(40),dpw(100),dph(10)),TRANSBLUE,ALPHA);
  buttonC = new Button(new RectArea(dpw(50),dph(55),dpw(100),dph(10)),TRANSBLUE,ALPHA);
  buttonD = new Button(new RectArea(dpw(50),dph(70),dpw(100),dph(10)),TRANSBLUE,ALPHA);
  buttonE = new Button(new RectArea(dpw(50),dph(85),dpw(100),dph(10)),TRANSBLUE,ALPHA);
  if (questionType=="CtoE"){
    buttonA.setText(choices[0].getWord(),50,0);
    buttonB.setText(choices[1].getWord(),50,0);
    buttonC.setText(choices[2].getWord(),50,0);
    buttonD.setText(choices[3].getWord(),50,0);
    buttonE.setText(choices[4].getWord(),50,0);
  }else if (questionType =="EtoC"){
    buttonA.setText( trimText(choices[0].getDefinition()) ,45,0);
    buttonB.setText( trimText(choices[1].getDefinition()) ,45,0);
    buttonC.setText( trimText(choices[2].getDefinition()) ,45,0);
    buttonD.setText( trimText(choices[3].getDefinition()) ,45,0);
    buttonE.setText( trimText(choices[4].getDefinition()) ,45,0);
  }
  buttonA.setAction(new Action(){
    public void perform(){
      choosed = 'A';
      setAllButtonsDim();
      buttonA.setBackgroundColor(YELLOW);
      doubleClickSensor.switchOn();
    }
  });
  buttonB.setAction(new Action(){
    public void perform(){
      choosed = 'B';
      setAllButtonsDim();
      buttonB.setBackgroundColor(YELLOW);
      doubleClickSensor.switchOn();
    }
  });
  buttonC.setAction(new Action(){
    public void perform(){
      choosed = 'C';
      setAllButtonsDim();
      buttonC.setBackgroundColor(YELLOW);
      doubleClickSensor.switchOn();
    }
  });
  buttonD.setAction(new Action(){
    public void perform(){
      choosed = 'D';
      setAllButtonsDim();
      buttonD.setBackgroundColor(YELLOW);
      doubleClickSensor.switchOn();
    }
  });
  buttonE.setAction(new Action(){
    public void perform(){
      choosed = 'E';
      setAllButtonsDim();
      buttonE.setBackgroundColor(YELLOW);
      doubleClickSensor.switchOn();
    }
  });
}

void setAllButtonsDim(){
  buttonE.setBackgroundColor(ALPHA);
  buttonD.setBackgroundColor(ALPHA);
  buttonC.setBackgroundColor(ALPHA);
  buttonB.setBackgroundColor(ALPHA);
  buttonA.setBackgroundColor(ALPHA);
}

void initializeMultipleChoiceWidgets(){
  SButtonA = new SButton('A');
  SButtonB = new SButton('B');
  SButtonC = new SButton('C');
  SButtonD = new SButton('D');
  SButtonE = new SButton('E');
  SButtonA.setText( trimText(choices[0].getDefinition()) ,45,0);
  SButtonB.setText( trimText(choices[1].getDefinition()) ,45,0);
  SButtonC.setText( trimText(choices[2].getDefinition()) ,45,0);
  SButtonD.setText( trimText(choices[3].getDefinition()) ,45,0);
  SButtonE.setText( trimText(choices[4].getDefinition()) ,45,0);
  /*
  当这种SButton在激活状态下被点击时，撤销答案中那个SButton所对应的字符
  反之，当在非激活状态下被点击时，加上它对应的字符
  解释以下代码
  */
  SButtonA.setAction(new Action(){
    public void perform(){
      if (SButtonA.isActivated==true){
        mChoosed = mChoosed.replaceAll("A","");
        println("minusA");
        println(mChoosed);
      }else{
        mChoosed = mChoosed+"A";
      }
    }
  });
  SButtonB.setAction(new Action(){
    public void perform(){
      if (SButtonB.isActivated==true){
        mChoosed = mChoosed.replaceAll("B","");
        println("minusB");
        println(mChoosed);
      }else{
        mChoosed = mChoosed+"B";        
      }
    }
  });
  SButtonC.setAction(new Action(){
    public void perform(){
      if (SButtonC.isActivated==true){
        mChoosed = mChoosed.replaceAll("C","");
        println("minusC");
        println(mChoosed);
      }else{
        mChoosed = mChoosed+"C";
      }
    }
  });
  SButtonD.setAction(new Action(){
    public void perform(){
      if (SButtonD.isActivated==true){
        mChoosed = mChoosed.replaceAll("D","");
        println("minusD");
        println(mChoosed);
      }else{
        mChoosed = mChoosed+"D";
      }
    }
  });
  SButtonE.setAction(new Action(){
    public void perform(){
      if (SButtonE.isActivated==true){
        mChoosed = mChoosed.replaceAll("E","");
        println("minusE");
        println(mChoosed);
      }else{
        mChoosed = mChoosed+"E";
      }
    }
  });
}

void loadingTitleBar(){
  background(255);
  fill(LIGHTBLUE);
  rectMode(NORMAL);
  rect(0,0,dpw(100),dph(20));
  dpTextSize(24);
  textFont(HEITI);
  fill(WHITE);
  textAlign(NORMAL);
  text("Loading...",dpw(3),dph(5));
  text("It may take about 45 seconds. Please be patient.",dpw(3),dph(15));
}

String trimText (String trimmed) {
  String result = trimmed;
  if (result.length()>30) {
    result = result.substring(0,30)+"...";
  }
  return result;
}

String[] loadAvailableVocabBooks(){//这个用来从Dictionary目录下读取现在所有的单词书
  File dictsFolder = new File(dataPath("")+"\\Dictionaries");
  File [] dicts = dictsFolder.listFiles();
  ArrayList<String> vocabBooks = new ArrayList<String>();
  for (File f:dicts){
    String fullName = f.getName();
    fullName = fullName.substring(0,fullName.length()-5);
    vocabBooks.add(fullName);
  }
  String[] bookNames = new String[vocabBooks.size()];
  for (int i=0; i<vocabBooks.size(); i++){
    bookNames[i] = vocabBooks.get(i);
  }
  return bookNames;
}

void pdfSetup(){
  pdfReport.beginDraw();
  pdfReport.background(255);
  pdfReport.textSize(dpt(25));
  pdfReport.textFont(HEITI);
  pdfReport.textAlign(NORMAL);
  pdfReport.rectMode(CENTER);
  pdfReport.strokeWeight(10.0/1920.0*displayWidth);
}

void pdfDrawLines (float start, float interval, int num){
  for (int i = 0; i < num; i ++){
    float lineY = start + interval * i;
    pdfReport.line(dpw (5),lineY, dpw(95), lineY);
  }
}

void pdfFirstPage(){
  pdfReport.noFill();
  pdfReport.rect(dpw(50), dph (50), dpw (90), dph(80),dph(4));
  pdfDrawLines (dph(30), dph(20), 3);
  pdfReport.fill(0);
  pdfReport.textAlign(CENTER);
  pdfReport.textSize(dpt(55));
  pdfReport.text("词汇测试成绩单", dpw(50), dph (20+1));
  pdfReport.textAlign(NORMAL);
  String timeString = testStartTime + " 至 " + testEndTime;
  pdfReport.text("测试时长： "+timeString, dpw(7), dph (40+1)); 
  pdfReport.text("选词范围： "+selectedBookName+", List"+upperLimit+" to List"+lowerLimit, dpw(7), dph (60+1)); 
  pdfReport.text("正确率： "+correct+"/"+String.valueOf(correct+wrong), dpw(7), dph (80+1));
}

void textLineNum (String text, int lineNum){
  float textY = dph(5)+dph (90.0/7.0)*(lineNum-0.5)+dph(1);
  pdfReport.text(text, dpw (7), textY);
}

void pdfMistakePage(MistakeRecord mistake){
  pdfReport.nextPage();
  pdfReport.noFill();
  pdfReport.rect(dpw(50), dph(50), dpw(90), dph (90), dph(4));
  pdfDrawLines (dph (5+90.0/7.0), dph (90.0/7.0), 6);
  pdfReport.textSize (dpt(50));
  textLineNum (mistake.getQuestionString(),1);
  for (int i = 0; i <5; i ++){
    char choice = (char)('A'+i);
    textLineNum (trimText(mistake.getChoiceString(choice)), i+2);
  }
  pdfReport.line(dpw(50), dph(90.0/7.0*6+5.0), dpw(50), dph(95));//draw the septum
  textLineNum ("正确答案："+mistake.getCorrectAnswer(),7);
  pdfReport.text("你的答案："+mistake.getYourAnswer(), dpw(52), dph (95.0-90.0/14.0+1));
}

void pdfRecord(){
  testEndTime = hour()+"时"+minute()+"分"+second()+"秒";
  String monthString = "0"+month();
  monthString = monthString.substring(monthString.length()-2);
  monthString = "-"+monthString;
  String dayString = "0"+day();
  dayString = dayString.substring(dayString.length()-2);
  dayString = "-"+dayString;
  pdfName =year()+monthString+dayString+"（"+testEndTime+"）";
  pdfReport = (PGraphicsPDF) createGraphics (width, height, PDF, "reports\\"+testerName+"\\"+pdfName+".pdf");
  pdfSetup();
  pdfFirstPage();
  for (MistakeRecord m : mistakes){
    pdfMistakePage (m);
  }
  pdfReport.dispose();
  pdfReport.endDraw();
  /*
  pdfReport.beginDraw();
  pdfReport.background(255);
  pdfReport.textSize(20);
  pdfReport.textFont(HEITI);
  pdfReport.fill(0);
  pdfReport.textAlign(NORMAL);
  pdfReport.text("正确答案",dpw(2),dph(5));
  pdfReport.text("题型",dpw(40),dph(5));
  pdfReport.text("你的错误选择",dpw(62),dph(5));
  for (int i=0; i<mistakes.size();i++){
    MistakeRecord displayed = mistakes.get(i);
    String displayedCorrectDefi = "";
    if (displayed.getCorrectAnswer().getDefinition().length()<8){
      displayedCorrectDefi = displayed.getCorrectAnswer().getDefinition();
    }else{
      displayedCorrectDefi = displayed.getCorrectAnswer().getDefinition().substring(0,8);
    }
    String displayedYourDefi;
    if(displayed.getQuestionType().equals("EtoC")){
      if (displayed.getYourAnswer()!=null){
        if (displayed.getYourAnswer().getDefinition().length()<8){
          displayedYourDefi = displayed.getYourAnswer().getDefinition();
        }else{
          displayedYourDefi = displayed.getYourAnswer().getDefinition().substring(0,8);
        }
      }else{
        displayedYourDefi = "未选择";
      }
    }else if(displayed.getQuestionType().equals("CtoE")){
      WordUnit yourDefi = displayed.getYourAnswer();
      if (yourDefi==null){
        displayedYourDefi = "未选择";
      }else{
        displayedYourDefi = yourDefi.getWord();
      }
    }else {//也就是说是多选模式的时候
      WordUnit yourDefi = displayed.getYourAnswer();
      String yourMistake = yourDefi.getDefinition();
      if (yourMistake.equals("")){
        displayedYourDefi = "选多了";
      }else{
        displayedYourDefi = "漏选了\n"+yourMistake;
      }
    }
    pdfReport.fill(0);
    pdfReport.textAlign(NORMAL);
    int j = i%8;
    pdfReport.text(displayed.getCorrectAnswer().getWord(),dpw(2),dph(15+j*11));
    pdfReport.text(displayedCorrectDefi,dpw(2),dph(15+j*11+5.5));
    pdfReport.text(displayed.getQuestionType(),dpw(40),dph(15+j*11));
    pdfReport.text(displayedYourDefi,dpw(62),dph(15+j*11));
    if (i%8==7){
      pdfReport.nextPage();
      pdfReport.text("正确答案",dpw(2),dph(5));
      pdfReport.text("题型",dpw(40),dph(5));
      pdfReport.text("你的错误选择",dpw(62),dph(5));
    }
  }
  pdfReport.dispose();
  pdfReport.endDraw();
  */
}

LinkedHashMap<String,WordUnit> searchInDicts(String searchKey){
  LinkedHashMap<String,WordUnit> searchResults = new LinkedHashMap<String,WordUnit>();
  for (String bookName: vocabBooks){
    BufferedReader dictReader = null;
    try{
      dictReader = new BufferedReader(new InputStreamReader(new FileInputStream(folderPath()+"\\data\\Dictionaries\\"+bookName+".dict"),"Unicode"));      
      boolean readerStop = false;
      while(readerStop==false){
        String tested =dictReader.readLine();
        if (tested==null){
          break;
        }
        String[] checkSplit = tested.split("\t");
        while(checkSplit.length<4){
          if (!WordUnit.isNumber(checkSplit[checkSplit.length-1])){
            tested = tested +dictReader.readLine();
          }else{
            break;
          }
          checkSplit = tested.split("\t");
        }
        WordUnit read = WordUnit.parseWord(tested);
        if (read.getWord().equals(searchKey)){
          searchResults.put(bookName,read);
          println(bookName);
        }
      }
  }catch(IOException e){
      e.printStackTrace();
    }
  }
  return searchResults;
}


boolean checkTime(){
  boolean timeResult = true;
  String monthString = "0"+month();
  monthString = monthString.substring(monthString.length()-2);
  String dayString = "0"+day();
  dayString = dayString.substring(dayString.length()-2);
  String dateString = year()+"/"+monthString+"/"+dayString;
  try{
    BufferedReader historyChecker = new BufferedReader(new InputStreamReader(new FileInputStream(folderPath()+"\\history\\General History.txt")));
    boolean checkerStop = false;
    while (checkerStop == false){
      String line = historyChecker.readLine();
      if (line==null){
        break;
      }
      String[] splices = line.split("\t");
      String date = splices[0];
      if (!date.equals(dateString)){
        println("over");
      }else{
        String tempName = splices[2];
        tempName = tempName.replaceAll(" ","");
        String timeString = splices[1];
        String[] timeSplits = timeString.split(":");
        int tempHour = Integer.parseInt(timeSplits[0]);
        int tempMin = Integer.parseInt(timeSplits[1]);
        int timeDiffer = hour()*60+minute()-tempHour*60-tempMin;
        String correctRateString = splices[4];
        String[] correctAndWrongSplices = correctRateString.split("/");
        float correctRate = Integer.parseInt(correctAndWrongSplices[0])/(float)(Integer.parseInt(correctAndWrongSplices[1]));
        if (tempName.equals(testerName)&&timeDiffer<15&&correctRate<0.93){
          println("Only "+timeDiffer+" minutes");
          timeResult = false;
          timeGap = timeDiffer;
        }
      }
    }
  }catch(IOException e){
    e.printStackTrace();
  }
  return timeResult;
}

void setErrStream(){
  try{
    System.setErr(new PrintStream(new FileOutputStream(folderPath()+"\\log\\main.log"),true));
  }catch (IOException e){
    e.printStackTrace();
  }
}

/*
void printAllChoices(){
  for (WordUnit wu:choices){
    println(wu.toString());
  }
}
*/

/*
void testInput()throws IOException{
  BufferedReader reader = new BufferedReader(new InputStreamReader(createInput("data/test.dict"),"Unicode"));
  println(reader.readLine());
  println(reader.readLine());
  println(reader.readLine());
}
*/