/*               In The Name Of GOD 
 * Name: nrf24l01p.h
 * Coded by: Sayyed Hassan Mortazavi (mortazavi91@gmail.com)
 * Creation Date:  2013-05-15
*/

#ifndef __nrf24l01p_h_included__
#define __nrf24l01p_h_included__

#define IRQ PORTB.2
#define DD_IRQ DDRB.2

#define CE PORTB.3
#define DD_CE DDRB.3

#define CSN PORTB.4
#define DD_CSN DDRB.4  

#define MOSI PORTB.5
#define DD_MOSI DDRB.5 

#define MISO PORTB.6
#define DD_MISO DDRB.6

#define CLK PORTB.7
#define DD_CLK DDRB.7
 
flash unsigned char base_address[5]={0x00,0x01,0x03,0x07,0x00};
unsigned char temp_address[5]={0x00,0x01,0x03,0x07,0x00};
unsigned char payload[33];
unsigned char command_buff=0,status_buff=0,nrf_state=0;
char nrf_mode;
bit sent_actived=0;
unsigned char spi(unsigned char data)
{
    SPDR=data;
    while(!(SPSR & 0x80)); 
    data=SPSR; 
    return SPDR;
}
void nrf_inst(unsigned char ins)
{
    int i;                              
    CSN=0;    
    status_buff=spi(ins);       
    switch(ins & 0xE0)
    {
        case 0x00:
        {                         
            if((ins & 0x1F)==0x0A || (ins & 0x1F)==0x0B || (ins & 0x1F)==0x10) 
            {
                for(i=4;i>=0;i--)
                {
                    temp_address[i]=spi(0xFF);
                }
            }
            else
            {
                command_buff=spi(0xFF);   
            }
            break;
        }
        case 0x20:  
        {                         
            if((ins & 0x1F)==0x0A || (ins & 0x1F)==0x0B || (ins & 0x1F)==0x10)
            {
                for(i=4;i>=0;i--)
                {
                    spi(base_address[i]);
                } 
            }
            else
            {  
                spi(command_buff);
            }
            break;
        }         
        case 0x60:
        {
            if((ins & 0x01)==1)
            {
                i=payload[0];
                while(i!=0)
                {
                    payload[i]=spi(0xFF); 
                    i--;
                }    
            }
            else 
            {
                command_buff=spi(0xFF);    
            }
            break;
        }
        case 0xA0:
        {    
            i=payload[0];
            while(i!=0)
            {
                spi(payload[i]); 
                i--;
            }
            break;
        }
        
    }   
    CSN=1;  
    delay_us(10);
}

interrupt [EXT_INT2] void ext2_isr()
{ 
    if(nrf_mode==0)
    {
        nrf_inst(0xFF); 
        if(status_buff & 0x20)  
        {
            nrf_state=2;
            nrf_inst(0x17);        
            if((command_buff & 0x01)==0)
            {
                nrf_inst(0x60);  
                if(command_buff<=32)
                {
                    payload[0]=command_buff; 
                    nrf_inst(0x61);    
                    nrf_state=3;
                }
                else
                    nrf_inst(0xE2);
            }          
        }
        else 
        {
            nrf_state=4;
        }
    }                                                     
    else
    {
        nrf_inst(0x60); 
        if(command_buff>32)
        {
            nrf_inst(0xE2);
        }
        else
        {
            payload[0]=command_buff;
            nrf_inst(0x61);
            nrf_state=1;
        }
    }     
    command_buff=0x7E; 
    nrf_inst(0x27);    
    nrf_inst(0xE1);                                                  
}

void sent()
{ 
    if(sent_actived)
    {
        sent_actived=0;  
        if((temp_address[4]==base_address[4]) && (temp_address[3]==base_address[3]) && (temp_address[2]==base_address[2]) && (temp_address[1]==base_address[1]) && (temp_address[0]==base_address[0]))
        {
            nrf_inst(0xE1); 
            nrf_inst(0xA0);           
            delay_ms(10);
            CE=1;
            delay_us(20);
            CE=0;
            delay_ms(10);
        }
        else
            nrf_state=5; 
    }                                      
}

void nrf_config(char mode)
{
    IRQ=1; 
    CSN=1; 
    DD_CSN=1;
    CLK=0;
    DD_CLK=1;
    CE=0;
    DD_CE=1;
    DD_MOSI=1;
    DD_MISO=0;  
    GIFR=0x20;
    GICR|=0x20;          
    #asm("sei")
    SPCR=0x50;        
    delay_ms(110);
    
    nrf_mode=mode;   
    
    command_buff=0x01;
    nrf_inst(0x21);   
    
    command_buff=0x01;
    nrf_inst(0x22);   
      
    command_buff=0x03;
    nrf_inst(0x23);   
    
    command_buff=0x2f;
    nrf_inst(0x24);   
                       
    command_buff=0x01;   
    nrf_inst(0x25);      
    
    command_buff=0x06;   
    nrf_inst(0x26);      
    
    nrf_inst(0x2A);      
    
    nrf_inst(0x30);      
    
    command_buff=0x01;   
    nrf_inst(0x3C);      
        
    command_buff=0x07;   
    nrf_inst(0x3D);          
    
    if(mode==0)
    {
        command_buff=0x4E;
        nrf_inst(0x20);   
        delay_ms(100);
        sent_actived=1;
    }
    else
    {
        command_buff=0x3F;
        nrf_inst(0x20);   
        delay_ms(5);
        CE=1;
    } 
}
#endif
