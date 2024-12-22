//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
// Define input parameters
// Define input parameters
// Define input parameters
int redCandleCount = 0;    // Variable to count red candles
int greenCandleCount = 0;  // Variable to count green candles
int maPeriod = 200;         // Period for the moving average
double maValue;            // Value of the moving average
bool countedCandle = false; // Variable to avoid multiple counting
datetime premin= 0;
bool gc2=Open[2]<Close[2];
bool gc1=Open[1]<Close[1];
bool rc2=Open[2]>Close[2];
bool rc1=Open[1]>Close[1];
int high=0;
int highest=0;
int ma1=10;
int ma2=20;
int can=0;
double win=1;

double bal=10000;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   double tenkan_sen=iIchimoku(NULL,0,9,26,52,MODE_TENKANSEN,2);
   double kijun_sen=iIchimoku(NULL,0,9,26,52,MODE_KIJUNSEN,2);


   double chikou_span=iIchimoku(NULL,0,9,26,52,MODE_CHIKOUSPAN,26);
   double up_kumo=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,0);
   double  down_kumo=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANB,0);


   double up_kumo26=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,-26);
   double  down_kumo26=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANB,-26);
   datetime min=Minute();
// Calculate the moving average value
   bool Up_Arrow_Condition = ((tenkan_sen>=kijun_sen)&&(up_kumo26>down_kumo26)&&(Open[1]>up_kumo)&&(Open[1]>down_kumo)&&(kijun_sen>up_kumo)&&(chikou_span>Close[26]));
   bool Down_Arrow_Condition =((tenkan_sen<=kijun_sen)&&(up_kumo26<down_kumo26)&&(Open[1]<up_kumo)&&(Open[1]<down_kumo)&&(kijun_sen<up_kumo)&&(chikou_span<Close[26]));
//  double testma=iMA(NULL,0,ma1,0,MODE_SMA,PRICE_CLOSE,1);
//---


// Check the current candle's color and its position relative to the moving average
   if(Up_Arrow_Condition && premin!=min)
     {
      premin=min;
      if(Open[1]>Close[1])
        {
         can++;

         high++;
         bal=bal-1;
        }
      else
         if(Open[1]<Close[1])
           {
            can++;
            high=0;
            bal=bal+win;
           }
     }
   else
      if(Down_Arrow_Condition &&premin!=min)
        {
         premin=min;
         if(Open[1]<Close[1])
           {
            can++;
            high++;
            bal=bal-1;
           }
         else
            if(Open[1]>Close[1])
              {
               can++;
               high=0;
               bal=bal+win;
              }
        }

   if(high>=highest)
     {
      highest=high;
     }

// Do something with the counts
   Comment("high: ", high,"\n",
           "highest: ", highest,"\n",
           "bal : ",bal,"\n",
           "bal : ",can);
  }
//+------------------------------------------------------------------+
