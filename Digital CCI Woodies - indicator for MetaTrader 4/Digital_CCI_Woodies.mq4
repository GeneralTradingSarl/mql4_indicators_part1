//+------------------------------------------------------------------+
//|                                                          CCI.mq4 |
//|                                              Ramdass programmed  |
//|                               Digital filter from Kenny-Goodman  |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 clrDodgerBlue
#property indicator_color2 clrRed
//---- input parameters
extern int CCIPeriod=14;
extern int CCIPeriod2=6;
//---- buffers
double CCIBuffer[];
double RelBuffer[];
double DevBuffer[];
double MovBuffer[];
//---
double CCIBuffer2[];
double RelBuffer2[];
double DevBuffer2[];
double MovBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 3 additional buffers are used for counting.
   IndicatorBuffers(8);
   SetIndexBuffer(2,RelBuffer);
   SetIndexBuffer(3,DevBuffer);
   SetIndexBuffer(4,MovBuffer);
//---
   SetIndexBuffer(5,RelBuffer2);
   SetIndexBuffer(6,DevBuffer2);
   SetIndexBuffer(7,MovBuffer2);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,clrSteelBlue);
   SetIndexBuffer(0,CCIBuffer);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1,clrRed);
   SetIndexBuffer(1,CCIBuffer2);
//---- name for DataWindow and indicator subwindow label
   short_name="CCI("+(string)CCIPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,CCIPeriod);
   SetIndexDrawBegin(1,CCIPeriod2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Commodity Channel Index                                          |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k,counted_bars=IndicatorCounted();
   double price,sum,mul;
   if(Bars<=CCIPeriod || Bars<=CCIPeriod2) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=CCIPeriod;i++) CCIBuffer[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod;i++) DevBuffer[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod;i++) MovBuffer[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod2;i++) CCIBuffer2[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod2;i++) DevBuffer2[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod2;i++) MovBuffer2[Bars-i]=0.0;
     }
//---- last counted bar will be recounted
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   if(counted_bars==0) limit-=26;
//---- moving average
   sum=0;
   int pos=Bars-counted_bars-1-25;
   if(Bars-26<=0)
     {
      Print("Not enough bars");
      return(0);
     }
//---- initial accumulation
   if(pos<CCIPeriod) pos=CCIPeriod;
   
   for(i=1;i<CCIPeriod;i++,pos--)
      sum+=0.225654509516691*Close[pos+0]
           +0.219241264585139*Close[pos+1]
           +0.200688479689899*Close[pos+2]
           +0.171992513765923*Close[pos+3]
           +0.136270408129286*Close[pos+4]
           +0.0971644469103302*Close[pos+5]
           +0.0585064796603445*Close[pos+6]
           +0.0237448140297671*Close[pos+7]
           -0.00442869436477854*Close[pos+8]
           -0.0243636783229045*Close[pos+9]
           -0.0355617365834807*Close[pos+10]
           -0.0386306817434228*Close[pos+11]
           -0.0350564564449243*Close[pos+12]
           -0.0268963490805002*Close[pos+13]
           -0.0164157887033052*Close[pos+14]
           -0.00573862260748731*Close[pos+15]
           +0.00342620684434*Close[pos+16]
           +0.00996574022237624*Close[pos+17]
           +0.0134223280887248*Close[pos+18]
           +0.0139394004237978*Close[pos+19]
           +0.0121149938483286*Close[pos+20]
           +0.00883315067608292*Close[pos+21]
           +0.0050235681107559*Close[pos+22]
           +0.00151954406404245*Close[pos+23]
           -0.00108567173532015*Close[pos+24]
           -0.0133301689797048*Close[pos+25];
//---- main calculation loop
   while(pos>=0)
     {
      sum+=0.225654509516691*Close[pos+0]
           +0.219241264585139*Close[pos+1]
           +0.200688479689899*Close[pos+2]
           +0.171992513765923*Close[pos+3]
           +0.136270408129286*Close[pos+4]
           +0.0971644469103302*Close[pos+5]
           +0.0585064796603445*Close[pos+6]
           +0.0237448140297671*Close[pos+7]
           -0.00442869436477854*Close[pos+8]
           -0.0243636783229045*Close[pos+9]
           -0.0355617365834807*Close[pos+10]
           -0.0386306817434228*Close[pos+11]
           -0.0350564564449243*Close[pos+12]
           -0.0268963490805002*Close[pos+13]
           -0.0164157887033052*Close[pos+14]
           -0.00573862260748731*Close[pos+15]
           +0.00342620684434*Close[pos+16]
           +0.00996574022237624*Close[pos+17]
           +0.0134223280887248*Close[pos+18]
           +0.0139394004237978*Close[pos+19]
           +0.0121149938483286*Close[pos+20]
           +0.00883315067608292*Close[pos+21]
           +0.0050235681107559*Close[pos+22]
           +0.00151954406404245*Close[pos+23]
           -0.00108567173532015*Close[pos+24]
           -0.0133301689797048*Close[pos+25];
      //---
      MovBuffer[pos]=sum/CCIPeriod;
      //---
      sum-=0.225654509516691*Close[pos+CCIPeriod-1+0]
           +0.219241264585139*Close[pos+CCIPeriod-1+1]
           +0.200688479689899*Close[pos+CCIPeriod-1+2]
           +0.171992513765923*Close[pos+CCIPeriod-1+3]
           +0.136270408129286*Close[pos+CCIPeriod-1+4]
           +0.0971644469103302*Close[pos+CCIPeriod-1+5]
           +0.0585064796603445*Close[pos+CCIPeriod-1+6]
           +0.0237448140297671*Close[pos+CCIPeriod-1+7]
           -0.00442869436477854*Close[pos+CCIPeriod-1+8]
           -0.0243636783229045*Close[pos+CCIPeriod-1+9]
           -0.0355617365834807*Close[pos+CCIPeriod-1+10]
           -0.0386306817434228*Close[pos+CCIPeriod-1+11]
           -0.0350564564449243*Close[pos+CCIPeriod-1+12]
           -0.0268963490805002*Close[pos+CCIPeriod-1+13]
           -0.0164157887033052*Close[pos+CCIPeriod-1+14]
           -0.00573862260748731*Close[pos+CCIPeriod-1+15]
           +0.00342620684434*Close[pos+CCIPeriod-1+16]
           +0.00996574022237624*Close[pos+CCIPeriod-1+17]
           +0.0134223280887248*Close[pos+CCIPeriod-1+18]
           +0.0139394004237978*Close[pos+CCIPeriod-1+19]
           +0.0121149938483286*Close[pos+CCIPeriod-1+20]
           +0.00883315067608292*Close[pos+CCIPeriod-1+21]
           +0.0050235681107559*Close[pos+CCIPeriod-1+22]
           +0.00151954406404245*Close[pos+CCIPeriod-1+23]
           -0.00108567173532015*Close[pos+CCIPeriod-1+24]
           -0.0133301689797048*Close[pos+CCIPeriod-1+25];
      pos--;
     }
//---- moving average2
   sum=0;
   pos=Bars-counted_bars-1-25;
//---- initial accumulation
   if(pos<CCIPeriod2) pos=CCIPeriod2;
   for(i=1;i<CCIPeriod2;i++,pos--)
      sum+=0.225654509516691*Close[pos+0]
           +0.219241264585139*Close[pos+1]
           +0.200688479689899*Close[pos+2]
           +0.171992513765923*Close[pos+3]
           +0.136270408129286*Close[pos+4]
           +0.0971644469103302*Close[pos+5]
           +0.0585064796603445*Close[pos+6]
           +0.0237448140297671*Close[pos+7]
           -0.00442869436477854*Close[pos+8]
           -0.0243636783229045*Close[pos+9]
           -0.0355617365834807*Close[pos+10]
           -0.0386306817434228*Close[pos+11]
           -0.0350564564449243*Close[pos+12]
           -0.0268963490805002*Close[pos+13]
           -0.0164157887033052*Close[pos+14]
           -0.00573862260748731*Close[pos+15]
           +0.00342620684434*Close[pos+16]
           +0.00996574022237624*Close[pos+17]
           +0.0134223280887248*Close[pos+18]
           +0.0139394004237978*Close[pos+19]
           +0.0121149938483286*Close[pos+20]
           +0.00883315067608292*Close[pos+21]
           +0.0050235681107559*Close[pos+22]
           +0.00151954406404245*Close[pos+23]
           -0.00108567173532015*Close[pos+24]
           -0.0133301689797048*Close[pos+25];
//---- main calculation loop
   while(pos>=0)
     {
      sum+=0.225654509516691*Close[pos+0]
           +0.219241264585139*Close[pos+1]
           +0.200688479689899*Close[pos+2]
           +0.171992513765923*Close[pos+3]
           +0.136270408129286*Close[pos+4]
           +0.0971644469103302*Close[pos+5]
           +0.0585064796603445*Close[pos+6]
           +0.0237448140297671*Close[pos+7]
           -0.00442869436477854*Close[pos+8]
           -0.0243636783229045*Close[pos+9]
           -0.0355617365834807*Close[pos+10]
           -0.0386306817434228*Close[pos+11]
           -0.0350564564449243*Close[pos+12]
           -0.0268963490805002*Close[pos+13]
           -0.0164157887033052*Close[pos+14]
           -0.00573862260748731*Close[pos+15]
           +0.00342620684434*Close[pos+16]
           +0.00996574022237624*Close[pos+17]
           +0.0134223280887248*Close[pos+18]
           +0.0139394004237978*Close[pos+19]
           +0.0121149938483286*Close[pos+20]
           +0.00883315067608292*Close[pos+21]
           +0.0050235681107559*Close[pos+22]
           +0.00151954406404245*Close[pos+23]
           -0.00108567173532015*Close[pos+24]
           -0.0133301689797048*Close[pos+25];
      //---
      MovBuffer2[pos]=sum/CCIPeriod2;
      //---
      sum-=0.225654509516691*Close[pos+CCIPeriod2-1+0]
           +0.219241264585139*Close[pos+CCIPeriod2-1+1]
           +0.200688479689899*Close[pos+CCIPeriod2-1+2]
           +0.171992513765923*Close[pos+CCIPeriod2-1+3]
           +0.136270408129286*Close[pos+CCIPeriod2-1+4]
           +0.0971644469103302*Close[pos+CCIPeriod2-1+5]
           +0.0585064796603445*Close[pos+CCIPeriod2-1+6]
           +0.0237448140297671*Close[pos+CCIPeriod2-1+7]
           -0.00442869436477854*Close[pos+CCIPeriod2-1+8]
           -0.0243636783229045*Close[pos+CCIPeriod2-1+9]
           -0.0355617365834807*Close[pos+CCIPeriod2-1+10]
           -0.0386306817434228*Close[pos+CCIPeriod2-1+11]
           -0.0350564564449243*Close[pos+CCIPeriod2-1+12]
           -0.0268963490805002*Close[pos+CCIPeriod2-1+13]
           -0.0164157887033052*Close[pos+CCIPeriod2-1+14]
           -0.00573862260748731*Close[pos+CCIPeriod2-1+15]
           +0.00342620684434*Close[pos+CCIPeriod2-1+16]
           +0.00996574022237624*Close[pos+CCIPeriod2-1+17]
           +0.0134223280887248*Close[pos+CCIPeriod2-1+18]
           +0.0139394004237978*Close[pos+CCIPeriod2-1+19]
           +0.0121149938483286*Close[pos+CCIPeriod2-1+20]
           +0.00883315067608292*Close[pos+CCIPeriod2-1+21]
           +0.0050235681107559*Close[pos+CCIPeriod2-1+22]
           +0.00151954406404245*Close[pos+CCIPeriod2-1+23]
           -0.00108567173532015*Close[pos+CCIPeriod2-1+24]
           -0.0133301689797048*Close[pos+CCIPeriod2-1+25];
      pos--;
     }
//---- standard deviations
   i=Bars-CCIPeriod-25;
   if(counted_bars>CCIPeriod-1) i=Bars-counted_bars-1;
   mul=0.015/CCIPeriod;
   while(i>=0)
     {
      sum=0.0;
      k=i+CCIPeriod-1;
      while(k>=i)
        {
         price=0.225654509516691*Close[k+0]
               +0.219241264585139*Close[k+1]
               +0.200688479689899*Close[k+2]
               +0.171992513765923*Close[k+3]
               +0.136270408129286*Close[k+4]
               +0.0971644469103302*Close[k+5]
               +0.0585064796603445*Close[k+6]
               +0.0237448140297671*Close[k+7]
               -0.00442869436477854*Close[k+8]
               -0.0243636783229045*Close[k+9]
               -0.0355617365834807*Close[k+10]
               -0.0386306817434228*Close[k+11]
               -0.0350564564449243*Close[k+12]
               -0.0268963490805002*Close[k+13]
               -0.0164157887033052*Close[k+14]
               -0.00573862260748731*Close[k+15]
               +0.00342620684434*Close[k+16]
               +0.00996574022237624*Close[k+17]
               +0.0134223280887248*Close[k+18]
               +0.0139394004237978*Close[k+19]
               +0.0121149938483286*Close[k+20]
               +0.00883315067608292*Close[k+21]
               +0.0050235681107559*Close[k+22]
               +0.00151954406404245*Close[k+23]
               -0.00108567173532015*Close[k+24]
               -0.0133301689797048*Close[k+25];
         sum+=MathAbs(price-MovBuffer[i]);
         k--;
        }
      DevBuffer[i]=sum*mul;
      i--;
     }
   i=Bars-CCIPeriod-25;
   if(counted_bars>CCIPeriod-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      price=0.225654509516691*Close[i+0]
            +0.219241264585139*Close[i+1]
            +0.200688479689899*Close[i+2]
            +0.171992513765923*Close[i+3]
            +0.136270408129286*Close[i+4]
            +0.0971644469103302*Close[i+5]
            +0.0585064796603445*Close[i+6]
            +0.0237448140297671*Close[i+7]
            -0.00442869436477854*Close[i+8]
            -0.0243636783229045*Close[i+9]
            -0.0355617365834807*Close[i+10]
            -0.0386306817434228*Close[i+11]
            -0.0350564564449243*Close[i+12]
            -0.0268963490805002*Close[i+13]
            -0.0164157887033052*Close[i+14]
            -0.00573862260748731*Close[i+15]
            +0.00342620684434*Close[i+16]
            +0.00996574022237624*Close[i+17]
            +0.0134223280887248*Close[i+18]
            +0.0139394004237978*Close[i+19]
            +0.0121149938483286*Close[i+20]
            +0.00883315067608292*Close[i+21]
            +0.0050235681107559*Close[i+22]
            +0.00151954406404245*Close[i+23]
            -0.00108567173532015*Close[i+24]
            -0.0133301689797048*Close[i+25];
      RelBuffer[i]=price-MovBuffer[i];
      i--;
     }
//---- standard deviations2
   i=Bars-CCIPeriod2-25;
   if(counted_bars>CCIPeriod2-1) i=Bars-counted_bars-1;
   mul=0.015/CCIPeriod2;
   while(i>=0)
     {
      sum=0.0;
      k=i+CCIPeriod2-1;
      while(k>=i)
        {
         price=0.225654509516691*Close[k+0]
               +0.219241264585139*Close[k+1]
               +0.200688479689899*Close[k+2]
               +0.171992513765923*Close[k+3]
               +0.136270408129286*Close[k+4]
               +0.0971644469103302*Close[k+5]
               +0.0585064796603445*Close[k+6]
               +0.0237448140297671*Close[k+7]
               -0.00442869436477854*Close[k+8]
               -0.0243636783229045*Close[k+9]
               -0.0355617365834807*Close[k+10]
               -0.0386306817434228*Close[k+11]
               -0.0350564564449243*Close[k+12]
               -0.0268963490805002*Close[k+13]
               -0.0164157887033052*Close[k+14]
               -0.00573862260748731*Close[k+15]
               +0.00342620684434*Close[k+16]
               +0.00996574022237624*Close[k+17]
               +0.0134223280887248*Close[k+18]
               +0.0139394004237978*Close[k+19]
               +0.0121149938483286*Close[k+20]
               +0.00883315067608292*Close[k+21]
               +0.0050235681107559*Close[k+22]
               +0.00151954406404245*Close[k+23]
               -0.00108567173532015*Close[k+24]
               -0.0133301689797048*Close[k+25];
         sum+=MathAbs(price-MovBuffer2[i]);
         k--;
        }
      DevBuffer2[i]=sum*mul;
      i--;
     }
   i=Bars-CCIPeriod2-25;
   if(counted_bars>CCIPeriod2-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      price=0.225654509516691*Close[i+0]
            +0.219241264585139*Close[i+1]
            +0.200688479689899*Close[i+2]
            +0.171992513765923*Close[i+3]
            +0.136270408129286*Close[i+4]
            +0.0971644469103302*Close[i+5]
            +0.0585064796603445*Close[i+6]
            +0.0237448140297671*Close[i+7]
            -0.00442869436477854*Close[i+8]
            -0.0243636783229045*Close[i+9]
            -0.0355617365834807*Close[i+10]
            -0.0386306817434228*Close[i+11]
            -0.0350564564449243*Close[i+12]
            -0.0268963490805002*Close[i+13]
            -0.0164157887033052*Close[i+14]
            -0.00573862260748731*Close[i+15]
            +0.00342620684434*Close[i+16]
            +0.00996574022237624*Close[i+17]
            +0.0134223280887248*Close[i+18]
            +0.0139394004237978*Close[i+19]
            +0.0121149938483286*Close[i+20]
            +0.00883315067608292*Close[i+21]
            +0.0050235681107559*Close[i+22]
            +0.00151954406404245*Close[i+23]
            -0.00108567173532015*Close[i+24]
            -0.0133301689797048*Close[i+25];
      RelBuffer2[i]=price-MovBuffer2[i];
      i--;
     }
//---- cci counting
   i=Bars-CCIPeriod+1;
   if(counted_bars>CCIPeriod-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      if(DevBuffer[i]==0.0) CCIBuffer[i]=0.0;
      else CCIBuffer[i]=RelBuffer[i]/DevBuffer[i];
      i--;
     }
//---- cci counting2
   i=Bars-CCIPeriod2+1;
   if(counted_bars>CCIPeriod2-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      if(DevBuffer2[i]==0.0) CCIBuffer2[i]=0.0;
      else CCIBuffer2[i]=RelBuffer2[i]/DevBuffer2[i];
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
