module router_fifo_tb();

//Global variables

reg clock, resetn, soft_reset, write_enb, read_enb, lfd_state;
reg [7:0] data_in;
wire full, empty;
wire [7:0] data_out;
integer i;

//Parameter constant CYCLE to generate the Time-period of the clock
parameter CYCLE=10;

//DUT instance
router_fifo DUT (clock,
				resetn,
				soft_reset,
				write_enb,
				read_enb,
				lfd_state,
				data_in,
				data_out,
				empty,
				full);
				
//Clock generation logic
always 
	begin
		#(CYCLE/2);
		clock=1'b0;
		#(CYCLE/2);
		clock=~clock;
	end

//Initialize task

task initialize();
	begin 
		write_enb = 0;
		read_enb = 0;
		data_in = 0;
		lfd_state = 0;
	end
endtask

// Reset task

task rst_dut();
	begin
		@(negedge clock);
		resetn = 1'b0;
		@(negedge clock);
		resetn = 1'b1;
	end
endtask

//soft_reset task
task soft_rst_dut();
	begin
		@(negedge clock);
		soft_reset=1'b1;
		@(negedge clock);
		soft_reset=1'b0;
	end
endtask
//Packet generation task

task pkt_gen;
reg[7:0] payload_data, parity, header;
reg[5:0] payload_len;
reg[1:0] addr;
	begin
		@(negedge clock);
		payload_len = 6'd4;
		addr=2'b01;
		header={payload_len,addr};
		data_in=header;
		lfd_state=1'b1;
		write_enb=1;
		for(i=0;i<payload_len;i=i+1)
			begin
				@(negedge clock);
				lfd_state=0;
				payload_data={$random} %256;
				data_in=payload_data;
			end
		@(negedge clock);
		parity={$random}%256;
		data_in=parity;
		end
endtask

//Read task

task read(input b);
	begin 
		@(negedge clock)
		read_enb=b;
	end
endtask

//Stimulus block

initial
	begin
		initialize;
		rst_dut;
		soft_rst_dut;
		pkt_gen;
		@(negedge clock);
		write_enb = 0;
		repeat(5)
		@(negedge clock);
		read(1'b1);
		@(negedge clock);
		wait(empty)
		@(negedge clock);
		read(1'b0);
		#1000 $finish;
	end
//Monitor task

initial 
	$monitor("Values are data_in = %b, data_out = %b, full = %b, empty = %b", data_in,data_out,full,empty);
	
endmodule
		


	
