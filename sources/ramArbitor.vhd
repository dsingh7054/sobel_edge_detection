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

    raddr0_out_vec      :     out std_logic_vector (10 downto 0);
    raddr1_out_vec      :     out std_logic_vector (10 downto 0);
    raddr2_out_vec      :     out std_logic_vector (10 downto 0);

    RAM_0           :     in  std_logic_vector(7 downto 0);
    RAM_1           :     in  std_logic_vector(7 downto 0);
    RAM_2           :     in  std_logic_vector(7 downto 0);
    RAM_3           :     in  std_logic_vector(7 downto 0);
    RAM_4           :     in  std_logic_vector(7 downto 0);
    RAM_5           :     in  std_logic_vector(7 downto 0);
    RAM_6           :     in  std_logic_vector(7 downto 0);
    RAM_7           :     in  std_logic_vector(7 downto 0);
    RAM_8           :     in  std_logic_vector(7 downto 0);

    ramVector       :     out std_logic_vector (71 downto 0);

    hsync_in        :     in  std_logic;
    vsync_in        :     in  std_logic;

    vDe_out         :     out STD_LOGIC;
    hsync_out       :     out STD_LOGIC;
    vsync_out       :     out STD_LOGIC    
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

signal vDe_in_reg0 : std_logic;
signal vDe_in_reg1 : std_logic;
signal vDe_in_reg2 : std_logic;

signal hsync_vec   : std_logic_vector(2 downto 0);
signal vsync_vec   : std_logic_vector(2 downto 0);

signal raddr0_out      :      std_logic_vector (10 downto 0);
signal raddr1_out      :      std_logic_vector (10 downto 0);
signal raddr2_out      :      std_logic_vector (10 downto 0);


begin


raddr0_out_vec <= raddr0_out;
raddr1_out_vec <= raddr1_out;
raddr2_out_vec <= raddr2_out;


vDe_out  <= vDe_in_reg2;
hsync_out <= hsync_vec(2);
vsync_out <= vsync_vec(2);

--maintin positioning of pixel
pixel_tracker : process (clk, aresetp) begin
  if (aresetp = '1') then
    horz_idx <= 0;
    vert_idx <= 0;
  elsif (rising_edge(clk)) then
    if (vDe_in_reg2  = '1') then --if in active region
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

    vDe_in_reg0 <= vDe_in;
    vDe_in_reg1 <= vDe_in_reg0;
    vDe_in_reg2 <= vDe_in_reg1;

    hsync_vec(0) <= hsync_in;
    hsync_vec(1) <= hsync_vec(0);
    hsync_vec(2) <= hsync_vec(1);

    vsync_vec(0) <= vsync_in;
    vsync_vec(1) <= vsync_vec(0);
    vsync_vec(2) <= vsync_vec(1);    
  end if;
end process;


mux_proc : process (clk) begin
  if (aresetp = '1') then
    ramVector <= (others => '0');
  elsif (rising_edge(clk)) then
    if (horz_idx = 0) then --set1
      if (vert_idx = 0) then
        ramVector <= x"00000000" & RAM_4 & RAM_5 & x"00" & RAM_7 & RAM_8;
      elsif (vert_idx = vert_dim-1) then
        ramVector <= x"000000" &  RAM_3 & RAM_4 & x"00" & RAM_6 & RAM_7 & x"00";
      else
        ramVector <= x"000000" & RAM_3 & RAM_4 & RAM_5 & RAM_6 & RAM_7 & RAM_8;
      end if;
    
    elsif (horz_idx = horz_dim-1) then --set2
      if (vert_idx = 0) then
        ramVector <= x"00" & RAM_1 & RAM_2 & x"00" & RAM_4 & RAM_5 & x"000000";
      elsif (vert_idx = vert_dim-1) then
        ramVector <= RAM_0 & RAM_1 & x"00" & RAM_3 & RAM_4 & x"00000000";
      else
        ramVector <= RAM_0 & RAM_1 & RAM_2 & RAM_3 & RAM_4 & RAM_5 & x"000000";
      end if;

    else --set3
      if (vert_idx = 0) then
        ramVector <= x"00" & RAM_1 & RAM_2 & x"00" & RAM_4 & RAM_5 & x"00" & RAM_7 & RAM_8;
      elsif (vert_idx = vert_dim-1) then
        ramVector <= RAM_0 & RAM_1 & x"00" & RAM_3 & RAM_4 &  x"00" & RAM_6 & RAM_7 & x"00";
      else
        ramVector <= RAM_0 & RAM_1 & RAM_2 & RAM_3 & RAM_4 & RAM_5 & RAM_6 & RAM_7 & RAM_8;
      end if;
    end if;
  end if;
end process;



end Behavioral;
