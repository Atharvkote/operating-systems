#include <stdio.h>
#include <limits.h>

#define MAX 50

// Function to print frames
void printFrames(int frames[], int f) {
    for (int i = 0; i < f; i++) {
        if (frames[i] == -1)
            printf("- ");
        else
            printf("%d ", frames[i]);
    }
    printf("\n");
}

// FIFO Algorithm
void FIFO(int pages[], int n, int f) {
    int frames[MAX], index = 0, faults = 0;

    for (int i = 0; i < f; i++)
        frames[i] = -1;

    printf("\nFIFO Page Replacement:\n");

    for (int i = 0; i < n; i++) {
        int found = 0;

        for (int j = 0; j < f; j++) {
            if (frames[j] == pages[i]) {
                found = 1;
                break;
            }
        }

        if (!found) {
            frames[index] = pages[i];
            index = (index + 1) % f;
            faults++;
        }

        printFrames(frames, f);
    }

    printf("Total Page Faults = %d\n", faults);
}

// LRU Algorithm
void LRU(int pages[], int n, int f) {
    int frames[MAX], time[MAX];
    int faults = 0, counter = 0;

    for (int i = 0; i < f; i++) {
        frames[i] = -1;
        time[i] = 0;
    }

    printf("\nLRU Page Replacement:\n");

    for (int i = 0; i < n; i++) {
        int found = 0;

        for (int j = 0; j < f; j++) {
            if (frames[j] == pages[i]) {
                counter++;
                time[j] = counter;
                found = 1;
                break;
            }
        }

        if (!found) {
            int min = INT_MAX, pos = 0;

            for (int j = 0; j < f; j++) {
                if (time[j] < min) {
                    min = time[j];
                    pos = j;
                }
            }

            counter++;
            frames[pos] = pages[i];
            time[pos] = counter;
            faults++;
        }

        printFrames(frames, f);
    }

    printf("Total Page Faults = %d\n", faults);
}

// Optimal Algorithm
void Optimal(int pages[], int n, int f) {
    int frames[MAX], faults = 0;

    for (int i = 0; i < f; i++)
        frames[i] = -1;

    printf("\nOptimal Page Replacement:\n");

    for (int i = 0; i < n; i++) {
        int found = 0;

        for (int j = 0; j < f; j++) {
            if (frames[j] == pages[i]) {
                found = 1;
                break;
            }
        }

        if (!found) {
            int pos = -1, farthest = i;

            for (int j = 0; j < f; j++) {
                int k;
                for (k = i + 1; k < n; k++) {
                    if (frames[j] == pages[k])
                        break;
                }

                if (k == n) {
                    pos = j;
                    break;
                }

                if (k > farthest) {
                    farthest = k;
                    pos = j;
                }
            }

            if (pos == -1)
                pos = 0;

            frames[pos] = pages[i];
            faults++;
        }

        printFrames(frames, f);
    }

    printf("Total Page Faults = %d\n", faults);
}

// Main Function with Switch Case
int main() {
    int pages[MAX], n, f, choice;

    printf("Enter number of pages: ");
    scanf("%d", &n);

    printf("Enter page reference string:\n");
    for (int i = 0; i < n; i++)
        scanf("%d", &pages[i]);

    printf("Enter number of frames: ");
    scanf("%d", &f);

    do {
        printf("\n--- Page Replacement Menu ---\n");
        printf("1. FIFO\n");
        printf("2. LRU\n");
        printf("3. Optimal\n");
        printf("4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                FIFO(pages, n, f);
                break;
            case 2:
                LRU(pages, n, f);
                break;
            case 3:
                Optimal(pages, n, f);
                break;
            case 4:
                printf("Exiting...\n");
                break;
            default:
                printf("Invalid choice!\n");
        }

    } while (choice != 4);

    return 0;
}