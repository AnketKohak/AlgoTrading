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


double openOrderIDb;
double openOrderIDb1;
double openOrderIDb2;

double openOrderIDs;
double openOrderIDs1;
double openOrderIDs2;
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
   double MODE= MODE_EMA;
   double mavalue=20;
   double ma = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,0);
   double atr= iATR(NULL,0,14,0);



   double ma0   = iMA(NULL,0,mavalue,0,MODE,PRICE_CLOSE,0);
   double ma5   = iMA(NULL,0,5,0,MODE,PRICE_CLOSE,0);
   double ma8   = iMA(NULL,0,8,0,MODE,PRICE_CLOSE,0);
   double ma13  = iMA(NULL,0,13,0,MODE,PRICE_CLOSE,0);
   double ma20  = iMA(NULL,0,20,0,MODE,PRICE_CLOSE,0);
   double ma50  = iMA(NULL,0,50,0,MODE,PRICE_CLOSE,0);


   double ma01  = iMA(NULL,0,mavalue,0,MODE,PRICE_CLOSE,0);
   double ma51  = iMA(NULL,0,5,0,MODE,PRICE_CLOSE,0);
   double ma81  = iMA(NULL,0,8,0,MODE,PRICE_CLOSE,0);
   double ma131 = iMA(NULL,0,13,0,MODE,PRICE_CLOSE,0);
   double ma201 = iMA(NULL,0,20,0,MODE,PRICE_CLOSE,0);
   double ma501 = iMA(NULL,0,50,0,MODE,PRICE_CLOSE,0);
   double ma2001 = iMA(NULL,0,200,0,MODE,PRICE_CLOSE,0);
   double adx   =iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,0);
//double uptrend= ((ma5<ma4)&&(ma4<ma3)&&(ma3<ma2)&&(ma2<ma1));

//double downtrend=((ma5>ma4)&&(ma4>ma3)&&(ma3>ma1)&&(ma2>ma1));
double ma1 = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,1);
   double ma2 = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,2);
   bool upma= ((ma1-ma2)>0.00005);
   bool downma= ((ma2-ma1)>0.00005);


      double uptrend   = (ma2001<ma501) && (ma501<ma201) && (ma201<ma131) && (ma131<ma81) && (ma81<ma51);
   double downtrend = (ma2001>ma501) && (ma501>ma201) && (ma201>ma131) && (ma131>ma81) && (ma81>ma51);
   double sideways=((!uptrend) && (!downtrend));


   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if(uptrend )  //buying
        {
         double stopLossPrice = Bid-(atr*2);
         double takeProfitPrice = Bid+((atr));
         openOrderIDb = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         openOrderIDb1 = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         openOrderIDb2 = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         // Sleep(1800000);
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());

        }
      else
         if(downtrend )
           {
            double stopLossPrice = Bid+(atr*2);
            double takeProfitPrice = Bid-((atr));
            openOrderIDs = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            openOrderIDs1 = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            openOrderIDs2 = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);

            //  Sleep(1800000);
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
            if(ma81>ma51)
              {
               OrderClose(openOrderIDb2,0.01,Bid,10);
              }
           }
         else
            if(OrderSelect(1,SELECT_BY_POS,MODE_TRADES))
              {
               if(ma131>ma81)
                 {
                  OrderClose(openOrderIDb1,0.01,Bid,10);
                 }
              }
            else
               if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(ma201>ma131)
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
               if(ma81<ma51)
                 {
                  OrderClose(openOrderIDs2,0.01,Bid,10);
                 }
              }
            else
               if(OrderSelect(1,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(ma131<ma81)
                    {
                     OrderClose(openOrderIDs1,0.01,Bid,10);
                    }
                 }
               else
                  if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(ma201>ma131)
                       {

                        OrderClose(openOrderIDs,0.01,Bid,10);
                       }
                    }
           }
     }
  }

//+------------------------------------------------------------------+
