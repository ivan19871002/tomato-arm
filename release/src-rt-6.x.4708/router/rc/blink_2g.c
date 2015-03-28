#include "rc.h"
#include <shared.h>

static char *interface = NULL;
static int rand_seed_by_time(void)
{
	time_t atime;

	time(&atime);
	srand((unsigned long)atime);

        return rand();
}

static unsigned long get_2g_count()
{
	FILE *f;
	char buf[256];
	char *ifname, *p;
	unsigned long counter1, counter2;

	if((f = fopen("/proc/net/dev", "r"))==NULL) return -1;

	fgets(buf, sizeof(buf), f);
	fgets(buf, sizeof(buf), f);

	counter1=counter2=0;

	while (fgets(buf, sizeof(buf), f)) {
		if((p=strchr(buf, ':'))==NULL) continue;
		*p = 0;
		if((ifname = strrchr(buf, ' '))==NULL) ifname = buf;
		else ++ifname;

		if(strcmp(ifname, interface)) continue;

		if(sscanf(p+1, "%lu%*u%*u%*u%*u%*u%*u%*u%*u%lu", &counter1, &counter2)!=2) continue;

	}
	fclose(f);

	return counter1;
}

int blink_2g_main(int argc, char *argv[])
{
	static unsigned int blink_2g = 0;
	static unsigned int data_2g = 0;
	unsigned long count_2g;
	int i;
	static int j;
	static int status = -1;
	static int status_old;
	if (fork() != 0) return 0;
	setsid();
	signal(SIGCHLD, chld_reap);
#define INTERFACE_MAXLEN 10
	interface = calloc(INTERFACE_MAXLEN,1);
	char *tmp_interface = nvram_get("blink_2g_interface");
	if(tmp_interface)
		strncpy(interface,tmp_interface, INTERFACE_MAXLEN);
	// check data per 10 count
	while(1){
		if(!tmp_interface){
			sleep(5);
			tmp_interface = nvram_get("blink_2g_interface");
			if(tmp_interface)
				strncpy(interface,tmp_interface, INTERFACE_MAXLEN);
			continue;
		}
		count_2g = get_2g_count();
		if(count_2g && data_2g!=count_2g) {
			blink_2g = 1;
			data_2g = count_2g;
		}
		else 
			blink_2g = 0;
		led(LED_WLAN, LED_ON);

		if(blink_2g) {
			j = rand_seed_by_time() % 3;
			for(i=0;i<10;i++) {
				usleep(33*1000);
				status_old = status;
				if (((i%2)==0) && (i > (3 + 2*j)))
					status = 0;
				else
					status = 1;

				if (status != status_old)
				{
					if (status)
						led(LED_WLAN, LED_ON);
					else
						led(LED_WLAN, LED_OFF);
				}
			}
			led(LED_WLAN, LED_ON);
		}
		else
			usleep(50000);

	}
}

