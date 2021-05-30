Time limit: 5000ms
Memory limit: 256mb

Description:
Each input file contains one test case. For each case,
the first line contains a positive integer N (≤20) which is the total number of keys to be inserted.
Then N distinct integer keys are given in the next line. All the numbers in a line are separated by a space.
Input a search key
Output the search result and min-value of the BST.

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

struct TreeNode {
    int data;
    struct TreeNode * leftchild;
    struct TreeNode * rightchild;
};

struct TreeNode * Insert(int x, struct TreeNode * root);
struct TreeNode * LChild(struct TreeNode * root);
struct TreeNode * RChild(struct TreeNode * root);
int Data(struct TreeNode * root);
bool isEmpty(struct TreeNode * root);
struct TreeNode * search(struct TreeNode * root, int key);
struct TreeNode * min(struct TreeNode * root);

int main()
{
    int n, x, key;
    struct TreeNode * root = NULL;
    scanf("%d", &n);
    for (int i = 0; i < n; i++)
    {
        scanf("%d", &x);
        root = Insert(x, root);
    }
    scanf("%d", &key);
    printf("%d\n", Data(search(root, key)));
    printf("%d\n", Data(min(root)));
    return 0;
}

struct TreeNode * Insert(int x, struct TreeNode * root)
{
    if (root == NULL)
    {
        root = (struct TreeNode *)malloc(sizeof(struct TreeNode));
        root->data = x;
        root->leftchild = root->rightchild = NULL;
    }
    else if (x < Data(root))
    {
        root->leftchild = Insert(x, root->leftchild);
    }
    else if (x > Data(root))
    {
        root->rightchild = Insert(x, root->rightchild);
    }
    return root;
}

struct TreeNode * Lchild(struct TreeNode * root){
    return root->leftchild;
}

struct TreeNode * Rchild(struct TreeNode * root){
    return root->rightchild;
}

int Data(struct TreeNode * root) {
    return root->data;
}

bool isEmpty(struct TreeNode * root) {
    return root == NULL;
}

struct TreeNode * search(struct TreeNode * root, int key) {
    // write your code here
}

struct TreeNode * min(struct TreeNode * root) {
    // write your code here
}

-------------------------------------------End of Code-------------------------------------------


Input:
The number of elements N.
An integer array.

Output:
Search result: If key in the BST, output key's value. Otherwise, output NULL.
Output the min-value in the tree.

Sample 1
input:
5
1 10 25 16 98
10

output:
10
1

Sample 2
input:
5
1 10 25 16 98
9

output:
NULL
1
