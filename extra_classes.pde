interface Action{
  public void perform();
}

static class WordUnit{  
 
  private String word;
  private String definition;
  private String root;
  private int listNumber;
  private String annotation;
  public static float maxSim;
  
  public WordUnit(String word, String definition, String root,int listNumber,String annotation) {
    this.word = word;
    this.definition = definition;
    this.root = root;
    this.listNumber = listNumber;
    this.annotation = annotation;
  }
  
  public WordUnit(String definition){
    this("",definition,-1,"");  
  }
  
  public WordUnit(String word, String definition,int listNumber,String annotation) {
    this.word = word;
    this.definition = definition;
    this.root = "";
    this.listNumber = listNumber;
    this.annotation = annotation;
  }
  
  private static boolean notEnglish(String str){
    char[] chars = str.toCharArray();
    for (char c:chars){
      if (!((c>='a'&&c<='z')||(c>='A'&&c<='Z')||c=='-'||c=='.'||c=='/'||c=='_')){
        return true;
      }
    }
    return false;
  }
  
  private static boolean isEnglish(String str){
    char[] chars = str.toCharArray();
    for (char c:chars){
      if (!((c>='a'&&c<='z')||(c>='A'&&c<='Z')||c=='-'||c=='/'||c=='.'||c=='_')){
        return false;
      }
    }
    return true;
  }
  
  private static boolean isNumber(String str){
    char[] chars = str.trim().toCharArray();
    for (char c:chars){
      if (c<'0'||c>'9'){
        return false;
      }
    }
    return true;
  }
  
  public static WordUnit parseWord(String line){
    String word="";
    String def="";
    String root="";
    int listNumber=0;
    String annotation="";
    String[] fragments = line.split("\t");
    for (int i =0; i<fragments.length; i++){
      String tested = fragments[i];
      if ( (tested.contains("=")||notEnglish(tested)) &&i==0){
        root = tested;
      }else if(isEnglish(tested)&&(i==0||i==1)) {
        word = tested;
      }else if ( (i==fragments.length-1||i==fragments.length-2) &&isNumber(tested)){
        try{
          listNumber = Integer.parseInt(tested.trim());
        }catch(Exception e){
          //println(line);
        }
      }else if (i==fragments.length-1&&(!isNumber(tested))){
        annotation = tested;
      }else{
        def = tested;
      }
    }
    return new WordUnit(word,def,root,listNumber,annotation);
  }
  
  public float getSimilarityWith(WordUnit another){
    maxSim = 0;
    String a = this.word;
    String b = another.word;
    return comp(a,b,0,0,0);
  }
  
  public ArrayList<WordUnit> getDefAsWordUnits(){//这个方法有点长，的确需要注释
    ArrayList<WordUnit> result = new ArrayList<WordUnit>();
    String s = this.definition;
    s = s.replaceAll("\"","");
    //第一部分，读入意思并去掉引号
    s = s.replaceAll(" ","");
    char[] charA = s.toCharArray();//把引号和空格去掉
    StringBuilder builder = new StringBuilder();
    int recorder = 0;
    boolean filter = true;//用来把'［'和'['和'【'过滤掉
    for (int k = 0; k<charA.length; k++){//这是最新版的改动，c变成了一个字符串，而非字符，用来对付"..."
      String c = String.valueOf(charA[k]);
      if (charA[k]=='.'){//这一段代码相当不友善，小心了
       int counter = 0;
       for (int f = k+1; f<charA.length; f++){
         if(charA[f]=='.'){
           c = c+charA[f];
           k++;
         }else{
           if (counter!=0){
             c = c+charA[f];
             k++;
           }
           break;
         }
         counter++;
       }
      }
      if (recorder == 0 && notEnglish(c)){
        builder.append(c);
        recorder++;
      }else if (recorder == 1 && isEnglish(c)&&filter == true){
        result.add(new WordUnit(builder.toString()));
        recorder = 0;
        builder = new StringBuilder(c);
      }else{
        builder.append(c);
      }
      if (c.equals("［")||c.equals("[")||c.equals("【")||c.equals("(")||c.equals("（")){//因为我把变量c改成了String类型，所以这里的东东也要变成String
        filter = false;
      }else if (c.equals("］")||c.equals("]")||c.equals("】")||c.equals(")")||c.equals("）")){
        filter = true;
      }
    }
    if(!builder.toString().equals("")){//别漏了最后一段
      result.add(new WordUnit(builder.toString()));
    }
    /*
    以上一部分是第二段，每次从英文字母开始，到中文，再到下一个英文字母时,将现有的字符串打包成WordUnit放入result中，
    并重新开始一个包含这个英语字母的StringBuilder
    */
    ArrayList<WordUnit> appended = new ArrayList<WordUnit>();
    ArrayList<WordUnit> deleted = new ArrayList<WordUnit>();
    deleted.addAll(result);
    for (WordUnit wu: result){
      String def = wu.getDefinition();
      //println("def:"+def);
      StringBuilder ac = new StringBuilder();
      for(int i =0; i<def.length(); i++){//这个for循环用来把词的词性找出来
        char c = def.charAt(i);
        if ( (c>='a'&&c<='z') || (c<='Z'&&c>='A')){
          ac.append(c);
        }else{
          break;
        }
      }
      String chara = ac.toString();
      if (def.charAt(chara.length())=='.') chara = chara+".";
      //println("chara! "+chara);
      StringTokenizer st = new StringTokenizer(def.substring(chara.length()),"；;");
      while(st.hasMoreTokens()){
        if (chara.length()>0){
          if(chara.charAt(chara.length()-1)=='.'){
            appended.add(new WordUnit(chara+st.nextToken()));
          }else{
            appended.add(new WordUnit(chara+"."+st.nextToken()));
          }
        }else{
          appended.add(new WordUnit(st.nextToken()));
        }
      }
    }
    /*
    第2步中仅仅做到把，不同词性的意思分段，而这里，第三部分是要把同词性的不同意思分段，StringTokenizer起到了关键作用
    */
    result.addAll(appended);
    result.removeAll(deleted);
    return result;
  }
  
  public float getSimilarityWith(WordUnit another, int startIndex){
    maxSim = 0;
    String a = this.word;
    String b = another.word;
    return comp(a,b,startIndex,startIndex,0);
  }
  
  private static float comp(String a , String b, int indexA, int indexB, int sim){
    if (indexA>=a.length()||indexB>=b.length()){
      float res = sim*2.0/(a.length()+b.length());
      if (res > maxSim){
        maxSim = res;
      }
      return maxSim;
    }
    
    char currentA = a.charAt(indexA);
    char currentB = b.charAt(indexB);
    
    if (currentA==currentB){
      comp(a,b,indexA+1,indexB+1,sim+1);
    }else{
      comp(a,b,indexA+1,indexB+1,sim);
    }
    
    comp(a,b,indexA+1,indexB,sim);
    comp(a,b,indexA,indexB+1,sim);
    
    return maxSim;
  }
  
  /*
  This stands for former contains later
  */
  public static boolean FContainsL(ArrayList<WordUnit> correctDefs, WordUnit tested){
    for (WordUnit wu: correctDefs){
      if (wu.equals(tested)){
        return true;
      }
    }
    return false;
  }
  
  public static boolean isInChoices(WordUnit a, WordUnit[] choices){
    boolean result = false;
    for (WordUnit wu: choices){
      if (wu==null){
        continue;
      }
      if (wu.equals(a)){
        result = true;
        break;
      }
    }
    return result;
  }
  
  public String toString(){
    return this.word+" means "+definition+" is in list "+listNumber+" has roots "+ root+" has extra annotation "+annotation;
  }
  
  public boolean equals(WordUnit another){
    if (another==null){
      return false;
    }else{
      //println(this.word+" = "+another.word);
      return this.word.equals(another.getWord())&&this.definition.equals(another.definition);
    }
  }
  
  public String getWord() {
    return this.word;
  }
  
  public String getDefinition() {
    return this.definition;
  }
  
  public String getRoot() {
    return this.root;
  }
  
  public String getAnnotation(){
    return this.annotation;
  }
  
  public int getListNumber(){
    return this.listNumber;
  }
}

class WordSimComp implements Comparator<WordUnit>{
  
  private WordUnit compared;
  private int startIndex;
  
  public WordSimComp(WordUnit compared,int startIndex){
    this.compared = compared;
    this.startIndex = startIndex;
  }
  
  public int compare(WordUnit a, WordUnit b){
    return (int)((a.getSimilarityWith(compared,startIndex)-b.getSimilarityWith(compared,startIndex))*100);
  }
}

class TestTimer{
  
  private long startTime;
  
  public TestTimer(){}
  
  public void start(){
    startTime = millis();
  }
  
  public boolean stop(){
    int timeLimit = 0;
    if(questionType!="multiple"){
      timeLimit = 6000;
    }else{
      timeLimit = 10000;
    }
    return millis()-startTime>timeLimit;
  }
}

class DoubleClickSensor{
  private long firstClick;
  private Action action;
  private boolean isOn;
  
  public DoubleClickSensor(){
    this.firstClick = 0;
    this.isOn = false;
  }
  
  public void setAction(Action action){
    this.action = action;
  }
  
  public void switchOn(){
    this.isOn=true;
  }
  
  public void detect(){
    if (isOn==false){
      return;
    }
    if (clickThres==true&&mousePressed){
      if (firstClick==0){
        firstClick = millis();
        //println("A first click is recorded");
      }else{
        if (millis()-firstClick<500){
          action.perform();
        }else{
          firstClick = millis();
        }
      }
    }
  }
}

class MistakeRecord{
  
  private String correctAnswer;
  private String yourAnswer;
  private String questionType;
  private WordUnit[] choices;
  private WordUnit currentTested;
  
  public MistakeRecord(WordUnit currentTested, String correctAnswer,String yourAnswer, String questionType, WordUnit[] choices){
    this.correctAnswer = correctAnswer;
    this.yourAnswer = yourAnswer;
    this.questionType = questionType;
    this.choices = choices;
    this.currentTested = currentTested;
  }
  
  public String getCorrectAnswer(){
    return this.correctAnswer;
  }
  
  public String getYourAnswer(){
    return this.yourAnswer;
  }
  
  public String getQuestionType(){
    return this.questionType;
  }
  
  public WordUnit[] getChoices(){
    return choices;
  }
  
  public WordUnit getChoice(char c){
    return choices[c-'A'];
  }
  
  public WordUnit getCurrentTested() {
    return currentTested;
  }
}