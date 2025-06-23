//=======================================================================================================================================================================
//	(c) 2009 DolSergon (dolsergon@yandex.ru/icq(qip)-366382375)
//=======================================================================================================================================================================
#property  copyright "(c) 2009 DolSergon"
#property  link      "http://tradecoder.narod.ru"

#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Orange
#property  indicator_width1  1

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

int TicksCount = 300;
double	BufTicks[];
double	Ticks[];


//=======================================================================================================================================================================
int init()
  {
   IndicatorBuffers(1);
	ArrayResize(Ticks, TicksCount);
	ArrayInitialize(Ticks, EMPTY_VALUE);
   SetIndexBuffer(0, BufTicks);
   SetIndexStyle(0, DRAW_LINE);
   return(0);
}

  
//=======================================================================================================================================================================
void start() {
	for (int t=TicksCount; t>=1; t--) {
		if (t < TicksCount) {
			Ticks[t] = Ticks[t-1];
			BufTicks[t] = Ticks[t];
		} else    BufTicks[t] = EMPTY_VALUE;
	}
	Ticks[0] = Close[0];
	BufTicks[0] = Ticks[0];
   return;
}


