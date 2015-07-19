
_clear:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int i;

  for(i = 1; i < 50; i++)
  11:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  18:	eb 1b                	jmp    35 <main+0x35>
    printf(1, "\n", "\n");
  1a:	83 ec 04             	sub    $0x4,%esp
  1d:	68 be 07 00 00       	push   $0x7be
  22:	68 be 07 00 00       	push   $0x7be
  27:	6a 01                	push   $0x1
  29:	e8 dc 03 00 00       	call   40a <printf>
  2e:	83 c4 10             	add    $0x10,%esp

int
main(int argc, char *argv[]) {
  int i;

  for(i = 1; i < 50; i++)
  31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  35:	83 7d f4 31          	cmpl   $0x31,-0xc(%ebp)
  39:	7e df                	jle    1a <main+0x1a>
    printf(1, "\n", "\n");
  
  exit();
  3b:	e8 55 02 00 00       	call   295 <exit>

00000040 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	57                   	push   %edi
  44:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  48:	8b 55 10             	mov    0x10(%ebp),%edx
  4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  4e:	89 cb                	mov    %ecx,%ebx
  50:	89 df                	mov    %ebx,%edi
  52:	89 d1                	mov    %edx,%ecx
  54:	fc                   	cld    
  55:	f3 aa                	rep stos %al,%es:(%edi)
  57:	89 ca                	mov    %ecx,%edx
  59:	89 fb                	mov    %edi,%ebx
  5b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  5e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  61:	5b                   	pop    %ebx
  62:	5f                   	pop    %edi
  63:	5d                   	pop    %ebp
  64:	c3                   	ret    

00000065 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  71:	90                   	nop
  72:	8b 45 08             	mov    0x8(%ebp),%eax
  75:	8d 50 01             	lea    0x1(%eax),%edx
  78:	89 55 08             	mov    %edx,0x8(%ebp)
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  84:	0f b6 12             	movzbl (%edx),%edx
  87:	88 10                	mov    %dl,(%eax)
  89:	0f b6 00             	movzbl (%eax),%eax
  8c:	84 c0                	test   %al,%al
  8e:	75 e2                	jne    72 <strcpy+0xd>
    ;
  return os;
  90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  93:	c9                   	leave  
  94:	c3                   	ret    

00000095 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  98:	eb 08                	jmp    a2 <strcmp+0xd>
    p++, q++;
  9a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  9e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a2:	8b 45 08             	mov    0x8(%ebp),%eax
  a5:	0f b6 00             	movzbl (%eax),%eax
  a8:	84 c0                	test   %al,%al
  aa:	74 10                	je     bc <strcmp+0x27>
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	0f b6 10             	movzbl (%eax),%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	38 c2                	cmp    %al,%dl
  ba:	74 de                	je     9a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	0f b6 00             	movzbl (%eax),%eax
  c2:	0f b6 d0             	movzbl %al,%edx
  c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  c8:	0f b6 00             	movzbl (%eax),%eax
  cb:	0f b6 c0             	movzbl %al,%eax
  ce:	29 c2                	sub    %eax,%edx
  d0:	89 d0                	mov    %edx,%eax
}
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    

000000d4 <strlen>:

uint
strlen(char *s)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e1:	eb 04                	jmp    e7 <strlen+0x13>
  e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	01 d0                	add    %edx,%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	84 c0                	test   %al,%al
  f4:	75 ed                	jne    e3 <strlen+0xf>
    ;
  return n;
  f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <memset>:

void*
memset(void *dst, int c, uint n)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  fe:	8b 45 10             	mov    0x10(%ebp),%eax
 101:	50                   	push   %eax
 102:	ff 75 0c             	pushl  0xc(%ebp)
 105:	ff 75 08             	pushl  0x8(%ebp)
 108:	e8 33 ff ff ff       	call   40 <stosb>
 10d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 110:	8b 45 08             	mov    0x8(%ebp),%eax
}
 113:	c9                   	leave  
 114:	c3                   	ret    

00000115 <strchr>:

char*
strchr(const char *s, char c)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	83 ec 04             	sub    $0x4,%esp
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 121:	eb 14                	jmp    137 <strchr+0x22>
    if(*s == c)
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	3a 45 fc             	cmp    -0x4(%ebp),%al
 12c:	75 05                	jne    133 <strchr+0x1e>
      return (char*)s;
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	eb 13                	jmp    146 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 133:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 00             	movzbl (%eax),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 e2                	jne    123 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 141:	b8 00 00 00 00       	mov    $0x0,%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <gets>:

char*
gets(char *buf, int max)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 155:	eb 44                	jmp    19b <gets+0x53>
    cc = read(0, &c, 1);
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	6a 01                	push   $0x1
 15c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 15f:	50                   	push   %eax
 160:	6a 00                	push   $0x0
 162:	e8 46 01 00 00       	call   2ad <read>
 167:	83 c4 10             	add    $0x10,%esp
 16a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 16d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 171:	7f 02                	jg     175 <gets+0x2d>
      break;
 173:	eb 31                	jmp    1a6 <gets+0x5e>
    buf[i++] = c;
 175:	8b 45 f4             	mov    -0xc(%ebp),%eax
 178:	8d 50 01             	lea    0x1(%eax),%edx
 17b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 17e:	89 c2                	mov    %eax,%edx
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	01 c2                	add    %eax,%edx
 185:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 189:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 18b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18f:	3c 0a                	cmp    $0xa,%al
 191:	74 13                	je     1a6 <gets+0x5e>
 193:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 197:	3c 0d                	cmp    $0xd,%al
 199:	74 0b                	je     1a6 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19e:	83 c0 01             	add    $0x1,%eax
 1a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a4:	7c b1                	jl     157 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <stat>:

int
stat(char *n, struct stat *st)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	6a 00                	push   $0x0
 1c1:	ff 75 08             	pushl  0x8(%ebp)
 1c4:	e8 0c 01 00 00       	call   2d5 <open>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d3:	79 07                	jns    1dc <stat+0x26>
    return -1;
 1d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1da:	eb 25                	jmp    201 <stat+0x4b>
  r = fstat(fd, st);
 1dc:	83 ec 08             	sub    $0x8,%esp
 1df:	ff 75 0c             	pushl  0xc(%ebp)
 1e2:	ff 75 f4             	pushl  -0xc(%ebp)
 1e5:	e8 03 01 00 00       	call   2ed <fstat>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f0:	83 ec 0c             	sub    $0xc,%esp
 1f3:	ff 75 f4             	pushl  -0xc(%ebp)
 1f6:	e8 c2 00 00 00       	call   2bd <close>
 1fb:	83 c4 10             	add    $0x10,%esp
  return r;
 1fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 201:	c9                   	leave  
 202:	c3                   	ret    

00000203 <atoi>:

int
atoi(const char *s)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 210:	eb 25                	jmp    237 <atoi+0x34>
    n = n*10 + *s++ - '0';
 212:	8b 55 fc             	mov    -0x4(%ebp),%edx
 215:	89 d0                	mov    %edx,%eax
 217:	c1 e0 02             	shl    $0x2,%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	01 c0                	add    %eax,%eax
 21e:	89 c1                	mov    %eax,%ecx
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	8d 50 01             	lea    0x1(%eax),%edx
 226:	89 55 08             	mov    %edx,0x8(%ebp)
 229:	0f b6 00             	movzbl (%eax),%eax
 22c:	0f be c0             	movsbl %al,%eax
 22f:	01 c8                	add    %ecx,%eax
 231:	83 e8 30             	sub    $0x30,%eax
 234:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 2f                	cmp    $0x2f,%al
 23f:	7e 0a                	jle    24b <atoi+0x48>
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	3c 39                	cmp    $0x39,%al
 249:	7e c7                	jle    212 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 24b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 25c:	8b 45 0c             	mov    0xc(%ebp),%eax
 25f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 262:	eb 17                	jmp    27b <memmove+0x2b>
    *dst++ = *src++;
 264:	8b 45 fc             	mov    -0x4(%ebp),%eax
 267:	8d 50 01             	lea    0x1(%eax),%edx
 26a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 26d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 270:	8d 4a 01             	lea    0x1(%edx),%ecx
 273:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 276:	0f b6 12             	movzbl (%edx),%edx
 279:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27b:	8b 45 10             	mov    0x10(%ebp),%eax
 27e:	8d 50 ff             	lea    -0x1(%eax),%edx
 281:	89 55 10             	mov    %edx,0x10(%ebp)
 284:	85 c0                	test   %eax,%eax
 286:	7f dc                	jg     264 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28d:	b8 01 00 00 00       	mov    $0x1,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <exit>:
SYSCALL(exit)
 295:	b8 02 00 00 00       	mov    $0x2,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <wait>:
SYSCALL(wait)
 29d:	b8 03 00 00 00       	mov    $0x3,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <pipe>:
SYSCALL(pipe)
 2a5:	b8 04 00 00 00       	mov    $0x4,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <read>:
SYSCALL(read)
 2ad:	b8 05 00 00 00       	mov    $0x5,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <write>:
SYSCALL(write)
 2b5:	b8 10 00 00 00       	mov    $0x10,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <close>:
SYSCALL(close)
 2bd:	b8 15 00 00 00       	mov    $0x15,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <kill>:
SYSCALL(kill)
 2c5:	b8 06 00 00 00       	mov    $0x6,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <exec>:
SYSCALL(exec)
 2cd:	b8 07 00 00 00       	mov    $0x7,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <open>:
SYSCALL(open)
 2d5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <mknod>:
SYSCALL(mknod)
 2dd:	b8 11 00 00 00       	mov    $0x11,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <unlink>:
SYSCALL(unlink)
 2e5:	b8 12 00 00 00       	mov    $0x12,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <fstat>:
SYSCALL(fstat)
 2ed:	b8 08 00 00 00       	mov    $0x8,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <link>:
SYSCALL(link)
 2f5:	b8 13 00 00 00       	mov    $0x13,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <mkdir>:
SYSCALL(mkdir)
 2fd:	b8 14 00 00 00       	mov    $0x14,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <chdir>:
SYSCALL(chdir)
 305:	b8 09 00 00 00       	mov    $0x9,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <dup>:
SYSCALL(dup)
 30d:	b8 0a 00 00 00       	mov    $0xa,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <getpid>:
SYSCALL(getpid)
 315:	b8 0b 00 00 00       	mov    $0xb,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <sbrk>:
SYSCALL(sbrk)
 31d:	b8 0c 00 00 00       	mov    $0xc,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <sleep>:
SYSCALL(sleep)
 325:	b8 0d 00 00 00       	mov    $0xd,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <uptime>:
SYSCALL(uptime)
 32d:	b8 0e 00 00 00       	mov    $0xe,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
 33b:	8b 45 0c             	mov    0xc(%ebp),%eax
 33e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 341:	83 ec 04             	sub    $0x4,%esp
 344:	6a 01                	push   $0x1
 346:	8d 45 f4             	lea    -0xc(%ebp),%eax
 349:	50                   	push   %eax
 34a:	ff 75 08             	pushl  0x8(%ebp)
 34d:	e8 63 ff ff ff       	call   2b5 <write>
 352:	83 c4 10             	add    $0x10,%esp
}
 355:	c9                   	leave  
 356:	c3                   	ret    

00000357 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	53                   	push   %ebx
 35b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 365:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 369:	74 17                	je     382 <printint+0x2b>
 36b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36f:	79 11                	jns    382 <printint+0x2b>
    neg = 1;
 371:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	f7 d8                	neg    %eax
 37d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 380:	eb 06                	jmp    388 <printint+0x31>
  } else {
    x = xx;
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 392:	8d 41 01             	lea    0x1(%ecx),%eax
 395:	89 45 f4             	mov    %eax,-0xc(%ebp)
 398:	8b 5d 10             	mov    0x10(%ebp),%ebx
 39b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39e:	ba 00 00 00 00       	mov    $0x0,%edx
 3a3:	f7 f3                	div    %ebx
 3a5:	89 d0                	mov    %edx,%eax
 3a7:	0f b6 80 10 0a 00 00 	movzbl 0xa10(%eax),%eax
 3ae:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b8:	ba 00 00 00 00       	mov    $0x0,%edx
 3bd:	f7 f3                	div    %ebx
 3bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c6:	75 c7                	jne    38f <printint+0x38>
  if(neg)
 3c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cc:	74 0e                	je     3dc <printint+0x85>
    buf[i++] = '-';
 3ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d1:	8d 50 01             	lea    0x1(%eax),%edx
 3d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3dc:	eb 1d                	jmp    3fb <printint+0xa4>
    putc(fd, buf[i]);
 3de:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	0f be c0             	movsbl %al,%eax
 3ec:	83 ec 08             	sub    $0x8,%esp
 3ef:	50                   	push   %eax
 3f0:	ff 75 08             	pushl  0x8(%ebp)
 3f3:	e8 3d ff ff ff       	call   335 <putc>
 3f8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3fb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 403:	79 d9                	jns    3de <printint+0x87>
    putc(fd, buf[i]);
}
 405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 410:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 417:	8d 45 0c             	lea    0xc(%ebp),%eax
 41a:	83 c0 04             	add    $0x4,%eax
 41d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 427:	e9 59 01 00 00       	jmp    585 <printf+0x17b>
    c = fmt[i] & 0xff;
 42c:	8b 55 0c             	mov    0xc(%ebp),%edx
 42f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 432:	01 d0                	add    %edx,%eax
 434:	0f b6 00             	movzbl (%eax),%eax
 437:	0f be c0             	movsbl %al,%eax
 43a:	25 ff 00 00 00       	and    $0xff,%eax
 43f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 442:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 446:	75 2c                	jne    474 <printf+0x6a>
      if(c == '%'){
 448:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 44c:	75 0c                	jne    45a <printf+0x50>
        state = '%';
 44e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 455:	e9 27 01 00 00       	jmp    581 <printf+0x177>
      } else {
        putc(fd, c);
 45a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	83 ec 08             	sub    $0x8,%esp
 463:	50                   	push   %eax
 464:	ff 75 08             	pushl  0x8(%ebp)
 467:	e8 c9 fe ff ff       	call   335 <putc>
 46c:	83 c4 10             	add    $0x10,%esp
 46f:	e9 0d 01 00 00       	jmp    581 <printf+0x177>
      }
    } else if(state == '%'){
 474:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 478:	0f 85 03 01 00 00    	jne    581 <printf+0x177>
      if(c == 'd'){
 47e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 482:	75 1e                	jne    4a2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 484:	8b 45 e8             	mov    -0x18(%ebp),%eax
 487:	8b 00                	mov    (%eax),%eax
 489:	6a 01                	push   $0x1
 48b:	6a 0a                	push   $0xa
 48d:	50                   	push   %eax
 48e:	ff 75 08             	pushl  0x8(%ebp)
 491:	e8 c1 fe ff ff       	call   357 <printint>
 496:	83 c4 10             	add    $0x10,%esp
        ap++;
 499:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 49d:	e9 d8 00 00 00       	jmp    57a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4a2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4a6:	74 06                	je     4ae <printf+0xa4>
 4a8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ac:	75 1e                	jne    4cc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b1:	8b 00                	mov    (%eax),%eax
 4b3:	6a 00                	push   $0x0
 4b5:	6a 10                	push   $0x10
 4b7:	50                   	push   %eax
 4b8:	ff 75 08             	pushl  0x8(%ebp)
 4bb:	e8 97 fe ff ff       	call   357 <printint>
 4c0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c7:	e9 ae 00 00 00       	jmp    57a <printf+0x170>
      } else if(c == 's'){
 4cc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d0:	75 43                	jne    515 <printf+0x10b>
        s = (char*)*ap;
 4d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d5:	8b 00                	mov    (%eax),%eax
 4d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e2:	75 07                	jne    4eb <printf+0xe1>
          s = "(null)";
 4e4:	c7 45 f4 c0 07 00 00 	movl   $0x7c0,-0xc(%ebp)
        while(*s != 0){
 4eb:	eb 1c                	jmp    509 <printf+0xff>
          putc(fd, *s);
 4ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f0:	0f b6 00             	movzbl (%eax),%eax
 4f3:	0f be c0             	movsbl %al,%eax
 4f6:	83 ec 08             	sub    $0x8,%esp
 4f9:	50                   	push   %eax
 4fa:	ff 75 08             	pushl  0x8(%ebp)
 4fd:	e8 33 fe ff ff       	call   335 <putc>
 502:	83 c4 10             	add    $0x10,%esp
          s++;
 505:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 509:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50c:	0f b6 00             	movzbl (%eax),%eax
 50f:	84 c0                	test   %al,%al
 511:	75 da                	jne    4ed <printf+0xe3>
 513:	eb 65                	jmp    57a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 515:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 519:	75 1d                	jne    538 <printf+0x12e>
        putc(fd, *ap);
 51b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	0f be c0             	movsbl %al,%eax
 523:	83 ec 08             	sub    $0x8,%esp
 526:	50                   	push   %eax
 527:	ff 75 08             	pushl  0x8(%ebp)
 52a:	e8 06 fe ff ff       	call   335 <putc>
 52f:	83 c4 10             	add    $0x10,%esp
        ap++;
 532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 536:	eb 42                	jmp    57a <printf+0x170>
      } else if(c == '%'){
 538:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53c:	75 17                	jne    555 <printf+0x14b>
        putc(fd, c);
 53e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	83 ec 08             	sub    $0x8,%esp
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 e5 fd ff ff       	call   335 <putc>
 550:	83 c4 10             	add    $0x10,%esp
 553:	eb 25                	jmp    57a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 555:	83 ec 08             	sub    $0x8,%esp
 558:	6a 25                	push   $0x25
 55a:	ff 75 08             	pushl  0x8(%ebp)
 55d:	e8 d3 fd ff ff       	call   335 <putc>
 562:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	83 ec 08             	sub    $0x8,%esp
 56e:	50                   	push   %eax
 56f:	ff 75 08             	pushl  0x8(%ebp)
 572:	e8 be fd ff ff       	call   335 <putc>
 577:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 57a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 581:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 585:	8b 55 0c             	mov    0xc(%ebp),%edx
 588:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58b:	01 d0                	add    %edx,%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	84 c0                	test   %al,%al
 592:	0f 85 94 fe ff ff    	jne    42c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 598:	c9                   	leave  
 599:	c3                   	ret    

0000059a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 59a:	55                   	push   %ebp
 59b:	89 e5                	mov    %esp,%ebp
 59d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	83 e8 08             	sub    $0x8,%eax
 5a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a9:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 5ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b1:	eb 24                	jmp    5d7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5bb:	77 12                	ja     5cf <free+0x35>
 5bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c3:	77 24                	ja     5e9 <free+0x4f>
 5c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c8:	8b 00                	mov    (%eax),%eax
 5ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5cd:	77 1a                	ja     5e9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d2:	8b 00                	mov    (%eax),%eax
 5d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5dd:	76 d4                	jbe    5b3 <free+0x19>
 5df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e7:	76 ca                	jbe    5b3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ec:	8b 40 04             	mov    0x4(%eax),%eax
 5ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f9:	01 c2                	add    %eax,%edx
 5fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	39 c2                	cmp    %eax,%edx
 602:	75 24                	jne    628 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 604:	8b 45 f8             	mov    -0x8(%ebp),%eax
 607:	8b 50 04             	mov    0x4(%eax),%edx
 60a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	8b 40 04             	mov    0x4(%eax),%eax
 612:	01 c2                	add    %eax,%edx
 614:	8b 45 f8             	mov    -0x8(%ebp),%eax
 617:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	8b 10                	mov    (%eax),%edx
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	89 10                	mov    %edx,(%eax)
 626:	eb 0a                	jmp    632 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 10                	mov    (%eax),%edx
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 40 04             	mov    0x4(%eax),%eax
 638:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	01 d0                	add    %edx,%eax
 644:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 647:	75 20                	jne    669 <free+0xcf>
    p->s.size += bp->s.size;
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 50 04             	mov    0x4(%eax),%edx
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	8b 40 04             	mov    0x4(%eax),%eax
 655:	01 c2                	add    %eax,%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	8b 10                	mov    (%eax),%edx
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	89 10                	mov    %edx,(%eax)
 667:	eb 08                	jmp    671 <free+0xd7>
  } else
    p->s.ptr = bp;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66f:	89 10                	mov    %edx,(%eax)
  freep = p;
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	a3 2c 0a 00 00       	mov    %eax,0xa2c
}
 679:	c9                   	leave  
 67a:	c3                   	ret    

0000067b <morecore>:

static Header*
morecore(uint nu)
{
 67b:	55                   	push   %ebp
 67c:	89 e5                	mov    %esp,%ebp
 67e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 681:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 688:	77 07                	ja     691 <morecore+0x16>
    nu = 4096;
 68a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	c1 e0 03             	shl    $0x3,%eax
 697:	83 ec 0c             	sub    $0xc,%esp
 69a:	50                   	push   %eax
 69b:	e8 7d fc ff ff       	call   31d <sbrk>
 6a0:	83 c4 10             	add    $0x10,%esp
 6a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6a6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6aa:	75 07                	jne    6b3 <morecore+0x38>
    return 0;
 6ac:	b8 00 00 00 00       	mov    $0x0,%eax
 6b1:	eb 26                	jmp    6d9 <morecore+0x5e>
  hp = (Header*)p;
 6b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bc:	8b 55 08             	mov    0x8(%ebp),%edx
 6bf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c5:	83 c0 08             	add    $0x8,%eax
 6c8:	83 ec 0c             	sub    $0xc,%esp
 6cb:	50                   	push   %eax
 6cc:	e8 c9 fe ff ff       	call   59a <free>
 6d1:	83 c4 10             	add    $0x10,%esp
  return freep;
 6d4:	a1 2c 0a 00 00       	mov    0xa2c,%eax
}
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <malloc>:

void*
malloc(uint nbytes)
{
 6db:	55                   	push   %ebp
 6dc:	89 e5                	mov    %esp,%ebp
 6de:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	83 c0 07             	add    $0x7,%eax
 6e7:	c1 e8 03             	shr    $0x3,%eax
 6ea:	83 c0 01             	add    $0x1,%eax
 6ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6f0:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 6f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fc:	75 23                	jne    721 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6fe:	c7 45 f0 24 0a 00 00 	movl   $0xa24,-0x10(%ebp)
 705:	8b 45 f0             	mov    -0x10(%ebp),%eax
 708:	a3 2c 0a 00 00       	mov    %eax,0xa2c
 70d:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 712:	a3 24 0a 00 00       	mov    %eax,0xa24
    base.s.size = 0;
 717:	c7 05 28 0a 00 00 00 	movl   $0x0,0xa28
 71e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 732:	72 4d                	jb     781 <malloc+0xa6>
      if(p->s.size == nunits)
 734:	8b 45 f4             	mov    -0xc(%ebp),%eax
 737:	8b 40 04             	mov    0x4(%eax),%eax
 73a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73d:	75 0c                	jne    74b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 73f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 742:	8b 10                	mov    (%eax),%edx
 744:	8b 45 f0             	mov    -0x10(%ebp),%eax
 747:	89 10                	mov    %edx,(%eax)
 749:	eb 26                	jmp    771 <malloc+0x96>
      else {
        p->s.size -= nunits;
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	2b 45 ec             	sub    -0x14(%ebp),%eax
 754:	89 c2                	mov    %eax,%edx
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	c1 e0 03             	shl    $0x3,%eax
 765:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 76e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	a3 2c 0a 00 00       	mov    %eax,0xa2c
      return (void*)(p + 1);
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	83 c0 08             	add    $0x8,%eax
 77f:	eb 3b                	jmp    7bc <malloc+0xe1>
    }
    if(p == freep)
 781:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 786:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 789:	75 1e                	jne    7a9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 78b:	83 ec 0c             	sub    $0xc,%esp
 78e:	ff 75 ec             	pushl  -0x14(%ebp)
 791:	e8 e5 fe ff ff       	call   67b <morecore>
 796:	83 c4 10             	add    $0x10,%esp
 799:	89 45 f4             	mov    %eax,-0xc(%ebp)
 79c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a0:	75 07                	jne    7a9 <malloc+0xce>
        return 0;
 7a2:	b8 00 00 00 00       	mov    $0x0,%eax
 7a7:	eb 13                	jmp    7bc <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7b7:	e9 6d ff ff ff       	jmp    729 <malloc+0x4e>
}
 7bc:	c9                   	leave  
 7bd:	c3                   	ret    
