//+------------------------------------------------------------------+
//|                                                      #MAMA.mq4   |
//|                                                                  |
//|                                        http://forex.kbpauk.ru/   |
//+------------------------------------------------------------------+

#property link      "http://forex.kbpauk.ru/"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue 
#property indicator_color2 Red
//---- input parameters
extern double FastLimit = 0.5;
extern double SlowLimit = 0.05;
//---- buffers
double FABuffer[];
double MABuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE,0,2);
   SetIndexStyle(1,DRAW_LINE,0,2);
   SetIndexBuffer(0,FABuffer);
   SetIndexBuffer(1,MABuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="#MAMA";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"#FAMA");
   SetIndexLabel(1,"#MAMA");
//----
   SetIndexDrawBegin(0,50);
   SetIndexDrawBegin(1,50);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|    #MAMA                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int limit=Bars-counted_bars,i=0;
   double jI,jQ,DeltaPhase,alpha,ttime;
   double Price[5],Smooth[8],Detrender[8],Q1[8],I1[8],I2[3],Q2[3];
   double Re[3],Im[3],SmoothPeriod[3],Period_[3],Phase[3],MAMA[3],FAMA[3];
//----
   if(Bars<=5)
      return(0);
//----
   if(counted_bars==0) i=limit-4;
//----
   while(i>=0)
     {
      Price[1] = ((High[i] + Low[i]) / 2);
      Price[2] = ((High[i+1] + Low[i+1]) / 2);
      Price[3] = ((High[i+2] + Low[i+2]) / 2);
      Price[4] = ((High[i+3] + Low[i+3]) / 2);
      Smooth[1]=(4*Price[1]+3*Price[2]+2*Price[3]+Price[4])/10;
      Detrender[1]=(0.0962*Smooth[1]+0.5769*Smooth[3]-0.5769*Smooth[5]-
                    0.0962*Smooth[7])*(0.075*Period_[2]+0.54);
      // {Compute InPhase and Quadrature components} 
      Q1[1]=(0.0962*Detrender[1]+0.5769*Detrender[3]-0.5769*Detrender[5]-
             0.0962*Detrender[7])*(0.075*Period_[2]+0.54);
      I1[1]=Detrender[4];
      // {Advance the phase of I1 and Q1 by 90 degrees} 
      jI=(0.0962*I1[1]+0.5769*I1[3]-0.5769*I1[5]-0.0962*I1[7])*
         (0.075*Period_[2]+0.54);
      jQ=(0.0962*Q1[1]+0.5769*Q1[3]-0.5769*Q1[5]-0.0962*Q1[7])*
         (0.075*Period_[2]+0.54);
      // {Phasor addition for 3 bar averaging)} 
      I2[1] = I1[1] - jQ;
      Q2[1] = Q1[1] + jI;
      // {Smooth the I and Q components before applying the discriminator} 
      I2[1] = 0.2*I2[1] + 0.8*I2[2];
      Q2[1] = 0.2*Q2[1] + 0.8*Q2[2];
      // {Homodyne Discriminator} 
      Re[1] = I2[1]*I2[2] + Q2[1]*Q2[2];
      Im[1] = I2[1]*Q2[2] - Q2[1]*I2[2];
      Re[1] = 0.2*Re[1] + 0.8*Re[2];
      Im[1] = 0.2*Im[1] + 0.8*Im[2];
      //----
      if(Im[1]!=0 && Re[1]!=0)
         Period_[1]=360/MathArctan(Im[1]/Re[1]);
      //----
      if(Period_[1]>1.5*Period_[2])
         Period_[1]=1.5*Period_[2];
      //----
      if(Period_[1]<0.67*Period_[2])
         Period_[1]=0.67*Period_[2];
      //----
      if(Period_[1]<6)
         Period_[1]=6;
      //----
      if(Period_[1]>50)
         Period_[1]=50;
      Period_[1]=0.2*Period_[1]+0.8*Period_[2];
      SmoothPeriod[1]=0.33*Period_[1]+0.67*SmoothPeriod[2];
      //----
      if(I1[1]!=0)
         Phase[1]=(MathArctan(Q1[1]/I1[1]));
      DeltaPhase=Phase[2]-Phase[1];
      //----
      if(DeltaPhase<1)
         DeltaPhase=1;
      alpha=FastLimit/DeltaPhase;
      //----
      if(alpha<SlowLimit)
         alpha=SlowLimit;
      MAMA[1] = alpha*Price[1] + (1 - alpha)*MAMA[2];
      FAMA[1] = 0.5*alpha*MAMA[1] + (1 - 0.5*alpha)*FAMA[2];
      FABuffer[i] = MAMA[1];
      MABuffer[i] = FAMA[1];
      //----
      Smooth[7] = Smooth[5];
      Smooth[6] = Smooth[5];
      Smooth[5] = Smooth[4];
      Smooth[4] = Smooth[3];
      Smooth[3] = Smooth[2];
      Smooth[2] = Smooth[1];
      //----
      Detrender[7] = Detrender[6];
      Detrender[6] = Detrender[5];
      Detrender[5] = Detrender[4];
      Detrender[4] = Detrender[3];
      Detrender[3] = Detrender[2];
      Detrender[2] = Detrender[1];
      //----
      Q1[7] = Q1[6];
      Q1[6] = Q1[5];
      Q1[5] = Q1[4];
      Q1[4] = Q1[3];
      Q1[3] = Q1[2];
      Q1[2] = Q1[1];
      //----
      I1[7] = I1[6];
      I1[6] = I1[5];
      I1[5] = I1[4];
      I1[4] = I1[3];
      I1[3] = I1[2];
      I1[2] = I1[1];
      //----
      Q2[2] = Q2[1];
      I2[2] = I2[1];
      Re[2] = Re[1];
      Im[2] = Im[1];
      SmoothPeriod[2]=SmoothPeriod[1];
      Phase[2]=Phase[1];
      Period_[2]=Period_[1];
      MAMA[2] = MAMA[1];
      FAMA[2] = FAMA[1];
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+
