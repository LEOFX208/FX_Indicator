//+------------------------------------------------------------------+
//|                                              ReminingTime_ja.mq4 |
//|                                                      googolyenfx |
//|                               http://googolyenfx.blog18.fc2.com/ |
//+------------------------------------------------------------------+
#property copyright "googolyenfx"
#property link      "http://googolyenfx.blog18.fc2.com/"

#property indicator_chart_window

string ReminingTime_sname = "bars_remining_time";
extern int Corner = 0;
extern double LocationX = 0;
extern double LocationY = 20;
extern int FontSize = 10;
extern color FontColor = White;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
	ObjectDelete(ReminingTime_sname);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double g;
	int m, s, k, h;
	m = Time[0] + Period()*60 - TimeCurrent();
	g = m/60.0;
	s = m%60;
	m = (m - m%60) / 60;
	
	string text;
	
	if (Period() <= PERIOD_H1) {
		text = "Žc‚è " + m + " •ª " + s + " •b";
	}
	else {
		if (m >= 60) h = m/60;
		else h = 0;
		k = m - (h*60);
		text = "Žc‚è " + h + " ŽžŠÔ " + k + " •ª " + s + " •b";
	}
	
	ObjectCreate(ReminingTime_sname, OBJ_LABEL, 0, 0, 0);
	ObjectSetText(ReminingTime_sname, text, FontSize, "Terminal", FontColor);
	ObjectSet(ReminingTime_sname, OBJPROP_XDISTANCE, LocationX);
	ObjectSet(ReminingTime_sname, OBJPROP_YDISTANCE, LocationY);
	ObjectSet(ReminingTime_sname, OBJPROP_CORNER, Corner);
   return(0);
  }
//+------------------------------------------------------------------+