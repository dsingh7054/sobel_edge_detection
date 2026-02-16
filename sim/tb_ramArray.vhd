----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2026 02:27:12 PM
-- Design Name: 
-- Module Name: tb_ramArray - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity tb_ramArray is
--  Port ( );
end tb_ramArray;

architecture Behavioral of tb_ramArray is


--Constants
constant CLK_PERIOD : time := 10 ns;


--Component Declaration
component ramArray is
 Port ( 
    clk             : in std_logic;
    aresetp         : in std_logic;
    validIn         : in std_logic;
    pixelIn         : in std_logic_vector(7 downto 0);

    RAM_0_OUT       : out std_logic_vector(7 downto 0);
    RAM_1_OUT       : out std_logic_vector(7 downto 0);
    RAM_2_OUT       : out std_logic_vector(7 downto 0);
    RAM_3_OUT       : out std_logic_vector(7 downto 0);
    RAM_4_OUT       : out std_logic_vector(7 downto 0);
    RAM_5_OUT       : out std_logic_vector(7 downto 0);
    RAM_6_OUT       : out std_logic_vector(7 downto 0);
    RAM_7_OUT       : out std_logic_vector(7 downto 0);
    RAM_8_OUT       : out std_logic_vector(7 downto 0)
 );
end component;

--Signals

signal clk             :  std_logic;
signal aresetp         :  std_logic;
signal validIn         :  std_logic;
signal pixelIn         :  std_logic_vector(7 downto 0);
signal RAM_0_OUT       :  std_logic_vector(7 downto 0);
signal RAM_1_OUT       :  std_logic_vector(7 downto 0);
signal RAM_2_OUT       :  std_logic_vector(7 downto 0);
signal RAM_3_OUT       :  std_logic_vector(7 downto 0);
signal RAM_4_OUT       :  std_logic_vector(7 downto 0);
signal RAM_5_OUT       :  std_logic_vector(7 downto 0);
signal RAM_6_OUT       :  std_logic_vector(7 downto 0);
signal RAM_7_OUT       :  std_logic_vector(7 downto 0);
signal RAM_8_OUT       :  std_logic_vector(7 downto 0);

begin


clk_gen : process begin
clk <= '1';
wait for CLK_PERIOD/2;
clk <= '0';
wait for CLK_PERIOD/2;
end process;


test_proc : process begin
aresetp <= '1';
wait for CLK_PERIOD * 3;
aresetp <= '0';
wait for CLK_PERIOD;


wait for CLK_PERIOD*2073700;
assert false report "Simulation Complete" severity failure;

end process;



--DUT Instance
DUT :  ramArray 
 Port map ( 
    clk             => clk             ,
    aresetp         => aresetp         ,
    validIn         => validIn         ,
    pixelIn         => pixelIn         ,
    RAM_0_OUT       => RAM_0_OUT       ,
    RAM_1_OUT       => RAM_1_OUT       ,
    RAM_2_OUT       => RAM_2_OUT       ,
    RAM_3_OUT       => RAM_3_OUT       ,
    RAM_4_OUT       => RAM_4_OUT       ,
    RAM_5_OUT       => RAM_5_OUT       ,
    RAM_6_OUT       => RAM_6_OUT       ,
    RAM_7_OUT       => RAM_7_OUT       ,
    RAM_8_OUT       => RAM_8_OUT       
 );

end Behavioral;
