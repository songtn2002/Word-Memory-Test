class RectArea implements Drawable{

  protected float x;
  protected float y;
  protected float w;
  protected float h;
  
  public RectArea(float tx,float ty,float tw,float th){
    x=tx;
    y=ty;
    w=tw;
    h=th;
  }
  
  public boolean hasMouse(){
    if (abs(mouseX-x)<(w/2) && abs(mouseY-y)<(h/2)){
      return true;
    }else{
      return false;
    }
  }
  
  public boolean hasMousePressed(){
    return this.hasMouse()&&mousePressed;
  }
  
  public void drawSelf(){
    rectMode(CENTER);
    strokeJoin(BEVEL);
    rect(x,y,w,h);
  }
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  public float getW(){
    return this.w;
  }
  
  public float getH(){
    return this.h;
  }
}

class RoundArea implements Drawable{
  private float x;
  private float y;
  private float r;
  
  public RoundArea(float tx,float ty,float tr){
    x=tx;
    y=ty;
    r=tr;
   
  }
  
  public boolean hasMouse(){
    if (dist(mouseX,mouseY,x,y)<=r){
      return true;
    }else{
      return false;
    }
  }
  
  public boolean hasMousePressed(){
    return this.hasMouse()&&mousePressed;
  }
  
  public void drawSelf(){
    ellipseMode(CENTER);
    ellipse(x,y,r*2.0,r*2.0);
  }
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  public float getR(){
    return this.r;
  }
  
  public float getW(){
    return this.r*2.0;
  }
  
  public float getH(){
    return this.r*2.0;
  }
}

class RoundRectArea extends RectArea{
  
  public RoundRectArea(float tx,float ty,float tw,float th){
    super(tx,ty,tw,th);
  }
  
  public void drawSelf(){
    rectMode(CENTER);
    roundRect(this.x, this.y, this.w, this.h);
  }
}

interface Drawable{
  public float getX();
  public float getY();
  public boolean hasMouse();
  public boolean hasMousePressed();
  public void drawSelf();
  public float getW();
  public float getH();
}