Time limit: 5000ms
Memory limit: 256mb

Description:
Given an unsorted array of N elements, output the sorted array.

-------------------------Copy the following code, complete it and submit-------------------------

/*
I, <Your Full Name>, am submitting the assignment for
an individual project.
I declare that the assignment here submitted is original except for
source material explicitly acknowledged, the piece of work, or a part
of the piece of work has not been submitted for more than one purpose
(i.e. to satisfy the requirements in two different courses) without
declaration. I also acknowledge that I am aware of University policy
and regulations on honesty in academic work, and of the disciplinary
guidelines and procedures applicable to breaches of such policy and
regulations, as contained in the University website
http://www.cuhk.edu.hk/policy/academichonesty/.
It is also understood that assignments without a properly signed
declaration by the student concerned will not be graded by the
teacher(s).
*/

#include <stdio.h>

void merge(int array[], int left, int middle, int right) {
    int lp = left;
    int rp = middle + 1;
    int buffer[right - left + 1];
    // write your code here
}

void mergeSort(int array[], int left, int right) {
    if (right - left + 1 <= 1) {
        return;
    }
    int middle = left + (right - left)/ 2;
    mergeSort(array, left, middle);
    mergeSort(array, middle + 1, right);
    merge(array, left, middle, right);
}

int main(void) {
    int N;
    int i;
    scanf("%d", &N);
    int array[N];
    for(i = 0; i < N; i++) {
        scanf("%d", &array[i]);
    }
    mergeSort(array, 0, N - 1);
    for (int i = 0; i < N; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
}


-------------------------------------------End of Code-------------------------------------------

Input:
N, followed by an unsorted integer array

Output:
A sorted integer array

Sample
input:
5
1 5 3 2 4

output:
1 2 3 4 5
