----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2025 10:20:58
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
  Port ( CLK_100MHz : in STD_LOGIC;  -- Horloge principale
         RESET      : in STD_LOGIC;  -- Reset asynchrone
         Interrupteur	: in STD_LOGIC_VECTOR(7 downto 0);	-- Interrupteurs de la Carte
         S :  out STD_LOGIC
        );
end TOP;

architecture Behavioral of TOP is
-- Signaux pour le module TOP
    constant N : integer := 51; -- Taille du registre pour le test
    signal       Clk1MHz      :   STD_LOGIC;                            -- Horloge 1 MHz
    signal       Dcc_Bit      :   STD_LOGIC;                            -- Gestion du registre DCC
    signal       Fin_0        :   STD_LOGIC;
    signal       Fin_1        :   STD_LOGIC;
    signal       Fin_Reg      :   STD_LOGIC;
    signal       Empty        :   STD_LOGIC;
    signal       Fin_Tempo    :   STD_LOGIC;                                 -- Commande liée à la tempo
    signal       GO_0         :   STD_LOGIC;                            -- Commande de mise à 1 bit 0 GO_0
    signal       GO_1         :   STD_LOGIC;                            -- Commande de mise à 1 bit 1 GO_1
    signal       COM_REG      :   STD_LOGIC_VECTOR(1 downto 0);
    signal       Start_tempo  :   STD_LOGIC;
    signal       data_in      :   STD_LOGIC_VECTOR(N-1 downto 0);       -- Trame à charger
    signal       DCC_0        :   STD_LOGIC;                             -- Signal de sortie du DCC_bit_0
    signal       DCC_1        :   STD_LOGIC;                             -- Signal de sortie du DCC_bit_1

begin

Generateur : entity work.DCC_FRAME_GENERATOR
    Port Map (
            Interrupteur => Interrupteur,
            Trame_DCC    => data_in
            );
            
Registre_DCC : entity work.Registre_DCC
    Generic map (N => 51)
    Port Map (
            clk => CLK_100MHz,
            reset    => reset,
            load   => COM_REG(0),
            shift  => COM_REG(1),
            data_in    => data_in,
            Dcc_Bit   =>  Dcc_Bit,
            Empty  => Empty,
            Fin_Reg  => Fin_Reg
            );
            
MAE : entity work.MAE
        Port Map (
           Clk100M      => Clk_100MHz,
           Reset        => Reset,
           Dcc_Bit      => Dcc_Bit,
           Fin_0        => Fin_0,       
           Fin_1        => Fin_1,        
           Fin_Reg      => Fin_Reg,      
           Empty        => Empty,        
           Fin_Tempo    => Fin_Tempo,                         
           GO_0         => GO_0,         
           GO_1         => GO_1,      
           COM_REG      => COM_REG,    
           Start_tempo  => Start_tempo  
        );
        
Tempo :  entity work.COMPTEUR_TEMPO
        Port Map ( 
           Clk 			=> Clk_100MHz,		-- Horloge 100 MHz
           Reset 		=> RESET,		-- Reset Asynchrone
           Clk1M 		=> Clk1MHz,		-- Horloge 1 MHz
           Start_Tempo	=> Start_Tempo,		-- Commande de Démarrage de la Temporisation
           Fin_Tempo	=> Fin_Tempo		-- Drapeau de Fin de la Temporisation
		);

Diviseur : entity work.CLK_DIV 
        Port Map( 
           Reset 	=> RESET,		-- Reset Asynchrone
           Clk_In 	=> Clk_100MHz,		-- Horloge 100 MHz de la carte Nexys
           Clk_Out 	=> Clk1MHz          -- Horloge 1 MHz de sortie
           );	

DCC_bit_1 : entity work.DCC_Bit_1
        Port Map (
            CLK_100MHz => CLK_100MHz,
            CLK_1MHz   => Clk1MHz,
            RESET      => RESET,
            GO_1       => GO_1,
            FIN_1      => FIN_1,
            DCC_1      => DCC_1
        );

DCC_bit_0 : entity work.DCC_Bit_0
        Port Map (
            CLK_100MHz => CLK_100MHz,
            CLK_1MHz   => Clk1MHz,
            RESET      => RESET,
            GO_0       => GO_0,
            FIN_0      => FIN_0,
            DCC_0      => DCC_0
        );

Sortie_DCC : entity work.SORTIE_DCC
  Port Map ( DCC_1      => DCC_1,  -- Signal de sortie du DCC_bit_1
         DCC_0      => DCC_0,  -- Signal de sortie du DCC_bit_0
         S          => S
       );

end Behavioral;
