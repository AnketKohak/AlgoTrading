//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
#include<custom.mqh>

int magicNB=2;
int orderID;
int rsibuy=30;
int rsisell=70;
double RSI1= iRSI(NULL,0,14,PRICE_CLOSE,2);
double RSI2= iRSI(NULL,0,14,PRICE_CLOSE,1);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RSI =iRSI(NULL,0,14,PRICE_CLOSE,0);
double  MA200=iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,1);
// here is everthing is delcercd function
input double lotszie=0.01;
input int  stoploss = 50;
input int takeprofit =100;
double BTP = Close[1]+100*pipvlaue();
double BSL = Close[3];

double STP =Close[1]-100*pipvlaue();
double SSL = Close[3];


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   Alert("EA IS JUST START");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("EA IS JUST END");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---


   double RSI1= iRSI(NULL,0,14,PRICE_CLOSE,2);
   double RSI2= iRSI(NULL,0,14,PRICE_CLOSE,1);
   double  MA200=iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,1);
// here is everthing is delcercd function



   if(!CheckIfOpenOrderByMagicNB(magicNB))

     {
      if(RSI1 <rsibuy && RSI2 > rsibuy )             //  this our condition rsi and ma for buying
        {
         Print("this is BUY singal ");
         double stoplossprice =  Close[3]; // this stoploss
         double takeprofitprice = Close[1]+100*pipvlaue(); //take profit
         orderID  = OrderSend(NULL,OP_BUY,lotszie,Close[0],10,0,0,NULL,magicNB);//this for order sending
         if(orderID <0)
           {
            Print("order is rejected error is :" + GetLastError());
           }
         else
           {
            Print("Order was sent");                       // this part strat from if , this for error finding
           }
        }
      //noe start code of selling
      else
         if(RSI1 > rsisell && RSI2 < rsisell )            // this our condition rsi and ma for buying
           {
            Print("this is sell singal ");
            Print(Bid);
            double stoplossprice = Close[3];  // this stoploss
            double takeprofitprice = Close[3]-100*pipvlaue();//take profit
            orderID = OrderSend(NULL,OP_SELL,lotszie,Close[0],10,0,0,NULL,magicNB);//this for sell order sending
            if(orderID <0)
              {
               Print("order is rejected error is :" + GetLastError());
              }
            else
              {
               Print("Order was sent");                               // this part strat from if , this for error finding
              }

           }



     }
   else
     {

      Alert("order alerady open");
      if(OrderSelect(orderID,SELECT_BY_TICKET)==true)
        {
         int ordertype=OrderType();

         double CurrentExitPoint;
         double CurrentProfit;

         if(ordertype == 0)
           {
            CurrentExitPoint =NormalizeDouble(BSL,Digits);
            CurrentProfit =NormalizeDouble(BTP,Digits);
           }
         else
           {
            CurrentExitPoint=NormalizeDouble(SSL,Digits);
            CurrentProfit =NormalizeDouble(STP,Digits);
           }
         double TP=OrderTakeProfit();
         double SL=OrderStopLoss();

         if(TP != Close[0] || SL != Close[0])
           {

            bool Ans = OrderModify(orderID,OrderOpenPrice(),CurrentExitPoint,CurrentProfit,0);
            if(Ans== true)
              {
               Alert("order modified :" + orderID);
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
