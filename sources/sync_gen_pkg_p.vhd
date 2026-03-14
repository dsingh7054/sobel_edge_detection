----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2026 07:25:24 PM
-- Design Name: 
-- Module Name: sync_gen_pkg - Behavioral
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

package sync_gen_pkg is

--count for hsync signal stages
constant HSYNC_ACTIVE             : integer := 1920;
constant HSYNC_FRONT_PORCH        : integer := 88;
constant HSYNC_SYNC               : integer := 44;
constant HSYNC_BACK_PORCH         : integer := 148;

constant VSYNC_ACTIVE             : integer := 1080;
constant VSYNC_FRONT_PORCH        : integer := 4;
constant VSYNC_SYNC               : integer := 5;
constant VSYNC_BACK_PORCH         : integer := 36;

end package sync_gen_pkg;
