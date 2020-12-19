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

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int data;
    struct TreeNode * leftchild;
    struct TreeNode * rightchild;
};

struct TreeNode * Insert(int x, struct TreeNode * root);
struct TreeNode * Lchild(struct TreeNode * root);
struct TreeNode * Rchild(struct TreeNode * root);
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
    if (search(root, key) == NULL) {
        printf("NULL\n");
    }
    else {
        printf("%d\n", Data(search(root, key)));
    }
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
    
    if(isEmpty(root) || Data(root) == key)
        return root;
    
    if(Data(root) < key)
        return search(Rchild(root), key);
    else
        return search(Lchild(root), key);
}

struct TreeNode * min(struct TreeNode * root) {
    // write your code here
    
    struct TreeNode * node = root;
    
    while(!isEmpty(node) && !isEmpty(Lchild(node)))
        node = Lchild(node);
    return node;
}
