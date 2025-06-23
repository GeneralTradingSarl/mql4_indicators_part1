//+------------------------------------------------------------------+
//|                                                   Didi Index.mq4 |
//|                                                Rudinei Felipetto |
//|                                         http://www.conttinua.com |
//+------------------------------------------------------------------+
#property copyright "Rudinei Felipetto"
#property link      "http://www.conttinua.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   3

//--- plot Curta
#property indicator_label1 "Curta"
#property indicator_type1  DRAW_LINE
#property indicator_color1 clrLime
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1
//--- plot Media
#property indicator_label2 "Media"
#property indicator_type2  DRAW_LINE
#property indicator_color2 clrWhite
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1
//--- plot Longa
#property indicator_label3 "Longa"
#property indicator_type3  DRAW_LINE
#property indicator_color3 clrYellow
#property indicator_style3 STYLE_SOLID
#property indicator_width3 1
//--- input parameters
extern int Curta=3;
extern ENUM_APPLIED_PRICE CurtaAppliedPrice = PRICE_CLOSE;
extern ENUM_MA_METHOD CurtaMethod = MODE_SMA;

extern int Media=8;
extern ENUM_APPLIED_PRICE MediaAppliedPrice = PRICE_CLOSE;
extern ENUM_MA_METHOD MediaMethod = MODE_SMA;

extern int Longa=20;
extern ENUM_APPLIED_PRICE LongaAppliedPrice = PRICE_CLOSE;
extern ENUM_MA_METHOD LongaMethod = MODE_SMA;

//--- indicator buffers
double CurtaBuffer[];
double MediaBuffer[];
double LongaBuffer[];

int init()
{
   SetIndexBuffer(0, CurtaBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, MediaBuffer, INDICATOR_DATA);
   SetIndexBuffer(2, LongaBuffer, INDICATOR_DATA);
   
   return(0);
}

int start()
{
   if(Bars<=Longa) return(0);

	CalculateDidiIndex();

   return(0);
  }
//+------------------------------------------------------------------+
void CalculateDidiIndex()
{
   for(int i = 1; i <= Bars; i++)
   {
      CurtaBuffer[i] = iMA(_Symbol, 0, Curta, 0, CurtaMethod, CurtaAppliedPrice, i);
      MediaBuffer[i] = iMA(_Symbol, 0, Media, 0, MediaMethod, MediaAppliedPrice, i);
      LongaBuffer[i] = iMA(_Symbol, 0, Longa, 0, LongaMethod, LongaAppliedPrice, i);
      
      CurtaBuffer[i] /= MediaBuffer[i];
      LongaBuffer[i] /= MediaBuffer[i];
      MediaBuffer[i] = 1;
   }
}
//+------------------------------------------------------------------+