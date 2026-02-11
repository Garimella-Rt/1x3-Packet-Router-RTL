# 1x3-Packet-Router-RTL
Synthesizable Verilog RTL implementation of a 1x3 packet router top that includes modules like FIFO, controller, synchronizer and register.
In this project, I designed a 1×3 packet router in Verilog that forwards data packets between computer networks. The router operates as an OSI Layer 3 routing device, directing incoming packets to one of three output channels based on the address field in the packet header.

The design follows a packet-based protocol. It receives data from the source LAN through the data_in signal on a byte-by-byte basis at the positive edge of the clock. The resetn signal is an active-low synchronous reset.

The start of a new packet is indicated by asserting pkt_valid, and the end of the packet is indicated by deasserting pkt_valid.

Incoming packets are stored in one of three FIFOs based on the destination address. The router contains three separate FIFOs, each corresponding to a destination LAN.

During packet read operation, the destination LAN monitors the vld_out_x signal (where x = 0, 1, 2) and asserts read_enb_x to read data through the corresponding data_out_x channel.

The router may enter a busy state, indicated by the busy signal. When asserted, the source LAN must pause transmission until the router is ready.

To ensure data integrity, a parity-based error detection mechanism is implemented. If the received parity byte does not match the internally computed parity, the error signal is asserted. This allows the source LAN to detect transmission errors and retransmit the packet if necessary.

The router can receive one packet at a time, while allowing up to three packets to be read simultaneously from the output FIFOs.
