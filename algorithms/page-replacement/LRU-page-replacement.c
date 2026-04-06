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
    int time_counter[capacity]; // To track last used time
    for(int i = 0; i < capacity; i++) {
        frames[i] = -1;
        time_counter[i] = 0;
    }

    int page_faults = 0;
    int current_time = 0;

    printf("\nPage Replacement Process (LRU):\n");
    printf("%-15s %-30s %-15s\n", "Page", "Frames", "Page Fault");
    printf("------------------------------------------------------------\n");

    for(int i = 0; i < n; i++) {
        current_time++;
        // Check if page is already in frame
        int found = -1;
        for(int j = 0; j < capacity; j++) {
            if(frames[j] == pages[i]) {
                found = j;
                break;
            }
        }

        if(found != -1) {
            // Page found, update its time
            time_counter[found] = current_time;
        } else {
            // Page not found, need to replace
            page_faults++;

            // Find empty frame
            int empty = -1;
            for(int j = 0; j < capacity; j++) {
                if(frames[j] == -1) {
                    empty = j;
                    break;
                }
            }

            if(empty != -1) {
                // There's an empty frame
                frames[empty] = pages[i];
                time_counter[empty] = current_time;
            } else {
                // No empty frame, replace LRU page
                int lru_index = 0;
                int min_time = time_counter[0];
                for(int j = 1; j < capacity; j++) {
                    if(time_counter[j] < min_time) {
                        min_time = time_counter[j];
                        lru_index = j;
                    }
                }
                frames[lru_index] = pages[i];
                time_counter[lru_index] = current_time;
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
        printf("%-15s\n", found != -1 ? "No" : "Yes");
    }

    printf("------------------------------------------------------------\n");
    printf("Total Page Faults: %d\n", page_faults);
    printf("Page Hit Rate: %.2f%%\n", ((float)(n - page_faults) / n) * 100);

    return 0;
}
