----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2026 02:29:00 PM
-- Design Name: 
-- Module Name: tb_sync_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
-- 
entity tb_sync_gen is
--  Port ( );
end tb_sync_gen;

architecture Behavioral of tb_sync_gen is

--Constants
constant CLK_PERIOD : time := 10 ns;

-----
--Component Declaration
--
component sync_gen is
    Port ( 
        clk             : in STD_LOGIC;
        reset           : in STD_LOGIC;
        start_gen       : in STD_LOGIC;
        hsync           : out STD_LOGIC;
        vsync           : out STD_LOGIC;
        vDe_out         : out STD_LOGIC
        );
end component;

signal clk             : STD_LOGIC;
signal reset           :  STD_LOGIC;
signal start_gen       :  STD_LOGIC;
signal hsync           :  STD_LOGIC;
signal vsync           :  STD_LOGIC;
signal vDe_out         :  STD_LOGIC;

begin

--DUT Instance
DUT : sync_gen 
 Port map ( 
    clk             =>  clk,       
    reset           =>  reset,     
    start_gen       =>  start_gen, 
    hsync           =>  hsync,     
    vsync           =>  vsync,     
    vDe_out         =>  vDe_out   
 );

--processes
clk_gen : process begin
    clk <= '1';
    wait for CLK_PERIOD/2;
    clk <= '0';
    wait for CLK_PERIOD/2;
end process;

test_proc : process begin
    reset <= '1';
    start_gen <= '0';
    wait for CLK_PERIOD * 3;
    reset <= '0';

    wait for CLK_PERIOD * 3;
    start_gen <= '1';

    wait for CLK_PERIOD * 4000000;
    assert false report "Simulation Complete" severity failure;
end process;

end Behavioral;
