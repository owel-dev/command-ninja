all:
	stack build -v
	stack exec command-ninja-exe
