//+------------------------------------------------------------------+
//|                                             Fractals5+Signal.mq4 |
//+------------------------------------------------------------------+
#property copyright "© Maloma"
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 clrRed
#property indicator_color2 clrBlue
#property indicator_color3 clrOrangeRed
#property indicator_color4 clrCornflowerBlue
#property indicator_color5 clrMagenta
#property indicator_color6 clrTeal
//---- input parameters
//---- buffers
double dUpFractalsBuffer[];
double dDownFractalsBuffer[];
double dUpSignalBuffer[];
double dDownSignalBuffer[];
double UpDiapazonBuffer[];
double DnDiapazonBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping  
   SetIndexBuffer(0,dUpFractalsBuffer);
   SetIndexBuffer(1,dDownFractalsBuffer);
   SetIndexBuffer(2,dUpSignalBuffer);
   SetIndexBuffer(3,dDownSignalBuffer);
   SetIndexBuffer(4,UpDiapazonBuffer);
   SetIndexBuffer(5,DnDiapazonBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2);
   SetIndexArrow(0,119);
   SetIndexStyle(1,DRAW_ARROW,EMPTY,2);
   SetIndexArrow(1,119);
   SetIndexStyle(2,DRAW_ARROW,EMPTY,2);
   SetIndexArrow(2,241);
   SetIndexStyle(3,DRAW_ARROW,EMPTY,2);
   SetIndexArrow(3,242);
   SetIndexStyle(4,DRAW_SECTION,EMPTY,2);
   SetIndexStyle(5,DRAW_SECTION,EMPTY,2);
//----
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
//---- name for DataWindow
   SetIndexLabel(0,"Fractal Up");
   SetIndexLabel(1,"Fractal Down");
   SetIndexLabel(2,"Signal Up");
   SetIndexLabel(3,"Signal Down");
   SetIndexLabel(4,"Diapazon Up");
   SetIndexLabel(5,"Diapazon Down");
//---- initialization done   
   IndicatorShortName("F5S");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,nCountedBars;
   nCountedBars=IndicatorCounted();
//---- check for possible errors
   if(nCountedBars<0 || Bars<5) return(-1);
//----
   i=Bars-nCountedBars-(1+3+2);
   while(i>=0)
     {
      //----Up and Down Fractals
      //----5 bars Fractal
      if(High[i+3]>High[i+3+1] && High[i+3]>High[i+3+2] && High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]= Low[i]-3*Point;
         dUpFractalsBuffer[i+3]= High[i+3];
         UpDiapazonBuffer[i]= Open[i];
         UpDiapazonBuffer[i+3]= High[i+3];
        }
      if(Low[i+3]<Low[i+3+1] && Low[i+3]<Low[i+3+2] && Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]= High[i]+3*Point;
         dDownFractalsBuffer[i+3]= Low[i+3];
         DnDiapazonBuffer[i]= Open[i];
         DnDiapazonBuffer[i+3]= Low[i+3];
         i--;
         continue;
        }
      //----6 bars Fractal
      if(High[i+3]==High[i+3+1] && High[i+3]>High[i+3+2] && High[i+3]>High[i+3+3] && High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]= Low[i]-3*Point;
         dUpFractalsBuffer[i+3]= High[i+3];
         UpDiapazonBuffer[i]= Open[i];
         UpDiapazonBuffer[i+3]= High[i+3];
        }
      if(Low[i+3]==Low[i+3+1] && Low[i+3]<Low[i+3+2] && Low[i+3]<Low[i+3+3] && Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]= High[i]+3*Point;
         dDownFractalsBuffer[i+3]= Low[i+3];
         DnDiapazonBuffer[i]= Open[i];
         DnDiapazonBuffer[i+3]= Low[i+3];
         i--;
         continue;
        }
      //----7 bars Fractal
      if(High[i+3]>=High[i+3+1] && High[i+3]==High[i+3+2] && High[i+3]>High[i+3+3] && High[i+3]>High[i+3+4] && High[i+3]>High[i+3-1] &&
         High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]= Low[i]-3*Point;
         dUpFractalsBuffer[i+3]= High[i+3];
         UpDiapazonBuffer[i]= Open[i];
         UpDiapazonBuffer[i+3]= High[i+3];
        }
      if(Low[i+3]<=Low[i+3+1] && Low[i+3]==Low[i+3+2] && Low[i+3]<Low[i+3+3] && Low[i+3]<Low[i+3+4] && Low[i+3]<Low[i+3-1] &&
         Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]= High[i]+3*Point;
         dDownFractalsBuffer[i+3]= Low[i+3];
         DnDiapazonBuffer[i]= Open[i];
         DnDiapazonBuffer[i+3]= Low[i+3];
         i--;
         continue;
        }
      //----8 bars Fractal                          
      if(High[i+3]>=High[i+3+1] && High[i+3]==High[i+3+2] && High[i+3]==High[i+3+3] && High[i+3]>High[i+3+4] && High[i+3]>High[i+3+5] &&
         High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]= Low[i]-3*Point;
         dUpFractalsBuffer[i+3]= High[i+3];
         UpDiapazonBuffer[i]= Open[i];
         UpDiapazonBuffer[i+3]= High[i+3];
        }
      if(Low[i+3]<=Low[i+3+1] && Low[i+3]==Low[i+3+2] && Low[i+3]==Low[i+3+3] && Low[i+3]<Low[i+3+4] && Low[i+3]<Low[i+3+5] &&
         Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]= High[i]+3*Point;
         dDownFractalsBuffer[i+3]= Low[i+3];
         DnDiapazonBuffer[i]= Open[i];
         DnDiapazonBuffer[i+3]= Low[i+3];
         i--;
         continue;
        }
      //----9 bars Fractal                                        
      if(High[i+3]>=High[i+3+1] && High[i+3]==High[i+3+2] && High[i+3]>=High[i+3+3] && High[i+3]==High[i+3+4] && High[i+3]>High[i+3+5] &&
         High[i+3]>High[i+3+6] && High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]= Low[i]-3*Point;
         dUpFractalsBuffer[i+3]= High[i+3];
         UpDiapazonBuffer[i]= Open[i];
         UpDiapazonBuffer[i+3]= High[i+3];
        }
      if(Low[i+3]<=Low[i+3+1] && Low[i+3]==Low[i+3+2] && Low[i+3]<=Low[i+3+3] && Low[i+3]==Low[i+3+4] && Low[i+3]<Low[i+3+5] &&
         Low[i+3]<Low[i+3+6] && Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]= High[i]+3*Point;
         dDownFractalsBuffer[i+3]= Low[i+3];
         DnDiapazonBuffer[i]= Open[i];
         DnDiapazonBuffer[i+3]= Low[i+3];
         i--;
         continue;
        }
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+