----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/28/2026 06:10:06 PM
-- Design Name: 
-- Module Name: tb_rgb2gray - Behavioral
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
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity tb_rgb2gray is
--  Port ( );
end tb_rgb2gray;

architecture Behavioral of tb_rgb2gray is

-------------------------
--Constants
------------------------
constant CLK_PERIOD : time := 10 ns;

constant seed1 : positive := 1;
constant seed2 : positive := 1;


-------------------------
--Signal
------------------------
signal RBG_in     :  STD_LOGIC_VECTOR (23 downto 0);
signal pixelClkIn :  STD_LOGIC;
signal aresetn    :  STD_LOGIC;
signal gray       :  STD_LOGIC_VECTOR(7 downto 0);
signal gray_reg   :  STD_LOGIC_VECTOR(7 downto 0);


signal RBG_check  : REAL := 0.0;
signal RBG_check_flr : REAL := 0.0;
signal RBG_check_vec : std_logic_vector(7 downto 0);


--------------------------
--Component
------------------------
component rgb2gray is
    Port ( 
           RBG_in     : in STD_LOGIC_VECTOR (23 downto 0);
           pixelClkIn : in STD_LOGIC;
           aresetn    : in STD_LOGIC;
           gray       : out std_logic_vector(7 downto 0)
           );
end component;

begin

clk_gen: process begin
    pixelClkIn <= '1';
    wait for CLK_PERIOD/2;
    pixelClkIn <= '0';
    wait for CLK_PERIOD/2;
end process;


main_proc : process 
    variable seed1 : positive;
    variable seed2 : positive;

begin
    aresetn <= '0';
    seed1 := seed1;
    seed2 := seed2;

    wait for CLK_PERIOD*3;
    aresetn <= '1';
    wait for CLK_PERIOD;

    RBG_in <= std_logic_vector(to_unsigned(23, 8)) & std_logic_vector(to_unsigned(17, 8)) & std_logic_vector(to_unsigned(12, 8));

    wait for CLK_PERIOD*3;
    wait until falling_edge(pixelClkIn);
    gray_reg <= gray;

    RBG_check <= (23 * 0.2989)  + (17 * 0.1140) + (12 * 0.5870);
    wait for CLK_PERIOD;
    RBG_check_flr <= FLOOR(RBG_check);
    wait for CLK_PERIOD;
    RBG_check_vec <= std_logic_vector(to_unsigned(natural(RBG_check_flr), 8));
    wait for CLK_PERIOD;
    wait for CLK_PERIOD;
    assert RBG_check_vec = gray_reg report "Mismatch of gray out and RGB_check value. Gray: " & integer'image(to_integer(unsigned(gray_reg))) & " RGB_check: " & integer'image(to_integer(unsigned(RBG_check_vec))) severity failure;


    assert false report "Simulation Complete" severity failure;

end process;

DUT: rgb2gray  
port map( 
    RBG_in     => RBG_in     ,
    pixelClkIn => pixelClkIn ,
    aresetn    => aresetn    ,
    gray       => gray       
);

end Behavioral;
