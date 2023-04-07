# Dice Analysis

Dice analysis is a simulation program designed for throwing two identical dice at the same time and analyzing the obtained values by summing them. Writes the obtained results to a TXT file, which can then be exported to a plot with Gnuplot.

It was designed to prepare datasets for a machine learning project, but you can use it for a variety of other purposes.

*It was prepared separately in **C**, **C++** and **Fortran** languages to be used in various projects. You can try the solution that suits you.*
## Usage/Examples

### Download and Open Project

```bash
git clone https://github.com/fkkarakurt/dice-analysis.git
cd dice-analysis
```

### For C

```bash
gcc ./Dice_C_version.c -o Test
./Test
```

### For C++

```bash
g++ ./Dice_Cxx_version.cpp -o Test
./Test
```

### For FORTRAN
```bash
gfortran ./Dice_Fortran_version.f90 -o Test
./Test
```
&nbsp;

---

&nbsp;

If all goes well, a text like the one below will greet you. Write here how many times you want the two dice to be thrown simultaneously:

```bash
DICE SIMULATION:
  <language> Vers.
  A program that simulates N throws of two identical dice with the same characteristics.

  How many times should both dice are thrown together: 20
```

Then the following files will be created in the directory where the project is located.

```bash
dice_commands.txt
dice_data.txt
```

In the `dice_data.txt` file, you can see the results of the dice thrown.

The first column is the sum of the two dice. The second column is how many times these dice reach this sum. For example:

```txt
  2  1      --> Sum of the dice: 2, This result happened 1 time.
  3  2      --> Sum of the dice: 3, This result happened 2 times.
  4  3      --> Sum of the dice: 4, This result happened 3 times.
  5  2      --> Sum of the dice: 2, This result happened 2 times.
  .  .      --> ...
  .  .      --> ...

```

### Graphical Usage with Gnuplot

After installing [Gnuplot](http://www.gnuplot.info/) on your system, enter your project folder either with the terminal or with the Gnuplot interface. Then use the following command:

```bash
load "dice_commands.txt"
```

You will now see a file named `dice_output.png` in your project folder. This file is a graphical representation of your results.

![dice analysis example usage with Gnuplot](/test_outputs/dice_output.png "Dice analysis output plotting example")

