//+------------------------------------------------------------------+
//|                                                   CheckPower.mq4 |
//|                           Copyright 2013, rockyhoangdn@gmail.com |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, rockyhoangdn@gmail.com"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 FireBrick
#property indicator_color3 Aqua
#property indicator_color4 Yellow
#property indicator_width1 0
#property indicator_width2 0
#property indicator_width3 0
#property indicator_width4 0
double Bulls[];
double Bears[];
double LongEntry[];
double ShortEntry[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexBuffer(0,Bulls);
   SetIndexBuffer(1,Bears);
   SetIndexBuffer(2,LongEntry);
   SetIndexBuffer(3,ShortEntry);
   SetIndexArrow(0,119);
   SetIndexArrow(1,119);
   SetIndexArrow(2,225);
   SetIndexArrow(3,226);
   SetIndexLabel(0,"Bulls");
   SetIndexLabel(1,"Bears");
   SetIndexLabel(2,"LongEnt");
   SetIndexLabel(3,"ShortEnt");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;
//----for
   for(int i=limit;i>=1;i--)
     {
      if(CheckPower(i,"CheckBuy"))
        {
         Bulls[i]=Low[i];
         if(!UpBarCheck(i)) LongEntry[i-1]=Low[i+1];
        }
      else Bulls[i]=EMPTY_VALUE;
      if(CheckPower(i,"CheckSell"))
        {
         Bears[i]=High[i];
         if(UpBarCheck(i)) ShortEntry[i-1]=High[i+1];
        }
      else Bears[i]=EMPTY_VALUE;
     }//end for
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckPower(int i,string mode)
  {
   double Bull_power =Bullspower(i);
   double Bear_power =Bearspower(i);
   double Bull_power_LK =Bullspower(i)+Bullspower(i+1);//+Bullspower(i+2)+Bullspower(i+3)+Bullspower(i+4)+Bullspower(i+5);   
   double Bear_power_LK =Bearspower(i)+Bearspower(i+1);//+Bearspower(i+2)+Bearspower(i+3)+Bearspower(i+4)+Bearspower(i+5);  
   if(mode=="CheckBuy")
     {
      for(int x=i+1;x<=Bars;x++)
        {
         if(Bear_power>Bull_power_LK) {return(true); break;}
         else
           {
            if(Bull_power>Bear_power_LK) {return(false);break;}
            else
              {
               Bull_power=Bull_power+Bullspower(x);
               Bear_power=Bear_power+Bearspower(x);
               Bull_power_LK=Bull_power_LK+Bullspower(x+1);
               Bear_power_LK=Bear_power_LK+Bearspower(x+1);
              }
           }///else
        }//for
     }//if   
//----
   if(mode=="CheckSell")
     {
      for(x=i+1;x<=Bars;x++)
        {
         if(Bull_power>Bear_power_LK) {return(true);break;}
         else
           {
            if(Bear_power>Bull_power_LK) {return(false); break;}
            else
              {
               Bull_power=Bull_power+Bullspower(x);
               Bear_power=Bear_power+Bearspower(x);
               Bull_power_LK=Bull_power_LK+Bullspower(x+1);
               Bear_power_LK=Bear_power_LK+Bearspower(x+1);
              }
           }///else
        }//for
     }//if   
  }//if   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Bullspower(int i)
  {
   double returnbullvalue=MathAbs(iBullsPower(NULL,0,1,PRICE_CLOSE,i));
   return(returnbullvalue);
  }
//----
double Bearspower(int i)
  {
   double returnbearvalue=MathAbs(iBearsPower(NULL,0,1,PRICE_CLOSE,i));
   return(returnbearvalue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UpBarCheck(int i)
  {
   if(Close[i]<Close[i+1]) return(false);///down bar
   if(Close[i]>Close[i+1]) return(true);///up bar
   if(Close[i]==Close[i+1])
     {
      if(Close[i]<Close[i+2]) return(false);///down bar
      if(Close[i]>Close[i+2]) return(true);///up bar
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
