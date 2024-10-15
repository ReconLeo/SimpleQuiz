#include<stdio.h>
#include<string.h>
#include<stdlib.h>
void process(char name[100],char abc[100],FILE* fp);
int main(){
	printf("UniQuiz Dict Editor (C Remade Version)\n");
	printf("(c)Recon&LY Inc. All Rights Reserved.\n");
	printf("-------------------------------\n");
	char dict_tmp[100],header[101]={'>'};
	FILE* fp;
	char dict[100];
	printf("Dict Name:\n");
	scanf("%s",dict);
	strcpy(dict_tmp,dict);
	strcat(dict,".ini");
	strcat(header,dict_tmp);
	fp = fopen(dict,"r");
	if (fp==NULL) {
		printf("New dict\[%s] has been generated.\n",dict_tmp);
		printf("-------------------------------\n");
		fp = fopen(dict,"a+");
		fputs(header,fp);
		fputc('\n',fp);
		fclose(fp);
	} else {
		printf("Dict\[%s] is being edited.\n",dict);
		printf("-------------------------------\n");
	}
	fp = fopen(dict,"a+");
	if (fp==NULL) {
		printf("Fail to access the file %s.\n",dict);
		system("cls");
		main();
	}
	process(dict,dict_tmp,fp);
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
