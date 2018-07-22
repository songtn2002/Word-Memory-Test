void homePage(){//在这个homepage里面的start按钮不是用Widget类写的，别犹豫；
  if(widgetThres==false){
    Button start = new Button(new RoundArea(dpw(50),dph(75),dpw(8)), LIGHTRED, DARKRED);
    start.setText("Start",88,WHITE);
    start.setAction(new Action(){
      public void perform(){
        testStartTime = hour()+"时"+minute()+"分"+second()+"秒";
        runStatus = "rangeChoice";
        clearAll();
      }
    });
    Button history = new Button(new RoundRectArea(dpw(80),dph(50),dpw(16),dph(35)),DARKRED,LIGHTRED);
    history.setAction(new Action(){
      public void perform(){
        clearAll();
        runStatus = "history";
      }
    });
    Button quest = new Button(new RoundRectArea(dpw(20),dph(50),dpw(16),dph(35)),DARKRED,LIGHTRED);
    quest.setAction(new Action(){
      public void perform(){
        clearAll();
        runStatus = "quest";
      }
    });
    widgetThres = true;
  }
  background(255);
  titleBar();
  String date = year()+"/"+month()+"/"+day();
  String time = hour()+":"+minute()+":"+second();
  textAlign(CENTER);
  fill(0);
  dpTextSize(55);
  text(date, dpw(50),dph(35));
  text(time, dpw(50),dph(45));
  widgets.display();
  historyImage(dpw(80),dph(47),1.1);
  questImage(dpw(20),dph(47),1.1);
}



void rChoicePage(){
  if (widgetThres == false){
    TextField testerNameInput = new TextField(new RectArea(dpw(50),dph(37),dpw(25),dph(5)));
    testerNameInput.setFocus(true);
    testerNameInput.setCharLimit(14);
    DropDownList bookName = new DropDownList(new RectArea(dpw(34),dph(39-1+20),dpw(7),dph(5)),vocabBooks);
    TextField startC = new TextField(new RectArea(dpw(52),dph(39-1+20),dpw(5),dph(5)));
    startC.setCharLimit(3);
    TextField stopC = new TextField(new RectArea(dpw(68),dph(39-1+20),dpw(5),dph(5)));
    stopC.setCharLimit(3);
    Button confirm = new Button(new RoundArea(dpw(50),dph(80),dpw(6)), LIGHTRED,DARKRED);
    confirm.setText("next",55,255);
    confirm.setAction(new Action(){
      public void perform(){
        rangeInputs = Arrays.copyOf(widgets.getTextFieldInputs(),3);//The variable rangeSelected here is a variable defined to stores responses by the input box, declared in the main file
        runStatus ="numberChoice";//number在这里是指数量的意思
        testerName = rangeInputs[0];
        selectedBookName = widgets.getDropDownListInputs()[0];
        try{
          lowerLimit = Integer.parseInt(rangeInputs[1]);
          upperLimit = Integer.parseInt(rangeInputs[2]);
        }catch(NumberFormatException e){
          runStatus = "rangeChoice";
        }
        if (checkTime()==false){
          runStatus = "timeError";
        }
        clearAll();
      }
    });
    widgetThres = true;
  }
  background(255);
  titleBar();
  dpTextSize(40);
  fill(0);
  textAlign(CENTER);
  text("Please enter your name",dpw(50),dph(30));
  text("Please select a range for testing",dpw(50),dph(30+20));
  text("from list",dpw(44),dph(39+20));
  text("to list",dpw(60),dph(39+20));
  widgets.display();
  
}//The range Choice Page ends here


void errorPage(){
  if (widgetThres==false){
     Button bt1 = new Button(new RectArea(dpw(50),dph(60),dpw(8),dph(8)),LIGHTRED,DARKRED);
     bt1.setText("Exit", 45, color(255));
     bt1.setAction(new Action(){
       public void perform(){
         exit();
       }
     });
     widgetThres = true;
  }
  background(255);
  titleBar();
  fill(0);
  dpTextSize(60);
  text("Sorry, the test can only be started when there is \nno internet connection and dictionary softwares,\n please close and restart the test",dpw(50),dph(30));
  widgets.display();
}//The error Page ends here

void timeErrorPage(){
  if (widgetThres==false){
    Button exit = new Button(new RectArea(dpw(50),dph(85),dpw(10),dph(10)),LIGHTRED,DARKRED);
    exit.setText("Exit", 55, color(255));
    exit.setAction(new Action(){
      public void perform(){
         exit();
      }
    });
    int choice = randint(1,3);
    println(choice);
    image11 = loadImage("pictures\\图片1"+String.valueOf(choice*2-1)+".jpg");
    image12 = loadImage("pictures\\图片1"+String.valueOf(choice*2)+".jpg");
    widgetThres = true;
  }
  background(255);
  titleBar();
  fill(0);
  dpTextSize(60);
  text("Sorry, you still have to wait "+String.valueOf(15-timeGap)+" minutes\nbefore you can take the test for another time",dpw(50),dph(30));
  imageMode(CENTER);
  image(image11,dpw(30),dph(60),dpw(16),dph(32));
  image(image12,dpw(70),dph(60),dpw(16),dph(32));
  widgets.display();
}


void nChoicePage(){
  if (widgetThres==false){
    Button pct = new Button(new RoundArea(dpw(41),dph(30),dpw(2)), LIGHTBLUE,ALPHA);
    pct.setText("%",40,0);
    Button nmb = new Button(new RoundArea(dpw(59),dph(30),dpw(2)), LIGHTBLUE,ALPHA);
    nmb.setText("N",40,0);
    pct.setAction(new Action(){
      public void perform(){
        nChoiceMode = "percentage";
      }
    });
    nmb.setAction(new Action(){
      public void perform(){
        nChoiceMode = "number";
      }
    });
    TextField numberInput = new TextField(new RectArea(dpw(50),dph(40),dpw(18),dph(6)));
    numberInput.setFocus(true);
    Button testStart = new Button(new RoundArea(dpw(50),dph(70),dpw(4.5)),LIGHTRED,DARKRED);
    testStart.setText("test!",35,WHITE);
    testStart.setAction(new Action(){
      public void perform(){
        runStatus = "test";//进入测试模式
        println("Let's test");
        try{
          nChoiceInput = Integer.parseInt(widgets.getTextFieldInputs()[0]);//解析输入的数据
          if ( (nChoiceInput>100||nChoiceInput<0) && nChoiceMode.equals("percentage") ){
            NumberFormatException e = new NumberFormatException();
            throw e;
          }
        }catch(NumberFormatException e){
          e.printStackTrace();
          clearAll();
          runStatus = "numberChoice";
        }
        clearAll();
        //println("Ready to load");
        try{
          loadWords();//把范围内的单词加载进来
        }catch(Exception e){
          e.printStackTrace();
          runStatus = "rangeChoice";
        }
      }
    });
    widgetThres = true;
  }
  background(255);
  titleBar();
  if (nChoiceMode.equals("percentage")){
    fill(DARKBLUE);
    new RoundArea(dpw(41),dph(30),dpw(2)).drawSelf();
    fill(0);
    dpTextSize(24);
    textAlign(CENTER);
    text("The number you are inputting right now indicates the percentage of words you\nwould like to select from the scope",dpw(50),dph(50));
  }else if (nChoiceMode.equals("number")){
    fill(DARKBLUE);
    new RoundArea(dpw(59),dph(30),dpw(2)).drawSelf();
    fill(0);
    dpTextSize(24);
    textAlign(CENTER);
    text("The number you are inputting right now indicates the number of words you\nwould like to select from the scope",dpw(50),dph(50));
  }
  widgets.display();
}//This is the end of the page nChoice



void testPage(){//milestone, 开始编写测试页面了,
  if (widgetThres == false){
    println("correct: "+correct);
    println("wrong: "+wrong);
    //println("chosen: "+mChoosed.length()+" "+mChoosed);//shoud be 0 
    if (recorder.size()<totalWordCount){
      takeOneWord();
    }else{
      clearAll();
      runStatus = "outcome";
      return;
    }
    if (questionType!="multiple") {
      initializeSingleChoiceWidgets();
    }else{
      initializeMultipleChoiceWidgets();
    }
    Button next = new Button(new RoundArea(dpw(92.5),dph(8),dpw(3)),YELLOW,YELLOW);
    next.setText(">",48,0);
    next.setAction(new Action(){
      public void perform(){
        checkAnswer();
        clearAll();
      }
    });
    timer.start();
    widgetThres = true;
    check();//防止之前被切换成error的时候widgetThres被改回true，造成errorPage的widgetThres为true
    println("All set for widgets");
  }
  if (timer.stop()==true){
    checkAnswer();
    clearAll();
    return;
  }//如果时间到了，就没有必要运行接下来的布局了，可以直接进入下一题测试了
  if (questionType!="multiple") doubleClickSensor.detect();//只有单选题需要双击
  background(255);
  fill(LIGHTBLUE);
  rectMode(NORMAL);
  rect(0,0,dpw(100),dph(20));
  if (questionType.equals("CtoE")){
    dpTextSize(24);
    textFont(HEITI);
    fill(WHITE);
    textAlign(NORMAL);
    text(String.valueOf(recorder.size())+"."+"中译英",dpw(3),dph(5));
    text(trimText(currentTested.getDefinition()),dpw(3),dph(15));
  }else if(questionType.equals("EtoC")){
    dpTextSize(24);
    textFont(HEITI);
    fill(WHITE);
    textAlign(NORMAL);
    text(String.valueOf(recorder.size())+"."+"英译中",dpw(3),dph(5));
    textFont(DEFAULTFONT);
    text(currentTested.getWord(),dpw(3),dph(15));
    textFont(HEITI);
  }else if (questionType.equals("multiple")){
    dpTextSize(24);
    textFont(HEITI);
    fill(WHITE);
    textAlign(NORMAL);
    text(String.valueOf(recorder.size())+"."+"多选题（答案可能只有1个）",dpw(3),dph(5));
    textFont(DEFAULTFONT);
    text(currentTested.getWord(),dpw(3),dph(15));
    textFont(HEITI);
  }
  widgets.display();//一般来说display函数都放在最后，但是这里因为效果问题，所以放在这里
  //println("chosen: "+mChoosed.length()+" "+mChoosed);//shoud be 0 
  for (float i =25; i<100; i+=15){
      ellipseMode(CENTER);
      fill(DARKBLUE);
      ellipse(dpw(6),dph(i),dpw(5),dpw(5));
      fill(WHITE);
      dpTextSize(65);
      text((char)((int)((i-25)/15+'A')),dpw(6),dph(i+2));
  }
  if (widgetThres==false) loadingTitleBar();//如果即将进入加载，即widgetThres已在widgets.display()中被调成true
}//This is the end of the test page, woo~

void outcomePage(){
  if (widgetThres==false){
    int choice = randint(1,3);
    image21 = loadImage("pictures\\图片2"+String.valueOf(choice*2-1)+".jpg");
    image22 = loadImage("pictures\\图片2"+String.valueOf(choice*2)+".jpg");
    if (recorded == false){
      txtRecord();//如果没记录的话，将这次考试记录在文件里
      pdfRecord();
      recorded = true;
    }
    Button exitButton = new Button(new RoundArea(dpw(60),dph(60),dpw(5)),DARKRED,LIGHTRED); 
    exitButton.setText("Exit",50,0);
    exitButton.setAction(new Action(){
      public void perform(){
        exit();
      }
    });
    Button reviewButton = new Button(new RoundArea(dpw(40),dph(60),dpw(5)),DARKRED,LIGHTRED); 
    reviewButton.setText("Review",50,0);
    reviewButton.setAction(new Action(){
      public void perform(){
        try{
          Desktop.getDesktop().open(new File (folderPath()+"\\reports\\"+testerName+"\\"+pdfName+".pdf"));
        }catch (IOException e){
          e.printStackTrace();
        }
      }
    });
  widgetThres=true;
  }
  background(255);
  textFont(DEFAULTFONT);
  titleBar();
  dpTextSize(45);
  fill(0);
  text("Thanks for taking the test",dpw(50),dph(30));
  text("Your SCORE is:",dpw(50),dph(35));
  float percentage = (correct/(float)(totalWordCount))*100;
  text((int)(percentage)+"% correct",dpw(50),dph(40));
  imageMode(CENTER);
  image(image21,dpw(20),dph(50),dpw(18),dph(30));
  image(image22,dpw(80),dph(50),dpw(18),dph(30));
  widgets.display();
}//This is the end of the outcome page, Thanks for using

//This is the review page, a page to view the words
public void reviewPage(){
  
}//This is the end of the reviewPage() function



void historyPage(){
  if (widgetThres==false){
    widgetThres = true;
    heightAdj = 0;
    Button back = new Button(new RectArea(dpw(90),dph(90),dpw(13),dph(10)),DARKRED,LIGHTRED);
    back.setText("Back",43,255);
    back.setAction(new Action(){
      public void perform(){
        runStatus = "home";
        clearAll();
      }
    });
  }
  background(255);
  titleBar();
  translate(0,heightAdj);
  textAlign(NORMAL);
  dpTextSize(35);
  fill(0);
  int counter = 0;//这个用来记录历史记录的条数
  LinkedList<String> displayedHistories = new LinkedList<String>();
  try{
    BufferedReader historyIn = new BufferedReader(new InputStreamReader(new FileInputStream(folderPath()+"\\history\\General History.txt")));
    boolean stopRead = false;
    while(stopRead ==false){
      String record = historyIn.readLine();
      if (record==null){
        break;
      }else{
        record = decode (record);
        println("record: "+record);
        record = record.replaceAll("\t","  ");//replace tab with double spaces
        displayedHistories.add(0,record);
      }
    }
    historyIn.close();
  }catch(IOException e){
    e.printStackTrace();
  }
  for (String record: displayedHistories){
      counter++;
      text(record,dpw(2),dph(25)+dph(5)*counter);
  }
  if (keyPressed&&(keyCode==UP||key=='w')){
    if (heightAdj<0){
      heightAdj+=7;
      println("up");
    }
  }else if (keyPressed&&(keyCode==DOWN||key=='s')){
    if (heightAdj>displayHeight-dph(24+counter*5+3)){
      heightAdj-=7;
      println("down");
    }
  }
  widgets.display();
}

void questPage(){
  if (widgetThres==false){
    searchResults = new LinkedHashMap<String,WordUnit>();
    heightAdj = 0;
    TextField searchedWord = new TextField(new RectArea(dpw(42),dph(25),dpw(78),dph(5)));
    searchedWord.setFocus(true);
    searchedWord.setCharLimit(30);
    Button search = new Button(new RoundRectArea(dpw(92),dph(25),dpw(10),dph(1.5)),DARKRED, LIGHTRED);
    search.setText("search",30,255);
    search.setAction(new Action(){
      public void perform(){
        searchResults = searchInDicts(widgets.getTextFieldInputs()[0]);
      }
    });
    Button back = new Button(new RectArea(dpw(90),dph(90),dpw(13),dph(10)),DARKRED,LIGHTRED);
    back.setText("Back",43,255);
    back.setAction(new Action(){
      public void perform(){
        runStatus = "home";
        clearAll();
      }
    });
    widgetThres = true;
  }
  background(255);
  translate(0,heightAdj);
  int displayCount = 0;
  for (int i = 0; i<vocabBooks.length; i++){
    String bookName = vocabBooks[i];
    if (searchResults.containsKey(bookName)){
      displayCount++;
      WordUnit displayedResult = searchResults.get(bookName);
      fill(0);
      dpTextSize(35);
      textAlign(NORMAL);
      textFont(HEITI);
      text(bookName+" in list"+displayedResult.getListNumber(),dpw(2),dph(15+20*displayCount));
      text("中文释义: "+displayedResult.getDefinition(),dpw(2),dph(15+20*displayCount+5));
      text("词根词缀&记忆方法: "+displayedResult.getRoot(),dpw(2),dph(15+20*displayCount+10));
      text("其他注释: "+displayedResult.getAnnotation(),dpw(2),dph(15+20*displayCount+15));
      strokeWeight(dph(0.3));
      stroke(0);
      line(dpw(2),dph(15+20*displayCount+16),dpw(98),dph(15+20*displayCount+16));
    }
  }
  translate(0,-heightAdj);
  if (displayCount==0){
    println("no results");
    fill(0);
    dpTextSize(25);
    textAlign(NORMAL);
    textFont(HEITI);
    text("无搜索结果",dpw(2.5),dph(35));
  }
  if (keyPressed&&keyCode==UP){
    if (heightAdj<0){
      heightAdj+=7;
      println("up");
    }
  }else if (keyPressed&&keyCode==DOWN){
    if (heightAdj>displayHeight-dph(15+displayCount*20+17)){
      heightAdj-=7;
      println("down");
    }
  }
  noStroke();
  fill(255);
  rectMode(NORMAL);
  rect(0,0,dpw(100),dph(27.5));
  titleBar();
  widgets.display();
}