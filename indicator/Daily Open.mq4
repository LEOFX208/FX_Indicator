//+------------------------------------------------------------------+
//|                               Bunnygirl Cross and Daily Open.mq4 |
//|                                Copyright © 2005, David W. Thomas |
//|                                           mailto:davidwt@usa.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, David W. Thomas"
#property link      "mailto:davidwt@usa.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 MediumSlateBlue
#property indicator_color2 ForestGreen

//---- input parameters

extern int DailyOpen=0;
extern int EuroOpen=8;


//---- buffers
double DailyOpenBuffer[];
double EuroOpenBuffer[];






//---- variables
int indexbegin = 0;
double dailyopen = 0,euroopen=0;



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
	SetIndexStyle(0, DRAW_LINE, STYLE_DASH);
	SetIndexBuffer(0, DailyOpenBuffer);
	SetIndexLabel(0, "Daily Open");
	SetIndexEmptyValue(0, 0.0);
	
		SetIndexStyle(1, DRAW_LINE, STYLE_DASH);
	SetIndexBuffer(1, EuroOpenBuffer);
	SetIndexLabel(1, "Euro Open");
	SetIndexEmptyValue(1, 0.0);


//----
	indexbegin = Bars - 20;
	if (indexbegin < 0)
		indexbegin = 0;


	return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//---- TODO: add your code here
	
//----
	return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int i;
	int counted_bars = IndicatorCounted();

	
	//---- check for possible errors
	if (counted_bars < 0) counted_bars = 0;
	//---- last counted bar will be recounted
	if (counted_bars > 0) counted_bars--;
	if (counted_bars > indexbegin) counted_bars = indexbegin;


		for (i = indexbegin-counted_bars; i >= 0; i--)
		{
			if ((TimeMinute(Time[i]) == 0) && (TimeHour(Time[i]) - DailyOpen == 0))
				dailyopen = Open[i];
			DailyOpenBuffer[i] = dailyopen;
			
			if ((TimeMinute(Time[i]) == 0) && (TimeHour(Time[i]) - EuroOpen == 0))
				euroopen = Open[i];
			EuroOpenBuffer[i] = euroopen;
			}

	
	return(0);

}
//+------------------------------------------------------------------+