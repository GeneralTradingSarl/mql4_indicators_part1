//+------------------------------------------------------------------+
//|                                             Fractional_Bands.mq4 |
//|                      Copyright © 2009, jppoton@yahoo.com         |
//|                              http://fractalfinance.blogspot.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, jppoton@yahoo.com"
#property link      "http://fractalfinance.blogspot.com/"

#property indicator_chart_window

#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_width1 2
#property indicator_color2 Yellow
#property indicator_width2 1
#property indicator_color3 Yellow
#property indicator_width3 1
//************************************************************
// Input parameters
//************************************************************
extern int    e_period         =30;
extern int    normal_speed     =30;
extern int    PIP_Convertor    =10000;
extern int    shift            =0;  
extern int    e_type_data      =PRICE_CLOSE;
//************************************************************
// Constant
//************************************************************
string INDICATOR_NAME="Fractional Bands";
string FILENAME      ="Fractional_bands.mq4";
double LOG_2;
//************************************************************
// Private vars
//************************************************************
double ExtOutputBuffer[];
double UpperBuffer[];
double LowerBuffer[];
int g_period_minus_1;
//+-----------------------------------------------------------------------+
//| FUNCTION : init                                                       |                                                                                                                                                                                                                                                      
//| Initialization function                                               |                                   
//| Check the user input parameters and convert them in appropriate types.|                                                                                                    
//+-----------------------------------------------------------------------+
int init()
  {
   // Check e_period input parameter
   if(e_period < 2 )
     {
      Alert( "[ 10-ERROR  " + FILENAME + " ] input parameter \"e_period\" must be >= 1 (" + e_period + ")" );
      return( -1 );
     }
   if(e_type_data < PRICE_CLOSE || e_type_data > PRICE_WEIGHTED )
     {
      Alert( "[ 20-ERROR  " + FILENAME + " ] input parameter \"e_type_data\" unknown (" + e_type_data + ")" );
      return( -1 );
     }
   IndicatorBuffers(3);
   SetIndexBuffer(0,ExtOutputBuffer);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(1,UpperBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(2,LowerBuffer);
   SetIndexStyle(2,DRAW_LINE);

   SetIndexDrawBegin(0,2*e_period);
   SetIndexDrawBegin(1,2*e_period);
   SetIndexDrawBegin(2,2*e_period);
   
   g_period_minus_1=e_period - 1;
   LOG_2=MathLog( 2.0 );
//----
   return( 0 );
  }
//+------------------------------------------------------------------+
//| FUNCTION : deinit                                                |
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| FUNCTION : start                                                 |
//| This callback is fired by metatrader for each tick               |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(e_period,g_period_minus_1);

   _computeLastNbBars(limit);
//----
   return( 0 );
  }
//+================================================================================================================+
//+=== FUNCTION : _computeLastNbBars                                                                            ===+
//+===                                                                                                          ===+
//+===                                                                                                          ===+
//+=== This callback is fired by metatrader for each tick                                                       ===+
//+===                                                                                                          ===+
//+=== In :                                                                                                     ===+
//+===    - lastBars : these "n" last bars must be repainted                                                    ===+
//+===                                                                                                          ===+
//+================================================================================================================+
//+------------------------------------------------------------------+
//| FUNCTION : _computeLastNbBars                                    |
//| This callback is fired by metatrader for each tick               |
//| In : - lastBars : these "n" last bars must be repainted          | 
//+------------------------------------------------------------------+
double tmpArray[];
void _computeLastNbBars( int lastBars )
  {
   switch( e_type_data )
     {
      case PRICE_CLOSE  : ArrayCopy(tmpArray,Close,0,0,WHOLE_ARRAY); FRACTIONAL_BANDS(lastBars, tmpArray); break;
      case PRICE_OPEN   : ArrayCopy(tmpArray,Open,0,0,WHOLE_ARRAY);  FRACTIONAL_BANDS(lastBars, tmpArray); break;
      case PRICE_HIGH   : ArrayCopy(tmpArray,High,0,0,WHOLE_ARRAY);  FRACTIONAL_BANDS(lastBars, tmpArray); break;
      case PRICE_LOW    : ArrayCopy(tmpArray,Low,0,0,WHOLE_ARRAY);   FRACTIONAL_BANDS(lastBars, tmpArray); break;    
      
      default :
         Alert( "[ 20-ERROR  " + FILENAME + " ] the imput parameter e_type_data <" + e_type_data + "> is unknown" );
     }
  }
//+------------------------------------------------------------------+
//| FUNCTION : FRACTIONAL_BANDS                                         |
//| Compute the Fractional Bands for input data                         |
//| In :                                                             |
//|    - lastBars : these "n" last bars are considered for           |
//|      calculating the fractal dimension                           |
//|    - inputData : data array on which the computation is applied  | 
//| For further theoretical explanations, see my blog:               |  
//|    http://fractalfinance.blogspot.com/                           |
//+------------------------------------------------------------------+
void FRACTIONAL_BANDS( int lastBars, double &inputData[] )
  {
   int    pos, iteration;
   double diff, priorDiff;
   double length;
   double priceMax, priceMin;
   double fdi,trail_dim,beta,sum,newres,deviation,frasma,hurst;
   int    speed,k;
//----
   for( pos=lastBars; pos>=0; pos-- )
     {
      priceMax=_highest( e_period, pos, inputData );
      priceMin=_lowest( e_period, pos, inputData );
      length   =0.0;
      priorDiff=0.0;
//----
      for( iteration=0; iteration <= g_period_minus_1; iteration++ )
        {
         if(( priceMax - priceMin)> 0.0 )
           {
            diff =(inputData[pos + iteration] - priceMin )/( priceMax - priceMin );
            if(iteration > 0 )
              {
               length+=MathSqrt( MathPow( diff - priorDiff, 2.0)+(1.0/MathPow( e_period, 2.0)) );
              }
            priorDiff=diff;
           }
        }
      if(length > 0.0 )
        {
         fdi=1.0 +(MathLog( length)+ LOG_2 )/MathLog( 2 * g_period_minus_1 );
        }
      else
        {
         /*
         ** The FDI algorithm suggests in this case a zero value.
         ** I prefer to use the previous FDI value.
         */
         fdi=0.0;
        }
      hurst=2-fdi; // The Hurst exponent
      trail_dim=1/hurst; // This is the trail dimension, the inverse of the Hurst-Holder exponent 
      beta=trail_dim/2;
      speed=MathRound(normal_speed*beta);
      ExtOutputBuffer[pos-shift]=iMA(NULL,0,speed,0,0,0,pos); // Buffer of the FRASMA
      sum=0.0;
      k=pos+g_period_minus_1;
      frasma=PIP_Convertor*ExtOutputBuffer[pos-shift];
      while(k>=pos)
        {
         newres=PIP_Convertor*Close[k]-frasma;
         sum+=newres*newres;
         k--;
        }
      deviation=MathSqrt(sum/e_period);  // standard deviation around the frasma (measured in PIPS) 
      UpperBuffer[pos-shift]=(frasma+2*MathPow(deviation,2*hurst))/PIP_Convertor;
      LowerBuffer[pos-shift]=(frasma-2*MathPow(deviation,2*hurst))/PIP_Convertor;
     }
  }
//+------------------------------------------------------------------+
//| FUNCTION : _highest                                              |
//| Search for the highest value in an array data                    |
//| In :                                                             |
//|    - n : find the highest on these n data                        |
//|    - pos : begin to search for from this index                   |
//|    - inputData : data array on which the searching for is done   |
//|                                                                  |
//| Return : the highest value                                       |                                                 |
//+------------------------------------------------------------------+
double _highest( int n, int pos, double &inputData[] )
  {
   int length=pos + n;
   double highest=0.0;
//----
   for( int i=pos; i < length; i++ )
     {
      if(inputData[i] > highest)highest=inputData[i];
     }
   return( highest );
  }
//+------------------------------------------------------------------+
//| FUNCTION : _lowest                                               |                                                                                                          ===+
//| Search for the lowest value in an array data                     |
//| In :                                                             |
//|    - n : find the hihest on these n data                         |
//|    - pos : begin to search for from this index                   |
//|    - inputData : data array on which the searching for is done   |
//|                                                                  |
//| Return : the highest value                                       |
//+------------------------------------------------------------------+
double _lowest( int n, int pos, double &inputData[] )
  {
   int length=pos + n;
   double lowest=9999999999.0;
//----
   for( int i=pos; i < length; i++ )
     {
      if(inputData[i] < lowest)lowest=inputData[i];
     }
   return( lowest );
  }
//+------------------------------------------------------------------+