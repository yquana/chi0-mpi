CFLAG=-I./

chi0.x:
	nvcc -o chi0.x main.cu $(CFLAG) ./io/parse.cu ./utils/utils.cu

clean:
	rm chi0.x

test:
	./chi0.x
