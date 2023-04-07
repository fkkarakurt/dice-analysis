#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int main(int argc, char *argv[]);
int random_int(int a, int b);
void timestamp();

int main(int argc, char *argv[])

{
    char *commandFilename = "dice_commands.txt";
    FILE *command;
    char *dataFilename = "dice_data.txt";
    FILE *data;
    int die1;
    int die2;
    int i;
    int n;
    int seed;
    int score;
    int score_count[13];

    timestamp();
    printf("\n");
    printf("DICE SIMULATION:\n");
    printf("  C Vers.\n");
    printf("  A program that simulates N throws of two identical dice with the same characteristics.\n");

    if (1 < argc)
    {
        n = atoi(argv[1]);
    }
    else
    {
        printf("\n");
        printf("  How many times should both dice are thrown together: ");
        scanf("%d", &n);
    }

    seed = time(0);
    srand(seed);

    for (i = 0; i <= 12; i++)
    {
        score_count[i] = 0;
    }

    for (i = 1; i <= n; i++)
    {
        die1 = random_int(1, 6);
        die2 = random_int(1, 6);
        score = die1 + die2;
        score_count[score] = score_count[score] + 1;
    }

    data = fopen(dataFilename, "wt");
    for (score = 2; score <= 12; score++)
    {
        fprintf(data, "  %d  %d\n", score, score_count[score]);
    }
    fclose(data);
    printf("\n");
    printf("  Created the graphics data file \"%s\".\n", dataFilename);
    command = fopen(commandFilename, "wt");
    fprintf(command, "# %s\n", commandFilename);
    fprintf(command, "#\n");
    fprintf(command, "# @author Fatih Kucukkarakurt\n");
    fprintf(command, "# @url https://github.com/fkkarakurt/dice-analysis\n");
    fprintf(command, "# Usage:\n");
    fprintf(command, "#  gnuplot > laod '%s'\n", commandFilename);
    fprintf(command, "#\n");
    fprintf(command, "set term png\n");
    fprintf(command, "set output 'dice_output.png'\n");
    fprintf(command, "set xlabel 'Score'\n");
    fprintf(command, "set ylabel 'Frequency'\n");
    fprintf(command, "set title 'Score frequency for a pair of fair dice'\n");
    fprintf(command, "set grid\n");
    fprintf(command, "set style fill solid\n");
    fprintf(command, "set yrange [0:*]\n");
    fprintf(command, "set timestamp\n");
    fprintf(command, "plot 'dice_data.txt' using 1:2:(0.90):xtic(3) with boxes\n");
    fprintf(command, "quit\n");

    fclose(command);

    printf("  Created the graphics command file \"%s\".\n", commandFilename);
    printf("\n");
    printf("DICE SIMULATION:\n");
    printf("  Execution has ended.\n");
    printf("\n");
    timestamp();

    return 0;
}

int random_int(int a, int b)
{
    int range;
    int value;
    range = b - a + 1;

    value = a + rand() % range;

    return value;
}

void timestamp(void)
{
#define TIME_SIZE 40

    static char time_buffer[TIME_SIZE];
    const struct tm *tm;
    time_t now;

    now = time(NULL);
    tm = localtime(&now);

    strftime(time_buffer, TIME_SIZE, "%d %B %Y %I:%M:%S %p", tm);

    printf("%s\n", time_buffer);

    return;
#undef TIME_SIZE
}