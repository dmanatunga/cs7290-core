// Size of HARP Instruction
`define INS_SIZE 32 
// Size of HARP data
`define REG_DATA_SIZE 32
// Size of HARP predicate data
`define PRED_DATA_SIZE 1
// Size of HARP Opcode
`define OPCODE_SIZE 6
// Number of address bits for general purpose regiter
`define REG_ADDR_SIZE 4
// Number of address bits for predicate register
`define PRED_ADDR_SIZE 2
// Number of address bits for ROB
`define ROB_ADDR_SIZE 5

`define INS_TYPE_SIZE 2

// The size of the larger data width
// Typically, should always be register data size
`define DATA_WIDTH `REG_DATA_SIZE
// The size of the largest dest address 
// In this case, the size of the registers
// Note: should be changed to size of pred, if
// more predicate registers than general purpose registers
`define DEST_ADDR_SIZE `REG_ADDR_SIZE