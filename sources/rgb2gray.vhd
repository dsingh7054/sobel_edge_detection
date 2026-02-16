----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/19/2026 08:51:52 PM
-- Design Name: 
-- Module Name: rgb2gray - Behavioral
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

library UNISIM;
use UNISIM.vcomponents.all;

library UNIMACRO;
use unimacro.Vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.

entity rgb2gray is
    Port ( 
           aresetp    : in STD_LOGIC;
           pixelClkIn : in STD_LOGIC;

           RBG_in     : in STD_LOGIC_VECTOR (23 downto 0);
           hSync_in   : in STD_LOGIC;
           vSync_in   : in STD_LOGIC;
           vDe_in     : in STD_LOGIC;     
           
           gray       : out std_logic_vector(23 downto 0);
           hSync_out  : out STD_LOGIC;
           vSync_out  : out STD_LOGIC;
           vDe_out    : out STD_LOGIC 
           );
end rgb2gray;

architecture Behavioral of rgb2gray is

--Constants
constant red_weight     : std_logic_vector(17 downto 0) := b"00" & x"0132";  --0.2989
constant green_weight   : std_logic_vector(17 downto 0) := b"00" & x"0259";  --0.5870
constant blue_weight    : std_logic_vector(17 downto 0) := b"00" & x"0074";  --0.1140

--Signals
--signal aresetp   : std_logic;
signal red_out   : std_logic_vector(35 downto 0);
signal blue_out  : std_logic_vector(35 downto 0);
signal green_out : std_logic_vector(35 downto 0);
signal sum       : std_logic_vector(35 downto 0);

signal red_in   : std_logic_vector(17 downto 0);
signal blue_in  : std_logic_vector(17 downto 0);
signal green_in : std_logic_vector(17 downto 0);

signal hSync_reg : std_logic_vector(2 downto 0);  
signal vSync_reg : std_logic_vector(2 downto 0);  
signal vDe_reg   : std_logic_vector(2 downto 0);  


begin

--continuous assignments
sum <= std_logic_vector(unsigned(red_out) + unsigned(blue_out) + unsigned(green_out));
gray <= sum(27 downto 20) & sum(27 downto 20) & sum(27 downto 20); --only shove out whole 
hSync_out   <= hSync_reg(2);   
vSync_out   <= vSync_reg(2); 
vDe_out     <= vDe_reg(2);

--Fixed point 8.10
--after multipler
red_in <= RBG_in(23 downto 16) & b"0000000000";
blue_in <= RBG_in(15 downto 8) & b"0000000000";
green_in <= RBG_in(7 downto 0) & b"0000000000"; 

--aresetp <= not aresetn;

--procedural
pipeline_proc: process (pixelClkIn, aresetp) begin
    if (aresetp = '1') then
            hSync_reg(0) <= '0';
            vSync_reg(0) <= '0';
            vDe_reg(0) <= '0';
    elsif (rising_edge(pixelClkIn)) then
        hSync_reg(0) <= hSync_in;
        vSync_reg(0) <= vSync_in;
        vDe_reg(0) <= vDe_in;

        for i in 2 downto 1 loop
            hSync_reg(i) <= hSync_reg(i-1);
            vSync_reg(i) <= vSync_reg(i-1); 
            vDe_reg(i)   <= vDe_reg(i-1); 
        end loop;
    end if;
end process;

--Multiplier Instance
RED_MULT : MULT_MACRO
generic map (
DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
LATENCY => 3,           -- Desired clock cycle latency, 0-4
WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
WIDTH_B => 18)          -- Multiplier B-input bus width, 1-18
port map (
P => red_out,           -- Multiplier ouput bus, width determined by WIDTH_P generic 
A => red_weight,        -- Multiplier input A bus, width determined by WIDTH_A generic 
B =>  red_in,    -- Multiplier input B bus, width determined by WIDTH_B generic 
CE => '1',              -- 1-bit active high input clock enable
CLK => pixelClkIn,      -- 1-bit positive edge clock input
RST => aresetp          -- 1-bit input active high reset
);

BLUE_MULT : MULT_MACRO
generic map (
DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
LATENCY => 3,           -- Desired clock cycle latency, 0-4
WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
WIDTH_B => 18)          -- Multiplier B-input bus width, 1-18
port map (
P => blue_out,          -- Multiplier ouput bus, width determined by WIDTH_P generic 
A => blue_weight,       -- Multiplier input A bus, width determined by WIDTH_A generic 
B => blue_in,     -- Multiplier input B bus, width determined by WIDTH_B generic 
CE => '1',              -- 1-bit active high input clock enable
CLK => pixelClkIn,      -- 1-bit positive edge clock input
RST => aresetp          -- 1-bit input active high reset
);

GREEN_MULT : MULT_MACRO
generic map (
DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
LATENCY => 3,           -- Desired clock cycle latency, 0-4
WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
WIDTH_B => 18)          -- Multiplier B-input bus width, 1-18
port map (
P => green_out,     -- Multiplier ouput bus, width determined by WIDTH_P generic 
A => green_weight,     -- Multiplier input A bus, width determined by WIDTH_A generic 
B => green_in,    -- Multiplier input B bus, width determined by WIDTH_B generic 
CE => '1',   -- 1-bit active high input clock enable
CLK => pixelClkIn, -- 1-bit positive edge clock input
RST => aresetp  -- 1-bit input active high reset
);


end Behavioral;
