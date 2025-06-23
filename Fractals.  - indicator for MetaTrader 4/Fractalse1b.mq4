//+------------------------------------------------------------------+
//|                                                     Fractals.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                                 Update by Kharko |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_width1 1
#property indicator_width2 1
//---- input parameters

//---- buffers
double ExtUpFractalsBuffer[];
double ExtDownFractalsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping  
   SetIndexBuffer(0,ExtUpFractalsBuffer);
   SetIndexBuffer(1,ExtDownFractalsBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,218);
//----
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
//---- name for DataWindow
   SetIndexLabel(0,"Fractal Up");
   SetIndexLabel(1,"Fractal Down");
//---- initialization done   
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
   int    i,nCountedBars;
   bool   bFound;
   double dCurrent;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+5;
   i=limit;
//----Up and Down Fractals
   while(i>=3)
     {
      //----Fractals up
      bFound=false;
      dCurrent=High[i];
      if(dCurrent>High[i+1] && dCurrent>High[i+2] && dCurrent>High[i-1] && dCurrent>High[i-2] && Volume[i-3]>0)
        {
         bFound=true;
         ExtUpFractalsBuffer[i]=dCurrent;
        }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
        {
         if(dCurrent==High[i+1] && dCurrent>High[i+2] && dCurrent>High[i+3] && 
            dCurrent>High[i-1] && dCurrent>High[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
        {
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent>High[i+3] && dCurrent>High[i+4] && 
            dCurrent>High[i-1] && dCurrent>High[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
        {
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent==High[i+3] && dCurrent>High[i+4] && dCurrent>High[i+5] && 
            dCurrent>High[i-1] && dCurrent>High[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
        {
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent>=High[i+3] && dCurrent==High[i+4] && dCurrent>High[i+5] && 
            dCurrent>High[i+6] && dCurrent>High[i-1] && dCurrent>High[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }
      //----Fractals down
      bFound=false;
      dCurrent=Low[i];
      if(dCurrent<Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i-1] && dCurrent<Low[i-2] && Volume[i-3]>0)
        {
         bFound=true;
         ExtDownFractalsBuffer[i]=dCurrent;
        }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
        {
         if(dCurrent==Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i+3] && 
            dCurrent<Low[i-1] && dCurrent<Low[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }
        }
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
        {
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<Low[i+3] && dCurrent<Low[i+4] && 
            dCurrent<Low[i-1] && dCurrent<Low[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }
        }
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
        {
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent==Low[i+3] && dCurrent<Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i-1] && dCurrent<Low[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }
        }
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
        {
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<=Low[i+3] && dCurrent==Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i+6] && dCurrent<Low[i-1] && dCurrent<Low[i-2] && Volume[i-3]>0)
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }
        }
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
