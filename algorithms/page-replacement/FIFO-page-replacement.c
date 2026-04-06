#include <stdio.h>

int main() {
    int n, capacity;
    printf("Enter number of page references: ");
    scanf("%d", &n);

    printf("Enter frame capacity: ");
    scanf("%d", &capacity);

    int pages[n];
    printf("Enter page references (space-separated):\n");
    for(int i = 0; i < n; i++) {
        scanf("%d", &pages[i]);
    }

    int frames[capacity];
    for(int i = 0; i < capacity; i++) {
        frames[i] = -1;
    }

    int page_faults = 0;
    int rear = 0; // For FIFO, tracks the next position to replace

    printf("\nPage Replacement Process (FIFO):\n");
    printf("%-15s %-30s %-15s\n", "Page", "Frames", "Page Fault");
    printf("------------------------------------------------------------\n");

    for(int i = 0; i < n; i++) {
        // Check if page is already in frame
        int found = 0;
        for(int j = 0; j < capacity; j++) {
            if(frames[j] == pages[i]) {
                found = 1;
                break;
            }
        }

        if(!found) {
            // Replace page using FIFO
            if(frames[rear] != -1) {
                page_faults++;
            }
            frames[rear] = pages[i];
            rear = (rear + 1) % capacity;
            if(frames[rear] == -1) {
                rear = (rear + 1) % capacity;
            }
            if(frames[0] == -1) {
                rear = 0;
            }
        }

        printf("%-15d", pages[i]);
        printf("[ ");
        for(int j = 0; j < capacity; j++) {
            if(frames[j] != -1) {
                printf("%d ", frames[j]);
            }
        }
        printf("]");
        printf("%-15s\n", found ? "No" : "Yes");
    }

    printf("------------------------------------------------------------\n");
    printf("Total Page Faults: %d\n", page_faults);
    printf("Page Hit Rate: %.2f%%\n", ((float)(n - page_faults) / n) * 100);

    return 0;
}

