#include <stdio.h>
#include <sys/time.h>
#include <assert.h>

int main(void)
{
    struct timeval now;

    assert(!gettimeofday(&now, NULL));

    printf("hello, world! it's %0.4f seconds past the epoch\n", now.tv_sec + now.tv_usec * 1e-6);
}
