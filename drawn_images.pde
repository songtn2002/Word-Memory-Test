void historyImage(float x, float y,float scale){
  strokeWeight(dpw(0.9)*scale);
  stroke(255);
  noFill();
  ellipse(x,y,dpw(11)*scale,dpw(11)*scale);
  fill(255);
  noStroke();
  ellipse(x,y,dpw(2)*scale,dpw(2)*scale);
  strokeWeight(dpw(1.3));
  stroke(255);
  line(x,y,x,y-dpw(4)*scale);
  line(x,y,x+dpw(4)*scale,y);
  fill(255);
  textAlign(CENTER);
  textFont(DEFAULTFONT);
  dpTextSize(45);//设置字体一定要用dpTextSize()
  text("History",x,y+dph(17));
}

void roundRect(float x, float y, float w, float h ){
  strokeJoin(ROUND);
  strokeCap(ROUND);
  stroke(g.fillColor);
  strokeWeight(dph(5));
  rect(x,y,w,h);
}

void questImage(float x, float y, float scale){
  text("Quest",x,y+dph(17));
  strokeWeight(dpw(1.2)*scale);
  stroke(255);
  noFill();
  float diam = dpw(10)*scale;
  ellipse(x,y-dph(3),diam,diam);
  translate(x,y-dph(3));
  rotate(45);
  strokeCap(ROUND);
  line(diam/2,0,diam/2+dpw(4)*scale, 0);
  translate(-x,-y);
  rotate(-45);
  fill(255);
  textAlign(CENTER);
  textFont(DEFAULTFONT);
  dpTextSize(45);
}