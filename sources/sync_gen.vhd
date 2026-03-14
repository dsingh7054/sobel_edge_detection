----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2026 07:08:03 PM
-- Design Name: 
-- Module Name: sync_gen - Behavioral
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
use work.sync_gen_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_gen is
    Port ( 
        clk             : in STD_LOGIC;
        reset           : in STD_LOGIC;
        start_gen       : in STD_LOGIC;
        hsync           : out STD_LOGIC;
        vsync           : out STD_LOGIC;
        vDe_out         : out STD_LOGIC
        );
end sync_gen;

architecture Behavioral of sync_gen is

type sync_state_t is (IDLE, ACTIVE, FRONT_PORCH, SYNC, BACK_PORCH);
signal hsync_state : sync_state_t := IDLE;
signal vsync_state : sync_state_t := IDLE;

signal hsync_cycle_counter              : integer := 0;
signal vsync_cycle_counter              : integer := 0;
signal hsync_active_sig                 : std_logic;
signal vsync_active_sig                 : std_logic;

signal increment_vsync                  : std_logic;
begin


vDe_out <= vsync_active_sig AND hsync_active_sig;

hsync_proc : process (clk) begin
    if (reset = '1') then
        hsync_state <= IDLE;
        hsync_cycle_counter <= 0;
        hsync_active_sig <= '0';
        hsync <= '0';

        vsync <= '0';
        vsync_active_sig <= '0';
        vsync_state <= IDLE;
        vsync_cycle_counter <= 0;

    elsif (rising_edge(clk)) then
        case (hsync_state) is
            when IDLE =>
                --upon start gen, move to active. activate hsync.
                if (start_gen = '1') then
                    hsync_state <= ACTIVE;
                    hsync_active_sig <= '1';
                    hsync <= '1';
                end if;
            when ACTIVE =>
                --keep active_sig indicator high
                if (hsync_cycle_counter < HSYNC_ACTIVE-1) then
                    hsync_cycle_counter <= hsync_cycle_counter + 1;
                else
                    hsync_cycle_counter <= 0;
                    hsync_state <= FRONT_PORCH;
                    hsync_active_sig <= '0';
                end if; 
            when FRONT_PORCH =>
                if (hsync_cycle_counter < HSYNC_FRONT_PORCH-1) then
                    hsync_cycle_counter <= hsync_cycle_counter + 1;
                else
                    hsync_cycle_counter <= 0;
                    hsync_state <= SYNC;
                    hsync <= '0';
                end if;
            when SYNC =>
                if (hsync_cycle_counter < HSYNC_SYNC-1) then
                    hsync_cycle_counter <= hsync_cycle_counter + 1;
                else
                    hsync_cycle_counter <= 0;
                    hsync_state <= BACK_PORCH;
                    hsync <= '1';
                end if;
            when BACK_PORCH =>
                if (hsync_cycle_counter < HSYNC_BACK_PORCH-1) then
                    hsync_cycle_counter <= hsync_cycle_counter + 1;
                else
                    hsync_cycle_counter <= 0;
                    hsync_state <= ACTIVE;
                    hsync_active_sig <= '1';
                 end if;            

            when others => 
        end case;

        case (vsync_state) is
            when IDLE =>
                if (start_gen = '1') then
                    vsync_state <= ACTIVE;
                    vsync <= '1';
                    vsync_active_sig <= '1';
                end if;
            when ACTIVE =>
                if (increment_vsync = '1') then
                    if (vsync_cycle_counter < VSYNC_ACTIVE-1) then
                        vsync_cycle_counter <= vsync_cycle_counter + 1;
                    else
                        vsync_cycle_counter <= 0;
                        vsync_state <= FRONT_PORCH;
                        vsync_active_sig <= '0';
                    end if;
                end if;
            when FRONT_PORCH =>
                if (increment_vsync = '1') then
                    if (vsync_cycle_counter < VSYNC_FRONT_PORCH-1) then
                        vsync_cycle_counter <= vsync_cycle_counter + 1;
                    else
                        vsync_cycle_counter <= 0;
                        vsync_state <= SYNC;
                        vsync <= '0';
                    end if;
                end if;         
            when SYNC =>
                if (increment_vsync = '1') then
                    if (vsync_cycle_counter < VSYNC_SYNC-1) then
                        vsync_cycle_counter <= vsync_cycle_counter + 1;
                    else
                        vsync_cycle_counter <= 0;
                        vsync_state <= BACK_PORCH;
                        vsync <= '1';
                    end if;
                end if;
            when BACK_PORCH =>
                if (increment_vsync = '1') then
                    if (vsync_cycle_counter < VSYNC_BACK_PORCH-1) then
                        vsync_cycle_counter <= vsync_cycle_counter + 1;
                    else
                        vsync_cycle_counter <= 0;
                        vsync_state <= ACTIVE;
                        vsync_active_sig <= '1';
                    end if;
                end if;
            when others =>
        end case;
    end if;
end process;


vsyn_incr_controller : process (clk) begin
    if (reset = '1') then
        increment_vsync <= '0';
    elsif (rising_edge(clk)) then
        increment_vsync <= '0';
        if (hsync_state = BACK_PORCH) then
            if (hsync_cycle_counter = HSYNC_BACK_PORCH-2) then
                increment_vsync <= '1';
            end if;
        end if;       
    end if;
end process;

end Behavioral;
