----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2025 10:20:58
-- Design Name: 
-- Module Name: SORTIE_DCC - Behavioral
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

entity SORTIE_DCC is
  Port ( DCC_1      : in STD_LOGIC;  -- Signal de sortie du DCC_bit_1
         DCC_0      : in STD_LOGIC;  -- Signal de sortie du DCC_bit_0
         S : out STD_LOGIC);
end SORTIE_DCC;

architecture Behavioral of SORTIE_DCC is

begin

    S <= DCC_1 or DCC_0;

end Behavioral;
