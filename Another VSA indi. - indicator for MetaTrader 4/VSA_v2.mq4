//+------------------------------------------------------------------+
//|                                     VSA        mich99@o2.pl      |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//----
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 YellowGreen
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Gray


#property indicator_level1 0

extern int TimeFrame = 0;

extern string        o="2 x MA trend";

extern int MA_per = 1;
extern int MA2_per = 1;
extern int MA_mode = 1;
extern int MA2_mode = 1;
extern int MA_price = 3;

extern int MA2_price = 2;


//---- buffers
double P1;
double P2;
double K1;
double K2;
double S1;
double S2;
double D1;
double D2;

double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
double P4Buffer[];



//----
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, P1Buffer);
   SetIndexBuffer(1, P2Buffer);
   SetIndexBuffer(2, P3Buffer);
   SetIndexBuffer(3, P4Buffer);
  
//----
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 6);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 1);
   
   IndicatorShortName("VSA_v2("+TimeFrame+","+MA_per+")");
//----
   IndicatorDigits(1);
   
   Comment(" Are You identifying Yourself with Your mind? ");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   int i,ii;
   static int pii=-1;
   
   for(i = 0; i <3000 ; i++)//iBars(Symbol(),TimeFrame)
     {
       ii = iBarShift(Symbol(), Period(), iTime(Symbol(),TimeFrame,i), true);
       //----
       if (pii!=ii)
       {
         P1=0;
         P2=0;
         K1=0;
         K2=0;        
         S1=0;
         S2=0;
         D1=0;
         D2=0;
         
         
         P1Buffer[ii]=0;
         P2Buffer[ii]=0;
         P3Buffer[ii]=0;
         P4Buffer[ii]=0;
         
       }
       
       if (ii != -1)
       {
         if (iVolume(Symbol(),TimeFrame,i)>iVolume(Symbol(),TimeFrame,i+1) && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)>iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)>iATR(Symbol(),TimeFrame, 1, i+1) )
         {
           P1 = P1+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
                
         if (iVolume(Symbol(),TimeFrame,i)>iVolume(Symbol(),TimeFrame,i+1) &&  iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)<iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)>iATR(Symbol(),TimeFrame, 1, i+1) )
         {
           P2 = P2+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));High[Highest(NULL,TimeFrame,MODE_HIGH,MA_per,i)]
         }
         
         
         
         
         
           if (iVolume(Symbol(),TimeFrame,i)>iVolume(Symbol(),TimeFrame,i+1)  && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)>iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)<iATR(Symbol(),TimeFrame, 1, i+1)  )
         {
           K1 = K1+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
         
        if (iVolume(Symbol(),TimeFrame,i)>iVolume(Symbol(),TimeFrame,i+1)  && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)<iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)<iATR(Symbol(),TimeFrame, 1, i+1)  )
         {
           K2 = K2+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
           
           
           
           
           
            if (iVolume(Symbol(),TimeFrame,i)<iVolume(Symbol(),TimeFrame,i+1)  && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)>iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)>iATR(Symbol(),TimeFrame, 1, i+1)  )
         {
           S1 = S1+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
         
        if (iVolume(Symbol(),TimeFrame,i)<iVolume(Symbol(),TimeFrame,i+1)  && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)<iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)>iATR(Symbol(),TimeFrame, 1, i+1)  )
         {
           S2 = S2+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
        
        
        
        
        
            if (iVolume(Symbol(),TimeFrame,i)<iVolume(Symbol(),TimeFrame,i+1)  && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)>iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)<iATR(Symbol(),TimeFrame, 1, i+1)  )
         {
           D1 = D1+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
         
        if (iVolume(Symbol(),TimeFrame,i)<iVolume(Symbol(),TimeFrame,i+1)  && iMA(NULL,TimeFrame,MA2_per,0,MA2_mode,MA2_price,i)<iMA(NULL,TimeFrame,MA_per,0,MA_mode,MA_price,i) &&  iATR(Symbol(),TimeFrame, 1, i)<iATR(Symbol(),TimeFrame, 1, i+1)  )
         {
           D2 = D2+iVolume(Symbol(),TimeFrame,i);//MathAbs(iClose(Symbol(),TimeFrame,i)-iClose(Symbol(),TimeFrame,i+1));
         }
        
        
         
         if (iVolume(Symbol(),TimeFrame,i)==iVolume(Symbol(),TimeFrame,i+1)   &&  iATR(Symbol(),TimeFrame, 2, i)==iATR(Symbol(),TimeFrame, 2, i+1) )
         {
           P1 = 0;//P1+(iVolume(Symbol(),TimeFrame,i)/2);
           P2 = 0;//P2-(iVolume(Symbol(),TimeFrame,i)/2);
         }
       }
       P1Buffer[ii]=P1-P2;
       P2Buffer[ii]=K1-K2;
       P3Buffer[ii]=S1-S2;
       P4Buffer[ii]=(D1-D2);
       
       pii=ii;
    }
//----
   return(0);
  }

