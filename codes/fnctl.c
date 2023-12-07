#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    int fd, n;
    char buff[100];

    // Ouverture du fichier de la base de données
    if ((fd = open("database.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666)) == -1) {
        perror("open");
        exit(-1);
    }

    // Configuration du verrou via la structure flock
    struct flock lock;
    lock.l_type = F_WRLCK;  // Verrou en écriture
    lock.l_whence = SEEK_SET;
    lock.l_start = 0;
    lock.l_len = 0;  // Verrou sur tout le fichier

    if (fcntl(fd, F_SETLKW, &lock) == -1) {
        perror("fcntl");
        exit(1);
    }

    if (fork() == 0) {
        // Code du fils
        while (fcntl(fd, F_GETLK, &lock) != -1 && lock.l_type != F_UNLCK) {
            sleep(1);
        }

        do {
            printf("[fils]: a pris le verrou sur la database\n");
            n = read(0, buff, 100);
            buff[n - 1] = 0;
            printf("[fils]: rend le verrou\n");

            if (fcntl(fd, F_SETLKW, &lock) == -1) {
                perror("[fils] fcntl");
                exit(1);
            }

            write(fd, buff, n);

            if (fcntl(fd, F_SETLK, &lock) == -1) {
                perror("[fils] fcntl");
                exit(1);
            }
        } while (strcmp(buff, "quit") != 0);

        printf("[fils]: a terminé\n");
        exit(0);
    }
    else {
        // Code du père
        while (fcntl(fd, F_GETLK, &lock) != -1 && lock.l_type != F_UNLCK) {
            sleep(1);
        }

        do {
            printf("[père]: a pris le verrou sur la database\n");
            n = read(0, buff, 100);
            buff[n - 1] = 0;
            printf("[père]: rend le verrou\n");


            if (fcntl(fd, F_SETLKW, &lock) == -1) {
                perror("[père] fcntl");
                exit(1);
            }

            write(fd, buff, n);

            if (fcntl(fd, F_SETLK, &lock) == -1) {
                perror("[père] fcntl");
                exit(1);
            }
        } while (strcmp(buff, "quit") != 0);

        printf("[père]: a terminé\n");
        wait(0);
    }

    // Fermeture du fichier (le verrou sera libéré)
    close(fd);
    exit(0);
}

