----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 10:43:10 AM
-- Design Name: 
-- Module Name: ramArray - Behavioral
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

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity ramArray is
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
    RAM_8_OUT       : out std_logic_vector(7 downto 0);

    raddr0          : in std_logic_vector(10 downto 0);
    raddr1          : in std_logic_vector(10 downto 0);
    raddr2          : in std_logic_vector(10 downto 0);
    
    vsyncIn         : in std_logic;
    
    waddr_out      : out std_logic_vector(10 downto 0);
    wdata_out      : out std_logic_vector(7 downto 0);
    wen_out        : out std_logic;

    start_gen       : out std_logic
 );
end ramArray;

architecture Behavioral of ramArray is
--Constants
constant horz_dim : integer := 1920;
constant vert_dim : integer := 1080;


--Component Declarations
COMPONENT sdpram_8bit_x_1920
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
  );
END COMPONENT;


--Signals
type addr_t is array (0 to 2) of std_logic_vector(10 downto 0);
type we_t   is array (0 to 8) of std_logic;
type data_t is array (0 to 8) of std_logic_vector(7 downto 0);

signal clka         : STD_LOGIC;
signal ena          : STD_LOGIC;
signal clkb         : STD_LOGIC;
signal enb          : STD_LOGIC;
signal wea          : we_t := (others => '0');
signal waddr        : std_logic_vector(10 downto 0);
-- signal waddr        : addr_t := (others => (others => '0'));
signal dataIn       : std_logic_vector(7 downto 0);
-- signal dataIn       : data_t := (others => (others => '0'));
signal raddr        : addr_t := (others => (others => '0'));
signal dataOut      : data_t := (others => (others => '0'));

signal horz_idx     : integer := 0;
signal vert_idx     : integer := 0;
signal line_track   : integer := 0;

signal pixel_Count  : integer := 0;
signal start_gen_sig : std_logic;

signal vsyncIn0       : std_logic;
signal valid_internal : std_logic;


begin

--map raddr
raddr(0)<= raddr0;
raddr(1)<= raddr1;
raddr(2)<= raddr2;

--map RAM_OUT
RAM_0_OUT <= dataOut(0);
RAM_1_OUT <= dataOut(1);
RAM_2_OUT <= dataOut(2);
RAM_3_OUT <= dataOut(3);
RAM_4_OUT <= dataOut(4);
RAM_5_OUT <= dataOut(5);
RAM_6_OUT <= dataOut(6);
RAM_7_OUT <= dataOut(7);
RAM_8_OUT <= dataOut(8);


start_gen <= start_gen_sig;

    waddr_out      <= waddr;
    wdata_out      <= dataIn;
    wen_out        <= wea(0);



--VSync reg proc
vsync_reg_proc : process (clk, aresetp) begin
  if (aresetp = '1') then
    vsyncIn0 <= '0';
  elsif (rising_edge(clk)) then
    vsyncIn0 <= vsyncIn;
  end if;
end process;
  
--falling edge detect for vsync signal
falling_edge_detect : process (clk, aresetp) begin
  if (aresetp = '1') then
    valid_internal <= '0';
  elsif (rising_edge(clk)) then
    if (vsyncIn0 = '1' and vsyncIn = '0') then
      valid_internal <= '1';
    end if;
  end if;
end process;


--Start Gen Latch
start_gen_proc : process (clk, aresetp) begin
  if (aresetp = '1') then
    start_gen_sig <= '0';
  elsif (rising_edge(clk)) then
    if (start_gen_sig = '0' and vert_idx = 2 and horz_idx = 3) then
      start_gen_sig <= '1'; 
    end if;
  end if;
end process;

--Component Instantiation
sdpram_generate : for i in 0 to 8 generate 
begin
  sdpram_inst : sdpram_8bit_x_1920
  port map(
    clka  => clk,      
    ena => '1',
    wea => wea(i), 
    addra => waddr,
    dina => dataIn,
    clkb => clk,
    enb => '1',
    addrb => raddr(i mod 3),
    doutb => dataOut(i)
  );
end generate;

pixel_counter_proc : process(clk, aresetp) begin
    if (aresetp = '1') then
        horz_idx <= 0;
        vert_idx <= 0;
    elsif (rising_edge(clk)) then
        if (validIn = '1' and valid_internal = '1') then
          horz_idx <= horz_idx + 1;
          if (horz_idx = horz_dim-1) then
            horz_idx <= 0;
            if (vert_idx = vert_dim - 1) then
              vert_idx <= 0;
            else
              vert_idx <= vert_idx + 1;
            end if;
          end if;
        end if;
    end if;
end process;

--This process tracks the current line we are in via line_track.
--Line track increments by three every three vert_index increments and is used in MUX to decided which RAM the pixel is stored in. 
line_track_proc : process (clk, aresetp) begin
    if (aresetp = '1') then
        line_track <= 0;
    elsif (rising_edge(clk)) then
      if (validIn = '1' and valid_internal = '1') then
        if (vert_idx = (line_track+2) and horz_idx = 1919) then
          line_track <=  line_track + 3;
        elsif (line_track = 1080 and horz_idx = 1919) then
          line_track <= 0;
        end if;
      end if;
    end if;
end process;

--This is the waddr for the RAM_ARRAY, increments every three pixels and overflows when the last three pixels of a line are encountered. 
waddr_proc : process (clk, aresetp) begin
    if (aresetp = '1') then
      waddr <= (others => '0');
      pixel_Count <= 0;
    elsif (rising_edge(clk)) then
      if (validIn = '1' and valid_internal = '1') then
        if (unsigned(waddr) = 639 and pixel_Count = 3) then
          waddr <= (others => '0');
          pixel_Count <= 1;
        else
          if (pixel_count = 3) then
            waddr <= std_logic_vector(unsigned(waddr) + 1);
            pixel_count <= 1;
          else
              pixel_count <= pixel_count + 1;
          end if;
        end if;
      end if;
    end if;
end process;

pixel_ram_arbiter_proc : process (clk, aresetp) begin
    if (aresetp = '1') then
        wea <= (others => '0');
    elsif (rising_edge(clk)) then
      for i in 0 to 8 loop --always initialize to 0
          wea(i) <= '0';
      end loop;
        
      if (validIn = '1' and valid_internal = '1') then
        dataIn <= pixelIn;
        if (vert_idx = line_track) then
          if (horz_idx >= 0 and horz_idx < 1920) then
            wea(0) <= '1';
          end if;
          if (horz_idx >= 1 and horz_idx < 1920) then
            wea(1) <= '1';
          end if;
          if (horz_idx >= 2 and horz_idx < 1920) then
            wea(2) <= '1';
          end if;
        elsif (vert_idx = (line_track + 1)) then
          if (horz_idx >= 0 and horz_idx < 1920) then
            wea(3) <= '1';
          end if;
          if (horz_idx >= 1 and horz_idx < 1920) then
            wea(4) <= '1';
          end if;
          if (horz_idx >= 2 and horz_idx < 1920) then
            wea(5) <= '1';
          end if;
        elsif (vert_idx = (line_track + 2)) then
          if (horz_idx >= 0 and horz_idx < 1920) then
            wea(6) <= '1';
          end if;
          if (horz_idx >= 1 and horz_idx < 1920) then
            wea(7) <= '1';
          end if;
          if (horz_idx >= 2 and horz_idx < 1920) then
            wea(8) <= '1';
          end if;
        end if;
      end if;
    end if;
end process;

end Behavioral;
