//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
#include  <custom.mqh>

int magicNB = 55555;
double lotsize=0.01;

int openOrderIDb;
int openOrderIDb1;
int openOrderIDb2;

int openOrderIDs;
int openOrderIDs1;
int openOrderIDs2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Alert("");
   Alert("Starting Strategy BB 2Bans MR");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Alert("Stopping Strategy BB 2Bans MR");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double tenkan_sen=iIchimoku(NULL,0,9,26,52,MODE_TENKANSEN,0);
   double kijun_sen=iIchimoku(NULL,0,9,26,52,MODE_KIJUNSEN,0);

   double tenkan_sen1=iIchimoku(NULL,0,9,26,52,MODE_TENKANSEN,1);
   double kijun_sen1=iIchimoku(NULL,0,9,26,52,MODE_KIJUNSEN,1);

   double chikou_span=iIchimoku(NULL,0,9,26,52,MODE_CHIKOUSPAN,26);
   double up_kumo=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,0);
   double  down_kumo=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANB,0);
   double ma = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,0);
   double ma1 = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,1);
   double ma2 = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,2);
   bool upma= ((ma1-ma2)>0.00005);
   bool downma= ((ma2-ma1)>0.00005);

   double up_kumo26=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,-26);
   double  down_kumo26=iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANB,-26);

   bool uptrend   =((tenkan_sen>=kijun_sen)&&(up_kumo26>down_kumo26)&&(Bid>up_kumo)&&(Bid>down_kumo)&&(kijun_sen>up_kumo)&&(chikou_span>Close[26]) && (tenkan_sen1<tenkan_sen) && (kijun_sen1<kijun_sen));
   bool downtrend =((tenkan_sen<=kijun_sen)&&(up_kumo26<down_kumo26)&&(Bid<up_kumo)&&(Bid<down_kumo)&&(kijun_sen<up_kumo)&&(chikou_span<Close[26]) && (tenkan_sen1>tenkan_sen) && (kijun_sen1>kijun_sen));
//   bool uptrend = (up_kumo<Bid && down_kumo<Bid && down_kumo26<up_kumo26 &&kijun_sen<tenkan_sen && up_kumo<kijun_sen && chikou_span<Close[26] && tenkan_sen1<tenkan_sen && kijun_sen1<kijun_sen);
//   bool downtrend=(up_kumo>Bid && down_kumo>Bid && down_kumo26>up_kumo26 &&kijun_sen>tenkan_sen && up_kumo>kijun_sen && chikou_span>Close[26] && tenkan_sen1>tenkan_sen && kijun_sen1>kijun_sen);
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if((uptrend == true)) //buying
        {
         double stoploss;
         double takeprofit;
         double stopLossPrice = Low[2];
         double takeProfitPrice = ((Bid-Low[2])*2)+Bid;
         openOrderIDb1 = OrderSend(NULL,OP_BUY,0.01,Ask,10,0,0,NULL,001);
         openOrderIDb2 = OrderSend(NULL,OP_BUY,0.01,Ask,10,0,0,NULL,002);
         openOrderIDb = OrderSend(NULL,OP_BUY,0.01,Ask,10,0,0,NULL,magicNB);
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(downtrend == true)
           {
            double stoploss=50;
            double stopLossPrice = Low[3];
            double takeProfitPrice = ((Bid-Low[3])*2)+Bid;

            openOrderIDs = OrderSend(NULL,OP_SELL,0.01,Bid,10,0,0,NULL,magicNB);
            openOrderIDs1 = OrderSend(NULL,OP_SELL,0.01,Bid,10,0,0,NULL,101);
            openOrderIDs2 = OrderSend(NULL,OP_SELL,0.01,Bid,10,0,0,NULL,102);
            if(openOrderIDs < 0)
               Alert("order rejected. Order error: " + GetLastError());
           }
     }
   else //else if you already have a position, update orders if need too.
     {
      if(OrderType()==0)
        {
         if(OrderSelect(2,SELECT_BY_POS,MODE_TRADES))
           {
            if(tenkan_sen<kijun_sen)
              {
               OrderClose(openOrderIDb2,0.01,Bid,10);
              }
           }
         else
            if(OrderSelect(1,SELECT_BY_POS,MODE_TRADES))
              {
               if(chikou_span<Close[26])
                 {
                  OrderClose(openOrderIDb1,0.01,Bid,10);
                 }
              }
            else
               if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(Close[0]<up_kumo)
                    {

                     OrderClose(openOrderIDb,0.01,Bid,10);
                    }
                 }
        }
      else
         if(OrderType()==1)
           {
            if(OrderSelect(2,SELECT_BY_POS,MODE_TRADES))
              {
               if(tenkan_sen>kijun_sen)
                 {
                  OrderClose(openOrderIDs2,0.01,Ask,10);
                 }
              }
            else
               if(OrderSelect(1,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(chikou_span>Close[26])
                    {
                     OrderClose(openOrderIDs1,0.01,Ask,10);
                    }
                 }
               else
                  if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(Close[0]>up_kumo)
                       {

                        OrderClose(openOrderIDs,0.01,Ask,10);
                       }
                    }
           }
     }
  }










//+------------------------------------------------------------------+

//+------------------------------------------------------------------

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
