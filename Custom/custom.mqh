//+------------------------------------------------------------------+
//|                                                       test01.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
 
 void step()
 {
 double MA = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,0);

double RSI = iRSI(NULL,0,14,PRICE_CLOSE,0);

Alert("");
  if(RSI<50 && MA<Bid)
  {
   Alert("sell" );
  }
   else 
  {
   Alert("not sell");
   
  }
 }
 //-----------------------------------------------------------------------------------------------
 
//---------------------------------------------------------
void whichdayistoday()
{
int Dayofweek = DayOfWeek();

switch (Dayofweek)
{
case 1 : Alert(1);
         break;
case 2 : Alert(2);
         break;

case 3 : Alert(3);
         break;

case 4 : Alert(4);
         break;


case 5 : Alert(5);
         break;

case 6 : Alert(6);
         break;

case 7 : Alert(0);
         break;
default : Alert("Error. No such day in the week.");
}
}
//----------------------------------------------------------





//-------------------------------------
void balance()
{
double accountbalance = AccountBalance ();
Alert("");
Alert(accountbalance);
Alert("loss in pips=2%");
Alert("max loss in pips "+ accountbalance * 0.02);
}
//------------------------------

double pipvlaue()
{
 if(Digits>=5)
 {
 return 0.00001;
 }
 else 
 {
 return 0.0001;
 }
 }
 
 
 //----------takeporfit or stoploss-------
 
 //---------------FOR  INPUT
 void takeprofitandstoploss()
{
double nowprice;
int  stoploss = 30;
int takeprofit =40;

//----------------FOR ITS BUY
if(nowprice>Ask)
{
double stoplossprice = Ask - stoploss * 0.00001;
double takeprofitprice = Ask + takeprofit * 0.00001;
int buying=OrderSend(NULL,0,0.01,Ask,10,stoplossprice,takeprofitprice);
Alert("buy price "+Ask);
Alert("your loss price "+ stoplossprice);
Alert("your profit  "+ takeprofitprice);


}
///------------FOR ITS SELL
else if(nowprice<Bid)
{
double stoplossprice = Bid + stoploss * 0.00001;
double takeprofitprice = Bid - takeprofit *0.00001 ;
Alert("sell price "+Bid);
Alert("your loss price "+ stoplossprice);
Alert("your profit  "+ takeprofitprice);
}
}




//----------------magic number---------------

bool CheckIfOpenOrderByMagicNB(int magicNB)
{
int openOrders = OrdersTotal();
 
for(int i=0;i<openOrders;i++)
 {
  if(OrderSelect(i,SELECT_BY_POS)==true)
   {
    if(OrderMagicNumber() == magicNB)  
    {
    return true;
    }
   }
 }
  return false;
}   
