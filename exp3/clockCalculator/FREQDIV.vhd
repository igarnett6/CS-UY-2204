----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:39:41 06/16/2016 
-- Design Name: 
-- Module Name:    FREQDIV - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FREQDIV is
    Port ( ONEHUNDREDMEGAHERTZ : in  STD_LOGIC;
	        RESET : in  STD_LOGIC;
           ONEHERTZ : out  STD_LOGIC;
			  EIGHTHUNDREDHERTZ : out  STD_LOGIC;
			  ONEHUNDREDHERTZ : out  STD_LOGIC;
			  FOURHERTZ : out  STD_LOGIC);
end FREQDIV;

architecture Behavioral of FREQDIV is

signal temp : STD_LOGIC ;
signal counter : INTEGER range 0 to 49999999 := 0 ;
signal temp1 : STD_LOGIC ;
signal counter1 : INTEGER range 0 to 62499 := 0 ;
signal temp2 : STD_LOGIC ;
signal counter2 : INTEGER range 0 to 499999 := 0 ;
signal temp3 : STD_LOGIC ;
signal counter3 : INTEGER range 0 to 12499999 := 0 ;
begin
process(ONEHUNDREDMEGAHERTZ, RESET)
begin

if (RESET='1') then 
temp <= '0' ;
counter <= 0 ; 
elsif (ONEHUNDREDMEGAHERTZ='1' and ONEHUNDREDMEGAHERTZ'event) then 
if(counter= 49999999) then 
temp <= NOT(temp) ;
counter <= 0 ;
else
counter <= counter + 1 ;
end if ;
end if ;
end process ;

process(ONEHUNDREDMEGAHERTZ, RESET)
begin

if (RESET='1') then 
temp1 <= '0' ;
counter1 <= 0 ; 
elsif (ONEHUNDREDMEGAHERTZ='1' and ONEHUNDREDMEGAHERTZ'event) then 
if(counter1= 62499) then 
temp1 <= NOT(temp1) ;
counter1 <= 0 ;
else
counter1 <= counter1 + 1 ;
end if ;
end if ;
end process ;

process(ONEHUNDREDMEGAHERTZ, RESET)
begin

if (RESET='1') then 
temp2 <= '0' ;
counter2 <= 0 ; 
elsif (ONEHUNDREDMEGAHERTZ='1' and ONEHUNDREDMEGAHERTZ'event) then 
if(counter2= 499999) then 
temp2 <= NOT(temp2) ;
counter2 <= 0 ;
else
counter2 <= counter2 + 1 ;
end if ;
end if ;
end process ;

process(ONEHUNDREDMEGAHERTZ, RESET)
begin

if (RESET='1') then 
temp3 <= '0' ;
counter3 <= 0 ; 
elsif (ONEHUNDREDMEGAHERTZ='1' and ONEHUNDREDMEGAHERTZ'event) then 
if(counter3= 12499999) then 
temp3 <= NOT(temp3) ;
counter3 <= 0 ;
else
counter3 <= counter3 + 1 ;
end if ;
end if ;
end process ;

ONEHERTZ <= temp ;
EIGHTHUNDREDHERTZ <= temp1 ;
ONEHUNDREDHERTZ <= temp2 ;
FOURHERTZ <= temp3 ;

end Behavioral;

