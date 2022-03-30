import "DPI-C" context function void display_c();
import "DPI-C" context task init_socket_server(int);
import "DPI-C" context function int sv_read_from_c_buffer(input int readLen,output byte tmpBufIn[256]);
import "DPI-C" context function int sv_write_to_c_buffer(input int readLen,input byte tmpBufIn[256]);


export "DPI-C" task delay_us;
export "DPI-C" task client_op;
export "DPI-C" function c_write_to_sv_buffer;
export "DPI-C" function c_read_from_sv_buffer;


task automatic delay_us(input int usNumIn);

    repeat(usNumIn) #1us;
    //$write("delay %d us\n",usNumIn);

endtask

event client_op_e;
task automatic client_op(input int dataIn);

    int len;
    byte buffer[256];

    //read_buffer_from_c(len);

    $write("client_op %d len %d\n",dataIn,len);

    sv_read_from_c_buffer(256,buffer);
    
    $write("SV> ");
    for(int i = 0; i < 256;i++)
        $write("%d",buffer[i]);
    $write("\n");

    sv_write_to_c_buffer(256,buffer);
    
    ->client_op_e;
endtask


byte tmpBufOut[256];


function automatic void c_write_to_sv_buffer(int writeLen,input byte tmpBufIn[256]);

    string testA;

    if (writeLen > 256)
    begin
        $write("Error in %s %d\n",`__FILE__,`__LINE__);
        $finish;
    end
    
    //$write("%s\n",bufIn[0]);
    $write("SV> ");
    
    for(int i = 0; i < 18;i++)
    begin
        tmpBufOut[i] = tmpBufIn[i];
        $write("%s",tmpBufIn[i]);
    end
    $write("\n");
    
    
endfunction

function automatic void c_read_from_sv_buffer(input int readLen,output byte bufOut[256]);

    string testA;

    if (readLen > 256)
    begin
        $write("Error in %s %d\n",`__FILE__,`__LINE__);
        $finish;
    end


    for(int i = 0; i < readLen;i++)
    begin
        bufOut[i] = tmpBufOut[i];
    end
    
    
endfunction



initial
begin
    #0.1;
    $write("hello verilog\n");

    fork 
        init_socket_server(8700);
        init_socket_server(8701);
    join
end


