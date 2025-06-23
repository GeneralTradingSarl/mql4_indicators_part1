//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//                                          TheGreedyPig ADR v6.mq4 $
//                                   Copyright © 2012, TheGreedyPig $
//                            http://greedypigtrading.blogspot.com/ $
//                                                                  $
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#property copyright "Greedy Pig Trading" 
#property indicator_chart_window
/*
If you need help developing Expert Advisor, Scripts, or Indicators 
send an eMail to: FREEMT4Consultation@sendfree.com
Visit/Follow us:
YouTube: http://www.youtube.com/user/GreedyPigTrading
Blog: http://greedypigtrading.blogspot.com/
eMail: GreedyPigTrading@Gmail.com
LinkedIn: http://www.linkedin.com/pub/thegreedy-pig/47/ba4/20b
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                              Version Log
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
2012/03/04  TheGreedyPig
TheGreedyPig ADR v6
Added Input Options to display High/Low Prices on chart for ADR 20, ADR 10 ADR 5
Top Left of chart shows:
ADR(20) = XXX
ADR(10) = XXX
ADR(5)  = XXX
Today   = XXX
ADR5 Top = xxxx - xx Pips Away [This will turn Yellow if within 20 Pips]
(Pips from Open) = xx [this will change color >20 is Green, < -20 is RED Less than 20 is Yellow]
ADR5 Bottom = xxxx - xx Pips Away [This will turn Yellow if within 20 Pips]
*/
extern  bool Show_ADR5  = true;
extern  bool Show_ADR10 = true;
extern  bool Show_ADR20 = true;
extern  bool ExcludeSundayData=true;  // set to "false" to INCLUDE Sunday bar in the calculation

color      ADR_Color=Blue;

int        Font_Size=10;
int        DisplayCorner=0;
int        x=10;
int        y=10;
int        LastBars0=0;
int        Todays_Range; // current days range High to Low 
int        RmUp; // Pips from Bid to ADR5 High
int        RmDn;// Pips from Bid to ADR5 Low
int        n=1; // $$$ Used to loop back x days 

string     font1 = "Compact";
string     font2 = "Arial Black";
static int adr1,adr5,adr10,adr20; // stores ADR calcs
string     text; // 

double     PipValue=0.0001;

double     DailyPips; // used to hold the daily move in pips  
double     Daily_Range=0.0;  // $$$ Used to Total up the Daily Ranges   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
int init()
  {
//$$$ Establish Pips for 4 or 5 digit/fractional pip calculations
   if(Digits==2 || Digits==3) PipValue=PipValue*100; // $$$ For JPY pairs
   if(Digits== 4 || Digits == 5) PipValue = PipValue;
// $$$ Branding 
   ObjectCreate("trademark",OBJ_LABEL,0,0,0);          //$$$ Trademark
   ObjectSet("trademark",OBJPROP_CORNER,DisplayCorner);
   ObjectSet("trademark",OBJPROP_XDISTANCE,x);
   ObjectSet("trademark",OBJPROP_YDISTANCE,y+5);
   ObjectSetText("trademark","TheGreedyPig",Font_Size-3,font2,Black);

   ObjectCreate("Watermark",OBJ_LABEL,0,0,0);          //$$$ Watermark
   ObjectSet("Watermark",OBJPROP_CORNER,3);
   ObjectSet("Watermark",OBJPROP_XDISTANCE,5);
   ObjectSet("Watermark",OBJPROP_YDISTANCE,5);
   ObjectSetText("Watermark","http://greedypigtrading.blogspot.com",Font_Size,font2,DimGray);
// $$$ TopLeft Dashboard/Display  
   ObjectCreate("xADR0",OBJ_LABEL,0,0,0);          // Average Daily Range ("ADR20" Label)
   ObjectSet("xADR0",OBJPROP_CORNER,DisplayCorner);
   ObjectSet("xADR0",OBJPROP_XDISTANCE,x);
   ObjectSet("xADR0",OBJPROP_YDISTANCE,y+20);

   ObjectCreate("xADR1",OBJ_LABEL,0,0,0);          // Average Daily Range ("ADR10" Label)
   ObjectSet("xADR1",OBJPROP_CORNER,DisplayCorner);
   ObjectSet("xADR1",OBJPROP_XDISTANCE,x);
   ObjectSet("xADR1",OBJPROP_YDISTANCE,y+35);

   ObjectCreate("xADR2",OBJ_LABEL,0,0,0);          // Average Daily Range ("ADR5" Label)
   ObjectSet("xADR2",OBJPROP_CORNER,DisplayCorner);
   ObjectSet("xADR2",OBJPROP_XDISTANCE,x);
   ObjectSet("xADR2",OBJPROP_YDISTANCE,y+50);

   ObjectCreate("xADR3",OBJ_LABEL,0,0,0);          // "Today's Range" Label
   ObjectSet("xADR3",OBJPROP_CORNER,DisplayCorner);
   ObjectSet("xADR3",OBJPROP_XDISTANCE,x);
   ObjectSet("xADR3",OBJPROP_YDISTANCE,y+65);

   ObjectCreate("xADR4",OBJ_LABEL,0,0,0);
   ObjectSet("xADR4",OBJPROP_CORNER,DisplayCorner);  // "ADR Top" Label
   ObjectSet("xADR4",OBJPROP_XDISTANCE,x);
   ObjectSet("xADR4",OBJPROP_YDISTANCE,y+80);

   ObjectCreate("DailyPipsObj2",OBJ_LABEL,0,0,0);
   ObjectSet("DailyPipsObj2",OBJPROP_CORNER,DisplayCorner);  // Daily Pips
   ObjectSet("DailyPipsObj2",OBJPROP_XDISTANCE,x);
   ObjectSet("DailyPipsObj2",OBJPROP_YDISTANCE,y+97);

   ObjectCreate("xADR5",OBJ_LABEL,0,0,0);          // "ADR Bottom" Label
   ObjectSet("xADR5",OBJPROP_CORNER,DisplayCorner);
   ObjectSet("xADR5",OBJPROP_XDISTANCE,x);
   ObjectSet("xADR5",OBJPROP_YDISTANCE,y+130);
// $$$ On Chart ADR Price Label Display     
   ObjectCreate("ADR5_High_obj",OBJ_ARROW,0,Time[0],0);  //Get this to calc price and plot 
   ObjectSet("ADR5_High_obj",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet("ADR5_High_obj",OBJPROP_COLOR,Red);
   ObjectSet("ADR5_High_obj",OBJPROP_WIDTH,3);

   ObjectCreate("ADR5_Low_obj",OBJ_ARROW,0,Time[0],0);  //Get this to calc price and plot  
   ObjectSet("ADR5_Low_obj",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet("ADR5_Low_obj",OBJPROP_COLOR,Green);
   ObjectSet("ADR5_Low_obj",OBJPROP_WIDTH,3);

   ObjectCreate("ADR10_High_obj",OBJ_ARROW,0,Time[1],0);  //Get this to calc price and plot 
   ObjectSet("ADR10_High_obj",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet("ADR10_High_obj",OBJPROP_COLOR,Red);
   ObjectSet("ADR10_High_obj",OBJPROP_WIDTH,2);

   ObjectCreate("ADR10_Low_obj",OBJ_ARROW,0,Time[1],0);  //Get this to calc price and plot  
   ObjectSet("ADR10_Low_obj",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet("ADR10_Low_obj",OBJPROP_COLOR,Green);
   ObjectSet("ADR10_Low_obj",OBJPROP_WIDTH,2);

   ObjectCreate("ADR20_High_obj",OBJ_ARROW,0,Time[2],0);  //Get this to calc price and plot 
   ObjectSet("ADR20_High_obj",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet("ADR20_High_obj",OBJPROP_COLOR,Red);
   ObjectSet("ADR20_High_obj",OBJPROP_WIDTH,1);

   ObjectCreate("ADR20_Low_obj",OBJ_ARROW,0,Time[2],0);  //Get this to calc price and plot  
   ObjectSet("ADR20_Low_obj",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet("ADR20_Low_obj",OBJPROP_COLOR,Green);
   ObjectSet("ADR20_Low_obj",OBJPROP_WIDTH,1);
   return(0);
  } // End Initialize 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   if(ObjectFind("xADR0")==0) ObjectDelete("xADR0");// only delete it if it exists
   if(ObjectFind("xADR1") == 0 )          ObjectDelete("xADR1");
   if(ObjectFind("xADR2") == 0 )          ObjectDelete("xADR2");
   if(ObjectFind("xADR3") == 0 )          ObjectDelete("xADR3");
   if(ObjectFind("xADR4") == 0 )          ObjectDelete("xADR4");
   if(ObjectFind("xADR5") == 0 )          ObjectDelete("xADR5");
   if(ObjectFind("DailyPipsObj2") == 0 )  ObjectDelete("DailyPipsObj2");
   if(ObjectFind("ADR5_High_obj") == 0 )  ObjectDelete("ADR5_High_obj");
   if(ObjectFind("ADR5_Low_obj")==0) ObjectDelete("ADR5_Low_obj");
   if(ObjectFind("ADR10_High_obj")== 0) ObjectDelete("ADR10_High_obj");
   if(ObjectFind("ADR10_Low_obj") == 0) ObjectDelete("ADR10_Low_obj");
   if(ObjectFind("ADR20_High_obj")== 0) ObjectDelete("ADR20_High_obj");
   if(ObjectFind("ADR20_Low_obj") == 0) ObjectDelete("ADR20_Low_obj");


   return(0);
  } // End Deinitialize
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
// Oink Oink
//   string text;
//string Color;
   int Bars0=Bars;
//$$$$$  ADR CALCULATION $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  
   if(Bars0>LastBars0)
     {

      double     ADR5_High=0;
      double     ADR5_Low=0;
      double     ADR10_High=0;
      double     ADR10_Low=0;
      double     ADR20_High=0;
      double     ADR20_Low=0;

      for(int i=1;i<=20;i++) // $$$ Loop Past 20 Daily Sessions
        {
         while(ExcludeSundayData && TimeDayOfWeek(iTime(Symbol(),PERIOD_D1,n))==0) n++; // If TimeDayOfWeek returns 0 add 1 to n to skip Sunday
         Daily_Range=Daily_Range+(iHigh(Symbol(),PERIOD_D1,n)-iLow(Symbol(),PERIOD_D1,n))/PipValue;
         if(i==1)  adr1 =MathRound(Daily_Range);
         if(i==5)  adr5 =MathRound(Daily_Range/5);
         if(i==10) adr10=MathRound(Daily_Range/10);
         if(i==20) adr20=MathRound(Daily_Range/20);
         n++;
        }
      text="ADR(20) = "+adr20;
      ObjectSetText("xADR0",text,Font_Size,font2,ADR_Color);      // $$$ "ADR20" Label       

      text="ADR(10) = "+adr10;
      ObjectSetText("xADR1",text,Font_Size,font2,ADR_Color);      // $$$ "ADR10" Label    

      text="ADR(5)   = "+adr5;
      ObjectSetText("xADR2",text,Font_Size,font2,ADR_Color);      // $$$ "ADR5" Label

      LastBars0=Bars0;
     }
//$$$$$  END OF ADR CALCULATION $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   

//Today's Range and Limit Room $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  
   double Todays_Low  =  iLow (Symbol(),PERIOD_D1,0);
   double Todays_High =  iHigh(Symbol(),PERIOD_D1,0);
   Todays_Range =  MathRound((Todays_High - Todays_Low)    /PipValue );
   RmUp         =  MathRound( adr5   - (Bid - Todays_Low)  /PipValue );
   RmDn         =  MathRound( adr5   - (Todays_High - Bid) /PipValue );

   ADR5_High     =  Todays_Low  + (adr5 * PipValue);
   ADR5_Low      =  Todays_High - (adr5 * PipValue);

   ADR10_High     =  Todays_Low  + (adr10 * PipValue);
   ADR10_Low      =  Todays_High - (adr10 * PipValue);

   ADR20_High     =  Todays_Low  + (adr20 * PipValue);
   ADR20_Low      =  Todays_High - (adr20 * PipValue);

   text="Today    = "+Todays_Range;                       // "Today's Range" Label
   ObjectSetText("xADR3",text,Font_Size,font2,ADR_Color);

   text="ADR(5) Top@"+DoubleToStr(ADR5_High,4)+" = "+RmUp+" Pips Away";      // "ADR Top" Label
   if(RmUp<20) ObjectSetText("xADR4",text,Font_Size,font1,Yellow);
   else   ObjectSetText("xADR4",text,Font_Size,font2,Green);

   text="ADR(5) Bottom@"+DoubleToStr(ADR5_Low,4)+" = "+RmDn+" Pips Away";    // "ADR Bottom" Label
   if(RmDn<20) ObjectSetText("xADR5",text,Font_Size,font2,Yellow);
   else ObjectSetText("xADR5",text,Font_Size,font2,Green);

   if(iClose(Symbol(),PERIOD_D1,0)>iOpen(Symbol(),PERIOD_D1,0)) DailyPips=(iClose(Symbol(),PERIOD_D1,0)-iOpen(Symbol(),PERIOD_D1,0))/PipValue;
   else if(iOpen(Symbol(),PERIOD_D1,0)>iClose(Symbol(),PERIOD_D1,0)) DailyPips=(iOpen(Symbol(),PERIOD_D1,0)-iClose(Symbol(),PERIOD_D1,0))/PipValue;

// $$$ Change Display of DailyPips by Daily Pip Range for the day.
// $$$ YELLOW
   if(DailyPips<20)
      ObjectSetText("DailyPipsObj2",DoubleToStr((iClose(Symbol(),PERIOD_D1,0)-iOpen(Symbol(),PERIOD_D1,0))/PipValue,0),20,"Arial Black",Yellow);
// $$$ RED
   else if(
      (iOpen(Symbol(),PERIOD_D1,0)-iClose(Symbol(),PERIOD_D1,0))/PipValue>20)
      ObjectSetText("DailyPipsObj2",DoubleToStr((iClose(Symbol(),PERIOD_D1,0)-iOpen(Symbol(),PERIOD_D1,0))/PipValue,0),20,"Arial Black",Red);
// $$$ GREEN 
   else if(
      (iClose(Symbol(),PERIOD_D1,0)-iOpen(Symbol(),PERIOD_D1,0))/PipValue>20)

      ObjectSetText("DailyPipsObj2",DoubleToStr((iClose(Symbol(),PERIOD_D1,0)-iOpen(Symbol(),PERIOD_D1,0))/PipValue,0),20,"Arial Black",Green);
// $$$ DISPLAY OF PRICE LABELS ON THE CHART
   if(Show_ADR5)
     {
      // $$$ Set ADR Price Label HIGH     
      ObjectSet("ADR5_High_obj",OBJPROP_TIME1,Time[0]);  //Get this to calc price and plot 
      ObjectSet("ADR5_High_obj",OBJPROP_PRICE1,ADR5_High);  //Get this to calc price and plot    
      ObjectSetText("ADR5_High_obj","ADR5 High="+DoubleToStr(ADR5_High,4),10,font1,Red);
      // $$$ Set ADR Price Label LOW     
      ObjectSet("ADR5_Low_obj",OBJPROP_TIME1,Time[0]);  //Get this to calc price and plot 
      ObjectSet("ADR5_Low_obj",OBJPROP_PRICE1,ADR5_Low);  //Get this to calc price and plot    
      ObjectSetText("ADR5_Low_obj","ADR5 Low="+DoubleToStr(ADR5_Low,4),10,font1,Red);
     }
   else
     {
      if(ObjectFind("ADR5_High_obj") == 0 )  ObjectDelete("ADR5_High_obj");
      if(ObjectFind("ADR5_Low_obj")  == 0 )  ObjectDelete("ADR5_Low_obj");
     }
   if(Show_ADR10)
     {
      // $$$ Set ADR Price Label HIGH     
      ObjectSet("ADR10_High_obj",OBJPROP_TIME1,Time[1]);  //Get this to calc price and plot 
      ObjectSet("ADR10_High_obj",OBJPROP_PRICE1,ADR10_High);  //Get this to calc price and plot    
      ObjectSetText("ADR10_High_obj","ADR10 High="+DoubleToStr(ADR10_High,4),10,font1,Red);
      // $$$ Set ADR Price Label LOW     
      ObjectSet("ADR10_Low_obj",OBJPROP_TIME1,Time[1]);  //Get this to calc price and plot 
      ObjectSet("ADR10_Low_obj",OBJPROP_PRICE1,ADR10_Low);  //Get this to calc price and plot    
      ObjectSetText("ADR10_Low_obj","ADR10 Low="+DoubleToStr(ADR10_Low,4),10,font1,Red);
     }
   else
     {
      if(ObjectFind("ADR10_High_obj") == 0 )  ObjectDelete("ADR10_High_obj");
      if(ObjectFind("ADR10_Low_obj")  == 0 )  ObjectDelete("ADR10_Low_obj");
     }
   if(Show_ADR20)
     {
      // $$$ Set ADR Price Label HIGH     
      ObjectSet("ADR20_High_obj",OBJPROP_TIME1,Time[2]);  //Get this to calc price and plot 
      ObjectSet("ADR20_High_obj",OBJPROP_PRICE1,ADR20_High);  //Get this to calc price and plot    
      ObjectSetText("ADR20_High_obj","ADR20 High="+DoubleToStr(ADR20_High,4),10,font1,Red);
      // $$$ Set ADR Price Label LOW     
      ObjectSet("ADR20_Low_obj",OBJPROP_TIME1,Time[2]);  //Get this to calc price and plot 
      ObjectSet("ADR20_Low_obj",OBJPROP_PRICE1,ADR20_Low);  //Get this to calc price and plot    
      ObjectSetText("ADR20_Low_obj","ADR20 Low="+DoubleToStr(ADR20_Low,4),10,font1,Red);
     }
   else
     {
      if(ObjectFind("ADR20_High_obj") == 0 )  ObjectDelete("ADR20_High_obj");
      if(ObjectFind("ADR20_Low_obj")  == 0 )  ObjectDelete("ADR20_Low_obj");
     }
   return(0);
  } // END Start
//+------------------------------------------------------------------+
