--* design name:   tb_DPD .
--*
--*
--*
--* description:
--*            This design implements a test banch for DPD
--*         
--*      @author Ghazi Aoussaji  | ghazi.aoussaji@gmail.com
--*      @version 1.0
--*      @date created 5/24/2019
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Pack.all; 
use STD.textio.all;
use ieee.std_logic_textio.all;
entity tb_DPD is 
end entity tb_DPD;

architecture rtl of tb_DPD is


  

	signal  clk1	:	std_logic;
	signal  clk2	:	std_logic;
	signal  reset_n	:	std_logic;
	signal  enable	:	std_logic;
	signal  re_c1	: signed(data_width-1 downto 0):="010000000000";	
	signal  re_c3	: signed(data_width-1 downto 0):="000011010111";	
	signal	im_c1	: signed(data_width-1 downto 0):="001011001101";	
	signal	im_c3	: signed(data_width-1 downto 0):="001011001101";	
	signal	I_in	: STD_LOGIC_VECTOR(data_width-1 downto 0);	
	signal	Q_in	: STD_LOGIC_VECTOR(data_width-1 downto 0);	

	signal	ready	:std_logic;
	signal	I_out	: STD_LOGIC_VECTOR(data_width-1 downto 0);	
	signal	Q_out	: STD_LOGIC_VECTOR(data_width-1 downto 0);	
	
	file re_input 	: TEXT open READ_MODE is "../input/re_in.txt";  
	file im_input 	: TEXT open READ_MODE is "../input/im_in.txt";  
 	file re_output 	: TEXT open WRITE_MODE is "../output/re_output.txt";
	file im_output 	: TEXT open WRITE_MODE is "../output/im_output.txt";
begin
	ut : DPD
		PORT MAP (
			clk1			=> clk1,
			clk2		=> clk2,
			reset_n		=> reset_n,
			enable		=> enable,
			re_c1		=> re_c1,
			re_c3  		=> re_c3,
			im_c1  		=> im_c1,
			im_c3  		=> im_c3,
			I_in   		=> I_in ,
			Q_in   		=> Q_in ,
			ready		=> ready,
			I_out  		=> I_out,
			Q_out  		=> Q_out
		); 

	-- First clock domain        
	CLK1_process1 :process
	begin           
	clk1<='0';
	wait for 80 ns;
	clk1<='1';
	wait for 80 ns;
	end process;
	-- Second clock domain
	CLK2_process1 :process
	begin           
	clk2<='0';
	wait for 20 ns;
	clk2<='1';
	wait for 20 ns;
	end process;

 	-- Reset process
	rst_proc : process
	begin
	
		reset_n <= '0';
		wait for 20 ns;
		reset_n <= '1';
		wait;
	end process;

 	-- enable process
	enable_proc : process
	begin
	
		enable <= '0';
		wait for 30 ns;
		enable <= '1';
		wait;
	end process;
			-- Inphase data in
           process(clk1)  
           	variable my_input_line : LINE;  
           	variable input1: std_logic_vector(data_width-1 downto 0);  
           	begin  
                	if rising_edge(clk1) then                      
                     		readline(re_input, my_input_line);  
                     		read(my_input_line,input1);  
                     		--data <= std_logic_vector(to_unsigned(input1, DATA_WIDTH));  
							I_in <= input1;
                     
                      
                	end if;  
           end process; 
			-- Inquadrature data in
           process(clk1)  
           	variable my_input_line : LINE;  
           	variable input1: std_logic_vector(data_width-1 downto 0);  
           	begin  
                	if rising_edge(clk1) then                      
                     		readline(im_input, my_input_line);  
                     		read(my_input_line,input1);  
                     		--data <= std_logic_vector(to_unsigned(input1, DATA_WIDTH));  
							Q_in <= input1;
                     
                      
                	end if;  
           end process;
			-- Inphase data out
           process(clk2)  
           variable my_output_line : LINE;  
           variable input1: std_logic_vector(data_width-1 downto 0); 
	   
           begin  
                if falling_edge(clk2) then  
                     if ready ='1' then  
                          write(my_output_line, to_integer(signed(I_out)));  
                          writeline(re_output,my_output_line);  
                     end if;  
                end if;  
           end process;
		   			-- Inquadrature data out
           process(clk2)  
           variable my_output_line : LINE;  
           variable input1: std_logic_vector(data_width-1 downto 0); 
	   
           begin  
                if falling_edge(clk2) then  
                     if ready ='1' then  
                          write(my_output_line, to_integer(signed(Q_out)));  
                          writeline(im_output,my_output_line);  
                     end if;  
                end if;  
           end process;


end architecture rtl;


