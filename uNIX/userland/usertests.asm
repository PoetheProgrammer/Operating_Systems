
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 9c 62 00 00       	mov    0x629c,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 f6 43 00 00       	push   $0x43f6
      13:	50                   	push   %eax
      14:	e8 11 40 00 00       	call   402a <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 01 44 00 00       	push   $0x4401
      24:	e8 f4 3e 00 00       	call   3f1d <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 9c 62 00 00       	mov    0x629c,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 09 44 00 00       	push   $0x4409
      3d:	50                   	push   %eax
      3e:	e8 e7 3f 00 00       	call   402a <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 6a 3e 00 00       	call   3eb5 <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 01 44 00 00       	push   $0x4401
      53:	e8 cd 3e 00 00       	call   3f25 <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 9c 62 00 00       	mov    0x629c,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 17 44 00 00       	push   $0x4417
      6c:	50                   	push   %eax
      6d:	e8 b8 3f 00 00       	call   402a <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 3b 3e 00 00       	call   3eb5 <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 2d 44 00 00       	push   $0x442d
      82:	e8 7e 3e 00 00       	call   3f05 <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 9c 62 00 00       	mov    0x629c,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 38 44 00 00       	push   $0x4438
      9b:	50                   	push   %eax
      9c:	e8 89 3f 00 00       	call   402a <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 0c 3e 00 00       	call   3eb5 <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 52 44 00 00       	push   $0x4452
      b1:	e8 6f 3e 00 00       	call   3f25 <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 9c 62 00 00       	mov    0x629c,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 54 44 00 00       	push   $0x4454
      ca:	50                   	push   %eax
      cb:	e8 5a 3f 00 00       	call   402a <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 dd 3d 00 00       	call   3eb5 <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 9c 62 00 00       	mov    0x629c,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 64 44 00 00       	push   $0x4464
      e5:	50                   	push   %eax
      e6:	e8 3f 3f 00 00       	call   402a <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	c9                   	leave  
      ef:	c3                   	ret    

000000f0 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f0:	55                   	push   %ebp
      f1:	89 e5                	mov    %esp,%ebp
      f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f6:	a1 9c 62 00 00       	mov    0x629c,%eax
      fb:	83 ec 08             	sub    $0x8,%esp
      fe:	68 72 44 00 00       	push   $0x4472
     103:	50                   	push   %eax
     104:	e8 21 3f 00 00       	call   402a <printf>
     109:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10c:	e8 9c 3d 00 00       	call   3ead <fork>
     111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     114:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     118:	79 1b                	jns    135 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11a:	a1 9c 62 00 00       	mov    0x629c,%eax
     11f:	83 ec 08             	sub    $0x8,%esp
     122:	68 81 44 00 00       	push   $0x4481
     127:	50                   	push   %eax
     128:	e8 fd 3e 00 00       	call   402a <printf>
     12d:	83 c4 10             	add    $0x10,%esp
    exit();
     130:	e8 80 3d 00 00       	call   3eb5 <exit>
  }
  if(pid == 0){
     135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     139:	0f 85 92 00 00 00    	jne    1d1 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     13f:	83 ec 0c             	sub    $0xc,%esp
     142:	68 01 44 00 00       	push   $0x4401
     147:	e8 d1 3d 00 00       	call   3f1d <mkdir>
     14c:	83 c4 10             	add    $0x10,%esp
     14f:	85 c0                	test   %eax,%eax
     151:	79 1b                	jns    16e <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     153:	a1 9c 62 00 00       	mov    0x629c,%eax
     158:	83 ec 08             	sub    $0x8,%esp
     15b:	68 09 44 00 00       	push   $0x4409
     160:	50                   	push   %eax
     161:	e8 c4 3e 00 00       	call   402a <printf>
     166:	83 c4 10             	add    $0x10,%esp
      exit();
     169:	e8 47 3d 00 00       	call   3eb5 <exit>
    }
    if(chdir("iputdir") < 0){
     16e:	83 ec 0c             	sub    $0xc,%esp
     171:	68 01 44 00 00       	push   $0x4401
     176:	e8 aa 3d 00 00       	call   3f25 <chdir>
     17b:	83 c4 10             	add    $0x10,%esp
     17e:	85 c0                	test   %eax,%eax
     180:	79 1b                	jns    19d <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     182:	a1 9c 62 00 00       	mov    0x629c,%eax
     187:	83 ec 08             	sub    $0x8,%esp
     18a:	68 8e 44 00 00       	push   $0x448e
     18f:	50                   	push   %eax
     190:	e8 95 3e 00 00       	call   402a <printf>
     195:	83 c4 10             	add    $0x10,%esp
      exit();
     198:	e8 18 3d 00 00       	call   3eb5 <exit>
    }
    if(unlink("../iputdir") < 0){
     19d:	83 ec 0c             	sub    $0xc,%esp
     1a0:	68 2d 44 00 00       	push   $0x442d
     1a5:	e8 5b 3d 00 00       	call   3f05 <unlink>
     1aa:	83 c4 10             	add    $0x10,%esp
     1ad:	85 c0                	test   %eax,%eax
     1af:	79 1b                	jns    1cc <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b1:	a1 9c 62 00 00       	mov    0x629c,%eax
     1b6:	83 ec 08             	sub    $0x8,%esp
     1b9:	68 38 44 00 00       	push   $0x4438
     1be:	50                   	push   %eax
     1bf:	e8 66 3e 00 00       	call   402a <printf>
     1c4:	83 c4 10             	add    $0x10,%esp
      exit();
     1c7:	e8 e9 3c 00 00       	call   3eb5 <exit>
    }
    exit();
     1cc:	e8 e4 3c 00 00       	call   3eb5 <exit>
  }
  wait();
     1d1:	e8 e7 3c 00 00       	call   3ebd <wait>
  printf(stdout, "exitiput test ok\n");
     1d6:	a1 9c 62 00 00       	mov    0x629c,%eax
     1db:	83 ec 08             	sub    $0x8,%esp
     1de:	68 a2 44 00 00       	push   $0x44a2
     1e3:	50                   	push   %eax
     1e4:	e8 41 3e 00 00       	call   402a <printf>
     1e9:	83 c4 10             	add    $0x10,%esp
}
     1ec:	c9                   	leave  
     1ed:	c3                   	ret    

000001ee <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1ee:	55                   	push   %ebp
     1ef:	89 e5                	mov    %esp,%ebp
     1f1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f4:	a1 9c 62 00 00       	mov    0x629c,%eax
     1f9:	83 ec 08             	sub    $0x8,%esp
     1fc:	68 b4 44 00 00       	push   $0x44b4
     201:	50                   	push   %eax
     202:	e8 23 3e 00 00       	call   402a <printf>
     207:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20a:	83 ec 0c             	sub    $0xc,%esp
     20d:	68 c3 44 00 00       	push   $0x44c3
     212:	e8 06 3d 00 00       	call   3f1d <mkdir>
     217:	83 c4 10             	add    $0x10,%esp
     21a:	85 c0                	test   %eax,%eax
     21c:	79 1b                	jns    239 <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     21e:	a1 9c 62 00 00       	mov    0x629c,%eax
     223:	83 ec 08             	sub    $0x8,%esp
     226:	68 c9 44 00 00       	push   $0x44c9
     22b:	50                   	push   %eax
     22c:	e8 f9 3d 00 00       	call   402a <printf>
     231:	83 c4 10             	add    $0x10,%esp
    exit();
     234:	e8 7c 3c 00 00       	call   3eb5 <exit>
  }
  pid = fork();
     239:	e8 6f 3c 00 00       	call   3ead <fork>
     23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     245:	79 1b                	jns    262 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     247:	a1 9c 62 00 00       	mov    0x629c,%eax
     24c:	83 ec 08             	sub    $0x8,%esp
     24f:	68 81 44 00 00       	push   $0x4481
     254:	50                   	push   %eax
     255:	e8 d0 3d 00 00       	call   402a <printf>
     25a:	83 c4 10             	add    $0x10,%esp
    exit();
     25d:	e8 53 3c 00 00       	call   3eb5 <exit>
  }
  if(pid == 0){
     262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     266:	75 3b                	jne    2a3 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     268:	83 ec 08             	sub    $0x8,%esp
     26b:	6a 02                	push   $0x2
     26d:	68 c3 44 00 00       	push   $0x44c3
     272:	e8 7e 3c 00 00       	call   3ef5 <open>
     277:	83 c4 10             	add    $0x10,%esp
     27a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     281:	78 1b                	js     29e <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     283:	a1 9c 62 00 00       	mov    0x629c,%eax
     288:	83 ec 08             	sub    $0x8,%esp
     28b:	68 e0 44 00 00       	push   $0x44e0
     290:	50                   	push   %eax
     291:	e8 94 3d 00 00       	call   402a <printf>
     296:	83 c4 10             	add    $0x10,%esp
      exit();
     299:	e8 17 3c 00 00       	call   3eb5 <exit>
    }
    exit();
     29e:	e8 12 3c 00 00       	call   3eb5 <exit>
  }
  sleep(1);
     2a3:	83 ec 0c             	sub    $0xc,%esp
     2a6:	6a 01                	push   $0x1
     2a8:	e8 98 3c 00 00       	call   3f45 <sleep>
     2ad:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b0:	83 ec 0c             	sub    $0xc,%esp
     2b3:	68 c3 44 00 00       	push   $0x44c3
     2b8:	e8 48 3c 00 00       	call   3f05 <unlink>
     2bd:	83 c4 10             	add    $0x10,%esp
     2c0:	85 c0                	test   %eax,%eax
     2c2:	74 1b                	je     2df <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c4:	a1 9c 62 00 00       	mov    0x629c,%eax
     2c9:	83 ec 08             	sub    $0x8,%esp
     2cc:	68 04 45 00 00       	push   $0x4504
     2d1:	50                   	push   %eax
     2d2:	e8 53 3d 00 00       	call   402a <printf>
     2d7:	83 c4 10             	add    $0x10,%esp
    exit();
     2da:	e8 d6 3b 00 00       	call   3eb5 <exit>
  }
  wait();
     2df:	e8 d9 3b 00 00       	call   3ebd <wait>
  printf(stdout, "openiput test ok\n");
     2e4:	a1 9c 62 00 00       	mov    0x629c,%eax
     2e9:	83 ec 08             	sub    $0x8,%esp
     2ec:	68 13 45 00 00       	push   $0x4513
     2f1:	50                   	push   %eax
     2f2:	e8 33 3d 00 00       	call   402a <printf>
     2f7:	83 c4 10             	add    $0x10,%esp
}
     2fa:	c9                   	leave  
     2fb:	c3                   	ret    

000002fc <opentest>:

// simple file system tests

void
opentest(void)
{
     2fc:	55                   	push   %ebp
     2fd:	89 e5                	mov    %esp,%ebp
     2ff:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     302:	a1 9c 62 00 00       	mov    0x629c,%eax
     307:	83 ec 08             	sub    $0x8,%esp
     30a:	68 25 45 00 00       	push   $0x4525
     30f:	50                   	push   %eax
     310:	e8 15 3d 00 00       	call   402a <printf>
     315:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     318:	83 ec 08             	sub    $0x8,%esp
     31b:	6a 00                	push   $0x0
     31d:	68 e0 43 00 00       	push   $0x43e0
     322:	e8 ce 3b 00 00       	call   3ef5 <open>
     327:	83 c4 10             	add    $0x10,%esp
     32a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     32d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     331:	79 1b                	jns    34e <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     333:	a1 9c 62 00 00       	mov    0x629c,%eax
     338:	83 ec 08             	sub    $0x8,%esp
     33b:	68 30 45 00 00       	push   $0x4530
     340:	50                   	push   %eax
     341:	e8 e4 3c 00 00       	call   402a <printf>
     346:	83 c4 10             	add    $0x10,%esp
    exit();
     349:	e8 67 3b 00 00       	call   3eb5 <exit>
  }
  close(fd);
     34e:	83 ec 0c             	sub    $0xc,%esp
     351:	ff 75 f4             	pushl  -0xc(%ebp)
     354:	e8 84 3b 00 00       	call   3edd <close>
     359:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35c:	83 ec 08             	sub    $0x8,%esp
     35f:	6a 00                	push   $0x0
     361:	68 43 45 00 00       	push   $0x4543
     366:	e8 8a 3b 00 00       	call   3ef5 <open>
     36b:	83 c4 10             	add    $0x10,%esp
     36e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     375:	78 1b                	js     392 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     377:	a1 9c 62 00 00       	mov    0x629c,%eax
     37c:	83 ec 08             	sub    $0x8,%esp
     37f:	68 50 45 00 00       	push   $0x4550
     384:	50                   	push   %eax
     385:	e8 a0 3c 00 00       	call   402a <printf>
     38a:	83 c4 10             	add    $0x10,%esp
    exit();
     38d:	e8 23 3b 00 00       	call   3eb5 <exit>
  }
  printf(stdout, "open test ok\n");
     392:	a1 9c 62 00 00       	mov    0x629c,%eax
     397:	83 ec 08             	sub    $0x8,%esp
     39a:	68 6e 45 00 00       	push   $0x456e
     39f:	50                   	push   %eax
     3a0:	e8 85 3c 00 00       	call   402a <printf>
     3a5:	83 c4 10             	add    $0x10,%esp
}
     3a8:	c9                   	leave  
     3a9:	c3                   	ret    

000003aa <writetest>:

void
writetest(void)
{
     3aa:	55                   	push   %ebp
     3ab:	89 e5                	mov    %esp,%ebp
     3ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b0:	a1 9c 62 00 00       	mov    0x629c,%eax
     3b5:	83 ec 08             	sub    $0x8,%esp
     3b8:	68 7c 45 00 00       	push   $0x457c
     3bd:	50                   	push   %eax
     3be:	e8 67 3c 00 00       	call   402a <printf>
     3c3:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3c6:	83 ec 08             	sub    $0x8,%esp
     3c9:	68 02 02 00 00       	push   $0x202
     3ce:	68 8d 45 00 00       	push   $0x458d
     3d3:	e8 1d 3b 00 00       	call   3ef5 <open>
     3d8:	83 c4 10             	add    $0x10,%esp
     3db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e2:	78 22                	js     406 <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e4:	a1 9c 62 00 00       	mov    0x629c,%eax
     3e9:	83 ec 08             	sub    $0x8,%esp
     3ec:	68 93 45 00 00       	push   $0x4593
     3f1:	50                   	push   %eax
     3f2:	e8 33 3c 00 00       	call   402a <printf>
     3f7:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     401:	e9 8f 00 00 00       	jmp    495 <writetest+0xeb>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     406:	a1 9c 62 00 00       	mov    0x629c,%eax
     40b:	83 ec 08             	sub    $0x8,%esp
     40e:	68 ae 45 00 00       	push   $0x45ae
     413:	50                   	push   %eax
     414:	e8 11 3c 00 00       	call   402a <printf>
     419:	83 c4 10             	add    $0x10,%esp
    exit();
     41c:	e8 94 3a 00 00       	call   3eb5 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     421:	83 ec 04             	sub    $0x4,%esp
     424:	6a 0a                	push   $0xa
     426:	68 ca 45 00 00       	push   $0x45ca
     42b:	ff 75 f0             	pushl  -0x10(%ebp)
     42e:	e8 a2 3a 00 00       	call   3ed5 <write>
     433:	83 c4 10             	add    $0x10,%esp
     436:	83 f8 0a             	cmp    $0xa,%eax
     439:	74 1e                	je     459 <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43b:	a1 9c 62 00 00       	mov    0x629c,%eax
     440:	83 ec 04             	sub    $0x4,%esp
     443:	ff 75 f4             	pushl  -0xc(%ebp)
     446:	68 d8 45 00 00       	push   $0x45d8
     44b:	50                   	push   %eax
     44c:	e8 d9 3b 00 00       	call   402a <printf>
     451:	83 c4 10             	add    $0x10,%esp
      exit();
     454:	e8 5c 3a 00 00       	call   3eb5 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     459:	83 ec 04             	sub    $0x4,%esp
     45c:	6a 0a                	push   $0xa
     45e:	68 fc 45 00 00       	push   $0x45fc
     463:	ff 75 f0             	pushl  -0x10(%ebp)
     466:	e8 6a 3a 00 00       	call   3ed5 <write>
     46b:	83 c4 10             	add    $0x10,%esp
     46e:	83 f8 0a             	cmp    $0xa,%eax
     471:	74 1e                	je     491 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     473:	a1 9c 62 00 00       	mov    0x629c,%eax
     478:	83 ec 04             	sub    $0x4,%esp
     47b:	ff 75 f4             	pushl  -0xc(%ebp)
     47e:	68 08 46 00 00       	push   $0x4608
     483:	50                   	push   %eax
     484:	e8 a1 3b 00 00       	call   402a <printf>
     489:	83 c4 10             	add    $0x10,%esp
      exit();
     48c:	e8 24 3a 00 00       	call   3eb5 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     491:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     495:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     499:	7e 86                	jle    421 <writetest+0x77>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     49b:	a1 9c 62 00 00       	mov    0x629c,%eax
     4a0:	83 ec 08             	sub    $0x8,%esp
     4a3:	68 2c 46 00 00       	push   $0x462c
     4a8:	50                   	push   %eax
     4a9:	e8 7c 3b 00 00       	call   402a <printf>
     4ae:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b1:	83 ec 0c             	sub    $0xc,%esp
     4b4:	ff 75 f0             	pushl  -0x10(%ebp)
     4b7:	e8 21 3a 00 00       	call   3edd <close>
     4bc:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4bf:	83 ec 08             	sub    $0x8,%esp
     4c2:	6a 00                	push   $0x0
     4c4:	68 8d 45 00 00       	push   $0x458d
     4c9:	e8 27 3a 00 00       	call   3ef5 <open>
     4ce:	83 c4 10             	add    $0x10,%esp
     4d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4d8:	78 3c                	js     516 <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4da:	a1 9c 62 00 00       	mov    0x629c,%eax
     4df:	83 ec 08             	sub    $0x8,%esp
     4e2:	68 37 46 00 00       	push   $0x4637
     4e7:	50                   	push   %eax
     4e8:	e8 3d 3b 00 00       	call   402a <printf>
     4ed:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f0:	83 ec 04             	sub    $0x4,%esp
     4f3:	68 d0 07 00 00       	push   $0x7d0
     4f8:	68 c0 8a 00 00       	push   $0x8ac0
     4fd:	ff 75 f0             	pushl  -0x10(%ebp)
     500:	e8 c8 39 00 00       	call   3ecd <read>
     505:	83 c4 10             	add    $0x10,%esp
     508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50b:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     512:	75 57                	jne    56b <writetest+0x1c1>
     514:	eb 1b                	jmp    531 <writetest+0x187>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     516:	a1 9c 62 00 00       	mov    0x629c,%eax
     51b:	83 ec 08             	sub    $0x8,%esp
     51e:	68 50 46 00 00       	push   $0x4650
     523:	50                   	push   %eax
     524:	e8 01 3b 00 00       	call   402a <printf>
     529:	83 c4 10             	add    $0x10,%esp
    exit();
     52c:	e8 84 39 00 00       	call   3eb5 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     531:	a1 9c 62 00 00       	mov    0x629c,%eax
     536:	83 ec 08             	sub    $0x8,%esp
     539:	68 6b 46 00 00       	push   $0x466b
     53e:	50                   	push   %eax
     53f:	e8 e6 3a 00 00       	call   402a <printf>
     544:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     547:	83 ec 0c             	sub    $0xc,%esp
     54a:	ff 75 f0             	pushl  -0x10(%ebp)
     54d:	e8 8b 39 00 00       	call   3edd <close>
     552:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     555:	83 ec 0c             	sub    $0xc,%esp
     558:	68 8d 45 00 00       	push   $0x458d
     55d:	e8 a3 39 00 00       	call   3f05 <unlink>
     562:	83 c4 10             	add    $0x10,%esp
     565:	85 c0                	test   %eax,%eax
     567:	79 38                	jns    5a1 <writetest+0x1f7>
     569:	eb 1b                	jmp    586 <writetest+0x1dc>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     56b:	a1 9c 62 00 00       	mov    0x629c,%eax
     570:	83 ec 08             	sub    $0x8,%esp
     573:	68 7e 46 00 00       	push   $0x467e
     578:	50                   	push   %eax
     579:	e8 ac 3a 00 00       	call   402a <printf>
     57e:	83 c4 10             	add    $0x10,%esp
    exit();
     581:	e8 2f 39 00 00       	call   3eb5 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     586:	a1 9c 62 00 00       	mov    0x629c,%eax
     58b:	83 ec 08             	sub    $0x8,%esp
     58e:	68 8b 46 00 00       	push   $0x468b
     593:	50                   	push   %eax
     594:	e8 91 3a 00 00       	call   402a <printf>
     599:	83 c4 10             	add    $0x10,%esp
    exit();
     59c:	e8 14 39 00 00       	call   3eb5 <exit>
  }
  printf(stdout, "small file test ok\n");
     5a1:	a1 9c 62 00 00       	mov    0x629c,%eax
     5a6:	83 ec 08             	sub    $0x8,%esp
     5a9:	68 a0 46 00 00       	push   $0x46a0
     5ae:	50                   	push   %eax
     5af:	e8 76 3a 00 00       	call   402a <printf>
     5b4:	83 c4 10             	add    $0x10,%esp
}
     5b7:	c9                   	leave  
     5b8:	c3                   	ret    

000005b9 <writetest1>:

void
writetest1(void)
{
     5b9:	55                   	push   %ebp
     5ba:	89 e5                	mov    %esp,%ebp
     5bc:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5bf:	a1 9c 62 00 00       	mov    0x629c,%eax
     5c4:	83 ec 08             	sub    $0x8,%esp
     5c7:	68 b4 46 00 00       	push   $0x46b4
     5cc:	50                   	push   %eax
     5cd:	e8 58 3a 00 00       	call   402a <printf>
     5d2:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5d5:	83 ec 08             	sub    $0x8,%esp
     5d8:	68 02 02 00 00       	push   $0x202
     5dd:	68 c4 46 00 00       	push   $0x46c4
     5e2:	e8 0e 39 00 00       	call   3ef5 <open>
     5e7:	83 c4 10             	add    $0x10,%esp
     5ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f1:	79 1b                	jns    60e <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f3:	a1 9c 62 00 00       	mov    0x629c,%eax
     5f8:	83 ec 08             	sub    $0x8,%esp
     5fb:	68 c8 46 00 00       	push   $0x46c8
     600:	50                   	push   %eax
     601:	e8 24 3a 00 00       	call   402a <printf>
     606:	83 c4 10             	add    $0x10,%esp
    exit();
     609:	e8 a7 38 00 00       	call   3eb5 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     60e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     615:	eb 4b                	jmp    662 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     617:	ba c0 8a 00 00       	mov    $0x8ac0,%edx
     61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61f:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     621:	83 ec 04             	sub    $0x4,%esp
     624:	68 00 02 00 00       	push   $0x200
     629:	68 c0 8a 00 00       	push   $0x8ac0
     62e:	ff 75 ec             	pushl  -0x14(%ebp)
     631:	e8 9f 38 00 00       	call   3ed5 <write>
     636:	83 c4 10             	add    $0x10,%esp
     639:	3d 00 02 00 00       	cmp    $0x200,%eax
     63e:	74 1e                	je     65e <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     640:	a1 9c 62 00 00       	mov    0x629c,%eax
     645:	83 ec 04             	sub    $0x4,%esp
     648:	ff 75 f4             	pushl  -0xc(%ebp)
     64b:	68 e2 46 00 00       	push   $0x46e2
     650:	50                   	push   %eax
     651:	e8 d4 39 00 00       	call   402a <printf>
     656:	83 c4 10             	add    $0x10,%esp
      exit();
     659:	e8 57 38 00 00       	call   3eb5 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     65e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     662:	8b 45 f4             	mov    -0xc(%ebp),%eax
     665:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66a:	76 ab                	jbe    617 <writetest1+0x5e>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     66c:	83 ec 0c             	sub    $0xc,%esp
     66f:	ff 75 ec             	pushl  -0x14(%ebp)
     672:	e8 66 38 00 00       	call   3edd <close>
     677:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67a:	83 ec 08             	sub    $0x8,%esp
     67d:	6a 00                	push   $0x0
     67f:	68 c4 46 00 00       	push   $0x46c4
     684:	e8 6c 38 00 00       	call   3ef5 <open>
     689:	83 c4 10             	add    $0x10,%esp
     68c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     68f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     693:	79 1b                	jns    6b0 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     695:	a1 9c 62 00 00       	mov    0x629c,%eax
     69a:	83 ec 08             	sub    $0x8,%esp
     69d:	68 00 47 00 00       	push   $0x4700
     6a2:	50                   	push   %eax
     6a3:	e8 82 39 00 00       	call   402a <printf>
     6a8:	83 c4 10             	add    $0x10,%esp
    exit();
     6ab:	e8 05 38 00 00       	call   3eb5 <exit>
  }

  n = 0;
     6b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6b7:	83 ec 04             	sub    $0x4,%esp
     6ba:	68 00 02 00 00       	push   $0x200
     6bf:	68 c0 8a 00 00       	push   $0x8ac0
     6c4:	ff 75 ec             	pushl  -0x14(%ebp)
     6c7:	e8 01 38 00 00       	call   3ecd <read>
     6cc:	83 c4 10             	add    $0x10,%esp
     6cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6d6:	75 4c                	jne    724 <writetest1+0x16b>
      if(n == MAXFILE - 1){
     6d8:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6df:	75 1e                	jne    6ff <writetest1+0x146>
        printf(stdout, "read only %d blocks from big", n);
     6e1:	a1 9c 62 00 00       	mov    0x629c,%eax
     6e6:	83 ec 04             	sub    $0x4,%esp
     6e9:	ff 75 f0             	pushl  -0x10(%ebp)
     6ec:	68 19 47 00 00       	push   $0x4719
     6f1:	50                   	push   %eax
     6f2:	e8 33 39 00 00       	call   402a <printf>
     6f7:	83 c4 10             	add    $0x10,%esp
        exit();
     6fa:	e8 b6 37 00 00       	call   3eb5 <exit>
      }
      break;
     6ff:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     700:	83 ec 0c             	sub    $0xc,%esp
     703:	ff 75 ec             	pushl  -0x14(%ebp)
     706:	e8 d2 37 00 00       	call   3edd <close>
     70b:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     70e:	83 ec 0c             	sub    $0xc,%esp
     711:	68 c4 46 00 00       	push   $0x46c4
     716:	e8 ea 37 00 00       	call   3f05 <unlink>
     71b:	83 c4 10             	add    $0x10,%esp
     71e:	85 c0                	test   %eax,%eax
     720:	79 7c                	jns    79e <writetest1+0x1e5>
     722:	eb 5f                	jmp    783 <writetest1+0x1ca>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     724:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     72b:	74 1e                	je     74b <writetest1+0x192>
      printf(stdout, "read failed %d\n", i);
     72d:	a1 9c 62 00 00       	mov    0x629c,%eax
     732:	83 ec 04             	sub    $0x4,%esp
     735:	ff 75 f4             	pushl  -0xc(%ebp)
     738:	68 36 47 00 00       	push   $0x4736
     73d:	50                   	push   %eax
     73e:	e8 e7 38 00 00       	call   402a <printf>
     743:	83 c4 10             	add    $0x10,%esp
      exit();
     746:	e8 6a 37 00 00       	call   3eb5 <exit>
    }
    if(((int*)buf)[0] != n){
     74b:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
     750:	8b 00                	mov    (%eax),%eax
     752:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     755:	74 23                	je     77a <writetest1+0x1c1>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     757:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     75c:	8b 10                	mov    (%eax),%edx
     75e:	a1 9c 62 00 00       	mov    0x629c,%eax
     763:	52                   	push   %edx
     764:	ff 75 f0             	pushl  -0x10(%ebp)
     767:	68 48 47 00 00       	push   $0x4748
     76c:	50                   	push   %eax
     76d:	e8 b8 38 00 00       	call   402a <printf>
     772:	83 c4 10             	add    $0x10,%esp
             n, ((int*)buf)[0]);
      exit();
     775:	e8 3b 37 00 00       	call   3eb5 <exit>
    }
    n++;
     77a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     77e:	e9 34 ff ff ff       	jmp    6b7 <writetest1+0xfe>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     783:	a1 9c 62 00 00       	mov    0x629c,%eax
     788:	83 ec 08             	sub    $0x8,%esp
     78b:	68 68 47 00 00       	push   $0x4768
     790:	50                   	push   %eax
     791:	e8 94 38 00 00       	call   402a <printf>
     796:	83 c4 10             	add    $0x10,%esp
    exit();
     799:	e8 17 37 00 00       	call   3eb5 <exit>
  }
  printf(stdout, "big files ok\n");
     79e:	a1 9c 62 00 00       	mov    0x629c,%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	68 7b 47 00 00       	push   $0x477b
     7ab:	50                   	push   %eax
     7ac:	e8 79 38 00 00       	call   402a <printf>
     7b1:	83 c4 10             	add    $0x10,%esp
}
     7b4:	c9                   	leave  
     7b5:	c3                   	ret    

000007b6 <createtest>:

void
createtest(void)
{
     7b6:	55                   	push   %ebp
     7b7:	89 e5                	mov    %esp,%ebp
     7b9:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7bc:	a1 9c 62 00 00       	mov    0x629c,%eax
     7c1:	83 ec 08             	sub    $0x8,%esp
     7c4:	68 8c 47 00 00       	push   $0x478c
     7c9:	50                   	push   %eax
     7ca:	e8 5b 38 00 00       	call   402a <printf>
     7cf:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d2:	c6 05 c0 aa 00 00 61 	movb   $0x61,0xaac0
  name[2] = '\0';
     7d9:	c6 05 c2 aa 00 00 00 	movb   $0x0,0xaac2
  for(i = 0; i < 52; i++){
     7e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7e7:	eb 35                	jmp    81e <createtest+0x68>
    name[1] = '0' + i;
     7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ec:	83 c0 30             	add    $0x30,%eax
     7ef:	a2 c1 aa 00 00       	mov    %al,0xaac1
    fd = open(name, O_CREATE|O_RDWR);
     7f4:	83 ec 08             	sub    $0x8,%esp
     7f7:	68 02 02 00 00       	push   $0x202
     7fc:	68 c0 aa 00 00       	push   $0xaac0
     801:	e8 ef 36 00 00       	call   3ef5 <open>
     806:	83 c4 10             	add    $0x10,%esp
     809:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     80c:	83 ec 0c             	sub    $0xc,%esp
     80f:	ff 75 f0             	pushl  -0x10(%ebp)
     812:	e8 c6 36 00 00       	call   3edd <close>
     817:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     81a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     81e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     822:	7e c5                	jle    7e9 <createtest+0x33>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     824:	c6 05 c0 aa 00 00 61 	movb   $0x61,0xaac0
  name[2] = '\0';
     82b:	c6 05 c2 aa 00 00 00 	movb   $0x0,0xaac2
  for(i = 0; i < 52; i++){
     832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     839:	eb 1f                	jmp    85a <createtest+0xa4>
    name[1] = '0' + i;
     83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83e:	83 c0 30             	add    $0x30,%eax
     841:	a2 c1 aa 00 00       	mov    %al,0xaac1
    unlink(name);
     846:	83 ec 0c             	sub    $0xc,%esp
     849:	68 c0 aa 00 00       	push   $0xaac0
     84e:	e8 b2 36 00 00       	call   3f05 <unlink>
     853:	83 c4 10             	add    $0x10,%esp
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     856:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85a:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     85e:	7e db                	jle    83b <createtest+0x85>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     860:	a1 9c 62 00 00       	mov    0x629c,%eax
     865:	83 ec 08             	sub    $0x8,%esp
     868:	68 b4 47 00 00       	push   $0x47b4
     86d:	50                   	push   %eax
     86e:	e8 b7 37 00 00       	call   402a <printf>
     873:	83 c4 10             	add    $0x10,%esp
}
     876:	c9                   	leave  
     877:	c3                   	ret    

00000878 <dirtest>:

void dirtest(void)
{
     878:	55                   	push   %ebp
     879:	89 e5                	mov    %esp,%ebp
     87b:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     87e:	a1 9c 62 00 00       	mov    0x629c,%eax
     883:	83 ec 08             	sub    $0x8,%esp
     886:	68 da 47 00 00       	push   $0x47da
     88b:	50                   	push   %eax
     88c:	e8 99 37 00 00       	call   402a <printf>
     891:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     894:	83 ec 0c             	sub    $0xc,%esp
     897:	68 e6 47 00 00       	push   $0x47e6
     89c:	e8 7c 36 00 00       	call   3f1d <mkdir>
     8a1:	83 c4 10             	add    $0x10,%esp
     8a4:	85 c0                	test   %eax,%eax
     8a6:	79 1b                	jns    8c3 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8a8:	a1 9c 62 00 00       	mov    0x629c,%eax
     8ad:	83 ec 08             	sub    $0x8,%esp
     8b0:	68 09 44 00 00       	push   $0x4409
     8b5:	50                   	push   %eax
     8b6:	e8 6f 37 00 00       	call   402a <printf>
     8bb:	83 c4 10             	add    $0x10,%esp
    exit();
     8be:	e8 f2 35 00 00       	call   3eb5 <exit>
  }

  if(chdir("dir0") < 0){
     8c3:	83 ec 0c             	sub    $0xc,%esp
     8c6:	68 e6 47 00 00       	push   $0x47e6
     8cb:	e8 55 36 00 00       	call   3f25 <chdir>
     8d0:	83 c4 10             	add    $0x10,%esp
     8d3:	85 c0                	test   %eax,%eax
     8d5:	79 1b                	jns    8f2 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8d7:	a1 9c 62 00 00       	mov    0x629c,%eax
     8dc:	83 ec 08             	sub    $0x8,%esp
     8df:	68 eb 47 00 00       	push   $0x47eb
     8e4:	50                   	push   %eax
     8e5:	e8 40 37 00 00       	call   402a <printf>
     8ea:	83 c4 10             	add    $0x10,%esp
    exit();
     8ed:	e8 c3 35 00 00       	call   3eb5 <exit>
  }

  if(chdir("..") < 0){
     8f2:	83 ec 0c             	sub    $0xc,%esp
     8f5:	68 fe 47 00 00       	push   $0x47fe
     8fa:	e8 26 36 00 00       	call   3f25 <chdir>
     8ff:	83 c4 10             	add    $0x10,%esp
     902:	85 c0                	test   %eax,%eax
     904:	79 1b                	jns    921 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     906:	a1 9c 62 00 00       	mov    0x629c,%eax
     90b:	83 ec 08             	sub    $0x8,%esp
     90e:	68 01 48 00 00       	push   $0x4801
     913:	50                   	push   %eax
     914:	e8 11 37 00 00       	call   402a <printf>
     919:	83 c4 10             	add    $0x10,%esp
    exit();
     91c:	e8 94 35 00 00       	call   3eb5 <exit>
  }

  if(unlink("dir0") < 0){
     921:	83 ec 0c             	sub    $0xc,%esp
     924:	68 e6 47 00 00       	push   $0x47e6
     929:	e8 d7 35 00 00       	call   3f05 <unlink>
     92e:	83 c4 10             	add    $0x10,%esp
     931:	85 c0                	test   %eax,%eax
     933:	79 1b                	jns    950 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     935:	a1 9c 62 00 00       	mov    0x629c,%eax
     93a:	83 ec 08             	sub    $0x8,%esp
     93d:	68 12 48 00 00       	push   $0x4812
     942:	50                   	push   %eax
     943:	e8 e2 36 00 00       	call   402a <printf>
     948:	83 c4 10             	add    $0x10,%esp
    exit();
     94b:	e8 65 35 00 00       	call   3eb5 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     950:	a1 9c 62 00 00       	mov    0x629c,%eax
     955:	83 ec 08             	sub    $0x8,%esp
     958:	68 26 48 00 00       	push   $0x4826
     95d:	50                   	push   %eax
     95e:	e8 c7 36 00 00       	call   402a <printf>
     963:	83 c4 10             	add    $0x10,%esp
}
     966:	c9                   	leave  
     967:	c3                   	ret    

00000968 <exectest>:

void
exectest(void)
{
     968:	55                   	push   %ebp
     969:	89 e5                	mov    %esp,%ebp
     96b:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     96e:	a1 9c 62 00 00       	mov    0x629c,%eax
     973:	83 ec 08             	sub    $0x8,%esp
     976:	68 35 48 00 00       	push   $0x4835
     97b:	50                   	push   %eax
     97c:	e8 a9 36 00 00       	call   402a <printf>
     981:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     984:	83 ec 08             	sub    $0x8,%esp
     987:	68 88 62 00 00       	push   $0x6288
     98c:	68 e0 43 00 00       	push   $0x43e0
     991:	e8 57 35 00 00       	call   3eed <exec>
     996:	83 c4 10             	add    $0x10,%esp
     999:	85 c0                	test   %eax,%eax
     99b:	79 1b                	jns    9b8 <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     99d:	a1 9c 62 00 00       	mov    0x629c,%eax
     9a2:	83 ec 08             	sub    $0x8,%esp
     9a5:	68 40 48 00 00       	push   $0x4840
     9aa:	50                   	push   %eax
     9ab:	e8 7a 36 00 00       	call   402a <printf>
     9b0:	83 c4 10             	add    $0x10,%esp
    exit();
     9b3:	e8 fd 34 00 00       	call   3eb5 <exit>
  }
}
     9b8:	c9                   	leave  
     9b9:	c3                   	ret    

000009ba <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9ba:	55                   	push   %ebp
     9bb:	89 e5                	mov    %esp,%ebp
     9bd:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c0:	83 ec 0c             	sub    $0xc,%esp
     9c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9c6:	50                   	push   %eax
     9c7:	e8 f9 34 00 00       	call   3ec5 <pipe>
     9cc:	83 c4 10             	add    $0x10,%esp
     9cf:	85 c0                	test   %eax,%eax
     9d1:	74 17                	je     9ea <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9d3:	83 ec 08             	sub    $0x8,%esp
     9d6:	68 52 48 00 00       	push   $0x4852
     9db:	6a 01                	push   $0x1
     9dd:	e8 48 36 00 00       	call   402a <printf>
     9e2:	83 c4 10             	add    $0x10,%esp
    exit();
     9e5:	e8 cb 34 00 00       	call   3eb5 <exit>
  }
  pid = fork();
     9ea:	e8 be 34 00 00       	call   3ead <fork>
     9ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9fd:	0f 85 89 00 00 00    	jne    a8c <pipe1+0xd2>
    close(fds[0]);
     a03:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a06:	83 ec 0c             	sub    $0xc,%esp
     a09:	50                   	push   %eax
     a0a:	e8 ce 34 00 00       	call   3edd <close>
     a0f:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a19:	eb 66                	jmp    a81 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a22:	eb 19                	jmp    a3d <pipe1+0x83>
        buf[i] = seq++;
     a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a27:	8d 50 01             	lea    0x1(%eax),%edx
     a2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a2d:	89 c2                	mov    %eax,%edx
     a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a32:	05 c0 8a 00 00       	add    $0x8ac0,%eax
     a37:	88 10                	mov    %dl,(%eax)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     a39:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a3d:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a44:	7e de                	jle    a24 <pipe1+0x6a>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     a46:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a49:	83 ec 04             	sub    $0x4,%esp
     a4c:	68 09 04 00 00       	push   $0x409
     a51:	68 c0 8a 00 00       	push   $0x8ac0
     a56:	50                   	push   %eax
     a57:	e8 79 34 00 00       	call   3ed5 <write>
     a5c:	83 c4 10             	add    $0x10,%esp
     a5f:	3d 09 04 00 00       	cmp    $0x409,%eax
     a64:	74 17                	je     a7d <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a66:	83 ec 08             	sub    $0x8,%esp
     a69:	68 61 48 00 00       	push   $0x4861
     a6e:	6a 01                	push   $0x1
     a70:	e8 b5 35 00 00       	call   402a <printf>
     a75:	83 c4 10             	add    $0x10,%esp
        exit();
     a78:	e8 38 34 00 00       	call   3eb5 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a7d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a81:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a85:	7e 94                	jle    a1b <pipe1+0x61>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a87:	e8 29 34 00 00       	call   3eb5 <exit>
  } else if(pid > 0){
     a8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a90:	0f 8e f4 00 00 00    	jle    b8a <pipe1+0x1d0>
    close(fds[1]);
     a96:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a99:	83 ec 0c             	sub    $0xc,%esp
     a9c:	50                   	push   %eax
     a9d:	e8 3b 34 00 00       	call   3edd <close>
     aa2:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     aac:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     ab3:	eb 66                	jmp    b1b <pipe1+0x161>
      for(i = 0; i < n; i++){
     ab5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     abc:	eb 3b                	jmp    af9 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac1:	05 c0 8a 00 00       	add    $0x8ac0,%eax
     ac6:	0f b6 00             	movzbl (%eax),%eax
     ac9:	0f be c8             	movsbl %al,%ecx
     acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     acf:	8d 50 01             	lea    0x1(%eax),%edx
     ad2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ad5:	31 c8                	xor    %ecx,%eax
     ad7:	0f b6 c0             	movzbl %al,%eax
     ada:	85 c0                	test   %eax,%eax
     adc:	74 17                	je     af5 <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ade:	83 ec 08             	sub    $0x8,%esp
     ae1:	68 6f 48 00 00       	push   $0x486f
     ae6:	6a 01                	push   $0x1
     ae8:	e8 3d 35 00 00       	call   402a <printf>
     aed:	83 c4 10             	add    $0x10,%esp
     af0:	e9 ac 00 00 00       	jmp    ba1 <pipe1+0x1e7>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     af5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     afc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     aff:	7c bd                	jl     abe <pipe1+0x104>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b04:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b07:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b0d:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b12:	76 07                	jbe    b1b <pipe1+0x161>
        cc = sizeof(buf);
     b14:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     b1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b1e:	83 ec 04             	sub    $0x4,%esp
     b21:	ff 75 e8             	pushl  -0x18(%ebp)
     b24:	68 c0 8a 00 00       	push   $0x8ac0
     b29:	50                   	push   %eax
     b2a:	e8 9e 33 00 00       	call   3ecd <read>
     b2f:	83 c4 10             	add    $0x10,%esp
     b32:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b39:	0f 8f 76 ff ff ff    	jg     ab5 <pipe1+0xfb>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     b3f:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b46:	74 1a                	je     b62 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b48:	83 ec 04             	sub    $0x4,%esp
     b4b:	ff 75 e4             	pushl  -0x1c(%ebp)
     b4e:	68 7d 48 00 00       	push   $0x487d
     b53:	6a 01                	push   $0x1
     b55:	e8 d0 34 00 00       	call   402a <printf>
     b5a:	83 c4 10             	add    $0x10,%esp
      exit();
     b5d:	e8 53 33 00 00       	call   3eb5 <exit>
    }
    close(fds[0]);
     b62:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b65:	83 ec 0c             	sub    $0xc,%esp
     b68:	50                   	push   %eax
     b69:	e8 6f 33 00 00       	call   3edd <close>
     b6e:	83 c4 10             	add    $0x10,%esp
    wait();
     b71:	e8 47 33 00 00       	call   3ebd <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b76:	83 ec 08             	sub    $0x8,%esp
     b79:	68 a3 48 00 00       	push   $0x48a3
     b7e:	6a 01                	push   $0x1
     b80:	e8 a5 34 00 00       	call   402a <printf>
     b85:	83 c4 10             	add    $0x10,%esp
     b88:	eb 17                	jmp    ba1 <pipe1+0x1e7>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b8a:	83 ec 08             	sub    $0x8,%esp
     b8d:	68 94 48 00 00       	push   $0x4894
     b92:	6a 01                	push   $0x1
     b94:	e8 91 34 00 00       	call   402a <printf>
     b99:	83 c4 10             	add    $0x10,%esp
    exit();
     b9c:	e8 14 33 00 00       	call   3eb5 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     ba1:	c9                   	leave  
     ba2:	c3                   	ret    

00000ba3 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     ba3:	55                   	push   %ebp
     ba4:	89 e5                	mov    %esp,%ebp
     ba6:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     ba9:	83 ec 08             	sub    $0x8,%esp
     bac:	68 ad 48 00 00       	push   $0x48ad
     bb1:	6a 01                	push   $0x1
     bb3:	e8 72 34 00 00       	call   402a <printf>
     bb8:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bbb:	e8 ed 32 00 00       	call   3ead <fork>
     bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bc7:	75 02                	jne    bcb <preempt+0x28>
    for(;;)
      ;
     bc9:	eb fe                	jmp    bc9 <preempt+0x26>

  pid2 = fork();
     bcb:	e8 dd 32 00 00       	call   3ead <fork>
     bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bd7:	75 02                	jne    bdb <preempt+0x38>
    for(;;)
      ;
     bd9:	eb fe                	jmp    bd9 <preempt+0x36>

  pipe(pfds);
     bdb:	83 ec 0c             	sub    $0xc,%esp
     bde:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be1:	50                   	push   %eax
     be2:	e8 de 32 00 00       	call   3ec5 <pipe>
     be7:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bea:	e8 be 32 00 00       	call   3ead <fork>
     bef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bf2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bf6:	75 4d                	jne    c45 <preempt+0xa2>
    close(pfds[0]);
     bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bfb:	83 ec 0c             	sub    $0xc,%esp
     bfe:	50                   	push   %eax
     bff:	e8 d9 32 00 00       	call   3edd <close>
     c04:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c07:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c0a:	83 ec 04             	sub    $0x4,%esp
     c0d:	6a 01                	push   $0x1
     c0f:	68 b7 48 00 00       	push   $0x48b7
     c14:	50                   	push   %eax
     c15:	e8 bb 32 00 00       	call   3ed5 <write>
     c1a:	83 c4 10             	add    $0x10,%esp
     c1d:	83 f8 01             	cmp    $0x1,%eax
     c20:	74 12                	je     c34 <preempt+0x91>
      printf(1, "preempt write error");
     c22:	83 ec 08             	sub    $0x8,%esp
     c25:	68 b9 48 00 00       	push   $0x48b9
     c2a:	6a 01                	push   $0x1
     c2c:	e8 f9 33 00 00       	call   402a <printf>
     c31:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c37:	83 ec 0c             	sub    $0xc,%esp
     c3a:	50                   	push   %eax
     c3b:	e8 9d 32 00 00       	call   3edd <close>
     c40:	83 c4 10             	add    $0x10,%esp
    for(;;)
      ;
     c43:	eb fe                	jmp    c43 <preempt+0xa0>
  }

  close(pfds[1]);
     c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c48:	83 ec 0c             	sub    $0xc,%esp
     c4b:	50                   	push   %eax
     c4c:	e8 8c 32 00 00       	call   3edd <close>
     c51:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c57:	83 ec 04             	sub    $0x4,%esp
     c5a:	68 00 20 00 00       	push   $0x2000
     c5f:	68 c0 8a 00 00       	push   $0x8ac0
     c64:	50                   	push   %eax
     c65:	e8 63 32 00 00       	call   3ecd <read>
     c6a:	83 c4 10             	add    $0x10,%esp
     c6d:	83 f8 01             	cmp    $0x1,%eax
     c70:	74 14                	je     c86 <preempt+0xe3>
    printf(1, "preempt read error");
     c72:	83 ec 08             	sub    $0x8,%esp
     c75:	68 cd 48 00 00       	push   $0x48cd
     c7a:	6a 01                	push   $0x1
     c7c:	e8 a9 33 00 00       	call   402a <printf>
     c81:	83 c4 10             	add    $0x10,%esp
     c84:	eb 7e                	jmp    d04 <preempt+0x161>
    return;
  }
  close(pfds[0]);
     c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c89:	83 ec 0c             	sub    $0xc,%esp
     c8c:	50                   	push   %eax
     c8d:	e8 4b 32 00 00       	call   3edd <close>
     c92:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c95:	83 ec 08             	sub    $0x8,%esp
     c98:	68 e0 48 00 00       	push   $0x48e0
     c9d:	6a 01                	push   $0x1
     c9f:	e8 86 33 00 00       	call   402a <printf>
     ca4:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     ca7:	83 ec 0c             	sub    $0xc,%esp
     caa:	ff 75 f4             	pushl  -0xc(%ebp)
     cad:	e8 33 32 00 00       	call   3ee5 <kill>
     cb2:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     cb5:	83 ec 0c             	sub    $0xc,%esp
     cb8:	ff 75 f0             	pushl  -0x10(%ebp)
     cbb:	e8 25 32 00 00       	call   3ee5 <kill>
     cc0:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cc3:	83 ec 0c             	sub    $0xc,%esp
     cc6:	ff 75 ec             	pushl  -0x14(%ebp)
     cc9:	e8 17 32 00 00       	call   3ee5 <kill>
     cce:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cd1:	83 ec 08             	sub    $0x8,%esp
     cd4:	68 e9 48 00 00       	push   $0x48e9
     cd9:	6a 01                	push   $0x1
     cdb:	e8 4a 33 00 00       	call   402a <printf>
     ce0:	83 c4 10             	add    $0x10,%esp
  wait();
     ce3:	e8 d5 31 00 00       	call   3ebd <wait>
  wait();
     ce8:	e8 d0 31 00 00       	call   3ebd <wait>
  wait();
     ced:	e8 cb 31 00 00       	call   3ebd <wait>
  printf(1, "preempt ok\n");
     cf2:	83 ec 08             	sub    $0x8,%esp
     cf5:	68 f2 48 00 00       	push   $0x48f2
     cfa:	6a 01                	push   $0x1
     cfc:	e8 29 33 00 00       	call   402a <printf>
     d01:	83 c4 10             	add    $0x10,%esp
}
     d04:	c9                   	leave  
     d05:	c3                   	ret    

00000d06 <exitwait>:

// try to find any races between exit and wait
void 
exitwait(void)
{
     d06:	55                   	push   %ebp
     d07:	89 e5                	mov    %esp,%ebp
     d09:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d13:	eb 4f                	jmp    d64 <exitwait+0x5e>
    pid = fork();
     d15:	e8 93 31 00 00       	call   3ead <fork>
     d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d21:	79 14                	jns    d37 <exitwait+0x31>
      printf(1, "fork failed\n");
     d23:	83 ec 08             	sub    $0x8,%esp
     d26:	68 81 44 00 00       	push   $0x4481
     d2b:	6a 01                	push   $0x1
     d2d:	e8 f8 32 00 00       	call   402a <printf>
     d32:	83 c4 10             	add    $0x10,%esp
      return;
     d35:	eb 45                	jmp    d7c <exitwait+0x76>
    }
    if(pid){
     d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d3b:	74 1e                	je     d5b <exitwait+0x55>
      if(wait() != pid){
     d3d:	e8 7b 31 00 00       	call   3ebd <wait>
     d42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     d45:	74 19                	je     d60 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d47:	83 ec 08             	sub    $0x8,%esp
     d4a:	68 fe 48 00 00       	push   $0x48fe
     d4f:	6a 01                	push   $0x1
     d51:	e8 d4 32 00 00       	call   402a <printf>
     d56:	83 c4 10             	add    $0x10,%esp
        return;
     d59:	eb 21                	jmp    d7c <exitwait+0x76>
      }
    } else {
      exit();
     d5b:	e8 55 31 00 00       	call   3eb5 <exit>
void 
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d64:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d68:	7e ab                	jle    d15 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d6a:	83 ec 08             	sub    $0x8,%esp
     d6d:	68 0e 49 00 00       	push   $0x490e
     d72:	6a 01                	push   $0x1
     d74:	e8 b1 32 00 00       	call   402a <printf>
     d79:	83 c4 10             	add    $0x10,%esp
}
     d7c:	c9                   	leave  
     d7d:	c3                   	ret    

00000d7e <mem>:

void
mem(void)
{
     d7e:	55                   	push   %ebp
     d7f:	89 e5                	mov    %esp,%ebp
     d81:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d84:	83 ec 08             	sub    $0x8,%esp
     d87:	68 1b 49 00 00       	push   $0x491b
     d8c:	6a 01                	push   $0x1
     d8e:	e8 97 32 00 00       	call   402a <printf>
     d93:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     d96:	e8 9a 31 00 00       	call   3f35 <getpid>
     d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d9e:	e8 0a 31 00 00       	call   3ead <fork>
     da3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     da6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     daa:	0f 85 b7 00 00 00    	jne    e67 <mem+0xe9>
    m1 = 0;
     db0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     db7:	eb 0e                	jmp    dc7 <mem+0x49>
      *(char**)m2 = m1;
     db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dbf:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     dc7:	83 ec 0c             	sub    $0xc,%esp
     dca:	68 11 27 00 00       	push   $0x2711
     dcf:	e8 27 35 00 00       	call   42fb <malloc>
     dd4:	83 c4 10             	add    $0x10,%esp
     dd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     dda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dde:	75 d9                	jne    db9 <mem+0x3b>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     de0:	eb 1c                	jmp    dfe <mem+0x80>
      m2 = *(char**)m1;
     de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de5:	8b 00                	mov    (%eax),%eax
     de7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     dea:	83 ec 0c             	sub    $0xc,%esp
     ded:	ff 75 f4             	pushl  -0xc(%ebp)
     df0:	e8 c5 33 00 00       	call   41ba <free>
     df5:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e02:	75 de                	jne    de2 <mem+0x64>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     e04:	83 ec 0c             	sub    $0xc,%esp
     e07:	68 00 50 00 00       	push   $0x5000
     e0c:	e8 ea 34 00 00       	call   42fb <malloc>
     e11:	83 c4 10             	add    $0x10,%esp
     e14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e1b:	75 25                	jne    e42 <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     e1d:	83 ec 08             	sub    $0x8,%esp
     e20:	68 25 49 00 00       	push   $0x4925
     e25:	6a 01                	push   $0x1
     e27:	e8 fe 31 00 00       	call   402a <printf>
     e2c:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e2f:	83 ec 0c             	sub    $0xc,%esp
     e32:	ff 75 f0             	pushl  -0x10(%ebp)
     e35:	e8 ab 30 00 00       	call   3ee5 <kill>
     e3a:	83 c4 10             	add    $0x10,%esp
      exit();
     e3d:	e8 73 30 00 00       	call   3eb5 <exit>
    }
    free(m1);
     e42:	83 ec 0c             	sub    $0xc,%esp
     e45:	ff 75 f4             	pushl  -0xc(%ebp)
     e48:	e8 6d 33 00 00       	call   41ba <free>
     e4d:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e50:	83 ec 08             	sub    $0x8,%esp
     e53:	68 3f 49 00 00       	push   $0x493f
     e58:	6a 01                	push   $0x1
     e5a:	e8 cb 31 00 00       	call   402a <printf>
     e5f:	83 c4 10             	add    $0x10,%esp
    exit();
     e62:	e8 4e 30 00 00       	call   3eb5 <exit>
  } else {
    wait();
     e67:	e8 51 30 00 00       	call   3ebd <wait>
  }
}
     e6c:	c9                   	leave  
     e6d:	c3                   	ret    

00000e6e <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e6e:	55                   	push   %ebp
     e6f:	89 e5                	mov    %esp,%ebp
     e71:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e74:	83 ec 08             	sub    $0x8,%esp
     e77:	68 47 49 00 00       	push   $0x4947
     e7c:	6a 01                	push   $0x1
     e7e:	e8 a7 31 00 00       	call   402a <printf>
     e83:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e86:	83 ec 0c             	sub    $0xc,%esp
     e89:	68 56 49 00 00       	push   $0x4956
     e8e:	e8 72 30 00 00       	call   3f05 <unlink>
     e93:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e96:	83 ec 08             	sub    $0x8,%esp
     e99:	68 02 02 00 00       	push   $0x202
     e9e:	68 56 49 00 00       	push   $0x4956
     ea3:	e8 4d 30 00 00       	call   3ef5 <open>
     ea8:	83 c4 10             	add    $0x10,%esp
     eab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     eae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     eb2:	79 17                	jns    ecb <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     eb4:	83 ec 08             	sub    $0x8,%esp
     eb7:	68 60 49 00 00       	push   $0x4960
     ebc:	6a 01                	push   $0x1
     ebe:	e8 67 31 00 00       	call   402a <printf>
     ec3:	83 c4 10             	add    $0x10,%esp
    return;
     ec6:	e9 84 01 00 00       	jmp    104f <sharedfd+0x1e1>
  }
  pid = fork();
     ecb:	e8 dd 2f 00 00       	call   3ead <fork>
     ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ed3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ed7:	75 07                	jne    ee0 <sharedfd+0x72>
     ed9:	b8 63 00 00 00       	mov    $0x63,%eax
     ede:	eb 05                	jmp    ee5 <sharedfd+0x77>
     ee0:	b8 70 00 00 00       	mov    $0x70,%eax
     ee5:	83 ec 04             	sub    $0x4,%esp
     ee8:	6a 0a                	push   $0xa
     eea:	50                   	push   %eax
     eeb:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     eee:	50                   	push   %eax
     eef:	e8 27 2e 00 00       	call   3d1b <memset>
     ef4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     efe:	eb 31                	jmp    f31 <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f00:	83 ec 04             	sub    $0x4,%esp
     f03:	6a 0a                	push   $0xa
     f05:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f08:	50                   	push   %eax
     f09:	ff 75 e8             	pushl  -0x18(%ebp)
     f0c:	e8 c4 2f 00 00       	call   3ed5 <write>
     f11:	83 c4 10             	add    $0x10,%esp
     f14:	83 f8 0a             	cmp    $0xa,%eax
     f17:	74 14                	je     f2d <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f19:	83 ec 08             	sub    $0x8,%esp
     f1c:	68 8c 49 00 00       	push   $0x498c
     f21:	6a 01                	push   $0x1
     f23:	e8 02 31 00 00       	call   402a <printf>
     f28:	83 c4 10             	add    $0x10,%esp
      break;
     f2b:	eb 0d                	jmp    f3a <sharedfd+0xcc>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     f2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f31:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f38:	7e c6                	jle    f00 <sharedfd+0x92>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     f3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f3e:	75 05                	jne    f45 <sharedfd+0xd7>
    exit();
     f40:	e8 70 2f 00 00       	call   3eb5 <exit>
  else
    wait();
     f45:	e8 73 2f 00 00       	call   3ebd <wait>
  close(fd);
     f4a:	83 ec 0c             	sub    $0xc,%esp
     f4d:	ff 75 e8             	pushl  -0x18(%ebp)
     f50:	e8 88 2f 00 00       	call   3edd <close>
     f55:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f58:	83 ec 08             	sub    $0x8,%esp
     f5b:	6a 00                	push   $0x0
     f5d:	68 56 49 00 00       	push   $0x4956
     f62:	e8 8e 2f 00 00       	call   3ef5 <open>
     f67:	83 c4 10             	add    $0x10,%esp
     f6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f71:	79 17                	jns    f8a <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f73:	83 ec 08             	sub    $0x8,%esp
     f76:	68 ac 49 00 00       	push   $0x49ac
     f7b:	6a 01                	push   $0x1
     f7d:	e8 a8 30 00 00       	call   402a <printf>
     f82:	83 c4 10             	add    $0x10,%esp
    return;
     f85:	e9 c5 00 00 00       	jmp    104f <sharedfd+0x1e1>
  }
  nc = np = 0;
     f8a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f97:	eb 3b                	jmp    fd4 <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     f99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fa0:	eb 2a                	jmp    fcc <sharedfd+0x15e>
      if(buf[i] == 'c')
     fa2:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fa8:	01 d0                	add    %edx,%eax
     faa:	0f b6 00             	movzbl (%eax),%eax
     fad:	3c 63                	cmp    $0x63,%al
     faf:	75 04                	jne    fb5 <sharedfd+0x147>
        nc++;
     fb1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     fb5:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fbb:	01 d0                	add    %edx,%eax
     fbd:	0f b6 00             	movzbl (%eax),%eax
     fc0:	3c 70                	cmp    $0x70,%al
     fc2:	75 04                	jne    fc8 <sharedfd+0x15a>
        np++;
     fc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     fc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fcf:	83 f8 09             	cmp    $0x9,%eax
     fd2:	76 ce                	jbe    fa2 <sharedfd+0x134>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fd4:	83 ec 04             	sub    $0x4,%esp
     fd7:	6a 0a                	push   $0xa
     fd9:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fdc:	50                   	push   %eax
     fdd:	ff 75 e8             	pushl  -0x18(%ebp)
     fe0:	e8 e8 2e 00 00       	call   3ecd <read>
     fe5:	83 c4 10             	add    $0x10,%esp
     fe8:	89 45 e0             	mov    %eax,-0x20(%ebp)
     feb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fef:	7f a8                	jg     f99 <sharedfd+0x12b>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     ff1:	83 ec 0c             	sub    $0xc,%esp
     ff4:	ff 75 e8             	pushl  -0x18(%ebp)
     ff7:	e8 e1 2e 00 00       	call   3edd <close>
     ffc:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
     fff:	83 ec 0c             	sub    $0xc,%esp
    1002:	68 56 49 00 00       	push   $0x4956
    1007:	e8 f9 2e 00 00       	call   3f05 <unlink>
    100c:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    100f:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1016:	75 1d                	jne    1035 <sharedfd+0x1c7>
    1018:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    101f:	75 14                	jne    1035 <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    1021:	83 ec 08             	sub    $0x8,%esp
    1024:	68 d7 49 00 00       	push   $0x49d7
    1029:	6a 01                	push   $0x1
    102b:	e8 fa 2f 00 00       	call   402a <printf>
    1030:	83 c4 10             	add    $0x10,%esp
    1033:	eb 1a                	jmp    104f <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1035:	ff 75 ec             	pushl  -0x14(%ebp)
    1038:	ff 75 f0             	pushl  -0x10(%ebp)
    103b:	68 e4 49 00 00       	push   $0x49e4
    1040:	6a 01                	push   $0x1
    1042:	e8 e3 2f 00 00       	call   402a <printf>
    1047:	83 c4 10             	add    $0x10,%esp
    exit();
    104a:	e8 66 2e 00 00       	call   3eb5 <exit>
  }
}
    104f:	c9                   	leave  
    1050:	c3                   	ret    

00001051 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1051:	55                   	push   %ebp
    1052:	89 e5                	mov    %esp,%ebp
    1054:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1057:	c7 45 c8 f9 49 00 00 	movl   $0x49f9,-0x38(%ebp)
    105e:	c7 45 cc fc 49 00 00 	movl   $0x49fc,-0x34(%ebp)
    1065:	c7 45 d0 ff 49 00 00 	movl   $0x49ff,-0x30(%ebp)
    106c:	c7 45 d4 02 4a 00 00 	movl   $0x4a02,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1073:	83 ec 08             	sub    $0x8,%esp
    1076:	68 05 4a 00 00       	push   $0x4a05
    107b:	6a 01                	push   $0x1
    107d:	e8 a8 2f 00 00       	call   402a <printf>
    1082:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1085:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    108c:	e9 f0 00 00 00       	jmp    1181 <fourfiles+0x130>
    fname = names[pi];
    1091:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1094:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    109b:	83 ec 0c             	sub    $0xc,%esp
    109e:	ff 75 e4             	pushl  -0x1c(%ebp)
    10a1:	e8 5f 2e 00 00       	call   3f05 <unlink>
    10a6:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10a9:	e8 ff 2d 00 00       	call   3ead <fork>
    10ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    10b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b5:	79 17                	jns    10ce <fourfiles+0x7d>
      printf(1, "fork failed\n");
    10b7:	83 ec 08             	sub    $0x8,%esp
    10ba:	68 81 44 00 00       	push   $0x4481
    10bf:	6a 01                	push   $0x1
    10c1:	e8 64 2f 00 00       	call   402a <printf>
    10c6:	83 c4 10             	add    $0x10,%esp
      exit();
    10c9:	e8 e7 2d 00 00       	call   3eb5 <exit>
    }

    if(pid == 0){
    10ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10d2:	0f 85 a5 00 00 00    	jne    117d <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    10d8:	83 ec 08             	sub    $0x8,%esp
    10db:	68 02 02 00 00       	push   $0x202
    10e0:	ff 75 e4             	pushl  -0x1c(%ebp)
    10e3:	e8 0d 2e 00 00       	call   3ef5 <open>
    10e8:	83 c4 10             	add    $0x10,%esp
    10eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10f2:	79 17                	jns    110b <fourfiles+0xba>
        printf(1, "create failed\n");
    10f4:	83 ec 08             	sub    $0x8,%esp
    10f7:	68 15 4a 00 00       	push   $0x4a15
    10fc:	6a 01                	push   $0x1
    10fe:	e8 27 2f 00 00       	call   402a <printf>
    1103:	83 c4 10             	add    $0x10,%esp
        exit();
    1106:	e8 aa 2d 00 00       	call   3eb5 <exit>
      }
      
      memset(buf, '0'+pi, 512);
    110b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    110e:	83 c0 30             	add    $0x30,%eax
    1111:	83 ec 04             	sub    $0x4,%esp
    1114:	68 00 02 00 00       	push   $0x200
    1119:	50                   	push   %eax
    111a:	68 c0 8a 00 00       	push   $0x8ac0
    111f:	e8 f7 2b 00 00       	call   3d1b <memset>
    1124:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    1127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    112e:	eb 42                	jmp    1172 <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    1130:	83 ec 04             	sub    $0x4,%esp
    1133:	68 f4 01 00 00       	push   $0x1f4
    1138:	68 c0 8a 00 00       	push   $0x8ac0
    113d:	ff 75 dc             	pushl  -0x24(%ebp)
    1140:	e8 90 2d 00 00       	call   3ed5 <write>
    1145:	83 c4 10             	add    $0x10,%esp
    1148:	89 45 d8             	mov    %eax,-0x28(%ebp)
    114b:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    1152:	74 1a                	je     116e <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    1154:	83 ec 04             	sub    $0x4,%esp
    1157:	ff 75 d8             	pushl  -0x28(%ebp)
    115a:	68 24 4a 00 00       	push   $0x4a24
    115f:	6a 01                	push   $0x1
    1161:	e8 c4 2e 00 00       	call   402a <printf>
    1166:	83 c4 10             	add    $0x10,%esp
          exit();
    1169:	e8 47 2d 00 00       	call   3eb5 <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    116e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1172:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    1176:	7e b8                	jle    1130 <fourfiles+0xdf>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    1178:	e8 38 2d 00 00       	call   3eb5 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    117d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1181:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1185:	0f 8e 06 ff ff ff    	jle    1091 <fourfiles+0x40>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    118b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1192:	eb 09                	jmp    119d <fourfiles+0x14c>
    wait();
    1194:	e8 24 2d 00 00       	call   3ebd <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1199:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    119d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11a1:	7e f1                	jle    1194 <fourfiles+0x143>
    wait();
  }

  for(i = 0; i < 2; i++){
    11a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11aa:	e9 d4 00 00 00       	jmp    1283 <fourfiles+0x232>
    fname = names[i];
    11af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b2:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11b9:	83 ec 08             	sub    $0x8,%esp
    11bc:	6a 00                	push   $0x0
    11be:	ff 75 e4             	pushl  -0x1c(%ebp)
    11c1:	e8 2f 2d 00 00       	call   3ef5 <open>
    11c6:	83 c4 10             	add    $0x10,%esp
    11c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11d3:	eb 4a                	jmp    121f <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    11d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11dc:	eb 33                	jmp    1211 <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    11de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e1:	05 c0 8a 00 00       	add    $0x8ac0,%eax
    11e6:	0f b6 00             	movzbl (%eax),%eax
    11e9:	0f be c0             	movsbl %al,%eax
    11ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11ef:	83 c2 30             	add    $0x30,%edx
    11f2:	39 d0                	cmp    %edx,%eax
    11f4:	74 17                	je     120d <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    11f6:	83 ec 08             	sub    $0x8,%esp
    11f9:	68 35 4a 00 00       	push   $0x4a35
    11fe:	6a 01                	push   $0x1
    1200:	e8 25 2e 00 00       	call   402a <printf>
    1205:	83 c4 10             	add    $0x10,%esp
          exit();
    1208:	e8 a8 2c 00 00       	call   3eb5 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    120d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1211:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1214:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    1217:	7c c5                	jl     11de <fourfiles+0x18d>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    1219:	8b 45 d8             	mov    -0x28(%ebp),%eax
    121c:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    121f:	83 ec 04             	sub    $0x4,%esp
    1222:	68 00 20 00 00       	push   $0x2000
    1227:	68 c0 8a 00 00       	push   $0x8ac0
    122c:	ff 75 dc             	pushl  -0x24(%ebp)
    122f:	e8 99 2c 00 00       	call   3ecd <read>
    1234:	83 c4 10             	add    $0x10,%esp
    1237:	89 45 d8             	mov    %eax,-0x28(%ebp)
    123a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    123e:	7f 95                	jg     11d5 <fourfiles+0x184>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1240:	83 ec 0c             	sub    $0xc,%esp
    1243:	ff 75 dc             	pushl  -0x24(%ebp)
    1246:	e8 92 2c 00 00       	call   3edd <close>
    124b:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    124e:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1255:	74 1a                	je     1271 <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    1257:	83 ec 04             	sub    $0x4,%esp
    125a:	ff 75 ec             	pushl  -0x14(%ebp)
    125d:	68 41 4a 00 00       	push   $0x4a41
    1262:	6a 01                	push   $0x1
    1264:	e8 c1 2d 00 00       	call   402a <printf>
    1269:	83 c4 10             	add    $0x10,%esp
      exit();
    126c:	e8 44 2c 00 00       	call   3eb5 <exit>
    }
    unlink(fname);
    1271:	83 ec 0c             	sub    $0xc,%esp
    1274:	ff 75 e4             	pushl  -0x1c(%ebp)
    1277:	e8 89 2c 00 00       	call   3f05 <unlink>
    127c:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    127f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1283:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1287:	0f 8e 22 ff ff ff    	jle    11af <fourfiles+0x15e>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    128d:	83 ec 08             	sub    $0x8,%esp
    1290:	68 52 4a 00 00       	push   $0x4a52
    1295:	6a 01                	push   $0x1
    1297:	e8 8e 2d 00 00       	call   402a <printf>
    129c:	83 c4 10             	add    $0x10,%esp
}
    129f:	c9                   	leave  
    12a0:	c3                   	ret    

000012a1 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12a1:	55                   	push   %ebp
    12a2:	89 e5                	mov    %esp,%ebp
    12a4:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12a7:	83 ec 08             	sub    $0x8,%esp
    12aa:	68 60 4a 00 00       	push   $0x4a60
    12af:	6a 01                	push   $0x1
    12b1:	e8 74 2d 00 00       	call   402a <printf>
    12b6:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12c0:	e9 f6 00 00 00       	jmp    13bb <createdelete+0x11a>
    pid = fork();
    12c5:	e8 e3 2b 00 00       	call   3ead <fork>
    12ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12d1:	79 17                	jns    12ea <createdelete+0x49>
      printf(1, "fork failed\n");
    12d3:	83 ec 08             	sub    $0x8,%esp
    12d6:	68 81 44 00 00       	push   $0x4481
    12db:	6a 01                	push   $0x1
    12dd:	e8 48 2d 00 00       	call   402a <printf>
    12e2:	83 c4 10             	add    $0x10,%esp
      exit();
    12e5:	e8 cb 2b 00 00       	call   3eb5 <exit>
    }

    if(pid == 0){
    12ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12ee:	0f 85 c3 00 00 00    	jne    13b7 <createdelete+0x116>
      name[0] = 'p' + pi;
    12f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12f7:	83 c0 70             	add    $0x70,%eax
    12fa:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12fd:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    1301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1308:	e9 9b 00 00 00       	jmp    13a8 <createdelete+0x107>
        name[1] = '0' + i;
    130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1310:	83 c0 30             	add    $0x30,%eax
    1313:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1316:	83 ec 08             	sub    $0x8,%esp
    1319:	68 02 02 00 00       	push   $0x202
    131e:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1321:	50                   	push   %eax
    1322:	e8 ce 2b 00 00       	call   3ef5 <open>
    1327:	83 c4 10             	add    $0x10,%esp
    132a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    132d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1331:	79 17                	jns    134a <createdelete+0xa9>
          printf(1, "create failed\n");
    1333:	83 ec 08             	sub    $0x8,%esp
    1336:	68 15 4a 00 00       	push   $0x4a15
    133b:	6a 01                	push   $0x1
    133d:	e8 e8 2c 00 00       	call   402a <printf>
    1342:	83 c4 10             	add    $0x10,%esp
          exit();
    1345:	e8 6b 2b 00 00       	call   3eb5 <exit>
        }
        close(fd);
    134a:	83 ec 0c             	sub    $0xc,%esp
    134d:	ff 75 e8             	pushl  -0x18(%ebp)
    1350:	e8 88 2b 00 00       	call   3edd <close>
    1355:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    1358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    135c:	7e 46                	jle    13a4 <createdelete+0x103>
    135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1361:	83 e0 01             	and    $0x1,%eax
    1364:	85 c0                	test   %eax,%eax
    1366:	75 3c                	jne    13a4 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1368:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136b:	89 c2                	mov    %eax,%edx
    136d:	c1 ea 1f             	shr    $0x1f,%edx
    1370:	01 d0                	add    %edx,%eax
    1372:	d1 f8                	sar    %eax
    1374:	83 c0 30             	add    $0x30,%eax
    1377:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    137a:	83 ec 0c             	sub    $0xc,%esp
    137d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1380:	50                   	push   %eax
    1381:	e8 7f 2b 00 00       	call   3f05 <unlink>
    1386:	83 c4 10             	add    $0x10,%esp
    1389:	85 c0                	test   %eax,%eax
    138b:	79 17                	jns    13a4 <createdelete+0x103>
            printf(1, "unlink failed\n");
    138d:	83 ec 08             	sub    $0x8,%esp
    1390:	68 04 45 00 00       	push   $0x4504
    1395:	6a 01                	push   $0x1
    1397:	e8 8e 2c 00 00       	call   402a <printf>
    139c:	83 c4 10             	add    $0x10,%esp
            exit();
    139f:	e8 11 2b 00 00       	call   3eb5 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    13a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13a8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13ac:	0f 8e 5b ff ff ff    	jle    130d <createdelete+0x6c>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    13b2:	e8 fe 2a 00 00       	call   3eb5 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    13b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13bb:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13bf:	0f 8e 00 ff ff ff    	jle    12c5 <createdelete+0x24>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13cc:	eb 09                	jmp    13d7 <createdelete+0x136>
    wait();
    13ce:	e8 ea 2a 00 00       	call   3ebd <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13d7:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13db:	7e f1                	jle    13ce <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13dd:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13e1:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13e5:	88 45 c9             	mov    %al,-0x37(%ebp)
    13e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13ec:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13f6:	e9 b2 00 00 00       	jmp    14ad <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    13fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1402:	e9 98 00 00 00       	jmp    149f <createdelete+0x1fe>
      name[0] = 'p' + pi;
    1407:	8b 45 f0             	mov    -0x10(%ebp),%eax
    140a:	83 c0 70             	add    $0x70,%eax
    140d:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1413:	83 c0 30             	add    $0x30,%eax
    1416:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1419:	83 ec 08             	sub    $0x8,%esp
    141c:	6a 00                	push   $0x0
    141e:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1421:	50                   	push   %eax
    1422:	e8 ce 2a 00 00       	call   3ef5 <open>
    1427:	83 c4 10             	add    $0x10,%esp
    142a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    142d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1431:	74 06                	je     1439 <createdelete+0x198>
    1433:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1437:	7e 21                	jle    145a <createdelete+0x1b9>
    1439:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    143d:	79 1b                	jns    145a <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    143f:	83 ec 04             	sub    $0x4,%esp
    1442:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1445:	50                   	push   %eax
    1446:	68 74 4a 00 00       	push   $0x4a74
    144b:	6a 01                	push   $0x1
    144d:	e8 d8 2b 00 00       	call   402a <printf>
    1452:	83 c4 10             	add    $0x10,%esp
        exit();
    1455:	e8 5b 2a 00 00       	call   3eb5 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    145a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    145e:	7e 27                	jle    1487 <createdelete+0x1e6>
    1460:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1464:	7f 21                	jg     1487 <createdelete+0x1e6>
    1466:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    146a:	78 1b                	js     1487 <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    146c:	83 ec 04             	sub    $0x4,%esp
    146f:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1472:	50                   	push   %eax
    1473:	68 98 4a 00 00       	push   $0x4a98
    1478:	6a 01                	push   $0x1
    147a:	e8 ab 2b 00 00       	call   402a <printf>
    147f:	83 c4 10             	add    $0x10,%esp
        exit();
    1482:	e8 2e 2a 00 00       	call   3eb5 <exit>
      }
      if(fd >= 0)
    1487:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    148b:	78 0e                	js     149b <createdelete+0x1fa>
        close(fd);
    148d:	83 ec 0c             	sub    $0xc,%esp
    1490:	ff 75 e8             	pushl  -0x18(%ebp)
    1493:	e8 45 2a 00 00       	call   3edd <close>
    1498:	83 c4 10             	add    $0x10,%esp
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    149b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    149f:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14a3:	0f 8e 5e ff ff ff    	jle    1407 <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    14a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14ad:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14b1:	0f 8e 44 ff ff ff    	jle    13fb <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14be:	eb 38                	jmp    14f8 <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    14c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14c7:	eb 25                	jmp    14ee <createdelete+0x24d>
      name[0] = 'p' + i;
    14c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cc:	83 c0 70             	add    $0x70,%eax
    14cf:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d5:	83 c0 30             	add    $0x30,%eax
    14d8:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14db:	83 ec 0c             	sub    $0xc,%esp
    14de:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14e1:	50                   	push   %eax
    14e2:	e8 1e 2a 00 00       	call   3f05 <unlink>
    14e7:	83 c4 10             	add    $0x10,%esp
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14ee:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14f2:	7e d5                	jle    14c9 <createdelete+0x228>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14f8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14fc:	7e c2                	jle    14c0 <createdelete+0x21f>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14fe:	83 ec 08             	sub    $0x8,%esp
    1501:	68 b8 4a 00 00       	push   $0x4ab8
    1506:	6a 01                	push   $0x1
    1508:	e8 1d 2b 00 00       	call   402a <printf>
    150d:	83 c4 10             	add    $0x10,%esp
}
    1510:	c9                   	leave  
    1511:	c3                   	ret    

00001512 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1512:	55                   	push   %ebp
    1513:	89 e5                	mov    %esp,%ebp
    1515:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1518:	83 ec 08             	sub    $0x8,%esp
    151b:	68 c9 4a 00 00       	push   $0x4ac9
    1520:	6a 01                	push   $0x1
    1522:	e8 03 2b 00 00       	call   402a <printf>
    1527:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    152a:	83 ec 08             	sub    $0x8,%esp
    152d:	68 02 02 00 00       	push   $0x202
    1532:	68 da 4a 00 00       	push   $0x4ada
    1537:	e8 b9 29 00 00       	call   3ef5 <open>
    153c:	83 c4 10             	add    $0x10,%esp
    153f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1546:	79 17                	jns    155f <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1548:	83 ec 08             	sub    $0x8,%esp
    154b:	68 e5 4a 00 00       	push   $0x4ae5
    1550:	6a 01                	push   $0x1
    1552:	e8 d3 2a 00 00       	call   402a <printf>
    1557:	83 c4 10             	add    $0x10,%esp
    exit();
    155a:	e8 56 29 00 00       	call   3eb5 <exit>
  }
  write(fd, "hello", 5);
    155f:	83 ec 04             	sub    $0x4,%esp
    1562:	6a 05                	push   $0x5
    1564:	68 ff 4a 00 00       	push   $0x4aff
    1569:	ff 75 f4             	pushl  -0xc(%ebp)
    156c:	e8 64 29 00 00       	call   3ed5 <write>
    1571:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1574:	83 ec 0c             	sub    $0xc,%esp
    1577:	ff 75 f4             	pushl  -0xc(%ebp)
    157a:	e8 5e 29 00 00       	call   3edd <close>
    157f:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    1582:	83 ec 08             	sub    $0x8,%esp
    1585:	6a 02                	push   $0x2
    1587:	68 da 4a 00 00       	push   $0x4ada
    158c:	e8 64 29 00 00       	call   3ef5 <open>
    1591:	83 c4 10             	add    $0x10,%esp
    1594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    159b:	79 17                	jns    15b4 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    159d:	83 ec 08             	sub    $0x8,%esp
    15a0:	68 05 4b 00 00       	push   $0x4b05
    15a5:	6a 01                	push   $0x1
    15a7:	e8 7e 2a 00 00       	call   402a <printf>
    15ac:	83 c4 10             	add    $0x10,%esp
    exit();
    15af:	e8 01 29 00 00       	call   3eb5 <exit>
  }
  if(unlink("unlinkread") != 0){
    15b4:	83 ec 0c             	sub    $0xc,%esp
    15b7:	68 da 4a 00 00       	push   $0x4ada
    15bc:	e8 44 29 00 00       	call   3f05 <unlink>
    15c1:	83 c4 10             	add    $0x10,%esp
    15c4:	85 c0                	test   %eax,%eax
    15c6:	74 17                	je     15df <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15c8:	83 ec 08             	sub    $0x8,%esp
    15cb:	68 1d 4b 00 00       	push   $0x4b1d
    15d0:	6a 01                	push   $0x1
    15d2:	e8 53 2a 00 00       	call   402a <printf>
    15d7:	83 c4 10             	add    $0x10,%esp
    exit();
    15da:	e8 d6 28 00 00       	call   3eb5 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15df:	83 ec 08             	sub    $0x8,%esp
    15e2:	68 02 02 00 00       	push   $0x202
    15e7:	68 da 4a 00 00       	push   $0x4ada
    15ec:	e8 04 29 00 00       	call   3ef5 <open>
    15f1:	83 c4 10             	add    $0x10,%esp
    15f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15f7:	83 ec 04             	sub    $0x4,%esp
    15fa:	6a 03                	push   $0x3
    15fc:	68 37 4b 00 00       	push   $0x4b37
    1601:	ff 75 f0             	pushl  -0x10(%ebp)
    1604:	e8 cc 28 00 00       	call   3ed5 <write>
    1609:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    160c:	83 ec 0c             	sub    $0xc,%esp
    160f:	ff 75 f0             	pushl  -0x10(%ebp)
    1612:	e8 c6 28 00 00       	call   3edd <close>
    1617:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    161a:	83 ec 04             	sub    $0x4,%esp
    161d:	68 00 20 00 00       	push   $0x2000
    1622:	68 c0 8a 00 00       	push   $0x8ac0
    1627:	ff 75 f4             	pushl  -0xc(%ebp)
    162a:	e8 9e 28 00 00       	call   3ecd <read>
    162f:	83 c4 10             	add    $0x10,%esp
    1632:	83 f8 05             	cmp    $0x5,%eax
    1635:	74 17                	je     164e <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1637:	83 ec 08             	sub    $0x8,%esp
    163a:	68 3b 4b 00 00       	push   $0x4b3b
    163f:	6a 01                	push   $0x1
    1641:	e8 e4 29 00 00       	call   402a <printf>
    1646:	83 c4 10             	add    $0x10,%esp
    exit();
    1649:	e8 67 28 00 00       	call   3eb5 <exit>
  }
  if(buf[0] != 'h'){
    164e:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    1655:	3c 68                	cmp    $0x68,%al
    1657:	74 17                	je     1670 <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    1659:	83 ec 08             	sub    $0x8,%esp
    165c:	68 52 4b 00 00       	push   $0x4b52
    1661:	6a 01                	push   $0x1
    1663:	e8 c2 29 00 00       	call   402a <printf>
    1668:	83 c4 10             	add    $0x10,%esp
    exit();
    166b:	e8 45 28 00 00       	call   3eb5 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1670:	83 ec 04             	sub    $0x4,%esp
    1673:	6a 0a                	push   $0xa
    1675:	68 c0 8a 00 00       	push   $0x8ac0
    167a:	ff 75 f4             	pushl  -0xc(%ebp)
    167d:	e8 53 28 00 00       	call   3ed5 <write>
    1682:	83 c4 10             	add    $0x10,%esp
    1685:	83 f8 0a             	cmp    $0xa,%eax
    1688:	74 17                	je     16a1 <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    168a:	83 ec 08             	sub    $0x8,%esp
    168d:	68 69 4b 00 00       	push   $0x4b69
    1692:	6a 01                	push   $0x1
    1694:	e8 91 29 00 00       	call   402a <printf>
    1699:	83 c4 10             	add    $0x10,%esp
    exit();
    169c:	e8 14 28 00 00       	call   3eb5 <exit>
  }
  close(fd);
    16a1:	83 ec 0c             	sub    $0xc,%esp
    16a4:	ff 75 f4             	pushl  -0xc(%ebp)
    16a7:	e8 31 28 00 00       	call   3edd <close>
    16ac:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16af:	83 ec 0c             	sub    $0xc,%esp
    16b2:	68 da 4a 00 00       	push   $0x4ada
    16b7:	e8 49 28 00 00       	call   3f05 <unlink>
    16bc:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    16bf:	83 ec 08             	sub    $0x8,%esp
    16c2:	68 82 4b 00 00       	push   $0x4b82
    16c7:	6a 01                	push   $0x1
    16c9:	e8 5c 29 00 00       	call   402a <printf>
    16ce:	83 c4 10             	add    $0x10,%esp
}
    16d1:	c9                   	leave  
    16d2:	c3                   	ret    

000016d3 <linktest>:

void
linktest(void)
{
    16d3:	55                   	push   %ebp
    16d4:	89 e5                	mov    %esp,%ebp
    16d6:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16d9:	83 ec 08             	sub    $0x8,%esp
    16dc:	68 91 4b 00 00       	push   $0x4b91
    16e1:	6a 01                	push   $0x1
    16e3:	e8 42 29 00 00       	call   402a <printf>
    16e8:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    16eb:	83 ec 0c             	sub    $0xc,%esp
    16ee:	68 9b 4b 00 00       	push   $0x4b9b
    16f3:	e8 0d 28 00 00       	call   3f05 <unlink>
    16f8:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    16fb:	83 ec 0c             	sub    $0xc,%esp
    16fe:	68 9f 4b 00 00       	push   $0x4b9f
    1703:	e8 fd 27 00 00       	call   3f05 <unlink>
    1708:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    170b:	83 ec 08             	sub    $0x8,%esp
    170e:	68 02 02 00 00       	push   $0x202
    1713:	68 9b 4b 00 00       	push   $0x4b9b
    1718:	e8 d8 27 00 00       	call   3ef5 <open>
    171d:	83 c4 10             	add    $0x10,%esp
    1720:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1727:	79 17                	jns    1740 <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1729:	83 ec 08             	sub    $0x8,%esp
    172c:	68 a3 4b 00 00       	push   $0x4ba3
    1731:	6a 01                	push   $0x1
    1733:	e8 f2 28 00 00       	call   402a <printf>
    1738:	83 c4 10             	add    $0x10,%esp
    exit();
    173b:	e8 75 27 00 00       	call   3eb5 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1740:	83 ec 04             	sub    $0x4,%esp
    1743:	6a 05                	push   $0x5
    1745:	68 ff 4a 00 00       	push   $0x4aff
    174a:	ff 75 f4             	pushl  -0xc(%ebp)
    174d:	e8 83 27 00 00       	call   3ed5 <write>
    1752:	83 c4 10             	add    $0x10,%esp
    1755:	83 f8 05             	cmp    $0x5,%eax
    1758:	74 17                	je     1771 <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    175a:	83 ec 08             	sub    $0x8,%esp
    175d:	68 b6 4b 00 00       	push   $0x4bb6
    1762:	6a 01                	push   $0x1
    1764:	e8 c1 28 00 00       	call   402a <printf>
    1769:	83 c4 10             	add    $0x10,%esp
    exit();
    176c:	e8 44 27 00 00       	call   3eb5 <exit>
  }
  close(fd);
    1771:	83 ec 0c             	sub    $0xc,%esp
    1774:	ff 75 f4             	pushl  -0xc(%ebp)
    1777:	e8 61 27 00 00       	call   3edd <close>
    177c:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    177f:	83 ec 08             	sub    $0x8,%esp
    1782:	68 9f 4b 00 00       	push   $0x4b9f
    1787:	68 9b 4b 00 00       	push   $0x4b9b
    178c:	e8 84 27 00 00       	call   3f15 <link>
    1791:	83 c4 10             	add    $0x10,%esp
    1794:	85 c0                	test   %eax,%eax
    1796:	79 17                	jns    17af <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    1798:	83 ec 08             	sub    $0x8,%esp
    179b:	68 c8 4b 00 00       	push   $0x4bc8
    17a0:	6a 01                	push   $0x1
    17a2:	e8 83 28 00 00       	call   402a <printf>
    17a7:	83 c4 10             	add    $0x10,%esp
    exit();
    17aa:	e8 06 27 00 00       	call   3eb5 <exit>
  }
  unlink("lf1");
    17af:	83 ec 0c             	sub    $0xc,%esp
    17b2:	68 9b 4b 00 00       	push   $0x4b9b
    17b7:	e8 49 27 00 00       	call   3f05 <unlink>
    17bc:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    17bf:	83 ec 08             	sub    $0x8,%esp
    17c2:	6a 00                	push   $0x0
    17c4:	68 9b 4b 00 00       	push   $0x4b9b
    17c9:	e8 27 27 00 00       	call   3ef5 <open>
    17ce:	83 c4 10             	add    $0x10,%esp
    17d1:	85 c0                	test   %eax,%eax
    17d3:	78 17                	js     17ec <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17d5:	83 ec 08             	sub    $0x8,%esp
    17d8:	68 e0 4b 00 00       	push   $0x4be0
    17dd:	6a 01                	push   $0x1
    17df:	e8 46 28 00 00       	call   402a <printf>
    17e4:	83 c4 10             	add    $0x10,%esp
    exit();
    17e7:	e8 c9 26 00 00       	call   3eb5 <exit>
  }

  fd = open("lf2", 0);
    17ec:	83 ec 08             	sub    $0x8,%esp
    17ef:	6a 00                	push   $0x0
    17f1:	68 9f 4b 00 00       	push   $0x4b9f
    17f6:	e8 fa 26 00 00       	call   3ef5 <open>
    17fb:	83 c4 10             	add    $0x10,%esp
    17fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1805:	79 17                	jns    181e <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1807:	83 ec 08             	sub    $0x8,%esp
    180a:	68 05 4c 00 00       	push   $0x4c05
    180f:	6a 01                	push   $0x1
    1811:	e8 14 28 00 00       	call   402a <printf>
    1816:	83 c4 10             	add    $0x10,%esp
    exit();
    1819:	e8 97 26 00 00       	call   3eb5 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    181e:	83 ec 04             	sub    $0x4,%esp
    1821:	68 00 20 00 00       	push   $0x2000
    1826:	68 c0 8a 00 00       	push   $0x8ac0
    182b:	ff 75 f4             	pushl  -0xc(%ebp)
    182e:	e8 9a 26 00 00       	call   3ecd <read>
    1833:	83 c4 10             	add    $0x10,%esp
    1836:	83 f8 05             	cmp    $0x5,%eax
    1839:	74 17                	je     1852 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    183b:	83 ec 08             	sub    $0x8,%esp
    183e:	68 16 4c 00 00       	push   $0x4c16
    1843:	6a 01                	push   $0x1
    1845:	e8 e0 27 00 00       	call   402a <printf>
    184a:	83 c4 10             	add    $0x10,%esp
    exit();
    184d:	e8 63 26 00 00       	call   3eb5 <exit>
  }
  close(fd);
    1852:	83 ec 0c             	sub    $0xc,%esp
    1855:	ff 75 f4             	pushl  -0xc(%ebp)
    1858:	e8 80 26 00 00       	call   3edd <close>
    185d:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    1860:	83 ec 08             	sub    $0x8,%esp
    1863:	68 9f 4b 00 00       	push   $0x4b9f
    1868:	68 9f 4b 00 00       	push   $0x4b9f
    186d:	e8 a3 26 00 00       	call   3f15 <link>
    1872:	83 c4 10             	add    $0x10,%esp
    1875:	85 c0                	test   %eax,%eax
    1877:	78 17                	js     1890 <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1879:	83 ec 08             	sub    $0x8,%esp
    187c:	68 27 4c 00 00       	push   $0x4c27
    1881:	6a 01                	push   $0x1
    1883:	e8 a2 27 00 00       	call   402a <printf>
    1888:	83 c4 10             	add    $0x10,%esp
    exit();
    188b:	e8 25 26 00 00       	call   3eb5 <exit>
  }

  unlink("lf2");
    1890:	83 ec 0c             	sub    $0xc,%esp
    1893:	68 9f 4b 00 00       	push   $0x4b9f
    1898:	e8 68 26 00 00       	call   3f05 <unlink>
    189d:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18a0:	83 ec 08             	sub    $0x8,%esp
    18a3:	68 9b 4b 00 00       	push   $0x4b9b
    18a8:	68 9f 4b 00 00       	push   $0x4b9f
    18ad:	e8 63 26 00 00       	call   3f15 <link>
    18b2:	83 c4 10             	add    $0x10,%esp
    18b5:	85 c0                	test   %eax,%eax
    18b7:	78 17                	js     18d0 <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    18b9:	83 ec 08             	sub    $0x8,%esp
    18bc:	68 48 4c 00 00       	push   $0x4c48
    18c1:	6a 01                	push   $0x1
    18c3:	e8 62 27 00 00       	call   402a <printf>
    18c8:	83 c4 10             	add    $0x10,%esp
    exit();
    18cb:	e8 e5 25 00 00       	call   3eb5 <exit>
  }

  if(link(".", "lf1") >= 0){
    18d0:	83 ec 08             	sub    $0x8,%esp
    18d3:	68 9b 4b 00 00       	push   $0x4b9b
    18d8:	68 6b 4c 00 00       	push   $0x4c6b
    18dd:	e8 33 26 00 00       	call   3f15 <link>
    18e2:	83 c4 10             	add    $0x10,%esp
    18e5:	85 c0                	test   %eax,%eax
    18e7:	78 17                	js     1900 <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18e9:	83 ec 08             	sub    $0x8,%esp
    18ec:	68 6d 4c 00 00       	push   $0x4c6d
    18f1:	6a 01                	push   $0x1
    18f3:	e8 32 27 00 00       	call   402a <printf>
    18f8:	83 c4 10             	add    $0x10,%esp
    exit();
    18fb:	e8 b5 25 00 00       	call   3eb5 <exit>
  }

  printf(1, "linktest ok\n");
    1900:	83 ec 08             	sub    $0x8,%esp
    1903:	68 89 4c 00 00       	push   $0x4c89
    1908:	6a 01                	push   $0x1
    190a:	e8 1b 27 00 00       	call   402a <printf>
    190f:	83 c4 10             	add    $0x10,%esp
}
    1912:	c9                   	leave  
    1913:	c3                   	ret    

00001914 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1914:	55                   	push   %ebp
    1915:	89 e5                	mov    %esp,%ebp
    1917:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    191a:	83 ec 08             	sub    $0x8,%esp
    191d:	68 96 4c 00 00       	push   $0x4c96
    1922:	6a 01                	push   $0x1
    1924:	e8 01 27 00 00       	call   402a <printf>
    1929:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    192c:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1930:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1934:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    193b:	e9 fc 00 00 00       	jmp    1a3c <concreate+0x128>
    file[1] = '0' + i;
    1940:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1943:	83 c0 30             	add    $0x30,%eax
    1946:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1949:	83 ec 0c             	sub    $0xc,%esp
    194c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    194f:	50                   	push   %eax
    1950:	e8 b0 25 00 00       	call   3f05 <unlink>
    1955:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1958:	e8 50 25 00 00       	call   3ead <fork>
    195d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1964:	74 3b                	je     19a1 <concreate+0x8d>
    1966:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1969:	ba 56 55 55 55       	mov    $0x55555556,%edx
    196e:	89 c8                	mov    %ecx,%eax
    1970:	f7 ea                	imul   %edx
    1972:	89 c8                	mov    %ecx,%eax
    1974:	c1 f8 1f             	sar    $0x1f,%eax
    1977:	29 c2                	sub    %eax,%edx
    1979:	89 d0                	mov    %edx,%eax
    197b:	01 c0                	add    %eax,%eax
    197d:	01 d0                	add    %edx,%eax
    197f:	29 c1                	sub    %eax,%ecx
    1981:	89 ca                	mov    %ecx,%edx
    1983:	83 fa 01             	cmp    $0x1,%edx
    1986:	75 19                	jne    19a1 <concreate+0x8d>
      link("C0", file);
    1988:	83 ec 08             	sub    $0x8,%esp
    198b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198e:	50                   	push   %eax
    198f:	68 a6 4c 00 00       	push   $0x4ca6
    1994:	e8 7c 25 00 00       	call   3f15 <link>
    1999:	83 c4 10             	add    $0x10,%esp
    199c:	e9 87 00 00 00       	jmp    1a28 <concreate+0x114>
    } else if(pid == 0 && (i % 5) == 1){
    19a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a5:	75 3b                	jne    19e2 <concreate+0xce>
    19a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19aa:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19af:	89 c8                	mov    %ecx,%eax
    19b1:	f7 ea                	imul   %edx
    19b3:	d1 fa                	sar    %edx
    19b5:	89 c8                	mov    %ecx,%eax
    19b7:	c1 f8 1f             	sar    $0x1f,%eax
    19ba:	29 c2                	sub    %eax,%edx
    19bc:	89 d0                	mov    %edx,%eax
    19be:	c1 e0 02             	shl    $0x2,%eax
    19c1:	01 d0                	add    %edx,%eax
    19c3:	29 c1                	sub    %eax,%ecx
    19c5:	89 ca                	mov    %ecx,%edx
    19c7:	83 fa 01             	cmp    $0x1,%edx
    19ca:	75 16                	jne    19e2 <concreate+0xce>
      link("C0", file);
    19cc:	83 ec 08             	sub    $0x8,%esp
    19cf:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d2:	50                   	push   %eax
    19d3:	68 a6 4c 00 00       	push   $0x4ca6
    19d8:	e8 38 25 00 00       	call   3f15 <link>
    19dd:	83 c4 10             	add    $0x10,%esp
    19e0:	eb 46                	jmp    1a28 <concreate+0x114>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19e2:	83 ec 08             	sub    $0x8,%esp
    19e5:	68 02 02 00 00       	push   $0x202
    19ea:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19ed:	50                   	push   %eax
    19ee:	e8 02 25 00 00       	call   3ef5 <open>
    19f3:	83 c4 10             	add    $0x10,%esp
    19f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fd:	79 1b                	jns    1a1a <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19ff:	83 ec 04             	sub    $0x4,%esp
    1a02:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a05:	50                   	push   %eax
    1a06:	68 a9 4c 00 00       	push   $0x4ca9
    1a0b:	6a 01                	push   $0x1
    1a0d:	e8 18 26 00 00       	call   402a <printf>
    1a12:	83 c4 10             	add    $0x10,%esp
        exit();
    1a15:	e8 9b 24 00 00       	call   3eb5 <exit>
      }
      close(fd);
    1a1a:	83 ec 0c             	sub    $0xc,%esp
    1a1d:	ff 75 e8             	pushl  -0x18(%ebp)
    1a20:	e8 b8 24 00 00       	call   3edd <close>
    1a25:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a2c:	75 05                	jne    1a33 <concreate+0x11f>
      exit();
    1a2e:	e8 82 24 00 00       	call   3eb5 <exit>
    else
      wait();
    1a33:	e8 85 24 00 00       	call   3ebd <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a3c:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a40:	0f 8e fa fe ff ff    	jle    1940 <concreate+0x2c>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a46:	83 ec 04             	sub    $0x4,%esp
    1a49:	6a 28                	push   $0x28
    1a4b:	6a 00                	push   $0x0
    1a4d:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a50:	50                   	push   %eax
    1a51:	e8 c5 22 00 00       	call   3d1b <memset>
    1a56:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a59:	83 ec 08             	sub    $0x8,%esp
    1a5c:	6a 00                	push   $0x0
    1a5e:	68 6b 4c 00 00       	push   $0x4c6b
    1a63:	e8 8d 24 00 00       	call   3ef5 <open>
    1a68:	83 c4 10             	add    $0x10,%esp
    1a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a75:	e9 93 00 00 00       	jmp    1b0d <concreate+0x1f9>
    if(de.inum == 0)
    1a7a:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a7e:	66 85 c0             	test   %ax,%ax
    1a81:	75 05                	jne    1a88 <concreate+0x174>
      continue;
    1a83:	e9 85 00 00 00       	jmp    1b0d <concreate+0x1f9>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a88:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a8c:	3c 43                	cmp    $0x43,%al
    1a8e:	75 7d                	jne    1b0d <concreate+0x1f9>
    1a90:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1a94:	84 c0                	test   %al,%al
    1a96:	75 75                	jne    1b0d <concreate+0x1f9>
      i = de.name[1] - '0';
    1a98:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1a9c:	0f be c0             	movsbl %al,%eax
    1a9f:	83 e8 30             	sub    $0x30,%eax
    1aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1aa9:	78 08                	js     1ab3 <concreate+0x19f>
    1aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aae:	83 f8 27             	cmp    $0x27,%eax
    1ab1:	76 1e                	jbe    1ad1 <concreate+0x1bd>
        printf(1, "concreate weird file %s\n", de.name);
    1ab3:	83 ec 04             	sub    $0x4,%esp
    1ab6:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ab9:	83 c0 02             	add    $0x2,%eax
    1abc:	50                   	push   %eax
    1abd:	68 c5 4c 00 00       	push   $0x4cc5
    1ac2:	6a 01                	push   $0x1
    1ac4:	e8 61 25 00 00       	call   402a <printf>
    1ac9:	83 c4 10             	add    $0x10,%esp
        exit();
    1acc:	e8 e4 23 00 00       	call   3eb5 <exit>
      }
      if(fa[i]){
    1ad1:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad7:	01 d0                	add    %edx,%eax
    1ad9:	0f b6 00             	movzbl (%eax),%eax
    1adc:	84 c0                	test   %al,%al
    1ade:	74 1e                	je     1afe <concreate+0x1ea>
        printf(1, "concreate duplicate file %s\n", de.name);
    1ae0:	83 ec 04             	sub    $0x4,%esp
    1ae3:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ae6:	83 c0 02             	add    $0x2,%eax
    1ae9:	50                   	push   %eax
    1aea:	68 de 4c 00 00       	push   $0x4cde
    1aef:	6a 01                	push   $0x1
    1af1:	e8 34 25 00 00       	call   402a <printf>
    1af6:	83 c4 10             	add    $0x10,%esp
        exit();
    1af9:	e8 b7 23 00 00       	call   3eb5 <exit>
      }
      fa[i] = 1;
    1afe:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b04:	01 d0                	add    %edx,%eax
    1b06:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b09:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b0d:	83 ec 04             	sub    $0x4,%esp
    1b10:	6a 10                	push   $0x10
    1b12:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b15:	50                   	push   %eax
    1b16:	ff 75 e8             	pushl  -0x18(%ebp)
    1b19:	e8 af 23 00 00       	call   3ecd <read>
    1b1e:	83 c4 10             	add    $0x10,%esp
    1b21:	85 c0                	test   %eax,%eax
    1b23:	0f 8f 51 ff ff ff    	jg     1a7a <concreate+0x166>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b29:	83 ec 0c             	sub    $0xc,%esp
    1b2c:	ff 75 e8             	pushl  -0x18(%ebp)
    1b2f:	e8 a9 23 00 00       	call   3edd <close>
    1b34:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b37:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b3b:	74 17                	je     1b54 <concreate+0x240>
    printf(1, "concreate not enough files in directory listing\n");
    1b3d:	83 ec 08             	sub    $0x8,%esp
    1b40:	68 fc 4c 00 00       	push   $0x4cfc
    1b45:	6a 01                	push   $0x1
    1b47:	e8 de 24 00 00       	call   402a <printf>
    1b4c:	83 c4 10             	add    $0x10,%esp
    exit();
    1b4f:	e8 61 23 00 00       	call   3eb5 <exit>
  }

  for(i = 0; i < 40; i++){
    1b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b5b:	e9 45 01 00 00       	jmp    1ca5 <concreate+0x391>
    file[1] = '0' + i;
    1b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b63:	83 c0 30             	add    $0x30,%eax
    1b66:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b69:	e8 3f 23 00 00       	call   3ead <fork>
    1b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b75:	79 17                	jns    1b8e <concreate+0x27a>
      printf(1, "fork failed\n");
    1b77:	83 ec 08             	sub    $0x8,%esp
    1b7a:	68 81 44 00 00       	push   $0x4481
    1b7f:	6a 01                	push   $0x1
    1b81:	e8 a4 24 00 00       	call   402a <printf>
    1b86:	83 c4 10             	add    $0x10,%esp
      exit();
    1b89:	e8 27 23 00 00       	call   3eb5 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b8e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1b91:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1b96:	89 c8                	mov    %ecx,%eax
    1b98:	f7 ea                	imul   %edx
    1b9a:	89 c8                	mov    %ecx,%eax
    1b9c:	c1 f8 1f             	sar    $0x1f,%eax
    1b9f:	29 c2                	sub    %eax,%edx
    1ba1:	89 d0                	mov    %edx,%eax
    1ba3:	89 c2                	mov    %eax,%edx
    1ba5:	01 d2                	add    %edx,%edx
    1ba7:	01 c2                	add    %eax,%edx
    1ba9:	89 c8                	mov    %ecx,%eax
    1bab:	29 d0                	sub    %edx,%eax
    1bad:	85 c0                	test   %eax,%eax
    1baf:	75 06                	jne    1bb7 <concreate+0x2a3>
    1bb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bb5:	74 28                	je     1bdf <concreate+0x2cb>
       ((i % 3) == 1 && pid != 0)){
    1bb7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bba:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bbf:	89 c8                	mov    %ecx,%eax
    1bc1:	f7 ea                	imul   %edx
    1bc3:	89 c8                	mov    %ecx,%eax
    1bc5:	c1 f8 1f             	sar    $0x1f,%eax
    1bc8:	29 c2                	sub    %eax,%edx
    1bca:	89 d0                	mov    %edx,%eax
    1bcc:	01 c0                	add    %eax,%eax
    1bce:	01 d0                	add    %edx,%eax
    1bd0:	29 c1                	sub    %eax,%ecx
    1bd2:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bd4:	83 fa 01             	cmp    $0x1,%edx
    1bd7:	75 7c                	jne    1c55 <concreate+0x341>
       ((i % 3) == 1 && pid != 0)){
    1bd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bdd:	74 76                	je     1c55 <concreate+0x341>
      close(open(file, 0));
    1bdf:	83 ec 08             	sub    $0x8,%esp
    1be2:	6a 00                	push   $0x0
    1be4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1be7:	50                   	push   %eax
    1be8:	e8 08 23 00 00       	call   3ef5 <open>
    1bed:	83 c4 10             	add    $0x10,%esp
    1bf0:	83 ec 0c             	sub    $0xc,%esp
    1bf3:	50                   	push   %eax
    1bf4:	e8 e4 22 00 00       	call   3edd <close>
    1bf9:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1bfc:	83 ec 08             	sub    $0x8,%esp
    1bff:	6a 00                	push   $0x0
    1c01:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c04:	50                   	push   %eax
    1c05:	e8 eb 22 00 00       	call   3ef5 <open>
    1c0a:	83 c4 10             	add    $0x10,%esp
    1c0d:	83 ec 0c             	sub    $0xc,%esp
    1c10:	50                   	push   %eax
    1c11:	e8 c7 22 00 00       	call   3edd <close>
    1c16:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c19:	83 ec 08             	sub    $0x8,%esp
    1c1c:	6a 00                	push   $0x0
    1c1e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c21:	50                   	push   %eax
    1c22:	e8 ce 22 00 00       	call   3ef5 <open>
    1c27:	83 c4 10             	add    $0x10,%esp
    1c2a:	83 ec 0c             	sub    $0xc,%esp
    1c2d:	50                   	push   %eax
    1c2e:	e8 aa 22 00 00       	call   3edd <close>
    1c33:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c36:	83 ec 08             	sub    $0x8,%esp
    1c39:	6a 00                	push   $0x0
    1c3b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c3e:	50                   	push   %eax
    1c3f:	e8 b1 22 00 00       	call   3ef5 <open>
    1c44:	83 c4 10             	add    $0x10,%esp
    1c47:	83 ec 0c             	sub    $0xc,%esp
    1c4a:	50                   	push   %eax
    1c4b:	e8 8d 22 00 00       	call   3edd <close>
    1c50:	83 c4 10             	add    $0x10,%esp
    1c53:	eb 3c                	jmp    1c91 <concreate+0x37d>
    } else {
      unlink(file);
    1c55:	83 ec 0c             	sub    $0xc,%esp
    1c58:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c5b:	50                   	push   %eax
    1c5c:	e8 a4 22 00 00       	call   3f05 <unlink>
    1c61:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c64:	83 ec 0c             	sub    $0xc,%esp
    1c67:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c6a:	50                   	push   %eax
    1c6b:	e8 95 22 00 00       	call   3f05 <unlink>
    1c70:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c73:	83 ec 0c             	sub    $0xc,%esp
    1c76:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c79:	50                   	push   %eax
    1c7a:	e8 86 22 00 00       	call   3f05 <unlink>
    1c7f:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c82:	83 ec 0c             	sub    $0xc,%esp
    1c85:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c88:	50                   	push   %eax
    1c89:	e8 77 22 00 00       	call   3f05 <unlink>
    1c8e:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1c91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c95:	75 05                	jne    1c9c <concreate+0x388>
      exit();
    1c97:	e8 19 22 00 00       	call   3eb5 <exit>
    else
      wait();
    1c9c:	e8 1c 22 00 00       	call   3ebd <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1ca1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ca5:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1ca9:	0f 8e b1 fe ff ff    	jle    1b60 <concreate+0x24c>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1caf:	83 ec 08             	sub    $0x8,%esp
    1cb2:	68 2d 4d 00 00       	push   $0x4d2d
    1cb7:	6a 01                	push   $0x1
    1cb9:	e8 6c 23 00 00       	call   402a <printf>
    1cbe:	83 c4 10             	add    $0x10,%esp
}
    1cc1:	c9                   	leave  
    1cc2:	c3                   	ret    

00001cc3 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cc3:	55                   	push   %ebp
    1cc4:	89 e5                	mov    %esp,%ebp
    1cc6:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cc9:	83 ec 08             	sub    $0x8,%esp
    1ccc:	68 3b 4d 00 00       	push   $0x4d3b
    1cd1:	6a 01                	push   $0x1
    1cd3:	e8 52 23 00 00       	call   402a <printf>
    1cd8:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1cdb:	83 ec 0c             	sub    $0xc,%esp
    1cde:	68 b7 48 00 00       	push   $0x48b7
    1ce3:	e8 1d 22 00 00       	call   3f05 <unlink>
    1ce8:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1ceb:	e8 bd 21 00 00       	call   3ead <fork>
    1cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cf7:	79 17                	jns    1d10 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1cf9:	83 ec 08             	sub    $0x8,%esp
    1cfc:	68 81 44 00 00       	push   $0x4481
    1d01:	6a 01                	push   $0x1
    1d03:	e8 22 23 00 00       	call   402a <printf>
    1d08:	83 c4 10             	add    $0x10,%esp
    exit();
    1d0b:	e8 a5 21 00 00       	call   3eb5 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d14:	74 07                	je     1d1d <linkunlink+0x5a>
    1d16:	b8 01 00 00 00       	mov    $0x1,%eax
    1d1b:	eb 05                	jmp    1d22 <linkunlink+0x5f>
    1d1d:	b8 61 00 00 00       	mov    $0x61,%eax
    1d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d2c:	e9 9a 00 00 00       	jmp    1dcb <linkunlink+0x108>
    x = x * 1103515245 + 12345;
    1d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d34:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d3a:	05 39 30 00 00       	add    $0x3039,%eax
    1d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d45:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d4a:	89 c8                	mov    %ecx,%eax
    1d4c:	f7 e2                	mul    %edx
    1d4e:	89 d0                	mov    %edx,%eax
    1d50:	d1 e8                	shr    %eax
    1d52:	89 c2                	mov    %eax,%edx
    1d54:	01 d2                	add    %edx,%edx
    1d56:	01 c2                	add    %eax,%edx
    1d58:	89 c8                	mov    %ecx,%eax
    1d5a:	29 d0                	sub    %edx,%eax
    1d5c:	85 c0                	test   %eax,%eax
    1d5e:	75 23                	jne    1d83 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1d60:	83 ec 08             	sub    $0x8,%esp
    1d63:	68 02 02 00 00       	push   $0x202
    1d68:	68 b7 48 00 00       	push   $0x48b7
    1d6d:	e8 83 21 00 00       	call   3ef5 <open>
    1d72:	83 c4 10             	add    $0x10,%esp
    1d75:	83 ec 0c             	sub    $0xc,%esp
    1d78:	50                   	push   %eax
    1d79:	e8 5f 21 00 00       	call   3edd <close>
    1d7e:	83 c4 10             	add    $0x10,%esp
    1d81:	eb 44                	jmp    1dc7 <linkunlink+0x104>
    } else if((x % 3) == 1){
    1d83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d86:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d8b:	89 c8                	mov    %ecx,%eax
    1d8d:	f7 e2                	mul    %edx
    1d8f:	d1 ea                	shr    %edx
    1d91:	89 d0                	mov    %edx,%eax
    1d93:	01 c0                	add    %eax,%eax
    1d95:	01 d0                	add    %edx,%eax
    1d97:	29 c1                	sub    %eax,%ecx
    1d99:	89 ca                	mov    %ecx,%edx
    1d9b:	83 fa 01             	cmp    $0x1,%edx
    1d9e:	75 17                	jne    1db7 <linkunlink+0xf4>
      link("cat", "x");
    1da0:	83 ec 08             	sub    $0x8,%esp
    1da3:	68 b7 48 00 00       	push   $0x48b7
    1da8:	68 4c 4d 00 00       	push   $0x4d4c
    1dad:	e8 63 21 00 00       	call   3f15 <link>
    1db2:	83 c4 10             	add    $0x10,%esp
    1db5:	eb 10                	jmp    1dc7 <linkunlink+0x104>
    } else {
      unlink("x");
    1db7:	83 ec 0c             	sub    $0xc,%esp
    1dba:	68 b7 48 00 00       	push   $0x48b7
    1dbf:	e8 41 21 00 00       	call   3f05 <unlink>
    1dc4:	83 c4 10             	add    $0x10,%esp
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1dc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dcb:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1dcf:	0f 8e 5c ff ff ff    	jle    1d31 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1dd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1dd9:	74 07                	je     1de2 <linkunlink+0x11f>
    wait();
    1ddb:	e8 dd 20 00 00       	call   3ebd <wait>
    1de0:	eb 05                	jmp    1de7 <linkunlink+0x124>
  else 
    exit();
    1de2:	e8 ce 20 00 00       	call   3eb5 <exit>

  printf(1, "linkunlink ok\n");
    1de7:	83 ec 08             	sub    $0x8,%esp
    1dea:	68 50 4d 00 00       	push   $0x4d50
    1def:	6a 01                	push   $0x1
    1df1:	e8 34 22 00 00       	call   402a <printf>
    1df6:	83 c4 10             	add    $0x10,%esp
}
    1df9:	c9                   	leave  
    1dfa:	c3                   	ret    

00001dfb <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1dfb:	55                   	push   %ebp
    1dfc:	89 e5                	mov    %esp,%ebp
    1dfe:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e01:	83 ec 08             	sub    $0x8,%esp
    1e04:	68 5f 4d 00 00       	push   $0x4d5f
    1e09:	6a 01                	push   $0x1
    1e0b:	e8 1a 22 00 00       	call   402a <printf>
    1e10:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e13:	83 ec 0c             	sub    $0xc,%esp
    1e16:	68 6c 4d 00 00       	push   $0x4d6c
    1e1b:	e8 e5 20 00 00       	call   3f05 <unlink>
    1e20:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e23:	83 ec 08             	sub    $0x8,%esp
    1e26:	68 00 02 00 00       	push   $0x200
    1e2b:	68 6c 4d 00 00       	push   $0x4d6c
    1e30:	e8 c0 20 00 00       	call   3ef5 <open>
    1e35:	83 c4 10             	add    $0x10,%esp
    1e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e3f:	79 17                	jns    1e58 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1e41:	83 ec 08             	sub    $0x8,%esp
    1e44:	68 6f 4d 00 00       	push   $0x4d6f
    1e49:	6a 01                	push   $0x1
    1e4b:	e8 da 21 00 00       	call   402a <printf>
    1e50:	83 c4 10             	add    $0x10,%esp
    exit();
    1e53:	e8 5d 20 00 00       	call   3eb5 <exit>
  }
  close(fd);
    1e58:	83 ec 0c             	sub    $0xc,%esp
    1e5b:	ff 75 f0             	pushl  -0x10(%ebp)
    1e5e:	e8 7a 20 00 00       	call   3edd <close>
    1e63:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e6d:	eb 61                	jmp    1ed0 <bigdir+0xd5>
    name[0] = 'x';
    1e6f:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e76:	99                   	cltd   
    1e77:	c1 ea 1a             	shr    $0x1a,%edx
    1e7a:	01 d0                	add    %edx,%eax
    1e7c:	c1 f8 06             	sar    $0x6,%eax
    1e7f:	83 c0 30             	add    $0x30,%eax
    1e82:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e88:	99                   	cltd   
    1e89:	c1 ea 1a             	shr    $0x1a,%edx
    1e8c:	01 d0                	add    %edx,%eax
    1e8e:	83 e0 3f             	and    $0x3f,%eax
    1e91:	29 d0                	sub    %edx,%eax
    1e93:	83 c0 30             	add    $0x30,%eax
    1e96:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e99:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e9d:	83 ec 08             	sub    $0x8,%esp
    1ea0:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ea3:	50                   	push   %eax
    1ea4:	68 6c 4d 00 00       	push   $0x4d6c
    1ea9:	e8 67 20 00 00       	call   3f15 <link>
    1eae:	83 c4 10             	add    $0x10,%esp
    1eb1:	85 c0                	test   %eax,%eax
    1eb3:	74 17                	je     1ecc <bigdir+0xd1>
      printf(1, "bigdir link failed\n");
    1eb5:	83 ec 08             	sub    $0x8,%esp
    1eb8:	68 85 4d 00 00       	push   $0x4d85
    1ebd:	6a 01                	push   $0x1
    1ebf:	e8 66 21 00 00       	call   402a <printf>
    1ec4:	83 c4 10             	add    $0x10,%esp
      exit();
    1ec7:	e8 e9 1f 00 00       	call   3eb5 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ecc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ed0:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ed7:	7e 96                	jle    1e6f <bigdir+0x74>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1ed9:	83 ec 0c             	sub    $0xc,%esp
    1edc:	68 6c 4d 00 00       	push   $0x4d6c
    1ee1:	e8 1f 20 00 00       	call   3f05 <unlink>
    1ee6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1ee9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ef0:	eb 5c                	jmp    1f4e <bigdir+0x153>
    name[0] = 'x';
    1ef2:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ef9:	99                   	cltd   
    1efa:	c1 ea 1a             	shr    $0x1a,%edx
    1efd:	01 d0                	add    %edx,%eax
    1eff:	c1 f8 06             	sar    $0x6,%eax
    1f02:	83 c0 30             	add    $0x30,%eax
    1f05:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f0b:	99                   	cltd   
    1f0c:	c1 ea 1a             	shr    $0x1a,%edx
    1f0f:	01 d0                	add    %edx,%eax
    1f11:	83 e0 3f             	and    $0x3f,%eax
    1f14:	29 d0                	sub    %edx,%eax
    1f16:	83 c0 30             	add    $0x30,%eax
    1f19:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f1c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f20:	83 ec 0c             	sub    $0xc,%esp
    1f23:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f26:	50                   	push   %eax
    1f27:	e8 d9 1f 00 00       	call   3f05 <unlink>
    1f2c:	83 c4 10             	add    $0x10,%esp
    1f2f:	85 c0                	test   %eax,%eax
    1f31:	74 17                	je     1f4a <bigdir+0x14f>
      printf(1, "bigdir unlink failed");
    1f33:	83 ec 08             	sub    $0x8,%esp
    1f36:	68 99 4d 00 00       	push   $0x4d99
    1f3b:	6a 01                	push   $0x1
    1f3d:	e8 e8 20 00 00       	call   402a <printf>
    1f42:	83 c4 10             	add    $0x10,%esp
      exit();
    1f45:	e8 6b 1f 00 00       	call   3eb5 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f4e:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f55:	7e 9b                	jle    1ef2 <bigdir+0xf7>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f57:	83 ec 08             	sub    $0x8,%esp
    1f5a:	68 ae 4d 00 00       	push   $0x4dae
    1f5f:	6a 01                	push   $0x1
    1f61:	e8 c4 20 00 00       	call   402a <printf>
    1f66:	83 c4 10             	add    $0x10,%esp
}
    1f69:	c9                   	leave  
    1f6a:	c3                   	ret    

00001f6b <subdir>:

void
subdir(void)
{
    1f6b:	55                   	push   %ebp
    1f6c:	89 e5                	mov    %esp,%ebp
    1f6e:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f71:	83 ec 08             	sub    $0x8,%esp
    1f74:	68 b9 4d 00 00       	push   $0x4db9
    1f79:	6a 01                	push   $0x1
    1f7b:	e8 aa 20 00 00       	call   402a <printf>
    1f80:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1f83:	83 ec 0c             	sub    $0xc,%esp
    1f86:	68 c6 4d 00 00       	push   $0x4dc6
    1f8b:	e8 75 1f 00 00       	call   3f05 <unlink>
    1f90:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1f93:	83 ec 0c             	sub    $0xc,%esp
    1f96:	68 c9 4d 00 00       	push   $0x4dc9
    1f9b:	e8 7d 1f 00 00       	call   3f1d <mkdir>
    1fa0:	83 c4 10             	add    $0x10,%esp
    1fa3:	85 c0                	test   %eax,%eax
    1fa5:	74 17                	je     1fbe <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1fa7:	83 ec 08             	sub    $0x8,%esp
    1faa:	68 cc 4d 00 00       	push   $0x4dcc
    1faf:	6a 01                	push   $0x1
    1fb1:	e8 74 20 00 00       	call   402a <printf>
    1fb6:	83 c4 10             	add    $0x10,%esp
    exit();
    1fb9:	e8 f7 1e 00 00       	call   3eb5 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fbe:	83 ec 08             	sub    $0x8,%esp
    1fc1:	68 02 02 00 00       	push   $0x202
    1fc6:	68 e4 4d 00 00       	push   $0x4de4
    1fcb:	e8 25 1f 00 00       	call   3ef5 <open>
    1fd0:	83 c4 10             	add    $0x10,%esp
    1fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fda:	79 17                	jns    1ff3 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1fdc:	83 ec 08             	sub    $0x8,%esp
    1fdf:	68 ea 4d 00 00       	push   $0x4dea
    1fe4:	6a 01                	push   $0x1
    1fe6:	e8 3f 20 00 00       	call   402a <printf>
    1feb:	83 c4 10             	add    $0x10,%esp
    exit();
    1fee:	e8 c2 1e 00 00       	call   3eb5 <exit>
  }
  write(fd, "ff", 2);
    1ff3:	83 ec 04             	sub    $0x4,%esp
    1ff6:	6a 02                	push   $0x2
    1ff8:	68 c6 4d 00 00       	push   $0x4dc6
    1ffd:	ff 75 f4             	pushl  -0xc(%ebp)
    2000:	e8 d0 1e 00 00       	call   3ed5 <write>
    2005:	83 c4 10             	add    $0x10,%esp
  close(fd);
    2008:	83 ec 0c             	sub    $0xc,%esp
    200b:	ff 75 f4             	pushl  -0xc(%ebp)
    200e:	e8 ca 1e 00 00       	call   3edd <close>
    2013:	83 c4 10             	add    $0x10,%esp
  
  if(unlink("dd") >= 0){
    2016:	83 ec 0c             	sub    $0xc,%esp
    2019:	68 c9 4d 00 00       	push   $0x4dc9
    201e:	e8 e2 1e 00 00       	call   3f05 <unlink>
    2023:	83 c4 10             	add    $0x10,%esp
    2026:	85 c0                	test   %eax,%eax
    2028:	78 17                	js     2041 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    202a:	83 ec 08             	sub    $0x8,%esp
    202d:	68 00 4e 00 00       	push   $0x4e00
    2032:	6a 01                	push   $0x1
    2034:	e8 f1 1f 00 00       	call   402a <printf>
    2039:	83 c4 10             	add    $0x10,%esp
    exit();
    203c:	e8 74 1e 00 00       	call   3eb5 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2041:	83 ec 0c             	sub    $0xc,%esp
    2044:	68 26 4e 00 00       	push   $0x4e26
    2049:	e8 cf 1e 00 00       	call   3f1d <mkdir>
    204e:	83 c4 10             	add    $0x10,%esp
    2051:	85 c0                	test   %eax,%eax
    2053:	74 17                	je     206c <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2055:	83 ec 08             	sub    $0x8,%esp
    2058:	68 2d 4e 00 00       	push   $0x4e2d
    205d:	6a 01                	push   $0x1
    205f:	e8 c6 1f 00 00       	call   402a <printf>
    2064:	83 c4 10             	add    $0x10,%esp
    exit();
    2067:	e8 49 1e 00 00       	call   3eb5 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    206c:	83 ec 08             	sub    $0x8,%esp
    206f:	68 02 02 00 00       	push   $0x202
    2074:	68 48 4e 00 00       	push   $0x4e48
    2079:	e8 77 1e 00 00       	call   3ef5 <open>
    207e:	83 c4 10             	add    $0x10,%esp
    2081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2088:	79 17                	jns    20a1 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    208a:	83 ec 08             	sub    $0x8,%esp
    208d:	68 51 4e 00 00       	push   $0x4e51
    2092:	6a 01                	push   $0x1
    2094:	e8 91 1f 00 00       	call   402a <printf>
    2099:	83 c4 10             	add    $0x10,%esp
    exit();
    209c:	e8 14 1e 00 00       	call   3eb5 <exit>
  }
  write(fd, "FF", 2);
    20a1:	83 ec 04             	sub    $0x4,%esp
    20a4:	6a 02                	push   $0x2
    20a6:	68 69 4e 00 00       	push   $0x4e69
    20ab:	ff 75 f4             	pushl  -0xc(%ebp)
    20ae:	e8 22 1e 00 00       	call   3ed5 <write>
    20b3:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20b6:	83 ec 0c             	sub    $0xc,%esp
    20b9:	ff 75 f4             	pushl  -0xc(%ebp)
    20bc:	e8 1c 1e 00 00       	call   3edd <close>
    20c1:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    20c4:	83 ec 08             	sub    $0x8,%esp
    20c7:	6a 00                	push   $0x0
    20c9:	68 6c 4e 00 00       	push   $0x4e6c
    20ce:	e8 22 1e 00 00       	call   3ef5 <open>
    20d3:	83 c4 10             	add    $0x10,%esp
    20d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20dd:	79 17                	jns    20f6 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    20df:	83 ec 08             	sub    $0x8,%esp
    20e2:	68 78 4e 00 00       	push   $0x4e78
    20e7:	6a 01                	push   $0x1
    20e9:	e8 3c 1f 00 00       	call   402a <printf>
    20ee:	83 c4 10             	add    $0x10,%esp
    exit();
    20f1:	e8 bf 1d 00 00       	call   3eb5 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    20f6:	83 ec 04             	sub    $0x4,%esp
    20f9:	68 00 20 00 00       	push   $0x2000
    20fe:	68 c0 8a 00 00       	push   $0x8ac0
    2103:	ff 75 f4             	pushl  -0xc(%ebp)
    2106:	e8 c2 1d 00 00       	call   3ecd <read>
    210b:	83 c4 10             	add    $0x10,%esp
    210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2111:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2115:	75 0b                	jne    2122 <subdir+0x1b7>
    2117:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    211e:	3c 66                	cmp    $0x66,%al
    2120:	74 17                	je     2139 <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    2122:	83 ec 08             	sub    $0x8,%esp
    2125:	68 91 4e 00 00       	push   $0x4e91
    212a:	6a 01                	push   $0x1
    212c:	e8 f9 1e 00 00       	call   402a <printf>
    2131:	83 c4 10             	add    $0x10,%esp
    exit();
    2134:	e8 7c 1d 00 00       	call   3eb5 <exit>
  }
  close(fd);
    2139:	83 ec 0c             	sub    $0xc,%esp
    213c:	ff 75 f4             	pushl  -0xc(%ebp)
    213f:	e8 99 1d 00 00       	call   3edd <close>
    2144:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2147:	83 ec 08             	sub    $0x8,%esp
    214a:	68 ac 4e 00 00       	push   $0x4eac
    214f:	68 48 4e 00 00       	push   $0x4e48
    2154:	e8 bc 1d 00 00       	call   3f15 <link>
    2159:	83 c4 10             	add    $0x10,%esp
    215c:	85 c0                	test   %eax,%eax
    215e:	74 17                	je     2177 <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2160:	83 ec 08             	sub    $0x8,%esp
    2163:	68 b8 4e 00 00       	push   $0x4eb8
    2168:	6a 01                	push   $0x1
    216a:	e8 bb 1e 00 00       	call   402a <printf>
    216f:	83 c4 10             	add    $0x10,%esp
    exit();
    2172:	e8 3e 1d 00 00       	call   3eb5 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2177:	83 ec 0c             	sub    $0xc,%esp
    217a:	68 48 4e 00 00       	push   $0x4e48
    217f:	e8 81 1d 00 00       	call   3f05 <unlink>
    2184:	83 c4 10             	add    $0x10,%esp
    2187:	85 c0                	test   %eax,%eax
    2189:	74 17                	je     21a2 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    218b:	83 ec 08             	sub    $0x8,%esp
    218e:	68 d9 4e 00 00       	push   $0x4ed9
    2193:	6a 01                	push   $0x1
    2195:	e8 90 1e 00 00       	call   402a <printf>
    219a:	83 c4 10             	add    $0x10,%esp
    exit();
    219d:	e8 13 1d 00 00       	call   3eb5 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21a2:	83 ec 08             	sub    $0x8,%esp
    21a5:	6a 00                	push   $0x0
    21a7:	68 48 4e 00 00       	push   $0x4e48
    21ac:	e8 44 1d 00 00       	call   3ef5 <open>
    21b1:	83 c4 10             	add    $0x10,%esp
    21b4:	85 c0                	test   %eax,%eax
    21b6:	78 17                	js     21cf <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21b8:	83 ec 08             	sub    $0x8,%esp
    21bb:	68 f4 4e 00 00       	push   $0x4ef4
    21c0:	6a 01                	push   $0x1
    21c2:	e8 63 1e 00 00       	call   402a <printf>
    21c7:	83 c4 10             	add    $0x10,%esp
    exit();
    21ca:	e8 e6 1c 00 00       	call   3eb5 <exit>
  }

  if(chdir("dd") != 0){
    21cf:	83 ec 0c             	sub    $0xc,%esp
    21d2:	68 c9 4d 00 00       	push   $0x4dc9
    21d7:	e8 49 1d 00 00       	call   3f25 <chdir>
    21dc:	83 c4 10             	add    $0x10,%esp
    21df:	85 c0                	test   %eax,%eax
    21e1:	74 17                	je     21fa <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    21e3:	83 ec 08             	sub    $0x8,%esp
    21e6:	68 18 4f 00 00       	push   $0x4f18
    21eb:	6a 01                	push   $0x1
    21ed:	e8 38 1e 00 00       	call   402a <printf>
    21f2:	83 c4 10             	add    $0x10,%esp
    exit();
    21f5:	e8 bb 1c 00 00       	call   3eb5 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    21fa:	83 ec 0c             	sub    $0xc,%esp
    21fd:	68 29 4f 00 00       	push   $0x4f29
    2202:	e8 1e 1d 00 00       	call   3f25 <chdir>
    2207:	83 c4 10             	add    $0x10,%esp
    220a:	85 c0                	test   %eax,%eax
    220c:	74 17                	je     2225 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    220e:	83 ec 08             	sub    $0x8,%esp
    2211:	68 35 4f 00 00       	push   $0x4f35
    2216:	6a 01                	push   $0x1
    2218:	e8 0d 1e 00 00       	call   402a <printf>
    221d:	83 c4 10             	add    $0x10,%esp
    exit();
    2220:	e8 90 1c 00 00       	call   3eb5 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2225:	83 ec 0c             	sub    $0xc,%esp
    2228:	68 4f 4f 00 00       	push   $0x4f4f
    222d:	e8 f3 1c 00 00       	call   3f25 <chdir>
    2232:	83 c4 10             	add    $0x10,%esp
    2235:	85 c0                	test   %eax,%eax
    2237:	74 17                	je     2250 <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    2239:	83 ec 08             	sub    $0x8,%esp
    223c:	68 35 4f 00 00       	push   $0x4f35
    2241:	6a 01                	push   $0x1
    2243:	e8 e2 1d 00 00       	call   402a <printf>
    2248:	83 c4 10             	add    $0x10,%esp
    exit();
    224b:	e8 65 1c 00 00       	call   3eb5 <exit>
  }
  if(chdir("./..") != 0){
    2250:	83 ec 0c             	sub    $0xc,%esp
    2253:	68 5e 4f 00 00       	push   $0x4f5e
    2258:	e8 c8 1c 00 00       	call   3f25 <chdir>
    225d:	83 c4 10             	add    $0x10,%esp
    2260:	85 c0                	test   %eax,%eax
    2262:	74 17                	je     227b <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2264:	83 ec 08             	sub    $0x8,%esp
    2267:	68 63 4f 00 00       	push   $0x4f63
    226c:	6a 01                	push   $0x1
    226e:	e8 b7 1d 00 00       	call   402a <printf>
    2273:	83 c4 10             	add    $0x10,%esp
    exit();
    2276:	e8 3a 1c 00 00       	call   3eb5 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    227b:	83 ec 08             	sub    $0x8,%esp
    227e:	6a 00                	push   $0x0
    2280:	68 ac 4e 00 00       	push   $0x4eac
    2285:	e8 6b 1c 00 00       	call   3ef5 <open>
    228a:	83 c4 10             	add    $0x10,%esp
    228d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2294:	79 17                	jns    22ad <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    2296:	83 ec 08             	sub    $0x8,%esp
    2299:	68 76 4f 00 00       	push   $0x4f76
    229e:	6a 01                	push   $0x1
    22a0:	e8 85 1d 00 00       	call   402a <printf>
    22a5:	83 c4 10             	add    $0x10,%esp
    exit();
    22a8:	e8 08 1c 00 00       	call   3eb5 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22ad:	83 ec 04             	sub    $0x4,%esp
    22b0:	68 00 20 00 00       	push   $0x2000
    22b5:	68 c0 8a 00 00       	push   $0x8ac0
    22ba:	ff 75 f4             	pushl  -0xc(%ebp)
    22bd:	e8 0b 1c 00 00       	call   3ecd <read>
    22c2:	83 c4 10             	add    $0x10,%esp
    22c5:	83 f8 02             	cmp    $0x2,%eax
    22c8:	74 17                	je     22e1 <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    22ca:	83 ec 08             	sub    $0x8,%esp
    22cd:	68 8e 4f 00 00       	push   $0x4f8e
    22d2:	6a 01                	push   $0x1
    22d4:	e8 51 1d 00 00       	call   402a <printf>
    22d9:	83 c4 10             	add    $0x10,%esp
    exit();
    22dc:	e8 d4 1b 00 00       	call   3eb5 <exit>
  }
  close(fd);
    22e1:	83 ec 0c             	sub    $0xc,%esp
    22e4:	ff 75 f4             	pushl  -0xc(%ebp)
    22e7:	e8 f1 1b 00 00       	call   3edd <close>
    22ec:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22ef:	83 ec 08             	sub    $0x8,%esp
    22f2:	6a 00                	push   $0x0
    22f4:	68 48 4e 00 00       	push   $0x4e48
    22f9:	e8 f7 1b 00 00       	call   3ef5 <open>
    22fe:	83 c4 10             	add    $0x10,%esp
    2301:	85 c0                	test   %eax,%eax
    2303:	78 17                	js     231c <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2305:	83 ec 08             	sub    $0x8,%esp
    2308:	68 ac 4f 00 00       	push   $0x4fac
    230d:	6a 01                	push   $0x1
    230f:	e8 16 1d 00 00       	call   402a <printf>
    2314:	83 c4 10             	add    $0x10,%esp
    exit();
    2317:	e8 99 1b 00 00       	call   3eb5 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    231c:	83 ec 08             	sub    $0x8,%esp
    231f:	68 02 02 00 00       	push   $0x202
    2324:	68 d1 4f 00 00       	push   $0x4fd1
    2329:	e8 c7 1b 00 00       	call   3ef5 <open>
    232e:	83 c4 10             	add    $0x10,%esp
    2331:	85 c0                	test   %eax,%eax
    2333:	78 17                	js     234c <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2335:	83 ec 08             	sub    $0x8,%esp
    2338:	68 da 4f 00 00       	push   $0x4fda
    233d:	6a 01                	push   $0x1
    233f:	e8 e6 1c 00 00       	call   402a <printf>
    2344:	83 c4 10             	add    $0x10,%esp
    exit();
    2347:	e8 69 1b 00 00       	call   3eb5 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    234c:	83 ec 08             	sub    $0x8,%esp
    234f:	68 02 02 00 00       	push   $0x202
    2354:	68 f6 4f 00 00       	push   $0x4ff6
    2359:	e8 97 1b 00 00       	call   3ef5 <open>
    235e:	83 c4 10             	add    $0x10,%esp
    2361:	85 c0                	test   %eax,%eax
    2363:	78 17                	js     237c <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2365:	83 ec 08             	sub    $0x8,%esp
    2368:	68 ff 4f 00 00       	push   $0x4fff
    236d:	6a 01                	push   $0x1
    236f:	e8 b6 1c 00 00       	call   402a <printf>
    2374:	83 c4 10             	add    $0x10,%esp
    exit();
    2377:	e8 39 1b 00 00       	call   3eb5 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    237c:	83 ec 08             	sub    $0x8,%esp
    237f:	68 00 02 00 00       	push   $0x200
    2384:	68 c9 4d 00 00       	push   $0x4dc9
    2389:	e8 67 1b 00 00       	call   3ef5 <open>
    238e:	83 c4 10             	add    $0x10,%esp
    2391:	85 c0                	test   %eax,%eax
    2393:	78 17                	js     23ac <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    2395:	83 ec 08             	sub    $0x8,%esp
    2398:	68 1b 50 00 00       	push   $0x501b
    239d:	6a 01                	push   $0x1
    239f:	e8 86 1c 00 00       	call   402a <printf>
    23a4:	83 c4 10             	add    $0x10,%esp
    exit();
    23a7:	e8 09 1b 00 00       	call   3eb5 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23ac:	83 ec 08             	sub    $0x8,%esp
    23af:	6a 02                	push   $0x2
    23b1:	68 c9 4d 00 00       	push   $0x4dc9
    23b6:	e8 3a 1b 00 00       	call   3ef5 <open>
    23bb:	83 c4 10             	add    $0x10,%esp
    23be:	85 c0                	test   %eax,%eax
    23c0:	78 17                	js     23d9 <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    23c2:	83 ec 08             	sub    $0x8,%esp
    23c5:	68 31 50 00 00       	push   $0x5031
    23ca:	6a 01                	push   $0x1
    23cc:	e8 59 1c 00 00       	call   402a <printf>
    23d1:	83 c4 10             	add    $0x10,%esp
    exit();
    23d4:	e8 dc 1a 00 00       	call   3eb5 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23d9:	83 ec 08             	sub    $0x8,%esp
    23dc:	6a 01                	push   $0x1
    23de:	68 c9 4d 00 00       	push   $0x4dc9
    23e3:	e8 0d 1b 00 00       	call   3ef5 <open>
    23e8:	83 c4 10             	add    $0x10,%esp
    23eb:	85 c0                	test   %eax,%eax
    23ed:	78 17                	js     2406 <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    23ef:	83 ec 08             	sub    $0x8,%esp
    23f2:	68 4a 50 00 00       	push   $0x504a
    23f7:	6a 01                	push   $0x1
    23f9:	e8 2c 1c 00 00       	call   402a <printf>
    23fe:	83 c4 10             	add    $0x10,%esp
    exit();
    2401:	e8 af 1a 00 00       	call   3eb5 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2406:	83 ec 08             	sub    $0x8,%esp
    2409:	68 65 50 00 00       	push   $0x5065
    240e:	68 d1 4f 00 00       	push   $0x4fd1
    2413:	e8 fd 1a 00 00       	call   3f15 <link>
    2418:	83 c4 10             	add    $0x10,%esp
    241b:	85 c0                	test   %eax,%eax
    241d:	75 17                	jne    2436 <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    241f:	83 ec 08             	sub    $0x8,%esp
    2422:	68 70 50 00 00       	push   $0x5070
    2427:	6a 01                	push   $0x1
    2429:	e8 fc 1b 00 00       	call   402a <printf>
    242e:	83 c4 10             	add    $0x10,%esp
    exit();
    2431:	e8 7f 1a 00 00       	call   3eb5 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2436:	83 ec 08             	sub    $0x8,%esp
    2439:	68 65 50 00 00       	push   $0x5065
    243e:	68 f6 4f 00 00       	push   $0x4ff6
    2443:	e8 cd 1a 00 00       	call   3f15 <link>
    2448:	83 c4 10             	add    $0x10,%esp
    244b:	85 c0                	test   %eax,%eax
    244d:	75 17                	jne    2466 <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    244f:	83 ec 08             	sub    $0x8,%esp
    2452:	68 94 50 00 00       	push   $0x5094
    2457:	6a 01                	push   $0x1
    2459:	e8 cc 1b 00 00       	call   402a <printf>
    245e:	83 c4 10             	add    $0x10,%esp
    exit();
    2461:	e8 4f 1a 00 00       	call   3eb5 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2466:	83 ec 08             	sub    $0x8,%esp
    2469:	68 ac 4e 00 00       	push   $0x4eac
    246e:	68 e4 4d 00 00       	push   $0x4de4
    2473:	e8 9d 1a 00 00       	call   3f15 <link>
    2478:	83 c4 10             	add    $0x10,%esp
    247b:	85 c0                	test   %eax,%eax
    247d:	75 17                	jne    2496 <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    247f:	83 ec 08             	sub    $0x8,%esp
    2482:	68 b8 50 00 00       	push   $0x50b8
    2487:	6a 01                	push   $0x1
    2489:	e8 9c 1b 00 00       	call   402a <printf>
    248e:	83 c4 10             	add    $0x10,%esp
    exit();
    2491:	e8 1f 1a 00 00       	call   3eb5 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2496:	83 ec 0c             	sub    $0xc,%esp
    2499:	68 d1 4f 00 00       	push   $0x4fd1
    249e:	e8 7a 1a 00 00       	call   3f1d <mkdir>
    24a3:	83 c4 10             	add    $0x10,%esp
    24a6:	85 c0                	test   %eax,%eax
    24a8:	75 17                	jne    24c1 <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24aa:	83 ec 08             	sub    $0x8,%esp
    24ad:	68 da 50 00 00       	push   $0x50da
    24b2:	6a 01                	push   $0x1
    24b4:	e8 71 1b 00 00       	call   402a <printf>
    24b9:	83 c4 10             	add    $0x10,%esp
    exit();
    24bc:	e8 f4 19 00 00       	call   3eb5 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24c1:	83 ec 0c             	sub    $0xc,%esp
    24c4:	68 f6 4f 00 00       	push   $0x4ff6
    24c9:	e8 4f 1a 00 00       	call   3f1d <mkdir>
    24ce:	83 c4 10             	add    $0x10,%esp
    24d1:	85 c0                	test   %eax,%eax
    24d3:	75 17                	jne    24ec <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24d5:	83 ec 08             	sub    $0x8,%esp
    24d8:	68 f5 50 00 00       	push   $0x50f5
    24dd:	6a 01                	push   $0x1
    24df:	e8 46 1b 00 00       	call   402a <printf>
    24e4:	83 c4 10             	add    $0x10,%esp
    exit();
    24e7:	e8 c9 19 00 00       	call   3eb5 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24ec:	83 ec 0c             	sub    $0xc,%esp
    24ef:	68 ac 4e 00 00       	push   $0x4eac
    24f4:	e8 24 1a 00 00       	call   3f1d <mkdir>
    24f9:	83 c4 10             	add    $0x10,%esp
    24fc:	85 c0                	test   %eax,%eax
    24fe:	75 17                	jne    2517 <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2500:	83 ec 08             	sub    $0x8,%esp
    2503:	68 10 51 00 00       	push   $0x5110
    2508:	6a 01                	push   $0x1
    250a:	e8 1b 1b 00 00       	call   402a <printf>
    250f:	83 c4 10             	add    $0x10,%esp
    exit();
    2512:	e8 9e 19 00 00       	call   3eb5 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2517:	83 ec 0c             	sub    $0xc,%esp
    251a:	68 f6 4f 00 00       	push   $0x4ff6
    251f:	e8 e1 19 00 00       	call   3f05 <unlink>
    2524:	83 c4 10             	add    $0x10,%esp
    2527:	85 c0                	test   %eax,%eax
    2529:	75 17                	jne    2542 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    252b:	83 ec 08             	sub    $0x8,%esp
    252e:	68 2d 51 00 00       	push   $0x512d
    2533:	6a 01                	push   $0x1
    2535:	e8 f0 1a 00 00       	call   402a <printf>
    253a:	83 c4 10             	add    $0x10,%esp
    exit();
    253d:	e8 73 19 00 00       	call   3eb5 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2542:	83 ec 0c             	sub    $0xc,%esp
    2545:	68 d1 4f 00 00       	push   $0x4fd1
    254a:	e8 b6 19 00 00       	call   3f05 <unlink>
    254f:	83 c4 10             	add    $0x10,%esp
    2552:	85 c0                	test   %eax,%eax
    2554:	75 17                	jne    256d <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2556:	83 ec 08             	sub    $0x8,%esp
    2559:	68 49 51 00 00       	push   $0x5149
    255e:	6a 01                	push   $0x1
    2560:	e8 c5 1a 00 00       	call   402a <printf>
    2565:	83 c4 10             	add    $0x10,%esp
    exit();
    2568:	e8 48 19 00 00       	call   3eb5 <exit>
  }
  if(chdir("dd/ff") == 0){
    256d:	83 ec 0c             	sub    $0xc,%esp
    2570:	68 e4 4d 00 00       	push   $0x4de4
    2575:	e8 ab 19 00 00       	call   3f25 <chdir>
    257a:	83 c4 10             	add    $0x10,%esp
    257d:	85 c0                	test   %eax,%eax
    257f:	75 17                	jne    2598 <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    2581:	83 ec 08             	sub    $0x8,%esp
    2584:	68 65 51 00 00       	push   $0x5165
    2589:	6a 01                	push   $0x1
    258b:	e8 9a 1a 00 00       	call   402a <printf>
    2590:	83 c4 10             	add    $0x10,%esp
    exit();
    2593:	e8 1d 19 00 00       	call   3eb5 <exit>
  }
  if(chdir("dd/xx") == 0){
    2598:	83 ec 0c             	sub    $0xc,%esp
    259b:	68 7d 51 00 00       	push   $0x517d
    25a0:	e8 80 19 00 00       	call   3f25 <chdir>
    25a5:	83 c4 10             	add    $0x10,%esp
    25a8:	85 c0                	test   %eax,%eax
    25aa:	75 17                	jne    25c3 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    25ac:	83 ec 08             	sub    $0x8,%esp
    25af:	68 83 51 00 00       	push   $0x5183
    25b4:	6a 01                	push   $0x1
    25b6:	e8 6f 1a 00 00       	call   402a <printf>
    25bb:	83 c4 10             	add    $0x10,%esp
    exit();
    25be:	e8 f2 18 00 00       	call   3eb5 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25c3:	83 ec 0c             	sub    $0xc,%esp
    25c6:	68 ac 4e 00 00       	push   $0x4eac
    25cb:	e8 35 19 00 00       	call   3f05 <unlink>
    25d0:	83 c4 10             	add    $0x10,%esp
    25d3:	85 c0                	test   %eax,%eax
    25d5:	74 17                	je     25ee <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    25d7:	83 ec 08             	sub    $0x8,%esp
    25da:	68 d9 4e 00 00       	push   $0x4ed9
    25df:	6a 01                	push   $0x1
    25e1:	e8 44 1a 00 00       	call   402a <printf>
    25e6:	83 c4 10             	add    $0x10,%esp
    exit();
    25e9:	e8 c7 18 00 00       	call   3eb5 <exit>
  }
  if(unlink("dd/ff") != 0){
    25ee:	83 ec 0c             	sub    $0xc,%esp
    25f1:	68 e4 4d 00 00       	push   $0x4de4
    25f6:	e8 0a 19 00 00       	call   3f05 <unlink>
    25fb:	83 c4 10             	add    $0x10,%esp
    25fe:	85 c0                	test   %eax,%eax
    2600:	74 17                	je     2619 <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2602:	83 ec 08             	sub    $0x8,%esp
    2605:	68 9b 51 00 00       	push   $0x519b
    260a:	6a 01                	push   $0x1
    260c:	e8 19 1a 00 00       	call   402a <printf>
    2611:	83 c4 10             	add    $0x10,%esp
    exit();
    2614:	e8 9c 18 00 00       	call   3eb5 <exit>
  }
  if(unlink("dd") == 0){
    2619:	83 ec 0c             	sub    $0xc,%esp
    261c:	68 c9 4d 00 00       	push   $0x4dc9
    2621:	e8 df 18 00 00       	call   3f05 <unlink>
    2626:	83 c4 10             	add    $0x10,%esp
    2629:	85 c0                	test   %eax,%eax
    262b:	75 17                	jne    2644 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    262d:	83 ec 08             	sub    $0x8,%esp
    2630:	68 b0 51 00 00       	push   $0x51b0
    2635:	6a 01                	push   $0x1
    2637:	e8 ee 19 00 00       	call   402a <printf>
    263c:	83 c4 10             	add    $0x10,%esp
    exit();
    263f:	e8 71 18 00 00       	call   3eb5 <exit>
  }
  if(unlink("dd/dd") < 0){
    2644:	83 ec 0c             	sub    $0xc,%esp
    2647:	68 d0 51 00 00       	push   $0x51d0
    264c:	e8 b4 18 00 00       	call   3f05 <unlink>
    2651:	83 c4 10             	add    $0x10,%esp
    2654:	85 c0                	test   %eax,%eax
    2656:	79 17                	jns    266f <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    2658:	83 ec 08             	sub    $0x8,%esp
    265b:	68 d6 51 00 00       	push   $0x51d6
    2660:	6a 01                	push   $0x1
    2662:	e8 c3 19 00 00       	call   402a <printf>
    2667:	83 c4 10             	add    $0x10,%esp
    exit();
    266a:	e8 46 18 00 00       	call   3eb5 <exit>
  }
  if(unlink("dd") < 0){
    266f:	83 ec 0c             	sub    $0xc,%esp
    2672:	68 c9 4d 00 00       	push   $0x4dc9
    2677:	e8 89 18 00 00       	call   3f05 <unlink>
    267c:	83 c4 10             	add    $0x10,%esp
    267f:	85 c0                	test   %eax,%eax
    2681:	79 17                	jns    269a <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    2683:	83 ec 08             	sub    $0x8,%esp
    2686:	68 eb 51 00 00       	push   $0x51eb
    268b:	6a 01                	push   $0x1
    268d:	e8 98 19 00 00       	call   402a <printf>
    2692:	83 c4 10             	add    $0x10,%esp
    exit();
    2695:	e8 1b 18 00 00       	call   3eb5 <exit>
  }

  printf(1, "subdir ok\n");
    269a:	83 ec 08             	sub    $0x8,%esp
    269d:	68 fd 51 00 00       	push   $0x51fd
    26a2:	6a 01                	push   $0x1
    26a4:	e8 81 19 00 00       	call   402a <printf>
    26a9:	83 c4 10             	add    $0x10,%esp
}
    26ac:	c9                   	leave  
    26ad:	c3                   	ret    

000026ae <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26ae:	55                   	push   %ebp
    26af:	89 e5                	mov    %esp,%ebp
    26b1:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26b4:	83 ec 08             	sub    $0x8,%esp
    26b7:	68 08 52 00 00       	push   $0x5208
    26bc:	6a 01                	push   $0x1
    26be:	e8 67 19 00 00       	call   402a <printf>
    26c3:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    26c6:	83 ec 0c             	sub    $0xc,%esp
    26c9:	68 17 52 00 00       	push   $0x5217
    26ce:	e8 32 18 00 00       	call   3f05 <unlink>
    26d3:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    26d6:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26dd:	e9 a8 00 00 00       	jmp    278a <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26e2:	83 ec 08             	sub    $0x8,%esp
    26e5:	68 02 02 00 00       	push   $0x202
    26ea:	68 17 52 00 00       	push   $0x5217
    26ef:	e8 01 18 00 00       	call   3ef5 <open>
    26f4:	83 c4 10             	add    $0x10,%esp
    26f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    26fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    26fe:	79 17                	jns    2717 <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    2700:	83 ec 08             	sub    $0x8,%esp
    2703:	68 20 52 00 00       	push   $0x5220
    2708:	6a 01                	push   $0x1
    270a:	e8 1b 19 00 00       	call   402a <printf>
    270f:	83 c4 10             	add    $0x10,%esp
      exit();
    2712:	e8 9e 17 00 00       	call   3eb5 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2717:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    271e:	eb 3f                	jmp    275f <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    2720:	83 ec 04             	sub    $0x4,%esp
    2723:	ff 75 f4             	pushl  -0xc(%ebp)
    2726:	68 c0 8a 00 00       	push   $0x8ac0
    272b:	ff 75 ec             	pushl  -0x14(%ebp)
    272e:	e8 a2 17 00 00       	call   3ed5 <write>
    2733:	83 c4 10             	add    $0x10,%esp
    2736:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2739:	8b 45 e8             	mov    -0x18(%ebp),%eax
    273c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    273f:	74 1a                	je     275b <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2741:	ff 75 e8             	pushl  -0x18(%ebp)
    2744:	ff 75 f4             	pushl  -0xc(%ebp)
    2747:	68 38 52 00 00       	push   $0x5238
    274c:	6a 01                	push   $0x1
    274e:	e8 d7 18 00 00       	call   402a <printf>
    2753:	83 c4 10             	add    $0x10,%esp
        exit();
    2756:	e8 5a 17 00 00       	call   3eb5 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    275b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    275f:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2763:	7e bb                	jle    2720 <bigwrite+0x72>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2765:	83 ec 0c             	sub    $0xc,%esp
    2768:	ff 75 ec             	pushl  -0x14(%ebp)
    276b:	e8 6d 17 00 00       	call   3edd <close>
    2770:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2773:	83 ec 0c             	sub    $0xc,%esp
    2776:	68 17 52 00 00       	push   $0x5217
    277b:	e8 85 17 00 00       	call   3f05 <unlink>
    2780:	83 c4 10             	add    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2783:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    278a:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2791:	0f 8e 4b ff ff ff    	jle    26e2 <bigwrite+0x34>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2797:	83 ec 08             	sub    $0x8,%esp
    279a:	68 4a 52 00 00       	push   $0x524a
    279f:	6a 01                	push   $0x1
    27a1:	e8 84 18 00 00       	call   402a <printf>
    27a6:	83 c4 10             	add    $0x10,%esp
}
    27a9:	c9                   	leave  
    27aa:	c3                   	ret    

000027ab <bigfile>:

void
bigfile(void)
{
    27ab:	55                   	push   %ebp
    27ac:	89 e5                	mov    %esp,%ebp
    27ae:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27b1:	83 ec 08             	sub    $0x8,%esp
    27b4:	68 57 52 00 00       	push   $0x5257
    27b9:	6a 01                	push   $0x1
    27bb:	e8 6a 18 00 00       	call   402a <printf>
    27c0:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    27c3:	83 ec 0c             	sub    $0xc,%esp
    27c6:	68 65 52 00 00       	push   $0x5265
    27cb:	e8 35 17 00 00       	call   3f05 <unlink>
    27d0:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    27d3:	83 ec 08             	sub    $0x8,%esp
    27d6:	68 02 02 00 00       	push   $0x202
    27db:	68 65 52 00 00       	push   $0x5265
    27e0:	e8 10 17 00 00       	call   3ef5 <open>
    27e5:	83 c4 10             	add    $0x10,%esp
    27e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    27eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    27ef:	79 17                	jns    2808 <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    27f1:	83 ec 08             	sub    $0x8,%esp
    27f4:	68 6d 52 00 00       	push   $0x526d
    27f9:	6a 01                	push   $0x1
    27fb:	e8 2a 18 00 00       	call   402a <printf>
    2800:	83 c4 10             	add    $0x10,%esp
    exit();
    2803:	e8 ad 16 00 00       	call   3eb5 <exit>
  }
  for(i = 0; i < 20; i++){
    2808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    280f:	eb 52                	jmp    2863 <bigfile+0xb8>
    memset(buf, i, 600);
    2811:	83 ec 04             	sub    $0x4,%esp
    2814:	68 58 02 00 00       	push   $0x258
    2819:	ff 75 f4             	pushl  -0xc(%ebp)
    281c:	68 c0 8a 00 00       	push   $0x8ac0
    2821:	e8 f5 14 00 00       	call   3d1b <memset>
    2826:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    2829:	83 ec 04             	sub    $0x4,%esp
    282c:	68 58 02 00 00       	push   $0x258
    2831:	68 c0 8a 00 00       	push   $0x8ac0
    2836:	ff 75 ec             	pushl  -0x14(%ebp)
    2839:	e8 97 16 00 00       	call   3ed5 <write>
    283e:	83 c4 10             	add    $0x10,%esp
    2841:	3d 58 02 00 00       	cmp    $0x258,%eax
    2846:	74 17                	je     285f <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    2848:	83 ec 08             	sub    $0x8,%esp
    284b:	68 83 52 00 00       	push   $0x5283
    2850:	6a 01                	push   $0x1
    2852:	e8 d3 17 00 00       	call   402a <printf>
    2857:	83 c4 10             	add    $0x10,%esp
      exit();
    285a:	e8 56 16 00 00       	call   3eb5 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    285f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2863:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2867:	7e a8                	jle    2811 <bigfile+0x66>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2869:	83 ec 0c             	sub    $0xc,%esp
    286c:	ff 75 ec             	pushl  -0x14(%ebp)
    286f:	e8 69 16 00 00       	call   3edd <close>
    2874:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    2877:	83 ec 08             	sub    $0x8,%esp
    287a:	6a 00                	push   $0x0
    287c:	68 65 52 00 00       	push   $0x5265
    2881:	e8 6f 16 00 00       	call   3ef5 <open>
    2886:	83 c4 10             	add    $0x10,%esp
    2889:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    288c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2890:	79 17                	jns    28a9 <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    2892:	83 ec 08             	sub    $0x8,%esp
    2895:	68 99 52 00 00       	push   $0x5299
    289a:	6a 01                	push   $0x1
    289c:	e8 89 17 00 00       	call   402a <printf>
    28a1:	83 c4 10             	add    $0x10,%esp
    exit();
    28a4:	e8 0c 16 00 00       	call   3eb5 <exit>
  }
  total = 0;
    28a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28b7:	83 ec 04             	sub    $0x4,%esp
    28ba:	68 2c 01 00 00       	push   $0x12c
    28bf:	68 c0 8a 00 00       	push   $0x8ac0
    28c4:	ff 75 ec             	pushl  -0x14(%ebp)
    28c7:	e8 01 16 00 00       	call   3ecd <read>
    28cc:	83 c4 10             	add    $0x10,%esp
    28cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28d6:	79 17                	jns    28ef <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    28d8:	83 ec 08             	sub    $0x8,%esp
    28db:	68 ae 52 00 00       	push   $0x52ae
    28e0:	6a 01                	push   $0x1
    28e2:	e8 43 17 00 00       	call   402a <printf>
    28e7:	83 c4 10             	add    $0x10,%esp
      exit();
    28ea:	e8 c6 15 00 00       	call   3eb5 <exit>
    }
    if(cc == 0)
    28ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28f3:	75 1e                	jne    2913 <bigfile+0x168>
      break;
    28f5:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    28f6:	83 ec 0c             	sub    $0xc,%esp
    28f9:	ff 75 ec             	pushl  -0x14(%ebp)
    28fc:	e8 dc 15 00 00       	call   3edd <close>
    2901:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    2904:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    290b:	0f 84 93 00 00 00    	je     29a4 <bigfile+0x1f9>
    2911:	eb 7a                	jmp    298d <bigfile+0x1e2>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    2913:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    291a:	74 17                	je     2933 <bigfile+0x188>
      printf(1, "short read bigfile\n");
    291c:	83 ec 08             	sub    $0x8,%esp
    291f:	68 c3 52 00 00       	push   $0x52c3
    2924:	6a 01                	push   $0x1
    2926:	e8 ff 16 00 00       	call   402a <printf>
    292b:	83 c4 10             	add    $0x10,%esp
      exit();
    292e:	e8 82 15 00 00       	call   3eb5 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2933:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    293a:	0f be d0             	movsbl %al,%edx
    293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2940:	89 c1                	mov    %eax,%ecx
    2942:	c1 e9 1f             	shr    $0x1f,%ecx
    2945:	01 c8                	add    %ecx,%eax
    2947:	d1 f8                	sar    %eax
    2949:	39 c2                	cmp    %eax,%edx
    294b:	75 1a                	jne    2967 <bigfile+0x1bc>
    294d:	0f b6 05 eb 8b 00 00 	movzbl 0x8beb,%eax
    2954:	0f be d0             	movsbl %al,%edx
    2957:	8b 45 f4             	mov    -0xc(%ebp),%eax
    295a:	89 c1                	mov    %eax,%ecx
    295c:	c1 e9 1f             	shr    $0x1f,%ecx
    295f:	01 c8                	add    %ecx,%eax
    2961:	d1 f8                	sar    %eax
    2963:	39 c2                	cmp    %eax,%edx
    2965:	74 17                	je     297e <bigfile+0x1d3>
      printf(1, "read bigfile wrong data\n");
    2967:	83 ec 08             	sub    $0x8,%esp
    296a:	68 d7 52 00 00       	push   $0x52d7
    296f:	6a 01                	push   $0x1
    2971:	e8 b4 16 00 00       	call   402a <printf>
    2976:	83 c4 10             	add    $0x10,%esp
      exit();
    2979:	e8 37 15 00 00       	call   3eb5 <exit>
    }
    total += cc;
    297e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2981:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    2984:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2988:	e9 2a ff ff ff       	jmp    28b7 <bigfile+0x10c>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    298d:	83 ec 08             	sub    $0x8,%esp
    2990:	68 f0 52 00 00       	push   $0x52f0
    2995:	6a 01                	push   $0x1
    2997:	e8 8e 16 00 00       	call   402a <printf>
    299c:	83 c4 10             	add    $0x10,%esp
    exit();
    299f:	e8 11 15 00 00       	call   3eb5 <exit>
  }
  unlink("bigfile");
    29a4:	83 ec 0c             	sub    $0xc,%esp
    29a7:	68 65 52 00 00       	push   $0x5265
    29ac:	e8 54 15 00 00       	call   3f05 <unlink>
    29b1:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    29b4:	83 ec 08             	sub    $0x8,%esp
    29b7:	68 0a 53 00 00       	push   $0x530a
    29bc:	6a 01                	push   $0x1
    29be:	e8 67 16 00 00       	call   402a <printf>
    29c3:	83 c4 10             	add    $0x10,%esp
}
    29c6:	c9                   	leave  
    29c7:	c3                   	ret    

000029c8 <fourteen>:

void
fourteen(void)
{
    29c8:	55                   	push   %ebp
    29c9:	89 e5                	mov    %esp,%ebp
    29cb:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29ce:	83 ec 08             	sub    $0x8,%esp
    29d1:	68 1b 53 00 00       	push   $0x531b
    29d6:	6a 01                	push   $0x1
    29d8:	e8 4d 16 00 00       	call   402a <printf>
    29dd:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    29e0:	83 ec 0c             	sub    $0xc,%esp
    29e3:	68 2a 53 00 00       	push   $0x532a
    29e8:	e8 30 15 00 00       	call   3f1d <mkdir>
    29ed:	83 c4 10             	add    $0x10,%esp
    29f0:	85 c0                	test   %eax,%eax
    29f2:	74 17                	je     2a0b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    29f4:	83 ec 08             	sub    $0x8,%esp
    29f7:	68 39 53 00 00       	push   $0x5339
    29fc:	6a 01                	push   $0x1
    29fe:	e8 27 16 00 00       	call   402a <printf>
    2a03:	83 c4 10             	add    $0x10,%esp
    exit();
    2a06:	e8 aa 14 00 00       	call   3eb5 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a0b:	83 ec 0c             	sub    $0xc,%esp
    2a0e:	68 58 53 00 00       	push   $0x5358
    2a13:	e8 05 15 00 00       	call   3f1d <mkdir>
    2a18:	83 c4 10             	add    $0x10,%esp
    2a1b:	85 c0                	test   %eax,%eax
    2a1d:	74 17                	je     2a36 <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a1f:	83 ec 08             	sub    $0x8,%esp
    2a22:	68 78 53 00 00       	push   $0x5378
    2a27:	6a 01                	push   $0x1
    2a29:	e8 fc 15 00 00       	call   402a <printf>
    2a2e:	83 c4 10             	add    $0x10,%esp
    exit();
    2a31:	e8 7f 14 00 00       	call   3eb5 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a36:	83 ec 08             	sub    $0x8,%esp
    2a39:	68 00 02 00 00       	push   $0x200
    2a3e:	68 a8 53 00 00       	push   $0x53a8
    2a43:	e8 ad 14 00 00       	call   3ef5 <open>
    2a48:	83 c4 10             	add    $0x10,%esp
    2a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a52:	79 17                	jns    2a6b <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a54:	83 ec 08             	sub    $0x8,%esp
    2a57:	68 d8 53 00 00       	push   $0x53d8
    2a5c:	6a 01                	push   $0x1
    2a5e:	e8 c7 15 00 00       	call   402a <printf>
    2a63:	83 c4 10             	add    $0x10,%esp
    exit();
    2a66:	e8 4a 14 00 00       	call   3eb5 <exit>
  }
  close(fd);
    2a6b:	83 ec 0c             	sub    $0xc,%esp
    2a6e:	ff 75 f4             	pushl  -0xc(%ebp)
    2a71:	e8 67 14 00 00       	call   3edd <close>
    2a76:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a79:	83 ec 08             	sub    $0x8,%esp
    2a7c:	6a 00                	push   $0x0
    2a7e:	68 18 54 00 00       	push   $0x5418
    2a83:	e8 6d 14 00 00       	call   3ef5 <open>
    2a88:	83 c4 10             	add    $0x10,%esp
    2a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a92:	79 17                	jns    2aab <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2a94:	83 ec 08             	sub    $0x8,%esp
    2a97:	68 48 54 00 00       	push   $0x5448
    2a9c:	6a 01                	push   $0x1
    2a9e:	e8 87 15 00 00       	call   402a <printf>
    2aa3:	83 c4 10             	add    $0x10,%esp
    exit();
    2aa6:	e8 0a 14 00 00       	call   3eb5 <exit>
  }
  close(fd);
    2aab:	83 ec 0c             	sub    $0xc,%esp
    2aae:	ff 75 f4             	pushl  -0xc(%ebp)
    2ab1:	e8 27 14 00 00       	call   3edd <close>
    2ab6:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2ab9:	83 ec 0c             	sub    $0xc,%esp
    2abc:	68 82 54 00 00       	push   $0x5482
    2ac1:	e8 57 14 00 00       	call   3f1d <mkdir>
    2ac6:	83 c4 10             	add    $0x10,%esp
    2ac9:	85 c0                	test   %eax,%eax
    2acb:	75 17                	jne    2ae4 <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2acd:	83 ec 08             	sub    $0x8,%esp
    2ad0:	68 a0 54 00 00       	push   $0x54a0
    2ad5:	6a 01                	push   $0x1
    2ad7:	e8 4e 15 00 00       	call   402a <printf>
    2adc:	83 c4 10             	add    $0x10,%esp
    exit();
    2adf:	e8 d1 13 00 00       	call   3eb5 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2ae4:	83 ec 0c             	sub    $0xc,%esp
    2ae7:	68 d0 54 00 00       	push   $0x54d0
    2aec:	e8 2c 14 00 00       	call   3f1d <mkdir>
    2af1:	83 c4 10             	add    $0x10,%esp
    2af4:	85 c0                	test   %eax,%eax
    2af6:	75 17                	jne    2b0f <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2af8:	83 ec 08             	sub    $0x8,%esp
    2afb:	68 f0 54 00 00       	push   $0x54f0
    2b00:	6a 01                	push   $0x1
    2b02:	e8 23 15 00 00       	call   402a <printf>
    2b07:	83 c4 10             	add    $0x10,%esp
    exit();
    2b0a:	e8 a6 13 00 00       	call   3eb5 <exit>
  }

  printf(1, "fourteen ok\n");
    2b0f:	83 ec 08             	sub    $0x8,%esp
    2b12:	68 21 55 00 00       	push   $0x5521
    2b17:	6a 01                	push   $0x1
    2b19:	e8 0c 15 00 00       	call   402a <printf>
    2b1e:	83 c4 10             	add    $0x10,%esp
}
    2b21:	c9                   	leave  
    2b22:	c3                   	ret    

00002b23 <rmdot>:

void
rmdot(void)
{
    2b23:	55                   	push   %ebp
    2b24:	89 e5                	mov    %esp,%ebp
    2b26:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2b29:	83 ec 08             	sub    $0x8,%esp
    2b2c:	68 2e 55 00 00       	push   $0x552e
    2b31:	6a 01                	push   $0x1
    2b33:	e8 f2 14 00 00       	call   402a <printf>
    2b38:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2b3b:	83 ec 0c             	sub    $0xc,%esp
    2b3e:	68 3a 55 00 00       	push   $0x553a
    2b43:	e8 d5 13 00 00       	call   3f1d <mkdir>
    2b48:	83 c4 10             	add    $0x10,%esp
    2b4b:	85 c0                	test   %eax,%eax
    2b4d:	74 17                	je     2b66 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b4f:	83 ec 08             	sub    $0x8,%esp
    2b52:	68 3f 55 00 00       	push   $0x553f
    2b57:	6a 01                	push   $0x1
    2b59:	e8 cc 14 00 00       	call   402a <printf>
    2b5e:	83 c4 10             	add    $0x10,%esp
    exit();
    2b61:	e8 4f 13 00 00       	call   3eb5 <exit>
  }
  if(chdir("dots") != 0){
    2b66:	83 ec 0c             	sub    $0xc,%esp
    2b69:	68 3a 55 00 00       	push   $0x553a
    2b6e:	e8 b2 13 00 00       	call   3f25 <chdir>
    2b73:	83 c4 10             	add    $0x10,%esp
    2b76:	85 c0                	test   %eax,%eax
    2b78:	74 17                	je     2b91 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b7a:	83 ec 08             	sub    $0x8,%esp
    2b7d:	68 52 55 00 00       	push   $0x5552
    2b82:	6a 01                	push   $0x1
    2b84:	e8 a1 14 00 00       	call   402a <printf>
    2b89:	83 c4 10             	add    $0x10,%esp
    exit();
    2b8c:	e8 24 13 00 00       	call   3eb5 <exit>
  }
  if(unlink(".") == 0){
    2b91:	83 ec 0c             	sub    $0xc,%esp
    2b94:	68 6b 4c 00 00       	push   $0x4c6b
    2b99:	e8 67 13 00 00       	call   3f05 <unlink>
    2b9e:	83 c4 10             	add    $0x10,%esp
    2ba1:	85 c0                	test   %eax,%eax
    2ba3:	75 17                	jne    2bbc <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2ba5:	83 ec 08             	sub    $0x8,%esp
    2ba8:	68 65 55 00 00       	push   $0x5565
    2bad:	6a 01                	push   $0x1
    2baf:	e8 76 14 00 00       	call   402a <printf>
    2bb4:	83 c4 10             	add    $0x10,%esp
    exit();
    2bb7:	e8 f9 12 00 00       	call   3eb5 <exit>
  }
  if(unlink("..") == 0){
    2bbc:	83 ec 0c             	sub    $0xc,%esp
    2bbf:	68 fe 47 00 00       	push   $0x47fe
    2bc4:	e8 3c 13 00 00       	call   3f05 <unlink>
    2bc9:	83 c4 10             	add    $0x10,%esp
    2bcc:	85 c0                	test   %eax,%eax
    2bce:	75 17                	jne    2be7 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2bd0:	83 ec 08             	sub    $0x8,%esp
    2bd3:	68 73 55 00 00       	push   $0x5573
    2bd8:	6a 01                	push   $0x1
    2bda:	e8 4b 14 00 00       	call   402a <printf>
    2bdf:	83 c4 10             	add    $0x10,%esp
    exit();
    2be2:	e8 ce 12 00 00       	call   3eb5 <exit>
  }
  if(chdir("/") != 0){
    2be7:	83 ec 0c             	sub    $0xc,%esp
    2bea:	68 52 44 00 00       	push   $0x4452
    2bef:	e8 31 13 00 00       	call   3f25 <chdir>
    2bf4:	83 c4 10             	add    $0x10,%esp
    2bf7:	85 c0                	test   %eax,%eax
    2bf9:	74 17                	je     2c12 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2bfb:	83 ec 08             	sub    $0x8,%esp
    2bfe:	68 54 44 00 00       	push   $0x4454
    2c03:	6a 01                	push   $0x1
    2c05:	e8 20 14 00 00       	call   402a <printf>
    2c0a:	83 c4 10             	add    $0x10,%esp
    exit();
    2c0d:	e8 a3 12 00 00       	call   3eb5 <exit>
  }
  if(unlink("dots/.") == 0){
    2c12:	83 ec 0c             	sub    $0xc,%esp
    2c15:	68 82 55 00 00       	push   $0x5582
    2c1a:	e8 e6 12 00 00       	call   3f05 <unlink>
    2c1f:	83 c4 10             	add    $0x10,%esp
    2c22:	85 c0                	test   %eax,%eax
    2c24:	75 17                	jne    2c3d <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2c26:	83 ec 08             	sub    $0x8,%esp
    2c29:	68 89 55 00 00       	push   $0x5589
    2c2e:	6a 01                	push   $0x1
    2c30:	e8 f5 13 00 00       	call   402a <printf>
    2c35:	83 c4 10             	add    $0x10,%esp
    exit();
    2c38:	e8 78 12 00 00       	call   3eb5 <exit>
  }
  if(unlink("dots/..") == 0){
    2c3d:	83 ec 0c             	sub    $0xc,%esp
    2c40:	68 a0 55 00 00       	push   $0x55a0
    2c45:	e8 bb 12 00 00       	call   3f05 <unlink>
    2c4a:	83 c4 10             	add    $0x10,%esp
    2c4d:	85 c0                	test   %eax,%eax
    2c4f:	75 17                	jne    2c68 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2c51:	83 ec 08             	sub    $0x8,%esp
    2c54:	68 a8 55 00 00       	push   $0x55a8
    2c59:	6a 01                	push   $0x1
    2c5b:	e8 ca 13 00 00       	call   402a <printf>
    2c60:	83 c4 10             	add    $0x10,%esp
    exit();
    2c63:	e8 4d 12 00 00       	call   3eb5 <exit>
  }
  if(unlink("dots") != 0){
    2c68:	83 ec 0c             	sub    $0xc,%esp
    2c6b:	68 3a 55 00 00       	push   $0x553a
    2c70:	e8 90 12 00 00       	call   3f05 <unlink>
    2c75:	83 c4 10             	add    $0x10,%esp
    2c78:	85 c0                	test   %eax,%eax
    2c7a:	74 17                	je     2c93 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c7c:	83 ec 08             	sub    $0x8,%esp
    2c7f:	68 c0 55 00 00       	push   $0x55c0
    2c84:	6a 01                	push   $0x1
    2c86:	e8 9f 13 00 00       	call   402a <printf>
    2c8b:	83 c4 10             	add    $0x10,%esp
    exit();
    2c8e:	e8 22 12 00 00       	call   3eb5 <exit>
  }
  printf(1, "rmdot ok\n");
    2c93:	83 ec 08             	sub    $0x8,%esp
    2c96:	68 d5 55 00 00       	push   $0x55d5
    2c9b:	6a 01                	push   $0x1
    2c9d:	e8 88 13 00 00       	call   402a <printf>
    2ca2:	83 c4 10             	add    $0x10,%esp
}
    2ca5:	c9                   	leave  
    2ca6:	c3                   	ret    

00002ca7 <dirfile>:

void
dirfile(void)
{
    2ca7:	55                   	push   %ebp
    2ca8:	89 e5                	mov    %esp,%ebp
    2caa:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cad:	83 ec 08             	sub    $0x8,%esp
    2cb0:	68 df 55 00 00       	push   $0x55df
    2cb5:	6a 01                	push   $0x1
    2cb7:	e8 6e 13 00 00       	call   402a <printf>
    2cbc:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2cbf:	83 ec 08             	sub    $0x8,%esp
    2cc2:	68 00 02 00 00       	push   $0x200
    2cc7:	68 ec 55 00 00       	push   $0x55ec
    2ccc:	e8 24 12 00 00       	call   3ef5 <open>
    2cd1:	83 c4 10             	add    $0x10,%esp
    2cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cdb:	79 17                	jns    2cf4 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2cdd:	83 ec 08             	sub    $0x8,%esp
    2ce0:	68 f4 55 00 00       	push   $0x55f4
    2ce5:	6a 01                	push   $0x1
    2ce7:	e8 3e 13 00 00       	call   402a <printf>
    2cec:	83 c4 10             	add    $0x10,%esp
    exit();
    2cef:	e8 c1 11 00 00       	call   3eb5 <exit>
  }
  close(fd);
    2cf4:	83 ec 0c             	sub    $0xc,%esp
    2cf7:	ff 75 f4             	pushl  -0xc(%ebp)
    2cfa:	e8 de 11 00 00       	call   3edd <close>
    2cff:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d02:	83 ec 0c             	sub    $0xc,%esp
    2d05:	68 ec 55 00 00       	push   $0x55ec
    2d0a:	e8 16 12 00 00       	call   3f25 <chdir>
    2d0f:	83 c4 10             	add    $0x10,%esp
    2d12:	85 c0                	test   %eax,%eax
    2d14:	75 17                	jne    2d2d <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2d16:	83 ec 08             	sub    $0x8,%esp
    2d19:	68 0b 56 00 00       	push   $0x560b
    2d1e:	6a 01                	push   $0x1
    2d20:	e8 05 13 00 00       	call   402a <printf>
    2d25:	83 c4 10             	add    $0x10,%esp
    exit();
    2d28:	e8 88 11 00 00       	call   3eb5 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d2d:	83 ec 08             	sub    $0x8,%esp
    2d30:	6a 00                	push   $0x0
    2d32:	68 25 56 00 00       	push   $0x5625
    2d37:	e8 b9 11 00 00       	call   3ef5 <open>
    2d3c:	83 c4 10             	add    $0x10,%esp
    2d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d46:	78 17                	js     2d5f <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2d48:	83 ec 08             	sub    $0x8,%esp
    2d4b:	68 30 56 00 00       	push   $0x5630
    2d50:	6a 01                	push   $0x1
    2d52:	e8 d3 12 00 00       	call   402a <printf>
    2d57:	83 c4 10             	add    $0x10,%esp
    exit();
    2d5a:	e8 56 11 00 00       	call   3eb5 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d5f:	83 ec 08             	sub    $0x8,%esp
    2d62:	68 00 02 00 00       	push   $0x200
    2d67:	68 25 56 00 00       	push   $0x5625
    2d6c:	e8 84 11 00 00       	call   3ef5 <open>
    2d71:	83 c4 10             	add    $0x10,%esp
    2d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d7b:	78 17                	js     2d94 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2d7d:	83 ec 08             	sub    $0x8,%esp
    2d80:	68 30 56 00 00       	push   $0x5630
    2d85:	6a 01                	push   $0x1
    2d87:	e8 9e 12 00 00       	call   402a <printf>
    2d8c:	83 c4 10             	add    $0x10,%esp
    exit();
    2d8f:	e8 21 11 00 00       	call   3eb5 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d94:	83 ec 0c             	sub    $0xc,%esp
    2d97:	68 25 56 00 00       	push   $0x5625
    2d9c:	e8 7c 11 00 00       	call   3f1d <mkdir>
    2da1:	83 c4 10             	add    $0x10,%esp
    2da4:	85 c0                	test   %eax,%eax
    2da6:	75 17                	jne    2dbf <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2da8:	83 ec 08             	sub    $0x8,%esp
    2dab:	68 4e 56 00 00       	push   $0x564e
    2db0:	6a 01                	push   $0x1
    2db2:	e8 73 12 00 00       	call   402a <printf>
    2db7:	83 c4 10             	add    $0x10,%esp
    exit();
    2dba:	e8 f6 10 00 00       	call   3eb5 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dbf:	83 ec 0c             	sub    $0xc,%esp
    2dc2:	68 25 56 00 00       	push   $0x5625
    2dc7:	e8 39 11 00 00       	call   3f05 <unlink>
    2dcc:	83 c4 10             	add    $0x10,%esp
    2dcf:	85 c0                	test   %eax,%eax
    2dd1:	75 17                	jne    2dea <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2dd3:	83 ec 08             	sub    $0x8,%esp
    2dd6:	68 6b 56 00 00       	push   $0x566b
    2ddb:	6a 01                	push   $0x1
    2ddd:	e8 48 12 00 00       	call   402a <printf>
    2de2:	83 c4 10             	add    $0x10,%esp
    exit();
    2de5:	e8 cb 10 00 00       	call   3eb5 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2dea:	83 ec 08             	sub    $0x8,%esp
    2ded:	68 25 56 00 00       	push   $0x5625
    2df2:	68 89 56 00 00       	push   $0x5689
    2df7:	e8 19 11 00 00       	call   3f15 <link>
    2dfc:	83 c4 10             	add    $0x10,%esp
    2dff:	85 c0                	test   %eax,%eax
    2e01:	75 17                	jne    2e1a <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e03:	83 ec 08             	sub    $0x8,%esp
    2e06:	68 90 56 00 00       	push   $0x5690
    2e0b:	6a 01                	push   $0x1
    2e0d:	e8 18 12 00 00       	call   402a <printf>
    2e12:	83 c4 10             	add    $0x10,%esp
    exit();
    2e15:	e8 9b 10 00 00       	call   3eb5 <exit>
  }
  if(unlink("dirfile") != 0){
    2e1a:	83 ec 0c             	sub    $0xc,%esp
    2e1d:	68 ec 55 00 00       	push   $0x55ec
    2e22:	e8 de 10 00 00       	call   3f05 <unlink>
    2e27:	83 c4 10             	add    $0x10,%esp
    2e2a:	85 c0                	test   %eax,%eax
    2e2c:	74 17                	je     2e45 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2e2e:	83 ec 08             	sub    $0x8,%esp
    2e31:	68 af 56 00 00       	push   $0x56af
    2e36:	6a 01                	push   $0x1
    2e38:	e8 ed 11 00 00       	call   402a <printf>
    2e3d:	83 c4 10             	add    $0x10,%esp
    exit();
    2e40:	e8 70 10 00 00       	call   3eb5 <exit>
  }

  fd = open(".", O_RDWR);
    2e45:	83 ec 08             	sub    $0x8,%esp
    2e48:	6a 02                	push   $0x2
    2e4a:	68 6b 4c 00 00       	push   $0x4c6b
    2e4f:	e8 a1 10 00 00       	call   3ef5 <open>
    2e54:	83 c4 10             	add    $0x10,%esp
    2e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e5e:	78 17                	js     2e77 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2e60:	83 ec 08             	sub    $0x8,%esp
    2e63:	68 c8 56 00 00       	push   $0x56c8
    2e68:	6a 01                	push   $0x1
    2e6a:	e8 bb 11 00 00       	call   402a <printf>
    2e6f:	83 c4 10             	add    $0x10,%esp
    exit();
    2e72:	e8 3e 10 00 00       	call   3eb5 <exit>
  }
  fd = open(".", 0);
    2e77:	83 ec 08             	sub    $0x8,%esp
    2e7a:	6a 00                	push   $0x0
    2e7c:	68 6b 4c 00 00       	push   $0x4c6b
    2e81:	e8 6f 10 00 00       	call   3ef5 <open>
    2e86:	83 c4 10             	add    $0x10,%esp
    2e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e8c:	83 ec 04             	sub    $0x4,%esp
    2e8f:	6a 01                	push   $0x1
    2e91:	68 b7 48 00 00       	push   $0x48b7
    2e96:	ff 75 f4             	pushl  -0xc(%ebp)
    2e99:	e8 37 10 00 00       	call   3ed5 <write>
    2e9e:	83 c4 10             	add    $0x10,%esp
    2ea1:	85 c0                	test   %eax,%eax
    2ea3:	7e 17                	jle    2ebc <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2ea5:	83 ec 08             	sub    $0x8,%esp
    2ea8:	68 e7 56 00 00       	push   $0x56e7
    2ead:	6a 01                	push   $0x1
    2eaf:	e8 76 11 00 00       	call   402a <printf>
    2eb4:	83 c4 10             	add    $0x10,%esp
    exit();
    2eb7:	e8 f9 0f 00 00       	call   3eb5 <exit>
  }
  close(fd);
    2ebc:	83 ec 0c             	sub    $0xc,%esp
    2ebf:	ff 75 f4             	pushl  -0xc(%ebp)
    2ec2:	e8 16 10 00 00       	call   3edd <close>
    2ec7:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2eca:	83 ec 08             	sub    $0x8,%esp
    2ecd:	68 fb 56 00 00       	push   $0x56fb
    2ed2:	6a 01                	push   $0x1
    2ed4:	e8 51 11 00 00       	call   402a <printf>
    2ed9:	83 c4 10             	add    $0x10,%esp
}
    2edc:	c9                   	leave  
    2edd:	c3                   	ret    

00002ede <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ede:	55                   	push   %ebp
    2edf:	89 e5                	mov    %esp,%ebp
    2ee1:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2ee4:	83 ec 08             	sub    $0x8,%esp
    2ee7:	68 0b 57 00 00       	push   $0x570b
    2eec:	6a 01                	push   $0x1
    2eee:	e8 37 11 00 00       	call   402a <printf>
    2ef3:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2efd:	e9 e7 00 00 00       	jmp    2fe9 <iref+0x10b>
    if(mkdir("irefd") != 0){
    2f02:	83 ec 0c             	sub    $0xc,%esp
    2f05:	68 1c 57 00 00       	push   $0x571c
    2f0a:	e8 0e 10 00 00       	call   3f1d <mkdir>
    2f0f:	83 c4 10             	add    $0x10,%esp
    2f12:	85 c0                	test   %eax,%eax
    2f14:	74 17                	je     2f2d <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f16:	83 ec 08             	sub    $0x8,%esp
    2f19:	68 22 57 00 00       	push   $0x5722
    2f1e:	6a 01                	push   $0x1
    2f20:	e8 05 11 00 00       	call   402a <printf>
    2f25:	83 c4 10             	add    $0x10,%esp
      exit();
    2f28:	e8 88 0f 00 00       	call   3eb5 <exit>
    }
    if(chdir("irefd") != 0){
    2f2d:	83 ec 0c             	sub    $0xc,%esp
    2f30:	68 1c 57 00 00       	push   $0x571c
    2f35:	e8 eb 0f 00 00       	call   3f25 <chdir>
    2f3a:	83 c4 10             	add    $0x10,%esp
    2f3d:	85 c0                	test   %eax,%eax
    2f3f:	74 17                	je     2f58 <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2f41:	83 ec 08             	sub    $0x8,%esp
    2f44:	68 36 57 00 00       	push   $0x5736
    2f49:	6a 01                	push   $0x1
    2f4b:	e8 da 10 00 00       	call   402a <printf>
    2f50:	83 c4 10             	add    $0x10,%esp
      exit();
    2f53:	e8 5d 0f 00 00       	call   3eb5 <exit>
    }

    mkdir("");
    2f58:	83 ec 0c             	sub    $0xc,%esp
    2f5b:	68 4a 57 00 00       	push   $0x574a
    2f60:	e8 b8 0f 00 00       	call   3f1d <mkdir>
    2f65:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2f68:	83 ec 08             	sub    $0x8,%esp
    2f6b:	68 4a 57 00 00       	push   $0x574a
    2f70:	68 89 56 00 00       	push   $0x5689
    2f75:	e8 9b 0f 00 00       	call   3f15 <link>
    2f7a:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2f7d:	83 ec 08             	sub    $0x8,%esp
    2f80:	68 00 02 00 00       	push   $0x200
    2f85:	68 4a 57 00 00       	push   $0x574a
    2f8a:	e8 66 0f 00 00       	call   3ef5 <open>
    2f8f:	83 c4 10             	add    $0x10,%esp
    2f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f99:	78 0e                	js     2fa9 <iref+0xcb>
      close(fd);
    2f9b:	83 ec 0c             	sub    $0xc,%esp
    2f9e:	ff 75 f0             	pushl  -0x10(%ebp)
    2fa1:	e8 37 0f 00 00       	call   3edd <close>
    2fa6:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2fa9:	83 ec 08             	sub    $0x8,%esp
    2fac:	68 00 02 00 00       	push   $0x200
    2fb1:	68 4b 57 00 00       	push   $0x574b
    2fb6:	e8 3a 0f 00 00       	call   3ef5 <open>
    2fbb:	83 c4 10             	add    $0x10,%esp
    2fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fc5:	78 0e                	js     2fd5 <iref+0xf7>
      close(fd);
    2fc7:	83 ec 0c             	sub    $0xc,%esp
    2fca:	ff 75 f0             	pushl  -0x10(%ebp)
    2fcd:	e8 0b 0f 00 00       	call   3edd <close>
    2fd2:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2fd5:	83 ec 0c             	sub    $0xc,%esp
    2fd8:	68 4b 57 00 00       	push   $0x574b
    2fdd:	e8 23 0f 00 00       	call   3f05 <unlink>
    2fe2:	83 c4 10             	add    $0x10,%esp
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fe5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2fe9:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2fed:	0f 8e 0f ff ff ff    	jle    2f02 <iref+0x24>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2ff3:	83 ec 0c             	sub    $0xc,%esp
    2ff6:	68 52 44 00 00       	push   $0x4452
    2ffb:	e8 25 0f 00 00       	call   3f25 <chdir>
    3000:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3003:	83 ec 08             	sub    $0x8,%esp
    3006:	68 4e 57 00 00       	push   $0x574e
    300b:	6a 01                	push   $0x1
    300d:	e8 18 10 00 00       	call   402a <printf>
    3012:	83 c4 10             	add    $0x10,%esp
}
    3015:	c9                   	leave  
    3016:	c3                   	ret    

00003017 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3017:	55                   	push   %ebp
    3018:	89 e5                	mov    %esp,%ebp
    301a:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    301d:	83 ec 08             	sub    $0x8,%esp
    3020:	68 62 57 00 00       	push   $0x5762
    3025:	6a 01                	push   $0x1
    3027:	e8 fe 0f 00 00       	call   402a <printf>
    302c:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    302f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3036:	eb 1f                	jmp    3057 <forktest+0x40>
    pid = fork();
    3038:	e8 70 0e 00 00       	call   3ead <fork>
    303d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3040:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3044:	79 02                	jns    3048 <forktest+0x31>
      break;
    3046:	eb 18                	jmp    3060 <forktest+0x49>
    if(pid == 0)
    3048:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    304c:	75 05                	jne    3053 <forktest+0x3c>
      exit();
    304e:	e8 62 0e 00 00       	call   3eb5 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3053:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3057:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    305e:	7e d8                	jle    3038 <forktest+0x21>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3060:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    3067:	75 17                	jne    3080 <forktest+0x69>
    printf(1, "fork claimed to work 1000 times!\n");
    3069:	83 ec 08             	sub    $0x8,%esp
    306c:	68 70 57 00 00       	push   $0x5770
    3071:	6a 01                	push   $0x1
    3073:	e8 b2 0f 00 00       	call   402a <printf>
    3078:	83 c4 10             	add    $0x10,%esp
    exit();
    307b:	e8 35 0e 00 00       	call   3eb5 <exit>
  }
  
  for(; n > 0; n--){
    3080:	eb 24                	jmp    30a6 <forktest+0x8f>
    if(wait() < 0){
    3082:	e8 36 0e 00 00       	call   3ebd <wait>
    3087:	85 c0                	test   %eax,%eax
    3089:	79 17                	jns    30a2 <forktest+0x8b>
      printf(1, "wait stopped early\n");
    308b:	83 ec 08             	sub    $0x8,%esp
    308e:	68 92 57 00 00       	push   $0x5792
    3093:	6a 01                	push   $0x1
    3095:	e8 90 0f 00 00       	call   402a <printf>
    309a:	83 c4 10             	add    $0x10,%esp
      exit();
    309d:	e8 13 0e 00 00       	call   3eb5 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    30a2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30aa:	7f d6                	jg     3082 <forktest+0x6b>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30ac:	e8 0c 0e 00 00       	call   3ebd <wait>
    30b1:	83 f8 ff             	cmp    $0xffffffff,%eax
    30b4:	74 17                	je     30cd <forktest+0xb6>
    printf(1, "wait got too many\n");
    30b6:	83 ec 08             	sub    $0x8,%esp
    30b9:	68 a6 57 00 00       	push   $0x57a6
    30be:	6a 01                	push   $0x1
    30c0:	e8 65 0f 00 00       	call   402a <printf>
    30c5:	83 c4 10             	add    $0x10,%esp
    exit();
    30c8:	e8 e8 0d 00 00       	call   3eb5 <exit>
  }
  
  printf(1, "fork test OK\n");
    30cd:	83 ec 08             	sub    $0x8,%esp
    30d0:	68 b9 57 00 00       	push   $0x57b9
    30d5:	6a 01                	push   $0x1
    30d7:	e8 4e 0f 00 00       	call   402a <printf>
    30dc:	83 c4 10             	add    $0x10,%esp
}
    30df:	c9                   	leave  
    30e0:	c3                   	ret    

000030e1 <sbrktest>:

void
sbrktest(void)
{
    30e1:	55                   	push   %ebp
    30e2:	89 e5                	mov    %esp,%ebp
    30e4:	53                   	push   %ebx
    30e5:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30e8:	a1 9c 62 00 00       	mov    0x629c,%eax
    30ed:	83 ec 08             	sub    $0x8,%esp
    30f0:	68 c7 57 00 00       	push   $0x57c7
    30f5:	50                   	push   %eax
    30f6:	e8 2f 0f 00 00       	call   402a <printf>
    30fb:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    30fe:	83 ec 0c             	sub    $0xc,%esp
    3101:	6a 00                	push   $0x0
    3103:	e8 35 0e 00 00       	call   3f3d <sbrk>
    3108:	83 c4 10             	add    $0x10,%esp
    310b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    310e:	83 ec 0c             	sub    $0xc,%esp
    3111:	6a 00                	push   $0x0
    3113:	e8 25 0e 00 00       	call   3f3d <sbrk>
    3118:	83 c4 10             	add    $0x10,%esp
    311b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    311e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3125:	eb 4f                	jmp    3176 <sbrktest+0x95>
    b = sbrk(1);
    3127:	83 ec 0c             	sub    $0xc,%esp
    312a:	6a 01                	push   $0x1
    312c:	e8 0c 0e 00 00       	call   3f3d <sbrk>
    3131:	83 c4 10             	add    $0x10,%esp
    3134:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3137:	8b 45 e8             	mov    -0x18(%ebp),%eax
    313a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    313d:	74 24                	je     3163 <sbrktest+0x82>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    313f:	a1 9c 62 00 00       	mov    0x629c,%eax
    3144:	83 ec 0c             	sub    $0xc,%esp
    3147:	ff 75 e8             	pushl  -0x18(%ebp)
    314a:	ff 75 f4             	pushl  -0xc(%ebp)
    314d:	ff 75 f0             	pushl  -0x10(%ebp)
    3150:	68 d2 57 00 00       	push   $0x57d2
    3155:	50                   	push   %eax
    3156:	e8 cf 0e 00 00       	call   402a <printf>
    315b:	83 c4 20             	add    $0x20,%esp
      exit();
    315e:	e8 52 0d 00 00       	call   3eb5 <exit>
    }
    *b = 1;
    3163:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3166:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3169:	8b 45 e8             	mov    -0x18(%ebp),%eax
    316c:	83 c0 01             	add    $0x1,%eax
    316f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3172:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3176:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    317d:	7e a8                	jle    3127 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    317f:	e8 29 0d 00 00       	call   3ead <fork>
    3184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    3187:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    318b:	79 1b                	jns    31a8 <sbrktest+0xc7>
    printf(stdout, "sbrk test fork failed\n");
    318d:	a1 9c 62 00 00       	mov    0x629c,%eax
    3192:	83 ec 08             	sub    $0x8,%esp
    3195:	68 ed 57 00 00       	push   $0x57ed
    319a:	50                   	push   %eax
    319b:	e8 8a 0e 00 00       	call   402a <printf>
    31a0:	83 c4 10             	add    $0x10,%esp
    exit();
    31a3:	e8 0d 0d 00 00       	call   3eb5 <exit>
  }
  c = sbrk(1);
    31a8:	83 ec 0c             	sub    $0xc,%esp
    31ab:	6a 01                	push   $0x1
    31ad:	e8 8b 0d 00 00       	call   3f3d <sbrk>
    31b2:	83 c4 10             	add    $0x10,%esp
    31b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31b8:	83 ec 0c             	sub    $0xc,%esp
    31bb:	6a 01                	push   $0x1
    31bd:	e8 7b 0d 00 00       	call   3f3d <sbrk>
    31c2:	83 c4 10             	add    $0x10,%esp
    31c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31cb:	83 c0 01             	add    $0x1,%eax
    31ce:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    31d1:	74 1b                	je     31ee <sbrktest+0x10d>
    printf(stdout, "sbrk test failed post-fork\n");
    31d3:	a1 9c 62 00 00       	mov    0x629c,%eax
    31d8:	83 ec 08             	sub    $0x8,%esp
    31db:	68 04 58 00 00       	push   $0x5804
    31e0:	50                   	push   %eax
    31e1:	e8 44 0e 00 00       	call   402a <printf>
    31e6:	83 c4 10             	add    $0x10,%esp
    exit();
    31e9:	e8 c7 0c 00 00       	call   3eb5 <exit>
  }
  if(pid == 0)
    31ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31f2:	75 05                	jne    31f9 <sbrktest+0x118>
    exit();
    31f4:	e8 bc 0c 00 00       	call   3eb5 <exit>
  wait();
    31f9:	e8 bf 0c 00 00       	call   3ebd <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    31fe:	83 ec 0c             	sub    $0xc,%esp
    3201:	6a 00                	push   $0x0
    3203:	e8 35 0d 00 00       	call   3f3d <sbrk>
    3208:	83 c4 10             	add    $0x10,%esp
    320b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3211:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3216:	29 c2                	sub    %eax,%edx
    3218:	89 d0                	mov    %edx,%eax
    321a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    321d:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3220:	83 ec 0c             	sub    $0xc,%esp
    3223:	50                   	push   %eax
    3224:	e8 14 0d 00 00       	call   3f3d <sbrk>
    3229:	83 c4 10             	add    $0x10,%esp
    322c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    322f:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3232:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3235:	74 1b                	je     3252 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3237:	a1 9c 62 00 00       	mov    0x629c,%eax
    323c:	83 ec 08             	sub    $0x8,%esp
    323f:	68 20 58 00 00       	push   $0x5820
    3244:	50                   	push   %eax
    3245:	e8 e0 0d 00 00       	call   402a <printf>
    324a:	83 c4 10             	add    $0x10,%esp
    exit();
    324d:	e8 63 0c 00 00       	call   3eb5 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3252:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    3259:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    325c:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    325f:	83 ec 0c             	sub    $0xc,%esp
    3262:	6a 00                	push   $0x0
    3264:	e8 d4 0c 00 00       	call   3f3d <sbrk>
    3269:	83 c4 10             	add    $0x10,%esp
    326c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    326f:	83 ec 0c             	sub    $0xc,%esp
    3272:	68 00 f0 ff ff       	push   $0xfffff000
    3277:	e8 c1 0c 00 00       	call   3f3d <sbrk>
    327c:	83 c4 10             	add    $0x10,%esp
    327f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3282:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3286:	75 1b                	jne    32a3 <sbrktest+0x1c2>
    printf(stdout, "sbrk could not deallocate\n");
    3288:	a1 9c 62 00 00       	mov    0x629c,%eax
    328d:	83 ec 08             	sub    $0x8,%esp
    3290:	68 5e 58 00 00       	push   $0x585e
    3295:	50                   	push   %eax
    3296:	e8 8f 0d 00 00       	call   402a <printf>
    329b:	83 c4 10             	add    $0x10,%esp
    exit();
    329e:	e8 12 0c 00 00       	call   3eb5 <exit>
  }
  c = sbrk(0);
    32a3:	83 ec 0c             	sub    $0xc,%esp
    32a6:	6a 00                	push   $0x0
    32a8:	e8 90 0c 00 00       	call   3f3d <sbrk>
    32ad:	83 c4 10             	add    $0x10,%esp
    32b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32b6:	2d 00 10 00 00       	sub    $0x1000,%eax
    32bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32be:	74 1e                	je     32de <sbrktest+0x1fd>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32c0:	a1 9c 62 00 00       	mov    0x629c,%eax
    32c5:	ff 75 e0             	pushl  -0x20(%ebp)
    32c8:	ff 75 f4             	pushl  -0xc(%ebp)
    32cb:	68 7c 58 00 00       	push   $0x587c
    32d0:	50                   	push   %eax
    32d1:	e8 54 0d 00 00       	call   402a <printf>
    32d6:	83 c4 10             	add    $0x10,%esp
    exit();
    32d9:	e8 d7 0b 00 00       	call   3eb5 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32de:	83 ec 0c             	sub    $0xc,%esp
    32e1:	6a 00                	push   $0x0
    32e3:	e8 55 0c 00 00       	call   3f3d <sbrk>
    32e8:	83 c4 10             	add    $0x10,%esp
    32eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    32ee:	83 ec 0c             	sub    $0xc,%esp
    32f1:	68 00 10 00 00       	push   $0x1000
    32f6:	e8 42 0c 00 00       	call   3f3d <sbrk>
    32fb:	83 c4 10             	add    $0x10,%esp
    32fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3301:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3304:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3307:	75 1b                	jne    3324 <sbrktest+0x243>
    3309:	83 ec 0c             	sub    $0xc,%esp
    330c:	6a 00                	push   $0x0
    330e:	e8 2a 0c 00 00       	call   3f3d <sbrk>
    3313:	83 c4 10             	add    $0x10,%esp
    3316:	89 c2                	mov    %eax,%edx
    3318:	8b 45 f4             	mov    -0xc(%ebp),%eax
    331b:	05 00 10 00 00       	add    $0x1000,%eax
    3320:	39 c2                	cmp    %eax,%edx
    3322:	74 1e                	je     3342 <sbrktest+0x261>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3324:	a1 9c 62 00 00       	mov    0x629c,%eax
    3329:	ff 75 e0             	pushl  -0x20(%ebp)
    332c:	ff 75 f4             	pushl  -0xc(%ebp)
    332f:	68 b4 58 00 00       	push   $0x58b4
    3334:	50                   	push   %eax
    3335:	e8 f0 0c 00 00       	call   402a <printf>
    333a:	83 c4 10             	add    $0x10,%esp
    exit();
    333d:	e8 73 0b 00 00       	call   3eb5 <exit>
  }
  if(*lastaddr == 99){
    3342:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3345:	0f b6 00             	movzbl (%eax),%eax
    3348:	3c 63                	cmp    $0x63,%al
    334a:	75 1b                	jne    3367 <sbrktest+0x286>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    334c:	a1 9c 62 00 00       	mov    0x629c,%eax
    3351:	83 ec 08             	sub    $0x8,%esp
    3354:	68 dc 58 00 00       	push   $0x58dc
    3359:	50                   	push   %eax
    335a:	e8 cb 0c 00 00       	call   402a <printf>
    335f:	83 c4 10             	add    $0x10,%esp
    exit();
    3362:	e8 4e 0b 00 00       	call   3eb5 <exit>
  }

  a = sbrk(0);
    3367:	83 ec 0c             	sub    $0xc,%esp
    336a:	6a 00                	push   $0x0
    336c:	e8 cc 0b 00 00       	call   3f3d <sbrk>
    3371:	83 c4 10             	add    $0x10,%esp
    3374:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3377:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    337a:	83 ec 0c             	sub    $0xc,%esp
    337d:	6a 00                	push   $0x0
    337f:	e8 b9 0b 00 00       	call   3f3d <sbrk>
    3384:	83 c4 10             	add    $0x10,%esp
    3387:	29 c3                	sub    %eax,%ebx
    3389:	89 d8                	mov    %ebx,%eax
    338b:	83 ec 0c             	sub    $0xc,%esp
    338e:	50                   	push   %eax
    338f:	e8 a9 0b 00 00       	call   3f3d <sbrk>
    3394:	83 c4 10             	add    $0x10,%esp
    3397:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    339a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    339d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33a0:	74 1e                	je     33c0 <sbrktest+0x2df>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33a2:	a1 9c 62 00 00       	mov    0x629c,%eax
    33a7:	ff 75 e0             	pushl  -0x20(%ebp)
    33aa:	ff 75 f4             	pushl  -0xc(%ebp)
    33ad:	68 0c 59 00 00       	push   $0x590c
    33b2:	50                   	push   %eax
    33b3:	e8 72 0c 00 00       	call   402a <printf>
    33b8:	83 c4 10             	add    $0x10,%esp
    exit();
    33bb:	e8 f5 0a 00 00       	call   3eb5 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33c0:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33c7:	eb 76                	jmp    343f <sbrktest+0x35e>
    ppid = getpid();
    33c9:	e8 67 0b 00 00       	call   3f35 <getpid>
    33ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    33d1:	e8 d7 0a 00 00       	call   3ead <fork>
    33d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    33d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33dd:	79 1b                	jns    33fa <sbrktest+0x319>
      printf(stdout, "fork failed\n");
    33df:	a1 9c 62 00 00       	mov    0x629c,%eax
    33e4:	83 ec 08             	sub    $0x8,%esp
    33e7:	68 81 44 00 00       	push   $0x4481
    33ec:	50                   	push   %eax
    33ed:	e8 38 0c 00 00       	call   402a <printf>
    33f2:	83 c4 10             	add    $0x10,%esp
      exit();
    33f5:	e8 bb 0a 00 00       	call   3eb5 <exit>
    }
    if(pid == 0){
    33fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33fe:	75 33                	jne    3433 <sbrktest+0x352>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3400:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3403:	0f b6 00             	movzbl (%eax),%eax
    3406:	0f be d0             	movsbl %al,%edx
    3409:	a1 9c 62 00 00       	mov    0x629c,%eax
    340e:	52                   	push   %edx
    340f:	ff 75 f4             	pushl  -0xc(%ebp)
    3412:	68 2d 59 00 00       	push   $0x592d
    3417:	50                   	push   %eax
    3418:	e8 0d 0c 00 00       	call   402a <printf>
    341d:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    3420:	83 ec 0c             	sub    $0xc,%esp
    3423:	ff 75 d0             	pushl  -0x30(%ebp)
    3426:	e8 ba 0a 00 00       	call   3ee5 <kill>
    342b:	83 c4 10             	add    $0x10,%esp
      exit();
    342e:	e8 82 0a 00 00       	call   3eb5 <exit>
    }
    wait();
    3433:	e8 85 0a 00 00       	call   3ebd <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3438:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    343f:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3446:	76 81                	jbe    33c9 <sbrktest+0x2e8>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3448:	83 ec 0c             	sub    $0xc,%esp
    344b:	8d 45 c8             	lea    -0x38(%ebp),%eax
    344e:	50                   	push   %eax
    344f:	e8 71 0a 00 00       	call   3ec5 <pipe>
    3454:	83 c4 10             	add    $0x10,%esp
    3457:	85 c0                	test   %eax,%eax
    3459:	74 17                	je     3472 <sbrktest+0x391>
    printf(1, "pipe() failed\n");
    345b:	83 ec 08             	sub    $0x8,%esp
    345e:	68 52 48 00 00       	push   $0x4852
    3463:	6a 01                	push   $0x1
    3465:	e8 c0 0b 00 00       	call   402a <printf>
    346a:	83 c4 10             	add    $0x10,%esp
    exit();
    346d:	e8 43 0a 00 00       	call   3eb5 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3479:	e9 88 00 00 00       	jmp    3506 <sbrktest+0x425>
    if((pids[i] = fork()) == 0){
    347e:	e8 2a 0a 00 00       	call   3ead <fork>
    3483:	89 c2                	mov    %eax,%edx
    3485:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3488:	89 54 85 a0          	mov    %edx,-0x60(%ebp,%eax,4)
    348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    348f:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3493:	85 c0                	test   %eax,%eax
    3495:	75 4a                	jne    34e1 <sbrktest+0x400>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3497:	83 ec 0c             	sub    $0xc,%esp
    349a:	6a 00                	push   $0x0
    349c:	e8 9c 0a 00 00       	call   3f3d <sbrk>
    34a1:	83 c4 10             	add    $0x10,%esp
    34a4:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34a9:	29 c2                	sub    %eax,%edx
    34ab:	89 d0                	mov    %edx,%eax
    34ad:	83 ec 0c             	sub    $0xc,%esp
    34b0:	50                   	push   %eax
    34b1:	e8 87 0a 00 00       	call   3f3d <sbrk>
    34b6:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    34b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34bc:	83 ec 04             	sub    $0x4,%esp
    34bf:	6a 01                	push   $0x1
    34c1:	68 b7 48 00 00       	push   $0x48b7
    34c6:	50                   	push   %eax
    34c7:	e8 09 0a 00 00       	call   3ed5 <write>
    34cc:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    34cf:	83 ec 0c             	sub    $0xc,%esp
    34d2:	68 e8 03 00 00       	push   $0x3e8
    34d7:	e8 69 0a 00 00       	call   3f45 <sleep>
    34dc:	83 c4 10             	add    $0x10,%esp
    34df:	eb ee                	jmp    34cf <sbrktest+0x3ee>
    }
    if(pids[i] != -1)
    34e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34e4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34e8:	83 f8 ff             	cmp    $0xffffffff,%eax
    34eb:	74 15                	je     3502 <sbrktest+0x421>
      read(fds[0], &scratch, 1);
    34ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
    34f0:	83 ec 04             	sub    $0x4,%esp
    34f3:	6a 01                	push   $0x1
    34f5:	8d 55 9f             	lea    -0x61(%ebp),%edx
    34f8:	52                   	push   %edx
    34f9:	50                   	push   %eax
    34fa:	e8 ce 09 00 00       	call   3ecd <read>
    34ff:	83 c4 10             	add    $0x10,%esp
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3502:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3506:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3509:	83 f8 09             	cmp    $0x9,%eax
    350c:	0f 86 6c ff ff ff    	jbe    347e <sbrktest+0x39d>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3512:	83 ec 0c             	sub    $0xc,%esp
    3515:	68 00 10 00 00       	push   $0x1000
    351a:	e8 1e 0a 00 00       	call   3f3d <sbrk>
    351f:	83 c4 10             	add    $0x10,%esp
    3522:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3525:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    352c:	eb 2a                	jmp    3558 <sbrktest+0x477>
    if(pids[i] == -1)
    352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3531:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3535:	83 f8 ff             	cmp    $0xffffffff,%eax
    3538:	75 02                	jne    353c <sbrktest+0x45b>
      continue;
    353a:	eb 18                	jmp    3554 <sbrktest+0x473>
    kill(pids[i]);
    353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    353f:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3543:	83 ec 0c             	sub    $0xc,%esp
    3546:	50                   	push   %eax
    3547:	e8 99 09 00 00       	call   3ee5 <kill>
    354c:	83 c4 10             	add    $0x10,%esp
    wait();
    354f:	e8 69 09 00 00       	call   3ebd <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3554:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3558:	8b 45 f0             	mov    -0x10(%ebp),%eax
    355b:	83 f8 09             	cmp    $0x9,%eax
    355e:	76 ce                	jbe    352e <sbrktest+0x44d>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    3560:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3564:	75 1b                	jne    3581 <sbrktest+0x4a0>
    printf(stdout, "failed sbrk leaked memory\n");
    3566:	a1 9c 62 00 00       	mov    0x629c,%eax
    356b:	83 ec 08             	sub    $0x8,%esp
    356e:	68 46 59 00 00       	push   $0x5946
    3573:	50                   	push   %eax
    3574:	e8 b1 0a 00 00       	call   402a <printf>
    3579:	83 c4 10             	add    $0x10,%esp
    exit();
    357c:	e8 34 09 00 00       	call   3eb5 <exit>
  }

  if(sbrk(0) > oldbrk)
    3581:	83 ec 0c             	sub    $0xc,%esp
    3584:	6a 00                	push   $0x0
    3586:	e8 b2 09 00 00       	call   3f3d <sbrk>
    358b:	83 c4 10             	add    $0x10,%esp
    358e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    3591:	76 20                	jbe    35b3 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    3593:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3596:	83 ec 0c             	sub    $0xc,%esp
    3599:	6a 00                	push   $0x0
    359b:	e8 9d 09 00 00       	call   3f3d <sbrk>
    35a0:	83 c4 10             	add    $0x10,%esp
    35a3:	29 c3                	sub    %eax,%ebx
    35a5:	89 d8                	mov    %ebx,%eax
    35a7:	83 ec 0c             	sub    $0xc,%esp
    35aa:	50                   	push   %eax
    35ab:	e8 8d 09 00 00       	call   3f3d <sbrk>
    35b0:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    35b3:	a1 9c 62 00 00       	mov    0x629c,%eax
    35b8:	83 ec 08             	sub    $0x8,%esp
    35bb:	68 61 59 00 00       	push   $0x5961
    35c0:	50                   	push   %eax
    35c1:	e8 64 0a 00 00       	call   402a <printf>
    35c6:	83 c4 10             	add    $0x10,%esp
}
    35c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    35cc:	c9                   	leave  
    35cd:	c3                   	ret    

000035ce <validateint>:

void
validateint(int *p)
{
    35ce:	55                   	push   %ebp
    35cf:	89 e5                	mov    %esp,%ebp
    35d1:	53                   	push   %ebx
    35d2:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35d5:	b8 0d 00 00 00       	mov    $0xd,%eax
    35da:	8b 55 08             	mov    0x8(%ebp),%edx
    35dd:	89 d1                	mov    %edx,%ecx
    35df:	89 e3                	mov    %esp,%ebx
    35e1:	89 cc                	mov    %ecx,%esp
    35e3:	cd 40                	int    $0x40
    35e5:	89 dc                	mov    %ebx,%esp
    35e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    35ea:	83 c4 10             	add    $0x10,%esp
    35ed:	5b                   	pop    %ebx
    35ee:	5d                   	pop    %ebp
    35ef:	c3                   	ret    

000035f0 <validatetest>:

void
validatetest(void)
{
    35f0:	55                   	push   %ebp
    35f1:	89 e5                	mov    %esp,%ebp
    35f3:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    35f6:	a1 9c 62 00 00       	mov    0x629c,%eax
    35fb:	83 ec 08             	sub    $0x8,%esp
    35fe:	68 6f 59 00 00       	push   $0x596f
    3603:	50                   	push   %eax
    3604:	e8 21 0a 00 00       	call   402a <printf>
    3609:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    360c:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    361a:	e9 8a 00 00 00       	jmp    36a9 <validatetest+0xb9>
    if((pid = fork()) == 0){
    361f:	e8 89 08 00 00       	call   3ead <fork>
    3624:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3627:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    362b:	75 14                	jne    3641 <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3630:	83 ec 0c             	sub    $0xc,%esp
    3633:	50                   	push   %eax
    3634:	e8 95 ff ff ff       	call   35ce <validateint>
    3639:	83 c4 10             	add    $0x10,%esp
      exit();
    363c:	e8 74 08 00 00       	call   3eb5 <exit>
    }
    sleep(0);
    3641:	83 ec 0c             	sub    $0xc,%esp
    3644:	6a 00                	push   $0x0
    3646:	e8 fa 08 00 00       	call   3f45 <sleep>
    364b:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    364e:	83 ec 0c             	sub    $0xc,%esp
    3651:	6a 00                	push   $0x0
    3653:	e8 ed 08 00 00       	call   3f45 <sleep>
    3658:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    365b:	83 ec 0c             	sub    $0xc,%esp
    365e:	ff 75 ec             	pushl  -0x14(%ebp)
    3661:	e8 7f 08 00 00       	call   3ee5 <kill>
    3666:	83 c4 10             	add    $0x10,%esp
    wait();
    3669:	e8 4f 08 00 00       	call   3ebd <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3671:	83 ec 08             	sub    $0x8,%esp
    3674:	50                   	push   %eax
    3675:	68 7e 59 00 00       	push   $0x597e
    367a:	e8 96 08 00 00       	call   3f15 <link>
    367f:	83 c4 10             	add    $0x10,%esp
    3682:	83 f8 ff             	cmp    $0xffffffff,%eax
    3685:	74 1b                	je     36a2 <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    3687:	a1 9c 62 00 00       	mov    0x629c,%eax
    368c:	83 ec 08             	sub    $0x8,%esp
    368f:	68 89 59 00 00       	push   $0x5989
    3694:	50                   	push   %eax
    3695:	e8 90 09 00 00       	call   402a <printf>
    369a:	83 c4 10             	add    $0x10,%esp
      exit();
    369d:	e8 13 08 00 00       	call   3eb5 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    36a2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36af:	0f 83 6a ff ff ff    	jae    361f <validatetest+0x2f>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36b5:	a1 9c 62 00 00       	mov    0x629c,%eax
    36ba:	83 ec 08             	sub    $0x8,%esp
    36bd:	68 a2 59 00 00       	push   $0x59a2
    36c2:	50                   	push   %eax
    36c3:	e8 62 09 00 00       	call   402a <printf>
    36c8:	83 c4 10             	add    $0x10,%esp
}
    36cb:	c9                   	leave  
    36cc:	c3                   	ret    

000036cd <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36cd:	55                   	push   %ebp
    36ce:	89 e5                	mov    %esp,%ebp
    36d0:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    36d3:	a1 9c 62 00 00       	mov    0x629c,%eax
    36d8:	83 ec 08             	sub    $0x8,%esp
    36db:	68 af 59 00 00       	push   $0x59af
    36e0:	50                   	push   %eax
    36e1:	e8 44 09 00 00       	call   402a <printf>
    36e6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    36e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    36f0:	eb 2e                	jmp    3720 <bsstest+0x53>
    if(uninit[i] != '\0'){
    36f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36f5:	05 80 63 00 00       	add    $0x6380,%eax
    36fa:	0f b6 00             	movzbl (%eax),%eax
    36fd:	84 c0                	test   %al,%al
    36ff:	74 1b                	je     371c <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    3701:	a1 9c 62 00 00       	mov    0x629c,%eax
    3706:	83 ec 08             	sub    $0x8,%esp
    3709:	68 b9 59 00 00       	push   $0x59b9
    370e:	50                   	push   %eax
    370f:	e8 16 09 00 00       	call   402a <printf>
    3714:	83 c4 10             	add    $0x10,%esp
      exit();
    3717:	e8 99 07 00 00       	call   3eb5 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    371c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3720:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3723:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3728:	76 c8                	jbe    36f2 <bsstest+0x25>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    372a:	a1 9c 62 00 00       	mov    0x629c,%eax
    372f:	83 ec 08             	sub    $0x8,%esp
    3732:	68 ca 59 00 00       	push   $0x59ca
    3737:	50                   	push   %eax
    3738:	e8 ed 08 00 00       	call   402a <printf>
    373d:	83 c4 10             	add    $0x10,%esp
}
    3740:	c9                   	leave  
    3741:	c3                   	ret    

00003742 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3742:	55                   	push   %ebp
    3743:	89 e5                	mov    %esp,%ebp
    3745:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3748:	83 ec 0c             	sub    $0xc,%esp
    374b:	68 d7 59 00 00       	push   $0x59d7
    3750:	e8 b0 07 00 00       	call   3f05 <unlink>
    3755:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3758:	e8 50 07 00 00       	call   3ead <fork>
    375d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3760:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3764:	0f 85 97 00 00 00    	jne    3801 <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    376a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3771:	eb 12                	jmp    3785 <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3773:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3776:	c7 04 85 c0 62 00 00 	movl   $0x59e4,0x62c0(,%eax,4)
    377d:	e4 59 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3781:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3785:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3789:	7e e8                	jle    3773 <bigargtest+0x31>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    378b:	c7 05 3c 63 00 00 00 	movl   $0x0,0x633c
    3792:	00 00 00 
    printf(stdout, "bigarg test\n");
    3795:	a1 9c 62 00 00       	mov    0x629c,%eax
    379a:	83 ec 08             	sub    $0x8,%esp
    379d:	68 c1 5a 00 00       	push   $0x5ac1
    37a2:	50                   	push   %eax
    37a3:	e8 82 08 00 00       	call   402a <printf>
    37a8:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    37ab:	83 ec 08             	sub    $0x8,%esp
    37ae:	68 c0 62 00 00       	push   $0x62c0
    37b3:	68 e0 43 00 00       	push   $0x43e0
    37b8:	e8 30 07 00 00       	call   3eed <exec>
    37bd:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    37c0:	a1 9c 62 00 00       	mov    0x629c,%eax
    37c5:	83 ec 08             	sub    $0x8,%esp
    37c8:	68 ce 5a 00 00       	push   $0x5ace
    37cd:	50                   	push   %eax
    37ce:	e8 57 08 00 00       	call   402a <printf>
    37d3:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    37d6:	83 ec 08             	sub    $0x8,%esp
    37d9:	68 00 02 00 00       	push   $0x200
    37de:	68 d7 59 00 00       	push   $0x59d7
    37e3:	e8 0d 07 00 00       	call   3ef5 <open>
    37e8:	83 c4 10             	add    $0x10,%esp
    37eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    37ee:	83 ec 0c             	sub    $0xc,%esp
    37f1:	ff 75 ec             	pushl  -0x14(%ebp)
    37f4:	e8 e4 06 00 00       	call   3edd <close>
    37f9:	83 c4 10             	add    $0x10,%esp
    exit();
    37fc:	e8 b4 06 00 00       	call   3eb5 <exit>
  } else if(pid < 0){
    3801:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3805:	79 1b                	jns    3822 <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    3807:	a1 9c 62 00 00       	mov    0x629c,%eax
    380c:	83 ec 08             	sub    $0x8,%esp
    380f:	68 de 5a 00 00       	push   $0x5ade
    3814:	50                   	push   %eax
    3815:	e8 10 08 00 00       	call   402a <printf>
    381a:	83 c4 10             	add    $0x10,%esp
    exit();
    381d:	e8 93 06 00 00       	call   3eb5 <exit>
  }
  wait();
    3822:	e8 96 06 00 00       	call   3ebd <wait>
  fd = open("bigarg-ok", 0);
    3827:	83 ec 08             	sub    $0x8,%esp
    382a:	6a 00                	push   $0x0
    382c:	68 d7 59 00 00       	push   $0x59d7
    3831:	e8 bf 06 00 00       	call   3ef5 <open>
    3836:	83 c4 10             	add    $0x10,%esp
    3839:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    383c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3840:	79 1b                	jns    385d <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    3842:	a1 9c 62 00 00       	mov    0x629c,%eax
    3847:	83 ec 08             	sub    $0x8,%esp
    384a:	68 f7 5a 00 00       	push   $0x5af7
    384f:	50                   	push   %eax
    3850:	e8 d5 07 00 00       	call   402a <printf>
    3855:	83 c4 10             	add    $0x10,%esp
    exit();
    3858:	e8 58 06 00 00       	call   3eb5 <exit>
  }
  close(fd);
    385d:	83 ec 0c             	sub    $0xc,%esp
    3860:	ff 75 ec             	pushl  -0x14(%ebp)
    3863:	e8 75 06 00 00       	call   3edd <close>
    3868:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    386b:	83 ec 0c             	sub    $0xc,%esp
    386e:	68 d7 59 00 00       	push   $0x59d7
    3873:	e8 8d 06 00 00       	call   3f05 <unlink>
    3878:	83 c4 10             	add    $0x10,%esp
}
    387b:	c9                   	leave  
    387c:	c3                   	ret    

0000387d <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    387d:	55                   	push   %ebp
    387e:	89 e5                	mov    %esp,%ebp
    3880:	53                   	push   %ebx
    3881:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    3884:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    388b:	83 ec 08             	sub    $0x8,%esp
    388e:	68 0c 5b 00 00       	push   $0x5b0c
    3893:	6a 01                	push   $0x1
    3895:	e8 90 07 00 00       	call   402a <printf>
    389a:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    389d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38a4:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38ab:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38b0:	89 c8                	mov    %ecx,%eax
    38b2:	f7 ea                	imul   %edx
    38b4:	c1 fa 06             	sar    $0x6,%edx
    38b7:	89 c8                	mov    %ecx,%eax
    38b9:	c1 f8 1f             	sar    $0x1f,%eax
    38bc:	29 c2                	sub    %eax,%edx
    38be:	89 d0                	mov    %edx,%eax
    38c0:	83 c0 30             	add    $0x30,%eax
    38c3:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38c9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38ce:	89 d8                	mov    %ebx,%eax
    38d0:	f7 ea                	imul   %edx
    38d2:	c1 fa 06             	sar    $0x6,%edx
    38d5:	89 d8                	mov    %ebx,%eax
    38d7:	c1 f8 1f             	sar    $0x1f,%eax
    38da:	89 d1                	mov    %edx,%ecx
    38dc:	29 c1                	sub    %eax,%ecx
    38de:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38e4:	29 c3                	sub    %eax,%ebx
    38e6:	89 d9                	mov    %ebx,%ecx
    38e8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38ed:	89 c8                	mov    %ecx,%eax
    38ef:	f7 ea                	imul   %edx
    38f1:	c1 fa 05             	sar    $0x5,%edx
    38f4:	89 c8                	mov    %ecx,%eax
    38f6:	c1 f8 1f             	sar    $0x1f,%eax
    38f9:	29 c2                	sub    %eax,%edx
    38fb:	89 d0                	mov    %edx,%eax
    38fd:	83 c0 30             	add    $0x30,%eax
    3900:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3903:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3906:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    390b:	89 d8                	mov    %ebx,%eax
    390d:	f7 ea                	imul   %edx
    390f:	c1 fa 05             	sar    $0x5,%edx
    3912:	89 d8                	mov    %ebx,%eax
    3914:	c1 f8 1f             	sar    $0x1f,%eax
    3917:	89 d1                	mov    %edx,%ecx
    3919:	29 c1                	sub    %eax,%ecx
    391b:	6b c1 64             	imul   $0x64,%ecx,%eax
    391e:	29 c3                	sub    %eax,%ebx
    3920:	89 d9                	mov    %ebx,%ecx
    3922:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3927:	89 c8                	mov    %ecx,%eax
    3929:	f7 ea                	imul   %edx
    392b:	c1 fa 02             	sar    $0x2,%edx
    392e:	89 c8                	mov    %ecx,%eax
    3930:	c1 f8 1f             	sar    $0x1f,%eax
    3933:	29 c2                	sub    %eax,%edx
    3935:	89 d0                	mov    %edx,%eax
    3937:	83 c0 30             	add    $0x30,%eax
    393a:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    393d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3940:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3945:	89 c8                	mov    %ecx,%eax
    3947:	f7 ea                	imul   %edx
    3949:	c1 fa 02             	sar    $0x2,%edx
    394c:	89 c8                	mov    %ecx,%eax
    394e:	c1 f8 1f             	sar    $0x1f,%eax
    3951:	29 c2                	sub    %eax,%edx
    3953:	89 d0                	mov    %edx,%eax
    3955:	c1 e0 02             	shl    $0x2,%eax
    3958:	01 d0                	add    %edx,%eax
    395a:	01 c0                	add    %eax,%eax
    395c:	29 c1                	sub    %eax,%ecx
    395e:	89 ca                	mov    %ecx,%edx
    3960:	89 d0                	mov    %edx,%eax
    3962:	83 c0 30             	add    $0x30,%eax
    3965:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3968:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    396c:	83 ec 04             	sub    $0x4,%esp
    396f:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3972:	50                   	push   %eax
    3973:	68 19 5b 00 00       	push   $0x5b19
    3978:	6a 01                	push   $0x1
    397a:	e8 ab 06 00 00       	call   402a <printf>
    397f:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3982:	83 ec 08             	sub    $0x8,%esp
    3985:	68 02 02 00 00       	push   $0x202
    398a:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    398d:	50                   	push   %eax
    398e:	e8 62 05 00 00       	call   3ef5 <open>
    3993:	83 c4 10             	add    $0x10,%esp
    3996:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3999:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    399d:	79 18                	jns    39b7 <fsfull+0x13a>
      printf(1, "open %s failed\n", name);
    399f:	83 ec 04             	sub    $0x4,%esp
    39a2:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39a5:	50                   	push   %eax
    39a6:	68 25 5b 00 00       	push   $0x5b25
    39ab:	6a 01                	push   $0x1
    39ad:	e8 78 06 00 00       	call   402a <printf>
    39b2:	83 c4 10             	add    $0x10,%esp
      break;
    39b5:	eb 6e                	jmp    3a25 <fsfull+0x1a8>
    }
    int total = 0;
    39b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39be:	83 ec 04             	sub    $0x4,%esp
    39c1:	68 00 02 00 00       	push   $0x200
    39c6:	68 c0 8a 00 00       	push   $0x8ac0
    39cb:	ff 75 e8             	pushl  -0x18(%ebp)
    39ce:	e8 02 05 00 00       	call   3ed5 <write>
    39d3:	83 c4 10             	add    $0x10,%esp
    39d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39d9:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39e0:	7f 2c                	jg     3a0e <fsfull+0x191>
        break;
    39e2:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    39e3:	83 ec 04             	sub    $0x4,%esp
    39e6:	ff 75 ec             	pushl  -0x14(%ebp)
    39e9:	68 35 5b 00 00       	push   $0x5b35
    39ee:	6a 01                	push   $0x1
    39f0:	e8 35 06 00 00       	call   402a <printf>
    39f5:	83 c4 10             	add    $0x10,%esp
    close(fd);
    39f8:	83 ec 0c             	sub    $0xc,%esp
    39fb:	ff 75 e8             	pushl  -0x18(%ebp)
    39fe:	e8 da 04 00 00       	call   3edd <close>
    3a03:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3a06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a0a:	75 10                	jne    3a1c <fsfull+0x19f>
    3a0c:	eb 0c                	jmp    3a1a <fsfull+0x19d>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    3a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a11:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3a18:	eb a4                	jmp    39be <fsfull+0x141>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3a1a:	eb 09                	jmp    3a25 <fsfull+0x1a8>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a20:	e9 7f fe ff ff       	jmp    38a4 <fsfull+0x27>

  while(nfiles >= 0){
    3a25:	e9 db 00 00 00       	jmp    3b05 <fsfull+0x288>
    char name[64];
    name[0] = 'f';
    3a2a:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a2e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a31:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a36:	89 c8                	mov    %ecx,%eax
    3a38:	f7 ea                	imul   %edx
    3a3a:	c1 fa 06             	sar    $0x6,%edx
    3a3d:	89 c8                	mov    %ecx,%eax
    3a3f:	c1 f8 1f             	sar    $0x1f,%eax
    3a42:	29 c2                	sub    %eax,%edx
    3a44:	89 d0                	mov    %edx,%eax
    3a46:	83 c0 30             	add    $0x30,%eax
    3a49:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a4c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a4f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a54:	89 d8                	mov    %ebx,%eax
    3a56:	f7 ea                	imul   %edx
    3a58:	c1 fa 06             	sar    $0x6,%edx
    3a5b:	89 d8                	mov    %ebx,%eax
    3a5d:	c1 f8 1f             	sar    $0x1f,%eax
    3a60:	89 d1                	mov    %edx,%ecx
    3a62:	29 c1                	sub    %eax,%ecx
    3a64:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a6a:	29 c3                	sub    %eax,%ebx
    3a6c:	89 d9                	mov    %ebx,%ecx
    3a6e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a73:	89 c8                	mov    %ecx,%eax
    3a75:	f7 ea                	imul   %edx
    3a77:	c1 fa 05             	sar    $0x5,%edx
    3a7a:	89 c8                	mov    %ecx,%eax
    3a7c:	c1 f8 1f             	sar    $0x1f,%eax
    3a7f:	29 c2                	sub    %eax,%edx
    3a81:	89 d0                	mov    %edx,%eax
    3a83:	83 c0 30             	add    $0x30,%eax
    3a86:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a89:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a8c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a91:	89 d8                	mov    %ebx,%eax
    3a93:	f7 ea                	imul   %edx
    3a95:	c1 fa 05             	sar    $0x5,%edx
    3a98:	89 d8                	mov    %ebx,%eax
    3a9a:	c1 f8 1f             	sar    $0x1f,%eax
    3a9d:	89 d1                	mov    %edx,%ecx
    3a9f:	29 c1                	sub    %eax,%ecx
    3aa1:	6b c1 64             	imul   $0x64,%ecx,%eax
    3aa4:	29 c3                	sub    %eax,%ebx
    3aa6:	89 d9                	mov    %ebx,%ecx
    3aa8:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aad:	89 c8                	mov    %ecx,%eax
    3aaf:	f7 ea                	imul   %edx
    3ab1:	c1 fa 02             	sar    $0x2,%edx
    3ab4:	89 c8                	mov    %ecx,%eax
    3ab6:	c1 f8 1f             	sar    $0x1f,%eax
    3ab9:	29 c2                	sub    %eax,%edx
    3abb:	89 d0                	mov    %edx,%eax
    3abd:	83 c0 30             	add    $0x30,%eax
    3ac0:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ac3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3ac6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3acb:	89 c8                	mov    %ecx,%eax
    3acd:	f7 ea                	imul   %edx
    3acf:	c1 fa 02             	sar    $0x2,%edx
    3ad2:	89 c8                	mov    %ecx,%eax
    3ad4:	c1 f8 1f             	sar    $0x1f,%eax
    3ad7:	29 c2                	sub    %eax,%edx
    3ad9:	89 d0                	mov    %edx,%eax
    3adb:	c1 e0 02             	shl    $0x2,%eax
    3ade:	01 d0                	add    %edx,%eax
    3ae0:	01 c0                	add    %eax,%eax
    3ae2:	29 c1                	sub    %eax,%ecx
    3ae4:	89 ca                	mov    %ecx,%edx
    3ae6:	89 d0                	mov    %edx,%eax
    3ae8:	83 c0 30             	add    $0x30,%eax
    3aeb:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3aee:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3af2:	83 ec 0c             	sub    $0xc,%esp
    3af5:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3af8:	50                   	push   %eax
    3af9:	e8 07 04 00 00       	call   3f05 <unlink>
    3afe:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b01:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b09:	0f 89 1b ff ff ff    	jns    3a2a <fsfull+0x1ad>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b0f:	83 ec 08             	sub    $0x8,%esp
    3b12:	68 45 5b 00 00       	push   $0x5b45
    3b17:	6a 01                	push   $0x1
    3b19:	e8 0c 05 00 00       	call   402a <printf>
    3b1e:	83 c4 10             	add    $0x10,%esp
}
    3b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b24:	c9                   	leave  
    3b25:	c3                   	ret    

00003b26 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b26:	55                   	push   %ebp
    3b27:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b29:	a1 a0 62 00 00       	mov    0x62a0,%eax
    3b2e:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b34:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b39:	a3 a0 62 00 00       	mov    %eax,0x62a0
  return randstate;
    3b3e:	a1 a0 62 00 00       	mov    0x62a0,%eax
}
    3b43:	5d                   	pop    %ebp
    3b44:	c3                   	ret    

00003b45 <main>:

int
main(int argc, char *argv[])
{
    3b45:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3b49:	83 e4 f0             	and    $0xfffffff0,%esp
    3b4c:	ff 71 fc             	pushl  -0x4(%ecx)
    3b4f:	55                   	push   %ebp
    3b50:	89 e5                	mov    %esp,%ebp
    3b52:	51                   	push   %ecx
    3b53:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3b56:	83 ec 08             	sub    $0x8,%esp
    3b59:	68 5b 5b 00 00       	push   $0x5b5b
    3b5e:	6a 01                	push   $0x1
    3b60:	e8 c5 04 00 00       	call   402a <printf>
    3b65:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3b68:	83 ec 08             	sub    $0x8,%esp
    3b6b:	6a 00                	push   $0x0
    3b6d:	68 6f 5b 00 00       	push   $0x5b6f
    3b72:	e8 7e 03 00 00       	call   3ef5 <open>
    3b77:	83 c4 10             	add    $0x10,%esp
    3b7a:	85 c0                	test   %eax,%eax
    3b7c:	78 17                	js     3b95 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b7e:	83 ec 08             	sub    $0x8,%esp
    3b81:	68 80 5b 00 00       	push   $0x5b80
    3b86:	6a 01                	push   $0x1
    3b88:	e8 9d 04 00 00       	call   402a <printf>
    3b8d:	83 c4 10             	add    $0x10,%esp
    exit();
    3b90:	e8 20 03 00 00       	call   3eb5 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3b95:	83 ec 08             	sub    $0x8,%esp
    3b98:	68 00 02 00 00       	push   $0x200
    3b9d:	68 6f 5b 00 00       	push   $0x5b6f
    3ba2:	e8 4e 03 00 00       	call   3ef5 <open>
    3ba7:	83 c4 10             	add    $0x10,%esp
    3baa:	83 ec 0c             	sub    $0xc,%esp
    3bad:	50                   	push   %eax
    3bae:	e8 2a 03 00 00       	call   3edd <close>
    3bb3:	83 c4 10             	add    $0x10,%esp

  createdelete();
    3bb6:	e8 e6 d6 ff ff       	call   12a1 <createdelete>
  linkunlink();
    3bbb:	e8 03 e1 ff ff       	call   1cc3 <linkunlink>
  concreate();
    3bc0:	e8 4f dd ff ff       	call   1914 <concreate>
  fourfiles();
    3bc5:	e8 87 d4 ff ff       	call   1051 <fourfiles>
  sharedfd();
    3bca:	e8 9f d2 ff ff       	call   e6e <sharedfd>

  bigargtest();
    3bcf:	e8 6e fb ff ff       	call   3742 <bigargtest>
  bigwrite();
    3bd4:	e8 d5 ea ff ff       	call   26ae <bigwrite>
  bigargtest();
    3bd9:	e8 64 fb ff ff       	call   3742 <bigargtest>
  bsstest();
    3bde:	e8 ea fa ff ff       	call   36cd <bsstest>
  sbrktest();
    3be3:	e8 f9 f4 ff ff       	call   30e1 <sbrktest>
  validatetest();
    3be8:	e8 03 fa ff ff       	call   35f0 <validatetest>

  opentest();
    3bed:	e8 0a c7 ff ff       	call   2fc <opentest>
  writetest();
    3bf2:	e8 b3 c7 ff ff       	call   3aa <writetest>
  writetest1();
    3bf7:	e8 bd c9 ff ff       	call   5b9 <writetest1>
  createtest();
    3bfc:	e8 b5 cb ff ff       	call   7b6 <createtest>

  openiputtest();
    3c01:	e8 e8 c5 ff ff       	call   1ee <openiputtest>
  exitiputtest();
    3c06:	e8 e5 c4 ff ff       	call   f0 <exitiputtest>
  iputtest();
    3c0b:	e8 f0 c3 ff ff       	call   0 <iputtest>

  mem();
    3c10:	e8 69 d1 ff ff       	call   d7e <mem>
  pipe1();
    3c15:	e8 a0 cd ff ff       	call   9ba <pipe1>
  preempt();
    3c1a:	e8 84 cf ff ff       	call   ba3 <preempt>
  exitwait();
    3c1f:	e8 e2 d0 ff ff       	call   d06 <exitwait>

  rmdot();
    3c24:	e8 fa ee ff ff       	call   2b23 <rmdot>
  fourteen();
    3c29:	e8 9a ed ff ff       	call   29c8 <fourteen>
  bigfile();
    3c2e:	e8 78 eb ff ff       	call   27ab <bigfile>
  subdir();
    3c33:	e8 33 e3 ff ff       	call   1f6b <subdir>
  linktest();
    3c38:	e8 96 da ff ff       	call   16d3 <linktest>
  unlinkread();
    3c3d:	e8 d0 d8 ff ff       	call   1512 <unlinkread>
  dirfile();
    3c42:	e8 60 f0 ff ff       	call   2ca7 <dirfile>
  iref();
    3c47:	e8 92 f2 ff ff       	call   2ede <iref>
  forktest();
    3c4c:	e8 c6 f3 ff ff       	call   3017 <forktest>
  bigdir(); // slow
    3c51:	e8 a5 e1 ff ff       	call   1dfb <bigdir>
  exectest();
    3c56:	e8 0d cd ff ff       	call   968 <exectest>

  exit();
    3c5b:	e8 55 02 00 00       	call   3eb5 <exit>

00003c60 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c60:	55                   	push   %ebp
    3c61:	89 e5                	mov    %esp,%ebp
    3c63:	57                   	push   %edi
    3c64:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c65:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c68:	8b 55 10             	mov    0x10(%ebp),%edx
    3c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c6e:	89 cb                	mov    %ecx,%ebx
    3c70:	89 df                	mov    %ebx,%edi
    3c72:	89 d1                	mov    %edx,%ecx
    3c74:	fc                   	cld    
    3c75:	f3 aa                	rep stos %al,%es:(%edi)
    3c77:	89 ca                	mov    %ecx,%edx
    3c79:	89 fb                	mov    %edi,%ebx
    3c7b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c7e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c81:	5b                   	pop    %ebx
    3c82:	5f                   	pop    %edi
    3c83:	5d                   	pop    %ebp
    3c84:	c3                   	ret    

00003c85 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c85:	55                   	push   %ebp
    3c86:	89 e5                	mov    %esp,%ebp
    3c88:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c8b:	8b 45 08             	mov    0x8(%ebp),%eax
    3c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3c91:	90                   	nop
    3c92:	8b 45 08             	mov    0x8(%ebp),%eax
    3c95:	8d 50 01             	lea    0x1(%eax),%edx
    3c98:	89 55 08             	mov    %edx,0x8(%ebp)
    3c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
    3c9e:	8d 4a 01             	lea    0x1(%edx),%ecx
    3ca1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3ca4:	0f b6 12             	movzbl (%edx),%edx
    3ca7:	88 10                	mov    %dl,(%eax)
    3ca9:	0f b6 00             	movzbl (%eax),%eax
    3cac:	84 c0                	test   %al,%al
    3cae:	75 e2                	jne    3c92 <strcpy+0xd>
    ;
  return os;
    3cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cb3:	c9                   	leave  
    3cb4:	c3                   	ret    

00003cb5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cb5:	55                   	push   %ebp
    3cb6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3cb8:	eb 08                	jmp    3cc2 <strcmp+0xd>
    p++, q++;
    3cba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cbe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cc2:	8b 45 08             	mov    0x8(%ebp),%eax
    3cc5:	0f b6 00             	movzbl (%eax),%eax
    3cc8:	84 c0                	test   %al,%al
    3cca:	74 10                	je     3cdc <strcmp+0x27>
    3ccc:	8b 45 08             	mov    0x8(%ebp),%eax
    3ccf:	0f b6 10             	movzbl (%eax),%edx
    3cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cd5:	0f b6 00             	movzbl (%eax),%eax
    3cd8:	38 c2                	cmp    %al,%dl
    3cda:	74 de                	je     3cba <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3cdc:	8b 45 08             	mov    0x8(%ebp),%eax
    3cdf:	0f b6 00             	movzbl (%eax),%eax
    3ce2:	0f b6 d0             	movzbl %al,%edx
    3ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ce8:	0f b6 00             	movzbl (%eax),%eax
    3ceb:	0f b6 c0             	movzbl %al,%eax
    3cee:	29 c2                	sub    %eax,%edx
    3cf0:	89 d0                	mov    %edx,%eax
}
    3cf2:	5d                   	pop    %ebp
    3cf3:	c3                   	ret    

00003cf4 <strlen>:

uint
strlen(char *s)
{
    3cf4:	55                   	push   %ebp
    3cf5:	89 e5                	mov    %esp,%ebp
    3cf7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3cfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d01:	eb 04                	jmp    3d07 <strlen+0x13>
    3d03:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d07:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3d0a:	8b 45 08             	mov    0x8(%ebp),%eax
    3d0d:	01 d0                	add    %edx,%eax
    3d0f:	0f b6 00             	movzbl (%eax),%eax
    3d12:	84 c0                	test   %al,%al
    3d14:	75 ed                	jne    3d03 <strlen+0xf>
    ;
  return n;
    3d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d19:	c9                   	leave  
    3d1a:	c3                   	ret    

00003d1b <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d1b:	55                   	push   %ebp
    3d1c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3d1e:	8b 45 10             	mov    0x10(%ebp),%eax
    3d21:	50                   	push   %eax
    3d22:	ff 75 0c             	pushl  0xc(%ebp)
    3d25:	ff 75 08             	pushl  0x8(%ebp)
    3d28:	e8 33 ff ff ff       	call   3c60 <stosb>
    3d2d:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3d30:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d33:	c9                   	leave  
    3d34:	c3                   	ret    

00003d35 <strchr>:

char*
strchr(const char *s, char c)
{
    3d35:	55                   	push   %ebp
    3d36:	89 e5                	mov    %esp,%ebp
    3d38:	83 ec 04             	sub    $0x4,%esp
    3d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d41:	eb 14                	jmp    3d57 <strchr+0x22>
    if(*s == c)
    3d43:	8b 45 08             	mov    0x8(%ebp),%eax
    3d46:	0f b6 00             	movzbl (%eax),%eax
    3d49:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d4c:	75 05                	jne    3d53 <strchr+0x1e>
      return (char*)s;
    3d4e:	8b 45 08             	mov    0x8(%ebp),%eax
    3d51:	eb 13                	jmp    3d66 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d57:	8b 45 08             	mov    0x8(%ebp),%eax
    3d5a:	0f b6 00             	movzbl (%eax),%eax
    3d5d:	84 c0                	test   %al,%al
    3d5f:	75 e2                	jne    3d43 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d66:	c9                   	leave  
    3d67:	c3                   	ret    

00003d68 <gets>:

char*
gets(char *buf, int max)
{
    3d68:	55                   	push   %ebp
    3d69:	89 e5                	mov    %esp,%ebp
    3d6b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d75:	eb 44                	jmp    3dbb <gets+0x53>
    cc = read(0, &c, 1);
    3d77:	83 ec 04             	sub    $0x4,%esp
    3d7a:	6a 01                	push   $0x1
    3d7c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d7f:	50                   	push   %eax
    3d80:	6a 00                	push   $0x0
    3d82:	e8 46 01 00 00       	call   3ecd <read>
    3d87:	83 c4 10             	add    $0x10,%esp
    3d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3d8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d91:	7f 02                	jg     3d95 <gets+0x2d>
      break;
    3d93:	eb 31                	jmp    3dc6 <gets+0x5e>
    buf[i++] = c;
    3d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d98:	8d 50 01             	lea    0x1(%eax),%edx
    3d9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3d9e:	89 c2                	mov    %eax,%edx
    3da0:	8b 45 08             	mov    0x8(%ebp),%eax
    3da3:	01 c2                	add    %eax,%edx
    3da5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3da9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3dab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3daf:	3c 0a                	cmp    $0xa,%al
    3db1:	74 13                	je     3dc6 <gets+0x5e>
    3db3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3db7:	3c 0d                	cmp    $0xd,%al
    3db9:	74 0b                	je     3dc6 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dbe:	83 c0 01             	add    $0x1,%eax
    3dc1:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dc4:	7c b1                	jl     3d77 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3dc9:	8b 45 08             	mov    0x8(%ebp),%eax
    3dcc:	01 d0                	add    %edx,%eax
    3dce:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dd4:	c9                   	leave  
    3dd5:	c3                   	ret    

00003dd6 <stat>:

int
stat(char *n, struct stat *st)
{
    3dd6:	55                   	push   %ebp
    3dd7:	89 e5                	mov    %esp,%ebp
    3dd9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3ddc:	83 ec 08             	sub    $0x8,%esp
    3ddf:	6a 00                	push   $0x0
    3de1:	ff 75 08             	pushl  0x8(%ebp)
    3de4:	e8 0c 01 00 00       	call   3ef5 <open>
    3de9:	83 c4 10             	add    $0x10,%esp
    3dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3def:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3df3:	79 07                	jns    3dfc <stat+0x26>
    return -1;
    3df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3dfa:	eb 25                	jmp    3e21 <stat+0x4b>
  r = fstat(fd, st);
    3dfc:	83 ec 08             	sub    $0x8,%esp
    3dff:	ff 75 0c             	pushl  0xc(%ebp)
    3e02:	ff 75 f4             	pushl  -0xc(%ebp)
    3e05:	e8 03 01 00 00       	call   3f0d <fstat>
    3e0a:	83 c4 10             	add    $0x10,%esp
    3e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e10:	83 ec 0c             	sub    $0xc,%esp
    3e13:	ff 75 f4             	pushl  -0xc(%ebp)
    3e16:	e8 c2 00 00 00       	call   3edd <close>
    3e1b:	83 c4 10             	add    $0x10,%esp
  return r;
    3e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e21:	c9                   	leave  
    3e22:	c3                   	ret    

00003e23 <atoi>:

int
atoi(const char *s)
{
    3e23:	55                   	push   %ebp
    3e24:	89 e5                	mov    %esp,%ebp
    3e26:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e30:	eb 25                	jmp    3e57 <atoi+0x34>
    n = n*10 + *s++ - '0';
    3e32:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e35:	89 d0                	mov    %edx,%eax
    3e37:	c1 e0 02             	shl    $0x2,%eax
    3e3a:	01 d0                	add    %edx,%eax
    3e3c:	01 c0                	add    %eax,%eax
    3e3e:	89 c1                	mov    %eax,%ecx
    3e40:	8b 45 08             	mov    0x8(%ebp),%eax
    3e43:	8d 50 01             	lea    0x1(%eax),%edx
    3e46:	89 55 08             	mov    %edx,0x8(%ebp)
    3e49:	0f b6 00             	movzbl (%eax),%eax
    3e4c:	0f be c0             	movsbl %al,%eax
    3e4f:	01 c8                	add    %ecx,%eax
    3e51:	83 e8 30             	sub    $0x30,%eax
    3e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e57:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5a:	0f b6 00             	movzbl (%eax),%eax
    3e5d:	3c 2f                	cmp    $0x2f,%al
    3e5f:	7e 0a                	jle    3e6b <atoi+0x48>
    3e61:	8b 45 08             	mov    0x8(%ebp),%eax
    3e64:	0f b6 00             	movzbl (%eax),%eax
    3e67:	3c 39                	cmp    $0x39,%al
    3e69:	7e c7                	jle    3e32 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e6e:	c9                   	leave  
    3e6f:	c3                   	ret    

00003e70 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e70:	55                   	push   %ebp
    3e71:	89 e5                	mov    %esp,%ebp
    3e73:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e76:	8b 45 08             	mov    0x8(%ebp),%eax
    3e79:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3e82:	eb 17                	jmp    3e9b <memmove+0x2b>
    *dst++ = *src++;
    3e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3e87:	8d 50 01             	lea    0x1(%eax),%edx
    3e8a:	89 55 fc             	mov    %edx,-0x4(%ebp)
    3e8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3e90:	8d 4a 01             	lea    0x1(%edx),%ecx
    3e93:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    3e96:	0f b6 12             	movzbl (%edx),%edx
    3e99:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3e9b:	8b 45 10             	mov    0x10(%ebp),%eax
    3e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
    3ea1:	89 55 10             	mov    %edx,0x10(%ebp)
    3ea4:	85 c0                	test   %eax,%eax
    3ea6:	7f dc                	jg     3e84 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3eab:	c9                   	leave  
    3eac:	c3                   	ret    

00003ead <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ead:	b8 01 00 00 00       	mov    $0x1,%eax
    3eb2:	cd 40                	int    $0x40
    3eb4:	c3                   	ret    

00003eb5 <exit>:
SYSCALL(exit)
    3eb5:	b8 02 00 00 00       	mov    $0x2,%eax
    3eba:	cd 40                	int    $0x40
    3ebc:	c3                   	ret    

00003ebd <wait>:
SYSCALL(wait)
    3ebd:	b8 03 00 00 00       	mov    $0x3,%eax
    3ec2:	cd 40                	int    $0x40
    3ec4:	c3                   	ret    

00003ec5 <pipe>:
SYSCALL(pipe)
    3ec5:	b8 04 00 00 00       	mov    $0x4,%eax
    3eca:	cd 40                	int    $0x40
    3ecc:	c3                   	ret    

00003ecd <read>:
SYSCALL(read)
    3ecd:	b8 05 00 00 00       	mov    $0x5,%eax
    3ed2:	cd 40                	int    $0x40
    3ed4:	c3                   	ret    

00003ed5 <write>:
SYSCALL(write)
    3ed5:	b8 10 00 00 00       	mov    $0x10,%eax
    3eda:	cd 40                	int    $0x40
    3edc:	c3                   	ret    

00003edd <close>:
SYSCALL(close)
    3edd:	b8 15 00 00 00       	mov    $0x15,%eax
    3ee2:	cd 40                	int    $0x40
    3ee4:	c3                   	ret    

00003ee5 <kill>:
SYSCALL(kill)
    3ee5:	b8 06 00 00 00       	mov    $0x6,%eax
    3eea:	cd 40                	int    $0x40
    3eec:	c3                   	ret    

00003eed <exec>:
SYSCALL(exec)
    3eed:	b8 07 00 00 00       	mov    $0x7,%eax
    3ef2:	cd 40                	int    $0x40
    3ef4:	c3                   	ret    

00003ef5 <open>:
SYSCALL(open)
    3ef5:	b8 0f 00 00 00       	mov    $0xf,%eax
    3efa:	cd 40                	int    $0x40
    3efc:	c3                   	ret    

00003efd <mknod>:
SYSCALL(mknod)
    3efd:	b8 11 00 00 00       	mov    $0x11,%eax
    3f02:	cd 40                	int    $0x40
    3f04:	c3                   	ret    

00003f05 <unlink>:
SYSCALL(unlink)
    3f05:	b8 12 00 00 00       	mov    $0x12,%eax
    3f0a:	cd 40                	int    $0x40
    3f0c:	c3                   	ret    

00003f0d <fstat>:
SYSCALL(fstat)
    3f0d:	b8 08 00 00 00       	mov    $0x8,%eax
    3f12:	cd 40                	int    $0x40
    3f14:	c3                   	ret    

00003f15 <link>:
SYSCALL(link)
    3f15:	b8 13 00 00 00       	mov    $0x13,%eax
    3f1a:	cd 40                	int    $0x40
    3f1c:	c3                   	ret    

00003f1d <mkdir>:
SYSCALL(mkdir)
    3f1d:	b8 14 00 00 00       	mov    $0x14,%eax
    3f22:	cd 40                	int    $0x40
    3f24:	c3                   	ret    

00003f25 <chdir>:
SYSCALL(chdir)
    3f25:	b8 09 00 00 00       	mov    $0x9,%eax
    3f2a:	cd 40                	int    $0x40
    3f2c:	c3                   	ret    

00003f2d <dup>:
SYSCALL(dup)
    3f2d:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f32:	cd 40                	int    $0x40
    3f34:	c3                   	ret    

00003f35 <getpid>:
SYSCALL(getpid)
    3f35:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f3a:	cd 40                	int    $0x40
    3f3c:	c3                   	ret    

00003f3d <sbrk>:
SYSCALL(sbrk)
    3f3d:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f42:	cd 40                	int    $0x40
    3f44:	c3                   	ret    

00003f45 <sleep>:
SYSCALL(sleep)
    3f45:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f4a:	cd 40                	int    $0x40
    3f4c:	c3                   	ret    

00003f4d <uptime>:
SYSCALL(uptime)
    3f4d:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f52:	cd 40                	int    $0x40
    3f54:	c3                   	ret    

00003f55 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f55:	55                   	push   %ebp
    3f56:	89 e5                	mov    %esp,%ebp
    3f58:	83 ec 18             	sub    $0x18,%esp
    3f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f5e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f61:	83 ec 04             	sub    $0x4,%esp
    3f64:	6a 01                	push   $0x1
    3f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f69:	50                   	push   %eax
    3f6a:	ff 75 08             	pushl  0x8(%ebp)
    3f6d:	e8 63 ff ff ff       	call   3ed5 <write>
    3f72:	83 c4 10             	add    $0x10,%esp
}
    3f75:	c9                   	leave  
    3f76:	c3                   	ret    

00003f77 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3f77:	55                   	push   %ebp
    3f78:	89 e5                	mov    %esp,%ebp
    3f7a:	53                   	push   %ebx
    3f7b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3f7e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3f85:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3f89:	74 17                	je     3fa2 <printint+0x2b>
    3f8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3f8f:	79 11                	jns    3fa2 <printint+0x2b>
    neg = 1;
    3f91:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3f98:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f9b:	f7 d8                	neg    %eax
    3f9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fa0:	eb 06                	jmp    3fa8 <printint+0x31>
  } else {
    x = xx;
    3fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3faf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3fb2:	8d 41 01             	lea    0x1(%ecx),%eax
    3fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3fb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fbe:	ba 00 00 00 00       	mov    $0x0,%edx
    3fc3:	f7 f3                	div    %ebx
    3fc5:	89 d0                	mov    %edx,%eax
    3fc7:	0f b6 80 a4 62 00 00 	movzbl 0x62a4(%eax),%eax
    3fce:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    3fd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fd8:	ba 00 00 00 00       	mov    $0x0,%edx
    3fdd:	f7 f3                	div    %ebx
    3fdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fe2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3fe6:	75 c7                	jne    3faf <printint+0x38>
  if(neg)
    3fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3fec:	74 0e                	je     3ffc <printint+0x85>
    buf[i++] = '-';
    3fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ff1:	8d 50 01             	lea    0x1(%eax),%edx
    3ff4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3ff7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    3ffc:	eb 1d                	jmp    401b <printint+0xa4>
    putc(fd, buf[i]);
    3ffe:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4001:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4004:	01 d0                	add    %edx,%eax
    4006:	0f b6 00             	movzbl (%eax),%eax
    4009:	0f be c0             	movsbl %al,%eax
    400c:	83 ec 08             	sub    $0x8,%esp
    400f:	50                   	push   %eax
    4010:	ff 75 08             	pushl  0x8(%ebp)
    4013:	e8 3d ff ff ff       	call   3f55 <putc>
    4018:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    401b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    401f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4023:	79 d9                	jns    3ffe <printint+0x87>
    putc(fd, buf[i]);
}
    4025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    4028:	c9                   	leave  
    4029:	c3                   	ret    

0000402a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    402a:	55                   	push   %ebp
    402b:	89 e5                	mov    %esp,%ebp
    402d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4037:	8d 45 0c             	lea    0xc(%ebp),%eax
    403a:	83 c0 04             	add    $0x4,%eax
    403d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4040:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4047:	e9 59 01 00 00       	jmp    41a5 <printf+0x17b>
    c = fmt[i] & 0xff;
    404c:	8b 55 0c             	mov    0xc(%ebp),%edx
    404f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4052:	01 d0                	add    %edx,%eax
    4054:	0f b6 00             	movzbl (%eax),%eax
    4057:	0f be c0             	movsbl %al,%eax
    405a:	25 ff 00 00 00       	and    $0xff,%eax
    405f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4062:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4066:	75 2c                	jne    4094 <printf+0x6a>
      if(c == '%'){
    4068:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    406c:	75 0c                	jne    407a <printf+0x50>
        state = '%';
    406e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4075:	e9 27 01 00 00       	jmp    41a1 <printf+0x177>
      } else {
        putc(fd, c);
    407a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    407d:	0f be c0             	movsbl %al,%eax
    4080:	83 ec 08             	sub    $0x8,%esp
    4083:	50                   	push   %eax
    4084:	ff 75 08             	pushl  0x8(%ebp)
    4087:	e8 c9 fe ff ff       	call   3f55 <putc>
    408c:	83 c4 10             	add    $0x10,%esp
    408f:	e9 0d 01 00 00       	jmp    41a1 <printf+0x177>
      }
    } else if(state == '%'){
    4094:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    4098:	0f 85 03 01 00 00    	jne    41a1 <printf+0x177>
      if(c == 'd'){
    409e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40a2:	75 1e                	jne    40c2 <printf+0x98>
        printint(fd, *ap, 10, 1);
    40a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40a7:	8b 00                	mov    (%eax),%eax
    40a9:	6a 01                	push   $0x1
    40ab:	6a 0a                	push   $0xa
    40ad:	50                   	push   %eax
    40ae:	ff 75 08             	pushl  0x8(%ebp)
    40b1:	e8 c1 fe ff ff       	call   3f77 <printint>
    40b6:	83 c4 10             	add    $0x10,%esp
        ap++;
    40b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40bd:	e9 d8 00 00 00       	jmp    419a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    40c2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    40c6:	74 06                	je     40ce <printf+0xa4>
    40c8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    40cc:	75 1e                	jne    40ec <printf+0xc2>
        printint(fd, *ap, 16, 0);
    40ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40d1:	8b 00                	mov    (%eax),%eax
    40d3:	6a 00                	push   $0x0
    40d5:	6a 10                	push   $0x10
    40d7:	50                   	push   %eax
    40d8:	ff 75 08             	pushl  0x8(%ebp)
    40db:	e8 97 fe ff ff       	call   3f77 <printint>
    40e0:	83 c4 10             	add    $0x10,%esp
        ap++;
    40e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40e7:	e9 ae 00 00 00       	jmp    419a <printf+0x170>
      } else if(c == 's'){
    40ec:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    40f0:	75 43                	jne    4135 <printf+0x10b>
        s = (char*)*ap;
    40f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40f5:	8b 00                	mov    (%eax),%eax
    40f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    40fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    40fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4102:	75 07                	jne    410b <printf+0xe1>
          s = "(null)";
    4104:	c7 45 f4 aa 5b 00 00 	movl   $0x5baa,-0xc(%ebp)
        while(*s != 0){
    410b:	eb 1c                	jmp    4129 <printf+0xff>
          putc(fd, *s);
    410d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4110:	0f b6 00             	movzbl (%eax),%eax
    4113:	0f be c0             	movsbl %al,%eax
    4116:	83 ec 08             	sub    $0x8,%esp
    4119:	50                   	push   %eax
    411a:	ff 75 08             	pushl  0x8(%ebp)
    411d:	e8 33 fe ff ff       	call   3f55 <putc>
    4122:	83 c4 10             	add    $0x10,%esp
          s++;
    4125:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4129:	8b 45 f4             	mov    -0xc(%ebp),%eax
    412c:	0f b6 00             	movzbl (%eax),%eax
    412f:	84 c0                	test   %al,%al
    4131:	75 da                	jne    410d <printf+0xe3>
    4133:	eb 65                	jmp    419a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4135:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4139:	75 1d                	jne    4158 <printf+0x12e>
        putc(fd, *ap);
    413b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    413e:	8b 00                	mov    (%eax),%eax
    4140:	0f be c0             	movsbl %al,%eax
    4143:	83 ec 08             	sub    $0x8,%esp
    4146:	50                   	push   %eax
    4147:	ff 75 08             	pushl  0x8(%ebp)
    414a:	e8 06 fe ff ff       	call   3f55 <putc>
    414f:	83 c4 10             	add    $0x10,%esp
        ap++;
    4152:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4156:	eb 42                	jmp    419a <printf+0x170>
      } else if(c == '%'){
    4158:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    415c:	75 17                	jne    4175 <printf+0x14b>
        putc(fd, c);
    415e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4161:	0f be c0             	movsbl %al,%eax
    4164:	83 ec 08             	sub    $0x8,%esp
    4167:	50                   	push   %eax
    4168:	ff 75 08             	pushl  0x8(%ebp)
    416b:	e8 e5 fd ff ff       	call   3f55 <putc>
    4170:	83 c4 10             	add    $0x10,%esp
    4173:	eb 25                	jmp    419a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4175:	83 ec 08             	sub    $0x8,%esp
    4178:	6a 25                	push   $0x25
    417a:	ff 75 08             	pushl  0x8(%ebp)
    417d:	e8 d3 fd ff ff       	call   3f55 <putc>
    4182:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    4185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4188:	0f be c0             	movsbl %al,%eax
    418b:	83 ec 08             	sub    $0x8,%esp
    418e:	50                   	push   %eax
    418f:	ff 75 08             	pushl  0x8(%ebp)
    4192:	e8 be fd ff ff       	call   3f55 <putc>
    4197:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    419a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    41a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    41a5:	8b 55 0c             	mov    0xc(%ebp),%edx
    41a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41ab:	01 d0                	add    %edx,%eax
    41ad:	0f b6 00             	movzbl (%eax),%eax
    41b0:	84 c0                	test   %al,%al
    41b2:	0f 85 94 fe ff ff    	jne    404c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    41b8:	c9                   	leave  
    41b9:	c3                   	ret    

000041ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    41ba:	55                   	push   %ebp
    41bb:	89 e5                	mov    %esp,%ebp
    41bd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    41c0:	8b 45 08             	mov    0x8(%ebp),%eax
    41c3:	83 e8 08             	sub    $0x8,%eax
    41c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41c9:	a1 48 63 00 00       	mov    0x6348,%eax
    41ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    41d1:	eb 24                	jmp    41f7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    41d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41d6:	8b 00                	mov    (%eax),%eax
    41d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41db:	77 12                	ja     41ef <free+0x35>
    41dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41e3:	77 24                	ja     4209 <free+0x4f>
    41e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41e8:	8b 00                	mov    (%eax),%eax
    41ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    41ed:	77 1a                	ja     4209 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41f2:	8b 00                	mov    (%eax),%eax
    41f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    41f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41fd:	76 d4                	jbe    41d3 <free+0x19>
    41ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4202:	8b 00                	mov    (%eax),%eax
    4204:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4207:	76 ca                	jbe    41d3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4209:	8b 45 f8             	mov    -0x8(%ebp),%eax
    420c:	8b 40 04             	mov    0x4(%eax),%eax
    420f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4216:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4219:	01 c2                	add    %eax,%edx
    421b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    421e:	8b 00                	mov    (%eax),%eax
    4220:	39 c2                	cmp    %eax,%edx
    4222:	75 24                	jne    4248 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4224:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4227:	8b 50 04             	mov    0x4(%eax),%edx
    422a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    422d:	8b 00                	mov    (%eax),%eax
    422f:	8b 40 04             	mov    0x4(%eax),%eax
    4232:	01 c2                	add    %eax,%edx
    4234:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4237:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    423a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    423d:	8b 00                	mov    (%eax),%eax
    423f:	8b 10                	mov    (%eax),%edx
    4241:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4244:	89 10                	mov    %edx,(%eax)
    4246:	eb 0a                	jmp    4252 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4248:	8b 45 fc             	mov    -0x4(%ebp),%eax
    424b:	8b 10                	mov    (%eax),%edx
    424d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4250:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4252:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4255:	8b 40 04             	mov    0x4(%eax),%eax
    4258:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    425f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4262:	01 d0                	add    %edx,%eax
    4264:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4267:	75 20                	jne    4289 <free+0xcf>
    p->s.size += bp->s.size;
    4269:	8b 45 fc             	mov    -0x4(%ebp),%eax
    426c:	8b 50 04             	mov    0x4(%eax),%edx
    426f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4272:	8b 40 04             	mov    0x4(%eax),%eax
    4275:	01 c2                	add    %eax,%edx
    4277:	8b 45 fc             	mov    -0x4(%ebp),%eax
    427a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    427d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4280:	8b 10                	mov    (%eax),%edx
    4282:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4285:	89 10                	mov    %edx,(%eax)
    4287:	eb 08                	jmp    4291 <free+0xd7>
  } else
    p->s.ptr = bp;
    4289:	8b 45 fc             	mov    -0x4(%ebp),%eax
    428c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    428f:	89 10                	mov    %edx,(%eax)
  freep = p;
    4291:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4294:	a3 48 63 00 00       	mov    %eax,0x6348
}
    4299:	c9                   	leave  
    429a:	c3                   	ret    

0000429b <morecore>:

static Header*
morecore(uint nu)
{
    429b:	55                   	push   %ebp
    429c:	89 e5                	mov    %esp,%ebp
    429e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42a1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    42a8:	77 07                	ja     42b1 <morecore+0x16>
    nu = 4096;
    42aa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    42b1:	8b 45 08             	mov    0x8(%ebp),%eax
    42b4:	c1 e0 03             	shl    $0x3,%eax
    42b7:	83 ec 0c             	sub    $0xc,%esp
    42ba:	50                   	push   %eax
    42bb:	e8 7d fc ff ff       	call   3f3d <sbrk>
    42c0:	83 c4 10             	add    $0x10,%esp
    42c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    42c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    42ca:	75 07                	jne    42d3 <morecore+0x38>
    return 0;
    42cc:	b8 00 00 00 00       	mov    $0x0,%eax
    42d1:	eb 26                	jmp    42f9 <morecore+0x5e>
  hp = (Header*)p;
    42d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    42d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42dc:	8b 55 08             	mov    0x8(%ebp),%edx
    42df:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    42e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42e5:	83 c0 08             	add    $0x8,%eax
    42e8:	83 ec 0c             	sub    $0xc,%esp
    42eb:	50                   	push   %eax
    42ec:	e8 c9 fe ff ff       	call   41ba <free>
    42f1:	83 c4 10             	add    $0x10,%esp
  return freep;
    42f4:	a1 48 63 00 00       	mov    0x6348,%eax
}
    42f9:	c9                   	leave  
    42fa:	c3                   	ret    

000042fb <malloc>:

void*
malloc(uint nbytes)
{
    42fb:	55                   	push   %ebp
    42fc:	89 e5                	mov    %esp,%ebp
    42fe:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4301:	8b 45 08             	mov    0x8(%ebp),%eax
    4304:	83 c0 07             	add    $0x7,%eax
    4307:	c1 e8 03             	shr    $0x3,%eax
    430a:	83 c0 01             	add    $0x1,%eax
    430d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4310:	a1 48 63 00 00       	mov    0x6348,%eax
    4315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    431c:	75 23                	jne    4341 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    431e:	c7 45 f0 40 63 00 00 	movl   $0x6340,-0x10(%ebp)
    4325:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4328:	a3 48 63 00 00       	mov    %eax,0x6348
    432d:	a1 48 63 00 00       	mov    0x6348,%eax
    4332:	a3 40 63 00 00       	mov    %eax,0x6340
    base.s.size = 0;
    4337:	c7 05 44 63 00 00 00 	movl   $0x0,0x6344
    433e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4341:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4344:	8b 00                	mov    (%eax),%eax
    4346:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4349:	8b 45 f4             	mov    -0xc(%ebp),%eax
    434c:	8b 40 04             	mov    0x4(%eax),%eax
    434f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4352:	72 4d                	jb     43a1 <malloc+0xa6>
      if(p->s.size == nunits)
    4354:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4357:	8b 40 04             	mov    0x4(%eax),%eax
    435a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    435d:	75 0c                	jne    436b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4362:	8b 10                	mov    (%eax),%edx
    4364:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4367:	89 10                	mov    %edx,(%eax)
    4369:	eb 26                	jmp    4391 <malloc+0x96>
      else {
        p->s.size -= nunits;
    436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    436e:	8b 40 04             	mov    0x4(%eax),%eax
    4371:	2b 45 ec             	sub    -0x14(%ebp),%eax
    4374:	89 c2                	mov    %eax,%edx
    4376:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4379:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    437c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    437f:	8b 40 04             	mov    0x4(%eax),%eax
    4382:	c1 e0 03             	shl    $0x3,%eax
    4385:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4388:	8b 45 f4             	mov    -0xc(%ebp),%eax
    438b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    438e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4391:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4394:	a3 48 63 00 00       	mov    %eax,0x6348
      return (void*)(p + 1);
    4399:	8b 45 f4             	mov    -0xc(%ebp),%eax
    439c:	83 c0 08             	add    $0x8,%eax
    439f:	eb 3b                	jmp    43dc <malloc+0xe1>
    }
    if(p == freep)
    43a1:	a1 48 63 00 00       	mov    0x6348,%eax
    43a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43a9:	75 1e                	jne    43c9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    43ab:	83 ec 0c             	sub    $0xc,%esp
    43ae:	ff 75 ec             	pushl  -0x14(%ebp)
    43b1:	e8 e5 fe ff ff       	call   429b <morecore>
    43b6:	83 c4 10             	add    $0x10,%esp
    43b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    43bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    43c0:	75 07                	jne    43c9 <malloc+0xce>
        return 0;
    43c2:	b8 00 00 00 00       	mov    $0x0,%eax
    43c7:	eb 13                	jmp    43dc <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    43cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43d2:	8b 00                	mov    (%eax),%eax
    43d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    43d7:	e9 6d ff ff ff       	jmp    4349 <malloc+0x4e>
}
    43dc:	c9                   	leave  
    43dd:	c3                   	ret    
