//+------------------------------------------------------------------+
//|                                                       Fract1.mq4 |
//|                                            Copyright 2015, Kabul |
//|                                               panji_xx@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Kabul"
#property link      "panji_xx@yahoo.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

input int    X_distance=770; 
input int    Y_distance=25; 

int    X_dist,Y_dist;
int    kstrok,kdown;

double M1[5],M5[3],M15[2],M30[2],M60[4],M240[6],M1440[5];
double M1max,M1min,M1ave,M5max,M5min,M5ave,M15max,M15min,M15ave,M30max,M30min,M30ave;
double M60max,M60min,M60ave,M240max,M240min,M240ave,M1440max,M1440min,M1440ave;
color  wrn;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
     EventSetTimer(1);
     X_dist=X_distance;
     Y_dist=Y_distance;
     return(INIT_SUCCEEDED);
  }
  
int deinit()
  {

  for(int i=1;i<44;i++)
    {
     ObjectDelete(StringConcatenate("Text"+IntegerToString(i)));
    }

  for(int i=0;i<4;i++)
    {
     ObjectDelete(StringConcatenate("M1"+IntegerToString(i)));
     ObjectDelete(StringConcatenate("M5"+IntegerToString(i)));
     ObjectDelete(StringConcatenate("M15"+IntegerToString(i)));
     ObjectDelete(StringConcatenate("M30"+IntegerToString(i)));
     ObjectDelete(StringConcatenate("M60"+IntegerToString(i)));
     ObjectDelete(StringConcatenate("M240"+IntegerToString(i)));
     ObjectDelete(StringConcatenate("M1440"+IntegerToString(i)));
    } 

      return(0);    
  }  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
  
void OnChartEvent(const int id,         // Event identifier  
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
                  
{
    if (id==CHARTEVENT_KEYDOWN)
     {
        kstrok=lparam;kdown=StringToInteger(sparam);
     }     
     
    if ((id==CHARTEVENT_CLICK)&&(kstrok==77)&&(kdown==16434))
     {
       X_dist=lparam;Y_dist=dparam;
       kstrok=0;kdown=0;
     }
}  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
    SetText("Text1","High Daily : ",X_dist,Y_dist,clrWhite,12,"Arial Black");
    SetText("Text2","Low  Daily : ",X_dist,Y_dist+20,clrWhite,12,"Arial Black");
 
    SetText("Text4",DoubleToString(iHigh(NULL,1440,0),Digits),X_dist+105,Y_dist,clrWhite,12,"Arial Black");
    SetText("Text5",DoubleToString(iLow(NULL,1440,0),Digits),X_dist+105,Y_dist+20,clrWhite,12,"Arial Black");
 
  
    HiLoCnd();
    
    SetText("Text7","Max",X_dist,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text8","Min",X_dist,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text9","Ave",X_dist,Y_dist+100,clrWhite,8,"Arial");

    SetText("Text40","3",X_dist,Y_dist+130,clrWhite,8,"Arial");
    SetText("Text41","2",X_dist,Y_dist+140,clrWhite,8,"Arial");
    SetText("Text42","1",X_dist,Y_dist+150,clrWhite,8,"Arial");
    SetText("Text43","0",X_dist,Y_dist+160,clrWhite,8,"Arial");
    
    SetText("Text10",DoubleToString(M1max,0),X_dist+25,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text11",DoubleToString(M1min,0),X_dist+25,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text12",DoubleToString(M1ave,0),X_dist+25,Y_dist+100,clrWhite,8,"Arial");    
    
    SetText("Text13",DoubleToString(M5max,0),X_dist+45,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text14",DoubleToString(M5min,0),X_dist+45,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text15",DoubleToString(M5ave,0),X_dist+45,Y_dist+100,clrWhite,8,"Arial");       
    
    SetText("Text16",DoubleToString(M15max,0),X_dist+65,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text17",DoubleToString(M15min,0),X_dist+65,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text18",DoubleToString(M15ave,0),X_dist+65,Y_dist+100,clrWhite,8,"Arial");             
    
    SetText("Text19",DoubleToString(M30max,0),X_dist+87,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text20",DoubleToString(M30min,0),X_dist+87,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text21",DoubleToString(M30ave,0),X_dist+87,Y_dist+100,clrWhite,8,"Arial");                 
    
    SetText("Text22",DoubleToString(M60max,0),X_dist+109,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text23",DoubleToString(M60min,0),X_dist+109,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text24",DoubleToString(M60ave,0),X_dist+109,Y_dist+100,clrWhite,8,"Arial");                    
    
    SetText("Text25",DoubleToString(M240max,0),X_dist+131,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text26",DoubleToString(M240min,0),X_dist+131,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text27",DoubleToString(M240ave,0),X_dist+131,Y_dist+100,clrWhite,8,"Arial");                          
    
    SetText("Text28",DoubleToString(M1440max,0),X_dist+153,Y_dist+70,clrWhite,8,"Arial");
    SetText("Text29",DoubleToString(M1440min,0),X_dist+153,Y_dist+85,clrWhite,8,"Arial");
    SetText("Text30",DoubleToString(M1440ave,0),X_dist+153,Y_dist+100,clrWhite,8,"Arial");                         
    
    SetText("Text31","M1 M5  M15 M30 1H   4H   1D",X_dist+25,Y_dist+115,clrWhite,8,"Arial");    
    
    MakePanel(X_dist+25,Y_dist+160);                         
    
    SetText("Text32","Now",X_dist,Y_dist+180,clrWhite,8,"Arial");
    
    warna((iHigh(NULL,1,0)-iLow(NULL,1,0))/Point,M1ave,M1max);
    SetText("Text33",DoubleToString((iHigh(NULL,1,0)-iLow(NULL,1,0))/Point,0),X_dist+25,Y_dist+180,wrn,8,"Arial");
    warna((iHigh(NULL,5,0)-iLow(NULL,5,0))/Point,M5ave,M5max);
    SetText("Text34",DoubleToString((iHigh(NULL,5,0)-iLow(NULL,5,0))/Point,0),X_dist+45,Y_dist+180,wrn,8,"Arial");
    warna((iHigh(NULL,15,0)-iLow(NULL,15,0))/Point,M15ave,M15max);
    SetText("Text35",DoubleToString((iHigh(NULL,15,0)-iLow(NULL,15,0))/Point,0),X_dist+65,Y_dist+180,wrn,8,"Arial");
    warna((iHigh(NULL,30,0)-iLow(NULL,30,0))/Point,M30ave,M30max);
    SetText("Text36",DoubleToString((iHigh(NULL,30,0)-iLow(NULL,30,0))/Point,0),X_dist+87,Y_dist+180,wrn,8,"Arial");
    warna((iHigh(NULL,60,0)-iLow(NULL,60,0))/Point,M60ave,M60max);
    SetText("Text37",DoubleToString((iHigh(NULL,60,0)-iLow(NULL,60,0))/Point,0),X_dist+109,Y_dist+180,wrn,8,"Arial");
    warna((iHigh(NULL,240,0)-iLow(NULL,240,0))/Point,M240ave,M240max);
    SetText("Text38",DoubleToString((iHigh(NULL,240,0)-iLow(NULL,240,0))/Point,0),X_dist+131,Y_dist+180,wrn,8,"Arial");
    warna((iHigh(NULL,1440,0)-iLow(NULL,1440,0))/Point,M1440ave,M1440max);
    SetText("Text39",DoubleToString((iHigh(NULL,1440,0)-iLow(NULL,1440,0))/Point,0),X_dist+153,Y_dist+180,wrn,8,"Arial");
    
  }
//+------------------------------------------------------------------+



void SetText(string name,string text,int x,int y,color colour,int fontsize=12, string fontname="Arial")
  {
     ObjectDelete(name);
   if(ObjectCreate(0,name,OBJ_LABEL,0,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
      ObjectSetString(0,name,OBJPROP_FONT,fontname);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
     }
   ObjectSetString(0,name,OBJPROP_TEXT,text);
  }
  

 
 void HiLoCnd()
 {
   int hit;
   M1ave=0;M5ave=0;M15ave=0;M30ave=0;M60ave=0;M240ave=0;M1440ave=0;
   M1max=0;M5max=0;M15max=0;M30max=0;M60max=0;M240max=0;M1440max=0;
   M1min=10000;M5min=10000;M15min=10000;M30min=10000;M60min=10000;M240min=10000;M1440min=10000;
   for (hit=1;hit<6;hit++)
    {
      M1[hit-1]=(iHigh(NULL,1,hit)-iLow(NULL,1,hit))/Point;    
      M1ave=M1ave+M1[hit-1];
      if(M1max<M1[hit-1]) {M1max=M1[hit-1];}
      if(M1min>M1[hit-1]) {M1min=M1[hit-1];}
    }

      M1ave=M1ave/5;
   for (hit=1;hit<4;hit++)
    {
      M5[hit-1]=(iHigh(NULL,5,hit)-iLow(NULL,5,hit))/Point;    
      M5ave=M5ave+M5[hit-1];
      if(M5max<M5[hit-1]) {M5max=M5[hit-1];}
      if(M5min>M5[hit-1]) {M5min=M5[hit-1];}      
    }    

      M5ave=M5ave/3;    
   for (hit=1;hit<3;hit++)
    {
      M15[hit-1]=(iHigh(NULL,15,hit)-iLow(NULL,15,hit))/Point;    
      M15ave=M15ave+M15[hit-1];
      if(M15max<M15[hit-1]) {M15max=M15[hit-1];}
      if(M15min>M15[hit-1]) {M15min=M15[hit-1];}
    }    

      M15ave=M15ave/2;    
    
   for (hit=1;hit<3;hit++)
    {
      M30[hit-1]=(iHigh(NULL,30,hit)-iLow(NULL,30,hit))/Point;    
      M30ave=M30ave+M30[hit-1];
      if(M30max<M30[hit-1]) {M30max=M30[hit-1];}
      if(M30min>M30[hit-1]) {M30min=M30[hit-1];}      
    }    

      M30ave=M30ave/2;    
    
   for (hit=1;hit<5;hit++)
    {
      M60[hit-1]=(iHigh(NULL,60,hit)-iLow(NULL,60,hit))/Point;    
      M60ave=M60ave+M60[hit-1];
      if(M60max<M60[hit-1]) {M60max=M60[hit-1];}
      if(M60min>M60[hit-1]) {M60min=M60[hit-1];}      
    }    

      M60ave=M60ave/4;
          
   for (hit=1;hit<7;hit++)
    {
      M240[hit-1]=(iHigh(NULL,240,hit)-iLow(NULL,240,hit))/Point;    
      M240ave=M240ave+M240[hit-1];
      if(M240max<M240[hit-1]) {M240max=M240[hit-1];}
      if(M240min>M240[hit-1]) {M240min=M240[hit-1];}      
    }    

      M240ave=M240ave/6;    
    
   for (hit=1;hit<6;hit++)
    {
      M1440[hit-1]=(iHigh(NULL,1440,hit)-iLow(NULL,1440,hit))/Point;    
      M1440ave=M1440ave+M1440[hit-1];
      if(M1440max<M1440[hit-1]) {M1440max=M1440[hit-1];}
      if(M1440min>M1440[hit-1]) {M1440min=M1440[hit-1];}      
    }    

      M1440ave=M1440ave/5;    
 }
 
 
 
   void MakePanel(int posx, int posy)
  {
     int x,y,i;
     int tf[7];
     tf[0]=1;tf[1]=5;tf[2]=15;tf[3]=30;tf[4]=60;tf[5]=240;tf[6]=1440;

     y=0;x=20;
     
      for (y=0;y<7;y++)
       {
        for (i=0;i<4;i++)
        {
          if (y>3) {x=22;}
          if (y==3) {x=21;}
          ObjectDelete("M"+IntegerToString(tf[y])+IntegerToString(i));
          if (iOpen(NULL,tf[y],i)<iClose(NULL,tf[y],i))
           {
             SetPanel("M"+IntegerToString(tf[y])+IntegerToString(i),0,posx+(y*x),posy-(i*10),10,10,clrLime,clrBlack,1);              
           }
           
          if (iOpen(NULL,tf[y],i)>=iClose(NULL,tf[y],i))
           {
             SetPanel("M"+IntegerToString(tf[y])+IntegerToString(i),0,posx+(y*x),posy-(i*10),10,10,clrRed,clrBlack,1);              
           }           
        }
       }
  }
  
  
void SetPanel(string name,int sub_window,int x,int y,int width,int height,color bg_color,color border_clr,int border_width)
  {
   if(ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,name,OBJPROP_COLOR,border_clr);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,border_width);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(0,name,OBJPROP_SELECTED,0);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
     }
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg_color);
  }  
  
void warna(double inow, double ave, double imax)
{
  wrn=clrWhite;
  if (inow>=ave) {wrn=clrLime;}
  if (inow>=imax) {wrn=clrRed;}
}  