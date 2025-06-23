//+------------------------------------------------------------------+
//|                                   Camarilla_Pivot_Lines_v1.0.mq4 |
//|                                         Copyright 2020, NickBixy |
//|             https://www.forexfactory.com/showthread.php?t=904734 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, NickBixy"
#property link      "https://www.forexfactory.com/showthread.php?t=904734"
//#property version   "1.00"
#property strict
#property indicator_chart_window

enum pivotTypes
  {

   Camarilla,//Camarilla Pivot Formula

  };

input string Header="----------------- Settings------------------------------------------";//----- Settings
pivotTypes pivotSelection=Camarilla;//Pivot Point Formula
input ENUM_TIMEFRAMES timeFrame=PERIOD_D1;//TimeFrame
input bool useShortLines=false;
input int Line_Length=15;

input string Font="Arial Narrow";//Font
input int labelFontSize=9;//Font Size
input int ShiftLabel=5;//Label Shift +move right -move left
input ENUM_LINE_STYLE lineStyle=STYLE_DOT;//Line Style
input color resistantColor=clrRed;//Resistant PP Color
input color supportColor=clrLime;//Support PP Color
input color pivotColor=clrYellow;//Pivot Color
input string customMSG="";
string indiName="CamPivot"+" "+EnumToString(timeFrame);

string camarillaPivotNames[]=
  {
   "L3 L",
   "L4 SBO",
   "H3 S",
   "H4 LBO",
   "H5 LBT",
   "L5 SBT",
  };
double camarillaValueArray[6];

//+------------------------------------------------------------------+
int OnInit()
  {
   ObjectsDeleteAll(0,"CamPivot",0,OBJ_TREND) ;
   ObjectsDeleteAll(0,"CamPivot",0,OBJ_TEXT) ;


   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void deinit()
  {
   ObjectsDeleteAll(0,"CamPivot",0,OBJ_TREND) ;
   ObjectsDeleteAll(0,"CamPivot",0,OBJ_TEXT) ;
  }
//+------------------------------------------------------------------+
int start()
  {
   if(pivotSelection==Camarilla)
     {
      camarillaPivotPoint(camarillaValueArray);
      for(int i=0; i<ArraySize(camarillaValueArray); i++)
        {
         DrawPivotLines(camarillaValueArray[i],camarillaPivotNames[i]);
        }
     }

   return 0;
  }
//+------------------------------------------------------------------+
void DrawPivotLines(double value,string pivotName)
  {
   color lineLabelColor=clrNONE;
   color lineColor=clrNONE;
   int lineWidth=1;

   if(pivotName=="H3 S" || pivotName=="L4 SBO")
     {
      lineLabelColor=clrRed;
      lineColor=clrRed;
      lineWidth=1;
     }

   if(pivotName=="H4 LBO" || pivotName=="L3 L")
     {
      lineLabelColor=clrLime;
      lineColor=clrLime;
      lineWidth=1;
     }

   if(pivotName=="H5 LBT")
     {
      lineLabelColor=clrDeepSkyBlue;
      lineColor=clrDeepSkyBlue;
      lineWidth=1;
     }

   if(pivotName=="L5 SBT")
     {
      lineLabelColor=clrDeepSkyBlue;
      lineColor=clrDeepSkyBlue;
      lineWidth=1;
     }

   string message=customMSG+pivotName;

   string nameLine=indiName+pivotName+" Line";
   string nameLabel=indiName+pivotName+" Label";
   if(ObjectFind(nameLine) != 0)
     {
      if(useShortLines==true)
        {
         ObjectCreate(nameLine, OBJ_TREND, 0, Time[1]+Period()*60, value, Time[0]+Period()*60*Line_Length, value);
         ObjectSet(nameLine,OBJPROP_RAY,false);
        }
      else
        {
         ObjectCreate(nameLine,OBJ_TREND,0,iTime(NULL,timeFrame,0),value,Time[0]+Period()*60,value);
         ObjectSet(nameLine,OBJPROP_RAY,true);
        }
      ObjectSet(nameLine,OBJPROP_COLOR,lineColor);
      ObjectSet(nameLine,OBJPROP_STYLE,lineStyle);
      ObjectSet(nameLine,OBJPROP_WIDTH,lineWidth);
      ObjectSet(nameLine,OBJPROP_BACK,true);
      ObjectSet(nameLine,OBJPROP_SELECTED,false);
      ObjectSet(nameLine,OBJPROP_SELECTABLE,false);
     }
   else
     {
      if(useShortLines==true)
        {
         ObjectMove(nameLine, 0, Time[1]+Period()*60, value);
         ObjectMove(nameLine, 1, Time[0]+Period()*60*Line_Length, value);
        }
      else
        {
         ObjectMove(nameLine,0,iTime(NULL,timeFrame,0),value);
         ObjectMove(nameLine,1,Time[0]+Period()*60,value);
        }

     }
   if(ObjectFind(nameLabel) != 0)
     {
      ObjectCreate(nameLabel,OBJ_TEXT,0,Time[0]+Period()*60*ShiftLabel,value);
      ObjectSetText(nameLabel,message,labelFontSize,Font,lineLabelColor);
      ObjectSet(nameLabel,OBJPROP_BACK,true);
      ObjectSet(nameLabel,OBJPROP_SELECTED,false);
      ObjectSet(nameLabel,OBJPROP_SELECTABLE,false);
     }
   else
     {
      ObjectMove(nameLabel, 0,Time[0]+Period()*60*ShiftLabel,value);
      ObjectSetText(nameLabel,message,labelFontSize,Font,lineLabelColor);
     }
   ChartRedraw(0);
  }
//camarilla formula
void camarillaPivotPoint(double &ppArrayRef[])//camrilla pivot point formula
  {
  
   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(NULL,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(NULL,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday
        {
         shift+=1;
        }
     }
  
   double camRange= iHigh(NULL,timeFrame,shift)-iLow(NULL,timeFrame,shift);
   double prevHigh=iHigh(NULL,timeFrame,shift);
   double prevLow=iLow(NULL,timeFrame,shift);
   double prevClose=iClose(NULL,timeFrame,shift);
   int symbolDigits=(int)MarketInfo(NULL,MODE_DIGITS);

   double H3 = ((1.1 / 4) * camRange) + prevClose;
   double H4= ((1.1/2) * camRange)+prevClose;

   double L3 = prevClose - ((1.1 / 4) * camRange);

   double L4 = prevClose - ((1.1 / 2) * camRange);

   double H5=((prevHigh/prevLow)*prevClose);
   double L5=(prevClose-(H5-prevClose));


   ppArrayRef[0]=L3;
   ppArrayRef[1]=L4;

   ppArrayRef[2]=H3;
   ppArrayRef[3]=H4;

   ppArrayRef[4]=H5;
   ppArrayRef[5]=L5;
  }
//+------------------------------------------------------------------+
