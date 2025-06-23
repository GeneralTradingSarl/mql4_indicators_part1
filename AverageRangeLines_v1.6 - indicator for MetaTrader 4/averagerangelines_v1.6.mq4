//+------------------------------------------------------------------+
//|                                            AverageRange_v1.4.mq4 |
//|                                         Copyright 2020, NickBixy |
//|             https://www.forexfactory.com/showthread.php?t=904734 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, NickBixy"
#property link      "https://www.forexfactory.com/showthread.php?t=904734"
//#property version   "1.00"
#property strict
#property indicator_chart_window

enum pipPointChoice
  {
   Pips,//Pips
   Points,//Points
  };

enum yesnoChoiceToggle
  {
   No,
   Yes
  };

input string adrHeader="-----------------Average Range Settings------------------------------------------";//----- Average Range Settings
input ENUM_TIMEFRAMES timeFrame=PERIOD_D1;//TimeFrame
input yesnoChoiceToggle useShortLines=Yes;//Draw Short Lines
input int Line_Length=15;//Length of Short Line

input int period=14;//Period
input string lineLabelHeader="-----------------Line/Label Customize  Settings------------------------------------------";//----- Line/Label Customize  Settings
input string Font="Arial";//Font
input int labelFontSize=8;//Font Size
input int ShiftLabel=10;//Label Shift +move right -move left
input string highHeader="High Line/Label Customize--------------------------------------------";//----- High Line/Label Customize
input string customHighMSG="ADR High";//High Label custom MSG
input ENUM_LINE_STYLE highLineStyle=STYLE_DOT;//High Line Style
input int highLineWidth=1;//High Line Width
input color highLineClr=clrOrange;//High Line Color
input color highLabelClr=clrOrange;//High Label Color
input string lowHeader="Low Line/Label Customize--------------------------------------------";//----- Low Line/Label Customize
input string customLowMSG="ADR Low";//Low Label custom MSG
input ENUM_LINE_STYLE lowLineStyle=STYLE_DOT;//Low Line Style
input int lowLineWidth=1;//Low Line Width
input color lowLineClr=clrOrange;//Low Line Color
input color lowLabelClr=clrOrange;//Low Label Color
string indiName="ARL"+" "+EnumToString(timeFrame)+" "+(string)period;

//+------------------------------------------------------------------+
int OnInit()
  {
   if(period<1)
     {
      Alert("Period can't be less than 1");
     }
   ObjectsDeleteAll(0,indiName,0,OBJ_TREND) ;
   ObjectsDeleteAll(0,indiName,0,OBJ_TEXT) ;
   indiName="ARL"+" "+EnumToString(timeFrame)+" "+(string)period;
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void deinit()
  {
   ObjectsDeleteAll(0,indiName,0,OBJ_TREND) ;
   ObjectsDeleteAll(0,indiName,0,OBJ_TEXT) ;
  }
//+------------------------------------------------------------------+
int start()
  {
   DrawRangeLines();
   return 0;
  }
//+------------------------------------------------------------------+
void DrawRangeLines()
  {


   string highMSG="";
   string lowMSG="";

   highMSG=customHighMSG;
   lowMSG=customLowMSG;



//HIGH Range Line
   string highLine=indiName+" High";
   if(ObjectFind(highLine) != 0)
     {
      if(useShortLines==Yes)
        {
         ObjectCreate(highLine, OBJ_TREND, 0, Time[1]+Period()*60, GetAverageRangeHigh(), Time[0]+Period()*60*Line_Length, GetAverageRangeHigh());
         ObjectSet(highLine,OBJPROP_RAY,false);
        }
      else
        {
         ObjectCreate(highLine,OBJ_TREND,0,iTime(NULL,timeFrame,0),GetAverageRangeHigh(),Time[0]+Period()*60,GetAverageRangeHigh());
         ObjectSet(highLine,OBJPROP_RAY,true);
        }

      ObjectSet(highLine,OBJPROP_COLOR,highLineClr);
      ObjectSet(highLine,OBJPROP_STYLE,highLineStyle);
      ObjectSet(highLine,OBJPROP_WIDTH,highLineWidth);
      ObjectSet(highLine,OBJPROP_BACK,true);
      ObjectSet(highLine,OBJPROP_SELECTED,false);
      ObjectSet(highLine,OBJPROP_SELECTABLE,false);

     }
   else
     {
      if(useShortLines==Yes)
        {
         ObjectSet(highLine,OBJPROP_RAY,false);
         ObjectMove(highLine, 0, Time[1]+Period()*60, GetAverageRangeHigh());
         ObjectMove(highLine, 1, Time[0]+Period()*60*Line_Length, GetAverageRangeHigh());
        }
      else
        {
         ObjectSet(highLine,OBJPROP_RAY,true);
         ObjectMove(highLine,0,iTime(NULL,timeFrame,0),GetAverageRangeHigh());
         ObjectMove(highLine,1,Time[0]+Period()*60,GetAverageRangeHigh());
        }

     }

//LOW Range Line
   string lowLine=indiName+" LOW";

   if(ObjectFind(lowLine) != 0)
     {
      if(useShortLines==Yes)
        {
         ObjectCreate(lowLine, OBJ_TREND, 0, Time[1]+Period()*60, GetAverageRangeLow(), Time[0]+Period()*60*Line_Length, GetAverageRangeLow());
         ObjectSet(lowLine,OBJPROP_RAY,false);
        }
      else
        {
         ObjectCreate(lowLine,OBJ_TREND,0,iTime(NULL,timeFrame,0),GetAverageRangeLow(),Time[0]+Period()*60,GetAverageRangeLow());
         ObjectSet(lowLine,OBJPROP_RAY,true);
        }
      ObjectSet(lowLine,OBJPROP_COLOR,lowLineClr);
      ObjectSet(lowLine,OBJPROP_STYLE,lowLineStyle);
      ObjectSet(lowLine,OBJPROP_WIDTH,lowLineWidth);
      ObjectSet(lowLine,OBJPROP_BACK,true);
      ObjectSet(lowLine,OBJPROP_SELECTED,false);
      ObjectSet(lowLine,OBJPROP_SELECTABLE,false);


     }
   else
     {
      if(useShortLines==Yes)
        {
         ObjectSet(lowLine,OBJPROP_RAY,false);
         ObjectMove(lowLine, 0, Time[1]+Period()*60, GetAverageRangeLow());
         ObjectMove(lowLine, 1, Time[0]+Period()*60*Line_Length, GetAverageRangeLow());
        }
      else
        {
         ObjectSet(lowLine,OBJPROP_RAY,true);
         ObjectMove(lowLine,0,iTime(NULL,timeFrame,0),GetAverageRangeLow());
         ObjectMove(lowLine,1,Time[0]+Period()*60,GetAverageRangeLow());
        }

     }
///////////////////////////////////////////////////////////
//HIGH Range LABEL
   string highLabel=indiName+" HighLabel";

   if(ObjectFind(highLabel) != 0)
     {
      ObjectCreate(highLabel,OBJ_TEXT,0,Time[0]+Period()*60*ShiftLabel,GetAverageRangeHigh());
      ObjectSetText(highLabel,highMSG,labelFontSize,Font,highLabelClr);
      ObjectSet(highLabel,OBJPROP_BACK,true);
      ObjectSet(highLabel,OBJPROP_SELECTED,false);
      ObjectSet(highLabel,OBJPROP_SELECTABLE,false);
     }
   else
     {
      ObjectMove(highLabel, 0,Time[0]+Period()*60*ShiftLabel,GetAverageRangeHigh());
      ObjectSetText(highLabel,highMSG,labelFontSize,Font,highLabelClr);
     }

//LOW Range LABEL
   string lowLabel=indiName+" LowLabel";

   if(ObjectFind(lowLabel) != 0)
     {
      ObjectCreate(lowLabel,OBJ_TEXT,0,Time[0]+Period()*60*ShiftLabel,GetAverageRangeLow());
      ObjectSetText(lowLabel,lowMSG,labelFontSize,Font,lowLabelClr);
      ObjectSet(lowLabel,OBJPROP_BACK,true);
      ObjectSet(lowLabel,OBJPROP_SELECTED,false);
      ObjectSet(lowLabel,OBJPROP_SELECTABLE,false);
     }
   else
     {
      ObjectMove(lowLabel, 0,Time[0]+Period()*60*ShiftLabel,GetAverageRangeLow());
      ObjectSetText(lowLabel,lowMSG,labelFontSize,Font,lowLabelClr);
     }
   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
double GetBidAverageRangeDistancePipsPoints(double rangeValue)
  {
   double value=0;
   double bid=MarketInfo(NULL,MODE_BID);
   double points=MarketInfo(NULL,MODE_POINT);

   if(rangeValue!=0 && rangeValue!=NULL && bid!=0 && bid!=NULL)
     {
      value=(rangeValue-bid)/points;
     }





   return value;
  }
//+------------------------------------------------------------------+
double GetAverageRangeRatioPipsPoints()
  {
   double value=0;

   double todayRange=GetTodayRangePipsPoints();
   double averageRangeNumPeriods=GetAverageRangeNumPeriodsPipsPoints();

   if((todayRange!=0 && todayRange!=NULL) && (averageRangeNumPeriods!=0 && averageRangeNumPeriods!=NULL))
     {
      value=(todayRange/averageRangeNumPeriods)*100;
     }



   return value;
  }
//+------------------------------------------------------------------+
int PipsToPointFactor()
  {
   int point=1;

   if(Digits==5 || Digits==3)
     {
      point=10; //1 pip to 10 point if 5 digit
     } //Check whether it's a 5 digit broker (3 digits for Yen)
   else
      if(Digits==4 || Digits==2)
        {
         point=1; //1 pip to 1 point if 4 digit
        }
      else
         if(Digits==1)
           {
            point=1;
           }

   return(point);
  }
//+------------------------------------------------------------------+
double GetAverageRangeNumPeriodsPipsPoints()
  {
   double value=GetAverageRangeNumPeriods();
   double points=MarketInfo(NULL,MODE_POINT);

   if(value!=0 && value!=NULL && points!=0 && points!=NULL)
     {
      value=value/points;
     }





   return value;
  }
//+------------------------------------------------------------------+
double GetTodayRangePipsPoints()
  {
   double value=0;
   double points=MarketInfo(NULL,MODE_POINT);
   double high=iHigh(NULL,timeFrame,0);
   double low=iLow(NULL,timeFrame,0);
   value=MathAbs(high-low);

   if(value!=0 && value!=NULL && points!=0 && points!=NULL)
     {
      value=value/points;
     }






   return value;
  }
//+------------------------------------------------------------------+
double GetAverageRangeNumPeriods()
  {
   double result=0;
   double averageRange=0;
   for(int i=1; i<=period; i++)
     {

      if(timeFrame==PERIOD_D1)
        {
         datetime dayCheck1=iTime(NULL,PERIOD_D1,i);
         if(TimeDayOfWeek(dayCheck1) == 0)//found sunday
           {
            continue;
           }

         datetime dayCheck2=iTime(NULL,PERIOD_D1,i);
         if(TimeDayOfWeek(dayCheck2) == 6)//found saturday
           {
            continue;
           }
        }

      double high=iHigh(NULL,timeFrame,i);
      double low=iLow(NULL,timeFrame,i);
      averageRange+=high-low;
     }
   return result=averageRange/period;
  }
//+------------------------------------------------------------------+
double GetTimeFrameHighestHigh()
  {
   return iHigh(NULL,timeFrame,0);
  }
//+------------------------------------------------------------------+
double GetTimeFrameLowestLow()
  {
   return iLow(NULL,timeFrame,0);
  }
//+------------------------------------------------------------------+
double GetAverageRangeHigh()
  {
   double todayHigh=iHigh(NULL,timeFrame,0);
   double todayLow=iLow(NULL,timeFrame,0);

   double rangeHigh=GetTimeFrameLowestLow()+GetAverageRangeNumPeriods();;

   double averageRange=GetAverageRangeNumPeriods();

   if(todayHigh - todayLow > averageRange)
     {
      if(MarketInfo(NULL,MODE_BID) >= todayHigh- (todayHigh-todayLow)/2)
        {
         rangeHigh = todayLow + averageRange;

        }
      else
        {
         rangeHigh  = todayHigh;
        }
     }

   return rangeHigh;
  }
//+------------------------------------------------------------------+
double GetAverageRangeLow()
  {
   double todayHigh=iHigh(NULL,timeFrame,0);
   double todayLow=iLow(NULL,timeFrame,0);

   double rangeLow=GetTimeFrameHighestHigh()-GetAverageRangeNumPeriods();

   double averageRange=GetAverageRangeNumPeriods();

   if(todayHigh - todayLow > averageRange)
     {
      if(MarketInfo(NULL,MODE_BID) >= todayHigh- (todayHigh-todayLow)/2)
        {
         rangeLow  = todayLow;
        }
      else
        {
         rangeLow = todayHigh - averageRange;
        }
     }

   return rangeLow;
  }
//+------------------------------------------------------------------+
