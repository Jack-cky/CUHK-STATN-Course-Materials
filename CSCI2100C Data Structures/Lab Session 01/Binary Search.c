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

int binary_search(int a[], int n, int target) {
    // WRITE YOUR CODE HERE
    // DO NOT MODIFY THE CODE BELOW

    int left = 0, right = n - 1, middle;
    
    while(left <= right) {
        
        middle = (left + right) / 2;
        
        if(a[middle] < target)
            left = middle + 1;
        else if(a[middle] > target)
            right = middle - 1;
        else
            return middle;
    }
    return -1;
}

int main(void) {
    int n,a[1000001],i,target,result;
    
    scanf("%d",&n);
    
    for (i=0; i<n; i++)scanf("%d",&a[i]);
    while (scanf("%d",&target)!=EOF){
        result = binary_search(a, n, target);
        printf("%d ", result);
    }
        
    return 0;
}
