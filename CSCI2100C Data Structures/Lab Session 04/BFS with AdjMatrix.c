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
    G->adjMatrix = (char**) malloc(sizeof(char*) * (N+1));
    for (int i = 0; i <= N; i++){
        G->adjMatrix[i] = (char *) malloc(sizeof(char) * (N+1));;
    }
    for (int i = 0; i <= N; i++){
        for (int j = 0; j <= N; j++){
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
void bfs(struct Graph* G, int S){
    // write your code here
    // use the provided printVertex function for output of a vertex
    
    int colour[G->N];
    for(int i = 0; i <= G->N - 1; i++)
        colour[i] = 0;
    
    struct Queue * q = Create();
    Enqueue(S, q);
    colour[S] = 1;
    
    while(!IsEmpty(q)) {
        int v = Dequeue(q);
        for(int i  = 0; i <= G->N; i++) {
            if(G->adjMatrix[v][i] != 0 && colour[i] == 0) {
                Enqueue(i, q);
                colour[i] = 1;
            }
        }
        printVertex(v);
    }
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
