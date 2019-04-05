# ======================================================================================================
# Main Game
# ======================================================================================================
gameloop: 
Register 1: I/O of User: 0 = no movement, 1 = up, 2=right, 3=down, 4=left, 5 = up-right, 6 = down-right, 7 = down-left, 8 = up-left

addi $3, $0, 1;
addi $4, $0, 2; 
addi $5, $0, 3; 
addi $6, $0, 4; 
addi $7, $0, 5; 
addi $8, $0, 6; 
addi $9, $0, 7;
addi $10, $0, 8; 
bneq $1, $3, ___; #If move up do inst below, else jump
