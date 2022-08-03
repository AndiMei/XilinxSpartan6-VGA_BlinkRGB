----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:53 08/03/2022 
-- Design Name: 
-- Module Name:    VGA_Driver - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity VGA_Driver is
port(
	CLK_PIXEL	: in std_logic;
	IN_RGB		: in std_logic_vector(23 downto 0);
	OUT_RED		: out std_logic_vector(7 downto 0);
	OUT_GREEN	: out std_logic_vector(7 downto 0);
	OUT_BLUE		: out std_logic_vector(7 downto 0);
	OUT_CLK		: out std_logic;
	OUT_HSYNC	: out std_logic;
	OUT_VSYNC	: out std_logic;
	OUT_CNTH		: out integer;
	OUT_CNTV		: out integer;
	EOF			: out std_logic
);
end VGA_Driver;

architecture Behavioral of VGA_Driver is
	-- parameter of SVGA Signal 800 x 600 @ 60 Hz timing --
	constant h_wholeLine		: integer := 1056;
	signal h_cnt				: integer range 0 to h_wholeLine := 0;
	constant h_visibleArea	: integer := 800;
	constant h_syncPulse		: integer := 128;
	constant h_frontPorch	: integer := 40;
	constant h_backPorch		: integer := 88;
	constant v_wholeFrame	: integer := 628;
	signal v_cnt				: integer range 0 to v_wholeFrame := 0;
	constant v_visibleArea	: integer := 600;
	constant v_syncPulse		: integer := 4;
	constant v_frontPorch	: integer := 1;
	constant v_backPorch		: integer := 23;
	signal NCLK_PIXEL			: std_logic;
	
begin

	NCLK_PIXEL <= not CLK_PIXEL;
	
	inst_ODDR2 : ODDR2
	port map(
		C0 => CLK_PIXEL,
		C1 => NCLK_PIXEL,
		CE => '1',
		D0 => '0',
		D1 => '1',
		S	=> '0',
		R => '0',
		Q => OUT_CLK
	);
	
	-- assign port --
	OUT_HSYNC 	<= '0' when h_cnt > (h_visibleArea + h_frontPorch - 1) and h_cnt <= (h_visibleArea + h_frontPorch + h_syncPulse - 1) else '1';
	OUT_VSYNC 	<= '0' when v_cnt > (v_visibleArea + v_frontPorch - 1) and v_cnt <= (v_visibleArea + v_frontPorch + v_syncPulse - 1) else '1';
	
	OUT_RED		<= IN_RGB(7 downto 0) when (h_cnt < h_visibleArea) and (v_cnt < v_visibleArea) else X"00";
	OUT_GREEN	<= IN_RGB(23 downto 16) when (h_cnt < h_visibleArea) and (v_cnt < v_visibleArea) else X"00";
	OUT_BLUE		<= IN_RGB(15 downto 8) when (h_cnt < h_visibleArea) and (v_cnt < v_visibleArea) else X"00";
	
	OUT_CNTH		<= h_cnt;
	OUT_CNTV		<= v_cnt;
	
	EOF			<= '1' when h_cnt = h_wholeLine-1 and v_cnt = v_wholeFrame-1 else '0';
	
	
	-- counter H sync and V sync proccess --
	proc_cntSync : process(CLK_PIXEL)
	begin
		if CLK_PIXEL'event and CLK_PIXEL = '1' then
			if h_cnt = h_wholeLine-1 then
				h_cnt <= 0;
				if v_cnt = v_wholeFrame-1 then
					v_cnt <= 0;
				else
					v_cnt <= v_cnt + 1;
				end if;
			else
				h_cnt <= h_cnt + 1;
			end if;
		end if;
	end process proc_cntSync;

end Behavioral;

