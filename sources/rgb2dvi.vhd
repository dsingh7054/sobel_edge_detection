----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/19/2026 08:51:52 PM
-- Design Name: 
-- Module Name: rgb2dvi - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rgb2dvi is
    Port ( 
           RBG_in : in STD_LOGIC_VECTOR (23 downto 0);
           pixelClkIn : in STD_LOGIC;
           aresetn    : in STD_LOGIC;
           gray       : out std_logic_vector(7 downto 0)
           );
end rgb2dvi;

architecture Behavioral of rgb2dvi is

begin





end Behavioral;
