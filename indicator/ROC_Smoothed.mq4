//+------------------------------------------------------------------+
//|                                                 ROC_Smoothed.mq4 |
//|                                    Copyright © 2006, Robert Hill |
//|                                                                  |
//| Modified ROC to use EMA                                          |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2006, Robert Hill"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Red
//---- indicator parameters
extern string  strROC = "ROC Period for lookback";
extern int     RPeriod = 10;
extern string  sep0 = "----------------------------------";
extern string  strMA = "MA input parameters";
extern int     MAPeriod=14;
extern string  sep1 = "----------------------------------";
extern string  strType = "Moving Average Types" ;
extern string  str0 = "0 = SMA, 1 = EMA, 2 = SMMA";
extern string  str1 = "3 = LWMA, 4 = LSMA, 5 = NLMA";
extern int     MAType = 1;
extern string  sep2 = "----------------------------------";
extern string  strAP = "Applied Price Types";
extern string  str2 = "0=close, 1=open, 2=high";
extern string  str3 = "3=low, 4=median(high+low)/2";
extern string  str4 = " 5=typical(high+low+close)/3";
extern string  str5 = "6=weighted(high+low+close+close)/4";
extern int     MAAppliedPrice = 0;
extern string  sep3 = "----------------------------------";
extern string  str6 = "NonLagMA Deviation";
extern double  Deviation      = 0;         
extern bool    UsePercent = false;

//---- indicator buffers
double     RateOfChange[];

//---- variables

int    MAMode;
string strMAType;

// Variables for NonLag
int Phase;
double Len;  
double Cycle =  4;
double pi = 3.1415926535;    
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,RPeriod);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
//---- indicator buffers mapping
   if(!SetIndexBuffer(0,RateOfChange))
      Print("cannot set indicator buffers!");
switch (MAType)
   {
      case 1: strMAType="EMA"; MAMode=MODE_EMA; break;
      case 2: strMAType="SMMA"; MAMode=MODE_SMMA; break;
      case 3: strMAType="LWMA"; MAMode=MODE_LWMA; break;
      case 4: strMAType="LSMA"; break;
      case 5: strMAType="NLMA";break;
      default: strMAType="SMA"; MAMode=MODE_SMA; break;
   }
   IndicatorShortName( "ROC (" + RPeriod + ")_Smoothed_" + strMAType+ " (" +MAPeriod + ") ");
//---- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,"ROC_Smoothed");

// Variables for NonLag
   Phase = MAPeriod-1;
   Len = MAPeriod*Cycle + Phase;  

//---- initialization done
   return(0);
  }

//+------------------------------------------------------------------+
//| LSMA with PriceMode                                              |
//| PrMode  0=close, 1=open, 2=high, 3=low, 4=median(high+low)/2,    |
//| 5=typical(high+low+close)/3, 6=weighted(high+low+close+close)/4  |
//+------------------------------------------------------------------+

double LSMA(int Rperiod, int prMode, int shift)
{
   int i;
   double sum, pr;
   int length;
   double lengthvar;
   double tmp;
   double wt;

   length = Rperiod;
 
   sum = 0;
   for(i = length; i >= 1  ; i--)
   {
     lengthvar = length + 1;
     lengthvar /= 3;
     tmp = 0;
     switch (prMode)
     {
     case 0: pr = Close[length-i+shift];break;
     case 1: pr = Open[length-i+shift];break;
     case 2: pr = High[length-i+shift];break;
     case 3: pr = Low[length-i+shift];break;
     case 4: pr = (High[length-i+shift] + Low[length-i+shift])/2;break;
     case 5: pr = (High[length-i+shift] + Low[length-i+shift] + Close[length-i+shift])/3;break;
     case 6: pr = (High[length-i+shift] + Low[length-i+shift] + Close[length-i+shift] + Close[length-i+shift])/4;break;
     }
     tmp = ( i - lengthvar)*pr;
     sum+=tmp;
    }
    
    wt = MathFloor(sum*6/(length*(length+1))/Point)*Point; 
    
    return(wt);
}

double NonLag(int RPeriod, int myLen, double myPhase, int myShift)
{

   int i;
   double alfa, beta, t, Sum, Weight,g;
   double myPrice;
   double Coeff =  3*pi;
   
      Weight=0; Sum=0; t=0;
       
      for (i=0;i<=myLen-1;i++)
	   { 
        g = 1.0/(Coeff*t+1);   
        if (t <= 0.5 ) g = 1;
        beta = MathCos(pi*t);
        alfa = g * beta;
        myPrice = iMA(NULL,0,1,0,MODE_SMA,MAAppliedPrice,myShift+i); 
        Sum += alfa*myPrice;
        Weight += alfa;
        if ( t < 1 ) t += 1.0/(myPhase-1); 
        else if ( t < myLen-1 )  t += (2*Cycle-1)/(Cycle*RPeriod-1);
      }
	   if (Weight > 0) Weight = (1.0+Deviation/100)*Sum/Weight;
      Weight = MathFloor(Weight/Point)*Point;
      return (Weight);

}

//+------------------------------------------------------------------+
//| Rate of Change Smoothed                                          |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   double ROC, MA_Cur, MA_Prev;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- ROC calculation
   for(int i=0; i<limit; i++)
   {
      if (MAType == 4)
      {
        MA_Cur = LSMA(MAPeriod, MAAppliedPrice,i);
        MA_Prev = LSMA(MAPeriod, MAAppliedPrice,i+RPeriod);
      }
      else if (MAType == 5)
      {
        MA_Cur = NonLag(MAPeriod, Len, Phase, i);
        MA_Prev = NonLag(MAPeriod, Len, Phase, i+RPeriod);
      }
      else
      {
        MA_Cur = iMA(NULL,0,MAPeriod,0,MAMode, MAAppliedPrice,i);
        MA_Prev = iMA(NULL,0,MAPeriod,0,MAMode, MAAppliedPrice,i+RPeriod);
      }
      ROC=MA_Cur-MA_Prev;
      if (UsePercent)
      {
        RateOfChange[i] = 100 * ROC / MA_Prev; 
      }
      else
      {
        RateOfChange[i] = NormalizeDouble(ROC/Point,1);
      }
   }
      
//---- done
   return(0);
  }