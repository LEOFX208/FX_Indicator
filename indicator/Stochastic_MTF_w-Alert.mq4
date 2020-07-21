//+--------------------------------------------------------------------------+
//|                                               Stochastic_MTF_w-Alert.mq4 |
//|                                              Copyright © 2006, Keris2112 |
//|                                                 http://www.forex-tsd.com |
//|                           Stochastic w-Alert mod 7/20/07 transport_david |
//| http://finance.groups.yahoo.com/group/MetaTrader_Experts_and_Indicators/ |
//+--------------------------------------------------------------------------+

#property copyright "Copyright © 2006, Keris2112"
#property link      "http://www.forex-tsd.com"

#property indicator_separate_window

#property indicator_buffers 2

#property indicator_color1 Magenta
#property indicator_color2 DeepSkyBlue

#property indicator_maximum 100
#property indicator_minimum   0

#property indicator_level1 80
#property indicator_level2 50
#property indicator_level3 20


//---- input parameters
/*************************************************************************
PERIOD_M1   1
PERIOD_M5   5
PERIOD_M15  15
PERIOD_M30  30 
PERIOD_H1   60
PERIOD_H4   240
PERIOD_D1   1440
PERIOD_W1   10080
PERIOD_MN1  43200
You must use the numeric value of the timeframe that you want to use
when you set the TimeFrame' value with the indicator inputs.
---------------------------------------
MODE_SMA    0 Simple moving average, 
MODE_EMA    1 Exponential moving average, 
MODE_SMMA   2 Smoothed moving average, 
MODE_LWMA   3 Linear weighted moving average. 
You must use the numeric value of the MA Method that you want to use
when you set the 'ma_method' value with the indicator inputs.

**************************************************************************/

extern string AS = "-- Alert Settings --";
extern bool   Play_Alert = True;
extern int    Alert_Bar  = 0;

extern string TF = "-- Time Frame To Display --";
extern int    TimeFrame  = 0;

extern string SS = "-- Stoch Settings --";
extern int    KPeriod    = 5;
extern int    DPeriod    = 3;
extern int    Slowing    = 3;
extern int    MAMethod   = 0;
extern int    PriceField = 0; // PriceField:  0=Hi/Low   1=Close/Close

double Signal_Buffer[];
double Main_Buffer[];

int goober;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   
//---- indicator line
   
   IndicatorBuffers(2);
   
   SetIndexBuffer(0,Signal_Buffer);
   SetIndexStyle(0,DRAW_LINE,STYLE_DOT,0);
   SetIndexLabel(0,"Stoch Signal");
   
   SetIndexBuffer(1,Main_Buffer);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
   SetIndexLabel(1,"Stoch Main");
   
//---- name for DataWindow and indicator subwindow label   
   switch(TimeFrame)
   {
      case 1 : string TimeFrameStr="Period_M1"; break;
      case 5 : TimeFrameStr="Period_M5"; break;
      case 15 : TimeFrameStr="Period_M15"; break;
      case 30 : TimeFrameStr="Period_M30"; break;
      case 60 : TimeFrameStr="Period_H1"; break;
      case 240 : TimeFrameStr="Period_H4"; break;
      case 1440 : TimeFrameStr="Period_D1"; break;
      case 10080 : TimeFrameStr="Period_W1"; break;
      case 43200 : TimeFrameStr="Period_MN1"; break;
      default : TimeFrameStr="Current Timeframe";
   } 
   IndicatorShortName("Stochastic_MTF_w-Alert("+KPeriod+","+DPeriod+","+Slowing+") "+TimeFrameStr);  
  }
//----
   return(0);

int start()
  {
   datetime TimeArray[];
   int    i,shift,limit,y=0,counted_bars=IndicatorCounted();
    
// Plot defined timeframe on to current timeframe   
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame); 
   
   limit=Bars-counted_bars;
   for(i=0,y=0;i<limit;i++)
   {
   if (Time[i]<TimeArray[y]) y++;
   
 /***********************************************************   
   Add your main indicator loop below.  You can reference an existing
      indicator with its iName  or iCustom.
   Rule 1:  Add extern inputs above for all neccesary values   
   Rule 2:  Use 'TimeFrame' for the indicator timeframe
   Rule 3:  Use 'y' for the indicator's shift value
 **********************************************************/  
     
   Signal_Buffer[i] = iStochastic(Symbol(),TimeFrame,KPeriod,DPeriod,Slowing,MAMethod,PriceField,1,y);
   Main_Buffer[i]   = iStochastic(Symbol(),TimeFrame,KPeriod,DPeriod,Slowing,MAMethod,PriceField,0,y); 
   
   }  
          
//FIX for display
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if (TimeFrame>Period()) {
     int PerINT=TimeFrame/Period()+1;
     datetime TimeArr[]; ArrayResize(TimeArr,PerINT);
     ArrayCopySeries(TimeArr,MODE_TIME,Symbol(),Period()); 
     for(i=0;i<PerINT+1;i++) {if (TimeArr[i]>=TimeArray[0]) {
//----
 /************************************************ by Raff   
    Refresh buffers:         buffer[i] = buffer[0];
 ********************************************************/  

   Signal_Buffer[i] = Signal_Buffer[0];
   Main_Buffer[i]   = Main_Buffer[0];
   

//----
   } } }
//+++++++++++++++++++++++++++++++++++++++++++++++++++
//END of fix
   
   if (Play_Alert)
    {
     if ( (Main_Buffer[1+Alert_Bar] < Signal_Buffer[1+Alert_Bar]) && (Main_Buffer[0+Alert_Bar] > Signal_Buffer[0+Alert_Bar]) && (goober < Time[0]) )
      {
        Alert("Stochastic_MTF_w-Alert Cross Up , "+Symbol()+" , M_"+Period()+" , Ask = ",Ask," , Hour = ",Hour()," , Minute = ",Minute()," .");
        //PlaySound("email.wav");
        goober = Time[0];
      }
     if ( (Main_Buffer[1+Alert_Bar] > Signal_Buffer[1+Alert_Bar]) && (Main_Buffer[0+Alert_Bar] < Signal_Buffer[0+Alert_Bar]) && (goober < Time[0]) )
      {
        Alert("Stochastic_MTF_w-Alert Cross Down , "+Symbol()+" , M_"+Period()+" , Bid = ",Bid," , Hour = ",Hour()," , Minute = ",Minute()," .");
        //PlaySound("email.wav");
        goober = Time[0];
      }
    }
   
   return(0);
  }
//+------------------------------------------------------------------+