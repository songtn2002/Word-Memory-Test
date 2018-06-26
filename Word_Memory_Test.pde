import java.io.IOException;
import java.io.File;
import java.io.InputStreamReader;
import java.util.StringTokenizer;
import java.util.stream.Stream;
import java.util.Arrays;
import java.io.FileInputStream;
import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.Iterator;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.awt.event.KeyEvent;
import java.util.LinkedList;
import java.util.LinkedHashMap;
import processing.pdf.*;


PImage logo; 
String runStatus = "home";//may also be "rangeChoice","error"
final color LIGHTRED = color(255,25,25);
final color DARKRED = color(205,0,0);
final color LIGHTBLUE = color(0,168,255);
final color DARKBLUE = color(7,112,237);
final color TRANSBLUE = color (3,198,255,155);
final color YELLOW = color(250,255,3);
final color WHITE = color(255);
final color ALPHA = color(255,255,255,0);
PFont  HEITI;
PFont  DEFAULTFONT;
boolean widgetThres = false;

WidgetSet widgets;
DoubleClickSensor doubleClickSensor =new DoubleClickSensor();

//input restrictions for textFields
char prevK = ' ';
long lastKPressed = 0;
boolean inputLock = true;
boolean inputThres = true;
boolean prevMousePressed = false;
boolean curMousePressed = false;
boolean clickThres = false;


//Selection related variables
String[] rangeInputs;
String testerName;
String selectedBookName;
int upperLimit;
int lowerLimit;
String nChoiceMode = "number";
float nChoiceInput;
String[] vocabBooks;

//Math related declarations
float dpw(float percentage){
  return percentage/100.0*displayWidth;
}

float dph(float percentage){
  return percentage/100.0*displayHeight;
} 


int randint(int a, int b){
  return (int)random(a,b+0.9999);
}

//Testing related declarations
ArrayList<WordUnit> testedWords = new ArrayList<WordUnit>();
LinkedList<WordUnit> entireBook = new LinkedList<WordUnit>();//之所以要把整本书读进来，是因为，选相似的词要用到
ArrayList<Integer> recorder = new ArrayList<Integer>();
int totalWordCount;
char choosed = ' ';
String mChoosed = "";//这个变量记录多选的选择
WordUnit currentTested;
WordUnit[] choices = new WordUnit[5];
ArrayList<WordUnit> correctDefs; //这个变量是用来记录多选题的正确答案的
TestTimer timer = new TestTimer();
String questionType = "";
Button buttonA;
Button buttonB;
Button buttonC;
Button buttonD;
Button buttonE;
SButton SButtonA;
SButton SButtonB;
SButton SButtonC;
SButton SButtonD;
SButton SButtonE;
int correct = 0;
int wrong = 0;
int dice1 = -1;//这个变量，dice1是被抽取的词在testedWords中的位置

//reviewPage related decalrations
ArrayList<MistakeRecord> mistakes = new ArrayList<MistakeRecord>();
int heightAdj = 0;
boolean recorded = false;
PGraphicsPDF pdfReport;

//images
PImage image11;
PImage image12;
PImage image21;
PImage image22;

//quest page related declartions
LinkedHashMap<String,WordUnit> searchResults = new LinkedHashMap<String,WordUnit>();

//timeCheck related declarations, 检查是否间隔15分钟
int timeGap = 0;

void setup(){
  //First part of set up, load the controlP5 and set the entire environment up建立环境
  fullScreen();
  smooth(22);
  frameRate(200);
  //Second part of set up, load images and initialize variables初始化变量
  logo = loadImage("logo.jpg");
  widgets = new WidgetSet();
  HEITI = createFont("simhei.ttf",48);
  DEFAULTFONT = createFont("lsans.ttf",48);
  check();
  vocabBooks = loadAvailableVocabBooks();
  //searchInDicts("measure");
}

void draw(){
  if (runStatus.equals("home")){
    homePage();
  }else if (runStatus.equals("rangeChoice")){
    rChoicePage();
  }else if (runStatus.equals("error")){
    errorPage();
  }else if (runStatus.equals("numberChoice")){
    nChoicePage();
  }else if (runStatus.equals("test")){
    testPage();
  }else if (runStatus.equals("outcome")){
    outcomePage();
  }else if (runStatus.equals("review")){
    reviewPage();
  }else if (runStatus.equals("history")){
    historyPage();
  }else if (runStatus.equals("quest")){
    questPage();
  }else if (runStatus.equals("timeError")){
    timeErrorPage();
  }
  //if (inputThres == true) println("input!");
}