//+------------------------------------------------------------------+
//|                                   Detrended Price Oscillator.mq4 |
//|                                    Copyright © 2025 Wolfforex.com|
//|                                        https://www.wolfforex.com |
//+------------------------------------------------------------------+
#property version   "1.01"
#property strict

#property description "Detrended Price Oscillator tries to capture the short-term trend changes."
#property description "Indicator's cross with the zero is the best indicator of such a change."

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrBlue
#property indicator_type1 DRAW_LINE
#property indicator_level1 0
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT
#property indicator_levelcolor clrDarkGray

enum enum_candle_to_check
{
    Current,
    Previous
};

input int MA_Period = 14; // MA Period
input int BarsToCount = 400;
input bool EnableNativeAlerts = false;
input bool EnableEmailAlerts = false;
input bool EnablePushAlerts = false;
input enum_candle_to_check TriggerCandle = Previous;

// Global variables:
int Shift;
datetime LastAlertTime = D'01.01.1970';
int LastBars = 0;

// Buffer:
double DPO[];

void OnInit()
{
    IndicatorShortName("DPO(" + IntegerToString(MA_Period) + ")");
    SetIndexBuffer(0, DPO);

    Shift = MA_Period / 2 + 1;
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    // Too few bars to do anything.
    if (Bars <= MA_Period) return 0;

    // If we don't have enough bars to count as specified in the input.
    int limit = BarsToCount;
    if (BarsToCount >= Bars) limit = Bars;

    SetIndexDrawBegin(0, Bars - limit + MA_Period + 1);

    int counted_bars = IndicatorCounted();

    // First MA_Period bars are set to 0 if we have too few bars to display.
    if (counted_bars < MA_Period)
    {
        for (int i = 1; i <= MA_Period; i++)
            DPO[limit - i] = 0.0;
    }

    for (int i = limit - MA_Period - 1; i >= 0; i--)
    {
        DPO[i] = Close[i] - iMA(NULL, 0, MA_Period, Shift, MODE_SMA, PRICE_CLOSE, i);
    }

    if (((TriggerCandle > 0) && (Time[0] > LastAlertTime)) || (TriggerCandle == 0))
    {
        // Crosses zero from below
        if ((DPO[TriggerCandle + 1] <= 0) && (DPO[TriggerCandle] > 0))
        {
            if (LastBars != 0) // Skip actual alerts if it is the first run after attachment.
            {
                string NativeText = "DPO Zero Cross: DPO above zero.";
                string Text = "DPO Zero Cross: " + Symbol() + " - " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7) + " - DPO above zero.";
                if (EnableNativeAlerts) Alert(NativeText);
                if (EnableEmailAlerts) SendMail("DPO Zero Cross Alert - " + Symbol() + " - " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7), Text);
                if (EnablePushAlerts) SendNotification(Text);
            }
            LastAlertTime = Time[0];
        }
        // Crosses zero from above
        if ((DPO[TriggerCandle + 1] >= 0) && (DPO[TriggerCandle] < 0))
        {
            if (LastBars != 0) // Skip actual alerts if it is the first run after attachment.
            {
                string NativeText = "DPO Zero Cross: DPO below zero.";
                string Text = "DPO Zero Cross: " + Symbol() + " - " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7) + " - DPO below zero.";
                if (EnableNativeAlerts) Alert(NativeText);
                if (EnableEmailAlerts) SendMail("DPO Zero Cross Alert - " + Symbol() + " - " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7), Text);
                if (EnablePushAlerts) SendNotification(Text);
            }
            LastAlertTime = Time[0];
        }
    }

    LastBars = rates_total;
    return rates_total;
}
//+------------------------------------------------------------------+