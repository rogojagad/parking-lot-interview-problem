#include<stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv){
	// run the spec
	char command[50];
	
	strcpy(command, "ruby lib/main.rb ");
	
	if(argc > 1){
		strcat(command, argv[1]);
	}

	system("bundle exec rspec");
	system(command);
}
