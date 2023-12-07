compile: fnctl.c
	@gcc -std=gnu99 -Wall -pedantic-errors fnctl.c -o fnctl

exec: compile a.sh balance.dat b.sh b_non-cooperative.sh update_balance.sh
	@chmod +rwx *
	@./demo.sh
	@echo "100" > balance.dat
clean:
	@rm -f fnctl
	@echo "100" > balance.dat
