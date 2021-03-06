// Size of HARP Instruction
`define INS_WIDTH 32 
// Size of fetch queue ID
`define FETCH_ID_SIZE 4
// Size of HARP data
`define REG_DATA_WIDTH 32
// Size of HARP predicate data
`define PRED_DATA_WIDTH 1
// Size of HARP Opcode
`define OPCODE_SIZE 6
// Number of address bits for general purpose regiter
`define REG_ADDR_SIZE 4
// Number of address bits for predicate register
`define PRED_ADDR_SIZE 2
// Number of address bits for ROB
`define ROB_ID_SIZE 5

// Size of the instruction type designator
`define INS_TYPE_SIZE 2
`define INS_STATE_SIZE 1
// Size of functional unit op
`define FUNC_UNIT_OP_SIZE 3
`define NUM_FUNC_UNITS 8
// The size of the larger data width
// Typically, should always be register data size
`define DATA_WIDTH `REG_DATA_WIDTH
// The size of the largest dest address 
// In this case, the size of the registers
// Note: should be changed to size of pred, if
// more predicate registers than general purpose registers
`define DEST_ADDR_SIZE `REG_ADDR_SIZE

// EXCEPTION ID SIZE
`define EXCEPTION_ID_SIZE 3
`define	NO_EXCEPTION 3'd0
`define INVALID_OP_EXCEPTION 3'd1
`define DIV_BY_ZERO_EXCEPTION 3'd2
