//+------------------------------------------------------------------+
//|                                                 BackToFuture.mq4 |
//|                                                      Denis Orlov |
//|                                    http://denis-or-love.narod.ru |
/*
Индикатор Назад В Будущее рисует в тестере предстоящие бары заранее...

Описание:
Работает только в тестере, в режиме визуализации и на таймфрейме не менее 5M. 
Побробно:
http://codebase.mql4.com/ru/6305

The indicator Back In the Future draws forthcoming bars  in a tester, in advance...

The description:
Works only in a tester, in a mode of visualisation and on timeframe not less 5M. 
In detail:
http://codebase.mql4.com/6306


*/
//+------------------------------------------------------------------+
#property copyright "Denis Orlov"
#property link      "http://denis-or-love.narod.ru"


#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Turquoise
#property indicator_color2 Blue
#property indicator_color3 Turquoise
#property indicator_color4 Blue

extern int Future=30;
extern bool GoldColor=False;

double Line1[], Line2[], Line3[], Line4[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      if(Future<0) Future=0;

   SetIndexStyle(0,DRAW_HISTOGRAM,0,3);
   SetIndexBuffer(0,Line1);
   SetIndexShift( 0, Future); 
     
   SetIndexStyle(1,DRAW_HISTOGRAM,0,3);
   SetIndexBuffer(1,Line2);  
   SetIndexShift( 1, Future);
   
   SetIndexStyle(2,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(2,Line3);
   SetIndexShift( 2, Future);
   
   SetIndexStyle(3,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(3,Line4);
   SetIndexShift( 3, Future);
   
   if(GoldColor)
      {
         SetIndexStyle(0,DRAW_HISTOGRAM,0,3,Yellow);
         SetIndexStyle(1,DRAW_HISTOGRAM,0,3,Orange);
         SetIndexStyle(2,DRAW_HISTOGRAM,0,1,Yellow);
         SetIndexStyle(3,DRAW_HISTOGRAM,0,1,Orange);
      }
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
  if (Period()<5) return; 
  
  static int per;
  if (per == Time[0]) return; // один раз в бар
    per = Time[0];
   
   //int    counted_bars=IndicatorCounted();
    
       int pTF=PrevPer(Period());    
    int iB=iBarShift(NULL,pTF, per);
    if(iB==0) return;
    
    int K=MathRound(Period()/pTF);
    
    //Comment(TimeToStr(per)+";"+iBarShift(NULL,0, per-3000, true)+"\n"+
           // TimeToStr(TimeCurrent())+";"+iBarShift(NULL,0, TimeCurrent()-3000, true));
   
   
   ArrayInitialize( Line1, EMPTY_VALUE);
   ArrayInitialize( Line2, EMPTY_VALUE);
   ArrayInitialize( Line3, EMPTY_VALUE);
   ArrayInitialize( Line4, EMPTY_VALUE);
   
   iB=iB-K+1;//последний бар низшего периода от 0 бара текущего
   
   for(int i=Future-1; i>=0;i--)
      {
          
        iB=iB-K; //последний бар низшего периода от i бара текущего

          double 
          
           H=iHigh(NULL, pTF,iHighest( NULL ,pTF, MODE_HIGH, K, iB) ),
           L=iLow(NULL, pTF,iLowest( NULL ,pTF, MODE_LOW, K, iB)),
           O=iOpen(NULL, pTF,iB+K-1),//первый бар низшего периода от i бара текущего
           C=iClose(NULL, pTF,iB);

          // H=iHigh(Symbol(), Period(),iB-Future+i),
          // L=iLow(Symbol(), Period(),iB-Future+i),
          // O=iOpen(Symbol(), Period(),iB-Future+i),
         //  C=iClose(Symbol(), Period(),iB-Future+i);
           
           if(C>O)
            {
               Line1[i]=C; Line2[i]=O;
               Line3[i]=H; Line4[i]=L; 
            }
            else
            if(C<O)
            {
               Line1[i]=C; Line2[i]=O;
               Line3[i]=L; Line4[i]=H; 
            }
            else
            if(C==O)
            {
               Line1[i]=O; Line2[i]=C+0.01*Point;
               Line3[i]=L; Line4[i]=H; 
            }
              
      }
   
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
int PrevPer(int Per)
   {
      switch(Per)                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return(1); break;// Таймфрейм М1      
      case     5: return(1); break;// Таймфрейм М5      
      case    15: return(5); break;// Таймфрейм М15      
      case    30: return(15); break;// Таймфрейм М30      
      case    60: return(30); break;// Таймфрейм H1      
      case   240: return(60); break;// Таймфрейм H4      
      case  1440: return(240); break;// Таймфрейм D1      
      case 10080: return(1440); break;// Таймфрейм W1      
      case 43200: return(10080); break;// Таймфрейм МN     
      }
   }