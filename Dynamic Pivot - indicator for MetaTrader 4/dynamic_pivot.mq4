//+------------------------------------------------------------------+
//|                                                Dynamic Pivot.mq4 |
//|                                    Copyright 2020, Anwar Minarso |
//|                                  https://github.com/anwarminarso |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Anwar Minarso"
#property link      "https://github.com/anwarminarso"
#property version   "1.20"
#property strict



enum CMY_ENUM_TIMEFRAMES {
   TF_M0 = 0,        // Current
   TF_M1 = 1,        // 1 Minutes
   TF_M5 = 5,        // 5 Minutes
   TF_M15 = 15,      // 15 Minutes
   TF_M30 = 30,      // 30 Minutes
   TF_H1 = 60,       // Hourly
   TF_H4 = 240,      // H4
   TF_D1 = 1440,     // Daily
   TF_W1 = 10080,    // Weekly
   TF_MN = 43200,    // Monthly
   //TF_MN3 = 129600,   // Quarterly
   //TF_MN6 = 259200    // Semester
};

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 clrGold          // Pivot Point
#property indicator_color2 clrAqua         // Resistance 1
#property indicator_color3 clrAqua   // Resistance 2
#property indicator_color4 clrAqua      // Resistance 3
#property indicator_color5 clrMagenta         // Support 1 
#property indicator_color6 clrMagenta        // Support 2
#property indicator_color7 clrMagenta      // Support 3
input CMY_ENUM_TIMEFRAMES   PivotTimeFrame = TF_D1;  // Pivot Time Frame

double ExtPivotBuffer[];
double ExtResistance1Buffer[];
double ExtResistance2Buffer[];
double ExtResistance3Buffer[];
double ExtSupport1Buffer[];
double ExtSupport2Buffer[];
double ExtSupport3Buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
//--- indicator buffers mapping

//---
   string p = EnumToString(PivotTimeFrame);
   IndicatorDigits(Digits);

   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtPivotBuffer);
   SetIndexLabel(0, "Pivot Point (" + p + ")");

   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, ExtResistance1Buffer);
   SetIndexLabel(1, "Resistance 1 (" + p + ")");

   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, ExtResistance2Buffer);
   SetIndexLabel(2, "Resistance 2 (" + p + ")");

   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(3, ExtResistance3Buffer);
   SetIndexLabel(3, "Resistance 3 (" + p + ")");


   SetIndexStyle(4, DRAW_LINE);
   SetIndexBuffer(4, ExtSupport1Buffer);
   SetIndexLabel(4, "Support 1 (" + p + ")");

   SetIndexStyle(5, DRAW_LINE);
   SetIndexBuffer(5, ExtSupport2Buffer);
   SetIndexLabel(5, "Support 2 (" + p + ")");

   SetIndexStyle(6, DRAW_LINE);
   SetIndexBuffer(6, ExtSupport3Buffer);
   SetIndexLabel(6, "Support 3 (" + p + ")");
   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {

   double highest, lowest, closed = 0;
   double pivotPoint, resistance1, resistance2, resistance3, support1, support2, support3 = 0;
   ArraySetAsSeries(ExtPivotBuffer, false);
   ArraySetAsSeries(ExtResistance1Buffer, false);
   ArraySetAsSeries(ExtResistance2Buffer, false);
   ArraySetAsSeries(ExtResistance3Buffer, false);
   ArraySetAsSeries(ExtSupport1Buffer, false);
   ArraySetAsSeries(ExtSupport2Buffer, false);
   ArraySetAsSeries(ExtSupport3Buffer, false);
   ArraySetAsSeries(open, false);
   ArraySetAsSeries(high, false);
   ArraySetAsSeries(low, false);
   ArraySetAsSeries(close, false);
   ArraySetAsSeries(time, false);
   int pos = 0;
   if(prev_calculated > 1)
      pos = prev_calculated - 1;
   if (PivotTimeFrame == TF_M0) {
      for(int i = pos; i < rates_total; i++) {
         if (i == 0) {
            ExtPivotBuffer[i] = 0;
            ExtResistance1Buffer[i] = 0;
            ExtResistance2Buffer[i] = 0;
            ExtResistance3Buffer[i] = 0;
            ExtSupport1Buffer[i] = 0;
            ExtSupport2Buffer[i] = 0;
            ExtSupport3Buffer[i] = 0;
         } else {
            pivotPoint = (high[i - 1] + low[i - 1] + close[i - 1]) / 3;

            resistance1 = (2 * pivotPoint) - low[i - 1];
            support1 = (2 * pivotPoint) - high[i - 1];

            resistance2 = pivotPoint + (resistance1 - support1);
            support2 =  pivotPoint - (resistance1 - support1);

            resistance3 = high[i - 1] + (2 * (pivotPoint - low[i - 1]));
            support3 =  low[i - 1] - (2 * (high[i - 1] - pivotPoint));
            ExtPivotBuffer[i] = pivotPoint;
            ExtResistance1Buffer[i] = resistance1;
            ExtResistance2Buffer[i] = resistance2;
            ExtResistance3Buffer[i] = resistance3;
            ExtSupport1Buffer[i] = support1;
            ExtSupport2Buffer[i] = support2;
            ExtSupport3Buffer[i] = support3;

         }

      }
   } else {
      int shift = 0;
      if (PivotTimeFrame < 129600) {
         for(int i = pos; i < rates_total; i++) {
            shift = iBarShift(Symbol(), PivotTimeFrame, time[i]);
            if (shift >= 0) {
               highest = iHigh(Symbol(), PivotTimeFrame, shift + 1);
               lowest = iLow(Symbol(), PivotTimeFrame, shift + 1);
               closed = iClose(Symbol(), PivotTimeFrame, shift + 1);

               if (highest > 0 && lowest > 0 && closed > 0) {
                  pivotPoint = (highest + lowest + closed) / 3;

                  resistance1 = (2 * pivotPoint) - lowest;
                  support1 = (2 * pivotPoint) - highest;

                  resistance2 = pivotPoint + (resistance1 - support1);
                  support2 =  pivotPoint - (resistance1 - support1);

                  resistance3 = highest + (2 * (pivotPoint - lowest));
                  support3 =  lowest - (2 * (highest - pivotPoint));

                  ExtPivotBuffer[i] = pivotPoint;
                  ExtResistance1Buffer[i] = resistance1;
                  ExtResistance2Buffer[i] = resistance2;
                  ExtResistance3Buffer[i] = resistance3;
                  ExtSupport1Buffer[i] = support1;
                  ExtSupport2Buffer[i] = support2;
                  ExtSupport3Buffer[i] = support3;
               }
            }
         }
      } else {
         datetime shiftTime;
         int month;
         int delta = 0;
         int deltaCount = 0;
         double highestTemp, lowestTemp = 0;
         for(int i = pos; i < rates_total; i++) {
            shift = iBarShift(Symbol(), PERIOD_MN1, time[i]);
            shiftTime = iTime(Symbol(), PERIOD_MN1, shift);
            month = TimeMonth(shiftTime);
            highest = 0;
            lowest = 0;
            closed = 0;
            if (PivotTimeFrame == 129600) {
               if (month == 1 || month == 4 || month == 7 || month == 10) {
                  delta = 3;
               } else if (month == 2 || month == 5 || month == 8 || month == 11) {
                  delta = 4;
               } else {
                  delta = 5;
               }
               deltaCount = 3;
            } else {
               if (month == 1 || month == 7) {
                  delta = 6;
               } else if (month == 2 || month == 8) {
                  delta = 7;
               } else if (month == 3 || month == 9) {
                  delta = 8;
               } else if (month == 4 || month == 10) {
                  delta = 9;
               } else if (month == 5 || month == 11) {
                  delta = 10;
               } else if (month == 6 || month == 12) {
                  delta = 11;
               }
               deltaCount = 6;
            }
            for(int d = 0; d < deltaCount; i++) {
               highestTemp = iHigh(Symbol(), PERIOD_MN1, shift + delta - d);
               lowestTemp = iLow(Symbol(), PERIOD_MN1, shift + delta - d);
               if (highestTemp > highest)
                  highest = highestTemp;
               if (lowest == 0)
                  lowest = highest;   
               if (lowestTemp < lowest)
                  lowest = lowestTemp;   
            }
            closed = iClose(Symbol(), PERIOD_MN1, shift + delta - deltaCount + 1);

            if (highest > 0 && lowest > 0 && closed > 0) {
               pivotPoint = (highest + lowest + closed) / 3;

               resistance1 = (2 * pivotPoint) - lowest;
               support1 = (2 * pivotPoint) - highest;

               resistance2 = pivotPoint + (resistance1 - support1);
               support2 =  pivotPoint - (resistance1 - support1);

               resistance3 = highest + (2 * (pivotPoint - lowest));
               support3 =  lowest - (2 * (highest - pivotPoint));

               ExtPivotBuffer[i] = pivotPoint;
               ExtResistance1Buffer[i] = resistance1;
               ExtResistance2Buffer[i] = resistance2;
               ExtResistance3Buffer[i] = resistance3;
               ExtSupport1Buffer[i] = support1;
               ExtSupport2Buffer[i] = support2;
               ExtSupport3Buffer[i] = support3;
            }
         }
      }
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
