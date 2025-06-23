//+------------------------------------------------------------------+
//|                                               CandlesticksBW.mq4 |
//|                                                         Vladimir |
//|                                         finance@allmotion.com.ua |
//+------------------------------------------------------------------+
// Раскраска свечей по Вильямсу
#property copyright "Vladimir"
#property link      "finance@allmotion.com.ua"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 LimeGreen
#property indicator_color2 Red
#property indicator_color3 LimeGreen 
#property indicator_color4 Red
#property indicator_color5 White

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtM;//----
int ExtCountedBars=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1,LimeGreen);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,1,Red);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2,LimeGreen);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,2,Red);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(4,DRAW_HISTOGRAM,0,1,White);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexStyle(5,DRAW_HISTOGRAM,0,1,White);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexStyle(4,DRAW_NONE,0,1,LimeGreen);

   return(0);
  }

int start()
  {ExtM=Point;
   if (Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   
   while (pos>=0)
     {
        	if (iAO(NULL,0,pos)>=iAO(NULL,0,pos+1) && iAC(NULL,0,pos)>=iAC(NULL,0,pos+1))
          {
           ExtMapBuffer1[pos]=High[pos];
           ExtMapBuffer2[pos]=Low[pos];
           if (Open[pos]>Close[pos]) 
             { ExtMapBuffer3[pos]=Open[pos]; ExtMapBuffer4[pos]=Close[pos]; }
         else 
           if (Open[pos]<Close[pos]) 
             { ExtMapBuffer3[pos]=Close[pos]; ExtMapBuffer4[pos]=Open[pos]; 
             ExtMapBuffer5[pos]=Open[pos]+ExtM;  ExtMapBuffer6[pos]=Close[pos]-ExtM;  }
           }
         if (iAO(NULL,0,pos)<=iAO(NULL,0,pos+1) && iAC(NULL,0,pos)<=iAC(NULL,0,pos+1))
	     	 {
           ExtMapBuffer1[pos]=Low[pos];
           ExtMapBuffer2[pos]=High[pos];
           if (Open[pos]<Close[pos]) 
             { ExtMapBuffer3[pos]=Open[pos]; ExtMapBuffer4[pos]=Close[pos];
               ExtMapBuffer5[pos]=Open[pos]+ExtM; ExtMapBuffer6[pos]=Close[pos]-ExtM;}
           else  
             if (Open[pos]>Close[pos]) 
               { ExtMapBuffer3[pos]=Close[pos]; ExtMapBuffer4[pos]=Open[pos]; }         
	  	       }
 	   pos--;
     }
   return(0);
  }