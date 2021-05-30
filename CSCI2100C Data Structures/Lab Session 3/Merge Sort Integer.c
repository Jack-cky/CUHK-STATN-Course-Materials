/*
I, CHAN King Yeung, am submitting the assignment for
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
    
     int filled = 0;
     
     while(lp <= middle && rp <= right)
         if(array[lp] < array[rp])
             buffer[filled++] = array[lp++];
         else
             buffer[filled++] = array[rp++];
     
     while(lp <= middle)
         buffer[filled++] = array[lp++];
     
     while(rp <= right)
         buffer[filled++] = array[rp++];
     
     for(int i = 0; i <= (right - left); i++)
         array[left + i] = buffer[i];
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
