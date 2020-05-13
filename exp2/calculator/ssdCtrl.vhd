--/////////////////////////////////////////////////////////////////////////////////
-- Company: Digilent Inc.
-- Engineer: Josh Sackos
-- 
-- Create Date:    07/11/2012
-- Module Name:    ssdCtrl 
-- Project Name: 	 PmodJSTK_Demo
-- Target Devices: Nexys3
-- Tool versions:  ISE 14.1
-- Description: This module interfaces the onboard seven segment display (SSD) on
--					 the Nexys3, and formats the data to be displayed.
--
--					 The DIN input is a binary number that gets converted to binary
--					 coded decimals, and is displayed as a 4 digit number on the SSD. The
--					 AN output bus drives the SSD's anodes controling the illumination
--					 of the 4 digits on the SSD.  The SEG output bus drives the cathodes
--					 on the SSD to display different characters.
--
-- Revision History: 
-- 						Revision 0.01 - File Created (Josh Sackos)
--/////////////////////////////////////////////////////////////////////////////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


--  ===================================================================================
--  								Define Module, Inputs and Outputs
--  ===================================================================================
entity ssdCtrl is
    Port ( CLK100MHZ : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           Err : in STD_LOGIC ;
           AE7, AE6, AE5, AE4, AE3, AE2, AE1, AE0 : in STD_LOGIC ;
           DIN31, DIN30, DIN29, DIN28, DIN27, DIN26, DIN25, DIN24, DIN23 , DIN22, DIN21, DIN20, DIN19, DIN18, DIN17, DIN16, DIN15, DIN14, DIN13, DIN12, DIN11, DIN10, DIN9, DIN8, DIN7, DIN6, DIN5, DIN4, DIN3, DIN2, DIN1, DIN0  : in  STD_LOGIC;
           AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0 : out  STD_LOGIC;
           SEGA, SEGB, SEGC, SEGD, SEGE, SEGF, SEGG : out  STD_LOGIC);
end ssdCtrl;

architecture Behavioral of ssdCtrl is

--  ===================================================================================
-- 							  					Components
--  ===================================================================================

		-- **********************************************
		-- 					Binary to BCD Converter
		-- **********************************************
--		component Binary_To_BCD
--			 Port ( CLK : in  STD_LOGIC;
--					  RST : in  STD_LOGIC;
--					  START : in STD_LOGIC;
--					  BIN : in  STD_LOGIC_VECTOR(9 downto 0);
--					  BCDOUT : inout STD_LOGIC_VECTOR(15 downto 0)
--			 );
--
--		end component;
		
		   component FREQDIV
               Port (ONEHUNDREDMEGAHERTZ : in STD_LOGIC ;
                     RESET : in STD_LOGIC ;
                     ONEHERTZ : out STD_LOGIC ;
                     EIGHTHUNDREDHERTZ : out STD_LOGIC ;
                     ONEHUNDREDHERTZ : out STD_LOGIC ;
                     FOURHERTZ : out STD_LOGIC
            ) ; 
	end component ;	
		
					  
--  ===================================================================================
-- 							  			Signals and Constants
--  ===================================================================================

			-- 1 kHz Clock Divider
			constant cntEndVal : STD_LOGIC_VECTOR(15 downto 0) := X"C350";
			signal clkCount : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
			signal DCLK : STD_LOGIC := '0';
			
            signal ONEHERTZ : STD_LOGIC ;
            signal ONEHUNDREDMEGAHERTZ : STD_LOGIC ;
            signal CLK800HZ : STD_LOGIC ;
            signal CLK100HZ : STD_LOGIC ;
            signal CLK4HZ : STD_LOGIC ;

            
			-- 2 Bit Counter
			signal CNT : STD_LOGIC_VECTOR(2 downto 0) := "000";

--			-- Binary to BCD
--			signal bcdData : STD_LOGIC_VECTOR(15 downto 0) := X"0000";

			-- Output Data Mux
			signal muxData : STD_LOGIC_VECTOR(3 downto 0);
			signal SEG : STD_LOGIC_VECTOR (6 downto 0) ;
			Signal AN : STD_LOGIC_VECTOR (7 downto 0) ;
			
--  ===================================================================================
-- 							  				Implementation
--  ===================================================================================
begin

			-------------------------------------------------
			--  	  		 Convert Binary to BCD
			------------------------------------------------
--			BtoBCD : Binary_To_BCD port map(
--					CLK=>CLK,
--					RST=>RST,
--					START=>DCLK,
--					BIN=>DIN,
--					BCDOUT=>bcdData
--			);
			
           Frequency_divider_for_ssd_Ctrl : FREQDIV  port map(
                     ONEHUNDREDMEGAHERTZ => CLK100MHZ,
                     RESET => RST,
                     ONEHERTZ => ONEHERTZ,
                     EIGHTHUNDREDHERTZ => CLK800HZ,
                     ONEHUNDREDHERTZ => CLK100HZ,
                     FOURHERTZ => CLK4HZ
            ); 




			-------------------------------------------------
			--					 Output Data Mux
			-- 		Select data to display on SSD
			-------------------------------------------------
			process (CNT, Err, DIN31, DIN30, DIN29, DIN28, DIN27, DIN26, DIN25, DIN24, DIN23, DIN22, DIN21, DIN20, DIN19, DIN18, DIN17, DIN16, DIN15, DIN14, DIN13, DIN12, DIN11, DIN10, DIN9, DIN8, DIN7, DIN6, DIN5, DIN4, DIN3, DIN2, DIN1, DIN0) begin
						 if (Err = '0') then    
							    case (CNT) is
									when "000" => muxData <= (DIN3, DIN2, DIN1, DIN0);
									when "001" => muxData <= (DIN7, DIN6, DIN5, DIN4);
									when "010" => muxData <= (DIN11,DIN10, DIN9, DIN8);
									when "011" => muxData <= (DIN15,DIN14, DIN13, DIN12) ;
									when "100" => muxData <= (DIN19, DIN18, DIN17, DIN16) ;
                                    when "101" => muxData <= (DIN23, DIN22, DIN21, DIN20);
                                    when "110" => muxData <= (DIN27, DIN26, DIN25, DIN24) ;
                                    when "111" => muxData <= (DIN31, DIN30, DIN29, DIN28) ;
									when others => muxData <= "0000";
							    end case;
						  else
						        case (CNT) is
                                    when "000" => muxData <= "0001" ;
                                    when "001" => muxData <= "0010" ;
                                    when "010" => muxData <= "0001" ;
                                    when "011" => muxData <= "0001" ;
                                    when "100" => muxData <= "0000" ;
                                    when others => muxData <= "0000";
                                end case ;
                           end if ;    
			end process ;
			
			
			
			--------------------------------
			--		   Segment Decoder
			-- Determines cathode pattern
			--   to display digit on SSD
			--------------------------------
			process(DCLK) begin		        
					if rising_edge(DCLK) then
					     if (Err = '0') then
							  case (muxData) is
									when X"0" => SEG <= "1000000";  -- 0
									when X"1" => SEG <= "1111001";  -- 1
									when X"2" => SEG <= "0100100";  -- 2
									when X"3" => SEG <= "0110000";  -- 3
									when X"4" => SEG <= "0011001";  -- 4
									when X"5" => SEG <= "0010010";  -- 5
									when X"6" => SEG <= "0000010";  -- 6
									when X"7" => SEG <= "1111000";  -- 7
									when X"8" => SEG <= "0000000";  -- 8
									when X"9" => SEG <= "0010000";  -- 9
									when X"A" => SEG <= "0001000";  -- A
									when X"B" => SEG <= "0000011";  -- B
									when X"C" => SEG <= "1000110";  -- C
									when X"D" => SEG <= "0100001";  -- D
									when X"E" => SEG <= "0000110";  -- E
									when X"F" => SEG <= "0001110";  -- F
									when others => SEG <= "1000000";
						       end case;
						    else
						        case (muxData) is
                                     when X"0" => SEG <= "0000110";  -- E
                                     when X"1" => SEG <= "0101111";  -- r
                                     when X"2" => SEG <= "0100011";  -- o
                                     when others => SEG <= "1000000"; 
						        end case ;
						     end if ;	     
						SEGA <= SEG(0);
                        SEGB <= SEG(1);
                        SEGC <= SEG(2);
                        SEGD <= SEG(3);
                        SEGE <= SEG(4);
                        SEGF <= SEG(5);
                        SEGG <= SEG(6);
					end if;
			end process;



			-----------------------------------
			--	  		  Anode Decoder
			--    Determines digit digit to
			--   illuminate for clock period
			-----------------------------------
			process(DCLK) begin
		     	  if rising_edge(DCLK) then
		     	          if (Err = '0') then
		     	                case (CNT) is
                                    when "000" => AN <= "11111110";  -- 0
                                    when "001" => AN <= "11111101";  -- 1
                                    when "010" => AN <= "11111011";  -- 2
                                    when "011" => AN <= "11110111";  -- 3
                                    when "100" => AN <= "11101111";  -- 4
                                    when "101" => AN <= "11011111";  -- 5
                                    when "110" => AN <= "10111111";  -- 6
                                    when "111" => AN <= "01111111";  -- 7
                                    when others => AN <= "11111111"; 
                                 end case ;
                            else
						    	case (CNT) is
									when "000" => AN <= "11111110";  -- 0
									when "001" => AN <= "11111101";  -- 1
									when "010" => AN <= "11111011";  -- 2
									when "011" => AN <= "11110111";  -- 3
									when "100" => AN <= "11101111";  -- 4
									when "101" => AN <= "11111111";  -- 5 : Off
									when "110" => AN <= "11111111";  -- 6 : Off
									when "111" => AN <= "11111111";  -- 7 : Off
									when others => AN <= "11111111"; 
						    	end case;
						   end if ;
							if (Err = '0') then if (AE0 = '1') then AN0 <= '1' ; else AN0 <= AN(0); end if ;
							               else AN0 <= (AN(0)or ONEHERTZ) ;  end if ;
                            if (Err = '0') then if (AE1 = '1') then AN1 <= '1' ; else AN1 <= AN(1); end if ; 
                                           else AN1 <= (AN(1)or ONEHERTZ) ;  end if ;
                            if (Err = '0') then if (AE2 = '1') then AN2 <= '1' ; else AN2 <= AN(2); end if ; 
                                           else AN2 <= (AN(2)or ONEHERTZ) ;  end if ;
                            if (Err = '0') then if (AE3 = '1') then AN3 <= '1' ; else AN3 <= AN(3); end if ;
                                           else AN3 <= (AN(3)or ONEHERTZ) ; end if ;
                            if (Err = '0') then if (AE4 = '1') then AN4 <= '1' ; else AN4 <= AN(4); end if ;
                                           else AN4 <= (AN(4)or ONEHERTZ) ; end if ;
                            if (AE5 = '1') then AN5 <= '1' ; else AN5 <= AN(5); end if ;
                            if (AE6 = '1') then AN6 <= '1' ; else AN6 <= AN(6); end if ;
                            if (AE7 = '1') then AN7 <= '1' ; else AN7 <= AN(7); end if ;
					end if;
			end process;
			

			--------------------------------
			--			2 Bit Counter
			--	 Used to select which diigt
			--	  is being illuminated, and
			--	selects data to be displayed
			--------------------------------
			process(DCLK) begin

					if rising_edge(DCLK) then
							CNT <= CNT + 1;
					end if;
					
			end process;
			
			--------------------------------
			--			1khz Clock Divider
			--  Timing for refreshing the
			--  			 SSD, etc.
			--------------------------------
			process(CLK100MHZ) begin

					if rising_edge(CLK100MHZ) then
							if(clkCount = cntEndVal) then
									DCLK <= '1';
									clkCount <= X"0000";
							else
									DCLK <= '0';
									clkCount <= clkCount + 1;
							end if;
					end if;
					
			end process;

end Behavioral;

