/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/9/2015
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 14.745600 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32a.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <1wire.h>


#include <ds18b20.h>


#define MAX_DS1820 8

unsigned char ds18b20_devices;

unsigned char ds18b20_rom_codes[MAX_DS1820][9];

char code;

char string[8][7];
char string2[12];
float tmpreture;
unsigned char cou;
unsigned char dt;

void rd_tmp_all(void);
void rom_code(void);
void tx_off(void);
void read_tmp(void);
void putchar2(unsigned char a);
void putchar3(unsigned int a);

void tx_on(void);
void tx_off(void);

void set_res(void);

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 16
char rx_buffer[RX_BUFFER_SIZE];


unsigned char rx_wr_index,rx_rd_index,rx_counter;


// This flag is set on USART Receiver buffer overflow


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{

char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   
   rx_buffer[rx_wr_index++]=data;    
   if (data=='*') rx_wr_index=0;
   if (data=='/'){
     if  ((rx_buffer[0]=='t') & (rx_buffer[1]=='a') & (rx_buffer[2]=='l')) rd_tmp_all();  
     if  ((rx_buffer[0]=='r') & (rx_buffer[1]=='c') & (rx_buffer[2]==code)) rom_code();  
     if  ((rx_buffer[0]=='o') & (rx_buffer[1]=='f') & (rx_buffer[2]==code)) tx_off();  
     if  ((rx_buffer[0]=='r') & (rx_buffer[1]=='t') & (rx_buffer[2]==code)) read_tmp();  
     if  ((rx_buffer[0]=='s') & (rx_buffer[1]=='e') & (rx_buffer[2]=='t')) set_res(); 
     if  ((rx_buffer[0]=='w') & (rx_buffer[1]=='d') & (rx_buffer[2]=='r')) WDTCR=0x08; 
      }
  if (rx_wr_index == RX_BUFFER_SIZE)
    rx_wr_index=0;
    
  
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif



void main(void)
{                                                                      



PORTA=0x00;
DDRA=0x00;


PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;


PORTD=0x00;
DDRD=0x00;


TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;


TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;


MCUCR=0x00;
MCUCSR=0x00;


TIMSK=0x00;


UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x5F;
tx_off();

ACSR=0x80;
SFIOR=0x00;


ADCSRA=0x00;


SPCR=0x00;

WDTCR|=0x18;
WDTCR=0x00;


TWCR=0x00;

// 1 Wire Bus initialization
// 1 Wire Data port: PORTD
// 1 Wire Data bit: 2
// Note: 1 Wire port settings must be specified in the
// Project|Configure|C Compiler|Libraries|1 Wire IDE menu.
w1_init();


code='b';


#asm("sei")


while (1)
      { 
 
   

      }
}

void rd_tmp_all(void){

ds18b20_devices=w1_search(0xf0,ds18b20_rom_codes); 
    if (ds18b20_devices!=0) 
      for (cou=0;cou<ds18b20_devices;cou++){
         tmpreture=ds18b20_temperature(&ds18b20_rom_codes[cou][0]);    
         ftoa(tmpreture,2,string2);     
         string[cou][0]=string2[0];
         string[cou][1]=string2[1];
         string[cou][2]=string2[2];
         string[cou][3]=string2[3];
         string[cou][4]=string2[4];
         string[cou][5]=string2[5];
         
         }

}

void rom_code(void){

ds18b20_devices=w1_search(0xf0,ds18b20_rom_codes);

putchar('*');
putchar('r');
if (ds18b20_devices>0)
  for (dt=0;dt<ds18b20_devices;dt++)
    for (cou=0;cou<9;cou++) {
     putchar2(ds18b20_rom_codes[dt][cou]);
     putchar(',');     
            }

putchar('/');

}

void read_tmp(void){
unsigned char o;
tx_on();
 delay_ms(1);
     ds18b20_devices=w1_search(0xf0,ds18b20_rom_codes);
    putchar('*');
    putchar('t');
    putchar(code);
    putchar(ds18b20_devices+48);
    putchar(',');   
    
    for (o=0;o<ds18b20_devices;o++){  
      for (cou=2;cou<8;cou++) {
        putchar3(ds18b20_rom_codes[o][cou]);
        //putchar(',');
      }  
      cou=0;
      while (string[o][cou]!='.') putchar(string[o][cou++]);
      putchar(string[o][cou++]);
      putchar(string[o][cou]); 
      putchar(',');
    }  
    if (code=='e') putchar('|'); 
     putchar('/');
     
    delay_ms(1);
     tx_off();
     }
     
    
void putchar2(unsigned char a){
unsigned char b;
if (a<9) putchar(a+48);
else if ((a>9) & (a<99)){
    b=a/10;
    putchar(b+48);
    b= a % 10;
    putchar(b+48);
    } 
else if (a>99){
  b=a/100;
  putchar(b+48);
  b=a/10;
  b=b % 10;
  putchar(b+48);
  b=a % 10;
  putchar(b+48);
  }
}

void putchar3(unsigned int a){
unsigned int b;
b= a / 16;
if ((b>=0) && (b<=9)) putchar(b+48);
else if (b>9) putchar(b+55); 
 
b= a % 16;
if ((b>=0) && (b<=9)) putchar(b+48);
else if (b>9) putchar(b+55); 
 
}


void tx_off(void){
UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x5F;
DDRD.1=0;
PORTD.1=0;
}

void tx_on(void){
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x5F;
DDRD.1=1;
}

void set_res(void){

    ds18b20_devices=w1_search(0xf0,ds18b20_rom_codes); 
    if (ds18b20_devices!=0) 
      for (cou=0;cou<ds18b20_devices;cou++)
        ds18b20_init(&ds18b20_rom_codes[cou][0],-20,120,1);
         
       

  } 
  

