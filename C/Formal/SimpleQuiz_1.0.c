#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<direct.h>
void process(char name[100],char abc[100],FILE* fp);
int main(){
	printf("UniQuiz Dict Editor (C Remade Version)\n");
	printf("(c)Recon&LY Inc. All Rights Reserved.\n");
	printf("-------------------------------\n");
	mkdir("Dicts");
	char dict_tmp[100],header[101]={'>'},dict_load[]="Dicts\\",path[1024],dict_load1[1024];
	FILE* fp;
	char dict[100];
	printf("Dict Name:\n");
	scanf("%s",dict);
	strcpy(dict_tmp,dict);
	strcat(header,dict_tmp);
    if (getcwd(path, sizeof(path)) != NULL) {
        printf("Current working directory: %s\n", path);
    } else {
        perror("getcwd() error\n");
    }
	sprintf(dict_load1,"%s\\%s%s%s",path,dict_load,dict,".ini");
	printf("Current loading file: %s\n",dict_load1);
	fp = fopen(dict_load1,"r");
	if (fp==NULL) {
		printf("New dict\[%s] has been generated.\n",dict_tmp);
		printf("-------------------------------\n");
		fp = fopen(dict_load1,"a+");
		fputs(header,fp);
		fputc('\n',fp);
		fclose(fp);
	} else {
		printf("Dict\[%s] is being edited.\n",dict);
		printf("-------------------------------\n");
	}
	fp = fopen(dict_load1,"a+");
	if (fp==NULL) {
		printf("Fail to access the file %s.\n",dict_load1);
		system("pause");
		main();
	}
	process(dict_load1,dict_tmp,fp);
}
void process(char name[100],char abc[100],FILE* fp){
	int have=0;
	char title[100],content[1000],note[1000],tmp[2100];
	printf("Entry title:\n");
	scanf("%s",title);
	printf("Entry content:\n");
	scanf("%s",content);
	printf("Entry note (Enter 0 to skip annotation):\n");
	scanf("%s",note);
	if (strcmp(note,"0")==0){
		strcpy(note,"(NaN)");
		have=1;
	}
	strcpy(tmp,title);
	strcat(tmp,",");
	strcat(tmp,content);
	strcat(tmp,",");
	strcat(tmp,note);
	int wr=fputs(tmp,fp);
	if (wr==EOF) {
		printf("Fail to add the entry. Make sure you have the permission to write the file.\n");
	} else
	{
		if (have==0){
			printf("Entry \"%s\"|\"%s\" was added to Dict\[%s] with annotation %s.\n",title,content,abc,note);
			fputc('\n',fp);	
		} else {
			printf("Entry \"%s\"|\"%s\" was added to Dict\[%s] without annotation.\n",title,content,abc);
			fputc('\n',fp);
		}
	}
	printf("-------------------------------\n");
	fclose(fp);
	fopen(name,"a+");
	process(name,abc,fp);
}
