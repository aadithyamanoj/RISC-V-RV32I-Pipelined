sim:
	cd obj_dir; make -f Vtop.mk; cp Vtop ../sim; cd ..

clean:
	rm -f sim; cd obj_dir; rm -f Vtop *.o;cd ..
