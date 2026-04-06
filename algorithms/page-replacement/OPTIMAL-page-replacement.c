#include <stdio.h>

// Function to find the page that will be used farthest in the future
int findFarthest(int pages[], int n, int frames[], int capacity, int current_index) {
    int farthest = -1;
    int farthest_distance = -1;

    for(int i = 0; i < capacity; i++) {
        if(frames[i] == -1) {
            return i; // Return empty frame
        }

        // Find the farthest page in future
        int distance = n;
        for(int j = current_index + 1; j < n; j++) {
            if(pages[j] == frames[i]) {
                distance = j - current_index;
                break;
            }
        }

        if(distance > farthest_distance) {
            farthest_distance = distance;
            farthest = i;
        }
    }

    return farthest;
}

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

    printf("\nPage Replacement Process (OPTIMAL):\n");
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
            // Page not found, need to replace
            page_faults++;

            // Find the page to replace using optimal algorithm
            int replace_index = findFarthest(pages, n, frames, capacity, i);
            frames[replace_index] = pages[i];
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
