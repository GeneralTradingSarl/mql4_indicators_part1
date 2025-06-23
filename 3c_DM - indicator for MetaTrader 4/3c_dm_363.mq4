//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 1999-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2002, Finware.ru Ltd."
#property link "http://www.finware.ru/"
//----
#property indicator_separate_window
#property indicator_buffers  3
#property indicator_color1  Lime
#property indicator_color2  Red
#property indicator_color3  Gray
//---- input parameters 
extern int Drow_style= 0;  // Стиль исполнения графика 0 - в виде точечной линии, другое значение - в виде гистограммы
//---- indicator buffers 
double Ind_Buffer1[];
double Ind_Buffer2[];
double Ind_Buffer3[];
//---- double vars 
double value1,value2,Rezalt,trend;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if (Drow_style==0)
     {
      SetIndexStyle(0,DRAW_ARROW);
      SetIndexStyle(1,DRAW_ARROW);
      SetIndexStyle(2,DRAW_ARROW);
      //----
      SetIndexArrow(0,159);
      SetIndexArrow(1,159);
      SetIndexArrow(2,159);
     }
   else
     {
      SetIndexStyle(0,DRAW_HISTOGRAM);
      SetIndexStyle(1,DRAW_HISTOGRAM);
      SetIndexStyle(2,DRAW_HISTOGRAM);
     }
//----
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
//----
   SetIndexBuffer(0,Ind_Buffer1);
   SetIndexBuffer(1,Ind_Buffer2);
   SetIndexBuffer(2,Ind_Buffer3);
//----   
   IndicatorShortName ("DM");
   SetIndexLabel (0,   "DM_Up");
   SetIndexLabel (1,   "DM_Down");
   SetIndexLabel (2,   "DM_Straight");
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//---- get already counted bars 
   int shift,counted_bars=IndicatorCounted();
//---- check for possible errors 
   if (counted_bars<0) return(-1);
//---- 
   if(counted_bars<64)for(shift=1;shift<=64;shift++)
      {Ind_Buffer1[shift]=0.0;Ind_Buffer2[shift]=0.0;Ind_Buffer3[shift]=0.0;}
//---- 
   shift=Bars-64-1;
   if(counted_bars>64) shift=Bars-counted_bars-1;
   while(shift>=0)
     {
      value1=
      -0.057943686277445900*Close[shift+00]
      -0.043658266634319700*Close[shift+01]
      +0.016893339337967300*Close[shift+02]
      +0.110448213843891000*Close[shift+03]
      +0.205220247113110000*Close[shift+04]
      +0.264664029548369000*Close[shift+05]
      +0.264664029548369000*Close[shift+06]
      +0.205220247113110000*Close[shift+07]
      +0.110448213843891000*Close[shift+08]
      +0.016893339337967300*Close[shift+09]
      -0.043658266634319700*Close[shift+10]
      -0.057943686277445900*Close[shift+11]
      -0.034834636631794200*Close[shift+12]
      +0.002212354734218340*Close[shift+13]
      +0.028933121721909400*Close[shift+14]
      +0.032424401776343200*Close[shift+15]
      +0.015569833996195800*Close[shift+16]
      -0.007660554868813180*Close[shift+17]
      -0.022138347829420900*Close[shift+18]
      -0.020552990368271800*Close[shift+19]
      -0.006433347602730440*Close[shift+20]
      +0.009627481503821010*Close[shift+21]
      +0.017394469333231100*Close[shift+22]
      +0.013176086997509700*Close[shift+23]
      +0.001209424586624090*Close[shift+24]
      -0.010002709133594700*Close[shift+25]
      -0.013505578777899800*Close[shift+26]
      -0.008035831519405070*Close[shift+27]
      +0.001903891095510710*Close[shift+28]
      +0.009480467257466930*Close[shift+29]
      +0.010166090979082400*Close[shift+30]
      +0.004303104789688430*Close[shift+31]
      -0.003659787203963280*Close[shift+32]
      -0.008411956859246820*Close[shift+33]
      -0.007282846005800100*Close[shift+34]
      -0.001620704470705190*Close[shift+35]
      +0.004466014467332310*Close[shift+36]
      +0.007048985722291220*Close[shift+37]
      +0.004847799927165300*Close[shift+38]
      -0.000217319809293247*Close[shift+39]
      -0.004603538852047050*Close[shift+40]
      -0.005574817063020290*Close[shift+41]
      -0.002877047191674200*Close[shift+42]
      +0.001371504969476030*Close[shift+43]
      +0.004280506570424680*Close[shift+44]
      +0.004136269885199370*Close[shift+45]
      +0.001361513374633290*Close[shift+46]
      -0.001973820228459360*Close[shift+47]
      -0.003675699277522370*Close[shift+48]
      -0.002836788589562860*Close[shift+49]
      -0.000284631689719810*Close[shift+50]
      +0.002153387731732640*Close[shift+51]
      +0.002934855205103340*Close[shift+52]
      +0.001758962821343280*Close[shift+53]
      -0.000389897847025107*Close[shift+54]
      -0.002031006983868290*Close[shift+55]
      -0.002197277408694140*Close[shift+56]
      -0.000975033303736501*Close[shift+57]
      +0.000693883112457725*Close[shift+58]
      +0.001751056105124850*Close[shift+59]
      +0.001683817123497210*Close[shift+60]
      +0.000645916394658871*Close[shift+61]
      -0.001229513645906610*Close[shift+62]
      -0.005497165615453070*Close[shift+63]
      +0.001719892732445040*Close[shift+64];
      value2=
      0.210642090317950000*Close[shift+00]
      +0.271656355551084000*Close[shift+01]
      +0.271656355551084000*Close[shift+02]
      +0.210642090317950000*Close[shift+03]
      +0.113366214899538000*Close[shift+04]
      +0.017339655129830400*Close[shift+05]
      -0.044811701929405100*Close[shift+06]
      -0.059474537088348700*Close[shift+07]
      -0.035754954878029800*Close[shift+08]
      +0.002270804329963180*Close[shift+09]
      +0.029697524121816400*Close[shift+10]
      +0.033281042507046500*Close[shift+11]
      +0.015981183265287400*Close[shift+12]
      -0.007862943901791450*Close[shift+13]
      -0.022723234810281000*Close[shift+14]
      -0.021095992789986800*Close[shift+15]
      -0.006603314272564040*Close[shift+16]
      +0.009881836012723110*Close[shift+17]
      +0.017854024794657900*Close[shift+18]
      +0.013524194354160800*Close[shift+19]
      +0.001241377137939080*Close[shift+20]
      -0.010266977018020800*Close[shift+21]
      -0.013862391185810200*Close[shift+22]
      -0.008248135223019260*Close[shift+23]
      +0.001954191195740410*Close[shift+24]
      +0.009730937704226890*Close[shift+25]
      +0.010434675351580300*Close[shift+26]
      +0.004416791230436310*Close[shift+27]
      -0.003756477431473020*Close[shift+28]
      -0.008634197655553740*Close[shift+29]
      -0.007475256109987750*Close[shift+30]
      -0.001663522884800100*Close[shift+31]
      +0.004584004921651760*Close[shift+32]
      +0.007235217324080300*Close[shift+33]
      +0.004975877012459140*Close[shift+34]
      -0.000223061318466289*Close[shift+35]
      -0.004725162649865770*Close[shift+36]
      -0.005722101672782540*Close[shift+37]
      -0.002953057716881230*Close[shift+38]
      +0.001407739624700190*Close[shift+39]
      +0.004393595974558090*Close[shift+40]
      +0.004245548609330800*Close[shift+41]
      +0.001397484055608480*Close[shift+42]
      -0.002025967830578520*Close[shift+43]
      -0.003772809896144160*Close[shift+44]
      -0.002911735497357070*Close[shift+45]
      -0.000292151553936419*Close[shift+46]
      +0.002210279441029960*Close[shift+47]
      +0.003012392996694690*Close[shift+48]
      +0.001805433970046320*Close[shift+49]
      -0.000400198804275733*Close[shift+50]
      -0.002084665438964100*Close[shift+51]
      -0.002255328667062000*Close[shift+52]
      -0.001000793323845250*Close[shift+53]
      +0.000712215248254048*Close[shift+54]
      +0.001797318361302890*Close[shift+55]
      +0.001728302950591050*Close[shift+56]
      +0.000662981267470111*Close[shift+57]
      -0.001261996942755200*Close[shift+58]
      -0.005642398702623070*Close[shift+59]
      +0.001765331663815800*Close[shift+60];
      //----
      Rezalt=value2-value1;
      //----
      //---- +SSSSSSSSSSSSSSSS <<< Three colore code >>> SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS+
      trend=Rezalt-Ind_Buffer1[shift+1]-Ind_Buffer2[shift+1]-Ind_Buffer3[shift+1];
      if(trend>0.0)     {Ind_Buffer1[shift]=Rezalt; Ind_Buffer2[shift]=0;      Ind_Buffer3[shift]=0;}
        else{if(trend<0.0){Ind_Buffer1[shift]=0;      Ind_Buffer2[shift]=Rezalt; Ind_Buffer3[shift]=0;}
        else              {Ind_Buffer1[shift]=0;      Ind_Buffer2[shift]=0;      Ind_Buffer3[shift]=Rezalt;}}
      //---- +SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS+
      shift--;
     }
   return(0);
  }
//+------------------------------------------------------------------+