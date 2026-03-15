----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2026 11:41:15 AM
-- Design Name: 
-- Module Name: ramArbitor - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ramArbitor is
  Port ( 
    clk             :     in std_logic;
    aresetp         :     in std_logic;
    vDe_in          :     in std_logic;

    raddr0_out      :     out std_logic_vector (10 downto 0);
    raddr1_out      :     out std_logic_vector (10 downto 0);
    raddr2_out      :     out std_logic_vector (10 downto 0)

  );
end ramArbitor;

architecture Behavioral of ramArbitor is
--------------
--Constants
--------------
constant horz_dim : integer := 1920;
constant vert_dim : integer := 1080;

--------------
--signals
--------------
signal raddr : std_logic_vector (10 downto 0);
signal read_pixel_count : integer := 0;
signal horz_idx : integer := 0;
signal vert_idx : integer := 0;


begin

--maintin positioning of pixel
pixel_tracker : process (clk, aresetp) begin
  if (aresetp = '1') then
    horz_idx <= 0;
    vert_idx <= 0;
  elsif (rising_edge(clk)) then
    if (vDe_in  = '1') then --if in active region
      if (horz_idx < horz_dim-1) then
        horz_idx <= horz_idx + 1;
      else
        horz_idx <= 0;
        if (vert_idx < vert_dim - 1) then
          vert_idx <= vert_idx + 1;
        else
          vert_idx <= 0;
        end if;
      end if;
    end if;
  end if;
end process;

raddr_proc : process (clk, aresetp) begin
  if (aresetp = '1') then
    raddr <= (others => '0');
    read_pixel_count <= 0;
  elsif (rising_edge(clk)) then
    if (vDe_in = '1') then
      if (unsigned(raddr) = 639 and read_pixel_count = 2) then
        raddr <= (others => '0');
        read_pixel_count <= 0;
      elsif (read_pixel_count = 2) then
        raddr <= std_logic_vector(unsigned(raddr) + 1);
        read_pixel_count <= 0;
      else
        read_pixel_count <= read_pixel_count + 1;
      end if;
    end if;
  end if;
end process;

raddr_pipeline_proc : process (clk) begin
  if (rising_edge(clk)) then
    raddr0_out <= raddr;
    raddr1_out <= raddr0_out;
    raddr2_out <= raddr1_out;
  end if;
end process;




end Behavioral;
