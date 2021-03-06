#include <mega32a.h>
#include <delay.h>
#include <nRF24L01+.h>

void send_temp_comand(void);

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
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data; 
   //putchar(data);   
   if (data=='*') rx_wr_index=0;
   if (data=='/'){
     if ((rx_buffer[0]=='r') & (rx_buffer[1]=='t') & (rx_buffer[2]=='a')) { 
     puts(rx_buffer);
     PORTA.0=~PORTA.0; 
     send_temp_comand();
     
        
 
      
       }  
       }
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
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

#include <stdio.h>

unsigned int j;
void sd(void);

void main(void)
{

PORTA=0x00;
DDRA=0x07;


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
// USART Baud Rate: 19200
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x2F;


ACSR=0x80;
SFIOR=0x00;


ADCSRA=0x00;


SPCR=0x00;


TWCR=0x00;


#asm("sei")

//nRF_Config(1);

j=0;
 nRF_Config(1);    
 DDRA.0=1;
 DDRA.2=1;  
 PORTA.0=1;
while (1)
      {
    
      if(State == 1) 
        {     
       // for (j=0;j<payload[0];j++)
        //data1[j]=payload[j+1];
       // putchar(payload[1]); 
         State = 0;
          sd();
   
         
            
     // puts(data1);     
     // PORTA.0=~PORTA.0;  
      PORTA.1=~PORTA.1;
     // PORTA.2=~PORTA.2;
      //delay_ms(1000);
 
          
        
        }  
        }
     
}

void sd(void){
unsigned int i;
for(i=0;i<payload[0];i++)
  putchar(payload[i+1]);
  PORTA.2=~PORTA.2; 
  j=0;
  }
  
void send_temp_comand(void){
 nRF_Config(0); 
 delay_ms(1000);
Send_Data(3,&rx_buffer[0]); 
delay_ms(100);
nRF_Config(1);
delay_ms(1000); 
}


