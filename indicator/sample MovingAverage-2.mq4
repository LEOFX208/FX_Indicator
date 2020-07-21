//+------------------------------------------------------------------+
//|                                                MovingAverage.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_width1 3
extern int SMAPeriod = 21;
double BufSMA[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   SetIndexBuffer(0, BufSMA);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 0);

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{int counted_bars=IndicatorCounted();
 int limit=Bars-1-counted_bars;
 for(int i=limit-1;i>=0;i--)
{BufSMA[i] = iMA(NULL,0,SMAPeriod,0,MODE_SMA,PRICE_CLOSE,i);}
Comment("Bid=",Bid,"Ask=",Ask,"  ",TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS));
 return(0);}
//+------------------------------------------------------------------+

