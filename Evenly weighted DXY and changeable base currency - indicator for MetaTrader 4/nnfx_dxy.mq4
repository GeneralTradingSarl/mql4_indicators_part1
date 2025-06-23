//+------------------------------------------------------------------+
//|                                                      NNFX_DXY    |
//|                                                      Karel Nagel |
//+------------------------------------------------------------------+
#property copyright "Karel Nagel"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 White
#property indicator_width1 1
#property strict
double Buffer[];
double exponent=0.142857142;
input int limit=300; //Bars
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum allSymbols
  {
   usd, //USD
   eur, //EUR
   jpy, //JPY
   gbp, //GBP
   cad, //CAD
   chf, //CHF
   aud, //AUD
   nzd, //NZD

  };
string symbols[]={"USD","EUR","JPY","GBP","CAD","CHF","AUD","NZD"};
input allSymbols mainSymbol=0;  //Symbol
string pairs[7];
int i,j,k;
string symbol=symbols[mainSymbol];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Buffer);
   for(i=0;i<SymbolsTotal(false);i++)
     {
      string pair=SymbolName(i,false);
      for(j=0;j<ArraySize(symbols);j++)
        {
         if(StringFind(pair,symbol,0)!=-1 && StringFind(pair,symbols[j],0)!=-1 && symbols[mainSymbol]!=symbols[j])
           {
            pairs[k]=pair;
            k++;
           }
         else continue;
        }
     }
//Print(pairs[0],"  ",pairs[1],"  ",pairs[2],"  ",pairs[3],"  ",pairs[4],"  ",pairs[5],"  ",pairs[6]);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   for(i=0; i<limit; i++)
     {
      IndicatorShortName(symbol);
      Buffer[i]=50.14348112*MathPow(iClose(pairs[0],0,i),-exponent)*MathPow(iClose(pairs[1],0,i),exponent)*MathPow(iClose(pairs[2],0,i),-exponent)*MathPow(iClose(pairs[3],0,i),exponent)*MathPow(iClose(pairs[4],0,i),exponent)*MathPow(iClose(pairs[5],0,i),-exponent)*MathPow(iClose(pairs[6],0,i),-exponent);
     }

   return(0);
  }
//+------------------------------------------------------------------+
