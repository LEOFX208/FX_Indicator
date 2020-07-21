//+------------------------------------------------------------------+
//|                                               OSC-MTF_CF_SYS.mq4 |
//|                                                           kuncup |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "kuncup"
#property link      "http://www.indofx-trader.net"
//----
#property indicator_separate_window
#property  indicator_buffers 6
//----
#property  indicator_color1  Yellow
#property  indicator_color2  MediumOrchid
#property  indicator_color3  SteelBlue
#property  indicator_color4  Khaki
#property  indicator_width3  2
#property  indicator_width4  2
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
extern string _.Method.Note="0=SMA, 1=EMA, 2=SMMA, 3=WMA";
extern string _.AppliedPrice.Note="0=Close, 1=Open, 2=High, 3=Low, 4=(H+L)/2, 5=(H+L+C)/3, 6=(H+L+C+C)/4";
//----
extern string D1.Separator="Daily MA";
extern int D1.HowManyBars=0;
extern int MA1D1.Period=8;
extern int MA1D1.Method=1;
extern int MA1D1.AppliedPrice=0;
extern int MA2D1.Period=12;
extern int MA2D1.Method=1;
extern int MA2D1.AppliedPrice=0;
extern int MA3D1.Period=24;
extern int MA3D1.Method=1;
extern int MA3D1.AppliedPrice=0;
extern int MA4D1.Period=72;
extern int MA4D1.Method=1;
extern int MA4D1.AppliedPrice=0;
//----
extern string H4.Separator="H4 MA";
extern int H4.HowManyBars=0;
extern int MA1H4.Period=8;
extern int MA1H4.Method=1;
extern int MA1H4.AppliedPrice=0;
extern int MA2H4.Period=12;
extern int MA2H4.Method=1;
extern int MA2H4.AppliedPrice=0;
extern int MA3H4.Period=24;
extern int MA3H4.Method=1;
extern int MA3H4.AppliedPrice=0;
extern int MA4H4.Period=72;
extern int MA4H4.Method=1;
extern int MA4H4.AppliedPrice=0;
//----
extern string H1.Separator="H1 MA";
extern int H1.HowManyBars=20;
extern int MA1H1.Period=8;
extern int MA1H1.Method=1;
extern int MA1H1.AppliedPrice=0;
extern int MA2H1.Period=12;
extern int MA2H1.Method=1;
extern int MA2H1.AppliedPrice=0;
extern int MA3H1.Period=24;
extern int MA3H1.Method=1;
extern int MA3H1.AppliedPrice=0;
extern int MA4H1.Period=72;
extern int MA4H1.Method=1;
extern int MA4H1.AppliedPrice=0;
//----
extern string M30.Separator="M30 MA";
extern int M30.HowManyBars=20;
extern int MA1M30.Period=8;
extern int MA1M30.Method=1;
extern int MA1M30.AppliedPrice=0;
extern int MA2M30.Period=12;
extern int MA2M30.Method=1;
extern int MA2M30.AppliedPrice=0;
extern int MA3M30.Period=24;
extern int MA3M30.Method=1;
extern int MA3M30.AppliedPrice=0;
extern int MA4M30.Period=72;
extern int MA4M30.Method=1;
extern int MA4M30.AppliedPrice=0;
//----
extern string M15.Separator="M15 MA";
extern int M15.HowManyBars=20;
extern int MA1M15.Period=8;
extern int MA1M15.Method=1;
extern int MA1M15.AppliedPrice=0;
extern int MA2M15.Period=12;
extern int MA2M15.Method=1;
extern int MA2M15.AppliedPrice=0;
extern int MA3M15.Period=24;
extern int MA3M15.Method=1;
extern int MA3M15.AppliedPrice=0;
extern int MA4M15.Period=72;
extern int MA4M15.Method=1;
extern int MA4M15.AppliedPrice=0;
//----
extern string M5.Separator="M5 MA";
extern int M5.HowManyBars=0;
extern int MA1M5.Period=8;
extern int MA1M5.Method=1;
extern int MA1M5.AppliedPrice=0;
extern int MA2M5.Period=12;
extern int MA2M5.Method=1;
extern int MA2M5.AppliedPrice=0;
extern int MA3M5.Period=24;
extern int MA3M5.Method=1;
extern int MA3M5.AppliedPrice=0;
extern int MA4M5.Period=72;
extern int MA4M5.Method=1;
extern int MA4M5.AppliedPrice=0;
//----
double Ema1[];
double Ema2[];
double Ema3[];
double Ema4[];
double HighPrice[];
double LowPrice[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexBuffer(0,Ema1);
   SetIndexBuffer(1,Ema2);
   SetIndexBuffer(2,Ema3);
   SetIndexBuffer(3,Ema4);
   SetIndexBuffer(4,HighPrice);
   SetIndexBuffer(5,LowPrice);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_NONE);
   SetIndexStyle(5,DRAW_NONE);
   //
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);
   SetIndexEmptyValue(2, 0.0);
   SetIndexEmptyValue(3, 0.0);
   IndicatorShortName("MTF MA Viewer");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
     for(int i=0;i<D1.HowManyBars;i++)
     {
      ObjectDelete("tlWickD1"+i);
      ObjectDelete("tlBodyD1"+i);
     }
     for(i=0;i<H4.HowManyBars;i++)
     {
      ObjectDelete("tlWickH4"+i);
      ObjectDelete("tlBodyH4"+i);
     }
     for(i=0;i<H1.HowManyBars;i++)
     {
      ObjectDelete("tlWickH1"+i);
      ObjectDelete("tlBodyH1"+i);
     }
     for(i=0;i<M30.HowManyBars;i++)
     {
      ObjectDelete("tlWickM30"+i);
      ObjectDelete("tlBodyM30"+i);
     }
     for(i=0;i<M15.HowManyBars;i++)
     {
      ObjectDelete("tlWickM15"+i);
      ObjectDelete("tlBodyM15"+i);
     }
     for(i=0;i<M5.HowManyBars;i++)
     {
      ObjectDelete("tlWickM5"+i);
      ObjectDelete("tlBodyM5"+i);
     }
   if (WindowFind("TF D1")!=-1)  ObjectDelete("TF D1");
   if (WindowFind("TF H4")!=-1)  ObjectDelete("TF H4");
   if (WindowFind("TF H1")!=-1)  ObjectDelete("TF H1");
   if (WindowFind("TF M30")!=-1) ObjectDelete("TF M30");
   if (WindowFind("TF M15")!=-1) ObjectDelete("TF M15");
   if (WindowFind("TF M5")!=-1)  ObjectDelete("TF M5");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   //if (Period()>PERIOD_H1) return(0);
//----
   double cp,op,hp,lp;
   int x=0;
   int BarCount=D1.HowManyBars;
   color cl;
   double maxhp=0;
     for(int i=1;i<BarCount+1;i++)
     {
      cp=iClose(NULL, PERIOD_D1, x);
      op=iOpen(NULL, PERIOD_D1, x);
      hp=iHigh(NULL, PERIOD_D1, x);
      lp=iLow(NULL, PERIOD_D1, x);
        if (cp > op)
        {
         cl=DodgerBlue;
        }
         else if(cp < op)
        {
         cl=Red;
        }
         else
        {
         cl=Green;
        }
         DrawTl("tlWickD1"+x, Time[i], Time[i], lp, hp, cl, 1);
         DrawTl("tlBodyD1"+x, Time[i], Time[i], op, cp, cl, 3);
         HighPrice[i]=hp;
         LowPrice[i] =lp;
         if (hp>maxhp) maxhp=hp;
//----
         Ema1[i]=iMA(NULL,PERIOD_D1,MA1D1.Period,0,MA1D1.Method,MA1D1.AppliedPrice,x);
         Ema2[i]=iMA(NULL,PERIOD_D1,MA2D1.Period,0,MA2D1.Method,MA2D1.AppliedPrice,x);
         Ema3[i]=iMA(NULL,PERIOD_D1,MA3D1.Period,0,MA3D1.Method,MA3D1.AppliedPrice,x);
         Ema4[i]=iMA(NULL,PERIOD_D1,MA4D1.Period,0,MA4D1.Method,MA4D1.AppliedPrice,x);
         x++;
     }
   if (BarCount!=0)
      drawText("TF D1", maxhp+(15*Point), Silver, Time[i-1]);
   else
      if(ObjectFind("TF D1")!=-1) ObjectDelete("TF D1");
   //return(0);
   int lasti=i+1;
   x=0;
   BarCount=H4.HowManyBars;
   maxhp=0;
     for(i=lasti;i<lasti+BarCount;i++)
     {
      cp=iClose(NULL, PERIOD_H4, x);
      op=iOpen(NULL, PERIOD_H4, x);
      hp=iHigh(NULL, PERIOD_H4, x);
      lp=iLow(NULL, PERIOD_H4, x);
        if (cp > op)
        {
         cl=DodgerBlue;
        }
         else if(cp < op)
        {
         cl=Red;
        }
         else
        {
         cl=Green;
        }
      DrawTl("tlWickH4"+x, Time[i], Time[i], lp, hp, cl, 1);
      DrawTl("tlBodyH4"+x, Time[i], Time[i], op, cp, cl, 3);
      HighPrice[i]=hp;
      LowPrice[i] =lp;
      if (hp>maxhp) maxhp=hp;
      Ema1[i]=iMA(NULL,PERIOD_H4,MA1H4.Period,0,MA1H4.Method,MA1H4.AppliedPrice,x);
      Ema2[i]=iMA(NULL,PERIOD_H4,MA2H4.Period,0,MA2H4.Method,MA2H4.AppliedPrice,x);
      Ema3[i]=iMA(NULL,PERIOD_H4,MA3H4.Period,0,MA3H4.Method,MA3H4.AppliedPrice,x);
      Ema4[i]=iMA(NULL,PERIOD_H4,MA4H4.Period,0,MA4H4.Method,MA4H4.AppliedPrice,x);
      x++;
     }
   if (BarCount!=0)
      drawText("TF H4", maxhp+(15*Point), Silver, Time[i-1]);
   else
      if(ObjectFind("TF H4")!=-1) ObjectDelete("TF H4");
   lasti=i+1;
   x=0;
   BarCount=H1.HowManyBars;
   maxhp=0;
     for(i=lasti;i<lasti+BarCount;i++)
     {
      cp=iClose(NULL, PERIOD_H1, x);
      op=iOpen(NULL, PERIOD_H1, x);
      hp=iHigh(NULL, PERIOD_H1, x);
      lp=iLow(NULL, PERIOD_H1, x);
        if (cp > op)
        {
         cl=DodgerBlue;
        }
         else if(cp < op)
        {
         cl=Red;
        }
         else
        {
         cl=Green;
        }
      DrawTl("tlWickH1"+x, Time[i], Time[i], lp, hp, cl, 1);
      DrawTl("tlBodyH1"+x, Time[i], Time[i], op, cp, cl, 3);
      HighPrice[i]=hp;
      LowPrice[i] =lp;
      if (hp>maxhp) maxhp=hp;
      Ema1[i]=iMA(NULL,PERIOD_H1,MA1H1.Period,0,MA1H1.Method,MA1H1.AppliedPrice,x);
      Ema2[i]=iMA(NULL,PERIOD_H1,MA2H1.Period,0,MA2H1.Method,MA2H1.AppliedPrice,x);
      Ema3[i]=iMA(NULL,PERIOD_H1,MA3H1.Period,0,MA3H1.Method,MA3H1.AppliedPrice,x);
      Ema4[i]=iMA(NULL,PERIOD_H1,MA4H1.Period,0,MA4H1.Method,MA4H1.AppliedPrice,x);
      x++;
     }
   if (BarCount!=0)
      drawText("TF H1", maxhp+(15*Point) , Silver, Time[i-1]);
   else
      if(ObjectFind("TF H1")!=-1) ObjectDelete("TF H1");
   lasti=i+1;
   x=0;
   BarCount=M30.HowManyBars;
   maxhp=0;
     for(i=lasti;i<lasti+BarCount;i++)
     {
      cp=iClose(NULL, PERIOD_M30, x);
      op=iOpen(NULL, PERIOD_M30, x);
      hp=iHigh(NULL, PERIOD_M30, x);
      lp=iLow(NULL, PERIOD_M30, x);
        if (cp > op)
        {
         cl=DodgerBlue;
        }
         else if(cp < op)
        {
         cl=Red;
        }
         else
        {
         cl=Green;
        }
      DrawTl("tlWickM30"+x, Time[i], Time[i], lp, hp, cl, 1);
      DrawTl("tlBodyM30"+x, Time[i], Time[i], op, cp, cl, 3);
      HighPrice[i]=hp;
      LowPrice[i] =lp;
      if (hp>maxhp) maxhp=hp;
      Ema1[i]=iMA(NULL,PERIOD_M30,MA1M30.Period,0,MA1M30.Method,MA1M30.AppliedPrice,x);
      Ema2[i]=iMA(NULL,PERIOD_M30,MA2M30.Period,0,MA2M30.Method,MA2M30.AppliedPrice,x);
      Ema3[i]=iMA(NULL,PERIOD_M30,MA3M30.Period,0,MA3M30.Method,MA3M30.AppliedPrice,x);
      Ema4[i]=iMA(NULL,PERIOD_M30,MA4M30.Period,0,MA4M30.Method,MA4M30.AppliedPrice,x);
      x++;
     }
   if (BarCount!=0)
      drawText("TF M30", maxhp+(15*Point)  ,Silver, Time[i-1]);
   else
      if(ObjectFind("TF M30")!=-1) ObjectDelete("TF M30");
   lasti=i+1;
   x=0;
   BarCount=M15.HowManyBars;
   maxhp=0;
     for(i=lasti;i<lasti+BarCount;i++)
     {
      cp=iClose(NULL, PERIOD_M15, x);
      op=iOpen(NULL, PERIOD_M15, x);
      hp=iHigh(NULL, PERIOD_M15, x);
      lp=iLow(NULL, PERIOD_M15, x);
        if (cp > op)
        {
         cl=Blue;
        }
         else if(cp < op)
        {
         cl=Red;
        }
         else
        {
         cl=Green;
        }
      DrawTl("tlWickM15"+x, Time[i], Time[i], lp, hp, cl, 1);
      DrawTl("tlBodyM15"+x, Time[i], Time[i], op, cp, cl, 3);
      HighPrice[i]=hp;
      LowPrice[i] =lp;
      if (hp>maxhp) maxhp=hp;
      Ema1[i]=iMA(NULL,PERIOD_M15,MA1M15.Period,0,MA1M15.Method,MA1M15.AppliedPrice,x);
      Ema2[i]=iMA(NULL,PERIOD_M15,MA2M15.Period,0,MA2M15.Method,MA2M15.AppliedPrice,x);
      Ema3[i]=iMA(NULL,PERIOD_M15,MA3M15.Period,0,MA3M15.Method,MA3M15.AppliedPrice,x);
      Ema4[i]=iMA(NULL,PERIOD_M15,MA4M15.Period,0,MA4M15.Method,MA4M15.AppliedPrice,x);
      x++;
     }
   if (BarCount!=0)
      drawText("TF M15",maxhp+(15*Point)  ,Silver, Time[i-1]);
   else
      if(ObjectFind("TF M15")!=-1) ObjectDelete("TF M15");
   lasti=i+1;
   x=0;
   BarCount=M5.HowManyBars;
   maxhp=0;
     for(i=lasti;i<lasti+BarCount;i++)
     {
      cp=iClose(NULL, PERIOD_M5, x);
      op=iOpen(NULL, PERIOD_M5, x);
      hp=iHigh(NULL, PERIOD_M5, x);
      lp=iLow(NULL, PERIOD_M5, x);
        if (cp > op)
        {
         cl=Blue;
        }
         else if(cp < op)
        {
         cl=Red;
        }
         else
        {
         cl=Green;
        }
      DrawTl("tlWickM5"+x, Time[i], Time[i], lp, hp, cl, 1);
      DrawTl("tlBodyM5"+x, Time[i], Time[i], op, cp, cl, 3);
      HighPrice[i]=hp;
      LowPrice[i] =lp;
      if (hp>maxhp) maxhp=hp;
      Ema1[i]=iMA(NULL,PERIOD_M5,MA1M5.Period,0,MA1M5.Method,MA1M5.AppliedPrice,x);
      Ema2[i]=iMA(NULL,PERIOD_M5,MA2M5.Period,0,MA2M5.Method,MA2M5.AppliedPrice,x);
      Ema3[i]=iMA(NULL,PERIOD_M5,MA3M5.Period,0,MA3M5.Method,MA3M5.AppliedPrice,x);
      Ema4[i]=iMA(NULL,PERIOD_M5,MA4M5.Period,0,MA4M5.Method,MA4M5.AppliedPrice,x);
      x++;
     }
   if (BarCount!=0)
      drawText("TF M5",maxhp+(15*Point) ,Silver, Time[i-1]);
   else
      if(ObjectFind("TF M5")!=-1) ObjectDelete("TF M5");
//----
   return(0);
  }
//+------------------------------------------------------------------+

void drawText(string name,double lvl,color Color, datetime  t)
  {
   //string text_name = StringConcatenate(name);
   if(ObjectFind(name)!=0)
     {
      ObjectCreate(name, OBJ_TEXT, WindowFind("MTF MA Viewer"), t, lvl);

     }
   ObjectSetText(name, name, 8, "Tahoma", EMPTY);
   ObjectSet(name, OBJPROP_COLOR, Color);
   ObjectMove(name, 0, t, lvl);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  void DrawTl(string n, datetime from, datetime to, double p1, double p2,color c, int w){

   //n=StringConcatenate("",n);

   if (ObjectFind(n)!=WindowFind("MTF MA Viewer"))
     {
      ObjectCreate(n, OBJ_TREND, WindowFind("MTF MA Viewer"), from, p1, to , p2);
      }else{
      ObjectMove(n, 0, from, p1);
      ObjectMove(n, 1, to, p2);
     }
   ObjectSet(n, OBJPROP_WIDTH, w);
   ObjectSet(n, OBJPROP_RAY, false);
   ObjectSet(n, OBJPROP_COLOR, c);
   ObjectSet(n, OBJPROP_BACK, true);
   WindowRedraw();
  }

//+------------------------------------------------------------------+