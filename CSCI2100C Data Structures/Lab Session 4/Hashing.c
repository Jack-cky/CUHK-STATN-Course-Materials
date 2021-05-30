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

struct Entry{
    int ID;
    int isInside;
};

void init_hashTable(struct Entry hashTable[], int hashTableSize){
    for (int i = 0; i < hashTableSize; i++){
        hashTable[i].ID = -1;
        hashTable[i].isInside = 0;
    }
}

int hashFunc1(int x, int hashTableSize){
    return x % hashTableSize;
}

int hashFunc2(int x){
    return x % 29 + 1;
}

int doubleHashFunc(int x, int i, int hashTableSize){
    return (hashFunc1(x,hashTableSize) + i * hashFunc2(x)) % hashTableSize;
}

int search(int x, struct Entry hashTable[], int hashTableSize){
    // write your code here
    
    for(int i = 0; i < hashTableSize; i++){
        int index = doubleHashFunc(x, i, hashTableSize);
        if(hashTable[index].ID == x)
            return index;
            
        if(hashTable[index].ID == -1)
            return -1;
    }
    
    return -1;
}

void insert(int x, struct Entry hashTable[], int hashTableSize){
    for (int i = 0; i < hashTableSize - 1; i++){
        int hashed_key = doubleHashFunc(x,i,hashTableSize);
        if(hashTable[hashed_key].ID == -1){
            // write your code here

            hashTable[hashed_key].ID = x;
            hashTable[hashed_key].isInside = 1;
            break;
        }
    }
}

int main(void) {
    int id;
    int numInside = 0;
    int hashTableSize = 29989;
    struct Entry hashTable[hashTableSize];
    init_hashTable(hashTable,hashTableSize);
    while(scanf("%d",&id) != EOF){
        if (id == -1) {
            break;
        }
        int hashed_key = search(id, hashTable, hashTableSize);
        if(hashed_key != -1){
            if(hashTable[hashed_key].isInside){
                numInside -= 1;
            }
            else{
                numInside += 1;
            }
            hashTable[hashed_key].isInside = 1 - hashTable[hashed_key].isInside;
        }
        else{
            insert(id, hashTable, hashTableSize);
            numInside += 1;
        }
    }
    printf("%d\n",numInside);
    return 0;
}
