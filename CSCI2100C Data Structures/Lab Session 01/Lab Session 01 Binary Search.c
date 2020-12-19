
Time limit: 5000ms
Memory limit: 256mb

Description:
Given a list L of unique integers and a list T of target values, find out the indices of the target values in the list L (if exists), or report its absence.


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

int binary_search(int a[], int n, int target) {
    // WRITE YOUR CODE HERE
	// DO NOT MODIFY THE CODE BELOW
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

-------------------------------------------End of Code-------------------------------------------

Input:
First line contains a non-negative integer N;
The second line contains L, a sorted (in ascending order) list of N unique integers, L_0, L_1, ..., L_(N-1);
The third line contains T, a list of M target values, T_0, T_1, ..., T_(M-1), each separated by a space.
0 <= N,M <= 10^6

Output:
A line of M integers, I_0, I_1, ..., I_(M-1), where I_j = x if L_x = T_j, otherwise I_j = -1 if T_j is not in L.

Sample Input 1:
8
1 12 25 30 36 40 45 58
12 25 30 36 40 45 58 1 12

Sample Output 1:
1 2 3 4 5 6 7 0 1

Sample Input 2:
10
1 2 3 4 5 6 7 8 9 10
1 0 10

Sample Output 2:
0 -1 9
