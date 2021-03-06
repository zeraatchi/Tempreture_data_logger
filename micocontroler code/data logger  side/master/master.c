
#include <mega32a.h>
#include <delay.h>
#include <nRF24L01+.h>
#include <stdlib.h>
#include <stdio.h>

void rom_code_recive(void);
void next_req(void);
void timer_1_on(void);
void timer_1_rst(void);

unsigned int j,conter;
unsigned char n;
unsigned char t1_ovf_counter=0;

#define datald  PORTC.3
#define wirless  PORTC.4

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
#define RX_BUFFER_SIZE 512
char rx_buffer[RX_BUFFER_SIZE];


unsigned int rx_wr_index,rx_rd_index,rx_counter;




// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status;
char data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0){
    if ((data>=65 && data <=70) || (data>=48 && data <=57) || (data>=97 && data <=101)
    || (data=='*') || (data=='/') || (data=='.') || (data=='|') || (data=='t') || (data=='r')) {
    rx_buffer[rx_wr_index++]=data; 
    if (data=='*') rx_wr_index=0;
    if (data=='/') rom_code_recive();
    
     }
  }
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;


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

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  if ((t1_ovf_counter++)==2) {
  next_req();  
  timer_1_rst();
  }  
}



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

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x5F;

ACSR=0x80;
SFIOR=0x00;


ADCSRA=0x00;


SPCR=0x00;


TWCR=0x00;

DDRC.3=1;
DDRC.4=1;
#asm("sei")
delay_ms(1000);
j=1000;
n=0;
nRF_Config(0);
/*
delay_ms(100);
putchar('*');
putchar('s');
putchar('e');
putchar('t');
putchar('/');
delay_ms(7000);    */
putchar('*');
putchar('t');
putchar('a');
putchar('l');
putchar('/');
delay_ms(8000);
putchar('*');
putchar('r');
putchar('t');
putchar('a');
putchar('/');

timer_1_on();

while (1)
      {  
          /*
      if(State == 1) 
        {  
        //if ((payload[1]=='r') & (payload[2]=='t') & (payload[3]=='a')){   
        State = 0;
        putchar(payload[1]);
        putchar(payload[2]);
        putchar(payload[3]);
        putchar(payload[4]);
        putchar(payload[5]); 
       // nRF_Config(0);  transmite
       // }
      }  
         */
      while (j<rx_wr_index){
      if (rx_wr_index<=30){    
      wirless=~wirless;
       Send_Data(rx_wr_index, &rx_buffer[0]); 
        next_req();
       }
       else if (rx_wr_index>30) {
         if (conter>30) {
           Send_Data(30, &rx_buffer[j-1]); 
           conter=conter-30;
           j=j+30;
           }
         if (conter<30) {
           Send_Data(conter, &rx_buffer[j-1]);  
            next_req();
           }       
         } 
         }  
        // Send_Data(1,"|");
  
 
      }
}


void rom_code_recive(void){
 timer_1_rst();
 datald=~datald;
 j=1;
 conter=rx_wr_index;


}

void next_req(void){
timer_1_rst();
j=1000;
delay_ms(100);
if (n!=4){
putchar('*');
putchar('r');
putchar('t');
if (n==0) putchar('b'); 
else if (n==1) putchar('c'); 
else if (n==2) putchar('d'); 
else if (n==3) putchar('e'); 
}
else if (n==4){
delay_ms(50);
putchar('*');
putchar('t');
putchar('a');
putchar('l');
putchar('/');
delay_ms(6000);
  putchar('*');
  putchar('r');
  putchar('t');
 putchar('a'); 
 }
putchar('/');
if (n<4) n++;
else n=0;

}


void timer_1_on(void)
{
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 14.400 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

TIMSK=0x04;

}


void timer_1_rst(void)
{
 TCNT1=0;
 t1_ovf_counter=0;
 }
