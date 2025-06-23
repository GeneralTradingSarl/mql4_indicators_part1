//+------------------------------------------------------------------+
//|                                             Doji Reader d 01.mq4 |
//|                               Copyright © 2009,  MQL PROGRAMMING |
//|                                  mailto:mqlprogramming@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009,  MQL PROGRAMMING"
#property link      "mailto:mqlprogramming@gmail.com"

#property indicator_chart_window

extern bool      AnAlert=true;

//---- input parameters for regular doji
extern bool      FindRegularDoji=true;
extern int       MinLengthOfUpTail=3;
extern int       MinLengthOfLoTail=3;

//---- input parameters for dragonfly doji
extern bool      FindDragonflyDoji=true;
extern int       MaxLengthOfUpTail1=0;
extern int       MinLengthOfLoTail1=3;

//---- input parameters for gravestone doji
extern bool      FindGravestoneDoji=true;
extern int       MinLengthOfUpTail2=3;
extern int       MaxLengthOfLoTail2=0;

//---- initialization for variables
int counter1=1, counter2=1, counter3=1, counterA=0, counterB=0, counterC=0, counterX=0,
    counterY=0, counterZ=0, counterH=0, counterI=0, counterJ=0;
string name1="Regular Doji", name2="Dragonfly Doji", name3="Gravestone Doji";
bool sound1=false, sound2=false, sound3=false;
double H=0.0, L=0.0, C=0.0, O=0.0;
datetime T=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- set texts for regular doji's notes 
   ObjectCreate(name1, OBJ_LABEL, 0, 0, 0);
   ObjectSet(name1, OBJPROP_XDISTANCE, 15);
   ObjectSet(name1, OBJPROP_YDISTANCE, 21);
   ObjectSetText(name1, "Candle with red tail is Regular Doji", 9, "Tahoma", Red);
//---- set texts for dragonfly doji's notes 
   ObjectCreate(name2, OBJ_LABEL, 0, 0, 0);
   ObjectSet(name2, OBJPROP_XDISTANCE, 15);
   ObjectSet(name2, OBJPROP_YDISTANCE, 42);
   ObjectSetText(name2, "Candle with blue tail is Dragonfly Doji", 9, "Tahoma", Blue);
//---- set texts for gravestone doji's notes 
   ObjectCreate(name3, OBJ_LABEL, 0, 0, 0);
   ObjectSet(name3, OBJPROP_XDISTANCE, 15);
   ObjectSet(name3, OBJPROP_YDISTANCE, 63);
   ObjectSetText(name3, "Candle with gold tail is Gravestone Doji", 9, "Tahoma", Gold);
 //---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- delete all object 
   ObjectsDeleteAll(0, OBJ_LABEL);
   ObjectsDeleteAll(0, OBJ_TREND);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars=IndicatorCounted();
//---- check for error
   if(counted_bars<0) return(-1);
//---- scan all bars except current bar for doji
   for(i=Bars-1; i>0; i--)
      {
//---- save bar price into variables
       H=High[i]; L=Low[i]; C=Close[i]; O=Open[i];
//---- save bar open time into variable
       T=Time[i];
//---- find regular doji if desired by user
       if(FindRegularDoji)
         {
//---- if high price minus close price is higher or equal with MinLengthOfUpTail and
//---- close price minus low price is higher or equal with MinLengthOfLoTail and
//---- close price is equal with open price, it is a regular doji  
          if(H-C>=MinLengthOfUpTail*Point && C-L>=MinLengthOfLoTail*Point && C==O) 
            {
//---- than we have to color its tail 
             if(ObjectFind(name1+counter1)==-1) //if tail is not colored yet 
               {
                if(ObjectCreate(name1+counter1, OBJ_TREND, 0, T, H, T, L))
                  {
                   ObjectSet(name1+counter1, OBJPROP_COLOR, Red);
                   ObjectSet(name1+counter1, OBJPROP_WIDTH, 1);
                   ObjectSet(name1+counter1, OBJPROP_RAY, false);
                   counter1++;
                   sound1=true;
                  }
               }
            }
         } 
//---- find dragonfly doji if desired by user
       if(FindDragonflyDoji)
         {
//---- if high price minus close price lower or equal with MaxLengthOfUpTail1 and 
//---- close price minus low price is higher or equal with MinLengthOfLoTail1 and
//---- close price is equal with open price , it is dragonfly doji
          if(H-C<=MaxLengthOfUpTail1*Point && C-L>=MinLengthOfLoTail1*Point && C==O)
            {
//---- than we have to color its tail
             if(ObjectFind(name2+counter2)==-1) //if tail is not colored yet
               {
                if(ObjectCreate(name2+counter2, OBJ_TREND, 0, T, H, T, L))
                  {
                   ObjectSet(name2+counter2, OBJPROP_COLOR, Blue);
                   ObjectSet(name2+counter2, OBJPROP_WIDTH, 1);
                   ObjectSet(name2+counter2, OBJPROP_RAY, false);
                   counter2++;
                   sound2=true;
                  }
               }
            }
         } 
//---- find gravestone doji if desired by user
       if(FindGravestoneDoji)
         {
//---- if high price minus close price higher or equal with MinLengthOfUpTail2 and 
//---- close price minus low price is lower or equal with MaxLengthOfLoTail2 and
//---- close price is equal with open price, it is gravestone doji 
          if(H-C>=MinLengthOfUpTail2*Point && C-L<=MaxLengthOfLoTail2*Point && C==O)
            {
             if(ObjectFind(name3+counter3)==-1) //if tail is not colored yet
               {
                if(ObjectCreate(name3+counter3, OBJ_TREND, 0, T, H, T, L)) 
                  {
                   ObjectSet(name3+counter3, OBJPROP_COLOR, Gold);
                   ObjectSet(name3+counter3, OBJPROP_WIDTH, 1);
                   ObjectSet(name3+counter3, OBJPROP_RAY, false);
                   counter3++;
                   sound3=true;
                  }
               }
            }
         } 
      } 
//---- if  an alert is false, than we discontinued the program
   if(!AnAlert) return(0);
//---- working once per bar 
   if(Volume[0]>1) return(0);
//---- save latest completed bar price into variables 
   H=High[1]; L=Low[1]; C=Close[1]; O=Open[1];
//---- we looking for latest doji and give an alert if we found it 
//---- if find regular doji is true, than we looking for it 
   if(FindRegularDoji)
     {
//---- if high price minus close price is higher or equal with MinLengthOfUpTail and
//---- close price minus low price is higher or equal with MinLengthOfLoTail and
//---- close price is equal with open price, it is a regular doji  
      if(H-C>=MinLengthOfUpTail*Point && C-L>=MinLengthOfLoTail*Point && C==O) 
        { 
//---- than we have to give an alert to user   
         Alert("new regular doji at ",Symbol()," M",Period());
        }
     }
//---- if find deagonfly doji is true, than we looking for it 
   if(FindDragonflyDoji)
     {
//---- if high price minus close price lower or equal with MaxLengthOfUpTail1 and 
//---- close price minus low price is higher or equal with MinLengthOfLoTail1 and
//---- close price is equal with open price , it is dragonfly doji
      if(H-C<=MaxLengthOfUpTail1*Point && C-L>=MinLengthOfLoTail1*Point && C==O)
        {
//---- than we have to give an alert to user 
         Alert("new dragonfly doji at ",Symbol()," M",Period()); 
        }
     }
//---- if find gravestone doji is true, than we looking for it 
   if(FindGravestoneDoji)
     {
//---- if high price minus close price higher or equal with MinLengthOfUpTail2 and 
//---- close price minus low price is lower or equal with MaxLengthOfLoTail2 and
//---- close price is equal with open price, it is gravestone doji 
      if(H-C>=MinLengthOfUpTail2*Point && C-L<=MaxLengthOfLoTail2*Point && C==O)
        {  
//---- than we have to give an alert to user
         Alert("new gravestone doji at ",Symbol()," M",Period());
        }
     }             
   return(0);
  } //end of file 
//+------------------------------------------------------------------+