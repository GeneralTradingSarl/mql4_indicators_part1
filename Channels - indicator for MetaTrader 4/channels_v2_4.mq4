//+------------------------------------------------------------------+
//|                                                  _indicatren.mq4 |
//|                      Copyright © 2009, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

//---- input parameters
extern int       period1=60;
extern int       period2=240;
extern int       period3=1440;

int tmin1, tmax1,tmin2, tmax2, period;
double max1, min1,max2, min2, up, down;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   period=period1; del();
   period=period2; del();
   period=period3; del();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int del()
{
   ObjectDelete("sup"+DoubleToStr(period,0));
   ObjectDelete("mid"+DoubleToStr(period,0));
   ObjectDelete("res"+DoubleToStr(period,0));
   ObjectDelete("up"+DoubleToStr(period,0));
   ObjectDelete("down"+DoubleToStr(period,0));
   return(0);
}


int main()
{
   int i, k, m;
   
   k=1; m=1;
  
   for(i=3; i<iBars(NULL, period)-3; i++)      
   {
      if (iLow(NULL, period,i-2)>iLow(NULL, period,i)&&iLow(NULL, period,i+2)>iLow(NULL, period,i)
      &&iLow(NULL, period,i-1)>=iLow(NULL, period,i)&&iLow(NULL, period,i+1)>iLow(NULL, period,i)&&k<3)
      if (k==1){ tmin1=i;  min1=iLow(NULL, period,i);      k=k+1;}
      else 
      if(i>tmin1+2){ tmin2=i;  min2=iLow(NULL, period,i);k=k+1;}
      
      if (k==3) break;
   }
   
   for(i=3; i<iBars(NULL, period)-3; i++)      
   {
      if (iHigh(NULL, period,i-2)<iHigh(NULL, period,i)&&iHigh(NULL, period,i+2)<iHigh(NULL, period,i)
      &&iHigh(NULL, period,i-1)<=iHigh(NULL, period,i)&&iHigh(NULL, period,i+1)<iHigh(NULL, period,i)&&m<3)
      if (m==1){ tmax1=i;  max1=iHigh(NULL, period,i);      m=m+1;}
      else 
      if(i>tmax1+2){ tmax2=i;  max2=iHigh(NULL, period,i);m=m+1;}
      
      if (m==3) break;
    }
     
   if ( MathAbs( (max1-max2)/(tmax1-tmax2) )>MathAbs( (min1-min2)/(tmin1-tmin2) ) )
   
   if (max1<max2)
   max1=max2+(min1-min2)/(tmin2-tmin1)*(tmax2-tmax1);
   else
   max2=max1+(min1-min2)/(tmin2-tmin1)*(tmax1-tmax2);
   
   else
   
   if (min1>min2)
   min1=min2-(max2-max1)/(tmax2-tmax1)*(tmin2-tmin1);
   else
   min2=min1-(max2-max1)/(tmax2-tmax1)*(tmin1-tmin2);
   
   
   up=max1+(max2-max1)/(tmax2-tmax1)*(0-tmax1);
   down=min1+(min2-min1)/(tmin2-tmin1)*(0-tmin1);
   
   
   set("sup"+DoubleToStr(period,0), OBJ_TREND,iTime(NULL, period,tmin2),min2,iTime(NULL, period1,0),down);  
   set("res"+DoubleToStr(period,0), OBJ_TREND,iTime(NULL, period,tmax2),max2,iTime(NULL, period1,0),up);
   
   set("mid"+DoubleToStr(period,0), OBJ_TREND,
   iTime(NULL, period,(tmin2+tmax2)/2),(min2+max2)/2,iTime(NULL, period1,0),(down+up)/2);
   ObjectSet("mid"+DoubleToStr(period,0),OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("mid"+DoubleToStr(period,0),OBJPROP_COLOR, Black);
   
   if(period==period3)
   {
   ObjectSet("res"+DoubleToStr(period,0),OBJPROP_WIDTH,3);
   ObjectSet("sup"+DoubleToStr(period,0),OBJPROP_WIDTH,3);
   }
   
   if(period==period2)
   {
   ObjectSet("res"+DoubleToStr(period,0),OBJPROP_WIDTH,2);
   ObjectSet("sup"+DoubleToStr(period,0),OBJPROP_WIDTH,2);
   }
   
   ObjectSet("res"+DoubleToStr(period,0),OBJPROP_RAY,false);
   ObjectSet("mid"+DoubleToStr(period,0),OBJPROP_RAY,false);
   ObjectSet("sup"+DoubleToStr(period,0),OBJPROP_RAY,false);
   
   
   
   set("up"+DoubleToStr(period,0),OBJ_TEXT,Time[0],up, 0, 0);
   ObjectSetText("up"+DoubleToStr(period,0),"              "+ DoubleToStr(up, 4), 12, "Times New Roman", Blue);

   set("down"+DoubleToStr(period,0),OBJ_TEXT,Time[0],down,0, 0);
   ObjectSetText("down"+DoubleToStr(period,0),"              "+ DoubleToStr(down,4), 12, "Times New Roman", Red);
   
   return(0);
}

void set(string s,int object, datetime t1, double p1, datetime t2, double p2)
{
   if (ObjectFind(s) != 0) 
     {
      ObjectCreate(s,object,0,t1, p1, t2, p2);
     }
     else
     {
     ObjectDelete(s);
     ObjectCreate(s,object,0,t1, p1, t2, p2);
     }
   ObjectSet(s,OBJPROP_COLOR, Silver);
   return(0);
}

int start()
  {
   static datetime	LastTime;
   if(Time[0] == LastTime) return;
   
   period=period1;main();
   period=period2;main();
   period=period3;main();
   
   LastTime = Time[0];
   return(0);
  }
//+------------------------------------------------------------------+