# phaseDiagramTVL
***Author: Brenton Bongcaron***

**Brief Description:**
Generate a T vs. liquid/vapor mole fraction of component A (in a binary mixture of A+B) phase diagram, given user-inputted names of the components and the pressure P of the system.

**Details:**  
This program uses Antoine's Equation coefficients from zyBooks 14:155:201 Table 9.10.1 and a user inputted constant pressure P through a GUI   
to calculate the saturation temperature at P. These points serve to define the upper and lower bound of the range of temperature values  
this VL phase diagram exists in. The vapor and liquid phase boundaries are defined by 100 data points each and are calculated by the following algorithm:
  
For each temperature in a linearly spaced array of 100 elements:  
  - calculate the saturation pressure @ the current temperature for both components of the binary mixture  
  - using the bubble point pressure equation derived from the summation of Rauolt's Law for each component, calculate the liquid mole fractions    
  - using a rearrangment of Rauolt's Law, calculate the vapor mole frations  
      
  A figure is then generated by plotting liquid and vapor mole fractions each against the linearly spaced array of temperatures.  
    
**Error Handling:**  
Each component has its own range of temperatures for which Antoine's Equation will be accurate. Implementation of this range will be done in the future.  

**Equations Used:**  
Raoult's Law : yP = xp*  
  - y = vapor mole fraction of component i  
  - P = total pressure of system  
  - x = liquid mole fraction of component i  
  - p* = saturation pressure @T for component i  
  
Antoine's Equation : log10(p*) = A - (B / (T + C))  
  - A, B & C are coefficents according to the component  
  - p* = saturation pressure @T for component i  
  - T = temperature  
  - *Note* : Antoine's Equation can also be a function of pressure used to find saturation temperature (t*)  
  
Bubble Point Pressure Equation : P = Σ(xp*)  
  - P = total pressure of system
  - x = liquid mole fraction of component i
  - p* = saturation pressure @T for component i
  
