
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 1e 0f 00 00       	call   f2f <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 84 14 00 00 	mov    0x1484(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 58 14 00 00       	push   $0x1458
      2c:	e8 cd 03 00 00       	call   3fe <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 e6 0e 00 00       	call   f2f <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 08 0f 00 00       	call   f67 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 5f 14 00 00       	push   $0x145f
      71:	6a 02                	push   $0x2
      73:	e8 2c 10 00 00       	call   10a4 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c8 01 00 00       	jmp    248 <runcmd+0x248>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 c2 0e 00 00       	call   f57 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 c1 0e 00 00       	call   f6f <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 6f 14 00 00       	push   $0x146f
      c4:	6a 02                	push   $0x2
      c6:	e8 d9 0f 00 00       	call   10a4 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 5c 0e 00 00       	call   f2f <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5e 01 00 00       	jmp    248 <runcmd+0x248>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 29 03 00 00       	call   41e <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 27 0e 00 00       	call   f37 <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 21 01 00 00       	jmp    248 <runcmd+0x248>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 06 0e 00 00       	call   f3f <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 7f 14 00 00       	push   $0x147f
     148:	e8 b1 02 00 00       	call   3fe <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 c9 02 00 00       	call   41e <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 f4 0d 00 00       	call   f57 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 35 0e 00 00       	call   fa7 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 d6 0d 00 00       	call   f57 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 c7 0d 00 00       	call   f57 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 74 02 00 00       	call   41e <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 9f 0d 00 00       	call   f57 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 e0 0d 00 00       	call   fa7 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 81 0d 00 00       	call   f57 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 72 0d 00 00       	call   f57 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 51 0d 00 00       	call   f57 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 42 0d 00 00       	call   f57 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 1a 0d 00 00       	call   f37 <wait>
    wait();
     21d:	e8 15 0d 00 00       	call   f37 <wait>
    break;
     222:	eb 24                	jmp    248 <runcmd+0x248>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 ef 01 00 00       	call   41e <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 14                	jne    247 <runcmd+0x247>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	eb 00                	jmp    247 <runcmd+0x247>
     247:	90                   	nop
  }
  exit();
     248:	e8 e2 0c 00 00       	call   f2f <exit>

0000024d <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24d:	55                   	push   %ebp
     24e:	89 e5                	mov    %esp,%ebp
     250:	83 ec 08             	sub    $0x8,%esp
  printf(2, "uNIX# ");
     253:	83 ec 08             	sub    $0x8,%esp
     256:	68 9c 14 00 00       	push   $0x149c
     25b:	6a 02                	push   $0x2
     25d:	e8 42 0e 00 00       	call   10a4 <printf>
     262:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     265:	8b 45 0c             	mov    0xc(%ebp),%eax
     268:	83 ec 04             	sub    $0x4,%esp
     26b:	50                   	push   %eax
     26c:	6a 00                	push   $0x0
     26e:	ff 75 08             	pushl  0x8(%ebp)
     271:	e8 1f 0b 00 00       	call   d95 <memset>
     276:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     279:	83 ec 08             	sub    $0x8,%esp
     27c:	ff 75 0c             	pushl  0xc(%ebp)
     27f:	ff 75 08             	pushl  0x8(%ebp)
     282:	e8 5b 0b 00 00       	call   de2 <gets>
     287:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     28a:	8b 45 08             	mov    0x8(%ebp),%eax
     28d:	0f b6 00             	movzbl (%eax),%eax
     290:	84 c0                	test   %al,%al
     292:	75 07                	jne    29b <getcmd+0x4e>
    return -1;
     294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     299:	eb 05                	jmp    2a0 <getcmd+0x53>
  return 0;
     29b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2a0:	c9                   	leave  
     2a1:	c3                   	ret    

000002a2 <main>:

int
main(void)
{
     2a2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a6:	83 e4 f0             	and    $0xfffffff0,%esp
     2a9:	ff 71 fc             	pushl  -0x4(%ecx)
     2ac:	55                   	push   %ebp
     2ad:	89 e5                	mov    %esp,%ebp
     2af:	51                   	push   %ecx
     2b0:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;

  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0) {
     2b3:	eb 16                	jmp    2cb <main+0x29>
    if(fd >= 3){
     2b5:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2b9:	7e 10                	jle    2cb <main+0x29>
      close(fd);
     2bb:	83 ec 0c             	sub    $0xc,%esp
     2be:	ff 75 f4             	pushl  -0xc(%ebp)
     2c1:	e8 91 0c 00 00       	call   f57 <close>
     2c6:	83 c4 10             	add    $0x10,%esp

      break;
     2c9:	eb 1b                	jmp    2e6 <main+0x44>
{
  static char buf[100];
  int fd;

  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0) {
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	6a 02                	push   $0x2
     2d0:	68 a3 14 00 00       	push   $0x14a3
     2d5:	e8 95 0c 00 00       	call   f6f <open>
     2da:	83 c4 10             	add    $0x10,%esp
     2dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2e4:	79 cf                	jns    2b5 <main+0x13>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0) {
     2e6:	e9 f4 00 00 00       	jmp    3df <main+0x13d>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2eb:	0f b6 05 40 1a 00 00 	movzbl 0x1a40,%eax
     2f2:	3c 63                	cmp    $0x63,%al
     2f4:	75 60                	jne    356 <main+0xb4>
     2f6:	0f b6 05 41 1a 00 00 	movzbl 0x1a41,%eax
     2fd:	3c 64                	cmp    $0x64,%al
     2ff:	75 55                	jne    356 <main+0xb4>
     301:	0f b6 05 42 1a 00 00 	movzbl 0x1a42,%eax
     308:	3c 20                	cmp    $0x20,%al
     30a:	75 4a                	jne    356 <main+0xb4>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     30c:	83 ec 0c             	sub    $0xc,%esp
     30f:	68 40 1a 00 00       	push   $0x1a40
     314:	e8 55 0a 00 00       	call   d6e <strlen>
     319:	83 c4 10             	add    $0x10,%esp
     31c:	83 e8 01             	sub    $0x1,%eax
     31f:	c6 80 40 1a 00 00 00 	movb   $0x0,0x1a40(%eax)
      if(chdir(buf+3) < 0)
     326:	83 ec 0c             	sub    $0xc,%esp
     329:	68 43 1a 00 00       	push   $0x1a43
     32e:	e8 6c 0c 00 00       	call   f9f <chdir>
     333:	83 c4 10             	add    $0x10,%esp
     336:	85 c0                	test   %eax,%eax
     338:	79 17                	jns    351 <main+0xaf>
        printf(2, "cannot cd %s\n", buf+3);
     33a:	83 ec 04             	sub    $0x4,%esp
     33d:	68 43 1a 00 00       	push   $0x1a43
     342:	68 ab 14 00 00       	push   $0x14ab
     347:	6a 02                	push   $0x2
     349:	e8 56 0d 00 00       	call   10a4 <printf>
     34e:	83 c4 10             	add    $0x10,%esp
      continue;
     351:	e9 89 00 00 00       	jmp    3df <main+0x13d>
    } else if(buf[0] == 'v' && buf[1] == 'e' && buf[2] == 'r' && buf[3] == 's' && buf[4] == 'i' && buf[5] == 'o' && buf[6] == 'n')
     356:	0f b6 05 40 1a 00 00 	movzbl 0x1a40,%eax
     35d:	3c 76                	cmp    $0x76,%al
     35f:	75 54                	jne    3b5 <main+0x113>
     361:	0f b6 05 41 1a 00 00 	movzbl 0x1a41,%eax
     368:	3c 65                	cmp    $0x65,%al
     36a:	75 49                	jne    3b5 <main+0x113>
     36c:	0f b6 05 42 1a 00 00 	movzbl 0x1a42,%eax
     373:	3c 72                	cmp    $0x72,%al
     375:	75 3e                	jne    3b5 <main+0x113>
     377:	0f b6 05 43 1a 00 00 	movzbl 0x1a43,%eax
     37e:	3c 73                	cmp    $0x73,%al
     380:	75 33                	jne    3b5 <main+0x113>
     382:	0f b6 05 44 1a 00 00 	movzbl 0x1a44,%eax
     389:	3c 69                	cmp    $0x69,%al
     38b:	75 28                	jne    3b5 <main+0x113>
     38d:	0f b6 05 45 1a 00 00 	movzbl 0x1a45,%eax
     394:	3c 6f                	cmp    $0x6f,%al
     396:	75 1d                	jne    3b5 <main+0x113>
     398:	0f b6 05 46 1a 00 00 	movzbl 0x1a46,%eax
     39f:	3c 6e                	cmp    $0x6e,%al
     3a1:	75 12                	jne    3b5 <main+0x113>
    	printf(1, "uNIX Version 0-1 \n Build Version 3");
     3a3:	83 ec 08             	sub    $0x8,%esp
     3a6:	68 bc 14 00 00       	push   $0x14bc
     3ab:	6a 01                	push   $0x1
     3ad:	e8 f2 0c 00 00       	call   10a4 <printf>
     3b2:	83 c4 10             	add    $0x10,%esp

    if(fork1() == 0)
     3b5:	e8 64 00 00 00       	call   41e <fork1>
     3ba:	85 c0                	test   %eax,%eax
     3bc:	75 1c                	jne    3da <main+0x138>
      runcmd(parsecmd(buf));
     3be:	83 ec 0c             	sub    $0xc,%esp
     3c1:	68 40 1a 00 00       	push   $0x1a40
     3c6:	e8 a7 03 00 00       	call   772 <parsecmd>
     3cb:	83 c4 10             	add    $0x10,%esp
     3ce:	83 ec 0c             	sub    $0xc,%esp
     3d1:	50                   	push   %eax
     3d2:	e8 29 fc ff ff       	call   0 <runcmd>
     3d7:	83 c4 10             	add    $0x10,%esp
    wait();
     3da:	e8 58 0b 00 00       	call   f37 <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0) {
     3df:	83 ec 08             	sub    $0x8,%esp
     3e2:	6a 64                	push   $0x64
     3e4:	68 40 1a 00 00       	push   $0x1a40
     3e9:	e8 5f fe ff ff       	call   24d <getcmd>
     3ee:	83 c4 10             	add    $0x10,%esp
     3f1:	85 c0                	test   %eax,%eax
     3f3:	0f 89 f2 fe ff ff    	jns    2eb <main+0x49>

    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     3f9:	e8 31 0b 00 00       	call   f2f <exit>

000003fe <panic>:
}

void
panic(char *s)
{
     3fe:	55                   	push   %ebp
     3ff:	89 e5                	mov    %esp,%ebp
     401:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     404:	83 ec 04             	sub    $0x4,%esp
     407:	ff 75 08             	pushl  0x8(%ebp)
     40a:	68 df 14 00 00       	push   $0x14df
     40f:	6a 02                	push   $0x2
     411:	e8 8e 0c 00 00       	call   10a4 <printf>
     416:	83 c4 10             	add    $0x10,%esp
  exit();
     419:	e8 11 0b 00 00       	call   f2f <exit>

0000041e <fork1>:
}

int
fork1(void)
{
     41e:	55                   	push   %ebp
     41f:	89 e5                	mov    %esp,%ebp
     421:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
     424:	e8 fe 0a 00 00       	call   f27 <fork>
     429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     42c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     430:	75 10                	jne    442 <fork1+0x24>
    panic("fork");
     432:	83 ec 0c             	sub    $0xc,%esp
     435:	68 e3 14 00 00       	push   $0x14e3
     43a:	e8 bf ff ff ff       	call   3fe <panic>
     43f:	83 c4 10             	add    $0x10,%esp
  return pid;
     442:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     445:	c9                   	leave  
     446:	c3                   	ret    

00000447 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     447:	55                   	push   %ebp
     448:	89 e5                	mov    %esp,%ebp
     44a:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     44d:	83 ec 0c             	sub    $0xc,%esp
     450:	6a 54                	push   $0x54
     452:	e8 1e 0f 00 00       	call   1375 <malloc>
     457:	83 c4 10             	add    $0x10,%esp
     45a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     45d:	83 ec 04             	sub    $0x4,%esp
     460:	6a 54                	push   $0x54
     462:	6a 00                	push   $0x0
     464:	ff 75 f4             	pushl  -0xc(%ebp)
     467:	e8 29 09 00 00       	call   d95 <memset>
     46c:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     472:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     478:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47b:	c9                   	leave  
     47c:	c3                   	ret    

0000047d <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     47d:	55                   	push   %ebp
     47e:	89 e5                	mov    %esp,%ebp
     480:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     483:	83 ec 0c             	sub    $0xc,%esp
     486:	6a 18                	push   $0x18
     488:	e8 e8 0e 00 00       	call   1375 <malloc>
     48d:	83 c4 10             	add    $0x10,%esp
     490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     493:	83 ec 04             	sub    $0x4,%esp
     496:	6a 18                	push   $0x18
     498:	6a 00                	push   $0x0
     49a:	ff 75 f4             	pushl  -0xc(%ebp)
     49d:	e8 f3 08 00 00       	call   d95 <memset>
     4a2:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     4ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b1:	8b 55 08             	mov    0x8(%ebp),%edx
     4b4:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     4b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ba:	8b 55 0c             	mov    0xc(%ebp),%edx
     4bd:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c3:	8b 55 10             	mov    0x10(%ebp),%edx
     4c6:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4cc:	8b 55 14             	mov    0x14(%ebp),%edx
     4cf:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d5:	8b 55 18             	mov    0x18(%ebp),%edx
     4d8:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     4db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4de:	c9                   	leave  
     4df:	c3                   	ret    

000004e0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     4e0:	55                   	push   %ebp
     4e1:	89 e5                	mov    %esp,%ebp
     4e3:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4e6:	83 ec 0c             	sub    $0xc,%esp
     4e9:	6a 0c                	push   $0xc
     4eb:	e8 85 0e 00 00       	call   1375 <malloc>
     4f0:	83 c4 10             	add    $0x10,%esp
     4f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4f6:	83 ec 04             	sub    $0x4,%esp
     4f9:	6a 0c                	push   $0xc
     4fb:	6a 00                	push   $0x0
     4fd:	ff 75 f4             	pushl  -0xc(%ebp)
     500:	e8 90 08 00 00       	call   d95 <memset>
     505:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     508:	8b 45 f4             	mov    -0xc(%ebp),%eax
     50b:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     511:	8b 45 f4             	mov    -0xc(%ebp),%eax
     514:	8b 55 08             	mov    0x8(%ebp),%edx
     517:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     51a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51d:	8b 55 0c             	mov    0xc(%ebp),%edx
     520:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     523:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     526:	c9                   	leave  
     527:	c3                   	ret    

00000528 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     528:	55                   	push   %ebp
     529:	89 e5                	mov    %esp,%ebp
     52b:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     52e:	83 ec 0c             	sub    $0xc,%esp
     531:	6a 0c                	push   $0xc
     533:	e8 3d 0e 00 00       	call   1375 <malloc>
     538:	83 c4 10             	add    $0x10,%esp
     53b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     53e:	83 ec 04             	sub    $0x4,%esp
     541:	6a 0c                	push   $0xc
     543:	6a 00                	push   $0x0
     545:	ff 75 f4             	pushl  -0xc(%ebp)
     548:	e8 48 08 00 00       	call   d95 <memset>
     54d:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     550:	8b 45 f4             	mov    -0xc(%ebp),%eax
     553:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     559:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55c:	8b 55 08             	mov    0x8(%ebp),%edx
     55f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     562:	8b 45 f4             	mov    -0xc(%ebp),%eax
     565:	8b 55 0c             	mov    0xc(%ebp),%edx
     568:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     56e:	c9                   	leave  
     56f:	c3                   	ret    

00000570 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     570:	55                   	push   %ebp
     571:	89 e5                	mov    %esp,%ebp
     573:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     576:	83 ec 0c             	sub    $0xc,%esp
     579:	6a 08                	push   $0x8
     57b:	e8 f5 0d 00 00       	call   1375 <malloc>
     580:	83 c4 10             	add    $0x10,%esp
     583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     586:	83 ec 04             	sub    $0x4,%esp
     589:	6a 08                	push   $0x8
     58b:	6a 00                	push   $0x0
     58d:	ff 75 f4             	pushl  -0xc(%ebp)
     590:	e8 00 08 00 00       	call   d95 <memset>
     595:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     598:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59b:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a4:	8b 55 08             	mov    0x8(%ebp),%edx
     5a7:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     5aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5ad:	c9                   	leave  
     5ae:	c3                   	ret    

000005af <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     5af:	55                   	push   %ebp
     5b0:	89 e5                	mov    %esp,%ebp
     5b2:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;

  s = *ps;
     5b5:	8b 45 08             	mov    0x8(%ebp),%eax
     5b8:	8b 00                	mov    (%eax),%eax
     5ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     5bd:	eb 04                	jmp    5c3 <gettoken+0x14>
    s++;
     5bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5c9:	73 1e                	jae    5e9 <gettoken+0x3a>
     5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ce:	0f b6 00             	movzbl (%eax),%eax
     5d1:	0f be c0             	movsbl %al,%eax
     5d4:	83 ec 08             	sub    $0x8,%esp
     5d7:	50                   	push   %eax
     5d8:	68 00 1a 00 00       	push   $0x1a00
     5dd:	e8 cd 07 00 00       	call   daf <strchr>
     5e2:	83 c4 10             	add    $0x10,%esp
     5e5:	85 c0                	test   %eax,%eax
     5e7:	75 d6                	jne    5bf <gettoken+0x10>
    s++;
  if(q)
     5e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     5ed:	74 08                	je     5f7 <gettoken+0x48>
    *q = s;
     5ef:	8b 45 10             	mov    0x10(%ebp),%eax
     5f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5f5:	89 10                	mov    %edx,(%eax)
  ret = *s;
     5f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fa:	0f b6 00             	movzbl (%eax),%eax
     5fd:	0f be c0             	movsbl %al,%eax
     600:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     603:	8b 45 f4             	mov    -0xc(%ebp),%eax
     606:	0f b6 00             	movzbl (%eax),%eax
     609:	0f be c0             	movsbl %al,%eax
     60c:	83 f8 29             	cmp    $0x29,%eax
     60f:	7f 14                	jg     625 <gettoken+0x76>
     611:	83 f8 28             	cmp    $0x28,%eax
     614:	7d 28                	jge    63e <gettoken+0x8f>
     616:	85 c0                	test   %eax,%eax
     618:	0f 84 96 00 00 00    	je     6b4 <gettoken+0x105>
     61e:	83 f8 26             	cmp    $0x26,%eax
     621:	74 1b                	je     63e <gettoken+0x8f>
     623:	eb 3c                	jmp    661 <gettoken+0xb2>
     625:	83 f8 3e             	cmp    $0x3e,%eax
     628:	74 1a                	je     644 <gettoken+0x95>
     62a:	83 f8 3e             	cmp    $0x3e,%eax
     62d:	7f 0a                	jg     639 <gettoken+0x8a>
     62f:	83 e8 3b             	sub    $0x3b,%eax
     632:	83 f8 01             	cmp    $0x1,%eax
     635:	77 2a                	ja     661 <gettoken+0xb2>
     637:	eb 05                	jmp    63e <gettoken+0x8f>
     639:	83 f8 7c             	cmp    $0x7c,%eax
     63c:	75 23                	jne    661 <gettoken+0xb2>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     63e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     642:	eb 71                	jmp    6b5 <gettoken+0x106>
  case '>':
    s++;
     644:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     648:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64b:	0f b6 00             	movzbl (%eax),%eax
     64e:	3c 3e                	cmp    $0x3e,%al
     650:	75 0d                	jne    65f <gettoken+0xb0>
      ret = '+';
     652:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     659:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     65d:	eb 56                	jmp    6b5 <gettoken+0x106>
     65f:	eb 54                	jmp    6b5 <gettoken+0x106>
  default:
    ret = 'a';
     661:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     668:	eb 04                	jmp    66e <gettoken+0xbf>
      s++;
     66a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     66e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     671:	3b 45 0c             	cmp    0xc(%ebp),%eax
     674:	73 3c                	jae    6b2 <gettoken+0x103>
     676:	8b 45 f4             	mov    -0xc(%ebp),%eax
     679:	0f b6 00             	movzbl (%eax),%eax
     67c:	0f be c0             	movsbl %al,%eax
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	50                   	push   %eax
     683:	68 00 1a 00 00       	push   $0x1a00
     688:	e8 22 07 00 00       	call   daf <strchr>
     68d:	83 c4 10             	add    $0x10,%esp
     690:	85 c0                	test   %eax,%eax
     692:	75 1e                	jne    6b2 <gettoken+0x103>
     694:	8b 45 f4             	mov    -0xc(%ebp),%eax
     697:	0f b6 00             	movzbl (%eax),%eax
     69a:	0f be c0             	movsbl %al,%eax
     69d:	83 ec 08             	sub    $0x8,%esp
     6a0:	50                   	push   %eax
     6a1:	68 06 1a 00 00       	push   $0x1a06
     6a6:	e8 04 07 00 00       	call   daf <strchr>
     6ab:	83 c4 10             	add    $0x10,%esp
     6ae:	85 c0                	test   %eax,%eax
     6b0:	74 b8                	je     66a <gettoken+0xbb>
      s++;
    break;
     6b2:	eb 01                	jmp    6b5 <gettoken+0x106>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     6b4:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     6b5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6b9:	74 08                	je     6c3 <gettoken+0x114>
    *eq = s;
     6bb:	8b 45 14             	mov    0x14(%ebp),%eax
     6be:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6c1:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     6c3:	eb 04                	jmp    6c9 <gettoken+0x11a>
    s++;
     6c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6cf:	73 1e                	jae    6ef <gettoken+0x140>
     6d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d4:	0f b6 00             	movzbl (%eax),%eax
     6d7:	0f be c0             	movsbl %al,%eax
     6da:	83 ec 08             	sub    $0x8,%esp
     6dd:	50                   	push   %eax
     6de:	68 00 1a 00 00       	push   $0x1a00
     6e3:	e8 c7 06 00 00       	call   daf <strchr>
     6e8:	83 c4 10             	add    $0x10,%esp
     6eb:	85 c0                	test   %eax,%eax
     6ed:	75 d6                	jne    6c5 <gettoken+0x116>
    s++;
  *ps = s;
     6ef:	8b 45 08             	mov    0x8(%ebp),%eax
     6f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6f5:	89 10                	mov    %edx,(%eax)
  return ret;
     6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     6fa:	c9                   	leave  
     6fb:	c3                   	ret    

000006fc <peek>:

int
peek(char **ps, char *es, char *toks)
{
     6fc:	55                   	push   %ebp
     6fd:	89 e5                	mov    %esp,%ebp
     6ff:	83 ec 18             	sub    $0x18,%esp
  char *s;

  s = *ps;
     702:	8b 45 08             	mov    0x8(%ebp),%eax
     705:	8b 00                	mov    (%eax),%eax
     707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     70a:	eb 04                	jmp    710 <peek+0x14>
    s++;
     70c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     710:	8b 45 f4             	mov    -0xc(%ebp),%eax
     713:	3b 45 0c             	cmp    0xc(%ebp),%eax
     716:	73 1e                	jae    736 <peek+0x3a>
     718:	8b 45 f4             	mov    -0xc(%ebp),%eax
     71b:	0f b6 00             	movzbl (%eax),%eax
     71e:	0f be c0             	movsbl %al,%eax
     721:	83 ec 08             	sub    $0x8,%esp
     724:	50                   	push   %eax
     725:	68 00 1a 00 00       	push   $0x1a00
     72a:	e8 80 06 00 00       	call   daf <strchr>
     72f:	83 c4 10             	add    $0x10,%esp
     732:	85 c0                	test   %eax,%eax
     734:	75 d6                	jne    70c <peek+0x10>
    s++;
  *ps = s;
     736:	8b 45 08             	mov    0x8(%ebp),%eax
     739:	8b 55 f4             	mov    -0xc(%ebp),%edx
     73c:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     741:	0f b6 00             	movzbl (%eax),%eax
     744:	84 c0                	test   %al,%al
     746:	74 23                	je     76b <peek+0x6f>
     748:	8b 45 f4             	mov    -0xc(%ebp),%eax
     74b:	0f b6 00             	movzbl (%eax),%eax
     74e:	0f be c0             	movsbl %al,%eax
     751:	83 ec 08             	sub    $0x8,%esp
     754:	50                   	push   %eax
     755:	ff 75 10             	pushl  0x10(%ebp)
     758:	e8 52 06 00 00       	call   daf <strchr>
     75d:	83 c4 10             	add    $0x10,%esp
     760:	85 c0                	test   %eax,%eax
     762:	74 07                	je     76b <peek+0x6f>
     764:	b8 01 00 00 00       	mov    $0x1,%eax
     769:	eb 05                	jmp    770 <peek+0x74>
     76b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     770:	c9                   	leave  
     771:	c3                   	ret    

00000772 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     772:	55                   	push   %ebp
     773:	89 e5                	mov    %esp,%ebp
     775:	53                   	push   %ebx
     776:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     779:	8b 5d 08             	mov    0x8(%ebp),%ebx
     77c:	8b 45 08             	mov    0x8(%ebp),%eax
     77f:	83 ec 0c             	sub    $0xc,%esp
     782:	50                   	push   %eax
     783:	e8 e6 05 00 00       	call   d6e <strlen>
     788:	83 c4 10             	add    $0x10,%esp
     78b:	01 d8                	add    %ebx,%eax
     78d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     790:	83 ec 08             	sub    $0x8,%esp
     793:	ff 75 f4             	pushl  -0xc(%ebp)
     796:	8d 45 08             	lea    0x8(%ebp),%eax
     799:	50                   	push   %eax
     79a:	e8 61 00 00 00       	call   800 <parseline>
     79f:	83 c4 10             	add    $0x10,%esp
     7a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     7a5:	83 ec 04             	sub    $0x4,%esp
     7a8:	68 e8 14 00 00       	push   $0x14e8
     7ad:	ff 75 f4             	pushl  -0xc(%ebp)
     7b0:	8d 45 08             	lea    0x8(%ebp),%eax
     7b3:	50                   	push   %eax
     7b4:	e8 43 ff ff ff       	call   6fc <peek>
     7b9:	83 c4 10             	add    $0x10,%esp
  if(s != es) {
     7bc:	8b 45 08             	mov    0x8(%ebp),%eax
     7bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     7c2:	74 26                	je     7ea <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     7c4:	8b 45 08             	mov    0x8(%ebp),%eax
     7c7:	83 ec 04             	sub    $0x4,%esp
     7ca:	50                   	push   %eax
     7cb:	68 e9 14 00 00       	push   $0x14e9
     7d0:	6a 02                	push   $0x2
     7d2:	e8 cd 08 00 00       	call   10a4 <printf>
     7d7:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     7da:	83 ec 0c             	sub    $0xc,%esp
     7dd:	68 f8 14 00 00       	push   $0x14f8
     7e2:	e8 17 fc ff ff       	call   3fe <panic>
     7e7:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     7ea:	83 ec 0c             	sub    $0xc,%esp
     7ed:	ff 75 f0             	pushl  -0x10(%ebp)
     7f0:	e8 e9 03 00 00       	call   bde <nulterminate>
     7f5:	83 c4 10             	add    $0x10,%esp
  return cmd;
     7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     7fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7fe:	c9                   	leave  
     7ff:	c3                   	ret    

00000800 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     800:	55                   	push   %ebp
     801:	89 e5                	mov    %esp,%ebp
     803:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     806:	83 ec 08             	sub    $0x8,%esp
     809:	ff 75 0c             	pushl  0xc(%ebp)
     80c:	ff 75 08             	pushl  0x8(%ebp)
     80f:	e8 99 00 00 00       	call   8ad <parsepipe>
     814:	83 c4 10             	add    $0x10,%esp
     817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     81a:	eb 23                	jmp    83f <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     81c:	6a 00                	push   $0x0
     81e:	6a 00                	push   $0x0
     820:	ff 75 0c             	pushl  0xc(%ebp)
     823:	ff 75 08             	pushl  0x8(%ebp)
     826:	e8 84 fd ff ff       	call   5af <gettoken>
     82b:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     82e:	83 ec 0c             	sub    $0xc,%esp
     831:	ff 75 f4             	pushl  -0xc(%ebp)
     834:	e8 37 fd ff ff       	call   570 <backcmd>
     839:	83 c4 10             	add    $0x10,%esp
     83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     83f:	83 ec 04             	sub    $0x4,%esp
     842:	68 ff 14 00 00       	push   $0x14ff
     847:	ff 75 0c             	pushl  0xc(%ebp)
     84a:	ff 75 08             	pushl  0x8(%ebp)
     84d:	e8 aa fe ff ff       	call   6fc <peek>
     852:	83 c4 10             	add    $0x10,%esp
     855:	85 c0                	test   %eax,%eax
     857:	75 c3                	jne    81c <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     859:	83 ec 04             	sub    $0x4,%esp
     85c:	68 01 15 00 00       	push   $0x1501
     861:	ff 75 0c             	pushl  0xc(%ebp)
     864:	ff 75 08             	pushl  0x8(%ebp)
     867:	e8 90 fe ff ff       	call   6fc <peek>
     86c:	83 c4 10             	add    $0x10,%esp
     86f:	85 c0                	test   %eax,%eax
     871:	74 35                	je     8a8 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     873:	6a 00                	push   $0x0
     875:	6a 00                	push   $0x0
     877:	ff 75 0c             	pushl  0xc(%ebp)
     87a:	ff 75 08             	pushl  0x8(%ebp)
     87d:	e8 2d fd ff ff       	call   5af <gettoken>
     882:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     885:	83 ec 08             	sub    $0x8,%esp
     888:	ff 75 0c             	pushl  0xc(%ebp)
     88b:	ff 75 08             	pushl  0x8(%ebp)
     88e:	e8 6d ff ff ff       	call   800 <parseline>
     893:	83 c4 10             	add    $0x10,%esp
     896:	83 ec 08             	sub    $0x8,%esp
     899:	50                   	push   %eax
     89a:	ff 75 f4             	pushl  -0xc(%ebp)
     89d:	e8 86 fc ff ff       	call   528 <listcmd>
     8a2:	83 c4 10             	add    $0x10,%esp
     8a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8ab:	c9                   	leave  
     8ac:	c3                   	ret    

000008ad <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     8ad:	55                   	push   %ebp
     8ae:	89 e5                	mov    %esp,%ebp
     8b0:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     8b3:	83 ec 08             	sub    $0x8,%esp
     8b6:	ff 75 0c             	pushl  0xc(%ebp)
     8b9:	ff 75 08             	pushl  0x8(%ebp)
     8bc:	e8 ec 01 00 00       	call   aad <parseexec>
     8c1:	83 c4 10             	add    $0x10,%esp
     8c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     8c7:	83 ec 04             	sub    $0x4,%esp
     8ca:	68 03 15 00 00       	push   $0x1503
     8cf:	ff 75 0c             	pushl  0xc(%ebp)
     8d2:	ff 75 08             	pushl  0x8(%ebp)
     8d5:	e8 22 fe ff ff       	call   6fc <peek>
     8da:	83 c4 10             	add    $0x10,%esp
     8dd:	85 c0                	test   %eax,%eax
     8df:	74 35                	je     916 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     8e1:	6a 00                	push   $0x0
     8e3:	6a 00                	push   $0x0
     8e5:	ff 75 0c             	pushl  0xc(%ebp)
     8e8:	ff 75 08             	pushl  0x8(%ebp)
     8eb:	e8 bf fc ff ff       	call   5af <gettoken>
     8f0:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8f3:	83 ec 08             	sub    $0x8,%esp
     8f6:	ff 75 0c             	pushl  0xc(%ebp)
     8f9:	ff 75 08             	pushl  0x8(%ebp)
     8fc:	e8 ac ff ff ff       	call   8ad <parsepipe>
     901:	83 c4 10             	add    $0x10,%esp
     904:	83 ec 08             	sub    $0x8,%esp
     907:	50                   	push   %eax
     908:	ff 75 f4             	pushl  -0xc(%ebp)
     90b:	e8 d0 fb ff ff       	call   4e0 <pipecmd>
     910:	83 c4 10             	add    $0x10,%esp
     913:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     916:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     919:	c9                   	leave  
     91a:	c3                   	ret    

0000091b <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     91b:	55                   	push   %ebp
     91c:	89 e5                	mov    %esp,%ebp
     91e:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     921:	e9 b6 00 00 00       	jmp    9dc <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     926:	6a 00                	push   $0x0
     928:	6a 00                	push   $0x0
     92a:	ff 75 10             	pushl  0x10(%ebp)
     92d:	ff 75 0c             	pushl  0xc(%ebp)
     930:	e8 7a fc ff ff       	call   5af <gettoken>
     935:	83 c4 10             	add    $0x10,%esp
     938:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     93b:	8d 45 ec             	lea    -0x14(%ebp),%eax
     93e:	50                   	push   %eax
     93f:	8d 45 f0             	lea    -0x10(%ebp),%eax
     942:	50                   	push   %eax
     943:	ff 75 10             	pushl  0x10(%ebp)
     946:	ff 75 0c             	pushl  0xc(%ebp)
     949:	e8 61 fc ff ff       	call   5af <gettoken>
     94e:	83 c4 10             	add    $0x10,%esp
     951:	83 f8 61             	cmp    $0x61,%eax
     954:	74 10                	je     966 <parseredirs+0x4b>
      panic("missing file for redirection");
     956:	83 ec 0c             	sub    $0xc,%esp
     959:	68 05 15 00 00       	push   $0x1505
     95e:	e8 9b fa ff ff       	call   3fe <panic>
     963:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     966:	8b 45 f4             	mov    -0xc(%ebp),%eax
     969:	83 f8 3c             	cmp    $0x3c,%eax
     96c:	74 0c                	je     97a <parseredirs+0x5f>
     96e:	83 f8 3e             	cmp    $0x3e,%eax
     971:	74 26                	je     999 <parseredirs+0x7e>
     973:	83 f8 2b             	cmp    $0x2b,%eax
     976:	74 43                	je     9bb <parseredirs+0xa0>
     978:	eb 62                	jmp    9dc <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     97a:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     980:	83 ec 0c             	sub    $0xc,%esp
     983:	6a 00                	push   $0x0
     985:	6a 00                	push   $0x0
     987:	52                   	push   %edx
     988:	50                   	push   %eax
     989:	ff 75 08             	pushl  0x8(%ebp)
     98c:	e8 ec fa ff ff       	call   47d <redircmd>
     991:	83 c4 20             	add    $0x20,%esp
     994:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     997:	eb 43                	jmp    9dc <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     999:	8b 55 ec             	mov    -0x14(%ebp),%edx
     99c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     99f:	83 ec 0c             	sub    $0xc,%esp
     9a2:	6a 01                	push   $0x1
     9a4:	68 01 02 00 00       	push   $0x201
     9a9:	52                   	push   %edx
     9aa:	50                   	push   %eax
     9ab:	ff 75 08             	pushl  0x8(%ebp)
     9ae:	e8 ca fa ff ff       	call   47d <redircmd>
     9b3:	83 c4 20             	add    $0x20,%esp
     9b6:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9b9:	eb 21                	jmp    9dc <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9be:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9c1:	83 ec 0c             	sub    $0xc,%esp
     9c4:	6a 01                	push   $0x1
     9c6:	68 01 02 00 00       	push   $0x201
     9cb:	52                   	push   %edx
     9cc:	50                   	push   %eax
     9cd:	ff 75 08             	pushl  0x8(%ebp)
     9d0:	e8 a8 fa ff ff       	call   47d <redircmd>
     9d5:	83 c4 20             	add    $0x20,%esp
     9d8:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9db:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9dc:	83 ec 04             	sub    $0x4,%esp
     9df:	68 22 15 00 00       	push   $0x1522
     9e4:	ff 75 10             	pushl  0x10(%ebp)
     9e7:	ff 75 0c             	pushl  0xc(%ebp)
     9ea:	e8 0d fd ff ff       	call   6fc <peek>
     9ef:	83 c4 10             	add    $0x10,%esp
     9f2:	85 c0                	test   %eax,%eax
     9f4:	0f 85 2c ff ff ff    	jne    926 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fd:	c9                   	leave  
     9fe:	c3                   	ret    

000009ff <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9ff:	55                   	push   %ebp
     a00:	89 e5                	mov    %esp,%ebp
     a02:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a05:	83 ec 04             	sub    $0x4,%esp
     a08:	68 25 15 00 00       	push   $0x1525
     a0d:	ff 75 0c             	pushl  0xc(%ebp)
     a10:	ff 75 08             	pushl  0x8(%ebp)
     a13:	e8 e4 fc ff ff       	call   6fc <peek>
     a18:	83 c4 10             	add    $0x10,%esp
     a1b:	85 c0                	test   %eax,%eax
     a1d:	75 10                	jne    a2f <parseblock+0x30>
    panic("parseblock");
     a1f:	83 ec 0c             	sub    $0xc,%esp
     a22:	68 27 15 00 00       	push   $0x1527
     a27:	e8 d2 f9 ff ff       	call   3fe <panic>
     a2c:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a2f:	6a 00                	push   $0x0
     a31:	6a 00                	push   $0x0
     a33:	ff 75 0c             	pushl  0xc(%ebp)
     a36:	ff 75 08             	pushl  0x8(%ebp)
     a39:	e8 71 fb ff ff       	call   5af <gettoken>
     a3e:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     a41:	83 ec 08             	sub    $0x8,%esp
     a44:	ff 75 0c             	pushl  0xc(%ebp)
     a47:	ff 75 08             	pushl  0x8(%ebp)
     a4a:	e8 b1 fd ff ff       	call   800 <parseline>
     a4f:	83 c4 10             	add    $0x10,%esp
     a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a55:	83 ec 04             	sub    $0x4,%esp
     a58:	68 32 15 00 00       	push   $0x1532
     a5d:	ff 75 0c             	pushl  0xc(%ebp)
     a60:	ff 75 08             	pushl  0x8(%ebp)
     a63:	e8 94 fc ff ff       	call   6fc <peek>
     a68:	83 c4 10             	add    $0x10,%esp
     a6b:	85 c0                	test   %eax,%eax
     a6d:	75 10                	jne    a7f <parseblock+0x80>
    panic("syntax - missing )");
     a6f:	83 ec 0c             	sub    $0xc,%esp
     a72:	68 34 15 00 00       	push   $0x1534
     a77:	e8 82 f9 ff ff       	call   3fe <panic>
     a7c:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a7f:	6a 00                	push   $0x0
     a81:	6a 00                	push   $0x0
     a83:	ff 75 0c             	pushl  0xc(%ebp)
     a86:	ff 75 08             	pushl  0x8(%ebp)
     a89:	e8 21 fb ff ff       	call   5af <gettoken>
     a8e:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a91:	83 ec 04             	sub    $0x4,%esp
     a94:	ff 75 0c             	pushl  0xc(%ebp)
     a97:	ff 75 08             	pushl  0x8(%ebp)
     a9a:	ff 75 f4             	pushl  -0xc(%ebp)
     a9d:	e8 79 fe ff ff       	call   91b <parseredirs>
     aa2:	83 c4 10             	add    $0x10,%esp
     aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     aab:	c9                   	leave  
     aac:	c3                   	ret    

00000aad <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     aad:	55                   	push   %ebp
     aae:	89 e5                	mov    %esp,%ebp
     ab0:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     ab3:	83 ec 04             	sub    $0x4,%esp
     ab6:	68 25 15 00 00       	push   $0x1525
     abb:	ff 75 0c             	pushl  0xc(%ebp)
     abe:	ff 75 08             	pushl  0x8(%ebp)
     ac1:	e8 36 fc ff ff       	call   6fc <peek>
     ac6:	83 c4 10             	add    $0x10,%esp
     ac9:	85 c0                	test   %eax,%eax
     acb:	74 16                	je     ae3 <parseexec+0x36>
    return parseblock(ps, es);
     acd:	83 ec 08             	sub    $0x8,%esp
     ad0:	ff 75 0c             	pushl  0xc(%ebp)
     ad3:	ff 75 08             	pushl  0x8(%ebp)
     ad6:	e8 24 ff ff ff       	call   9ff <parseblock>
     adb:	83 c4 10             	add    $0x10,%esp
     ade:	e9 f9 00 00 00       	jmp    bdc <parseexec+0x12f>

  ret = execcmd();
     ae3:	e8 5f f9 ff ff       	call   447 <execcmd>
     ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aee:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     af1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     af8:	83 ec 04             	sub    $0x4,%esp
     afb:	ff 75 0c             	pushl  0xc(%ebp)
     afe:	ff 75 08             	pushl  0x8(%ebp)
     b01:	ff 75 f0             	pushl  -0x10(%ebp)
     b04:	e8 12 fe ff ff       	call   91b <parseredirs>
     b09:	83 c4 10             	add    $0x10,%esp
     b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b0f:	e9 88 00 00 00       	jmp    b9c <parseexec+0xef>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b14:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b17:	50                   	push   %eax
     b18:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b1b:	50                   	push   %eax
     b1c:	ff 75 0c             	pushl  0xc(%ebp)
     b1f:	ff 75 08             	pushl  0x8(%ebp)
     b22:	e8 88 fa ff ff       	call   5af <gettoken>
     b27:	83 c4 10             	add    $0x10,%esp
     b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b31:	75 05                	jne    b38 <parseexec+0x8b>
      break;
     b33:	e9 82 00 00 00       	jmp    bba <parseexec+0x10d>
    if(tok != 'a')
     b38:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b3c:	74 10                	je     b4e <parseexec+0xa1>
      panic("syntax");
     b3e:	83 ec 0c             	sub    $0xc,%esp
     b41:	68 f8 14 00 00       	push   $0x14f8
     b46:	e8 b3 f8 ff ff       	call   3fe <panic>
     b4b:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     b4e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b57:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b61:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b64:	83 c1 08             	add    $0x8,%ecx
     b67:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     b6f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b73:	7e 10                	jle    b85 <parseexec+0xd8>
      panic("too many args");
     b75:	83 ec 0c             	sub    $0xc,%esp
     b78:	68 47 15 00 00       	push   $0x1547
     b7d:	e8 7c f8 ff ff       	call   3fe <panic>
     b82:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b85:	83 ec 04             	sub    $0x4,%esp
     b88:	ff 75 0c             	pushl  0xc(%ebp)
     b8b:	ff 75 08             	pushl  0x8(%ebp)
     b8e:	ff 75 f0             	pushl  -0x10(%ebp)
     b91:	e8 85 fd ff ff       	call   91b <parseredirs>
     b96:	83 c4 10             	add    $0x10,%esp
     b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     b9c:	83 ec 04             	sub    $0x4,%esp
     b9f:	68 55 15 00 00       	push   $0x1555
     ba4:	ff 75 0c             	pushl  0xc(%ebp)
     ba7:	ff 75 08             	pushl  0x8(%ebp)
     baa:	e8 4d fb ff ff       	call   6fc <peek>
     baf:	83 c4 10             	add    $0x10,%esp
     bb2:	85 c0                	test   %eax,%eax
     bb4:	0f 84 5a ff ff ff    	je     b14 <parseexec+0x67>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bc0:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     bc7:	00 
  cmd->eargv[argc] = 0;
     bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bce:	83 c2 08             	add    $0x8,%edx
     bd1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     bd8:	00 
  return ret;
     bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     bdc:	c9                   	leave  
     bdd:	c3                   	ret    

00000bde <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     bde:	55                   	push   %ebp
     bdf:	89 e5                	mov    %esp,%ebp
     be1:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     be8:	75 0a                	jne    bf4 <nulterminate+0x16>
    return 0;
     bea:	b8 00 00 00 00       	mov    $0x0,%eax
     bef:	e9 e4 00 00 00       	jmp    cd8 <nulterminate+0xfa>

  switch(cmd->type){
     bf4:	8b 45 08             	mov    0x8(%ebp),%eax
     bf7:	8b 00                	mov    (%eax),%eax
     bf9:	83 f8 05             	cmp    $0x5,%eax
     bfc:	0f 87 d3 00 00 00    	ja     cd5 <nulterminate+0xf7>
     c02:	8b 04 85 5c 15 00 00 	mov    0x155c(,%eax,4),%eax
     c09:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c0b:	8b 45 08             	mov    0x8(%ebp),%eax
     c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c18:	eb 14                	jmp    c2e <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c20:	83 c2 08             	add    $0x8,%edx
     c23:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c27:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c34:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c38:	85 c0                	test   %eax,%eax
     c3a:	75 de                	jne    c1a <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c3c:	e9 94 00 00 00       	jmp    cd5 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c41:	8b 45 08             	mov    0x8(%ebp),%eax
     c44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c4a:	8b 40 04             	mov    0x4(%eax),%eax
     c4d:	83 ec 0c             	sub    $0xc,%esp
     c50:	50                   	push   %eax
     c51:	e8 88 ff ff ff       	call   bde <nulterminate>
     c56:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c5c:	8b 40 0c             	mov    0xc(%eax),%eax
     c5f:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c62:	eb 71                	jmp    cd5 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c6d:	8b 40 04             	mov    0x4(%eax),%eax
     c70:	83 ec 0c             	sub    $0xc,%esp
     c73:	50                   	push   %eax
     c74:	e8 65 ff ff ff       	call   bde <nulterminate>
     c79:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c7f:	8b 40 08             	mov    0x8(%eax),%eax
     c82:	83 ec 0c             	sub    $0xc,%esp
     c85:	50                   	push   %eax
     c86:	e8 53 ff ff ff       	call   bde <nulterminate>
     c8b:	83 c4 10             	add    $0x10,%esp
    break;
     c8e:	eb 45                	jmp    cd5 <nulterminate+0xf7>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     c90:	8b 45 08             	mov    0x8(%ebp),%eax
     c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c99:	8b 40 04             	mov    0x4(%eax),%eax
     c9c:	83 ec 0c             	sub    $0xc,%esp
     c9f:	50                   	push   %eax
     ca0:	e8 39 ff ff ff       	call   bde <nulterminate>
     ca5:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cab:	8b 40 08             	mov    0x8(%eax),%eax
     cae:	83 ec 0c             	sub    $0xc,%esp
     cb1:	50                   	push   %eax
     cb2:	e8 27 ff ff ff       	call   bde <nulterminate>
     cb7:	83 c4 10             	add    $0x10,%esp
    break;
     cba:	eb 19                	jmp    cd5 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cbc:	8b 45 08             	mov    0x8(%ebp),%eax
     cbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
     cc5:	8b 40 04             	mov    0x4(%eax),%eax
     cc8:	83 ec 0c             	sub    $0xc,%esp
     ccb:	50                   	push   %eax
     ccc:	e8 0d ff ff ff       	call   bde <nulterminate>
     cd1:	83 c4 10             	add    $0x10,%esp
    break;
     cd4:	90                   	nop
  }
  return cmd;
     cd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cd8:	c9                   	leave  
     cd9:	c3                   	ret    

00000cda <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cda:	55                   	push   %ebp
     cdb:	89 e5                	mov    %esp,%ebp
     cdd:	57                   	push   %edi
     cde:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ce2:	8b 55 10             	mov    0x10(%ebp),%edx
     ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
     ce8:	89 cb                	mov    %ecx,%ebx
     cea:	89 df                	mov    %ebx,%edi
     cec:	89 d1                	mov    %edx,%ecx
     cee:	fc                   	cld    
     cef:	f3 aa                	rep stos %al,%es:(%edi)
     cf1:	89 ca                	mov    %ecx,%edx
     cf3:	89 fb                	mov    %edi,%ebx
     cf5:	89 5d 08             	mov    %ebx,0x8(%ebp)
     cf8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     cfb:	5b                   	pop    %ebx
     cfc:	5f                   	pop    %edi
     cfd:	5d                   	pop    %ebp
     cfe:	c3                   	ret    

00000cff <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     cff:	55                   	push   %ebp
     d00:	89 e5                	mov    %esp,%ebp
     d02:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d05:	8b 45 08             	mov    0x8(%ebp),%eax
     d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d0b:	90                   	nop
     d0c:	8b 45 08             	mov    0x8(%ebp),%eax
     d0f:	8d 50 01             	lea    0x1(%eax),%edx
     d12:	89 55 08             	mov    %edx,0x8(%ebp)
     d15:	8b 55 0c             	mov    0xc(%ebp),%edx
     d18:	8d 4a 01             	lea    0x1(%edx),%ecx
     d1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     d1e:	0f b6 12             	movzbl (%edx),%edx
     d21:	88 10                	mov    %dl,(%eax)
     d23:	0f b6 00             	movzbl (%eax),%eax
     d26:	84 c0                	test   %al,%al
     d28:	75 e2                	jne    d0c <strcpy+0xd>
    ;
  return os;
     d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d2d:	c9                   	leave  
     d2e:	c3                   	ret    

00000d2f <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d2f:	55                   	push   %ebp
     d30:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d32:	eb 08                	jmp    d3c <strcmp+0xd>
    p++, q++;
     d34:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d38:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d3c:	8b 45 08             	mov    0x8(%ebp),%eax
     d3f:	0f b6 00             	movzbl (%eax),%eax
     d42:	84 c0                	test   %al,%al
     d44:	74 10                	je     d56 <strcmp+0x27>
     d46:	8b 45 08             	mov    0x8(%ebp),%eax
     d49:	0f b6 10             	movzbl (%eax),%edx
     d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d4f:	0f b6 00             	movzbl (%eax),%eax
     d52:	38 c2                	cmp    %al,%dl
     d54:	74 de                	je     d34 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d56:	8b 45 08             	mov    0x8(%ebp),%eax
     d59:	0f b6 00             	movzbl (%eax),%eax
     d5c:	0f b6 d0             	movzbl %al,%edx
     d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
     d62:	0f b6 00             	movzbl (%eax),%eax
     d65:	0f b6 c0             	movzbl %al,%eax
     d68:	29 c2                	sub    %eax,%edx
     d6a:	89 d0                	mov    %edx,%eax
}
     d6c:	5d                   	pop    %ebp
     d6d:	c3                   	ret    

00000d6e <strlen>:

uint
strlen(char *s)
{
     d6e:	55                   	push   %ebp
     d6f:	89 e5                	mov    %esp,%ebp
     d71:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d7b:	eb 04                	jmp    d81 <strlen+0x13>
     d7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d81:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d84:	8b 45 08             	mov    0x8(%ebp),%eax
     d87:	01 d0                	add    %edx,%eax
     d89:	0f b6 00             	movzbl (%eax),%eax
     d8c:	84 c0                	test   %al,%al
     d8e:	75 ed                	jne    d7d <strlen+0xf>
    ;
  return n;
     d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d93:	c9                   	leave  
     d94:	c3                   	ret    

00000d95 <memset>:

void*
memset(void *dst, int c, uint n)
{
     d95:	55                   	push   %ebp
     d96:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d98:	8b 45 10             	mov    0x10(%ebp),%eax
     d9b:	50                   	push   %eax
     d9c:	ff 75 0c             	pushl  0xc(%ebp)
     d9f:	ff 75 08             	pushl  0x8(%ebp)
     da2:	e8 33 ff ff ff       	call   cda <stosb>
     da7:	83 c4 0c             	add    $0xc,%esp
  return dst;
     daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dad:	c9                   	leave  
     dae:	c3                   	ret    

00000daf <strchr>:

char*
strchr(const char *s, char c)
{
     daf:	55                   	push   %ebp
     db0:	89 e5                	mov    %esp,%ebp
     db2:	83 ec 04             	sub    $0x4,%esp
     db5:	8b 45 0c             	mov    0xc(%ebp),%eax
     db8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     dbb:	eb 14                	jmp    dd1 <strchr+0x22>
    if(*s == c)
     dbd:	8b 45 08             	mov    0x8(%ebp),%eax
     dc0:	0f b6 00             	movzbl (%eax),%eax
     dc3:	3a 45 fc             	cmp    -0x4(%ebp),%al
     dc6:	75 05                	jne    dcd <strchr+0x1e>
      return (char*)s;
     dc8:	8b 45 08             	mov    0x8(%ebp),%eax
     dcb:	eb 13                	jmp    de0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     dcd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     dd1:	8b 45 08             	mov    0x8(%ebp),%eax
     dd4:	0f b6 00             	movzbl (%eax),%eax
     dd7:	84 c0                	test   %al,%al
     dd9:	75 e2                	jne    dbd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     de0:	c9                   	leave  
     de1:	c3                   	ret    

00000de2 <gets>:

char*
gets(char *buf, int max)
{
     de2:	55                   	push   %ebp
     de3:	89 e5                	mov    %esp,%ebp
     de5:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     def:	eb 44                	jmp    e35 <gets+0x53>
    cc = read(0, &c, 1);
     df1:	83 ec 04             	sub    $0x4,%esp
     df4:	6a 01                	push   $0x1
     df6:	8d 45 ef             	lea    -0x11(%ebp),%eax
     df9:	50                   	push   %eax
     dfa:	6a 00                	push   $0x0
     dfc:	e8 46 01 00 00       	call   f47 <read>
     e01:	83 c4 10             	add    $0x10,%esp
     e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e0b:	7f 02                	jg     e0f <gets+0x2d>
      break;
     e0d:	eb 31                	jmp    e40 <gets+0x5e>
    buf[i++] = c;
     e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e12:	8d 50 01             	lea    0x1(%eax),%edx
     e15:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e18:	89 c2                	mov    %eax,%edx
     e1a:	8b 45 08             	mov    0x8(%ebp),%eax
     e1d:	01 c2                	add    %eax,%edx
     e1f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e23:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e25:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e29:	3c 0a                	cmp    $0xa,%al
     e2b:	74 13                	je     e40 <gets+0x5e>
     e2d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e31:	3c 0d                	cmp    $0xd,%al
     e33:	74 0b                	je     e40 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e38:	83 c0 01             	add    $0x1,%eax
     e3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e3e:	7c b1                	jl     df1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e43:	8b 45 08             	mov    0x8(%ebp),%eax
     e46:	01 d0                	add    %edx,%eax
     e48:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e4e:	c9                   	leave  
     e4f:	c3                   	ret    

00000e50 <stat>:

int
stat(char *n, struct stat *st)
{
     e50:	55                   	push   %ebp
     e51:	89 e5                	mov    %esp,%ebp
     e53:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e56:	83 ec 08             	sub    $0x8,%esp
     e59:	6a 00                	push   $0x0
     e5b:	ff 75 08             	pushl  0x8(%ebp)
     e5e:	e8 0c 01 00 00       	call   f6f <open>
     e63:	83 c4 10             	add    $0x10,%esp
     e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e6d:	79 07                	jns    e76 <stat+0x26>
    return -1;
     e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e74:	eb 25                	jmp    e9b <stat+0x4b>
  r = fstat(fd, st);
     e76:	83 ec 08             	sub    $0x8,%esp
     e79:	ff 75 0c             	pushl  0xc(%ebp)
     e7c:	ff 75 f4             	pushl  -0xc(%ebp)
     e7f:	e8 03 01 00 00       	call   f87 <fstat>
     e84:	83 c4 10             	add    $0x10,%esp
     e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e8a:	83 ec 0c             	sub    $0xc,%esp
     e8d:	ff 75 f4             	pushl  -0xc(%ebp)
     e90:	e8 c2 00 00 00       	call   f57 <close>
     e95:	83 c4 10             	add    $0x10,%esp
  return r;
     e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e9b:	c9                   	leave  
     e9c:	c3                   	ret    

00000e9d <atoi>:

int
atoi(const char *s)
{
     e9d:	55                   	push   %ebp
     e9e:	89 e5                	mov    %esp,%ebp
     ea0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ea3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     eaa:	eb 25                	jmp    ed1 <atoi+0x34>
    n = n*10 + *s++ - '0';
     eac:	8b 55 fc             	mov    -0x4(%ebp),%edx
     eaf:	89 d0                	mov    %edx,%eax
     eb1:	c1 e0 02             	shl    $0x2,%eax
     eb4:	01 d0                	add    %edx,%eax
     eb6:	01 c0                	add    %eax,%eax
     eb8:	89 c1                	mov    %eax,%ecx
     eba:	8b 45 08             	mov    0x8(%ebp),%eax
     ebd:	8d 50 01             	lea    0x1(%eax),%edx
     ec0:	89 55 08             	mov    %edx,0x8(%ebp)
     ec3:	0f b6 00             	movzbl (%eax),%eax
     ec6:	0f be c0             	movsbl %al,%eax
     ec9:	01 c8                	add    %ecx,%eax
     ecb:	83 e8 30             	sub    $0x30,%eax
     ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ed1:	8b 45 08             	mov    0x8(%ebp),%eax
     ed4:	0f b6 00             	movzbl (%eax),%eax
     ed7:	3c 2f                	cmp    $0x2f,%al
     ed9:	7e 0a                	jle    ee5 <atoi+0x48>
     edb:	8b 45 08             	mov    0x8(%ebp),%eax
     ede:	0f b6 00             	movzbl (%eax),%eax
     ee1:	3c 39                	cmp    $0x39,%al
     ee3:	7e c7                	jle    eac <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ee8:	c9                   	leave  
     ee9:	c3                   	ret    

00000eea <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     eea:	55                   	push   %ebp
     eeb:	89 e5                	mov    %esp,%ebp
     eed:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     ef0:	8b 45 08             	mov    0x8(%ebp),%eax
     ef3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ef9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     efc:	eb 17                	jmp    f15 <memmove+0x2b>
    *dst++ = *src++;
     efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f01:	8d 50 01             	lea    0x1(%eax),%edx
     f04:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f07:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f0a:	8d 4a 01             	lea    0x1(%edx),%ecx
     f0d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f10:	0f b6 12             	movzbl (%edx),%edx
     f13:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f15:	8b 45 10             	mov    0x10(%ebp),%eax
     f18:	8d 50 ff             	lea    -0x1(%eax),%edx
     f1b:	89 55 10             	mov    %edx,0x10(%ebp)
     f1e:	85 c0                	test   %eax,%eax
     f20:	7f dc                	jg     efe <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f22:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f25:	c9                   	leave  
     f26:	c3                   	ret    

00000f27 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f27:	b8 01 00 00 00       	mov    $0x1,%eax
     f2c:	cd 40                	int    $0x40
     f2e:	c3                   	ret    

00000f2f <exit>:
SYSCALL(exit)
     f2f:	b8 02 00 00 00       	mov    $0x2,%eax
     f34:	cd 40                	int    $0x40
     f36:	c3                   	ret    

00000f37 <wait>:
SYSCALL(wait)
     f37:	b8 03 00 00 00       	mov    $0x3,%eax
     f3c:	cd 40                	int    $0x40
     f3e:	c3                   	ret    

00000f3f <pipe>:
SYSCALL(pipe)
     f3f:	b8 04 00 00 00       	mov    $0x4,%eax
     f44:	cd 40                	int    $0x40
     f46:	c3                   	ret    

00000f47 <read>:
SYSCALL(read)
     f47:	b8 05 00 00 00       	mov    $0x5,%eax
     f4c:	cd 40                	int    $0x40
     f4e:	c3                   	ret    

00000f4f <write>:
SYSCALL(write)
     f4f:	b8 10 00 00 00       	mov    $0x10,%eax
     f54:	cd 40                	int    $0x40
     f56:	c3                   	ret    

00000f57 <close>:
SYSCALL(close)
     f57:	b8 15 00 00 00       	mov    $0x15,%eax
     f5c:	cd 40                	int    $0x40
     f5e:	c3                   	ret    

00000f5f <kill>:
SYSCALL(kill)
     f5f:	b8 06 00 00 00       	mov    $0x6,%eax
     f64:	cd 40                	int    $0x40
     f66:	c3                   	ret    

00000f67 <exec>:
SYSCALL(exec)
     f67:	b8 07 00 00 00       	mov    $0x7,%eax
     f6c:	cd 40                	int    $0x40
     f6e:	c3                   	ret    

00000f6f <open>:
SYSCALL(open)
     f6f:	b8 0f 00 00 00       	mov    $0xf,%eax
     f74:	cd 40                	int    $0x40
     f76:	c3                   	ret    

00000f77 <mknod>:
SYSCALL(mknod)
     f77:	b8 11 00 00 00       	mov    $0x11,%eax
     f7c:	cd 40                	int    $0x40
     f7e:	c3                   	ret    

00000f7f <unlink>:
SYSCALL(unlink)
     f7f:	b8 12 00 00 00       	mov    $0x12,%eax
     f84:	cd 40                	int    $0x40
     f86:	c3                   	ret    

00000f87 <fstat>:
SYSCALL(fstat)
     f87:	b8 08 00 00 00       	mov    $0x8,%eax
     f8c:	cd 40                	int    $0x40
     f8e:	c3                   	ret    

00000f8f <link>:
SYSCALL(link)
     f8f:	b8 13 00 00 00       	mov    $0x13,%eax
     f94:	cd 40                	int    $0x40
     f96:	c3                   	ret    

00000f97 <mkdir>:
SYSCALL(mkdir)
     f97:	b8 14 00 00 00       	mov    $0x14,%eax
     f9c:	cd 40                	int    $0x40
     f9e:	c3                   	ret    

00000f9f <chdir>:
SYSCALL(chdir)
     f9f:	b8 09 00 00 00       	mov    $0x9,%eax
     fa4:	cd 40                	int    $0x40
     fa6:	c3                   	ret    

00000fa7 <dup>:
SYSCALL(dup)
     fa7:	b8 0a 00 00 00       	mov    $0xa,%eax
     fac:	cd 40                	int    $0x40
     fae:	c3                   	ret    

00000faf <getpid>:
SYSCALL(getpid)
     faf:	b8 0b 00 00 00       	mov    $0xb,%eax
     fb4:	cd 40                	int    $0x40
     fb6:	c3                   	ret    

00000fb7 <sbrk>:
SYSCALL(sbrk)
     fb7:	b8 0c 00 00 00       	mov    $0xc,%eax
     fbc:	cd 40                	int    $0x40
     fbe:	c3                   	ret    

00000fbf <sleep>:
SYSCALL(sleep)
     fbf:	b8 0d 00 00 00       	mov    $0xd,%eax
     fc4:	cd 40                	int    $0x40
     fc6:	c3                   	ret    

00000fc7 <uptime>:
SYSCALL(uptime)
     fc7:	b8 0e 00 00 00       	mov    $0xe,%eax
     fcc:	cd 40                	int    $0x40
     fce:	c3                   	ret    

00000fcf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     fcf:	55                   	push   %ebp
     fd0:	89 e5                	mov    %esp,%ebp
     fd2:	83 ec 18             	sub    $0x18,%esp
     fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     fd8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     fdb:	83 ec 04             	sub    $0x4,%esp
     fde:	6a 01                	push   $0x1
     fe0:	8d 45 f4             	lea    -0xc(%ebp),%eax
     fe3:	50                   	push   %eax
     fe4:	ff 75 08             	pushl  0x8(%ebp)
     fe7:	e8 63 ff ff ff       	call   f4f <write>
     fec:	83 c4 10             	add    $0x10,%esp
}
     fef:	c9                   	leave  
     ff0:	c3                   	ret    

00000ff1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ff1:	55                   	push   %ebp
     ff2:	89 e5                	mov    %esp,%ebp
     ff4:	53                   	push   %ebx
     ff5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     ff8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     fff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1003:	74 17                	je     101c <printint+0x2b>
    1005:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1009:	79 11                	jns    101c <printint+0x2b>
    neg = 1;
    100b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1012:	8b 45 0c             	mov    0xc(%ebp),%eax
    1015:	f7 d8                	neg    %eax
    1017:	89 45 ec             	mov    %eax,-0x14(%ebp)
    101a:	eb 06                	jmp    1022 <printint+0x31>
  } else {
    x = xx;
    101c:	8b 45 0c             	mov    0xc(%ebp),%eax
    101f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1029:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    102c:	8d 41 01             	lea    0x1(%ecx),%eax
    102f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1032:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1035:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1038:	ba 00 00 00 00       	mov    $0x0,%edx
    103d:	f7 f3                	div    %ebx
    103f:	89 d0                	mov    %edx,%eax
    1041:	0f b6 80 0e 1a 00 00 	movzbl 0x1a0e(%eax),%eax
    1048:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    104c:	8b 5d 10             	mov    0x10(%ebp),%ebx
    104f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1052:	ba 00 00 00 00       	mov    $0x0,%edx
    1057:	f7 f3                	div    %ebx
    1059:	89 45 ec             	mov    %eax,-0x14(%ebp)
    105c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1060:	75 c7                	jne    1029 <printint+0x38>
  if(neg)
    1062:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1066:	74 0e                	je     1076 <printint+0x85>
    buf[i++] = '-';
    1068:	8b 45 f4             	mov    -0xc(%ebp),%eax
    106b:	8d 50 01             	lea    0x1(%eax),%edx
    106e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1071:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1076:	eb 1d                	jmp    1095 <printint+0xa4>
    putc(fd, buf[i]);
    1078:	8d 55 dc             	lea    -0x24(%ebp),%edx
    107b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107e:	01 d0                	add    %edx,%eax
    1080:	0f b6 00             	movzbl (%eax),%eax
    1083:	0f be c0             	movsbl %al,%eax
    1086:	83 ec 08             	sub    $0x8,%esp
    1089:	50                   	push   %eax
    108a:	ff 75 08             	pushl  0x8(%ebp)
    108d:	e8 3d ff ff ff       	call   fcf <putc>
    1092:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1095:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    109d:	79 d9                	jns    1078 <printint+0x87>
    putc(fd, buf[i]);
}
    109f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10a2:	c9                   	leave  
    10a3:	c3                   	ret    

000010a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10a4:	55                   	push   %ebp
    10a5:	89 e5                	mov    %esp,%ebp
    10a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10b1:	8d 45 0c             	lea    0xc(%ebp),%eax
    10b4:	83 c0 04             	add    $0x4,%eax
    10b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10c1:	e9 59 01 00 00       	jmp    121f <printf+0x17b>
    c = fmt[i] & 0xff;
    10c6:	8b 55 0c             	mov    0xc(%ebp),%edx
    10c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10cc:	01 d0                	add    %edx,%eax
    10ce:	0f b6 00             	movzbl (%eax),%eax
    10d1:	0f be c0             	movsbl %al,%eax
    10d4:	25 ff 00 00 00       	and    $0xff,%eax
    10d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    10dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10e0:	75 2c                	jne    110e <printf+0x6a>
      if(c == '%'){
    10e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10e6:	75 0c                	jne    10f4 <printf+0x50>
        state = '%';
    10e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    10ef:	e9 27 01 00 00       	jmp    121b <printf+0x177>
      } else {
        putc(fd, c);
    10f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10f7:	0f be c0             	movsbl %al,%eax
    10fa:	83 ec 08             	sub    $0x8,%esp
    10fd:	50                   	push   %eax
    10fe:	ff 75 08             	pushl  0x8(%ebp)
    1101:	e8 c9 fe ff ff       	call   fcf <putc>
    1106:	83 c4 10             	add    $0x10,%esp
    1109:	e9 0d 01 00 00       	jmp    121b <printf+0x177>
      }
    } else if(state == '%'){
    110e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1112:	0f 85 03 01 00 00    	jne    121b <printf+0x177>
      if(c == 'd'){
    1118:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    111c:	75 1e                	jne    113c <printf+0x98>
        printint(fd, *ap, 10, 1);
    111e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1121:	8b 00                	mov    (%eax),%eax
    1123:	6a 01                	push   $0x1
    1125:	6a 0a                	push   $0xa
    1127:	50                   	push   %eax
    1128:	ff 75 08             	pushl  0x8(%ebp)
    112b:	e8 c1 fe ff ff       	call   ff1 <printint>
    1130:	83 c4 10             	add    $0x10,%esp
        ap++;
    1133:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1137:	e9 d8 00 00 00       	jmp    1214 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    113c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1140:	74 06                	je     1148 <printf+0xa4>
    1142:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1146:	75 1e                	jne    1166 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1148:	8b 45 e8             	mov    -0x18(%ebp),%eax
    114b:	8b 00                	mov    (%eax),%eax
    114d:	6a 00                	push   $0x0
    114f:	6a 10                	push   $0x10
    1151:	50                   	push   %eax
    1152:	ff 75 08             	pushl  0x8(%ebp)
    1155:	e8 97 fe ff ff       	call   ff1 <printint>
    115a:	83 c4 10             	add    $0x10,%esp
        ap++;
    115d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1161:	e9 ae 00 00 00       	jmp    1214 <printf+0x170>
      } else if(c == 's'){
    1166:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    116a:	75 43                	jne    11af <printf+0x10b>
        s = (char*)*ap;
    116c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    116f:	8b 00                	mov    (%eax),%eax
    1171:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1174:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    117c:	75 07                	jne    1185 <printf+0xe1>
          s = "(null)";
    117e:	c7 45 f4 74 15 00 00 	movl   $0x1574,-0xc(%ebp)
        while(*s != 0){
    1185:	eb 1c                	jmp    11a3 <printf+0xff>
          putc(fd, *s);
    1187:	8b 45 f4             	mov    -0xc(%ebp),%eax
    118a:	0f b6 00             	movzbl (%eax),%eax
    118d:	0f be c0             	movsbl %al,%eax
    1190:	83 ec 08             	sub    $0x8,%esp
    1193:	50                   	push   %eax
    1194:	ff 75 08             	pushl  0x8(%ebp)
    1197:	e8 33 fe ff ff       	call   fcf <putc>
    119c:	83 c4 10             	add    $0x10,%esp
          s++;
    119f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    11a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a6:	0f b6 00             	movzbl (%eax),%eax
    11a9:	84 c0                	test   %al,%al
    11ab:	75 da                	jne    1187 <printf+0xe3>
    11ad:	eb 65                	jmp    1214 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    11af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    11b3:	75 1d                	jne    11d2 <printf+0x12e>
        putc(fd, *ap);
    11b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11b8:	8b 00                	mov    (%eax),%eax
    11ba:	0f be c0             	movsbl %al,%eax
    11bd:	83 ec 08             	sub    $0x8,%esp
    11c0:	50                   	push   %eax
    11c1:	ff 75 08             	pushl  0x8(%ebp)
    11c4:	e8 06 fe ff ff       	call   fcf <putc>
    11c9:	83 c4 10             	add    $0x10,%esp
        ap++;
    11cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11d0:	eb 42                	jmp    1214 <printf+0x170>
      } else if(c == '%'){
    11d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11d6:	75 17                	jne    11ef <printf+0x14b>
        putc(fd, c);
    11d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11db:	0f be c0             	movsbl %al,%eax
    11de:	83 ec 08             	sub    $0x8,%esp
    11e1:	50                   	push   %eax
    11e2:	ff 75 08             	pushl  0x8(%ebp)
    11e5:	e8 e5 fd ff ff       	call   fcf <putc>
    11ea:	83 c4 10             	add    $0x10,%esp
    11ed:	eb 25                	jmp    1214 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    11ef:	83 ec 08             	sub    $0x8,%esp
    11f2:	6a 25                	push   $0x25
    11f4:	ff 75 08             	pushl  0x8(%ebp)
    11f7:	e8 d3 fd ff ff       	call   fcf <putc>
    11fc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    11ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1202:	0f be c0             	movsbl %al,%eax
    1205:	83 ec 08             	sub    $0x8,%esp
    1208:	50                   	push   %eax
    1209:	ff 75 08             	pushl  0x8(%ebp)
    120c:	e8 be fd ff ff       	call   fcf <putc>
    1211:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1214:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    121b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    121f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1222:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1225:	01 d0                	add    %edx,%eax
    1227:	0f b6 00             	movzbl (%eax),%eax
    122a:	84 c0                	test   %al,%al
    122c:	0f 85 94 fe ff ff    	jne    10c6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1232:	c9                   	leave  
    1233:	c3                   	ret    

00001234 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    123a:	8b 45 08             	mov    0x8(%ebp),%eax
    123d:	83 e8 08             	sub    $0x8,%eax
    1240:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1243:	a1 ac 1a 00 00       	mov    0x1aac,%eax
    1248:	89 45 fc             	mov    %eax,-0x4(%ebp)
    124b:	eb 24                	jmp    1271 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    124d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1250:	8b 00                	mov    (%eax),%eax
    1252:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1255:	77 12                	ja     1269 <free+0x35>
    1257:	8b 45 f8             	mov    -0x8(%ebp),%eax
    125a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    125d:	77 24                	ja     1283 <free+0x4f>
    125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1262:	8b 00                	mov    (%eax),%eax
    1264:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1267:	77 1a                	ja     1283 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1269:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126c:	8b 00                	mov    (%eax),%eax
    126e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1271:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1274:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1277:	76 d4                	jbe    124d <free+0x19>
    1279:	8b 45 fc             	mov    -0x4(%ebp),%eax
    127c:	8b 00                	mov    (%eax),%eax
    127e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1281:	76 ca                	jbe    124d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1283:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1286:	8b 40 04             	mov    0x4(%eax),%eax
    1289:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1290:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1293:	01 c2                	add    %eax,%edx
    1295:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1298:	8b 00                	mov    (%eax),%eax
    129a:	39 c2                	cmp    %eax,%edx
    129c:	75 24                	jne    12c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12a1:	8b 50 04             	mov    0x4(%eax),%edx
    12a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a7:	8b 00                	mov    (%eax),%eax
    12a9:	8b 40 04             	mov    0x4(%eax),%eax
    12ac:	01 c2                	add    %eax,%edx
    12ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    12b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b7:	8b 00                	mov    (%eax),%eax
    12b9:	8b 10                	mov    (%eax),%edx
    12bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12be:	89 10                	mov    %edx,(%eax)
    12c0:	eb 0a                	jmp    12cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    12c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c5:	8b 10                	mov    (%eax),%edx
    12c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    12cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12cf:	8b 40 04             	mov    0x4(%eax),%eax
    12d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12dc:	01 d0                	add    %edx,%eax
    12de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12e1:	75 20                	jne    1303 <free+0xcf>
    p->s.size += bp->s.size;
    12e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e6:	8b 50 04             	mov    0x4(%eax),%edx
    12e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ec:	8b 40 04             	mov    0x4(%eax),%eax
    12ef:	01 c2                	add    %eax,%edx
    12f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    12f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12fa:	8b 10                	mov    (%eax),%edx
    12fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ff:	89 10                	mov    %edx,(%eax)
    1301:	eb 08                	jmp    130b <free+0xd7>
  } else
    p->s.ptr = bp;
    1303:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1306:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1309:	89 10                	mov    %edx,(%eax)
  freep = p;
    130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130e:	a3 ac 1a 00 00       	mov    %eax,0x1aac
}
    1313:	c9                   	leave  
    1314:	c3                   	ret    

00001315 <morecore>:

static Header*
morecore(uint nu)
{
    1315:	55                   	push   %ebp
    1316:	89 e5                	mov    %esp,%ebp
    1318:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    131b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1322:	77 07                	ja     132b <morecore+0x16>
    nu = 4096;
    1324:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    132b:	8b 45 08             	mov    0x8(%ebp),%eax
    132e:	c1 e0 03             	shl    $0x3,%eax
    1331:	83 ec 0c             	sub    $0xc,%esp
    1334:	50                   	push   %eax
    1335:	e8 7d fc ff ff       	call   fb7 <sbrk>
    133a:	83 c4 10             	add    $0x10,%esp
    133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1340:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1344:	75 07                	jne    134d <morecore+0x38>
    return 0;
    1346:	b8 00 00 00 00       	mov    $0x0,%eax
    134b:	eb 26                	jmp    1373 <morecore+0x5e>
  hp = (Header*)p;
    134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1350:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1353:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1356:	8b 55 08             	mov    0x8(%ebp),%edx
    1359:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    135c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    135f:	83 c0 08             	add    $0x8,%eax
    1362:	83 ec 0c             	sub    $0xc,%esp
    1365:	50                   	push   %eax
    1366:	e8 c9 fe ff ff       	call   1234 <free>
    136b:	83 c4 10             	add    $0x10,%esp
  return freep;
    136e:	a1 ac 1a 00 00       	mov    0x1aac,%eax
}
    1373:	c9                   	leave  
    1374:	c3                   	ret    

00001375 <malloc>:

void*
malloc(uint nbytes)
{
    1375:	55                   	push   %ebp
    1376:	89 e5                	mov    %esp,%ebp
    1378:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    137b:	8b 45 08             	mov    0x8(%ebp),%eax
    137e:	83 c0 07             	add    $0x7,%eax
    1381:	c1 e8 03             	shr    $0x3,%eax
    1384:	83 c0 01             	add    $0x1,%eax
    1387:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    138a:	a1 ac 1a 00 00       	mov    0x1aac,%eax
    138f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1392:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1396:	75 23                	jne    13bb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1398:	c7 45 f0 a4 1a 00 00 	movl   $0x1aa4,-0x10(%ebp)
    139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13a2:	a3 ac 1a 00 00       	mov    %eax,0x1aac
    13a7:	a1 ac 1a 00 00       	mov    0x1aac,%eax
    13ac:	a3 a4 1a 00 00       	mov    %eax,0x1aa4
    base.s.size = 0;
    13b1:	c7 05 a8 1a 00 00 00 	movl   $0x0,0x1aa8
    13b8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13be:	8b 00                	mov    (%eax),%eax
    13c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    13c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c6:	8b 40 04             	mov    0x4(%eax),%eax
    13c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    13cc:	72 4d                	jb     141b <malloc+0xa6>
      if(p->s.size == nunits)
    13ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d1:	8b 40 04             	mov    0x4(%eax),%eax
    13d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    13d7:	75 0c                	jne    13e5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    13d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13dc:	8b 10                	mov    (%eax),%edx
    13de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13e1:	89 10                	mov    %edx,(%eax)
    13e3:	eb 26                	jmp    140b <malloc+0x96>
      else {
        p->s.size -= nunits;
    13e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13e8:	8b 40 04             	mov    0x4(%eax),%eax
    13eb:	2b 45 ec             	sub    -0x14(%ebp),%eax
    13ee:	89 c2                	mov    %eax,%edx
    13f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    13f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f9:	8b 40 04             	mov    0x4(%eax),%eax
    13fc:	c1 e0 03             	shl    $0x3,%eax
    13ff:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1402:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1405:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1408:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    140e:	a3 ac 1a 00 00       	mov    %eax,0x1aac
      return (void*)(p + 1);
    1413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1416:	83 c0 08             	add    $0x8,%eax
    1419:	eb 3b                	jmp    1456 <malloc+0xe1>
    }
    if(p == freep)
    141b:	a1 ac 1a 00 00       	mov    0x1aac,%eax
    1420:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1423:	75 1e                	jne    1443 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1425:	83 ec 0c             	sub    $0xc,%esp
    1428:	ff 75 ec             	pushl  -0x14(%ebp)
    142b:	e8 e5 fe ff ff       	call   1315 <morecore>
    1430:	83 c4 10             	add    $0x10,%esp
    1433:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    143a:	75 07                	jne    1443 <malloc+0xce>
        return 0;
    143c:	b8 00 00 00 00       	mov    $0x0,%eax
    1441:	eb 13                	jmp    1456 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1443:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1446:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1449:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144c:	8b 00                	mov    (%eax),%eax
    144e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1451:	e9 6d ff ff ff       	jmp    13c3 <malloc+0x4e>
}
    1456:	c9                   	leave  
    1457:	c3                   	ret    
