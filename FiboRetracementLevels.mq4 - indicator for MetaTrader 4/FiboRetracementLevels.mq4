//+------------------------------------------------------------------+
//|                                        FiboRetracementLevels.mq4 |
//|                 Copyright 2014,  Roy Philips Jacobs ~ 22/02/2014 |
//|                                           http://www.gol2you.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014,  Roy Philips Jacobs ~ 22/02/2014"
#property link      "http://www.gol2you.com ~ Forex Videos"
#property description "Fibonacci Retracement Levels"
//--
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Yellow
//--
#property indicator_width1 1
#property indicator_width2 1
//---
extern string FiboRetLevels="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
double cntrBuf[]; // center line
double smmaBuf[]; // cons line
int perio=20;
//--
string CRight;
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   CRight="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
//--- indicator buffers mapping
   IndicatorBuffers(2);
//---
   SetIndexBuffer(0,cntrBuf);
   SetIndexBuffer(1,smmaBuf);
   //--- indicator line drawing
//--- center line SMA 20 Price Median 
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,EMPTY,Red);
   //-- SMMA 20 Price Median
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,EMPTY,Yellow);
   //--- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,"Center");
   SetIndexLabel(1,"Cons");
//---
   SetIndexDrawBegin(0,perio);
   SetIndexDrawBegin(1,perio);
   //--
   IndicatorShortName("FRL");
   IndicatorDigits(Digits);
   //--
//--- initialization done
   return(0);
  }
//---
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
//----
int deinit()
  {
//----
   for(int d=0; d<7; d++) 
    {
      ObjectDelete("FiboLineLevels_"+d);
      ObjectDelete("FiboLineLabels_"+d);
      ObjectDelete("FiboLineLimit_"+d);
    }
//---
   ObjectDelete("FiboLineLimit6");
   ObjectDelete("FiboLineLimit0");
   ObjectDelete("FiboLineCross1");
   ObjectDelete("FiboLineCross2");
   ObjectDelete("FiboStarCross");
//----
   return(0);
  }
//----
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//---
int start()
//----
  {
//------
   if(FiboRetLevels!=CRight) return(0);
//---
   int counted_bars=IndicatorCounted();
   //---
   if(counted_bars<0) return(-1);
   //----
   if(counted_bars>0) counted_bars--;
   int pos=Bars-counted_bars;
   if(counted_bars==0) pos-=1+61;
//----
   int i,f;
   double divFL=80.9;  
   double maxHi[],minLo[];
   double Lvl[]={0.0,23.6,38.2,50.0,61.8,80.9,100.0};
   double Lvr[]={100.0,80.9,61.8,50.0,38.2,23.6,0.0};
   datetime Cor1,Cor2,CorC,CorL;
   datetime bartime[];
//--- Set the arrays as a series
   ArraySetAsSeries(Lvl,true);
   ArraySetAsSeries(Lvr,true);
   ArraySetAsSeries(maxHi,true);
   ArraySetAsSeries(minLo,true);
   ArraySetAsSeries(bartime,true);
//--- Set Last error value to Zero
   ResetLastError();
//--- Copy timeseries containing the opening bars of the last 90 bars
   int copytime=CopyTime(NULL,0,0,90,bartime);
   //--
   if(copytime<=0)
     {
      Print("Unable to copy the Open Time of the last 90 bars");
      ResetLastError();
      return(0);
     }
   //--   
   int copyHi=CopyHigh(NULL,0,0,copytime,maxHi);
   int copyLo=CopyLow(NULL,0,0,copytime,minLo);
 //--- prepare the maxHi[] and minLo[] arrays
   ArrayResize(maxHi,Bars);
   ArrayResize(minLo,Bars);
   //--
   for(i=pos; i>=0; i--)
     {
      //---
      int ind1=iHighest(NULL,0,MODE_HIGH,77,i);
      int ind2=iLowest(NULL,0,MODE_LOW,77,i);
      if ((ind1>=0)&& (ind1<Bars)) maxHi[i]=High[ind1];
      if ((ind2>=0)&& (ind2<Bars)) minLo[i]=Low[ind2];
      Cor1=Time[i];
      Cor2=Time[i+60];
      CorL=Time[i+61];
      CorC=Time[i+30];
     }
   //--
   RefreshRates();  
   //----
//--- main cycle indicator iteration --//
   //---
   for(i=pos; i>=0; i--)
     {
      //--- center line SMA 20
      cntrBuf[i]=iMA(NULL,0,perio,0,MODE_SMA,PRICE_MEDIAN,i);
      //-- SMMA line
      smmaBuf[i]=iMA(NULL,0,perio,0,MODE_SMMA,PRICE_MEDIAN,i);
      //---
//----- Time to create the Fibonacci object
      //---
      if(i==0)
        {
        for(f=0; f<7; f++) 
          {
            ObjectDelete("FiboLineLevels_"+f);
            ObjectDelete("FiboLineLabels_"+f);
            ObjectDelete("FiboLineLimit_"+f);
           }
        //--
        ObjectDelete("FiboLineLimit6");
        ObjectDelete("FiboLineLimit0");
        ObjectDelete("FiboLineCross1");
        ObjectDelete("FiboLineCross2");
        ObjectDelete("FiboStarCross");
        //---
        for(f=0; f<7; f++)
           {
             if(Close[i]>minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0]))
               {
                 if(ObjectFind("FiboLineLevels_"+f)<0)
                   {
                     //--- Create Fibonacci Retracement Levels
                     ObjectCreate("FiboLineLevels_"+f,OBJ_TREND,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]),
                     Cor2,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     //--- level value
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_COLOR,clrGold);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_RIGHT,false);
                     if(Lvl[f]==80.9) {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_DASHDOT);}
                     else {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_SOLID);}
                     //--
                     ObjectCreate(0,"FiboLineLabels_"+f,OBJ_TEXT,0,CorL,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_COLOR,clrSnow);
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_TEXT,DoubleToStr(Lvl[f],1));
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_FONT,"Bodoni MT Black");
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_FONTSIZE,8);
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_ANCHOR,ANCHOR_RIGHT);
                     //--
                     ObjectCreate(0,"FiboLineLimit_"+f,OBJ_TEXT,0,Cor2,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetText("FiboLineLimit_"+f,CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit_"+f,OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--                 
                     ObjectCreate("FiboLineCross1",OBJ_CHANNEL,0,Cor2,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0]),
                     Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectCreate("FiboLineCross2",OBJ_CHANNEL,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0]),
                     Cor2,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectCreate(0,"FiboLineLimit6",OBJ_TEXT,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetText("FiboLineLimit6",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit6",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectCreate(0,"FiboLineLimit0",OBJ_TEXT,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetText("FiboLineLimit0",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit0",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectCreate(0,"FiboStarCross",OBJ_TEXT,0,CorC,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[3]));
                     ObjectSetText("FiboStarCross",CharToStr(181),15,"Wingdings",Aqua);
                     ObjectSetInteger(0,"FiboStarCross",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ChartRedraw(0);
                     Sleep(1000);
                     RefreshRates();
                     //----
                   }
                 //--
                 else // if(ObjectFind("FiboLineLevels_"+f)>0) //
                   {
                     //--- ObjectMove Fibonacci Retracement Levels
                     ObjectMove("FiboLineLevels_"+f,f,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_COLOR,clrGold);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_RIGHT,false);
                     if(Lvl[f]==80.9) {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_DASHDOT);}
                     else {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_SOLID);}
                     //--
                     ObjectMove("FiboLineLabels_"+f,OBJ_TEXT,0,CorL,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_COLOR,clrSnow);                 
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_TEXT,DoubleToStr(Lvl[f],1));
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_FONT,"Bodoni MT Black");
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_FONTSIZE,8);
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_ANCHOR,ANCHOR_RIGHT);
                     //--
                     ObjectMove("FiboLineLimit_"+f,OBJ_TEXT,0,Cor2,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetText("FiboLineLimit_"+f,CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit_"+f,OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--                  
                     ObjectMove("FiboLineCross1",OBJ_CHANNEL,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectMove("FiboLineCross2",OBJ_CHANNEL,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectMove("FiboLineLimit6",OBJ_TEXT,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetText("FiboLineLimit6",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit6",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectMove("FiboLineLimit0",OBJ_TEXT,0,Cor1,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetText("FiboLineLimit0",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit0",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectMove("FiboStarCross",OBJ_TEXT,0,CorC,minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[3]));
                     ObjectSetText("FiboStarCross",CharToStr(181),15,"Wingdings",Aqua);
                     ObjectSetInteger(0,"FiboStarCross",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ChartRedraw(0);
                     Sleep(1000);
                     RefreshRates();
                     //----
                   }
               }
             //---//
             else // if(Close[i]<minLo[i]+((maxHi[i]-minLo[i])/divFL*Lvl[0])) //
               {
                 if(ObjectFind("FiboLineLevels_"+f)<0)
                   {
                     //--- Create Fibonacci Retracement Levels
                     ObjectCreate("FiboLineLevels_"+f,OBJ_TREND,0,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]),
                     Cor2,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     //--- level value
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_COLOR,clrGold);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_RIGHT,false);
                     if(Lvr[f]==80.9) {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_DASHDOT);}
                     else {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_SOLID);}
                     //--
                     ObjectCreate(0,"FiboLineLabels_"+f,OBJ_TEXT,0,CorL,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_COLOR,clrSnow);
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_TEXT,DoubleToStr(Lvr[f],1));
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_FONT,"Bodoni MT Black");
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_FONTSIZE,8);
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_ANCHOR,ANCHOR_RIGHT);
                     //--
                     ObjectCreate(0,"FiboLineLimit_"+f,OBJ_TEXT,0,Cor2,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetText("FiboLineLimit_"+f,CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit_"+f,OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--                 
                     ObjectCreate("FiboLineCross1",OBJ_CHANNEL,0,Cor2,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[6]),
                     Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectCreate("FiboLineCross2",OBJ_CHANNEL,0,Cor2,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[0]),
                     Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectCreate(0,"FiboLineLimit6",OBJ_TEXT,0,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetText("FiboLineLimit6",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit6",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectCreate(0,"FiboLineLimit0",OBJ_TEXT,0,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetText("FiboLineLimit0",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit0",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectCreate(0,"FiboStarCross",OBJ_TEXT,0,CorC,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[3]));
                     ObjectSetText("FiboStarCross",CharToStr(181),15,"Wingdings",Aqua);
                     ObjectSetInteger(0,"FiboStarCross",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ChartRedraw(0);
                     Sleep(1000);
                     RefreshRates();
                     //----
                   }
                 //--
                 else // if(ObjectFind("FiboLineLevels_"+f)>0) //
                   {
                     //--- ObjectMove Fibonacci Retracement Levels
                     ObjectMove("FiboLineLevels_"+f,f,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_COLOR,clrGold);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_RAY_RIGHT,false);
                     if(Lvr[f]==80.9) {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_DASHDOT);}
                     else {ObjectSetInteger(0,"FiboLineLevels_"+f,OBJPROP_STYLE,STYLE_SOLID);}
                     //--
                     ObjectMove("FiboLineLabels_"+f,OBJ_TEXT,0,CorL,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_COLOR,clrSnow);                 
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_TEXT,DoubleToStr(Lvr[f],1));
                     ObjectSetString(0,"FiboLineLabels_"+f,OBJPROP_FONT,"Bodoni MT Black");
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_FONTSIZE,8);
                     ObjectSetInteger(0,"FiboLineLabels_"+f,OBJPROP_ANCHOR,ANCHOR_RIGHT);
                     //--
                     ObjectMove("FiboLineLimit_"+f,OBJ_TEXT,0,Cor2,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[f]));
                     ObjectSetText("FiboLineLimit_"+f,CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit_"+f,OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--                  
                     ObjectMove("FiboLineCross1",OBJ_CHANNEL,0,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross1",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectMove("FiboLineCross2",OBJ_CHANNEL,0,Cor2,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_COLOR,clrRed);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_LEFT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_RAY_RIGHT,false);
                     ObjectSetInteger(0,"FiboLineCross2",OBJPROP_STYLE,STYLE_DOT);
                     //--
                     ObjectMove("FiboLineLimit6",OBJ_TEXT,0,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[0]));
                     ObjectSetText("FiboLineLimit6",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit6",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectMove("FiboLineLimit0",OBJ_TEXT,0,Cor1,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[6]));
                     ObjectSetText("FiboLineLimit0",CharToStr(119),15,"Wingdings",DeepPink);
                     ObjectSetInteger(0,"FiboLineLimit0",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ObjectMove("FiboStarCross",OBJ_TEXT,0,CorC,maxHi[i]-((maxHi[i]-minLo[i])/divFL*Lvl[3]));
                     ObjectSetText("FiboStarCross",CharToStr(181),15,"Wingdings",Aqua);
                     ObjectSetInteger(0,"FiboStarCross",OBJPROP_ANCHOR,ANCHOR_CENTER);
                     //--
                     ChartRedraw(0);
                     Sleep(1000);
                     RefreshRates();
                     //----
                   }               
               }
           //---
           }
        //--- End for(f)
        }
     //--- End if(i)
     }
   //--- End for(i)
//-----
   return(0);     
  }
//----- End start()
//+------------------------------------------------------------------+ 
