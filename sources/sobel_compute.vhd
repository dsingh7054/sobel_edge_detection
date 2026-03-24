----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2026 08:32:01 PM
-- Design Name: 
-- Module Name: sobel_compute - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sobel_compute is
    Port ( 
           clk : in STD_LOGIC;
           aresetp : in STD_LOGIC;
           vDe_in : in STD_LOGIC;
           hsync_IN  : IN STD_LOGIC;
           vsync_IN  : IN STD_LOGIC;           
           ramVector_in : in STD_LOGIC_VECTOR (71 downto 0);

           rgbVector : out STD_LOGIC_VECTOR (23 downto 0);
           vDe_out : out STD_LOGIC;
           hsync_out : out STD_LOGIC;
           vsync_out : out STD_LOGIC
           );
end sobel_compute;

architecture Behavioral of sobel_compute is


alias a : std_logic_vector(7 downto 0) is ramVector_in(71 downto 64);
alias b : std_logic_vector(7 downto 0) is ramVector_in(63 downto 56);
alias c : std_logic_vector(7 downto 0) is ramVector_in(55 downto 48);
alias d : std_logic_vector(7 downto 0) is ramVector_in(47 downto 40);
alias e : std_logic_vector(7 downto 0) is ramVector_in(39 downto 32);
alias f : std_logic_vector(7 downto 0) is ramVector_in(31 downto 24);
alias g : std_logic_vector(7 downto 0) is ramVector_in(23 downto 16);
alias h : std_logic_vector(7 downto 0) is ramVector_in(15 downto 8);
alias i : std_logic_vector(7 downto 0) is ramVector_in(7 downto 0);

begin

sobel_compute_proc : process (clk, aresetp) 
    variable rgb_vect_int : std_logic_vector(7 downto 0) := (others => '0');
begin
    
    if (aresetp = '1') then
        rgbVector <= (others => '0');
    elsif (rising_edge(clk)) then
        if (vDe_in = '1') then
            rgb_vect_int := std_logic_vector(abs((signed(a) + signed(b(7 downto 2) & "00") + signed(c)) - (signed(g) + signed(h(7 downto 2) & "00") + signed(i))) + abs((signed(c) + signed(f(7 downto 2) & "00") + signed(i)) - (signed(a) + signed(f(7 downto 2) & "00") + signed(g))));
            rgbVector <= rgb_vect_int & rgb_vect_int & rgb_vect_int;
        end if;
    end if;
end process;

sync_proc : process (clk) begin
    if (rising_edge(clk)) then
        vDe_out   <= vDe_in;
        hsync_out <= hsync_IN;
        vsync_out <= vsync_IN;
    end if;
end process;


end Behavioral;
