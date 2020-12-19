Time limit: 5000ms
Memory limit: 256mb

Description:
Given two arrays of non-negative integers, denoted as arrA and arrB, the sets setA and setB are the unique elements of arrA and arrB respectively. Please complete the missing part of the following code to compute the union of setA and setB with the aid of the implemented ADT:


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
#include <stdlib.h>

struct Node {
    int Element;
    struct Node * Left;
    struct Node * Right;
}; // structure of Node

struct Node * init_set(int x); // create an integer set which contains element x.
struct Node * set_insert(struct Node * r, int x); // insert x into integer set r.
void set_delete(struct Node * r, int x); // delete x from integer set r.
struct Node * preorder_merge(struct Node * r, struct Node * r_new); // preorder merge of r and r_new
struct Node * set_union(struct Node * a, struct Node * b); // calculate the union of two integer sets: integer set a and integer set b.
void print_set(struct Node * r); // output the elements in the integer set in ascending.
void arr_union(int a[], int b[], int size_a, int size_b); // output (in ascending order) the union of two sets that are derived from integer arrays a and b respectively

struct Node * init_set(int x) {
    struct Node * temp = (struct Node *)malloc(sizeof(struct Node));
    if (temp == NULL) {
        return NULL;
    }
    temp->Element = x;
    temp->Left = NULL;
    temp->Right = NULL;
    return temp;
}

struct Node * set_insert(struct Node * r, int x) {
    if (r == NULL) {
        r = init_set(x);
    }
    else if (r->Element > x) {
        r->Left = set_insert(r->Left, x);
    }
    else if (r->Element < x) {
        r->Right = set_insert(r->Right, x);
    }
    return r;
}

void set_delete(struct Node * r, int x) {
    if (r == NULL) {
        return;
    }
    struct Node * temp = r;
    struct Node * temp_prev = temp;
    while (temp && temp->Element != x) {
        temp_prev = temp;
        if (temp->Element > x) {
            temp = temp->Left;
        }
        else {
            temp = temp->Right;
        }
    }
    if (temp == NULL) {
        return;
    }
    if(temp->Left && temp->Right)
    {
        struct Node * min = temp->Right;
        temp_prev = temp;
        while(min->Left)
        {
            temp_prev = min;
            min = min->Left;
        }
        temp->Element = min->Element;
        if(temp_prev->Right == min) {
            temp_prev->Right = min->Right;
        }
        else {
            temp_prev->Left = min->Right;
        }
    }
    else
    {
        if(temp_prev->Left == temp)
        {
            temp_prev->Left = temp->Left ? temp->Left : temp->Right;
        }
        else if(temp_prev->Right == temp)
        {
            temp_prev->Right = temp->Left ? temp->Left : temp->Right;
        }
        else if(temp_prev == temp) {
            temp = temp_prev->Left ? temp_prev->Left : temp_prev->Right;
            temp_prev->Element = temp->Element;
            if (temp_prev->Left == NULL) {
                temp_prev->Right = NULL;
            } else {
                temp_prev->Left = NULL;
            }
        }
        free(temp);
    }
}

struct Node * preorder_merge(struct Node * r, struct Node * r_new) {
    if (r != NULL) {
        r_new = set_insert(r_new, r->Element);
        preorder_merge(r->Left, r_new);
        preorder_merge(r->Right, r_new);
    }
    return r_new;
}

struct Node * set_union(struct Node * a, struct Node * b) {
    struct Node * t_new = NULL;
    t_new = preorder_merge(a, t_new);
    t_new = preorder_merge(b, t_new);
    return t_new;
}

void print_set(struct Node * r) {
    if (r == NULL) {
        return;
    }
    print_set(r->Left);
    printf("%d ", r->Element);
    print_set(r->Right);
}

void arr_union(int a[], int b[], int size_a, int size_b) {
    int i;
    struct Node * root_a = NULL;
    struct Node * root_b = NULL;
    struct Node * new_root = NULL;
    for (i = 0; i < size_a; i++) {
        if (i == 0) {
            root_a = init_set(a[i]);
        }
        else {
            set_insert(root_a, a[i]);
        }
    }
    for (i = 0; i < size_b; i++) {
        if (i == 0) {
            root_b = init_set(b[i]);
        }
        else {
            set_insert(root_b, b[i]);
        }
    }
    if (root_a != NULL || root_b != NULL) {
        new_root = set_union(root_a, root_b);
        print_set(new_root);
    }
}

int main(void) {
    int i, x;
    int size_a;
    int size_b;
    scanf("%d", &size_a);
    int arr_a[size_a];
    for(i = 0; i < size_a; i++) {
        scanf("%d", &x);
        arr_a[i] = x;
    }
    scanf("%d", &size_b);
    int arr_b[size_b];
    for(i = 0; i < size_b; i++) {
        scanf("%d", &x);
        arr_b[i] = x;
    }
    // WRITE YOUR CODE HERE
	// DO NOT MODIFY THE CODE ABOVE
    printf("\n");
	return 0;
}

-------------------------------------------End of Code-------------------------------------------

Input:
Four lines, where:
First line is a non-negative integer A;
Second line is arrA of A non-negative integers;
Third line is a non-negative integer B;
Fourth line is arrB of B non-negative integers;
0 <= A, B <= 10^3

Output:
You should output the union of setA and setB in ascending order.

Sample Input 1:
7
1 2 5 6 7 9 10
5
1 2 3 4 8

Sample Output 1:
1 2 3 4 5 6 7 8 9 10
