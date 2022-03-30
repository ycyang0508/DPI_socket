#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <sys/un.h>
#include <netinet/in.h>

#include "dpi_c.h"
#include "dpi_sv.h"



#ifdef __cplusplus                          
    extern "C" {                          
#endif 



void display_c(void)
{
    printf("hello world\n");

}




int init_socket_server(int portNum)
{
    char inputBuffer[256] = {};
    int sock_fd_server = 0;
    int sock_fd_client = 0;
    char message[] = {"Hi,this is server.\n"};
    char tmpBuf[256];
    int tmpBufLen;

    printf("init_socket_server %d\n",portNum);

    sock_fd_server = socket(AF_INET,SOCK_STREAM,0);
    if (sock_fd_server == -1)
    {
        printf("%s %d\n",__FILE__,__LINE__);
        exit(0);
    }
    fcntl(sock_fd_server, F_SETFL, O_NONBLOCK);
    
    struct sockaddr_in serverInfo,clientInfo;
    socklen_t addrlen = sizeof(clientInfo);
    bzero(&serverInfo,sizeof(serverInfo));
    serverInfo.sin_family = PF_INET;
    serverInfo.sin_addr.s_addr = INADDR_ANY;
    serverInfo.sin_port = htons(portNum);
    bind(sock_fd_server,(const struct sockaddr *)&serverInfo,sizeof(serverInfo));
    listen(sock_fd_server,5);

    
    while(1)
    {
        sock_fd_client = accept(sock_fd_server,(struct sockaddr* )&clientInfo,&addrlen);
        if (sock_fd_client != -1)
        {
            recv(sock_fd_client,inputBuffer,sizeof(inputBuffer),0);
            printf("CPP %d> 1 %s",portNum,inputBuffer);
            c_write_to_sv_buffer(sizeof(inputBuffer),inputBuffer);
            c_read_from_sv_buffer(sizeof(inputBuffer),tmpBuf);
            printf("CPP %d> 2 %d %s\n",portNum,tmpBufLen,tmpBuf);
            

            client_op(12);
            send(sock_fd_client,message,sizeof(message),0);
            
        }
        else
        {
            delay_us(100);
        }
    }
    
    return 0;

}

int sv_read_from_c_buffer(int len,char *buffIn)
{
    int i ;


    for (i = 0;i<=len;i++)
    {
        buffIn[i] = i;
        //*(char *)svGetArrElemPtr1(buffIn,i) = i;
    }
    //buffIn = buffer;


    return 0;
}

int sv_write_to_c_buffer(int len,char *buffIn)
{
    int i ;

    printf("C> ");
    for (i = 0;i<len;i++)
    {
        printf("%d ",buffIn[i]);
    }
    printf("\n");


    return 0;
}



#ifdef __cplusplus                          
 }                          
#endif


