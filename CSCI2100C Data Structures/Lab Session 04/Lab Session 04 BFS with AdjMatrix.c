Time limit: 5000ms
Memory limit: 256mb

Description:
Given an unweighted, undirected and connected graph and a vertex, find out the BFS traversal order of the graph from the vertex. When there are multiple neighbours for a vertex, visit the neighbours in ascending order of their vertices' label. Note that the required traversal is unique.

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

typedef struct queueNode * PtrToQueueNode;

struct queueNode{
    int vertex;
    PtrToQueueNode next;
    PtrToQueueNode prev;
};

struct Queue {
    PtrToQueueNode head;
    PtrToQueueNode tail;
};

struct Queue * Create() {
    struct Queue * L;
    L = (struct Queue *)malloc(sizeof(struct Queue));
    L->head = (PtrToQueueNode)malloc(sizeof(struct queueNode));
    L->head->prev = NULL;
    L->tail = (PtrToQueueNode)malloc(sizeof(struct queueNode));
    L->head->next = L->tail;
    L->tail->prev = L->head;
    L->tail->next = NULL;
    return L;
}

void Enqueue(int x, struct Queue * L) {
    PtrToQueueNode temp;
    temp = (struct queueNode *)malloc(sizeof(struct queueNode));
    temp->vertex = x;
    temp->next = L->tail;
    temp->prev = L->tail->prev;
    L->tail->prev->next = temp;
    L->tail->prev = temp;
}

int Dequeue(struct Queue * L) {
    if (L->head->next == L->tail) {
        return -1;
    }
    PtrToQueueNode t = L->head->next;
    int vertex = t->vertex;
    t->next->prev = L->head;
    L->head->next = t->next;
    free(t);
    return vertex;
}
int IsEmpty(struct Queue * queue) {
    return queue->head->next == queue->tail;
}

struct Graph{
    int N;
    char** adjMatrix;
};

struct Graph* init_Graph(int N){
    struct Graph* G = (struct Graph*)malloc(sizeof(struct Graph));
    G->N = N;
    G->adjMatrix = (char**) malloc(sizeof(char*) * N);
    for (int i = 0; i < N; i++){
        G->adjMatrix[i] = (char *) malloc(sizeof(char) * N);;
    }
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            G->adjMatrix[i][j] = 0;
        }
    }
    return G;
}

void add_edge(struct Graph* G, int u, int v){
    G->adjMatrix[u][v] = 1;
    G->adjMatrix[v][u] = 1;
}

void printVertex(int x){
    printf("%d\n",x);
}

void bfs(struct Graph * G, int S){
    // write your code here
    // use the provided printVertex function for output of a vertex
}

int main(void) {
    int N, E;
    int S;
    struct Graph* G;
    scanf("%d%d%d",&N,&E,&S);
    G = init_Graph(N);
    for (int i = 0; i < E; i++){
        int u,v;
        scanf("%d%d",&u,&v);
        add_edge(G,u,v);
    }
    bfs(G,S);
    return 0;
}

-------------------------------------------End of Code-------------------------------------------

Input:
The first line are two integers, the number of vertices N and edges E.
The second line is one integer, the starting vertex S.
The next E lines are the edges, each consist of two integers, u and v, representing an undirected edge between vertex u and v.
Note that the vertices are labeled from 0 to N-1.
2 <= N <= 1,000; 0 <= E <= 100,000

Output
Output the BFS traversal from S as required.

Sample Input 1:
4 5
1
0 1
0 2
1 2
2 3
1 3

Sample Output 1:
1
0
2
3

Sample Input 2:
5 5
4
0 1
0 3
1 2
1 3
2 4

Sample Output 2:
4
2
1
0
3
