//+------------------------------------------------------------------+
//| CoreWinTT желает Вам успехов и удачи! :)                           
//+------------------------------------------------------------------+

//---- indicator settings

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 MediumPurple
#property indicator_color2 Magenta
#property indicator_color3 Aqua
#property indicator_color4 Silver
#property indicator_color5 Red
#property indicator_color6 Aquamarine
//---- indicator parameters
//extern string Setup =  "Classic 12 26 9";
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalEMA=9;
extern int OsmaX=2;

double  Zero_level=0.0;
double minuse;
double Vol;
//---- indicator buffers
double ind_buffer1[];
double ind_buffer2[];
double ind_buffer3[];
double ind_buffer4[];
double ind_buffer5[];
double ind_buffer6[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,1);
   SetIndexDrawBegin(1,"OsMA");
//---- indicator buffers mapping
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,ind_buffer3);
   SetIndexBuffer(3,ind_buffer4);
   SetIndexBuffer(4,ind_buffer5);
   SetIndexBuffer(5,ind_buffer6);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalEMA+")");
   SetIndexLabel(0,"OsMAW");
   SetIndexLabel(1,"OsMAS");
   SetIndexLabel(2,"OsMAB");
   SetIndexLabel(3,"OsMA");
   SetIndexLabel(4,"Signal");
   SetIndexLabel(5,"MACD");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   for(int i=0; i<limit; i++)
      ind_buffer6[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      ind_buffer5[i]=iMAOnArray(ind_buffer6,Bars,SignalEMA,0,MODE_EMA,i);
   for(i=0; i<limit; i++)
      ind_buffer4[i]=((iOsMA(NULL,0,FastEMA,SlowEMA,SignalEMA,PRICE_CLOSE,i))*OsmaX);
   for(i=0; i<limit; i++)
      ind_buffer3[i]=ind_buffer4[i];
   for(i=0; i<limit; i++)
      ind_buffer2[i]=ind_buffer4[i];
   for(i=0; i<limit; i++)
      ind_buffer1[i]=ind_buffer4[i];
//---- done

//---- Three Colour MACD mapping 
   for(i=0; i<limit; i++)
     {   //for open

      if(ind_buffer6[i]>ind_buffer6[i+1])
        {
         ind_buffer2[i]=Zero_level;

         Vol=ind_buffer1[i];     minuse=Vol-ind_buffer1[i+1];

         if(minuse>0.0){ind_buffer3[i]=Vol; ind_buffer2[i]=0.0; ind_buffer1[i]=0.0;}
         else 
           {
            if(minuse<0.0){ind_buffer3[i]=0.0; ind_buffer2[i]=0.0; ind_buffer1[i]=Vol;}
            else{ind_buffer3[i]=0.0; ind_buffer2[i]=0.0; ind_buffer1[i]=Vol;}
           }
        } //if Close
      else 
        {
         ind_buffer2[i]=Zero_level;

         Vol=ind_buffer1[i];     minuse=Vol-ind_buffer1[i+1];

         if(minuse>0.0){ind_buffer3[i]=0.0; ind_buffer2[i]=0.0; ind_buffer1[i]=Vol;}
         else 
           {
            if(minuse<0.0){ind_buffer3[i]=0.0; ind_buffer2[i]=Vol; ind_buffer1[i]=0.0;}
            else{ind_buffer4[i]=0.0; ind_buffer2[i]=0.0; ind_buffer1[i]=Vol;}
           }

        }
     }//for Close
   return(0);
  } 
//+------------------------------------------------------------------+
