#property version   "1.0"
#property strict

#property indicator_chart_window
#property indicator_buffers 2

#property indicator_type1  DRAW_ARROW
#property indicator_width1 2
#property indicator_color1 clrDeepSkyBlue

#property indicator_type2  DRAW_ARROW
#property indicator_width2 2
#property indicator_color2 clrTomato

input int      inp_depta_period     = 7;     // depta period
      int      inp_delta_proof      = 0;
      
double   ext_arrow_up[];
double   ext_arrow_dn[];
//+------------------------------------------------------------------+
int OnInit() {

   SetIndexBuffer(0, ext_arrow_up);
   SetIndexBuffer(1, ext_arrow_dn);
   SetIndexArrow(0, 217);
   SetIndexArrow(1, 218);

   inp_delta_proof = int(MathFloor(inp_depta_period*0.8));
   
   return(INIT_SUCCEEDED);
}
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
                
   int limit = prev_calculated > 0 ? rates_total - prev_calculated + 1 : rates_total - inp_depta_period - 2;
   
   for(int i=limit; i>=0; i--) {
      // calculte deltas
      int delta_count_buy = 0;
      int delta_count_sell = 0;
      for(int b=0; b<inp_depta_period; b++) {
         double mid = ( high[i+b+1] + low[i+b+1] ) / 2;
         if(close[i+b] > mid)
            delta_count_buy++;
         if(close[i+b] < mid)
            delta_count_sell++;
      }
      
      // calculate aos
      double ao[2];
      ao[0] = iAO(NULL, PERIOD_CURRENT, i);
      ao[1] = iAO(NULL, PERIOD_CURRENT, i+1);
      
      // arrows
      if(ao[0] > ao[1] && ao[1] < 0.0 && delta_count_buy >= inp_delta_proof) 
         ext_arrow_up[i] = low[i] - iATR(NULL,PERIOD_CURRENT,14,i) / 3.0;
      else
         ext_arrow_up[i] = EMPTY_VALUE;
      if(ao[0] < ao[1] && ao[1] > 0.0 && delta_count_sell >= inp_delta_proof) 
         ext_arrow_dn[i] = high[i] + iATR(NULL,PERIOD_CURRENT,14,i) / 3.0;
      else
         ext_arrow_dn[i] = EMPTY_VALUE;
   }

   return(rates_total);
}
//+------------------------------------------------------------------+