#include <stdio.h>

typedef struct {
    int pid;
    int arrival_time;
    int burst_time;
    int remaining_time;
} Process;

int main() {
    int n, time_quantum;
    printf("Enter number of processes: ");
    scanf("%d", &n);

    printf("Enter time quantum: ");
    scanf("%d", &time_quantum);

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
        proc[i].remaining_time = proc[i].burst_time;
    }

    // Round Robin Scheduling
    int current_time = 0;
    int completed = 0;
    int finished[n];
    for(int i = 0; i < n; i++) finished[i] = 0;

    while(completed < n) {
        for(int i = 0; i < n; i++) {
            if(finished[i] == 0 && proc[i].arrival_time <= current_time) {
                if(proc[i].remaining_time <= time_quantum) {
                    current_time += proc[i].remaining_time;
                    completion_time[i] = current_time;
                    turnaround_time[i] = completion_time[i] - proc[i].arrival_time;
                    waiting_time[i] = turnaround_time[i] - proc[i].burst_time;
                    proc[i].remaining_time = 0;
                    finished[i] = 1;
                    completed++;
                    total_tat += turnaround_time[i];
                    total_wt += waiting_time[i];
                } else {
                    current_time += time_quantum;
                    proc[i].remaining_time -= time_quantum;
                }
            }
        }

        // If no process is ready, move time forward
        if(completed < n) {
            int min_arrival = 10000;
            for(int i = 0; i < n; i++) {
                if(finished[i] == 0 && proc[i].arrival_time < min_arrival) {
                    min_arrival = proc[i].arrival_time;
                }
            }
            if(min_arrival > current_time) {
                current_time = min_arrival;
            }
        }
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
