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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TopModule is
port(
	CLK			: in std_logic;	-- clock oscillator
	VGA_RED		: out std_logic_vector(7 downto 0);
	VGA_GREEN	: out std_logic_vector(7 downto 0);
	VGA_BLUE		: out std_logic_vector(7 downto 0);
	VGA_CLK		: out std_logic;
	VGA_HSYNC	: out std_logic;
	VGA_VSYNC	: out std_logic
);
end TopModule;

architecture Behavioral of TopModule is
	signal clk40mhz	: std_logic;
	signal clk100mhz	: std_logic;

	signal colorPixel		: std_logic_vector(23 downto 0);	
	signal colorPixelBuf		: std_logic_vector(23 downto 0);	
	signal vga_hcnt		: integer;
	signal vga_vcnt		: integer;
	signal vga_eof			: std_logic;
	
	signal writeDisplay	: std_logic;
	
	-- Digital Clock Manager --
	component DigitalClockManager
	port(
		-- Clock in ports
		CLK_IN1           : in     std_logic;
		-- Clock out ports
		CLK_OUT1          : out    std_logic;
		CLK_OUT2          : out    std_logic
	);
	end component;
	
	-- VGA Driver --
	component VGA_Driver
	port(
		CLK_PIXEL 	: in std_logic;
		IN_RGB 		: in std_logic_vector(23 downto 0);          
		OUT_RED 		: out std_logic_vector(7 downto 0);
		OUT_GREEN 	: out std_logic_vector(7 downto 0);
		OUT_BLUE 	: out std_logic_vector(7 downto 0);
		OUT_CLK 		: out std_logic;
		OUT_HSYNC 	: out std_logic;
		OUT_VSYNC	: out std_logic;
		OUT_CNTH 	: out integer;
		OUT_CNTV 	: out integer;
		EOF 			: out std_logic
	);
	end component;

---------------------------------------------------------------------------
--                       			BEGIN		 										 --	
---------------------------------------------------------------------------
begin

	Inst_DigitalClockManager : DigitalClockManager
	port map(
		CLK_IN1 => CLK,			-- Clock in ports
		CLK_OUT1 => clk100mhz,	-- Clock out port 100Mhz
		CLK_OUT2 => clk40mhz		-- Clock out port 40Mhz
	);	
	
	Inst_VGA_Driver: VGA_Driver PORT MAP(
		CLK_PIXEL	 	=> clk40Mhz,
		IN_RGB 			=> colorPixel,
		OUT_RED  		=> VGA_RED,
		OUT_GREEN 		=> VGA_GREEN,
		OUT_BLUE 		=> VGA_BLUE,
		OUT_CLK 			=> VGA_CLK,
		OUT_HSYNC 		=> VGA_HSYNC,
		OUT_VSYNC 		=> VGA_VSYNC,
		OUT_CNTH 		=> vga_hcnt,
		OUT_CNTV 		=> vga_vcnt,
		EOF 				=> vga_eof		
	);
	
	proc_colorGen : process(clk100mhz)
		variable cnt, cntColor : integer := 0;
		constant maxCnt	: integer := 100E6;
	begin
		if clk100mhz'event and clk100mhz = '1' then
			if cnt = maxCnt - 1 then
				cnt := 0;
				-- color counter
				if cntColor = 2 then
					cntColor := 0;
				else
					cntColor := cntColor + 1;
				end if;
				-- color change
				if cntColor = 2 then
					colorPixelBuf <= X"0000FF";
				elsif cntColor = 1 then
					colorPixelBuf <= X"00FF00";
				elsif cntColor = 0 then
					colorPixelBuf <= X"FF0000";
				else
					colorPixelBuf <= X"FFFFFF";
				end if;
			else
				cnt := cnt + 1;
			end if;
		end if;
	end process proc_colorGen;
	
--	colorPixel  <= colorPixelBuf when vga_eof = '0' else X"FFFFFF"; 
	process(clk40mhz)
	begin
		if clk40mhz'event and clk40mhz = '1' then
			if vga_eof = '1' then
				colorPixel <= colorPixelBuf;
			end if;
		end if;
	end process;
	
end Behavioral;

