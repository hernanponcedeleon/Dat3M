all: 
	clang -Xclang -disable-O0-optnone -Xclang -disable-llvm-passes -S -emit-llvm -g -gcolumn-info ck_epoch.c client-code.c
 
	llvm-link client-code.ll ck_epoch.ll -S -o ebr_test.ll 

	opt $(OPTFLAGS) ebr_test.ll -S -o ebr_test-opt.ll   

	rm ck_epoch.ll client-code.ll    

clean:
	rm *.ll
	rm *.out