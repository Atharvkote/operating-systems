#include <stdio.h>

typedef struct {
    int pid;
    int arrival_time;
    int burst_time;
} Process;

int main() {
    int n;
    printf("Enter number of processes: ");
    scanf("%d", &n);

    Process proc[n];
    int completion_time[n], turnaround_time[n], waiting_time[n];
    int total_tat = 0, total_wt = 0;

    // Input processes
    for(int i = 0; i < n; i++) {
        proc[i].pid = i + 1;
        printf("Enter arrival time for P%d: ", proc[i].pid);
        scanf("%d", &proc[i].arrival_time);
        printf("Enter burst time for P%d: ", proc[i].pid);
        scanf("%d", &proc[i].burst_time);
    }

    // Sort processes by arrival time
    for(int i = 0; i < n - 1; i++) {
        for(int j = 0; j < n - i - 1; j++) {
            if(proc[j].arrival_time > proc[j+1].arrival_time) {
                Process temp = proc[j];
                proc[j] = proc[j+1];
                proc[j+1] = temp;
            }
        }
    }

    // Calculate completion time, turnaround time, and waiting time
    int current_time = 0;
    for(int i = 0; i < n; i++) {
        if(current_time < proc[i].arrival_time) {
            current_time = proc[i].arrival_time;
        }
        current_time += proc[i].burst_time;
        completion_time[i] = current_time;
        turnaround_time[i] = completion_time[i] - proc[i].arrival_time;
        waiting_time[i] = turnaround_time[i] - proc[i].burst_time;

        total_tat += turnaround_time[i];
        total_wt += waiting_time[i];
    }

    // Display results
    printf("\n%-5s %-10s %-10s %-15s %-15s %-12s\n", 
           "PID", "Arrival", "Burst", "Completion", "Turnaround", "Waiting");
    printf("--------------------------------------------------------------\n");

    for(int i = 0; i < n; i++) {
        printf("%-5d %-10d %-10d %-15d %-15d %-12d\n",
               proc[i].pid, proc[i].arrival_time, proc[i].burst_time,
               completion_time[i], turnaround_time[i], waiting_time[i]);
    }

    printf("--------------------------------------------------------------\n");
    printf("Average Turnaround Time: %.2f\n", (float)total_tat / n);
    printf("Average Waiting Time: %.2f\n", (float)total_wt / n);

    return 0;
}

