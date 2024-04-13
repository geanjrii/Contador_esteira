module Contador_esteira(clk, sensor, rst, parada, perigo, continuar, display_c , display_i, LED_vm, LED_vd);
	input logic clk, sensor, rst, parada, perigo, continuar;
	
	output logic [6:0] display_c , display_i;
		
	output logic LED_vm, LED_vd;

	reg [3:0] cont_c, cont_i;	//contador de ciclos e itens

	reg [2:0] auto_p;		//contador de ciclos sem item

	reg [1:0] funcionamento;	//estados

	parameter espera = 2'b00, emergencia = 2'b01, atividade = 2'b10;
			 
	initial funcionamento <= espera;

	always_ff @ (posedge clk, posedge rst) begin	//bloco procedural
	
		if(rst)	begin		//reset assíncrono
			cont_c <= 4'b0;
			cont_i <= 4'b0;
			auto_p <= 3'b0;
		end
	
		else begin		
			case(funcionamento)	//operações em cada estado
				espera: begin
					LED_vd <= 0;
					LED_vm <= 0;
					funcionamento <= continuar ? atividade : espera;
				end
				emergencia: begin
					LED_vm <= 1;
					LED_vd <= 0;
					funcionamento <= continuar ? atividade : emergencia;
				end						
				atividade: begin
					LED_vd <= 1;
					LED_vm <= 0;
					cont_c <= cont_c + 1;
					if(perigo) funcionamento <= emergencia;
					else if(parada | (auto_p >= 3'b101)) funcionamento <= espera;
					else begin
						funcionamento <= atividade;
							if(sensor) begin
								cont_i <= cont_i + 1;
								auto_p <= 0;
							end
							else
								auto_p <= auto_p + 1;
							end
					end
			endcase
		end   
	end 

	always_comb begin	//decodificador do display

		case(cont_c)					//    abcdefg
			4'b0000: display_c = 7'b1111110;	//0
			4'b0001: display_c = 7'b0110000;	//1
			4'b0010: display_c = 7'b1101101;	//2
			4'b0011: display_c = 7'b1111001;	//3
			4'b0100: display_c = 7'b0110011;	//4
			4'b0101: display_c = 7'b1011011;	//5
			4'b0110: display_c = 7'b1011111;	//6
			4'b0111: display_c = 7'b1110000;	//7
			4'b1000: display_c = 7'b1111111;	//8
			4'b1001: display_c = 7'b1111011;	//9
			4'b1010: display_c = 7'b1110111;	//A
			4'b1011: display_c = 7'b0011111;	//B
			4'b1100: display_c = 7'b1001110;	//C
			4'b1101: display_c = 7'b0111101;	//D
			4'b1110: display_c = 7'b1001111;	//E
			4'b1111: display_c = 7'b1000111;	//F
			default: display_c = 7'b0000001;	//display apresenta traço "-" como padrão
		endcase
	
		case(cont_i)					//    abcdefg
			4'b0000: display_i = 7'b1111110;	//0
			4'b0001: display_i = 7'b0110000;	//1
			4'b0010: display_i = 7'b1101101;	//2
			4'b0011: display_i = 7'b1111001;	//3
			4'b0100: display_i = 7'b0110011;	//4
			4'b0101: display_i = 7'b1011011;	//5
			4'b0110: display_i = 7'b1011111;	//6
			4'b0111: display_i = 7'b1110000;	//7
			4'b1000: display_i = 7'b1111111;	//8
			4'b1001: display_i = 7'b1111011;	//9
			4'b1010: display_i = 7'b1110111;	//A
			4'b1011: display_i = 7'b0011111;	//B
			4'b1100: display_i = 7'b1001110;	//C
			4'b1101: display_i = 7'b0111101;	//D
			4'b1110: display_i = 7'b1001111;	//E
			4'b1111: display_i = 7'b1000111;	//F
			default: display_i = 7'b0000001;	//display apresenta traço "-" como padrão
		endcase
	end
endmodule 
