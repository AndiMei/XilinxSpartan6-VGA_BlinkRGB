--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:21:38 08/03/2022
-- Design Name:   
-- Module Name:   D:/AMP/Research and Development/FPGA/XilinxSpartan6-VGA_BlinkRGB/TB_TopModule.vhd
-- Project Name:  XilinxSpartan6-VGA_BlinkRGB
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TopModule
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_TopModule IS
END TB_TopModule;
 
ARCHITECTURE behavior OF TB_TopModule IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TopModule
    PORT(
         CLK : IN  std_logic;
         VGA_RED : OUT  std_logic_vector(7 downto 0);
         VGA_GREEN : OUT  std_logic_vector(7 downto 0);
         VGA_BLUE : OUT  std_logic_vector(7 downto 0);
         VGA_CLK : OUT  std_logic;
         VGA_HSYNC : OUT  std_logic;
         VGA_VSYNC : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';

 	--Outputs
   signal VGA_RED : std_logic_vector(7 downto 0);
   signal VGA_GREEN : std_logic_vector(7 downto 0);
   signal VGA_BLUE : std_logic_vector(7 downto 0);
   signal VGA_CLK : std_logic;
   signal VGA_HSYNC : std_logic;
   signal VGA_VSYNC : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
   constant VGA_CLK_period : time := 25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TopModule PORT MAP (
          CLK => CLK,
          VGA_RED => VGA_RED,
          VGA_GREEN => VGA_GREEN,
          VGA_BLUE => VGA_BLUE,
          VGA_CLK => VGA_CLK,
          VGA_HSYNC => VGA_HSYNC,
          VGA_VSYNC => VGA_VSYNC
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
--   VGA_CLK_process :process
--   begin
--		VGA_CLK <= '0';
--		wait for VGA_CLK_period/2;
--		VGA_CLK <= '1';
--		wait for VGA_CLK_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
