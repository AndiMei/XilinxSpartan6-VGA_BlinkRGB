----------------------------------------------------------------------------------
-- Company: 		INFOGLOBAL TEKNOLOGI SEMESTA
-- Engineer: 		AMP (ANDI MEI PRASETYO ISWORO)
-- 
-- Create Date:    15:51:47 08/02/2022 
-- Design Name: 	
-- Module Name:    TopModule - Behavioral 
-- Project Name: 	Output RGB blink to VGA port
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 1
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

entity TopModule is
port(
	CLK			: in std_logic;	-- clock oscillator
	VGA_RED		: out std_logic_vector(7 downto 0);
	VGA_GREEN	: out std_logic_vector(7 downto 0);
	VGA_BLUE		: out std_logic_vector(7 downto 0);
	VGA_CLK		: out std_logic;
	VGA_HSYC		: out std_logic;
	VGA_VSYNC	: out std_logic
);
end TopModule;

architecture Behavioral of TopModule is
	signal clk40mhz	: std_logic;
	signal clk100mhz	: std_logic;
	
	component DigitalClockManager
	port(
		-- Clock in ports
		CLK_IN1           : in     std_logic;
		-- Clock out ports
		CLK_OUT1          : out    std_logic;
		CLK_OUT2          : out    std_logic
	);
	end component;

begin

	Inst_DigitalClockManager : DigitalClockManager
	port map(
		CLK_IN1 => CLK,		-- Clock in ports
		CLK_OUT1 => clk100mhz,	-- Clock out port 100Mhz
		CLK_OUT2 => clk40mhz		-- -- Clock out port 40Mhz
	);	

end Behavioral;

