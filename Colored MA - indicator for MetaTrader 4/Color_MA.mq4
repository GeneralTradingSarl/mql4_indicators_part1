//+------------------------------------------------------------------+
//|                                                     Color_MA.mq4 |
//|                                                      Денис Орлов |
//|                                    http://denis-or-love.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Денис Орлов"
#property link      "http://denis-or-love.narod.ru"

#property indicator_chart_window

#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Silver

extern int PeriodAv=12;
extern int Flat=1;
extern color ColorUp=Green;
extern color ColorDown=Red;
extern color ColorFlat=Silver;
extern int Width=2;


double Line1[], Line2[],  Line3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
    SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,Width,ColorUp);//DRAW_LINE
   SetIndexBuffer(0,Line1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,Width,ColorDown);
   SetIndexBuffer(1,Line2);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,Width,ColorFlat);//DRAW_LINE
   SetIndexBuffer(2,Line3);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
       int    i, Counted_bars=IndicatorCounted();
      
     i=Bars-Counted_bars-1;           // Индекс первого непосчитанного  

      while(i>=0)                      // Цикл по непосчитанным барам     
      { 
         double MA_0=iMA(NULL,0,PeriodAv,0,MODE_EMA,PRICE_CLOSE,i),
         MA_2=iMA(NULL,0,PeriodAv,0,MODE_EMA,PRICE_CLOSE,i+1);
         
         if(MA_0>MA_2) Line1[i]=MA_0;
            else
         if(MA_0<MA_2) Line2[i]=MA_0;
            else //if(MA_0==MA_2)
          Line3[i]=MA_0;
         i--;
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+