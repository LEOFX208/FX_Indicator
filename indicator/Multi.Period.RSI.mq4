//+------------------------------------------------------------------+
//|                                             Multi.Period.RSI.mq4 |
//|                               Copyright © 2010, Vladimir Hlystov |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Vladimir Hlystov"
#property link      "http://cmillion.narod.ru"
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_width1 1  
//---- input parameters
extern int PeriodRSI = 14;
extern int timeframe =5;
//---- buffers
double Buffer[];
//+------------------------------------------------------------------+
int init()
  {
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0, Buffer);
//---- 
   timeframe = next_period(timeframe);
   SetIndexLabel(0, "RSI "+StrPer(timeframe));
   return(0);
  }
//+------------------------------------------------------------------+
int start()
{
   int    counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
   {
      Buffer[i]  = iRSI(NULL,timeframe,PeriodRSI,PRICE_CLOSE,iBarShift(NULL,timeframe,Time[i],false));
   }
   return(0);
}
//+------------------------------------------------------------------+
int next_period(int per)
{
   if (per > 43200)  return(0); 
   if (per > 10080)  return(43200); 
   if (per > 1440)   return(10080); 
   if (per > 240)    return(1440); 
   if (per > 60)     return(240); 
   if (per > 30)     return(60);
   if (per > 15)     return(30); 
   if (per >  5)     return(15); 
   if (per >  1)     return(5);   
   if (per == 1)     return(1);   
   if (per == 0)     return(Period());   
}
//+------------------------------------------------------------------+
string StrPer(int per)
{
   if (per == 1)     return(" M1 ");
   if (per == 5)     return(" M5 ");
   if (per == 15)    return(" M15 ");
   if (per == 30)    return(" M30 ");
   if (per == 60)    return(" H1 ");
   if (per == 240)   return(" H4 ");
   if (per == 1440)  return(" D1 ");
   if (per == 10080) return(" W1 ");
   if (per == 43200) return(" MN1 ");
return("îøèáêà ïåğèîäà");
}
//+------------------------------------------------------------------+


