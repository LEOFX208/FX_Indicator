//+------------------------------------------------------------------+
//| #BobokusFibo.mq4 modified from
//| #SpudFibo.mq4
//| http://www.forexfactory.com/showthread.php?t=50767
//+------------------------------------------------------------------+
#property  indicator_chart_window

#property indicator_buffers 3
#property indicator_color1 Blue 
#property indicator_color2 RoyalBlue 
#property indicator_color3 DodgerBlue 

double HiPrice, LoPrice, Range;
datetime StartTime;

int init()
{
   return(0);
}

int deinit()
{
   ObjectDelete("LongFibo");
   ObjectDelete("ShortFibo");
   ObjectDelete("IntradayFibo");
   return(0);
}

//+------------------------------------------------------------------+
//| Draw Fibo
//+------------------------------------------------------------------+

int DrawFibo()
{
	if(ObjectFind("LongFibo") == -1)
		ObjectCreate("LongFibo",OBJ_FIBO,0,StartTime,HiPrice+Range,StartTime,HiPrice);
	else
	{
		ObjectSet("LongFibo",OBJPROP_TIME2, StartTime);
		ObjectSet("LongFibo",OBJPROP_TIME1, StartTime);
		ObjectSet("LongFibo",OBJPROP_PRICE1,HiPrice+Range);
		ObjectSet("LongFibo",OBJPROP_PRICE2,HiPrice);
	}
   ObjectSet("LongFibo",OBJPROP_LEVELCOLOR,indicator_color1);
   ObjectSet("LongFibo",OBJPROP_FIBOLEVELS,4);
   ObjectSet("LongFibo",OBJPROP_FIRSTLEVEL+0,0.34);	ObjectSetFiboDescription("LongFibo",0,"Daily Long Target 1 -  %$"); 
   ObjectSet("LongFibo",OBJPROP_FIRSTLEVEL+1,0.55);	ObjectSetFiboDescription("LongFibo",1,"Daily Long Target 2 -  %$"); 
   ObjectSet("LongFibo",OBJPROP_FIRSTLEVEL+2,0.764);	ObjectSetFiboDescription("LongFibo",2,"Daily Long Target 3 -  %$"); 
    ObjectSet("LongFibo",OBJPROP_FIRSTLEVEL+3,1.764);	ObjectSetFiboDescription("LongFibo",3,"Daily Long Target 4 -  %$"); 
   ObjectSet("LongFibo",OBJPROP_RAY,true);
   ObjectSet("LongFibo",OBJPROP_BACK,true);

	if(ObjectFind("ShortFibo") == -1)
		ObjectCreate("ShortFibo",OBJ_FIBO,0,StartTime,LoPrice-Range,StartTime,LoPrice);
	else
	{
		ObjectSet("ShortFibo",OBJPROP_TIME2, StartTime);
		ObjectSet("ShortFibo",OBJPROP_TIME1, StartTime);
		ObjectSet("ShortFibo",OBJPROP_PRICE1,LoPrice-Range);
		ObjectSet("ShortFibo",OBJPROP_PRICE2,LoPrice);
	}
   ObjectSet("ShortFibo",OBJPROP_LEVELCOLOR,indicator_color3); 
   ObjectSet("ShortFibo",OBJPROP_FIBOLEVELS,4);
   ObjectSet("ShortFibo",OBJPROP_FIRSTLEVEL+0,0.34);	ObjectSetFiboDescription("ShortFibo",0,"Daily Short Target 1 -  %$"); 
   ObjectSet("ShortFibo",OBJPROP_FIRSTLEVEL+1,0.55);	ObjectSetFiboDescription("ShortFibo",1,"Daily Short Target 2 -  %$"); 
   ObjectSet("ShortFibo",OBJPROP_FIRSTLEVEL+2,0.764);	ObjectSetFiboDescription("ShortFibo",2,"Daily Short Target 3 -  %$");
   ObjectSet("ShortFibo",OBJPROP_FIRSTLEVEL+3,1.764);	ObjectSetFiboDescription("ShortFibo",3,"Daily Short Target 4 -  %$"); 
   ObjectSet("ShortFibo",OBJPROP_RAY,true);
   ObjectSet("ShortFibo",OBJPROP_BACK,true);

		if(ObjectFind("IntradayFibo") == -1)
			ObjectCreate("IntradayFibo",OBJ_FIBO,0,StartTime,HiPrice,StartTime+PERIOD_D1*60,LoPrice);
		else
		{
			ObjectSet("IntradayFibo",OBJPROP_TIME2, StartTime);
			ObjectSet("IntradayFibo",OBJPROP_TIME1, StartTime+PERIOD_D1*60);
			ObjectSet("IntradayFibo",OBJPROP_PRICE1,HiPrice);
			ObjectSet("IntradayFibo",OBJPROP_PRICE2,LoPrice);
		}
   	ObjectSet("IntradayFibo",OBJPROP_LEVELCOLOR,indicator_color2); 
   	ObjectSet("IntradayFibo",OBJPROP_FIBOLEVELS,7);
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+0,0.0);	ObjectSetFiboDescription("IntradayFibo",0,"Intraday Low -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+1,0.191);	ObjectSetFiboDescription("IntradayFibo",1,"Intraday S1 -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+2,0.382);	ObjectSetFiboDescription("IntradayFibo",2,"Intraday Short -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+3,0.500);	ObjectSetFiboDescription("IntradayFibo",3,"Intraday Pivot -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+4,0.618);	ObjectSetFiboDescription("IntradayFibo",4,"Intraday Long -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+5,0.809);	ObjectSetFiboDescription("IntradayFibo",5,"Intraday R1 -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_FIRSTLEVEL+6,1.000);	ObjectSetFiboDescription("IntradayFibo",6,"Intraday High -  %$"); 
   	ObjectSet("IntradayFibo",OBJPROP_RAY,true);
   	ObjectSet("IntradayFibo",OBJPROP_BACK,true);
   }

//+------------------------------------------------------------------+
//| Indicator start function
//+------------------------------------------------------------------+

int start()
{
	int shift	= iBarShift(NULL,PERIOD_D1,Time[0]) + 1;	// yesterday
	HiPrice		= iHigh(NULL,PERIOD_D1,shift);
	LoPrice		= iLow (NULL,PERIOD_D1,shift);
	StartTime	= iTime(NULL,PERIOD_D1,shift);

	if(TimeDayOfWeek(StartTime)==0/*Sunday*/)
	{//Add fridays high and low
		HiPrice = MathMax(HiPrice,iHigh(NULL,PERIOD_D1,shift+1));
		LoPrice = MathMin(LoPrice,iLow(NULL,PERIOD_D1,shift+1));
	}

	Range = HiPrice-LoPrice;

	DrawFibo();

	return(0);
}
//+------------------------------------------------------------------+

