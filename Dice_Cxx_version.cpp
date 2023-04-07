#include <cstdlib>
#include <iostream>
#include <fstream>
#include <ctime>

int main(int argc, char *argv[]);
int randomInt(int a, int b);
void timestamp();

int main(int argc, char *argv[])
{
    std::ofstream command;
    std::string commandFilename = "dice_commands.txt";
    std::ofstream data;
    std::string dataFilename = "dice_data.txt";

    int end1, end2, i, n, seed, value, valueCount[13];

    timestamp();

    std::cout << "\n";
    std::cout << "DICE SIMULATION:\n";
    std::cout << " C++ Vers.\n";
    std::cout << " A program that simulates N throws of two identical dice with the same characteristics.\n";

    if (1 < argc)
    {
        n = atoi(argv[1]);
    }
    else
    {
        std::cout << "\n";
        std::cout << " How many times should both dice are thrown together: ";
        std::cin >> n;
    }

    seed = time(0);
    srand(seed);

    for (i = 0; i <= 12; i++)
    {
        valueCount[i] = 0;
    }

    for (i = 1; i <= n; i++)
    {
        end1 = randomInt(1, 6);
        end2 = randomInt(1, 6);
        value = end1 + end2;
        valueCount[value] = valueCount[value] + 1;
    }

    data.open(dataFilename.c_str());
    for (value = 2; value <= 12; value++)
    {
        data << " " << value << " " << valueCount[value] << "\n";
    }
    data.close();
    std::cout << "\n";
    std::cout << " Created the graphics data file \"" << dataFilename << "\".\n";

    command.open(commandFilename.c_str());
    command << "# " << commandFilename << "\n";
    command << "#\n";
    command << "# @author Fatih Kucukkarakurt\n";
    command << "# @url https://github.com/fkkarakurt/dice-analysis\n";
    command << "# Usage: \n";
    command << "# \n";
    command << "# gnuplot > "
            << "'" << commandFilename << "'"
            << "\n";
    command << "#\n";
    command << "set term png\n";
    command << "set output 'dice_output.png'\n";
    command << "set xlabel 'Value'\n";
    command << "set ylabel 'Frequency'\n";
    command << "set title 'Score frequency for a pair of fair dice'\n";
    command << "set grid\n";
    command << "set style fill solid\n";
    command << "set yrange [0:*]\n";
    command << "set timestamp\n";
    command << "plot 'dice_data.txt' using 1:2:(0.90):xtic(3) with boxes\n";
    command << "quit\n";
    command.close();

    std::cout << " Created the graphics command file \"" << commandFilename << "\".\n";

    std::cout << "\n";
    std::cout << "DICE_SIMULATION: \n";
    std::cout << " Execution has ended.\n";
    std::cout << "\n";
    timestamp();

    return 0;
}

int randomInt(int x, int y)
{
    int range, point;

    range = y - x + 1;
    point = x + rand() % range;

    return point;
}

void timestamp()
{
#define TIMESIZE 400
    static char timeBuffer[TIMESIZE];
    const struct std::tm *tm_ptr;
    std::time_t now;

    now = std::time(NULL);
    tm_ptr = std::localtime(&now);

    std::strftime(timeBuffer, TIMESIZE, "%d %B %Y %I:%M:%S %p", tm_ptr);

    std::cout << timeBuffer << "\n";

    return;

#undef TIMESIZE
}