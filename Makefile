
IRUN_OPT = -sv -64bit -v93 -vlog_ext +.vh -relax -access +rwc -namemap_mixgen -cdslib ${XILINX_PRE_LIBS}/cds.lib  ${XILINX_VIVADO}/data/verilog/src/glbl.v -top tbTop -top glbl -timescale 1ps/1ps


sim : 
	g++ client.cpp -o socket_client -fpermissive
	irun ${IRUN_OPT} -dpi -dpiheader "dpi_sv.h" -dpiimpheader "dpi_c.h" -64bit -f stim.f -l run.log

flat : 
	flatf.pl -i stim.f -o stim_flat.f
	rm -f tmp*.txt stim_flat.txt
	grep -v "//" stim_flat.f > tmp.txt
	grep -v "+incdir+" tmp.txt > tmp1.txt
	grep -v "\-cpost" tmp1.txt > tmp2.txt
	grep -v "\-end" tmp2.txt > tmp3.txt
	mv tmp3.txt stim_flat.txt
	rm -f tmp*.txt

verdi :
	flatf.pl -i stim.f -o stim_flat.f
	verdi -sv -2012 -f stim_flat.f &
vs :
	vs ~/se_prj/socket_example/socket_example.vpj &

clean :
	rm -rf INCA_libs irun.* novas_dump.log dpi_c.h dpi_sv.h socket_client stim_flat.* irun.* waves.* verdiLog novas.* *.fsdb *.log run.* *.err

