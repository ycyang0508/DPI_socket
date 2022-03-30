#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h> 


int main()
{
    int sock_fd_client = 0;
    char inputBuffer[256] = {};
    char message[] = {"Hi,this is client.\n"};



    sock_fd_client = socket(AF_INET,SOCK_STREAM,0);

    struct sockaddr_in serverInfo,clientInfo;
    socklen_t addrlen = sizeof(clientInfo);
    
    bzero(&serverInfo,sizeof(sockaddr_in));
    serverInfo.sin_family = PF_INET;
    serverInfo.sin_addr.s_addr = inet_addr("127.0.0.1");
    serverInfo.sin_port = htons(8700);

    if (connect(sock_fd_client,(struct sockaddr *)&serverInfo,sizeof(serverInfo)) < 0)
    {
        printf("Error in %s %d\n",__FILE__,__LINE__);
        exit(0);
    }

    send(sock_fd_client,message,sizeof(message),0);
    recv(sock_fd_client,inputBuffer,sizeof(inputBuffer),0);
    printf("%s\n",inputBuffer);


    return 0;
}

