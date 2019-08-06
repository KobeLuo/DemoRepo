//
//  SortClass.m
//  ProgrammingContests
//
//  Created by Kobe on 2019/8/6.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "SortClass.h"

@implementation SortClass

+ (void)testSort {
    
    testSort();
}

void testSort() {
    
    printf("\n========Insert Sort=========\n");
    int a[] = {31,41,59,26,41,58};
    int *result = insertSort(a,sizeof(a)/sizeof(int));
    printf("result:{%d,%d,%d,%d,%d,%d} \n",result[0],result[1],result[2],result[3],result[4],result[5]);
    
    printf("\n========Merge Sort=========\n");
//    int b[] = {31,2,41,59,26,124,1,43,0,41,58,6,72,38,11};
    int b[] = {12,8,7,5,3};
    mergeSort(b,sizeof(b)/sizeof(int));
    result = b;
    printf("result:{");
    for (int index = 0; index < sizeof(b)/sizeof(int); index ++) {
        
        printf("%d,",b[index]);
    }
    printf("}\n");
    
    printf("\n=========Check values exist in array=========\n");
    int c[] = {12,8,7,3,8,5,3};
    printf("values:{12,8,7,3,8,5,3},sum:14 exist:%d\n",sumCheck(c, sizeof(c)/ sizeof(int), 14));
    printf("values:{12,8,7,3,8,5,3},sum:12 exist:%d\n",sumCheck(c, sizeof(c)/ sizeof(int), 12));
    printf("values:{12,8,7,3,8,5,3},sum:6 exist:%d\n",sumCheck(c, sizeof(c)/ sizeof(int), 6));

    
}

#pragma mark - insert sort

int *insertSort(int *a, int count) {
    
    int *res = malloc(count * sizeof(int));
    for (int index = 0; index < count; index ++) {
        
        int value = *a++;
        res = insertValueToArray(res, index, value);
    }
    return res;
}

int *insertValueToArray(int *a, int count, int value) {
    
    if (0 == count) { *a = value; return a;}
    int lastv = value;
    bool didFind = false;
    for (int index = 0; index < count; index ++) {
        
        int tmpv = a[index];
        if (didFind) {
            
            a[index] = lastv;
            lastv = tmpv;
        }else {
            
            if (tmpv >= value) {
                
                a[index] = value;
                lastv = tmpv;
                didFind = true;
            }
        }
    }
    
    a[count] = lastv;
    return a;
}


#pragma mark - Merge sort
void mergeSort(int *a, int count) {
    
    int *tempBuffer = malloc(count * sizeof(int));
    mergeSortWithBuffer(a, 0, 0, count - 1,tempBuffer);
    free(tempBuffer);
}
void mergeSortWithBuffer(int *a, int leftStart, int rightStart, int end, int *tempBuffer) {
    
    int leftCount  = rightStart - leftStart;
    int rightCount = end - rightStart + 1;
    if (leftCount + rightCount <= 1) { return; }
    
    if (leftCount != 0) {
        
        // left dichotomy
        int lls = leftStart;
        int lrs = leftStart + leftCount/2;
        int lnd = rightStart - 1;
        mergeSortWithBuffer(a, lls, lrs, lnd,tempBuffer);
    }
    
    if (rightCount != 0) {
        
        // right dichotomy
        int rls = rightStart;
        int rrs = rightStart + rightCount/2;
        int rnd = end;
        mergeSortWithBuffer(a, rls, rrs, rnd,tempBuffer);
    }
    
    mergeData(a, leftStart, rightStart, end, tempBuffer);
}

void mergeData(int *a, int leftStart, int rightStart, int end,int *tempBuffer) {
    
    int leftCount  = rightStart - leftStart;
    int rightCount = end - rightStart + 1;
    
    int lindex,rindex;
    lindex = rindex = 0;
    
    while (lindex < leftCount || rindex < rightCount) {
        
        int lv = INT_MAX,rv = INT_MAX;
        if (lindex < leftCount) { lv = a[leftStart + lindex]; }
        if (rindex < rightCount) { rv = a[rightStart + rindex]; }
        
        if (lv <= rv) {
            
            tempBuffer[leftStart + lindex + rindex] = lv;
            lindex ++;
        }else {
            
            tempBuffer[leftStart + lindex + rindex] = rv;
            rindex ++;
        }
    }
    
    for (int index = 0; index < end - leftStart + 1; index ++) {
        
        a[leftStart + index] = tempBuffer[leftStart + index];
    }
}

int *merge1Sort(int *a,int count) {
    
    int leftCount  = count / 2;
    int rightCount = count - leftCount;
    if (leftCount == 0 || rightCount == 0) { return a; }
    
    int *leftData  = get1Data(a, 0, leftCount);
    int *rightData = get1Data(a, leftCount, count);
    
    int *sortedLeftData  = merge1Sort(leftData, leftCount);
    int *sortedRightData = merge1Sort(rightData, rightCount);
    
    int *resultData = merge1Data(sortedLeftData, sortedRightData, leftCount, rightCount);
    
    free(sortedLeftData);
    free(sortedRightData);
    
    return resultData;
}

int *get1Data(int *a,int from, int to) {
    
    if (from > to) { return nil; }
    int *res = malloc((to - from + 1) * sizeof(int));
    for (int index = from; index < to; index ++) {
        
        int value = a[index];
        res[index-from] = value;
    }
    return res;
}

int *merge1Data(int *a, int *b, int acount, int bcount) {
    
    int *result = malloc((acount + bcount) * sizeof(int));
    
    int aindex,bindex,rindex;
    aindex = bindex = rindex = 0;
    
    while (aindex < acount | bindex < bcount) {
        
        int value,avalue = INT_MAX,bvalue = INT_MAX;
        if (aindex < acount) { avalue = a[aindex]; }
        if (bindex < bcount) { bvalue = b[bindex]; }
        // get value from a point.
        if (avalue <= bvalue) {
            
            value = avalue;
            aindex ++;
        }else {
            // get value from b point.
            value = bvalue;
            bindex ++;
        }
        
        result[rindex] = value;
        rindex ++;
    }
    
    return result;
}

#pragma mark - sum check
bool sumCheck(int *a, int count, int sum) {
    
    mergeSort(a, count);
    
    int *b = malloc(count * 2 * sizeof(int));
    bool checked = false;
    bool hassum = false;
    bool haszero = false;
    for (int index = 0; index < count; index ++) {
        
        int value = a[index];
        if (value == 0) { haszero = true; }
        if (a[index] == sum) { hassum = true; }
        if (a[index] * 2 == sum) {
            
            if (a[index + 1] * 2 == sum) {
                
                checked = true;break;
            }else{
                
                b[index] = 0; b[index + count] = 0; continue;
            }
        }
        if (a[index] == a[index + 1]) {
            
            b[index] = 0; b[index + count] = 0; continue;
        }
        
        if (hassum && haszero) { checked = true; break; }
        b[index] = a[index];
        b[count + index] = sum - a[index];
    }
    
    if (checked) {  free(b); return true; }
    
    mergeSort(b, count * 2);
    
    for (int index = 0; index < count*2; index ++) {
        
        if (b[index] == 0) { continue; }
        if (b[index] == b[index + 1] && b[index] != 0) {
            checked = true;
            break; }
    }
    
    free(b);
    return checked;
}

@end
