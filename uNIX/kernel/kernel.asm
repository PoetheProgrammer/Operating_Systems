
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 ed 37 10 80       	mov    $0x801037ed,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 44 84 10 80       	push   $0x80108444
80100042:	68 80 c6 10 80       	push   $0x8010c680
80100047:	e8 ca 4e 00 00       	call   80104f16 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 05 11 80 84 	movl   $0x80110584,0x80110590
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 05 11 80 84 	movl   $0x80110584,0x80110594
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 05 11 80       	mov    0x80110594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 05 11 80       	mov    %eax,0x80110594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 80 c6 10 80       	push   $0x8010c680
801000bf:	e8 73 4e 00 00       	call   80104f37 <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 94 05 11 80       	mov    0x80110594,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 80 c6 10 80       	push   $0x8010c680
8010010a:	e8 8e 4e 00 00       	call   80104f9d <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 c6 10 80       	push   $0x8010c680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 1d 4b 00 00       	call   80104c47 <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 90 05 11 80       	mov    0x80110590,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 80 c6 10 80       	push   $0x8010c680
80100186:	e8 12 4e 00 00       	call   80104f9d <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 4b 84 10 80       	push   $0x8010844b
801001ad:	e8 aa 03 00 00       	call   8010055c <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 98 26 00 00       	call   8010287d <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 5c 84 10 80       	push   $0x8010845c
80100207:	e8 50 03 00 00       	call   8010055c <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 57 26 00 00       	call   8010287d <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 63 84 10 80       	push   $0x80108463
80100245:	e8 12 03 00 00       	call   8010055c <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 c6 10 80       	push   $0x8010c680
80100252:	e8 e0 4c 00 00       	call   80104f37 <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 94 05 11 80    	mov    0x80110594,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 94 05 11 80       	mov    0x80110594,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 94 05 11 80       	mov    %eax,0x80110594

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 75 4a 00 00       	call   80104d30 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 c6 10 80       	push   $0x8010c680
801002c6:	e8 d2 4c 00 00       	call   80104f9d <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e1:	89 c2                	mov    %eax,%edx
801002e3:	ec                   	in     (%dx),%al
801002e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002eb:	c9                   	leave  
801002ec:	c3                   	ret    

801002ed <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002ed:	55                   	push   %ebp
801002ee:	89 e5                	mov    %esp,%ebp
801002f0:	83 ec 08             	sub    $0x8,%esp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
801002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002f9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002fd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100300:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100304:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100308:	ee                   	out    %al,(%dx)
}
80100309:	c9                   	leave  
8010030a:	c3                   	ret    

8010030b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030b:	55                   	push   %ebp
8010030c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010030e:	fa                   	cli    
}
8010030f:	5d                   	pop    %ebp
80100310:	c3                   	ret    

80100311 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100311:	55                   	push   %ebp
80100312:	89 e5                	mov    %esp,%ebp
80100314:	53                   	push   %ebx
80100315:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031c:	74 1c                	je     8010033a <printint+0x29>
8010031e:	8b 45 08             	mov    0x8(%ebp),%eax
80100321:	c1 e8 1f             	shr    $0x1f,%eax
80100324:	0f b6 c0             	movzbl %al,%eax
80100327:	89 45 10             	mov    %eax,0x10(%ebp)
8010032a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010032e:	74 0a                	je     8010033a <printint+0x29>
    x = -xx;
80100330:	8b 45 08             	mov    0x8(%ebp),%eax
80100333:	f7 d8                	neg    %eax
80100335:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100338:	eb 06                	jmp    80100340 <printint+0x2f>
  else
    x = xx;
8010033a:	8b 45 08             	mov    0x8(%ebp),%eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100347:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034a:	8d 41 01             	lea    0x1(%ecx),%eax
8010034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f3                	div    %ebx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100366:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100370:	ba 00 00 00 00       	mov    $0x0,%edx
80100375:	f7 f3                	div    %ebx
80100377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010037e:	75 c7                	jne    80100347 <printint+0x36>

  if(sign)
80100380:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100384:	74 0e                	je     80100394 <printint+0x83>
    buf[i++] = '-';
80100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100389:	8d 50 01             	lea    0x1(%eax),%edx
8010038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010038f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100394:	eb 1a                	jmp    801003b0 <printint+0x9f>
    consputc(buf[i]);
80100396:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010039c:	01 d0                	add    %edx,%eax
8010039e:	0f b6 00             	movzbl (%eax),%eax
801003a1:	0f be c0             	movsbl %al,%eax
801003a4:	83 ec 0c             	sub    $0xc,%esp
801003a7:	50                   	push   %eax
801003a8:	e8 be 03 00 00       	call   8010076b <consputc>
801003ad:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 dc                	jns    80100396 <printint+0x85>
    consputc(buf[i]);
}
801003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003bd:	c9                   	leave  
801003be:	c3                   	ret    

801003bf <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003bf:	55                   	push   %ebp
801003c0:	89 e5                	mov    %esp,%ebp
801003c2:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c5:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d1:	74 10                	je     801003e3 <cprintf+0x24>
    acquire(&cons.lock);
801003d3:	83 ec 0c             	sub    $0xc,%esp
801003d6:	68 e0 b5 10 80       	push   $0x8010b5e0
801003db:	e8 57 4b 00 00       	call   80104f37 <acquire>
801003e0:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e3:	8b 45 08             	mov    0x8(%ebp),%eax
801003e6:	85 c0                	test   %eax,%eax
801003e8:	75 0d                	jne    801003f7 <cprintf+0x38>
    panic("null fmt");
801003ea:	83 ec 0c             	sub    $0xc,%esp
801003ed:	68 6a 84 10 80       	push   $0x8010846a
801003f2:	e8 65 01 00 00       	call   8010055c <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f7:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100404:	e9 1b 01 00 00       	jmp    80100524 <cprintf+0x165>
    if(c != '%'){
80100409:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040d:	74 13                	je     80100422 <cprintf+0x63>
      consputc(c);
8010040f:	83 ec 0c             	sub    $0xc,%esp
80100412:	ff 75 e4             	pushl  -0x1c(%ebp)
80100415:	e8 51 03 00 00       	call   8010076b <consputc>
8010041a:	83 c4 10             	add    $0x10,%esp
      continue;
8010041d:	e9 fe 00 00 00       	jmp    80100520 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100422:	8b 55 08             	mov    0x8(%ebp),%edx
80100425:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042c:	01 d0                	add    %edx,%eax
8010042e:	0f b6 00             	movzbl (%eax),%eax
80100431:	0f be c0             	movsbl %al,%eax
80100434:	25 ff 00 00 00       	and    $0xff,%eax
80100439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100440:	75 05                	jne    80100447 <cprintf+0x88>
      break;
80100442:	e9 fd 00 00 00       	jmp    80100544 <cprintf+0x185>
    switch(c){
80100447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044a:	83 f8 70             	cmp    $0x70,%eax
8010044d:	74 47                	je     80100496 <cprintf+0xd7>
8010044f:	83 f8 70             	cmp    $0x70,%eax
80100452:	7f 13                	jg     80100467 <cprintf+0xa8>
80100454:	83 f8 25             	cmp    $0x25,%eax
80100457:	0f 84 98 00 00 00    	je     801004f5 <cprintf+0x136>
8010045d:	83 f8 64             	cmp    $0x64,%eax
80100460:	74 14                	je     80100476 <cprintf+0xb7>
80100462:	e9 9d 00 00 00       	jmp    80100504 <cprintf+0x145>
80100467:	83 f8 73             	cmp    $0x73,%eax
8010046a:	74 47                	je     801004b3 <cprintf+0xf4>
8010046c:	83 f8 78             	cmp    $0x78,%eax
8010046f:	74 25                	je     80100496 <cprintf+0xd7>
80100471:	e9 8e 00 00 00       	jmp    80100504 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
80100476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100479:	8d 50 04             	lea    0x4(%eax),%edx
8010047c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010047f:	8b 00                	mov    (%eax),%eax
80100481:	83 ec 04             	sub    $0x4,%esp
80100484:	6a 01                	push   $0x1
80100486:	6a 0a                	push   $0xa
80100488:	50                   	push   %eax
80100489:	e8 83 fe ff ff       	call   80100311 <printint>
8010048e:	83 c4 10             	add    $0x10,%esp
      break;
80100491:	e9 8a 00 00 00       	jmp    80100520 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	83 ec 04             	sub    $0x4,%esp
801004a4:	6a 00                	push   $0x0
801004a6:	6a 10                	push   $0x10
801004a8:	50                   	push   %eax
801004a9:	e8 63 fe ff ff       	call   80100311 <printint>
801004ae:	83 c4 10             	add    $0x10,%esp
      break;
801004b1:	eb 6d                	jmp    80100520 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b6:	8d 50 04             	lea    0x4(%eax),%edx
801004b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bc:	8b 00                	mov    (%eax),%eax
801004be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c5:	75 07                	jne    801004ce <cprintf+0x10f>
        s = "(null)";
801004c7:	c7 45 ec 73 84 10 80 	movl   $0x80108473,-0x14(%ebp)
      for(; *s; s++)
801004ce:	eb 19                	jmp    801004e9 <cprintf+0x12a>
        consputc(*s);
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	0f be c0             	movsbl %al,%eax
801004d9:	83 ec 0c             	sub    $0xc,%esp
801004dc:	50                   	push   %eax
801004dd:	e8 89 02 00 00       	call   8010076b <consputc>
801004e2:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ec:	0f b6 00             	movzbl (%eax),%eax
801004ef:	84 c0                	test   %al,%al
801004f1:	75 dd                	jne    801004d0 <cprintf+0x111>
        consputc(*s);
      break;
801004f3:	eb 2b                	jmp    80100520 <cprintf+0x161>
    case '%':
      consputc('%');
801004f5:	83 ec 0c             	sub    $0xc,%esp
801004f8:	6a 25                	push   $0x25
801004fa:	e8 6c 02 00 00       	call   8010076b <consputc>
801004ff:	83 c4 10             	add    $0x10,%esp
      break;
80100502:	eb 1c                	jmp    80100520 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100504:	83 ec 0c             	sub    $0xc,%esp
80100507:	6a 25                	push   $0x25
80100509:	e8 5d 02 00 00       	call   8010076b <consputc>
8010050e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100511:	83 ec 0c             	sub    $0xc,%esp
80100514:	ff 75 e4             	pushl  -0x1c(%ebp)
80100517:	e8 4f 02 00 00       	call   8010076b <consputc>
8010051c:	83 c4 10             	add    $0x10,%esp
      break;
8010051f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100524:	8b 55 08             	mov    0x8(%ebp),%edx
80100527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052a:	01 d0                	add    %edx,%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	0f be c0             	movsbl %al,%eax
80100532:	25 ff 00 00 00       	and    $0xff,%eax
80100537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053e:	0f 85 c5 fe ff ff    	jne    80100409 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
80100544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100548:	74 10                	je     8010055a <cprintf+0x19b>
    release(&cons.lock);
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100552:	e8 46 4a 00 00       	call   80104f9d <release>
80100557:	83 c4 10             	add    $0x10,%esp
}
8010055a:	c9                   	leave  
8010055b:	c3                   	ret    

8010055c <panic>:

void
panic(char *s)
{
8010055c:	55                   	push   %ebp
8010055d:	89 e5                	mov    %esp,%ebp
8010055f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100562:	e8 a4 fd ff ff       	call   8010030b <cli>
  cons.locking = 0;
80100567:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010056e:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100571:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100577:	0f b6 00             	movzbl (%eax),%eax
8010057a:	0f b6 c0             	movzbl %al,%eax
8010057d:	83 ec 08             	sub    $0x8,%esp
80100580:	50                   	push   %eax
80100581:	68 7a 84 10 80       	push   $0x8010847a
80100586:	e8 34 fe ff ff       	call   801003bf <cprintf>
8010058b:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
8010058e:	8b 45 08             	mov    0x8(%ebp),%eax
80100591:	83 ec 0c             	sub    $0xc,%esp
80100594:	50                   	push   %eax
80100595:	e8 25 fe ff ff       	call   801003bf <cprintf>
8010059a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	68 89 84 10 80       	push   $0x80108489
801005a5:	e8 15 fe ff ff       	call   801003bf <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ad:	83 ec 08             	sub    $0x8,%esp
801005b0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b3:	50                   	push   %eax
801005b4:	8d 45 08             	lea    0x8(%ebp),%eax
801005b7:	50                   	push   %eax
801005b8:	e8 31 4a 00 00       	call   80104fee <getcallerpcs>
801005bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c7:	eb 1c                	jmp    801005e5 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005cc:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d0:	83 ec 08             	sub    $0x8,%esp
801005d3:	50                   	push   %eax
801005d4:	68 8b 84 10 80       	push   $0x8010848b
801005d9:	e8 e1 fd ff ff       	call   801003bf <cprintf>
801005de:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e9:	7e de                	jle    801005c9 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005eb:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005f2:	00 00 00 
  for(;;)
    ;
801005f5:	eb fe                	jmp    801005f5 <panic+0x99>

801005f7 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f7:	55                   	push   %ebp
801005f8:	89 e5                	mov    %esp,%ebp
801005fa:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005fd:	6a 0e                	push   $0xe
801005ff:	68 d4 03 00 00       	push   $0x3d4
80100604:	e8 e4 fc ff ff       	call   801002ed <outb>
80100609:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010060c:	68 d5 03 00 00       	push   $0x3d5
80100611:	e8 ba fc ff ff       	call   801002d0 <inb>
80100616:	83 c4 04             	add    $0x4,%esp
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	c1 e0 08             	shl    $0x8,%eax
8010061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100622:	6a 0f                	push   $0xf
80100624:	68 d4 03 00 00       	push   $0x3d4
80100629:	e8 bf fc ff ff       	call   801002ed <outb>
8010062e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100631:	68 d5 03 00 00       	push   $0x3d5
80100636:	e8 95 fc ff ff       	call   801002d0 <inb>
8010063b:	83 c4 04             	add    $0x4,%esp
8010063e:	0f b6 c0             	movzbl %al,%eax
80100641:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 30                	jne    8010067a <cgaputc+0x83>
    pos += 80 - pos%80;
8010064a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010064d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100652:	89 c8                	mov    %ecx,%eax
80100654:	f7 ea                	imul   %edx
80100656:	c1 fa 05             	sar    $0x5,%edx
80100659:	89 c8                	mov    %ecx,%eax
8010065b:	c1 f8 1f             	sar    $0x1f,%eax
8010065e:	29 c2                	sub    %eax,%edx
80100660:	89 d0                	mov    %edx,%eax
80100662:	c1 e0 02             	shl    $0x2,%eax
80100665:	01 d0                	add    %edx,%eax
80100667:	c1 e0 04             	shl    $0x4,%eax
8010066a:	29 c1                	sub    %eax,%ecx
8010066c:	89 ca                	mov    %ecx,%edx
8010066e:	b8 50 00 00 00       	mov    $0x50,%eax
80100673:	29 d0                	sub    %edx,%eax
80100675:	01 45 f4             	add    %eax,-0xc(%ebp)
80100678:	eb 34                	jmp    801006ae <cgaputc+0xb7>
  else if(c == BACKSPACE){
8010067a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100681:	75 0c                	jne    8010068f <cgaputc+0x98>
    if(pos > 0) --pos;
80100683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100687:	7e 25                	jle    801006ae <cgaputc+0xb7>
80100689:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010068d:	eb 1f                	jmp    801006ae <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068f:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100698:	8d 50 01             	lea    0x1(%eax),%edx
8010069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069e:	01 c0                	add    %eax,%eax
801006a0:	01 c8                	add    %ecx,%eax
801006a2:	8b 55 08             	mov    0x8(%ebp),%edx
801006a5:	0f b6 d2             	movzbl %dl,%edx
801006a8:	80 ce 07             	or     $0x7,%dh
801006ab:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006ae:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006b5:	7e 4c                	jle    80100703 <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006b7:	a1 00 90 10 80       	mov    0x80109000,%eax
801006bc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006c2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c7:	83 ec 04             	sub    $0x4,%esp
801006ca:	68 60 0e 00 00       	push   $0xe60
801006cf:	52                   	push   %edx
801006d0:	50                   	push   %eax
801006d1:	e8 7c 4b 00 00       	call   80105252 <memmove>
801006d6:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006d9:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006dd:	b8 80 07 00 00       	mov    $0x780,%eax
801006e2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006e5:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e8:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006f0:	01 c9                	add    %ecx,%ecx
801006f2:	01 c8                	add    %ecx,%eax
801006f4:	83 ec 04             	sub    $0x4,%esp
801006f7:	52                   	push   %edx
801006f8:	6a 00                	push   $0x0
801006fa:	50                   	push   %eax
801006fb:	e8 93 4a 00 00       	call   80105193 <memset>
80100700:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100703:	83 ec 08             	sub    $0x8,%esp
80100706:	6a 0e                	push   $0xe
80100708:	68 d4 03 00 00       	push   $0x3d4
8010070d:	e8 db fb ff ff       	call   801002ed <outb>
80100712:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100718:	c1 f8 08             	sar    $0x8,%eax
8010071b:	0f b6 c0             	movzbl %al,%eax
8010071e:	83 ec 08             	sub    $0x8,%esp
80100721:	50                   	push   %eax
80100722:	68 d5 03 00 00       	push   $0x3d5
80100727:	e8 c1 fb ff ff       	call   801002ed <outb>
8010072c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010072f:	83 ec 08             	sub    $0x8,%esp
80100732:	6a 0f                	push   $0xf
80100734:	68 d4 03 00 00       	push   $0x3d4
80100739:	e8 af fb ff ff       	call   801002ed <outb>
8010073e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100744:	0f b6 c0             	movzbl %al,%eax
80100747:	83 ec 08             	sub    $0x8,%esp
8010074a:	50                   	push   %eax
8010074b:	68 d5 03 00 00       	push   $0x3d5
80100750:	e8 98 fb ff ff       	call   801002ed <outb>
80100755:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100758:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100760:	01 d2                	add    %edx,%edx
80100762:	01 d0                	add    %edx,%eax
80100764:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100769:	c9                   	leave  
8010076a:	c3                   	ret    

8010076b <consputc>:

void
consputc(int c)
{
8010076b:	55                   	push   %ebp
8010076c:	89 e5                	mov    %esp,%ebp
8010076e:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100771:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100776:	85 c0                	test   %eax,%eax
80100778:	74 07                	je     80100781 <consputc+0x16>
    cli();
8010077a:	e8 8c fb ff ff       	call   8010030b <cli>
    for(;;)
      ;
8010077f:	eb fe                	jmp    8010077f <consputc+0x14>
  }

  if(c == BACKSPACE){
80100781:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100788:	75 29                	jne    801007b3 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078a:	83 ec 0c             	sub    $0xc,%esp
8010078d:	6a 08                	push   $0x8
8010078f:	e8 44 63 00 00       	call   80106ad8 <uartputc>
80100794:	83 c4 10             	add    $0x10,%esp
80100797:	83 ec 0c             	sub    $0xc,%esp
8010079a:	6a 20                	push   $0x20
8010079c:	e8 37 63 00 00       	call   80106ad8 <uartputc>
801007a1:	83 c4 10             	add    $0x10,%esp
801007a4:	83 ec 0c             	sub    $0xc,%esp
801007a7:	6a 08                	push   $0x8
801007a9:	e8 2a 63 00 00       	call   80106ad8 <uartputc>
801007ae:	83 c4 10             	add    $0x10,%esp
801007b1:	eb 0e                	jmp    801007c1 <consputc+0x56>
  } else
    uartputc(c);
801007b3:	83 ec 0c             	sub    $0xc,%esp
801007b6:	ff 75 08             	pushl  0x8(%ebp)
801007b9:	e8 1a 63 00 00       	call   80106ad8 <uartputc>
801007be:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007c1:	83 ec 0c             	sub    $0xc,%esp
801007c4:	ff 75 08             	pushl  0x8(%ebp)
801007c7:	e8 2b fe ff ff       	call   801005f7 <cgaputc>
801007cc:	83 c4 10             	add    $0x10,%esp
}
801007cf:	c9                   	leave  
801007d0:	c3                   	ret    

801007d1 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d1:	55                   	push   %ebp
801007d2:	89 e5                	mov    %esp,%ebp
801007d4:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007d7:	83 ec 0c             	sub    $0xc,%esp
801007da:	68 c0 07 11 80       	push   $0x801107c0
801007df:	e8 53 47 00 00       	call   80104f37 <acquire>
801007e4:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007e7:	e9 43 01 00 00       	jmp    8010092f <consoleintr+0x15e>
    switch(c){
801007ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007ef:	83 f8 10             	cmp    $0x10,%eax
801007f2:	74 1e                	je     80100812 <consoleintr+0x41>
801007f4:	83 f8 10             	cmp    $0x10,%eax
801007f7:	7f 0a                	jg     80100803 <consoleintr+0x32>
801007f9:	83 f8 08             	cmp    $0x8,%eax
801007fc:	74 67                	je     80100865 <consoleintr+0x94>
801007fe:	e9 93 00 00 00       	jmp    80100896 <consoleintr+0xc5>
80100803:	83 f8 15             	cmp    $0x15,%eax
80100806:	74 31                	je     80100839 <consoleintr+0x68>
80100808:	83 f8 7f             	cmp    $0x7f,%eax
8010080b:	74 58                	je     80100865 <consoleintr+0x94>
8010080d:	e9 84 00 00 00       	jmp    80100896 <consoleintr+0xc5>
    case C('P'):  // Process listing.
      procdump();
80100812:	e8 d3 45 00 00       	call   80104dea <procdump>
      break;
80100817:	e9 13 01 00 00       	jmp    8010092f <consoleintr+0x15e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010081c:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100821:	83 e8 01             	sub    $0x1,%eax
80100824:	a3 7c 08 11 80       	mov    %eax,0x8011087c
        consputc(BACKSPACE);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 00 01 00 00       	push   $0x100
80100831:	e8 35 ff ff ff       	call   8010076b <consputc>
80100836:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100839:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
8010083f:	a1 78 08 11 80       	mov    0x80110878,%eax
80100844:	39 c2                	cmp    %eax,%edx
80100846:	74 18                	je     80100860 <consoleintr+0x8f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	a1 7c 08 11 80       	mov    0x8011087c,%eax
8010084d:	83 e8 01             	sub    $0x1,%eax
80100850:	83 e0 7f             	and    $0x7f,%eax
80100853:	05 c0 07 11 80       	add    $0x801107c0,%eax
80100858:	0f b6 40 34          	movzbl 0x34(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085c:	3c 0a                	cmp    $0xa,%al
8010085e:	75 bc                	jne    8010081c <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100860:	e9 ca 00 00 00       	jmp    8010092f <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100865:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
8010086b:	a1 78 08 11 80       	mov    0x80110878,%eax
80100870:	39 c2                	cmp    %eax,%edx
80100872:	74 1d                	je     80100891 <consoleintr+0xc0>
        input.e--;
80100874:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100879:	83 e8 01             	sub    $0x1,%eax
8010087c:	a3 7c 08 11 80       	mov    %eax,0x8011087c
        consputc(BACKSPACE);
80100881:	83 ec 0c             	sub    $0xc,%esp
80100884:	68 00 01 00 00       	push   $0x100
80100889:	e8 dd fe ff ff       	call   8010076b <consputc>
8010088e:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100891:	e9 99 00 00 00       	jmp    8010092f <consoleintr+0x15e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010089a:	0f 84 8e 00 00 00    	je     8010092e <consoleintr+0x15d>
801008a0:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
801008a6:	a1 74 08 11 80       	mov    0x80110874,%eax
801008ab:	29 c2                	sub    %eax,%edx
801008ad:	89 d0                	mov    %edx,%eax
801008af:	83 f8 7f             	cmp    $0x7f,%eax
801008b2:	77 7a                	ja     8010092e <consoleintr+0x15d>
        c = (c == '\r') ? '\n' : c;
801008b4:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008b8:	74 05                	je     801008bf <consoleintr+0xee>
801008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bd:	eb 05                	jmp    801008c4 <consoleintr+0xf3>
801008bf:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c7:	a1 7c 08 11 80       	mov    0x8011087c,%eax
801008cc:	8d 50 01             	lea    0x1(%eax),%edx
801008cf:	89 15 7c 08 11 80    	mov    %edx,0x8011087c
801008d5:	83 e0 7f             	and    $0x7f,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008dd:	89 c1                	mov    %eax,%ecx
801008df:	8d 82 c0 07 11 80    	lea    -0x7feef840(%edx),%eax
801008e5:	88 48 34             	mov    %cl,0x34(%eax)
        consputc(c);
801008e8:	83 ec 0c             	sub    $0xc,%esp
801008eb:	ff 75 f4             	pushl  -0xc(%ebp)
801008ee:	e8 78 fe ff ff       	call   8010076b <consputc>
801008f3:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008fa:	74 18                	je     80100914 <consoleintr+0x143>
801008fc:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80100900:	74 12                	je     80100914 <consoleintr+0x143>
80100902:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100907:	8b 15 74 08 11 80    	mov    0x80110874,%edx
8010090d:	83 ea 80             	sub    $0xffffff80,%edx
80100910:	39 d0                	cmp    %edx,%eax
80100912:	75 1a                	jne    8010092e <consoleintr+0x15d>
          input.w = input.e;
80100914:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100919:	a3 78 08 11 80       	mov    %eax,0x80110878
          wakeup(&input.r);
8010091e:	83 ec 0c             	sub    $0xc,%esp
80100921:	68 74 08 11 80       	push   $0x80110874
80100926:	e8 05 44 00 00       	call   80104d30 <wakeup>
8010092b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010092e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010092f:	8b 45 08             	mov    0x8(%ebp),%eax
80100932:	ff d0                	call   *%eax
80100934:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010093b:	0f 89 ab fe ff ff    	jns    801007ec <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100941:	83 ec 0c             	sub    $0xc,%esp
80100944:	68 c0 07 11 80       	push   $0x801107c0
80100949:	e8 4f 46 00 00       	call   80104f9d <release>
8010094e:	83 c4 10             	add    $0x10,%esp
}
80100951:	c9                   	leave  
80100952:	c3                   	ret    

80100953 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100953:	55                   	push   %ebp
80100954:	89 e5                	mov    %esp,%ebp
80100956:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100959:	83 ec 0c             	sub    $0xc,%esp
8010095c:	ff 75 08             	pushl  0x8(%ebp)
8010095f:	e8 cd 10 00 00       	call   80101a31 <iunlock>
80100964:	83 c4 10             	add    $0x10,%esp
  target = n;
80100967:	8b 45 10             	mov    0x10(%ebp),%eax
8010096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
8010096d:	83 ec 0c             	sub    $0xc,%esp
80100970:	68 c0 07 11 80       	push   $0x801107c0
80100975:	e8 bd 45 00 00       	call   80104f37 <acquire>
8010097a:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
8010097d:	e9 b4 00 00 00       	jmp    80100a36 <consoleread+0xe3>
    while(input.r == input.w){
80100982:	eb 4a                	jmp    801009ce <consoleread+0x7b>
      if(proc->killed){
80100984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010098a:	8b 40 24             	mov    0x24(%eax),%eax
8010098d:	85 c0                	test   %eax,%eax
8010098f:	74 28                	je     801009b9 <consoleread+0x66>
        release(&input.lock);
80100991:	83 ec 0c             	sub    $0xc,%esp
80100994:	68 c0 07 11 80       	push   $0x801107c0
80100999:	e8 ff 45 00 00       	call   80104f9d <release>
8010099e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009a1:	83 ec 0c             	sub    $0xc,%esp
801009a4:	ff 75 08             	pushl  0x8(%ebp)
801009a7:	e8 2e 0f 00 00       	call   801018da <ilock>
801009ac:	83 c4 10             	add    $0x10,%esp
        return -1;
801009af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009b4:	e9 af 00 00 00       	jmp    80100a68 <consoleread+0x115>
      }
      sleep(&input.r, &input.lock);
801009b9:	83 ec 08             	sub    $0x8,%esp
801009bc:	68 c0 07 11 80       	push   $0x801107c0
801009c1:	68 74 08 11 80       	push   $0x80110874
801009c6:	e8 7c 42 00 00       	call   80104c47 <sleep>
801009cb:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009ce:	8b 15 74 08 11 80    	mov    0x80110874,%edx
801009d4:	a1 78 08 11 80       	mov    0x80110878,%eax
801009d9:	39 c2                	cmp    %eax,%edx
801009db:	74 a7                	je     80100984 <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009dd:	a1 74 08 11 80       	mov    0x80110874,%eax
801009e2:	8d 50 01             	lea    0x1(%eax),%edx
801009e5:	89 15 74 08 11 80    	mov    %edx,0x80110874
801009eb:	83 e0 7f             	and    $0x7f,%eax
801009ee:	05 c0 07 11 80       	add    $0x801107c0,%eax
801009f3:	0f b6 40 34          	movzbl 0x34(%eax),%eax
801009f7:	0f be c0             	movsbl %al,%eax
801009fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009fd:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a01:	75 19                	jne    80100a1c <consoleread+0xc9>
      if(n < target){
80100a03:	8b 45 10             	mov    0x10(%ebp),%eax
80100a06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a09:	73 0f                	jae    80100a1a <consoleread+0xc7>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a0b:	a1 74 08 11 80       	mov    0x80110874,%eax
80100a10:	83 e8 01             	sub    $0x1,%eax
80100a13:	a3 74 08 11 80       	mov    %eax,0x80110874
      }
      break;
80100a18:	eb 26                	jmp    80100a40 <consoleread+0xed>
80100a1a:	eb 24                	jmp    80100a40 <consoleread+0xed>
    }
    *dst++ = c;
80100a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a1f:	8d 50 01             	lea    0x1(%eax),%edx
80100a22:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a28:	88 10                	mov    %dl,(%eax)
    --n;
80100a2a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a2e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a32:	75 02                	jne    80100a36 <consoleread+0xe3>
      break;
80100a34:	eb 0a                	jmp    80100a40 <consoleread+0xed>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3a:	0f 8f 42 ff ff ff    	jg     80100982 <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
80100a40:	83 ec 0c             	sub    $0xc,%esp
80100a43:	68 c0 07 11 80       	push   $0x801107c0
80100a48:	e8 50 45 00 00       	call   80104f9d <release>
80100a4d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a50:	83 ec 0c             	sub    $0xc,%esp
80100a53:	ff 75 08             	pushl  0x8(%ebp)
80100a56:	e8 7f 0e 00 00       	call   801018da <ilock>
80100a5b:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a5e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a64:	29 c2                	sub    %eax,%edx
80100a66:	89 d0                	mov    %edx,%eax
}
80100a68:	c9                   	leave  
80100a69:	c3                   	ret    

80100a6a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a6a:	55                   	push   %ebp
80100a6b:	89 e5                	mov    %esp,%ebp
80100a6d:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a70:	83 ec 0c             	sub    $0xc,%esp
80100a73:	ff 75 08             	pushl  0x8(%ebp)
80100a76:	e8 b6 0f 00 00       	call   80101a31 <iunlock>
80100a7b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a7e:	83 ec 0c             	sub    $0xc,%esp
80100a81:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a86:	e8 ac 44 00 00       	call   80104f37 <acquire>
80100a8b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a95:	eb 21                	jmp    80100ab8 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	0f b6 00             	movzbl (%eax),%eax
80100aa2:	0f be c0             	movsbl %al,%eax
80100aa5:	0f b6 c0             	movzbl %al,%eax
80100aa8:	83 ec 0c             	sub    $0xc,%esp
80100aab:	50                   	push   %eax
80100aac:	e8 ba fc ff ff       	call   8010076b <consputc>
80100ab1:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ab4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100abb:	3b 45 10             	cmp    0x10(%ebp),%eax
80100abe:	7c d7                	jl     80100a97 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	68 e0 b5 10 80       	push   $0x8010b5e0
80100ac8:	e8 d0 44 00 00       	call   80104f9d <release>
80100acd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	ff 75 08             	pushl  0x8(%ebp)
80100ad6:	e8 ff 0d 00 00       	call   801018da <ilock>
80100adb:	83 c4 10             	add    $0x10,%esp

  return n;
80100ade:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ae1:	c9                   	leave  
80100ae2:	c3                   	ret    

80100ae3 <consoleinit>:

void
consoleinit(void)
{
80100ae3:	55                   	push   %ebp
80100ae4:	89 e5                	mov    %esp,%ebp
80100ae6:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100ae9:	83 ec 08             	sub    $0x8,%esp
80100aec:	68 8f 84 10 80       	push   $0x8010848f
80100af1:	68 e0 b5 10 80       	push   $0x8010b5e0
80100af6:	e8 1b 44 00 00       	call   80104f16 <initlock>
80100afb:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100afe:	83 ec 08             	sub    $0x8,%esp
80100b01:	68 97 84 10 80       	push   $0x80108497
80100b06:	68 c0 07 11 80       	push   $0x801107c0
80100b0b:	e8 06 44 00 00       	call   80104f16 <initlock>
80100b10:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b13:	c7 05 4c 12 11 80 6a 	movl   $0x80100a6a,0x8011124c
80100b1a:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b1d:	c7 05 48 12 11 80 53 	movl   $0x80100953,0x80111248
80100b24:	09 10 80 
  cons.locking = 1;
80100b27:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b2e:	00 00 00 

  picenable(IRQ_KBD);
80100b31:	83 ec 0c             	sub    $0xc,%esp
80100b34:	6a 01                	push   $0x1
80100b36:	e8 4c 33 00 00       	call   80103e87 <picenable>
80100b3b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b3e:	83 ec 08             	sub    $0x8,%esp
80100b41:	6a 00                	push   $0x0
80100b43:	6a 01                	push   $0x1
80100b45:	e8 fc 1e 00 00       	call   80102a46 <ioapicenable>
80100b4a:	83 c4 10             	add    $0x10,%esp
}
80100b4d:	c9                   	leave  
80100b4e:	c3                   	ret    

80100b4f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b4f:	55                   	push   %ebp
80100b50:	89 e5                	mov    %esp,%ebp
80100b52:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b58:	e8 51 29 00 00       	call   801034ae <begin_op>
  if((ip = namei(path)) == 0){
80100b5d:	83 ec 0c             	sub    $0xc,%esp
80100b60:	ff 75 08             	pushl  0x8(%ebp)
80100b63:	e8 35 19 00 00       	call   8010249d <namei>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b72:	75 0f                	jne    80100b83 <exec+0x34>
    end_op();
80100b74:	e8 c3 29 00 00       	call   8010353c <end_op>
    return -1;
80100b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b7e:	e9 b9 03 00 00       	jmp    80100f3c <exec+0x3ed>
  }
  ilock(ip);
80100b83:	83 ec 0c             	sub    $0xc,%esp
80100b86:	ff 75 d8             	pushl  -0x28(%ebp)
80100b89:	e8 4c 0d 00 00       	call   801018da <ilock>
80100b8e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b98:	6a 34                	push   $0x34
80100b9a:	6a 00                	push   $0x0
80100b9c:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ba2:	50                   	push   %eax
80100ba3:	ff 75 d8             	pushl  -0x28(%ebp)
80100ba6:	e8 91 12 00 00       	call   80101e3c <readi>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	83 f8 33             	cmp    $0x33,%eax
80100bb1:	77 05                	ja     80100bb8 <exec+0x69>
    goto bad;
80100bb3:	e9 52 03 00 00       	jmp    80100f0a <exec+0x3bb>
  if(elf.magic != ELF_MAGIC)
80100bb8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbe:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc3:	74 05                	je     80100bca <exec+0x7b>
    goto bad;
80100bc5:	e9 40 03 00 00       	jmp    80100f0a <exec+0x3bb>

  if((pgdir = setupkvm()) == 0)
80100bca:	e8 59 70 00 00       	call   80107c28 <setupkvm>
80100bcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bd6:	75 05                	jne    80100bdd <exec+0x8e>
    goto bad;
80100bd8:	e9 2d 03 00 00       	jmp    80100f0a <exec+0x3bb>

  // Load program into memory.
  sz = 0;
80100bdd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100beb:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bf1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf4:	e9 ae 00 00 00       	jmp    80100ca7 <exec+0x158>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	50                   	push   %eax
80100bff:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c05:	50                   	push   %eax
80100c06:	ff 75 d8             	pushl  -0x28(%ebp)
80100c09:	e8 2e 12 00 00       	call   80101e3c <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 20             	cmp    $0x20,%eax
80100c14:	74 05                	je     80100c1b <exec+0xcc>
      goto bad;
80100c16:	e9 ef 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if(ph.type != ELF_PROG_LOAD)
80100c1b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c21:	83 f8 01             	cmp    $0x1,%eax
80100c24:	74 02                	je     80100c28 <exec+0xd9>
      continue;
80100c26:	eb 72                	jmp    80100c9a <exec+0x14b>
    if(ph.memsz < ph.filesz)
80100c28:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c2e:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c34:	39 c2                	cmp    %eax,%edx
80100c36:	73 05                	jae    80100c3d <exec+0xee>
      goto bad;
80100c38:	e9 cd 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 71 73 00 00       	call   80107fcb <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	75 05                	jne    80100c6b <exec+0x11c>
      goto bad;
80100c66:	e9 9f 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c6b:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c71:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c77:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	52                   	push   %edx
80100c81:	50                   	push   %eax
80100c82:	ff 75 d8             	pushl  -0x28(%ebp)
80100c85:	51                   	push   %ecx
80100c86:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c89:	e8 66 72 00 00       	call   80107ef4 <loaduvm>
80100c8e:	83 c4 20             	add    $0x20,%esp
80100c91:	85 c0                	test   %eax,%eax
80100c93:	79 05                	jns    80100c9a <exec+0x14b>
      goto bad;
80100c95:	e9 70 02 00 00       	jmp    80100f0a <exec+0x3bb>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca1:	83 c0 20             	add    $0x20,%eax
80100ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca7:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cae:	0f b7 c0             	movzwl %ax,%eax
80100cb1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb4:	0f 8f 3f ff ff ff    	jg     80100bf9 <exec+0xaa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cba:	83 ec 0c             	sub    $0xc,%esp
80100cbd:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc0:	e8 cc 0e 00 00       	call   80101b91 <iunlockput>
80100cc5:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cc8:	e8 6f 28 00 00       	call   8010353c <end_op>
  ip = 0;
80100ccd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd7:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce7:	05 00 20 00 00       	add    $0x2000,%eax
80100cec:	83 ec 04             	sub    $0x4,%esp
80100cef:	50                   	push   %eax
80100cf0:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf6:	e8 d0 72 00 00       	call   80107fcb <allocuvm>
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d05:	75 05                	jne    80100d0c <exec+0x1bd>
    goto bad;
80100d07:	e9 fe 01 00 00       	jmp    80100f0a <exec+0x3bb>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 d0 74 00 00       	call   801081f0 <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 98 00 00 00       	jmp    80100dcd <exec+0x27e>
    if(argc >= MAXARG)
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	76 05                	jbe    80100d40 <exec+0x1f1>
      goto bad;
80100d3b:	e9 ca 01 00 00       	jmp    80100f0a <exec+0x3bb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4d:	01 d0                	add    %edx,%eax
80100d4f:	8b 00                	mov    (%eax),%eax
80100d51:	83 ec 0c             	sub    $0xc,%esp
80100d54:	50                   	push   %eax
80100d55:	e8 88 46 00 00       	call   801053e2 <strlen>
80100d5a:	83 c4 10             	add    $0x10,%esp
80100d5d:	89 c2                	mov    %eax,%edx
80100d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d62:	29 d0                	sub    %edx,%eax
80100d64:	83 e8 01             	sub    $0x1,%eax
80100d67:	83 e0 fc             	and    $0xfffffffc,%eax
80100d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7a:	01 d0                	add    %edx,%eax
80100d7c:	8b 00                	mov    (%eax),%eax
80100d7e:	83 ec 0c             	sub    $0xc,%esp
80100d81:	50                   	push   %eax
80100d82:	e8 5b 46 00 00       	call   801053e2 <strlen>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	83 c0 01             	add    $0x1,%eax
80100d8d:	89 c1                	mov    %eax,%ecx
80100d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9c:	01 d0                	add    %edx,%eax
80100d9e:	8b 00                	mov    (%eax),%eax
80100da0:	51                   	push   %ecx
80100da1:	50                   	push   %eax
80100da2:	ff 75 dc             	pushl  -0x24(%ebp)
80100da5:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da8:	e8 f9 75 00 00       	call   801083a6 <copyout>
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	85 c0                	test   %eax,%eax
80100db2:	79 05                	jns    80100db9 <exec+0x26a>
      goto bad;
80100db4:	e9 51 01 00 00       	jmp    80100f0a <exec+0x3bb>
    ustack[3+argc] = sp;
80100db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbc:	8d 50 03             	lea    0x3(%eax),%edx
80100dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc2:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dda:	01 d0                	add    %edx,%eax
80100ddc:	8b 00                	mov    (%eax),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	0f 85 4f ff ff ff    	jne    80100d35 <exec+0x1e6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	83 c0 03             	add    $0x3,%eax
80100dec:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100df7:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfe:	ff ff ff 
  ustack[1] = argc;
80100e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e04:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1a:	29 d0                	sub    %edx,%eax
80100e1c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e25:	83 c0 04             	add    $0x4,%eax
80100e28:	c1 e0 02             	shl    $0x2,%eax
80100e2b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	83 c0 04             	add    $0x4,%eax
80100e34:	c1 e0 02             	shl    $0x2,%eax
80100e37:	50                   	push   %eax
80100e38:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3e:	50                   	push   %eax
80100e3f:	ff 75 dc             	pushl  -0x24(%ebp)
80100e42:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e45:	e8 5c 75 00 00       	call   801083a6 <copyout>
80100e4a:	83 c4 10             	add    $0x10,%esp
80100e4d:	85 c0                	test   %eax,%eax
80100e4f:	79 05                	jns    80100e56 <exec+0x307>
    goto bad;
80100e51:	e9 b4 00 00 00       	jmp    80100f0a <exec+0x3bb>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e56:	8b 45 08             	mov    0x8(%ebp),%eax
80100e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e62:	eb 17                	jmp    80100e7b <exec+0x32c>
    if(*s == '/')
80100e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e67:	0f b6 00             	movzbl (%eax),%eax
80100e6a:	3c 2f                	cmp    $0x2f,%al
80100e6c:	75 09                	jne    80100e77 <exec+0x328>
      last = s+1;
80100e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e71:	83 c0 01             	add    $0x1,%eax
80100e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7e:	0f b6 00             	movzbl (%eax),%eax
80100e81:	84 c0                	test   %al,%al
80100e83:	75 df                	jne    80100e64 <exec+0x315>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8b:	83 c0 6c             	add    $0x6c,%eax
80100e8e:	83 ec 04             	sub    $0x4,%esp
80100e91:	6a 10                	push   $0x10
80100e93:	ff 75 f0             	pushl  -0x10(%ebp)
80100e96:	50                   	push   %eax
80100e97:	e8 fc 44 00 00       	call   80105398 <safestrcpy>
80100e9c:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea5:	8b 40 04             	mov    0x4(%eax),%eax
80100ea8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100eab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb4:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ec0:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ec2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec8:	8b 40 18             	mov    0x18(%eax),%eax
80100ecb:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ed1:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eda:	8b 40 18             	mov    0x18(%eax),%eax
80100edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ee0:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee9:	83 ec 0c             	sub    $0xc,%esp
80100eec:	50                   	push   %eax
80100eed:	e8 1b 6e 00 00       	call   80107d0d <switchuvm>
80100ef2:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 d0             	pushl  -0x30(%ebp)
80100efb:	e8 51 72 00 00       	call   80108151 <freevm>
80100f00:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f03:	b8 00 00 00 00       	mov    $0x0,%eax
80100f08:	eb 32                	jmp    80100f3c <exec+0x3ed>

 bad:
  if(pgdir)
80100f0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f0e:	74 0e                	je     80100f1e <exec+0x3cf>
    freevm(pgdir);
80100f10:	83 ec 0c             	sub    $0xc,%esp
80100f13:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f16:	e8 36 72 00 00       	call   80108151 <freevm>
80100f1b:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f1e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f22:	74 13                	je     80100f37 <exec+0x3e8>
    iunlockput(ip);
80100f24:	83 ec 0c             	sub    $0xc,%esp
80100f27:	ff 75 d8             	pushl  -0x28(%ebp)
80100f2a:	e8 62 0c 00 00       	call   80101b91 <iunlockput>
80100f2f:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f32:	e8 05 26 00 00       	call   8010353c <end_op>
  }
  return -1;
80100f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f3c:	c9                   	leave  
80100f3d:	c3                   	ret    

80100f3e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f3e:	55                   	push   %ebp
80100f3f:	89 e5                	mov    %esp,%ebp
80100f41:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f44:	83 ec 08             	sub    $0x8,%esp
80100f47:	68 9d 84 10 80       	push   $0x8010849d
80100f4c:	68 80 08 11 80       	push   $0x80110880
80100f51:	e8 c0 3f 00 00       	call   80104f16 <initlock>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	c9                   	leave  
80100f5a:	c3                   	ret    

80100f5b <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f5b:	55                   	push   %ebp
80100f5c:	89 e5                	mov    %esp,%ebp
80100f5e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f61:	83 ec 0c             	sub    $0xc,%esp
80100f64:	68 80 08 11 80       	push   $0x80110880
80100f69:	e8 c9 3f 00 00       	call   80104f37 <acquire>
80100f6e:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f71:	c7 45 f4 b4 08 11 80 	movl   $0x801108b4,-0xc(%ebp)
80100f78:	eb 2d                	jmp    80100fa7 <filealloc+0x4c>
    if(f->ref == 0){
80100f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7d:	8b 40 04             	mov    0x4(%eax),%eax
80100f80:	85 c0                	test   %eax,%eax
80100f82:	75 1f                	jne    80100fa3 <filealloc+0x48>
      f->ref = 1;
80100f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f87:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
80100f91:	68 80 08 11 80       	push   $0x80110880
80100f96:	e8 02 40 00 00       	call   80104f9d <release>
80100f9b:	83 c4 10             	add    $0x10,%esp
      return f;
80100f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa1:	eb 22                	jmp    80100fc5 <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa3:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fa7:	81 7d f4 14 12 11 80 	cmpl   $0x80111214,-0xc(%ebp)
80100fae:	72 ca                	jb     80100f7a <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
80100fb3:	68 80 08 11 80       	push   $0x80110880
80100fb8:	e8 e0 3f 00 00       	call   80104f9d <release>
80100fbd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fc5:	c9                   	leave  
80100fc6:	c3                   	ret    

80100fc7 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc7:	55                   	push   %ebp
80100fc8:	89 e5                	mov    %esp,%ebp
80100fca:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	68 80 08 11 80       	push   $0x80110880
80100fd5:	e8 5d 3f 00 00       	call   80104f37 <acquire>
80100fda:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe0:	8b 40 04             	mov    0x4(%eax),%eax
80100fe3:	85 c0                	test   %eax,%eax
80100fe5:	7f 0d                	jg     80100ff4 <filedup+0x2d>
    panic("filedup");
80100fe7:	83 ec 0c             	sub    $0xc,%esp
80100fea:	68 a4 84 10 80       	push   $0x801084a4
80100fef:	e8 68 f5 ff ff       	call   8010055c <panic>
  f->ref++;
80100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff7:	8b 40 04             	mov    0x4(%eax),%eax
80100ffa:	8d 50 01             	lea    0x1(%eax),%edx
80100ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80101000:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101003:	83 ec 0c             	sub    $0xc,%esp
80101006:	68 80 08 11 80       	push   $0x80110880
8010100b:	e8 8d 3f 00 00       	call   80104f9d <release>
80101010:	83 c4 10             	add    $0x10,%esp
  return f;
80101013:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101016:	c9                   	leave  
80101017:	c3                   	ret    

80101018 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101018:	55                   	push   %ebp
80101019:	89 e5                	mov    %esp,%ebp
8010101b:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010101e:	83 ec 0c             	sub    $0xc,%esp
80101021:	68 80 08 11 80       	push   $0x80110880
80101026:	e8 0c 3f 00 00       	call   80104f37 <acquire>
8010102b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010102e:	8b 45 08             	mov    0x8(%ebp),%eax
80101031:	8b 40 04             	mov    0x4(%eax),%eax
80101034:	85 c0                	test   %eax,%eax
80101036:	7f 0d                	jg     80101045 <fileclose+0x2d>
    panic("fileclose");
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	68 ac 84 10 80       	push   $0x801084ac
80101040:	e8 17 f5 ff ff       	call   8010055c <panic>
  if(--f->ref > 0){
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	8b 40 04             	mov    0x4(%eax),%eax
8010104b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010104e:	8b 45 08             	mov    0x8(%ebp),%eax
80101051:	89 50 04             	mov    %edx,0x4(%eax)
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	8b 40 04             	mov    0x4(%eax),%eax
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7e 15                	jle    80101073 <fileclose+0x5b>
    release(&ftable.lock);
8010105e:	83 ec 0c             	sub    $0xc,%esp
80101061:	68 80 08 11 80       	push   $0x80110880
80101066:	e8 32 3f 00 00       	call   80104f9d <release>
8010106b:	83 c4 10             	add    $0x10,%esp
8010106e:	e9 8b 00 00 00       	jmp    801010fe <fileclose+0xe6>
    return;
  }
  ff = *f;
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	8b 10                	mov    (%eax),%edx
80101078:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010107b:	8b 50 04             	mov    0x4(%eax),%edx
8010107e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101081:	8b 50 08             	mov    0x8(%eax),%edx
80101084:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101087:	8b 50 0c             	mov    0xc(%eax),%edx
8010108a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010108d:	8b 50 10             	mov    0x10(%eax),%edx
80101090:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101093:	8b 40 14             	mov    0x14(%eax),%eax
80101096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101099:	8b 45 08             	mov    0x8(%ebp),%eax
8010109c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010a3:	8b 45 08             	mov    0x8(%ebp),%eax
801010a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	68 80 08 11 80       	push   $0x80110880
801010b4:	e8 e4 3e 00 00       	call   80104f9d <release>
801010b9:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bf:	83 f8 01             	cmp    $0x1,%eax
801010c2:	75 19                	jne    801010dd <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010c4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010c8:	0f be d0             	movsbl %al,%edx
801010cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ce:	83 ec 08             	sub    $0x8,%esp
801010d1:	52                   	push   %edx
801010d2:	50                   	push   %eax
801010d3:	e8 16 30 00 00       	call   801040ee <pipeclose>
801010d8:	83 c4 10             	add    $0x10,%esp
801010db:	eb 21                	jmp    801010fe <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e0:	83 f8 02             	cmp    $0x2,%eax
801010e3:	75 19                	jne    801010fe <fileclose+0xe6>
    begin_op();
801010e5:	e8 c4 23 00 00       	call   801034ae <begin_op>
    iput(ff.ip);
801010ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010ed:	83 ec 0c             	sub    $0xc,%esp
801010f0:	50                   	push   %eax
801010f1:	e8 ac 09 00 00       	call   80101aa2 <iput>
801010f6:	83 c4 10             	add    $0x10,%esp
    end_op();
801010f9:	e8 3e 24 00 00       	call   8010353c <end_op>
  }
}
801010fe:	c9                   	leave  
801010ff:	c3                   	ret    

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101106:	8b 45 08             	mov    0x8(%ebp),%eax
80101109:	8b 00                	mov    (%eax),%eax
8010110b:	83 f8 02             	cmp    $0x2,%eax
8010110e:	75 40                	jne    80101150 <filestat+0x50>
    ilock(f->ip);
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 40 10             	mov    0x10(%eax),%eax
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	50                   	push   %eax
8010111a:	e8 bb 07 00 00       	call   801018da <ilock>
8010111f:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101122:	8b 45 08             	mov    0x8(%ebp),%eax
80101125:	8b 40 10             	mov    0x10(%eax),%eax
80101128:	83 ec 08             	sub    $0x8,%esp
8010112b:	ff 75 0c             	pushl  0xc(%ebp)
8010112e:	50                   	push   %eax
8010112f:	e8 c3 0c 00 00       	call   80101df7 <stati>
80101134:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101137:	8b 45 08             	mov    0x8(%ebp),%eax
8010113a:	8b 40 10             	mov    0x10(%eax),%eax
8010113d:	83 ec 0c             	sub    $0xc,%esp
80101140:	50                   	push   %eax
80101141:	e8 eb 08 00 00       	call   80101a31 <iunlock>
80101146:	83 c4 10             	add    $0x10,%esp
    return 0;
80101149:	b8 00 00 00 00       	mov    $0x0,%eax
8010114e:	eb 05                	jmp    80101155 <filestat+0x55>
  }
  return -1;
80101150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101155:	c9                   	leave  
80101156:	c3                   	ret    

80101157 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101157:	55                   	push   %ebp
80101158:	89 e5                	mov    %esp,%ebp
8010115a:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101164:	84 c0                	test   %al,%al
80101166:	75 0a                	jne    80101172 <fileread+0x1b>
    return -1;
80101168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010116d:	e9 9b 00 00 00       	jmp    8010120d <fileread+0xb6>
  if(f->type == FD_PIPE)
80101172:	8b 45 08             	mov    0x8(%ebp),%eax
80101175:	8b 00                	mov    (%eax),%eax
80101177:	83 f8 01             	cmp    $0x1,%eax
8010117a:	75 1a                	jne    80101196 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 40 0c             	mov    0xc(%eax),%eax
80101182:	83 ec 04             	sub    $0x4,%esp
80101185:	ff 75 10             	pushl  0x10(%ebp)
80101188:	ff 75 0c             	pushl  0xc(%ebp)
8010118b:	50                   	push   %eax
8010118c:	e8 0a 31 00 00       	call   8010429b <piperead>
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	eb 77                	jmp    8010120d <fileread+0xb6>
  if(f->type == FD_INODE){
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	8b 00                	mov    (%eax),%eax
8010119b:	83 f8 02             	cmp    $0x2,%eax
8010119e:	75 60                	jne    80101200 <fileread+0xa9>
    ilock(f->ip);
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 40 10             	mov    0x10(%eax),%eax
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	50                   	push   %eax
801011aa:	e8 2b 07 00 00       	call   801018da <ilock>
801011af:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 50 14             	mov    0x14(%eax),%edx
801011bb:	8b 45 08             	mov    0x8(%ebp),%eax
801011be:	8b 40 10             	mov    0x10(%eax),%eax
801011c1:	51                   	push   %ecx
801011c2:	52                   	push   %edx
801011c3:	ff 75 0c             	pushl  0xc(%ebp)
801011c6:	50                   	push   %eax
801011c7:	e8 70 0c 00 00       	call   80101e3c <readi>
801011cc:	83 c4 10             	add    $0x10,%esp
801011cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011d6:	7e 11                	jle    801011e9 <fileread+0x92>
      f->off += r;
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	8b 50 14             	mov    0x14(%eax),%edx
801011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e1:	01 c2                	add    %eax,%edx
801011e3:	8b 45 08             	mov    0x8(%ebp),%eax
801011e6:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 40 10             	mov    0x10(%eax),%eax
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	50                   	push   %eax
801011f3:	e8 39 08 00 00       	call   80101a31 <iunlock>
801011f8:	83 c4 10             	add    $0x10,%esp
    return r;
801011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fe:	eb 0d                	jmp    8010120d <fileread+0xb6>
  }
  panic("fileread");
80101200:	83 ec 0c             	sub    $0xc,%esp
80101203:	68 b6 84 10 80       	push   $0x801084b6
80101208:	e8 4f f3 ff ff       	call   8010055c <panic>
}
8010120d:	c9                   	leave  
8010120e:	c3                   	ret    

8010120f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010120f:	55                   	push   %ebp
80101210:	89 e5                	mov    %esp,%ebp
80101212:	53                   	push   %ebx
80101213:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010121d:	84 c0                	test   %al,%al
8010121f:	75 0a                	jne    8010122b <filewrite+0x1c>
    return -1;
80101221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101226:	e9 1a 01 00 00       	jmp    80101345 <filewrite+0x136>
  if(f->type == FD_PIPE)
8010122b:	8b 45 08             	mov    0x8(%ebp),%eax
8010122e:	8b 00                	mov    (%eax),%eax
80101230:	83 f8 01             	cmp    $0x1,%eax
80101233:	75 1d                	jne    80101252 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101235:	8b 45 08             	mov    0x8(%ebp),%eax
80101238:	8b 40 0c             	mov    0xc(%eax),%eax
8010123b:	83 ec 04             	sub    $0x4,%esp
8010123e:	ff 75 10             	pushl  0x10(%ebp)
80101241:	ff 75 0c             	pushl  0xc(%ebp)
80101244:	50                   	push   %eax
80101245:	e8 4d 2f 00 00       	call   80104197 <pipewrite>
8010124a:	83 c4 10             	add    $0x10,%esp
8010124d:	e9 f3 00 00 00       	jmp    80101345 <filewrite+0x136>
  if(f->type == FD_INODE){
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 00                	mov    (%eax),%eax
80101257:	83 f8 02             	cmp    $0x2,%eax
8010125a:	0f 85 d8 00 00 00    	jne    80101338 <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101260:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010126e:	e9 a5 00 00 00       	jmp    80101318 <filewrite+0x109>
      int n1 = n - i;
80101273:	8b 45 10             	mov    0x10(%ebp),%eax
80101276:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101279:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101282:	7e 06                	jle    8010128a <filewrite+0x7b>
        n1 = max;
80101284:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101287:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010128a:	e8 1f 22 00 00       	call   801034ae <begin_op>
      ilock(f->ip);
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 40 10             	mov    0x10(%eax),%eax
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	50                   	push   %eax
80101299:	e8 3c 06 00 00       	call   801018da <ilock>
8010129e:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012a4:	8b 45 08             	mov    0x8(%ebp),%eax
801012a7:	8b 50 14             	mov    0x14(%eax),%edx
801012aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801012b0:	01 c3                	add    %eax,%ebx
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 40 10             	mov    0x10(%eax),%eax
801012b8:	51                   	push   %ecx
801012b9:	52                   	push   %edx
801012ba:	53                   	push   %ebx
801012bb:	50                   	push   %eax
801012bc:	e8 dc 0c 00 00       	call   80101f9d <writei>
801012c1:	83 c4 10             	add    $0x10,%esp
801012c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012cb:	7e 11                	jle    801012de <filewrite+0xcf>
        f->off += r;
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	8b 50 14             	mov    0x14(%eax),%edx
801012d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d6:	01 c2                	add    %eax,%edx
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012de:	8b 45 08             	mov    0x8(%ebp),%eax
801012e1:	8b 40 10             	mov    0x10(%eax),%eax
801012e4:	83 ec 0c             	sub    $0xc,%esp
801012e7:	50                   	push   %eax
801012e8:	e8 44 07 00 00       	call   80101a31 <iunlock>
801012ed:	83 c4 10             	add    $0x10,%esp
      end_op();
801012f0:	e8 47 22 00 00       	call   8010353c <end_op>

      if(r < 0)
801012f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012f9:	79 02                	jns    801012fd <filewrite+0xee>
        break;
801012fb:	eb 27                	jmp    80101324 <filewrite+0x115>
      if(r != n1)
801012fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101303:	74 0d                	je     80101312 <filewrite+0x103>
        panic("short filewrite");
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	68 bf 84 10 80       	push   $0x801084bf
8010130d:	e8 4a f2 ff ff       	call   8010055c <panic>
      i += r;
80101312:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101315:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010131e:	0f 8c 4f ff ff ff    	jl     80101273 <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101327:	3b 45 10             	cmp    0x10(%ebp),%eax
8010132a:	75 05                	jne    80101331 <filewrite+0x122>
8010132c:	8b 45 10             	mov    0x10(%ebp),%eax
8010132f:	eb 14                	jmp    80101345 <filewrite+0x136>
80101331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101336:	eb 0d                	jmp    80101345 <filewrite+0x136>
  }
  panic("filewrite");
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	68 cf 84 10 80       	push   $0x801084cf
80101340:	e8 17 f2 ff ff       	call   8010055c <panic>
}
80101345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101348:	c9                   	leave  
80101349:	c3                   	ret    

8010134a <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010134a:	55                   	push   %ebp
8010134b:	89 e5                	mov    %esp,%ebp
8010134d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101350:	8b 45 08             	mov    0x8(%ebp),%eax
80101353:	83 ec 08             	sub    $0x8,%esp
80101356:	6a 01                	push   $0x1
80101358:	50                   	push   %eax
80101359:	e8 56 ee ff ff       	call   801001b4 <bread>
8010135e:	83 c4 10             	add    $0x10,%esp
80101361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101367:	83 c0 18             	add    $0x18,%eax
8010136a:	83 ec 04             	sub    $0x4,%esp
8010136d:	6a 10                	push   $0x10
8010136f:	50                   	push   %eax
80101370:	ff 75 0c             	pushl  0xc(%ebp)
80101373:	e8 da 3e 00 00       	call   80105252 <memmove>
80101378:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	ff 75 f4             	pushl  -0xc(%ebp)
80101381:	e8 a5 ee ff ff       	call   8010022b <brelse>
80101386:	83 c4 10             	add    $0x10,%esp
}
80101389:	c9                   	leave  
8010138a:	c3                   	ret    

8010138b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010138b:	55                   	push   %ebp
8010138c:	89 e5                	mov    %esp,%ebp
8010138e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101391:	8b 55 0c             	mov    0xc(%ebp),%edx
80101394:	8b 45 08             	mov    0x8(%ebp),%eax
80101397:	83 ec 08             	sub    $0x8,%esp
8010139a:	52                   	push   %edx
8010139b:	50                   	push   %eax
8010139c:	e8 13 ee ff ff       	call   801001b4 <bread>
801013a1:	83 c4 10             	add    $0x10,%esp
801013a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013aa:	83 c0 18             	add    $0x18,%eax
801013ad:	83 ec 04             	sub    $0x4,%esp
801013b0:	68 00 02 00 00       	push   $0x200
801013b5:	6a 00                	push   $0x0
801013b7:	50                   	push   %eax
801013b8:	e8 d6 3d 00 00       	call   80105193 <memset>
801013bd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013c0:	83 ec 0c             	sub    $0xc,%esp
801013c3:	ff 75 f4             	pushl  -0xc(%ebp)
801013c6:	e8 1a 23 00 00       	call   801036e5 <log_write>
801013cb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ce:	83 ec 0c             	sub    $0xc,%esp
801013d1:	ff 75 f4             	pushl  -0xc(%ebp)
801013d4:	e8 52 ee ff ff       	call   8010022b <brelse>
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	c9                   	leave  
801013dd:	c3                   	ret    

801013de <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013de:	55                   	push   %ebp
801013df:	89 e5                	mov    %esp,%ebp
801013e1:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013eb:	8b 45 08             	mov    0x8(%ebp),%eax
801013ee:	83 ec 08             	sub    $0x8,%esp
801013f1:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013f4:	52                   	push   %edx
801013f5:	50                   	push   %eax
801013f6:	e8 4f ff ff ff       	call   8010134a <readsb>
801013fb:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801013fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101405:	e9 0c 01 00 00       	jmp    80101516 <balloc+0x138>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010140a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140d:	99                   	cltd   
8010140e:	c1 ea 14             	shr    $0x14,%edx
80101411:	01 d0                	add    %edx,%eax
80101413:	c1 f8 0c             	sar    $0xc,%eax
80101416:	89 c2                	mov    %eax,%edx
80101418:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010141b:	c1 e8 03             	shr    $0x3,%eax
8010141e:	01 d0                	add    %edx,%eax
80101420:	83 c0 03             	add    $0x3,%eax
80101423:	83 ec 08             	sub    $0x8,%esp
80101426:	50                   	push   %eax
80101427:	ff 75 08             	pushl  0x8(%ebp)
8010142a:	e8 85 ed ff ff       	call   801001b4 <bread>
8010142f:	83 c4 10             	add    $0x10,%esp
80101432:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010143c:	e9 a2 00 00 00       	jmp    801014e3 <balloc+0x105>
      m = 1 << (bi % 8);
80101441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101444:	99                   	cltd   
80101445:	c1 ea 1d             	shr    $0x1d,%edx
80101448:	01 d0                	add    %edx,%eax
8010144a:	83 e0 07             	and    $0x7,%eax
8010144d:	29 d0                	sub    %edx,%eax
8010144f:	ba 01 00 00 00       	mov    $0x1,%edx
80101454:	89 c1                	mov    %eax,%ecx
80101456:	d3 e2                	shl    %cl,%edx
80101458:	89 d0                	mov    %edx,%eax
8010145a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101460:	99                   	cltd   
80101461:	c1 ea 1d             	shr    $0x1d,%edx
80101464:	01 d0                	add    %edx,%eax
80101466:	c1 f8 03             	sar    $0x3,%eax
80101469:	89 c2                	mov    %eax,%edx
8010146b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010146e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101473:	0f b6 c0             	movzbl %al,%eax
80101476:	23 45 e8             	and    -0x18(%ebp),%eax
80101479:	85 c0                	test   %eax,%eax
8010147b:	75 62                	jne    801014df <balloc+0x101>
        bp->data[bi/8] |= m;  // Mark block in use.
8010147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101480:	99                   	cltd   
80101481:	c1 ea 1d             	shr    $0x1d,%edx
80101484:	01 d0                	add    %edx,%eax
80101486:	c1 f8 03             	sar    $0x3,%eax
80101489:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010148c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101491:	89 d1                	mov    %edx,%ecx
80101493:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101496:	09 ca                	or     %ecx,%edx
80101498:	89 d1                	mov    %edx,%ecx
8010149a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010149d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	ff 75 ec             	pushl  -0x14(%ebp)
801014a7:	e8 39 22 00 00       	call   801036e5 <log_write>
801014ac:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	ff 75 ec             	pushl  -0x14(%ebp)
801014b5:	e8 71 ed ff ff       	call   8010022b <brelse>
801014ba:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c3:	01 c2                	add    %eax,%edx
801014c5:	8b 45 08             	mov    0x8(%ebp),%eax
801014c8:	83 ec 08             	sub    $0x8,%esp
801014cb:	52                   	push   %edx
801014cc:	50                   	push   %eax
801014cd:	e8 b9 fe ff ff       	call   8010138b <bzero>
801014d2:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014db:	01 d0                	add    %edx,%eax
801014dd:	eb 52                	jmp    80101531 <balloc+0x153>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014e3:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014ea:	7f 15                	jg     80101501 <balloc+0x123>
801014ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f2:	01 d0                	add    %edx,%eax
801014f4:	89 c2                	mov    %eax,%edx
801014f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014f9:	39 c2                	cmp    %eax,%edx
801014fb:	0f 82 40 ff ff ff    	jb     80101441 <balloc+0x63>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101501:	83 ec 0c             	sub    $0xc,%esp
80101504:	ff 75 ec             	pushl  -0x14(%ebp)
80101507:	e8 1f ed ff ff       	call   8010022b <brelse>
8010150c:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
8010150f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101519:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010151c:	39 c2                	cmp    %eax,%edx
8010151e:	0f 82 e6 fe ff ff    	jb     8010140a <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	68 d9 84 10 80       	push   $0x801084d9
8010152c:	e8 2b f0 ff ff       	call   8010055c <panic>
}
80101531:	c9                   	leave  
80101532:	c3                   	ret    

80101533 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101533:	55                   	push   %ebp
80101534:	89 e5                	mov    %esp,%ebp
80101536:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010153f:	50                   	push   %eax
80101540:	ff 75 08             	pushl  0x8(%ebp)
80101543:	e8 02 fe ff ff       	call   8010134a <readsb>
80101548:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010154b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010154e:	c1 e8 0c             	shr    $0xc,%eax
80101551:	89 c2                	mov    %eax,%edx
80101553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101556:	c1 e8 03             	shr    $0x3,%eax
80101559:	01 d0                	add    %edx,%eax
8010155b:	8d 50 03             	lea    0x3(%eax),%edx
8010155e:	8b 45 08             	mov    0x8(%ebp),%eax
80101561:	83 ec 08             	sub    $0x8,%esp
80101564:	52                   	push   %edx
80101565:	50                   	push   %eax
80101566:	e8 49 ec ff ff       	call   801001b4 <bread>
8010156b:	83 c4 10             	add    $0x10,%esp
8010156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101571:	8b 45 0c             	mov    0xc(%ebp),%eax
80101574:	25 ff 0f 00 00       	and    $0xfff,%eax
80101579:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157f:	99                   	cltd   
80101580:	c1 ea 1d             	shr    $0x1d,%edx
80101583:	01 d0                	add    %edx,%eax
80101585:	83 e0 07             	and    $0x7,%eax
80101588:	29 d0                	sub    %edx,%eax
8010158a:	ba 01 00 00 00       	mov    $0x1,%edx
8010158f:	89 c1                	mov    %eax,%ecx
80101591:	d3 e2                	shl    %cl,%edx
80101593:	89 d0                	mov    %edx,%eax
80101595:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159b:	99                   	cltd   
8010159c:	c1 ea 1d             	shr    $0x1d,%edx
8010159f:	01 d0                	add    %edx,%eax
801015a1:	c1 f8 03             	sar    $0x3,%eax
801015a4:	89 c2                	mov    %eax,%edx
801015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a9:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015ae:	0f b6 c0             	movzbl %al,%eax
801015b1:	23 45 ec             	and    -0x14(%ebp),%eax
801015b4:	85 c0                	test   %eax,%eax
801015b6:	75 0d                	jne    801015c5 <bfree+0x92>
    panic("freeing free block");
801015b8:	83 ec 0c             	sub    $0xc,%esp
801015bb:	68 ef 84 10 80       	push   $0x801084ef
801015c0:	e8 97 ef ff ff       	call   8010055c <panic>
  bp->data[bi/8] &= ~m;
801015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c8:	99                   	cltd   
801015c9:	c1 ea 1d             	shr    $0x1d,%edx
801015cc:	01 d0                	add    %edx,%eax
801015ce:	c1 f8 03             	sar    $0x3,%eax
801015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d4:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015d9:	89 d1                	mov    %edx,%ecx
801015db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015de:	f7 d2                	not    %edx
801015e0:	21 ca                	and    %ecx,%edx
801015e2:	89 d1                	mov    %edx,%ecx
801015e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015e7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	ff 75 f4             	pushl  -0xc(%ebp)
801015f1:	e8 ef 20 00 00       	call   801036e5 <log_write>
801015f6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015f9:	83 ec 0c             	sub    $0xc,%esp
801015fc:	ff 75 f4             	pushl  -0xc(%ebp)
801015ff:	e8 27 ec ff ff       	call   8010022b <brelse>
80101604:	83 c4 10             	add    $0x10,%esp
}
80101607:	c9                   	leave  
80101608:	c3                   	ret    

80101609 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101609:	55                   	push   %ebp
8010160a:	89 e5                	mov    %esp,%ebp
8010160c:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	68 02 85 10 80       	push   $0x80108502
80101617:	68 c0 12 11 80       	push   $0x801112c0
8010161c:	e8 f5 38 00 00       	call   80104f16 <initlock>
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	c9                   	leave  
80101625:	c3                   	ret    

80101626 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101626:	55                   	push   %ebp
80101627:	89 e5                	mov    %esp,%ebp
80101629:	83 ec 38             	sub    $0x38,%esp
8010162c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101633:	8b 45 08             	mov    0x8(%ebp),%eax
80101636:	83 ec 08             	sub    $0x8,%esp
80101639:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010163c:	52                   	push   %edx
8010163d:	50                   	push   %eax
8010163e:	e8 07 fd ff ff       	call   8010134a <readsb>
80101643:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101646:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010164d:	e9 98 00 00 00       	jmp    801016ea <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
80101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101655:	c1 e8 03             	shr    $0x3,%eax
80101658:	83 c0 02             	add    $0x2,%eax
8010165b:	83 ec 08             	sub    $0x8,%esp
8010165e:	50                   	push   %eax
8010165f:	ff 75 08             	pushl  0x8(%ebp)
80101662:	e8 4d eb ff ff       	call   801001b4 <bread>
80101667:	83 c4 10             	add    $0x10,%esp
8010166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101670:	8d 50 18             	lea    0x18(%eax),%edx
80101673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101676:	83 e0 07             	and    $0x7,%eax
80101679:	c1 e0 06             	shl    $0x6,%eax
8010167c:	01 d0                	add    %edx,%eax
8010167e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101681:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101684:	0f b7 00             	movzwl (%eax),%eax
80101687:	66 85 c0             	test   %ax,%ax
8010168a:	75 4c                	jne    801016d8 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
8010168c:	83 ec 04             	sub    $0x4,%esp
8010168f:	6a 40                	push   $0x40
80101691:	6a 00                	push   $0x0
80101693:	ff 75 ec             	pushl  -0x14(%ebp)
80101696:	e8 f8 3a 00 00       	call   80105193 <memset>
8010169b:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016a1:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016a5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016a8:	83 ec 0c             	sub    $0xc,%esp
801016ab:	ff 75 f0             	pushl  -0x10(%ebp)
801016ae:	e8 32 20 00 00       	call   801036e5 <log_write>
801016b3:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016b6:	83 ec 0c             	sub    $0xc,%esp
801016b9:	ff 75 f0             	pushl  -0x10(%ebp)
801016bc:	e8 6a eb ff ff       	call   8010022b <brelse>
801016c1:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c7:	83 ec 08             	sub    $0x8,%esp
801016ca:	50                   	push   %eax
801016cb:	ff 75 08             	pushl  0x8(%ebp)
801016ce:	e8 ee 00 00 00       	call   801017c1 <iget>
801016d3:	83 c4 10             	add    $0x10,%esp
801016d6:	eb 2d                	jmp    80101705 <ialloc+0xdf>
    }
    brelse(bp);
801016d8:	83 ec 0c             	sub    $0xc,%esp
801016db:	ff 75 f0             	pushl  -0x10(%ebp)
801016de:	e8 48 eb ff ff       	call   8010022b <brelse>
801016e3:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016f0:	39 c2                	cmp    %eax,%edx
801016f2:	0f 82 5a ff ff ff    	jb     80101652 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	68 09 85 10 80       	push   $0x80108509
80101700:	e8 57 ee ff ff       	call   8010055c <panic>
}
80101705:	c9                   	leave  
80101706:	c3                   	ret    

80101707 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101707:	55                   	push   %ebp
80101708:	89 e5                	mov    %esp,%ebp
8010170a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010170d:	8b 45 08             	mov    0x8(%ebp),%eax
80101710:	8b 40 04             	mov    0x4(%eax),%eax
80101713:	c1 e8 03             	shr    $0x3,%eax
80101716:	8d 50 02             	lea    0x2(%eax),%edx
80101719:	8b 45 08             	mov    0x8(%ebp),%eax
8010171c:	8b 00                	mov    (%eax),%eax
8010171e:	83 ec 08             	sub    $0x8,%esp
80101721:	52                   	push   %edx
80101722:	50                   	push   %eax
80101723:	e8 8c ea ff ff       	call   801001b4 <bread>
80101728:	83 c4 10             	add    $0x10,%esp
8010172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101731:	8d 50 18             	lea    0x18(%eax),%edx
80101734:	8b 45 08             	mov    0x8(%ebp),%eax
80101737:	8b 40 04             	mov    0x4(%eax),%eax
8010173a:	83 e0 07             	and    $0x7,%eax
8010173d:	c1 e0 06             	shl    $0x6,%eax
80101740:	01 d0                	add    %edx,%eax
80101742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101745:	8b 45 08             	mov    0x8(%ebp),%eax
80101748:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101752:	8b 45 08             	mov    0x8(%ebp),%eax
80101755:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101759:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101760:	8b 45 08             	mov    0x8(%ebp),%eax
80101763:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010176e:	8b 45 08             	mov    0x8(%ebp),%eax
80101771:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101778:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010177c:	8b 45 08             	mov    0x8(%ebp),%eax
8010177f:	8b 50 18             	mov    0x18(%eax),%edx
80101782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101785:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101788:	8b 45 08             	mov    0x8(%ebp),%eax
8010178b:	8d 50 1c             	lea    0x1c(%eax),%edx
8010178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101791:	83 c0 0c             	add    $0xc,%eax
80101794:	83 ec 04             	sub    $0x4,%esp
80101797:	6a 34                	push   $0x34
80101799:	52                   	push   %edx
8010179a:	50                   	push   %eax
8010179b:	e8 b2 3a 00 00       	call   80105252 <memmove>
801017a0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017a3:	83 ec 0c             	sub    $0xc,%esp
801017a6:	ff 75 f4             	pushl  -0xc(%ebp)
801017a9:	e8 37 1f 00 00       	call   801036e5 <log_write>
801017ae:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017b1:	83 ec 0c             	sub    $0xc,%esp
801017b4:	ff 75 f4             	pushl  -0xc(%ebp)
801017b7:	e8 6f ea ff ff       	call   8010022b <brelse>
801017bc:	83 c4 10             	add    $0x10,%esp
}
801017bf:	c9                   	leave  
801017c0:	c3                   	ret    

801017c1 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017c1:	55                   	push   %ebp
801017c2:	89 e5                	mov    %esp,%ebp
801017c4:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017c7:	83 ec 0c             	sub    $0xc,%esp
801017ca:	68 c0 12 11 80       	push   $0x801112c0
801017cf:	e8 63 37 00 00       	call   80104f37 <acquire>
801017d4:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801017d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017de:	c7 45 f4 f4 12 11 80 	movl   $0x801112f4,-0xc(%ebp)
801017e5:	eb 5d                	jmp    80101844 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ea:	8b 40 08             	mov    0x8(%eax),%eax
801017ed:	85 c0                	test   %eax,%eax
801017ef:	7e 39                	jle    8010182a <iget+0x69>
801017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f4:	8b 00                	mov    (%eax),%eax
801017f6:	3b 45 08             	cmp    0x8(%ebp),%eax
801017f9:	75 2f                	jne    8010182a <iget+0x69>
801017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fe:	8b 40 04             	mov    0x4(%eax),%eax
80101801:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101804:	75 24                	jne    8010182a <iget+0x69>
      ip->ref++;
80101806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101809:	8b 40 08             	mov    0x8(%eax),%eax
8010180c:	8d 50 01             	lea    0x1(%eax),%edx
8010180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101812:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101815:	83 ec 0c             	sub    $0xc,%esp
80101818:	68 c0 12 11 80       	push   $0x801112c0
8010181d:	e8 7b 37 00 00       	call   80104f9d <release>
80101822:	83 c4 10             	add    $0x10,%esp
      return ip;
80101825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101828:	eb 74                	jmp    8010189e <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010182a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010182e:	75 10                	jne    80101840 <iget+0x7f>
80101830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101833:	8b 40 08             	mov    0x8(%eax),%eax
80101836:	85 c0                	test   %eax,%eax
80101838:	75 06                	jne    80101840 <iget+0x7f>
      empty = ip;
8010183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101840:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101844:	81 7d f4 94 22 11 80 	cmpl   $0x80112294,-0xc(%ebp)
8010184b:	72 9a                	jb     801017e7 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010184d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101851:	75 0d                	jne    80101860 <iget+0x9f>
    panic("iget: no inodes");
80101853:	83 ec 0c             	sub    $0xc,%esp
80101856:	68 1b 85 10 80       	push   $0x8010851b
8010185b:	e8 fc ec ff ff       	call   8010055c <panic>

  ip = empty;
80101860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101863:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101869:	8b 55 08             	mov    0x8(%ebp),%edx
8010186c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101871:	8b 55 0c             	mov    0xc(%ebp),%edx
80101874:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010188b:	83 ec 0c             	sub    $0xc,%esp
8010188e:	68 c0 12 11 80       	push   $0x801112c0
80101893:	e8 05 37 00 00       	call   80104f9d <release>
80101898:	83 c4 10             	add    $0x10,%esp

  return ip;
8010189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010189e:	c9                   	leave  
8010189f:	c3                   	ret    

801018a0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	68 c0 12 11 80       	push   $0x801112c0
801018ae:	e8 84 36 00 00       	call   80104f37 <acquire>
801018b3:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	8b 40 08             	mov    0x8(%eax),%eax
801018bc:	8d 50 01             	lea    0x1(%eax),%edx
801018bf:	8b 45 08             	mov    0x8(%ebp),%eax
801018c2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	68 c0 12 11 80       	push   $0x801112c0
801018cd:	e8 cb 36 00 00       	call   80104f9d <release>
801018d2:	83 c4 10             	add    $0x10,%esp
  return ip;
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018d8:	c9                   	leave  
801018d9:	c3                   	ret    

801018da <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018da:	55                   	push   %ebp
801018db:	89 e5                	mov    %esp,%ebp
801018dd:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018e4:	74 0a                	je     801018f0 <ilock+0x16>
801018e6:	8b 45 08             	mov    0x8(%ebp),%eax
801018e9:	8b 40 08             	mov    0x8(%eax),%eax
801018ec:	85 c0                	test   %eax,%eax
801018ee:	7f 0d                	jg     801018fd <ilock+0x23>
    panic("ilock");
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 2b 85 10 80       	push   $0x8010852b
801018f8:	e8 5f ec ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
801018fd:	83 ec 0c             	sub    $0xc,%esp
80101900:	68 c0 12 11 80       	push   $0x801112c0
80101905:	e8 2d 36 00 00       	call   80104f37 <acquire>
8010190a:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010190d:	eb 13                	jmp    80101922 <ilock+0x48>
    sleep(ip, &icache.lock);
8010190f:	83 ec 08             	sub    $0x8,%esp
80101912:	68 c0 12 11 80       	push   $0x801112c0
80101917:	ff 75 08             	pushl  0x8(%ebp)
8010191a:	e8 28 33 00 00       	call   80104c47 <sleep>
8010191f:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101922:	8b 45 08             	mov    0x8(%ebp),%eax
80101925:	8b 40 0c             	mov    0xc(%eax),%eax
80101928:	83 e0 01             	and    $0x1,%eax
8010192b:	85 c0                	test   %eax,%eax
8010192d:	75 e0                	jne    8010190f <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010192f:	8b 45 08             	mov    0x8(%ebp),%eax
80101932:	8b 40 0c             	mov    0xc(%eax),%eax
80101935:	83 c8 01             	or     $0x1,%eax
80101938:	89 c2                	mov    %eax,%edx
8010193a:	8b 45 08             	mov    0x8(%ebp),%eax
8010193d:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101940:	83 ec 0c             	sub    $0xc,%esp
80101943:	68 c0 12 11 80       	push   $0x801112c0
80101948:	e8 50 36 00 00       	call   80104f9d <release>
8010194d:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101950:	8b 45 08             	mov    0x8(%ebp),%eax
80101953:	8b 40 0c             	mov    0xc(%eax),%eax
80101956:	83 e0 02             	and    $0x2,%eax
80101959:	85 c0                	test   %eax,%eax
8010195b:	0f 85 ce 00 00 00    	jne    80101a2f <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101961:	8b 45 08             	mov    0x8(%ebp),%eax
80101964:	8b 40 04             	mov    0x4(%eax),%eax
80101967:	c1 e8 03             	shr    $0x3,%eax
8010196a:	8d 50 02             	lea    0x2(%eax),%edx
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
80101970:	8b 00                	mov    (%eax),%eax
80101972:	83 ec 08             	sub    $0x8,%esp
80101975:	52                   	push   %edx
80101976:	50                   	push   %eax
80101977:	e8 38 e8 ff ff       	call   801001b4 <bread>
8010197c:	83 c4 10             	add    $0x10,%esp
8010197f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101985:	8d 50 18             	lea    0x18(%eax),%edx
80101988:	8b 45 08             	mov    0x8(%ebp),%eax
8010198b:	8b 40 04             	mov    0x4(%eax),%eax
8010198e:	83 e0 07             	and    $0x7,%eax
80101991:	c1 e0 06             	shl    $0x6,%eax
80101994:	01 d0                	add    %edx,%eax
80101996:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199c:	0f b7 10             	movzwl (%eax),%edx
8010199f:	8b 45 08             	mov    0x8(%ebp),%eax
801019a2:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a9:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b7:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019bb:	8b 45 08             	mov    0x8(%ebp),%eax
801019be:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019c9:	8b 45 08             	mov    0x8(%ebp),%eax
801019cc:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d3:	8b 50 08             	mov    0x8(%eax),%edx
801019d6:	8b 45 08             	mov    0x8(%ebp),%eax
801019d9:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019df:	8d 50 0c             	lea    0xc(%eax),%edx
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	83 c0 1c             	add    $0x1c,%eax
801019e8:	83 ec 04             	sub    $0x4,%esp
801019eb:	6a 34                	push   $0x34
801019ed:	52                   	push   %edx
801019ee:	50                   	push   %eax
801019ef:	e8 5e 38 00 00       	call   80105252 <memmove>
801019f4:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801019f7:	83 ec 0c             	sub    $0xc,%esp
801019fa:	ff 75 f4             	pushl  -0xc(%ebp)
801019fd:	e8 29 e8 ff ff       	call   8010022b <brelse>
80101a02:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a05:	8b 45 08             	mov    0x8(%ebp),%eax
80101a08:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0b:	83 c8 02             	or     $0x2,%eax
80101a0e:	89 c2                	mov    %eax,%edx
80101a10:	8b 45 08             	mov    0x8(%ebp),%eax
80101a13:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a16:	8b 45 08             	mov    0x8(%ebp),%eax
80101a19:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a1d:	66 85 c0             	test   %ax,%ax
80101a20:	75 0d                	jne    80101a2f <ilock+0x155>
      panic("ilock: no type");
80101a22:	83 ec 0c             	sub    $0xc,%esp
80101a25:	68 31 85 10 80       	push   $0x80108531
80101a2a:	e8 2d eb ff ff       	call   8010055c <panic>
  }
}
80101a2f:	c9                   	leave  
80101a30:	c3                   	ret    

80101a31 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a31:	55                   	push   %ebp
80101a32:	89 e5                	mov    %esp,%ebp
80101a34:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a3b:	74 17                	je     80101a54 <iunlock+0x23>
80101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a40:	8b 40 0c             	mov    0xc(%eax),%eax
80101a43:	83 e0 01             	and    $0x1,%eax
80101a46:	85 c0                	test   %eax,%eax
80101a48:	74 0a                	je     80101a54 <iunlock+0x23>
80101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4d:	8b 40 08             	mov    0x8(%eax),%eax
80101a50:	85 c0                	test   %eax,%eax
80101a52:	7f 0d                	jg     80101a61 <iunlock+0x30>
    panic("iunlock");
80101a54:	83 ec 0c             	sub    $0xc,%esp
80101a57:	68 40 85 10 80       	push   $0x80108540
80101a5c:	e8 fb ea ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101a61:	83 ec 0c             	sub    $0xc,%esp
80101a64:	68 c0 12 11 80       	push   $0x801112c0
80101a69:	e8 c9 34 00 00       	call   80104f37 <acquire>
80101a6e:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 40 0c             	mov    0xc(%eax),%eax
80101a77:	83 e0 fe             	and    $0xfffffffe,%eax
80101a7a:	89 c2                	mov    %eax,%edx
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a82:	83 ec 0c             	sub    $0xc,%esp
80101a85:	ff 75 08             	pushl  0x8(%ebp)
80101a88:	e8 a3 32 00 00       	call   80104d30 <wakeup>
80101a8d:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101a90:	83 ec 0c             	sub    $0xc,%esp
80101a93:	68 c0 12 11 80       	push   $0x801112c0
80101a98:	e8 00 35 00 00       	call   80104f9d <release>
80101a9d:	83 c4 10             	add    $0x10,%esp
}
80101aa0:	c9                   	leave  
80101aa1:	c3                   	ret    

80101aa2 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101aa2:	55                   	push   %ebp
80101aa3:	89 e5                	mov    %esp,%ebp
80101aa5:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101aa8:	83 ec 0c             	sub    $0xc,%esp
80101aab:	68 c0 12 11 80       	push   $0x801112c0
80101ab0:	e8 82 34 00 00       	call   80104f37 <acquire>
80101ab5:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80101abb:	8b 40 08             	mov    0x8(%eax),%eax
80101abe:	83 f8 01             	cmp    $0x1,%eax
80101ac1:	0f 85 a9 00 00 00    	jne    80101b70 <iput+0xce>
80101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aca:	8b 40 0c             	mov    0xc(%eax),%eax
80101acd:	83 e0 02             	and    $0x2,%eax
80101ad0:	85 c0                	test   %eax,%eax
80101ad2:	0f 84 98 00 00 00    	je     80101b70 <iput+0xce>
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101adf:	66 85 c0             	test   %ax,%ax
80101ae2:	0f 85 88 00 00 00    	jne    80101b70 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	8b 40 0c             	mov    0xc(%eax),%eax
80101aee:	83 e0 01             	and    $0x1,%eax
80101af1:	85 c0                	test   %eax,%eax
80101af3:	74 0d                	je     80101b02 <iput+0x60>
      panic("iput busy");
80101af5:	83 ec 0c             	sub    $0xc,%esp
80101af8:	68 48 85 10 80       	push   $0x80108548
80101afd:	e8 5a ea ff ff       	call   8010055c <panic>
    ip->flags |= I_BUSY;
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	8b 40 0c             	mov    0xc(%eax),%eax
80101b08:	83 c8 01             	or     $0x1,%eax
80101b0b:	89 c2                	mov    %eax,%edx
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b13:	83 ec 0c             	sub    $0xc,%esp
80101b16:	68 c0 12 11 80       	push   $0x801112c0
80101b1b:	e8 7d 34 00 00       	call   80104f9d <release>
80101b20:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	ff 75 08             	pushl  0x8(%ebp)
80101b29:	e8 a6 01 00 00       	call   80101cd4 <itrunc>
80101b2e:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b3a:	83 ec 0c             	sub    $0xc,%esp
80101b3d:	ff 75 08             	pushl  0x8(%ebp)
80101b40:	e8 c2 fb ff ff       	call   80101707 <iupdate>
80101b45:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b48:	83 ec 0c             	sub    $0xc,%esp
80101b4b:	68 c0 12 11 80       	push   $0x801112c0
80101b50:	e8 e2 33 00 00       	call   80104f37 <acquire>
80101b55:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b58:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b62:	83 ec 0c             	sub    $0xc,%esp
80101b65:	ff 75 08             	pushl  0x8(%ebp)
80101b68:	e8 c3 31 00 00       	call   80104d30 <wakeup>
80101b6d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101b70:	8b 45 08             	mov    0x8(%ebp),%eax
80101b73:	8b 40 08             	mov    0x8(%eax),%eax
80101b76:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b79:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b7f:	83 ec 0c             	sub    $0xc,%esp
80101b82:	68 c0 12 11 80       	push   $0x801112c0
80101b87:	e8 11 34 00 00       	call   80104f9d <release>
80101b8c:	83 c4 10             	add    $0x10,%esp
}
80101b8f:	c9                   	leave  
80101b90:	c3                   	ret    

80101b91 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b91:	55                   	push   %ebp
80101b92:	89 e5                	mov    %esp,%ebp
80101b94:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	ff 75 08             	pushl  0x8(%ebp)
80101b9d:	e8 8f fe ff ff       	call   80101a31 <iunlock>
80101ba2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101ba5:	83 ec 0c             	sub    $0xc,%esp
80101ba8:	ff 75 08             	pushl  0x8(%ebp)
80101bab:	e8 f2 fe ff ff       	call   80101aa2 <iput>
80101bb0:	83 c4 10             	add    $0x10,%esp
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    

80101bb5 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bb5:	55                   	push   %ebp
80101bb6:	89 e5                	mov    %esp,%ebp
80101bb8:	53                   	push   %ebx
80101bb9:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bbc:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bc0:	77 42                	ja     80101c04 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bc8:	83 c2 04             	add    $0x4,%edx
80101bcb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bd6:	75 24                	jne    80101bfc <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdb:	8b 00                	mov    (%eax),%eax
80101bdd:	83 ec 0c             	sub    $0xc,%esp
80101be0:	50                   	push   %eax
80101be1:	e8 f8 f7 ff ff       	call   801013de <balloc>
80101be6:	83 c4 10             	add    $0x10,%esp
80101be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bec:	8b 45 08             	mov    0x8(%ebp),%eax
80101bef:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bf2:	8d 4a 04             	lea    0x4(%edx),%ecx
80101bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bf8:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bff:	e9 cb 00 00 00       	jmp    80101ccf <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c04:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c08:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c0c:	0f 87 b0 00 00 00    	ja     80101cc2 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c12:	8b 45 08             	mov    0x8(%ebp),%eax
80101c15:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c1f:	75 1d                	jne    80101c3e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	8b 00                	mov    (%eax),%eax
80101c26:	83 ec 0c             	sub    $0xc,%esp
80101c29:	50                   	push   %eax
80101c2a:	e8 af f7 ff ff       	call   801013de <balloc>
80101c2f:	83 c4 10             	add    $0x10,%esp
80101c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c35:	8b 45 08             	mov    0x8(%ebp),%eax
80101c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c41:	8b 00                	mov    (%eax),%eax
80101c43:	83 ec 08             	sub    $0x8,%esp
80101c46:	ff 75 f4             	pushl  -0xc(%ebp)
80101c49:	50                   	push   %eax
80101c4a:	e8 65 e5 ff ff       	call   801001b4 <bread>
80101c4f:	83 c4 10             	add    $0x10,%esp
80101c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c58:	83 c0 18             	add    $0x18,%eax
80101c5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c6b:	01 d0                	add    %edx,%eax
80101c6d:	8b 00                	mov    (%eax),%eax
80101c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c76:	75 37                	jne    80101caf <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101c78:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c7b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c85:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c88:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8b:	8b 00                	mov    (%eax),%eax
80101c8d:	83 ec 0c             	sub    $0xc,%esp
80101c90:	50                   	push   %eax
80101c91:	e8 48 f7 ff ff       	call   801013de <balloc>
80101c96:	83 c4 10             	add    $0x10,%esp
80101c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c9f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ca1:	83 ec 0c             	sub    $0xc,%esp
80101ca4:	ff 75 f0             	pushl  -0x10(%ebp)
80101ca7:	e8 39 1a 00 00       	call   801036e5 <log_write>
80101cac:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101caf:	83 ec 0c             	sub    $0xc,%esp
80101cb2:	ff 75 f0             	pushl  -0x10(%ebp)
80101cb5:	e8 71 e5 ff ff       	call   8010022b <brelse>
80101cba:	83 c4 10             	add    $0x10,%esp
    return addr;
80101cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc0:	eb 0d                	jmp    80101ccf <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	68 52 85 10 80       	push   $0x80108552
80101cca:	e8 8d e8 ff ff       	call   8010055c <panic>
}
80101ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cd2:	c9                   	leave  
80101cd3:	c3                   	ret    

80101cd4 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ce1:	eb 45                	jmp    80101d28 <itrunc+0x54>
    if(ip->addrs[i]){
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ce9:	83 c2 04             	add    $0x4,%edx
80101cec:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cf0:	85 c0                	test   %eax,%eax
80101cf2:	74 30                	je     80101d24 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfa:	83 c2 04             	add    $0x4,%edx
80101cfd:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d01:	8b 55 08             	mov    0x8(%ebp),%edx
80101d04:	8b 12                	mov    (%edx),%edx
80101d06:	83 ec 08             	sub    $0x8,%esp
80101d09:	50                   	push   %eax
80101d0a:	52                   	push   %edx
80101d0b:	e8 23 f8 ff ff       	call   80101533 <bfree>
80101d10:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d13:	8b 45 08             	mov    0x8(%ebp),%eax
80101d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d19:	83 c2 04             	add    $0x4,%edx
80101d1c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d23:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d28:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d2c:	7e b5                	jle    80101ce3 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d31:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d34:	85 c0                	test   %eax,%eax
80101d36:	0f 84 a1 00 00 00    	je     80101ddd <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	8b 00                	mov    (%eax),%eax
80101d47:	83 ec 08             	sub    $0x8,%esp
80101d4a:	52                   	push   %edx
80101d4b:	50                   	push   %eax
80101d4c:	e8 63 e4 ff ff       	call   801001b4 <bread>
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d5a:	83 c0 18             	add    $0x18,%eax
80101d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d67:	eb 3c                	jmp    80101da5 <itrunc+0xd1>
      if(a[j])
80101d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d76:	01 d0                	add    %edx,%eax
80101d78:	8b 00                	mov    (%eax),%eax
80101d7a:	85 c0                	test   %eax,%eax
80101d7c:	74 23                	je     80101da1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d8b:	01 d0                	add    %edx,%eax
80101d8d:	8b 00                	mov    (%eax),%eax
80101d8f:	8b 55 08             	mov    0x8(%ebp),%edx
80101d92:	8b 12                	mov    (%edx),%edx
80101d94:	83 ec 08             	sub    $0x8,%esp
80101d97:	50                   	push   %eax
80101d98:	52                   	push   %edx
80101d99:	e8 95 f7 ff ff       	call   80101533 <bfree>
80101d9e:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101da1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da8:	83 f8 7f             	cmp    $0x7f,%eax
80101dab:	76 bc                	jbe    80101d69 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101dad:	83 ec 0c             	sub    $0xc,%esp
80101db0:	ff 75 ec             	pushl  -0x14(%ebp)
80101db3:	e8 73 e4 ff ff       	call   8010022b <brelse>
80101db8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbe:	8b 40 4c             	mov    0x4c(%eax),%eax
80101dc1:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc4:	8b 12                	mov    (%edx),%edx
80101dc6:	83 ec 08             	sub    $0x8,%esp
80101dc9:	50                   	push   %eax
80101dca:	52                   	push   %edx
80101dcb:	e8 63 f7 ff ff       	call   80101533 <bfree>
80101dd0:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80101de0:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101de7:	83 ec 0c             	sub    $0xc,%esp
80101dea:	ff 75 08             	pushl  0x8(%ebp)
80101ded:	e8 15 f9 ff ff       	call   80101707 <iupdate>
80101df2:	83 c4 10             	add    $0x10,%esp
}
80101df5:	c9                   	leave  
80101df6:	c3                   	ret    

80101df7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101df7:	55                   	push   %ebp
80101df8:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfd:	8b 00                	mov    (%eax),%eax
80101dff:	89 c2                	mov    %eax,%edx
80101e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e04:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	8b 50 04             	mov    0x4(%eax),%edx
80101e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e10:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e13:	8b 45 08             	mov    0x8(%ebp),%eax
80101e16:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1d:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2a:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e31:	8b 50 18             	mov    0x18(%eax),%edx
80101e34:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e37:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    

80101e3c <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e3c:	55                   	push   %ebp
80101e3d:	89 e5                	mov    %esp,%ebp
80101e3f:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e49:	66 83 f8 03          	cmp    $0x3,%ax
80101e4d:	75 5c                	jne    80101eab <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e52:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e56:	66 85 c0             	test   %ax,%ax
80101e59:	78 20                	js     80101e7b <readi+0x3f>
80101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e62:	66 83 f8 09          	cmp    $0x9,%ax
80101e66:	7f 13                	jg     80101e7b <readi+0x3f>
80101e68:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e6f:	98                   	cwtl   
80101e70:	8b 04 c5 40 12 11 80 	mov    -0x7feeedc0(,%eax,8),%eax
80101e77:	85 c0                	test   %eax,%eax
80101e79:	75 0a                	jne    80101e85 <readi+0x49>
      return -1;
80101e7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e80:	e9 16 01 00 00       	jmp    80101f9b <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
80101e85:	8b 45 08             	mov    0x8(%ebp),%eax
80101e88:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e8c:	98                   	cwtl   
80101e8d:	8b 04 c5 40 12 11 80 	mov    -0x7feeedc0(,%eax,8),%eax
80101e94:	8b 55 14             	mov    0x14(%ebp),%edx
80101e97:	83 ec 04             	sub    $0x4,%esp
80101e9a:	52                   	push   %edx
80101e9b:	ff 75 0c             	pushl  0xc(%ebp)
80101e9e:	ff 75 08             	pushl  0x8(%ebp)
80101ea1:	ff d0                	call   *%eax
80101ea3:	83 c4 10             	add    $0x10,%esp
80101ea6:	e9 f0 00 00 00       	jmp    80101f9b <readi+0x15f>
  }

  if(off > ip->size || off + n < off)
80101eab:	8b 45 08             	mov    0x8(%ebp),%eax
80101eae:	8b 40 18             	mov    0x18(%eax),%eax
80101eb1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eb4:	72 0d                	jb     80101ec3 <readi+0x87>
80101eb6:	8b 55 10             	mov    0x10(%ebp),%edx
80101eb9:	8b 45 14             	mov    0x14(%ebp),%eax
80101ebc:	01 d0                	add    %edx,%eax
80101ebe:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ec1:	73 0a                	jae    80101ecd <readi+0x91>
    return -1;
80101ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec8:	e9 ce 00 00 00       	jmp    80101f9b <readi+0x15f>
  if(off + n > ip->size)
80101ecd:	8b 55 10             	mov    0x10(%ebp),%edx
80101ed0:	8b 45 14             	mov    0x14(%ebp),%eax
80101ed3:	01 c2                	add    %eax,%edx
80101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed8:	8b 40 18             	mov    0x18(%eax),%eax
80101edb:	39 c2                	cmp    %eax,%edx
80101edd:	76 0c                	jbe    80101eeb <readi+0xaf>
    n = ip->size - off;
80101edf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee2:	8b 40 18             	mov    0x18(%eax),%eax
80101ee5:	2b 45 10             	sub    0x10(%ebp),%eax
80101ee8:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ef2:	e9 95 00 00 00       	jmp    80101f8c <readi+0x150>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ef7:	8b 45 10             	mov    0x10(%ebp),%eax
80101efa:	c1 e8 09             	shr    $0x9,%eax
80101efd:	83 ec 08             	sub    $0x8,%esp
80101f00:	50                   	push   %eax
80101f01:	ff 75 08             	pushl  0x8(%ebp)
80101f04:	e8 ac fc ff ff       	call   80101bb5 <bmap>
80101f09:	83 c4 10             	add    $0x10,%esp
80101f0c:	89 c2                	mov    %eax,%edx
80101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f11:	8b 00                	mov    (%eax),%eax
80101f13:	83 ec 08             	sub    $0x8,%esp
80101f16:	52                   	push   %edx
80101f17:	50                   	push   %eax
80101f18:	e8 97 e2 ff ff       	call   801001b4 <bread>
80101f1d:	83 c4 10             	add    $0x10,%esp
80101f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f23:	8b 45 10             	mov    0x10(%ebp),%eax
80101f26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f2b:	ba 00 02 00 00       	mov    $0x200,%edx
80101f30:	89 d1                	mov    %edx,%ecx
80101f32:	29 c1                	sub    %eax,%ecx
80101f34:	8b 45 14             	mov    0x14(%ebp),%eax
80101f37:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f3a:	89 c2                	mov    %eax,%edx
80101f3c:	89 c8                	mov    %ecx,%eax
80101f3e:	39 d0                	cmp    %edx,%eax
80101f40:	76 02                	jbe    80101f44 <readi+0x108>
80101f42:	89 d0                	mov    %edx,%eax
80101f44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f47:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f4f:	8d 50 10             	lea    0x10(%eax),%edx
80101f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f55:	01 d0                	add    %edx,%eax
80101f57:	83 c0 08             	add    $0x8,%eax
80101f5a:	83 ec 04             	sub    $0x4,%esp
80101f5d:	ff 75 ec             	pushl  -0x14(%ebp)
80101f60:	50                   	push   %eax
80101f61:	ff 75 0c             	pushl  0xc(%ebp)
80101f64:	e8 e9 32 00 00       	call   80105252 <memmove>
80101f69:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f6c:	83 ec 0c             	sub    $0xc,%esp
80101f6f:	ff 75 f0             	pushl  -0x10(%ebp)
80101f72:	e8 b4 e2 ff ff       	call   8010022b <brelse>
80101f77:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f7d:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f83:	01 45 10             	add    %eax,0x10(%ebp)
80101f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f89:	01 45 0c             	add    %eax,0xc(%ebp)
80101f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f8f:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f92:	0f 82 5f ff ff ff    	jb     80101ef7 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f98:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f9b:	c9                   	leave  
80101f9c:	c3                   	ret    

80101f9d <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f9d:	55                   	push   %ebp
80101f9e:	89 e5                	mov    %esp,%ebp
80101fa0:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101faa:	66 83 f8 03          	cmp    $0x3,%ax
80101fae:	75 5c                	jne    8010200c <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb7:	66 85 c0             	test   %ax,%ax
80101fba:	78 20                	js     80101fdc <writei+0x3f>
80101fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fc3:	66 83 f8 09          	cmp    $0x9,%ax
80101fc7:	7f 13                	jg     80101fdc <writei+0x3f>
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fd0:	98                   	cwtl   
80101fd1:	8b 04 c5 44 12 11 80 	mov    -0x7feeedbc(,%eax,8),%eax
80101fd8:	85 c0                	test   %eax,%eax
80101fda:	75 0a                	jne    80101fe6 <writei+0x49>
      return -1;
80101fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe1:	e9 47 01 00 00       	jmp    8010212d <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fed:	98                   	cwtl   
80101fee:	8b 04 c5 44 12 11 80 	mov    -0x7feeedbc(,%eax,8),%eax
80101ff5:	8b 55 14             	mov    0x14(%ebp),%edx
80101ff8:	83 ec 04             	sub    $0x4,%esp
80101ffb:	52                   	push   %edx
80101ffc:	ff 75 0c             	pushl  0xc(%ebp)
80101fff:	ff 75 08             	pushl  0x8(%ebp)
80102002:	ff d0                	call   *%eax
80102004:	83 c4 10             	add    $0x10,%esp
80102007:	e9 21 01 00 00       	jmp    8010212d <writei+0x190>
  }

  if(off > ip->size || off + n < off)
8010200c:	8b 45 08             	mov    0x8(%ebp),%eax
8010200f:	8b 40 18             	mov    0x18(%eax),%eax
80102012:	3b 45 10             	cmp    0x10(%ebp),%eax
80102015:	72 0d                	jb     80102024 <writei+0x87>
80102017:	8b 55 10             	mov    0x10(%ebp),%edx
8010201a:	8b 45 14             	mov    0x14(%ebp),%eax
8010201d:	01 d0                	add    %edx,%eax
8010201f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102022:	73 0a                	jae    8010202e <writei+0x91>
    return -1;
80102024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102029:	e9 ff 00 00 00       	jmp    8010212d <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
8010202e:	8b 55 10             	mov    0x10(%ebp),%edx
80102031:	8b 45 14             	mov    0x14(%ebp),%eax
80102034:	01 d0                	add    %edx,%eax
80102036:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010203b:	76 0a                	jbe    80102047 <writei+0xaa>
    return -1;
8010203d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102042:	e9 e6 00 00 00       	jmp    8010212d <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010204e:	e9 a3 00 00 00       	jmp    801020f6 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102053:	8b 45 10             	mov    0x10(%ebp),%eax
80102056:	c1 e8 09             	shr    $0x9,%eax
80102059:	83 ec 08             	sub    $0x8,%esp
8010205c:	50                   	push   %eax
8010205d:	ff 75 08             	pushl  0x8(%ebp)
80102060:	e8 50 fb ff ff       	call   80101bb5 <bmap>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	89 c2                	mov    %eax,%edx
8010206a:	8b 45 08             	mov    0x8(%ebp),%eax
8010206d:	8b 00                	mov    (%eax),%eax
8010206f:	83 ec 08             	sub    $0x8,%esp
80102072:	52                   	push   %edx
80102073:	50                   	push   %eax
80102074:	e8 3b e1 ff ff       	call   801001b4 <bread>
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010207f:	8b 45 10             	mov    0x10(%ebp),%eax
80102082:	25 ff 01 00 00       	and    $0x1ff,%eax
80102087:	ba 00 02 00 00       	mov    $0x200,%edx
8010208c:	89 d1                	mov    %edx,%ecx
8010208e:	29 c1                	sub    %eax,%ecx
80102090:	8b 45 14             	mov    0x14(%ebp),%eax
80102093:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102096:	89 c2                	mov    %eax,%edx
80102098:	89 c8                	mov    %ecx,%eax
8010209a:	39 d0                	cmp    %edx,%eax
8010209c:	76 02                	jbe    801020a0 <writei+0x103>
8010209e:	89 d0                	mov    %edx,%eax
801020a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020a3:	8b 45 10             	mov    0x10(%ebp),%eax
801020a6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ab:	8d 50 10             	lea    0x10(%eax),%edx
801020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020b1:	01 d0                	add    %edx,%eax
801020b3:	83 c0 08             	add    $0x8,%eax
801020b6:	83 ec 04             	sub    $0x4,%esp
801020b9:	ff 75 ec             	pushl  -0x14(%ebp)
801020bc:	ff 75 0c             	pushl  0xc(%ebp)
801020bf:	50                   	push   %eax
801020c0:	e8 8d 31 00 00       	call   80105252 <memmove>
801020c5:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	ff 75 f0             	pushl  -0x10(%ebp)
801020ce:	e8 12 16 00 00       	call   801036e5 <log_write>
801020d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020d6:	83 ec 0c             	sub    $0xc,%esp
801020d9:	ff 75 f0             	pushl  -0x10(%ebp)
801020dc:	e8 4a e1 ff ff       	call   8010022b <brelse>
801020e1:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020e7:	01 45 f4             	add    %eax,-0xc(%ebp)
801020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ed:	01 45 10             	add    %eax,0x10(%ebp)
801020f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020f3:	01 45 0c             	add    %eax,0xc(%ebp)
801020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020f9:	3b 45 14             	cmp    0x14(%ebp),%eax
801020fc:	0f 82 51 ff ff ff    	jb     80102053 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102102:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102106:	74 22                	je     8010212a <writei+0x18d>
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8b 40 18             	mov    0x18(%eax),%eax
8010210e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102111:	73 17                	jae    8010212a <writei+0x18d>
    ip->size = off;
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	8b 55 10             	mov    0x10(%ebp),%edx
80102119:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010211c:	83 ec 0c             	sub    $0xc,%esp
8010211f:	ff 75 08             	pushl  0x8(%ebp)
80102122:	e8 e0 f5 ff ff       	call   80101707 <iupdate>
80102127:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010212a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010212d:	c9                   	leave  
8010212e:	c3                   	ret    

8010212f <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010212f:	55                   	push   %ebp
80102130:	89 e5                	mov    %esp,%ebp
80102132:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102135:	83 ec 04             	sub    $0x4,%esp
80102138:	6a 0e                	push   $0xe
8010213a:	ff 75 0c             	pushl  0xc(%ebp)
8010213d:	ff 75 08             	pushl  0x8(%ebp)
80102140:	e8 a5 31 00 00       	call   801052ea <strncmp>
80102145:	83 c4 10             	add    $0x10,%esp
}
80102148:	c9                   	leave  
80102149:	c3                   	ret    

8010214a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010214a:	55                   	push   %ebp
8010214b:	89 e5                	mov    %esp,%ebp
8010214d:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102157:	66 83 f8 01          	cmp    $0x1,%ax
8010215b:	74 0d                	je     8010216a <dirlookup+0x20>
    panic("dirlookup not DIR");
8010215d:	83 ec 0c             	sub    $0xc,%esp
80102160:	68 65 85 10 80       	push   $0x80108565
80102165:	e8 f2 e3 ff ff       	call   8010055c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010216a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102171:	eb 7c                	jmp    801021ef <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102173:	6a 10                	push   $0x10
80102175:	ff 75 f4             	pushl  -0xc(%ebp)
80102178:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010217b:	50                   	push   %eax
8010217c:	ff 75 08             	pushl  0x8(%ebp)
8010217f:	e8 b8 fc ff ff       	call   80101e3c <readi>
80102184:	83 c4 10             	add    $0x10,%esp
80102187:	83 f8 10             	cmp    $0x10,%eax
8010218a:	74 0d                	je     80102199 <dirlookup+0x4f>
      panic("dirlink read");
8010218c:	83 ec 0c             	sub    $0xc,%esp
8010218f:	68 77 85 10 80       	push   $0x80108577
80102194:	e8 c3 e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
80102199:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010219d:	66 85 c0             	test   %ax,%ax
801021a0:	75 02                	jne    801021a4 <dirlookup+0x5a>
      continue;
801021a2:	eb 47                	jmp    801021eb <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
801021a4:	83 ec 08             	sub    $0x8,%esp
801021a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021aa:	83 c0 02             	add    $0x2,%eax
801021ad:	50                   	push   %eax
801021ae:	ff 75 0c             	pushl  0xc(%ebp)
801021b1:	e8 79 ff ff ff       	call   8010212f <namecmp>
801021b6:	83 c4 10             	add    $0x10,%esp
801021b9:	85 c0                	test   %eax,%eax
801021bb:	75 2e                	jne    801021eb <dirlookup+0xa1>
      // entry matches path element
      if(poff)
801021bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021c1:	74 08                	je     801021cb <dirlookup+0x81>
        *poff = off;
801021c3:	8b 45 10             	mov    0x10(%ebp),%eax
801021c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021c9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021cb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021cf:	0f b7 c0             	movzwl %ax,%eax
801021d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021d5:	8b 45 08             	mov    0x8(%ebp),%eax
801021d8:	8b 00                	mov    (%eax),%eax
801021da:	83 ec 08             	sub    $0x8,%esp
801021dd:	ff 75 f0             	pushl  -0x10(%ebp)
801021e0:	50                   	push   %eax
801021e1:	e8 db f5 ff ff       	call   801017c1 <iget>
801021e6:	83 c4 10             	add    $0x10,%esp
801021e9:	eb 18                	jmp    80102203 <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021eb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021ef:	8b 45 08             	mov    0x8(%ebp),%eax
801021f2:	8b 40 18             	mov    0x18(%eax),%eax
801021f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021f8:	0f 87 75 ff ff ff    	ja     80102173 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102203:	c9                   	leave  
80102204:	c3                   	ret    

80102205 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102205:	55                   	push   %ebp
80102206:	89 e5                	mov    %esp,%ebp
80102208:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010220b:	83 ec 04             	sub    $0x4,%esp
8010220e:	6a 00                	push   $0x0
80102210:	ff 75 0c             	pushl  0xc(%ebp)
80102213:	ff 75 08             	pushl  0x8(%ebp)
80102216:	e8 2f ff ff ff       	call   8010214a <dirlookup>
8010221b:	83 c4 10             	add    $0x10,%esp
8010221e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102225:	74 18                	je     8010223f <dirlink+0x3a>
    iput(ip);
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	ff 75 f0             	pushl  -0x10(%ebp)
8010222d:	e8 70 f8 ff ff       	call   80101aa2 <iput>
80102232:	83 c4 10             	add    $0x10,%esp
    return -1;
80102235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010223a:	e9 9b 00 00 00       	jmp    801022da <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010223f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102246:	eb 3b                	jmp    80102283 <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010224b:	6a 10                	push   $0x10
8010224d:	50                   	push   %eax
8010224e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102251:	50                   	push   %eax
80102252:	ff 75 08             	pushl  0x8(%ebp)
80102255:	e8 e2 fb ff ff       	call   80101e3c <readi>
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	83 f8 10             	cmp    $0x10,%eax
80102260:	74 0d                	je     8010226f <dirlink+0x6a>
      panic("dirlink read");
80102262:	83 ec 0c             	sub    $0xc,%esp
80102265:	68 77 85 10 80       	push   $0x80108577
8010226a:	e8 ed e2 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
8010226f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102273:	66 85 c0             	test   %ax,%ax
80102276:	75 02                	jne    8010227a <dirlink+0x75>
      break;
80102278:	eb 16                	jmp    80102290 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010227d:	83 c0 10             	add    $0x10,%eax
80102280:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102283:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102286:	8b 45 08             	mov    0x8(%ebp),%eax
80102289:	8b 40 18             	mov    0x18(%eax),%eax
8010228c:	39 c2                	cmp    %eax,%edx
8010228e:	72 b8                	jb     80102248 <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102290:	83 ec 04             	sub    $0x4,%esp
80102293:	6a 0e                	push   $0xe
80102295:	ff 75 0c             	pushl  0xc(%ebp)
80102298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010229b:	83 c0 02             	add    $0x2,%eax
8010229e:	50                   	push   %eax
8010229f:	e8 9c 30 00 00       	call   80105340 <strncpy>
801022a4:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022a7:	8b 45 10             	mov    0x10(%ebp),%eax
801022aa:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b1:	6a 10                	push   $0x10
801022b3:	50                   	push   %eax
801022b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b7:	50                   	push   %eax
801022b8:	ff 75 08             	pushl  0x8(%ebp)
801022bb:	e8 dd fc ff ff       	call   80101f9d <writei>
801022c0:	83 c4 10             	add    $0x10,%esp
801022c3:	83 f8 10             	cmp    $0x10,%eax
801022c6:	74 0d                	je     801022d5 <dirlink+0xd0>
    panic("dirlink");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 84 85 10 80       	push   $0x80108584
801022d0:	e8 87 e2 ff ff       	call   8010055c <panic>
  
  return 0;
801022d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022da:	c9                   	leave  
801022db:	c3                   	ret    

801022dc <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022dc:	55                   	push   %ebp
801022dd:	89 e5                	mov    %esp,%ebp
801022df:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801022e2:	eb 04                	jmp    801022e8 <skipelem+0xc>
    path++;
801022e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022e8:	8b 45 08             	mov    0x8(%ebp),%eax
801022eb:	0f b6 00             	movzbl (%eax),%eax
801022ee:	3c 2f                	cmp    $0x2f,%al
801022f0:	74 f2                	je     801022e4 <skipelem+0x8>
    path++;
  if(*path == 0)
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	0f b6 00             	movzbl (%eax),%eax
801022f8:	84 c0                	test   %al,%al
801022fa:	75 07                	jne    80102303 <skipelem+0x27>
    return 0;
801022fc:	b8 00 00 00 00       	mov    $0x0,%eax
80102301:	eb 7b                	jmp    8010237e <skipelem+0xa2>
  s = path;
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
80102306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102309:	eb 04                	jmp    8010230f <skipelem+0x33>
    path++;
8010230b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010230f:	8b 45 08             	mov    0x8(%ebp),%eax
80102312:	0f b6 00             	movzbl (%eax),%eax
80102315:	3c 2f                	cmp    $0x2f,%al
80102317:	74 0a                	je     80102323 <skipelem+0x47>
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
8010231c:	0f b6 00             	movzbl (%eax),%eax
8010231f:	84 c0                	test   %al,%al
80102321:	75 e8                	jne    8010230b <skipelem+0x2f>
    path++;
  len = path - s;
80102323:	8b 55 08             	mov    0x8(%ebp),%edx
80102326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102329:	29 c2                	sub    %eax,%edx
8010232b:	89 d0                	mov    %edx,%eax
8010232d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102330:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102334:	7e 15                	jle    8010234b <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102336:	83 ec 04             	sub    $0x4,%esp
80102339:	6a 0e                	push   $0xe
8010233b:	ff 75 f4             	pushl  -0xc(%ebp)
8010233e:	ff 75 0c             	pushl  0xc(%ebp)
80102341:	e8 0c 2f 00 00       	call   80105252 <memmove>
80102346:	83 c4 10             	add    $0x10,%esp
80102349:	eb 20                	jmp    8010236b <skipelem+0x8f>
  else {
    memmove(name, s, len);
8010234b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010234e:	83 ec 04             	sub    $0x4,%esp
80102351:	50                   	push   %eax
80102352:	ff 75 f4             	pushl  -0xc(%ebp)
80102355:	ff 75 0c             	pushl  0xc(%ebp)
80102358:	e8 f5 2e 00 00       	call   80105252 <memmove>
8010235d:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102360:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102363:	8b 45 0c             	mov    0xc(%ebp),%eax
80102366:	01 d0                	add    %edx,%eax
80102368:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010236b:	eb 04                	jmp    80102371 <skipelem+0x95>
    path++;
8010236d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102371:	8b 45 08             	mov    0x8(%ebp),%eax
80102374:	0f b6 00             	movzbl (%eax),%eax
80102377:	3c 2f                	cmp    $0x2f,%al
80102379:	74 f2                	je     8010236d <skipelem+0x91>
    path++;
  return path;
8010237b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010237e:	c9                   	leave  
8010237f:	c3                   	ret    

80102380 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102386:	8b 45 08             	mov    0x8(%ebp),%eax
80102389:	0f b6 00             	movzbl (%eax),%eax
8010238c:	3c 2f                	cmp    $0x2f,%al
8010238e:	75 14                	jne    801023a4 <namex+0x24>
    ip = iget(ROOTDEV, ROOTINO);
80102390:	83 ec 08             	sub    $0x8,%esp
80102393:	6a 01                	push   $0x1
80102395:	6a 01                	push   $0x1
80102397:	e8 25 f4 ff ff       	call   801017c1 <iget>
8010239c:	83 c4 10             	add    $0x10,%esp
8010239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023a2:	eb 18                	jmp    801023bc <namex+0x3c>
  else
    ip = idup(proc->cwd);
801023a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023aa:	8b 40 68             	mov    0x68(%eax),%eax
801023ad:	83 ec 0c             	sub    $0xc,%esp
801023b0:	50                   	push   %eax
801023b1:	e8 ea f4 ff ff       	call   801018a0 <idup>
801023b6:	83 c4 10             	add    $0x10,%esp
801023b9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023bc:	e9 9e 00 00 00       	jmp    8010245f <namex+0xdf>
    ilock(ip);
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	ff 75 f4             	pushl  -0xc(%ebp)
801023c7:	e8 0e f5 ff ff       	call   801018da <ilock>
801023cc:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023d6:	66 83 f8 01          	cmp    $0x1,%ax
801023da:	74 18                	je     801023f4 <namex+0x74>
      iunlockput(ip);
801023dc:	83 ec 0c             	sub    $0xc,%esp
801023df:	ff 75 f4             	pushl  -0xc(%ebp)
801023e2:	e8 aa f7 ff ff       	call   80101b91 <iunlockput>
801023e7:	83 c4 10             	add    $0x10,%esp
      return 0;
801023ea:	b8 00 00 00 00       	mov    $0x0,%eax
801023ef:	e9 a7 00 00 00       	jmp    8010249b <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
801023f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f8:	74 20                	je     8010241a <namex+0x9a>
801023fa:	8b 45 08             	mov    0x8(%ebp),%eax
801023fd:	0f b6 00             	movzbl (%eax),%eax
80102400:	84 c0                	test   %al,%al
80102402:	75 16                	jne    8010241a <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
80102404:	83 ec 0c             	sub    $0xc,%esp
80102407:	ff 75 f4             	pushl  -0xc(%ebp)
8010240a:	e8 22 f6 ff ff       	call   80101a31 <iunlock>
8010240f:	83 c4 10             	add    $0x10,%esp
      return ip;
80102412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102415:	e9 81 00 00 00       	jmp    8010249b <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010241a:	83 ec 04             	sub    $0x4,%esp
8010241d:	6a 00                	push   $0x0
8010241f:	ff 75 10             	pushl  0x10(%ebp)
80102422:	ff 75 f4             	pushl  -0xc(%ebp)
80102425:	e8 20 fd ff ff       	call   8010214a <dirlookup>
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102434:	75 15                	jne    8010244b <namex+0xcb>
      iunlockput(ip);
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	ff 75 f4             	pushl  -0xc(%ebp)
8010243c:	e8 50 f7 ff ff       	call   80101b91 <iunlockput>
80102441:	83 c4 10             	add    $0x10,%esp
      return 0;
80102444:	b8 00 00 00 00       	mov    $0x0,%eax
80102449:	eb 50                	jmp    8010249b <namex+0x11b>
    }
    iunlockput(ip);
8010244b:	83 ec 0c             	sub    $0xc,%esp
8010244e:	ff 75 f4             	pushl  -0xc(%ebp)
80102451:	e8 3b f7 ff ff       	call   80101b91 <iunlockput>
80102456:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010245c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010245f:	83 ec 08             	sub    $0x8,%esp
80102462:	ff 75 10             	pushl  0x10(%ebp)
80102465:	ff 75 08             	pushl  0x8(%ebp)
80102468:	e8 6f fe ff ff       	call   801022dc <skipelem>
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	89 45 08             	mov    %eax,0x8(%ebp)
80102473:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102477:	0f 85 44 ff ff ff    	jne    801023c1 <namex+0x41>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010247d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102481:	74 15                	je     80102498 <namex+0x118>
    iput(ip);
80102483:	83 ec 0c             	sub    $0xc,%esp
80102486:	ff 75 f4             	pushl  -0xc(%ebp)
80102489:	e8 14 f6 ff ff       	call   80101aa2 <iput>
8010248e:	83 c4 10             	add    $0x10,%esp
    return 0;
80102491:	b8 00 00 00 00       	mov    $0x0,%eax
80102496:	eb 03                	jmp    8010249b <namex+0x11b>
  }
  return ip;
80102498:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010249b:	c9                   	leave  
8010249c:	c3                   	ret    

8010249d <namei>:

struct inode*
namei(char *path)
{
8010249d:	55                   	push   %ebp
8010249e:	89 e5                	mov    %esp,%ebp
801024a0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024a3:	83 ec 04             	sub    $0x4,%esp
801024a6:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024a9:	50                   	push   %eax
801024aa:	6a 00                	push   $0x0
801024ac:	ff 75 08             	pushl  0x8(%ebp)
801024af:	e8 cc fe ff ff       	call   80102380 <namex>
801024b4:	83 c4 10             	add    $0x10,%esp
}
801024b7:	c9                   	leave  
801024b8:	c3                   	ret    

801024b9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024b9:	55                   	push   %ebp
801024ba:	89 e5                	mov    %esp,%ebp
801024bc:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024bf:	83 ec 04             	sub    $0x4,%esp
801024c2:	ff 75 0c             	pushl  0xc(%ebp)
801024c5:	6a 01                	push   $0x1
801024c7:	ff 75 08             	pushl  0x8(%ebp)
801024ca:	e8 b1 fe ff ff       	call   80102380 <namex>
801024cf:	83 c4 10             	add    $0x10,%esp
}
801024d2:	c9                   	leave  
801024d3:	c3                   	ret    

801024d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024d4:	55                   	push   %ebp
801024d5:	89 e5                	mov    %esp,%ebp
801024d7:	83 ec 14             	sub    $0x14,%esp
801024da:	8b 45 08             	mov    0x8(%ebp),%eax
801024dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024e5:	89 c2                	mov    %eax,%edx
801024e7:	ec                   	in     (%dx),%al
801024e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024ef:	c9                   	leave  
801024f0:	c3                   	ret    

801024f1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024f1:	55                   	push   %ebp
801024f2:	89 e5                	mov    %esp,%ebp
801024f4:	57                   	push   %edi
801024f5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024f6:	8b 55 08             	mov    0x8(%ebp),%edx
801024f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024fc:	8b 45 10             	mov    0x10(%ebp),%eax
801024ff:	89 cb                	mov    %ecx,%ebx
80102501:	89 df                	mov    %ebx,%edi
80102503:	89 c1                	mov    %eax,%ecx
80102505:	fc                   	cld    
80102506:	f3 6d                	rep insl (%dx),%es:(%edi)
80102508:	89 c8                	mov    %ecx,%eax
8010250a:	89 fb                	mov    %edi,%ebx
8010250c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010250f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102512:	5b                   	pop    %ebx
80102513:	5f                   	pop    %edi
80102514:	5d                   	pop    %ebp
80102515:	c3                   	ret    

80102516 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102516:	55                   	push   %ebp
80102517:	89 e5                	mov    %esp,%ebp
80102519:	83 ec 08             	sub    $0x8,%esp
8010251c:	8b 55 08             	mov    0x8(%ebp),%edx
8010251f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102522:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102526:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102529:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010252d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102531:	ee                   	out    %al,(%dx)
}
80102532:	c9                   	leave  
80102533:	c3                   	ret    

80102534 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	56                   	push   %esi
80102538:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102539:	8b 55 08             	mov    0x8(%ebp),%edx
8010253c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253f:	8b 45 10             	mov    0x10(%ebp),%eax
80102542:	89 cb                	mov    %ecx,%ebx
80102544:	89 de                	mov    %ebx,%esi
80102546:	89 c1                	mov    %eax,%ecx
80102548:	fc                   	cld    
80102549:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010254b:	89 c8                	mov    %ecx,%eax
8010254d:	89 f3                	mov    %esi,%ebx
8010254f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102552:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102555:	5b                   	pop    %ebx
80102556:	5e                   	pop    %esi
80102557:	5d                   	pop    %ebp
80102558:	c3                   	ret    

80102559 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010255f:	90                   	nop
80102560:	68 f7 01 00 00       	push   $0x1f7
80102565:	e8 6a ff ff ff       	call   801024d4 <inb>
8010256a:	83 c4 04             	add    $0x4,%esp
8010256d:	0f b6 c0             	movzbl %al,%eax
80102570:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102573:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102576:	25 c0 00 00 00       	and    $0xc0,%eax
8010257b:	83 f8 40             	cmp    $0x40,%eax
8010257e:	75 e0                	jne    80102560 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102580:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102584:	74 11                	je     80102597 <idewait+0x3e>
80102586:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102589:	83 e0 21             	and    $0x21,%eax
8010258c:	85 c0                	test   %eax,%eax
8010258e:	74 07                	je     80102597 <idewait+0x3e>
    return -1;
80102590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102595:	eb 05                	jmp    8010259c <idewait+0x43>
  return 0;
80102597:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010259c:	c9                   	leave  
8010259d:	c3                   	ret    

8010259e <ideinit>:

void
ideinit(void)
{
8010259e:	55                   	push   %ebp
8010259f:	89 e5                	mov    %esp,%ebp
801025a1:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801025a4:	83 ec 08             	sub    $0x8,%esp
801025a7:	68 8c 85 10 80       	push   $0x8010858c
801025ac:	68 20 b6 10 80       	push   $0x8010b620
801025b1:	e8 60 29 00 00       	call   80104f16 <initlock>
801025b6:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025b9:	83 ec 0c             	sub    $0xc,%esp
801025bc:	6a 0e                	push   $0xe
801025be:	e8 c4 18 00 00       	call   80103e87 <picenable>
801025c3:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025c6:	a1 20 2a 11 80       	mov    0x80112a20,%eax
801025cb:	83 e8 01             	sub    $0x1,%eax
801025ce:	83 ec 08             	sub    $0x8,%esp
801025d1:	50                   	push   %eax
801025d2:	6a 0e                	push   $0xe
801025d4:	e8 6d 04 00 00       	call   80102a46 <ioapicenable>
801025d9:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801025dc:	83 ec 0c             	sub    $0xc,%esp
801025df:	6a 00                	push   $0x0
801025e1:	e8 73 ff ff ff       	call   80102559 <idewait>
801025e6:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025e9:	83 ec 08             	sub    $0x8,%esp
801025ec:	68 f0 00 00 00       	push   $0xf0
801025f1:	68 f6 01 00 00       	push   $0x1f6
801025f6:	e8 1b ff ff ff       	call   80102516 <outb>
801025fb:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801025fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102605:	eb 24                	jmp    8010262b <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102607:	83 ec 0c             	sub    $0xc,%esp
8010260a:	68 f7 01 00 00       	push   $0x1f7
8010260f:	e8 c0 fe ff ff       	call   801024d4 <inb>
80102614:	83 c4 10             	add    $0x10,%esp
80102617:	84 c0                	test   %al,%al
80102619:	74 0c                	je     80102627 <ideinit+0x89>
      havedisk1 = 1;
8010261b:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
80102622:	00 00 00 
      break;
80102625:	eb 0d                	jmp    80102634 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010262b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102632:	7e d3                	jle    80102607 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102634:	83 ec 08             	sub    $0x8,%esp
80102637:	68 e0 00 00 00       	push   $0xe0
8010263c:	68 f6 01 00 00       	push   $0x1f6
80102641:	e8 d0 fe ff ff       	call   80102516 <outb>
80102646:	83 c4 10             	add    $0x10,%esp
}
80102649:	c9                   	leave  
8010264a:	c3                   	ret    

8010264b <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010264b:	55                   	push   %ebp
8010264c:	89 e5                	mov    %esp,%ebp
8010264e:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102655:	75 0d                	jne    80102664 <idestart+0x19>
    panic("idestart");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 90 85 10 80       	push   $0x80108590
8010265f:	e8 f8 de ff ff       	call   8010055c <panic>
  if(b->blockno >= FSSIZE)
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
80102667:	8b 40 08             	mov    0x8(%eax),%eax
8010266a:	3d e7 03 00 00       	cmp    $0x3e7,%eax
8010266f:	76 0d                	jbe    8010267e <idestart+0x33>
    panic("incorrect blockno");
80102671:	83 ec 0c             	sub    $0xc,%esp
80102674:	68 99 85 10 80       	push   $0x80108599
80102679:	e8 de de ff ff       	call   8010055c <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010267e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
80102688:	8b 50 08             	mov    0x8(%eax),%edx
8010268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010268e:	0f af c2             	imul   %edx,%eax
80102691:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102694:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102698:	7e 0d                	jle    801026a7 <idestart+0x5c>
8010269a:	83 ec 0c             	sub    $0xc,%esp
8010269d:	68 90 85 10 80       	push   $0x80108590
801026a2:	e8 b5 de ff ff       	call   8010055c <panic>
  
  idewait(0);
801026a7:	83 ec 0c             	sub    $0xc,%esp
801026aa:	6a 00                	push   $0x0
801026ac:	e8 a8 fe ff ff       	call   80102559 <idewait>
801026b1:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026b4:	83 ec 08             	sub    $0x8,%esp
801026b7:	6a 00                	push   $0x0
801026b9:	68 f6 03 00 00       	push   $0x3f6
801026be:	e8 53 fe ff ff       	call   80102516 <outb>
801026c3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026c9:	0f b6 c0             	movzbl %al,%eax
801026cc:	83 ec 08             	sub    $0x8,%esp
801026cf:	50                   	push   %eax
801026d0:	68 f2 01 00 00       	push   $0x1f2
801026d5:	e8 3c fe ff ff       	call   80102516 <outb>
801026da:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801026dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026e0:	0f b6 c0             	movzbl %al,%eax
801026e3:	83 ec 08             	sub    $0x8,%esp
801026e6:	50                   	push   %eax
801026e7:	68 f3 01 00 00       	push   $0x1f3
801026ec:	e8 25 fe ff ff       	call   80102516 <outb>
801026f1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801026f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026f7:	c1 f8 08             	sar    $0x8,%eax
801026fa:	0f b6 c0             	movzbl %al,%eax
801026fd:	83 ec 08             	sub    $0x8,%esp
80102700:	50                   	push   %eax
80102701:	68 f4 01 00 00       	push   $0x1f4
80102706:	e8 0b fe ff ff       	call   80102516 <outb>
8010270b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102711:	c1 f8 10             	sar    $0x10,%eax
80102714:	0f b6 c0             	movzbl %al,%eax
80102717:	83 ec 08             	sub    $0x8,%esp
8010271a:	50                   	push   %eax
8010271b:	68 f5 01 00 00       	push   $0x1f5
80102720:	e8 f1 fd ff ff       	call   80102516 <outb>
80102725:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102728:	8b 45 08             	mov    0x8(%ebp),%eax
8010272b:	8b 40 04             	mov    0x4(%eax),%eax
8010272e:	83 e0 01             	and    $0x1,%eax
80102731:	c1 e0 04             	shl    $0x4,%eax
80102734:	89 c2                	mov    %eax,%edx
80102736:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102739:	c1 f8 18             	sar    $0x18,%eax
8010273c:	83 e0 0f             	and    $0xf,%eax
8010273f:	09 d0                	or     %edx,%eax
80102741:	83 c8 e0             	or     $0xffffffe0,%eax
80102744:	0f b6 c0             	movzbl %al,%eax
80102747:	83 ec 08             	sub    $0x8,%esp
8010274a:	50                   	push   %eax
8010274b:	68 f6 01 00 00       	push   $0x1f6
80102750:	e8 c1 fd ff ff       	call   80102516 <outb>
80102755:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102758:	8b 45 08             	mov    0x8(%ebp),%eax
8010275b:	8b 00                	mov    (%eax),%eax
8010275d:	83 e0 04             	and    $0x4,%eax
80102760:	85 c0                	test   %eax,%eax
80102762:	74 30                	je     80102794 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102764:	83 ec 08             	sub    $0x8,%esp
80102767:	6a 30                	push   $0x30
80102769:	68 f7 01 00 00       	push   $0x1f7
8010276e:	e8 a3 fd ff ff       	call   80102516 <outb>
80102773:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102776:	8b 45 08             	mov    0x8(%ebp),%eax
80102779:	83 c0 18             	add    $0x18,%eax
8010277c:	83 ec 04             	sub    $0x4,%esp
8010277f:	68 80 00 00 00       	push   $0x80
80102784:	50                   	push   %eax
80102785:	68 f0 01 00 00       	push   $0x1f0
8010278a:	e8 a5 fd ff ff       	call   80102534 <outsl>
8010278f:	83 c4 10             	add    $0x10,%esp
80102792:	eb 12                	jmp    801027a6 <idestart+0x15b>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102794:	83 ec 08             	sub    $0x8,%esp
80102797:	6a 20                	push   $0x20
80102799:	68 f7 01 00 00       	push   $0x1f7
8010279e:	e8 73 fd ff ff       	call   80102516 <outb>
801027a3:	83 c4 10             	add    $0x10,%esp
  }
}
801027a6:	c9                   	leave  
801027a7:	c3                   	ret    

801027a8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027a8:	55                   	push   %ebp
801027a9:	89 e5                	mov    %esp,%ebp
801027ab:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027ae:	83 ec 0c             	sub    $0xc,%esp
801027b1:	68 20 b6 10 80       	push   $0x8010b620
801027b6:	e8 7c 27 00 00       	call   80104f37 <acquire>
801027bb:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027be:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027ca:	75 15                	jne    801027e1 <ideintr+0x39>
    release(&idelock);
801027cc:	83 ec 0c             	sub    $0xc,%esp
801027cf:	68 20 b6 10 80       	push   $0x8010b620
801027d4:	e8 c4 27 00 00       	call   80104f9d <release>
801027d9:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027dc:	e9 9a 00 00 00       	jmp    8010287b <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e4:	8b 40 14             	mov    0x14(%eax),%eax
801027e7:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ef:	8b 00                	mov    (%eax),%eax
801027f1:	83 e0 04             	and    $0x4,%eax
801027f4:	85 c0                	test   %eax,%eax
801027f6:	75 2d                	jne    80102825 <ideintr+0x7d>
801027f8:	83 ec 0c             	sub    $0xc,%esp
801027fb:	6a 01                	push   $0x1
801027fd:	e8 57 fd ff ff       	call   80102559 <idewait>
80102802:	83 c4 10             	add    $0x10,%esp
80102805:	85 c0                	test   %eax,%eax
80102807:	78 1c                	js     80102825 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280c:	83 c0 18             	add    $0x18,%eax
8010280f:	83 ec 04             	sub    $0x4,%esp
80102812:	68 80 00 00 00       	push   $0x80
80102817:	50                   	push   %eax
80102818:	68 f0 01 00 00       	push   $0x1f0
8010281d:	e8 cf fc ff ff       	call   801024f1 <insl>
80102822:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102828:	8b 00                	mov    (%eax),%eax
8010282a:	83 c8 02             	or     $0x2,%eax
8010282d:	89 c2                	mov    %eax,%edx
8010282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102832:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102837:	8b 00                	mov    (%eax),%eax
80102839:	83 e0 fb             	and    $0xfffffffb,%eax
8010283c:	89 c2                	mov    %eax,%edx
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102843:	83 ec 0c             	sub    $0xc,%esp
80102846:	ff 75 f4             	pushl  -0xc(%ebp)
80102849:	e8 e2 24 00 00       	call   80104d30 <wakeup>
8010284e:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102851:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102856:	85 c0                	test   %eax,%eax
80102858:	74 11                	je     8010286b <ideintr+0xc3>
    idestart(idequeue);
8010285a:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010285f:	83 ec 0c             	sub    $0xc,%esp
80102862:	50                   	push   %eax
80102863:	e8 e3 fd ff ff       	call   8010264b <idestart>
80102868:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010286b:	83 ec 0c             	sub    $0xc,%esp
8010286e:	68 20 b6 10 80       	push   $0x8010b620
80102873:	e8 25 27 00 00       	call   80104f9d <release>
80102878:	83 c4 10             	add    $0x10,%esp
}
8010287b:	c9                   	leave  
8010287c:	c3                   	ret    

8010287d <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010287d:	55                   	push   %ebp
8010287e:	89 e5                	mov    %esp,%ebp
80102880:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102883:	8b 45 08             	mov    0x8(%ebp),%eax
80102886:	8b 00                	mov    (%eax),%eax
80102888:	83 e0 01             	and    $0x1,%eax
8010288b:	85 c0                	test   %eax,%eax
8010288d:	75 0d                	jne    8010289c <iderw+0x1f>
    panic("iderw: buf not busy");
8010288f:	83 ec 0c             	sub    $0xc,%esp
80102892:	68 ab 85 10 80       	push   $0x801085ab
80102897:	e8 c0 dc ff ff       	call   8010055c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010289c:	8b 45 08             	mov    0x8(%ebp),%eax
8010289f:	8b 00                	mov    (%eax),%eax
801028a1:	83 e0 06             	and    $0x6,%eax
801028a4:	83 f8 02             	cmp    $0x2,%eax
801028a7:	75 0d                	jne    801028b6 <iderw+0x39>
    panic("iderw: nothing to do");
801028a9:	83 ec 0c             	sub    $0xc,%esp
801028ac:	68 bf 85 10 80       	push   $0x801085bf
801028b1:	e8 a6 dc ff ff       	call   8010055c <panic>
  if(b->dev != 0 && !havedisk1)
801028b6:	8b 45 08             	mov    0x8(%ebp),%eax
801028b9:	8b 40 04             	mov    0x4(%eax),%eax
801028bc:	85 c0                	test   %eax,%eax
801028be:	74 16                	je     801028d6 <iderw+0x59>
801028c0:	a1 58 b6 10 80       	mov    0x8010b658,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	75 0d                	jne    801028d6 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028c9:	83 ec 0c             	sub    $0xc,%esp
801028cc:	68 d4 85 10 80       	push   $0x801085d4
801028d1:	e8 86 dc ff ff       	call   8010055c <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	68 20 b6 10 80       	push   $0x8010b620
801028de:	e8 54 26 00 00       	call   80104f37 <acquire>
801028e3:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028e6:	8b 45 08             	mov    0x8(%ebp),%eax
801028e9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028f0:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
801028f7:	eb 0b                	jmp    80102904 <iderw+0x87>
801028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fc:	8b 00                	mov    (%eax),%eax
801028fe:	83 c0 14             	add    $0x14,%eax
80102901:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102907:	8b 00                	mov    (%eax),%eax
80102909:	85 c0                	test   %eax,%eax
8010290b:	75 ec                	jne    801028f9 <iderw+0x7c>
    ;
  *pp = b;
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	8b 55 08             	mov    0x8(%ebp),%edx
80102913:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102915:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010291a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010291d:	75 0e                	jne    8010292d <iderw+0xb0>
    idestart(b);
8010291f:	83 ec 0c             	sub    $0xc,%esp
80102922:	ff 75 08             	pushl  0x8(%ebp)
80102925:	e8 21 fd ff ff       	call   8010264b <idestart>
8010292a:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010292d:	eb 13                	jmp    80102942 <iderw+0xc5>
    sleep(b, &idelock);
8010292f:	83 ec 08             	sub    $0x8,%esp
80102932:	68 20 b6 10 80       	push   $0x8010b620
80102937:	ff 75 08             	pushl  0x8(%ebp)
8010293a:	e8 08 23 00 00       	call   80104c47 <sleep>
8010293f:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102942:	8b 45 08             	mov    0x8(%ebp),%eax
80102945:	8b 00                	mov    (%eax),%eax
80102947:	83 e0 06             	and    $0x6,%eax
8010294a:	83 f8 02             	cmp    $0x2,%eax
8010294d:	75 e0                	jne    8010292f <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
8010294f:	83 ec 0c             	sub    $0xc,%esp
80102952:	68 20 b6 10 80       	push   $0x8010b620
80102957:	e8 41 26 00 00       	call   80104f9d <release>
8010295c:	83 c4 10             	add    $0x10,%esp
}
8010295f:	c9                   	leave  
80102960:	c3                   	ret    

80102961 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102961:	55                   	push   %ebp
80102962:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102964:	a1 94 22 11 80       	mov    0x80112294,%eax
80102969:	8b 55 08             	mov    0x8(%ebp),%edx
8010296c:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010296e:	a1 94 22 11 80       	mov    0x80112294,%eax
80102973:	8b 40 10             	mov    0x10(%eax),%eax
}
80102976:	5d                   	pop    %ebp
80102977:	c3                   	ret    

80102978 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102978:	55                   	push   %ebp
80102979:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010297b:	a1 94 22 11 80       	mov    0x80112294,%eax
80102980:	8b 55 08             	mov    0x8(%ebp),%edx
80102983:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102985:	a1 94 22 11 80       	mov    0x80112294,%eax
8010298a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010298d:	89 50 10             	mov    %edx,0x10(%eax)
}
80102990:	5d                   	pop    %ebp
80102991:	c3                   	ret    

80102992 <ioapicinit>:

void
ioapicinit(void)
{
80102992:	55                   	push   %ebp
80102993:	89 e5                	mov    %esp,%ebp
80102995:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102998:	a1 04 24 11 80       	mov    0x80112404,%eax
8010299d:	85 c0                	test   %eax,%eax
8010299f:	75 05                	jne    801029a6 <ioapicinit+0x14>
    return;
801029a1:	e9 9e 00 00 00       	jmp    80102a44 <ioapicinit+0xb2>

  ioapic = (volatile struct ioapic*)IOAPIC;
801029a6:	c7 05 94 22 11 80 00 	movl   $0xfec00000,0x80112294
801029ad:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029b0:	6a 01                	push   $0x1
801029b2:	e8 aa ff ff ff       	call   80102961 <ioapicread>
801029b7:	83 c4 04             	add    $0x4,%esp
801029ba:	c1 e8 10             	shr    $0x10,%eax
801029bd:	25 ff 00 00 00       	and    $0xff,%eax
801029c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029c5:	6a 00                	push   $0x0
801029c7:	e8 95 ff ff ff       	call   80102961 <ioapicread>
801029cc:	83 c4 04             	add    $0x4,%esp
801029cf:	c1 e8 18             	shr    $0x18,%eax
801029d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029d5:	0f b6 05 00 24 11 80 	movzbl 0x80112400,%eax
801029dc:	0f b6 c0             	movzbl %al,%eax
801029df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029e2:	74 10                	je     801029f4 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029e4:	83 ec 0c             	sub    $0xc,%esp
801029e7:	68 f4 85 10 80       	push   $0x801085f4
801029ec:	e8 ce d9 ff ff       	call   801003bf <cprintf>
801029f1:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029fb:	eb 3f                	jmp    80102a3c <ioapicinit+0xaa>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a00:	83 c0 20             	add    $0x20,%eax
80102a03:	0d 00 00 01 00       	or     $0x10000,%eax
80102a08:	89 c2                	mov    %eax,%edx
80102a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a0d:	83 c0 08             	add    $0x8,%eax
80102a10:	01 c0                	add    %eax,%eax
80102a12:	83 ec 08             	sub    $0x8,%esp
80102a15:	52                   	push   %edx
80102a16:	50                   	push   %eax
80102a17:	e8 5c ff ff ff       	call   80102978 <ioapicwrite>
80102a1c:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a22:	83 c0 08             	add    $0x8,%eax
80102a25:	01 c0                	add    %eax,%eax
80102a27:	83 c0 01             	add    $0x1,%eax
80102a2a:	83 ec 08             	sub    $0x8,%esp
80102a2d:	6a 00                	push   $0x0
80102a2f:	50                   	push   %eax
80102a30:	e8 43 ff ff ff       	call   80102978 <ioapicwrite>
80102a35:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a42:	7e b9                	jle    801029fd <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a44:	c9                   	leave  
80102a45:	c3                   	ret    

80102a46 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a46:	55                   	push   %ebp
80102a47:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a49:	a1 04 24 11 80       	mov    0x80112404,%eax
80102a4e:	85 c0                	test   %eax,%eax
80102a50:	75 02                	jne    80102a54 <ioapicenable+0xe>
    return;
80102a52:	eb 37                	jmp    80102a8b <ioapicenable+0x45>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a54:	8b 45 08             	mov    0x8(%ebp),%eax
80102a57:	83 c0 20             	add    $0x20,%eax
80102a5a:	89 c2                	mov    %eax,%edx
80102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5f:	83 c0 08             	add    $0x8,%eax
80102a62:	01 c0                	add    %eax,%eax
80102a64:	52                   	push   %edx
80102a65:	50                   	push   %eax
80102a66:	e8 0d ff ff ff       	call   80102978 <ioapicwrite>
80102a6b:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a71:	c1 e0 18             	shl    $0x18,%eax
80102a74:	89 c2                	mov    %eax,%edx
80102a76:	8b 45 08             	mov    0x8(%ebp),%eax
80102a79:	83 c0 08             	add    $0x8,%eax
80102a7c:	01 c0                	add    %eax,%eax
80102a7e:	83 c0 01             	add    $0x1,%eax
80102a81:	52                   	push   %edx
80102a82:	50                   	push   %eax
80102a83:	e8 f0 fe ff ff       	call   80102978 <ioapicwrite>
80102a88:	83 c4 08             	add    $0x8,%esp
}
80102a8b:	c9                   	leave  
80102a8c:	c3                   	ret    

80102a8d <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a8d:	55                   	push   %ebp
80102a8e:	89 e5                	mov    %esp,%ebp
80102a90:	8b 45 08             	mov    0x8(%ebp),%eax
80102a93:	05 00 00 00 80       	add    $0x80000000,%eax
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    

80102a9a <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a9a:	55                   	push   %ebp
80102a9b:	89 e5                	mov    %esp,%ebp
80102a9d:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102aa0:	83 ec 08             	sub    $0x8,%esp
80102aa3:	68 26 86 10 80       	push   $0x80108626
80102aa8:	68 a0 22 11 80       	push   $0x801122a0
80102aad:	e8 64 24 00 00       	call   80104f16 <initlock>
80102ab2:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ab5:	c7 05 d4 22 11 80 00 	movl   $0x0,0x801122d4
80102abc:	00 00 00 
  freerange(vstart, vend);
80102abf:	83 ec 08             	sub    $0x8,%esp
80102ac2:	ff 75 0c             	pushl  0xc(%ebp)
80102ac5:	ff 75 08             	pushl  0x8(%ebp)
80102ac8:	e8 28 00 00 00       	call   80102af5 <freerange>
80102acd:	83 c4 10             	add    $0x10,%esp
}
80102ad0:	c9                   	leave  
80102ad1:	c3                   	ret    

80102ad2 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ad2:	55                   	push   %ebp
80102ad3:	89 e5                	mov    %esp,%ebp
80102ad5:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ad8:	83 ec 08             	sub    $0x8,%esp
80102adb:	ff 75 0c             	pushl  0xc(%ebp)
80102ade:	ff 75 08             	pushl  0x8(%ebp)
80102ae1:	e8 0f 00 00 00       	call   80102af5 <freerange>
80102ae6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ae9:	c7 05 d4 22 11 80 01 	movl   $0x1,0x801122d4
80102af0:	00 00 00 
}
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    

80102af5 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
80102af8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102afb:	8b 45 08             	mov    0x8(%ebp),%eax
80102afe:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0b:	eb 15                	jmp    80102b22 <freerange+0x2d>
    kfree(p);
80102b0d:	83 ec 0c             	sub    $0xc,%esp
80102b10:	ff 75 f4             	pushl  -0xc(%ebp)
80102b13:	e8 19 00 00 00       	call   80102b31 <kfree>
80102b18:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b1b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b25:	05 00 10 00 00       	add    $0x1000,%eax
80102b2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b2d:	76 de                	jbe    80102b0d <freerange+0x18>
    kfree(p);
}
80102b2f:	c9                   	leave  
80102b30:	c3                   	ret    

80102b31 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b31:	55                   	push   %ebp
80102b32:	89 e5                	mov    %esp,%ebp
80102b34:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b37:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3a:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	75 1b                	jne    80102b5e <kfree+0x2d>
80102b43:	81 7d 08 1c 52 11 80 	cmpl   $0x8011521c,0x8(%ebp)
80102b4a:	72 12                	jb     80102b5e <kfree+0x2d>
80102b4c:	ff 75 08             	pushl  0x8(%ebp)
80102b4f:	e8 39 ff ff ff       	call   80102a8d <v2p>
80102b54:	83 c4 04             	add    $0x4,%esp
80102b57:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b5c:	76 0d                	jbe    80102b6b <kfree+0x3a>
    panic("kfree");
80102b5e:	83 ec 0c             	sub    $0xc,%esp
80102b61:	68 2b 86 10 80       	push   $0x8010862b
80102b66:	e8 f1 d9 ff ff       	call   8010055c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b6b:	83 ec 04             	sub    $0x4,%esp
80102b6e:	68 00 10 00 00       	push   $0x1000
80102b73:	6a 01                	push   $0x1
80102b75:	ff 75 08             	pushl  0x8(%ebp)
80102b78:	e8 16 26 00 00       	call   80105193 <memset>
80102b7d:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b80:	a1 d4 22 11 80       	mov    0x801122d4,%eax
80102b85:	85 c0                	test   %eax,%eax
80102b87:	74 10                	je     80102b99 <kfree+0x68>
    acquire(&kmem.lock);
80102b89:	83 ec 0c             	sub    $0xc,%esp
80102b8c:	68 a0 22 11 80       	push   $0x801122a0
80102b91:	e8 a1 23 00 00       	call   80104f37 <acquire>
80102b96:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b99:	8b 45 08             	mov    0x8(%ebp),%eax
80102b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b9f:	8b 15 d8 22 11 80    	mov    0x801122d8,%edx
80102ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba8:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bad:	a3 d8 22 11 80       	mov    %eax,0x801122d8
  if(kmem.use_lock)
80102bb2:	a1 d4 22 11 80       	mov    0x801122d4,%eax
80102bb7:	85 c0                	test   %eax,%eax
80102bb9:	74 10                	je     80102bcb <kfree+0x9a>
    release(&kmem.lock);
80102bbb:	83 ec 0c             	sub    $0xc,%esp
80102bbe:	68 a0 22 11 80       	push   $0x801122a0
80102bc3:	e8 d5 23 00 00       	call   80104f9d <release>
80102bc8:	83 c4 10             	add    $0x10,%esp
}
80102bcb:	c9                   	leave  
80102bcc:	c3                   	ret    

80102bcd <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bcd:	55                   	push   %ebp
80102bce:	89 e5                	mov    %esp,%ebp
80102bd0:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102bd3:	a1 d4 22 11 80       	mov    0x801122d4,%eax
80102bd8:	85 c0                	test   %eax,%eax
80102bda:	74 10                	je     80102bec <kalloc+0x1f>
    acquire(&kmem.lock);
80102bdc:	83 ec 0c             	sub    $0xc,%esp
80102bdf:	68 a0 22 11 80       	push   $0x801122a0
80102be4:	e8 4e 23 00 00       	call   80104f37 <acquire>
80102be9:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102bec:	a1 d8 22 11 80       	mov    0x801122d8,%eax
80102bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf8:	74 0a                	je     80102c04 <kalloc+0x37>
    kmem.freelist = r->next;
80102bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfd:	8b 00                	mov    (%eax),%eax
80102bff:	a3 d8 22 11 80       	mov    %eax,0x801122d8
  if(kmem.use_lock)
80102c04:	a1 d4 22 11 80       	mov    0x801122d4,%eax
80102c09:	85 c0                	test   %eax,%eax
80102c0b:	74 10                	je     80102c1d <kalloc+0x50>
    release(&kmem.lock);
80102c0d:	83 ec 0c             	sub    $0xc,%esp
80102c10:	68 a0 22 11 80       	push   $0x801122a0
80102c15:	e8 83 23 00 00       	call   80104f9d <release>
80102c1a:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c20:	c9                   	leave  
80102c21:	c3                   	ret    

80102c22 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c22:	55                   	push   %ebp
80102c23:	89 e5                	mov    %esp,%ebp
80102c25:	83 ec 14             	sub    $0x14,%esp
80102c28:	8b 45 08             	mov    0x8(%ebp),%eax
80102c2b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c33:	89 c2                	mov    %eax,%edx
80102c35:	ec                   	in     (%dx),%al
80102c36:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c39:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c3d:	c9                   	leave  
80102c3e:	c3                   	ret    

80102c3f <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c3f:	55                   	push   %ebp
80102c40:	89 e5                	mov    %esp,%ebp
80102c42:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c45:	6a 64                	push   $0x64
80102c47:	e8 d6 ff ff ff       	call   80102c22 <inb>
80102c4c:	83 c4 04             	add    $0x4,%esp
80102c4f:	0f b6 c0             	movzbl %al,%eax
80102c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c58:	83 e0 01             	and    $0x1,%eax
80102c5b:	85 c0                	test   %eax,%eax
80102c5d:	75 0a                	jne    80102c69 <kbdgetc+0x2a>
    return -1;
80102c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c64:	e9 23 01 00 00       	jmp    80102d8c <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c69:	6a 60                	push   $0x60
80102c6b:	e8 b2 ff ff ff       	call   80102c22 <inb>
80102c70:	83 c4 04             	add    $0x4,%esp
80102c73:	0f b6 c0             	movzbl %al,%eax
80102c76:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c79:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c80:	75 17                	jne    80102c99 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c82:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c87:	83 c8 40             	or     $0x40,%eax
80102c8a:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c8f:	b8 00 00 00 00       	mov    $0x0,%eax
80102c94:	e9 f3 00 00 00       	jmp    80102d8c <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c9c:	25 80 00 00 00       	and    $0x80,%eax
80102ca1:	85 c0                	test   %eax,%eax
80102ca3:	74 45                	je     80102cea <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ca5:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102caa:	83 e0 40             	and    $0x40,%eax
80102cad:	85 c0                	test   %eax,%eax
80102caf:	75 08                	jne    80102cb9 <kbdgetc+0x7a>
80102cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb4:	83 e0 7f             	and    $0x7f,%eax
80102cb7:	eb 03                	jmp    80102cbc <kbdgetc+0x7d>
80102cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc2:	05 40 90 10 80       	add    $0x80109040,%eax
80102cc7:	0f b6 00             	movzbl (%eax),%eax
80102cca:	83 c8 40             	or     $0x40,%eax
80102ccd:	0f b6 c0             	movzbl %al,%eax
80102cd0:	f7 d0                	not    %eax
80102cd2:	89 c2                	mov    %eax,%edx
80102cd4:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cd9:	21 d0                	and    %edx,%eax
80102cdb:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102ce0:	b8 00 00 00 00       	mov    $0x0,%eax
80102ce5:	e9 a2 00 00 00       	jmp    80102d8c <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102cea:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cef:	83 e0 40             	and    $0x40,%eax
80102cf2:	85 c0                	test   %eax,%eax
80102cf4:	74 14                	je     80102d0a <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cf6:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cfd:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d02:	83 e0 bf             	and    $0xffffffbf,%eax
80102d05:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d0d:	05 40 90 10 80       	add    $0x80109040,%eax
80102d12:	0f b6 00             	movzbl (%eax),%eax
80102d15:	0f b6 d0             	movzbl %al,%edx
80102d18:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d1d:	09 d0                	or     %edx,%eax
80102d1f:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d27:	05 40 91 10 80       	add    $0x80109140,%eax
80102d2c:	0f b6 00             	movzbl (%eax),%eax
80102d2f:	0f b6 d0             	movzbl %al,%edx
80102d32:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d37:	31 d0                	xor    %edx,%eax
80102d39:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d3e:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d43:	83 e0 03             	and    $0x3,%eax
80102d46:	8b 14 85 40 95 10 80 	mov    -0x7fef6ac0(,%eax,4),%edx
80102d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d50:	01 d0                	add    %edx,%eax
80102d52:	0f b6 00             	movzbl (%eax),%eax
80102d55:	0f b6 c0             	movzbl %al,%eax
80102d58:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d5b:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d60:	83 e0 08             	and    $0x8,%eax
80102d63:	85 c0                	test   %eax,%eax
80102d65:	74 22                	je     80102d89 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d67:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d6b:	76 0c                	jbe    80102d79 <kbdgetc+0x13a>
80102d6d:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d71:	77 06                	ja     80102d79 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d73:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d77:	eb 10                	jmp    80102d89 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d79:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d7d:	76 0a                	jbe    80102d89 <kbdgetc+0x14a>
80102d7f:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d83:	77 04                	ja     80102d89 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d85:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d8c:	c9                   	leave  
80102d8d:	c3                   	ret    

80102d8e <kbdintr>:

void
kbdintr(void)
{
80102d8e:	55                   	push   %ebp
80102d8f:	89 e5                	mov    %esp,%ebp
80102d91:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d94:	83 ec 0c             	sub    $0xc,%esp
80102d97:	68 3f 2c 10 80       	push   $0x80102c3f
80102d9c:	e8 30 da ff ff       	call   801007d1 <consoleintr>
80102da1:	83 c4 10             	add    $0x10,%esp
}
80102da4:	c9                   	leave  
80102da5:	c3                   	ret    

80102da6 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102da6:	55                   	push   %ebp
80102da7:	89 e5                	mov    %esp,%ebp
80102da9:	83 ec 14             	sub    $0x14,%esp
80102dac:	8b 45 08             	mov    0x8(%ebp),%eax
80102daf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102db3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102db7:	89 c2                	mov    %eax,%edx
80102db9:	ec                   	in     (%dx),%al
80102dba:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102dbd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102dc1:	c9                   	leave  
80102dc2:	c3                   	ret    

80102dc3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102dc3:	55                   	push   %ebp
80102dc4:	89 e5                	mov    %esp,%ebp
80102dc6:	83 ec 08             	sub    $0x8,%esp
80102dc9:	8b 55 08             	mov    0x8(%ebp),%edx
80102dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dcf:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dd3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dda:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dde:	ee                   	out    %al,(%dx)
}
80102ddf:	c9                   	leave  
80102de0:	c3                   	ret    

80102de1 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102de1:	55                   	push   %ebp
80102de2:	89 e5                	mov    %esp,%ebp
80102de4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102de7:	9c                   	pushf  
80102de8:	58                   	pop    %eax
80102de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102def:	c9                   	leave  
80102df0:	c3                   	ret    

80102df1 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102df1:	55                   	push   %ebp
80102df2:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102df4:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102df9:	8b 55 08             	mov    0x8(%ebp),%edx
80102dfc:	c1 e2 02             	shl    $0x2,%edx
80102dff:	01 c2                	add    %eax,%edx
80102e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e04:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e06:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102e0b:	83 c0 20             	add    $0x20,%eax
80102e0e:	8b 00                	mov    (%eax),%eax
}
80102e10:	5d                   	pop    %ebp
80102e11:	c3                   	ret    

80102e12 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e12:	55                   	push   %ebp
80102e13:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e15:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102e1a:	85 c0                	test   %eax,%eax
80102e1c:	75 05                	jne    80102e23 <lapicinit+0x11>
    return;
80102e1e:	e9 09 01 00 00       	jmp    80102f2c <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e23:	68 3f 01 00 00       	push   $0x13f
80102e28:	6a 3c                	push   $0x3c
80102e2a:	e8 c2 ff ff ff       	call   80102df1 <lapicw>
80102e2f:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e32:	6a 0b                	push   $0xb
80102e34:	68 f8 00 00 00       	push   $0xf8
80102e39:	e8 b3 ff ff ff       	call   80102df1 <lapicw>
80102e3e:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e41:	68 20 00 02 00       	push   $0x20020
80102e46:	68 c8 00 00 00       	push   $0xc8
80102e4b:	e8 a1 ff ff ff       	call   80102df1 <lapicw>
80102e50:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e53:	68 80 96 98 00       	push   $0x989680
80102e58:	68 e0 00 00 00       	push   $0xe0
80102e5d:	e8 8f ff ff ff       	call   80102df1 <lapicw>
80102e62:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e65:	68 00 00 01 00       	push   $0x10000
80102e6a:	68 d4 00 00 00       	push   $0xd4
80102e6f:	e8 7d ff ff ff       	call   80102df1 <lapicw>
80102e74:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e77:	68 00 00 01 00       	push   $0x10000
80102e7c:	68 d8 00 00 00       	push   $0xd8
80102e81:	e8 6b ff ff ff       	call   80102df1 <lapicw>
80102e86:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e89:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102e8e:	83 c0 30             	add    $0x30,%eax
80102e91:	8b 00                	mov    (%eax),%eax
80102e93:	c1 e8 10             	shr    $0x10,%eax
80102e96:	0f b6 c0             	movzbl %al,%eax
80102e99:	83 f8 03             	cmp    $0x3,%eax
80102e9c:	76 12                	jbe    80102eb0 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102e9e:	68 00 00 01 00       	push   $0x10000
80102ea3:	68 d0 00 00 00       	push   $0xd0
80102ea8:	e8 44 ff ff ff       	call   80102df1 <lapicw>
80102ead:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102eb0:	6a 33                	push   $0x33
80102eb2:	68 dc 00 00 00       	push   $0xdc
80102eb7:	e8 35 ff ff ff       	call   80102df1 <lapicw>
80102ebc:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ebf:	6a 00                	push   $0x0
80102ec1:	68 a0 00 00 00       	push   $0xa0
80102ec6:	e8 26 ff ff ff       	call   80102df1 <lapicw>
80102ecb:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102ece:	6a 00                	push   $0x0
80102ed0:	68 a0 00 00 00       	push   $0xa0
80102ed5:	e8 17 ff ff ff       	call   80102df1 <lapicw>
80102eda:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102edd:	6a 00                	push   $0x0
80102edf:	6a 2c                	push   $0x2c
80102ee1:	e8 0b ff ff ff       	call   80102df1 <lapicw>
80102ee6:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee9:	6a 00                	push   $0x0
80102eeb:	68 c4 00 00 00       	push   $0xc4
80102ef0:	e8 fc fe ff ff       	call   80102df1 <lapicw>
80102ef5:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ef8:	68 00 85 08 00       	push   $0x88500
80102efd:	68 c0 00 00 00       	push   $0xc0
80102f02:	e8 ea fe ff ff       	call   80102df1 <lapicw>
80102f07:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f0a:	90                   	nop
80102f0b:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102f10:	05 00 03 00 00       	add    $0x300,%eax
80102f15:	8b 00                	mov    (%eax),%eax
80102f17:	25 00 10 00 00       	and    $0x1000,%eax
80102f1c:	85 c0                	test   %eax,%eax
80102f1e:	75 eb                	jne    80102f0b <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f20:	6a 00                	push   $0x0
80102f22:	6a 20                	push   $0x20
80102f24:	e8 c8 fe ff ff       	call   80102df1 <lapicw>
80102f29:	83 c4 08             	add    $0x8,%esp
}
80102f2c:	c9                   	leave  
80102f2d:	c3                   	ret    

80102f2e <cpunum>:

int
cpunum(void)
{
80102f2e:	55                   	push   %ebp
80102f2f:	89 e5                	mov    %esp,%ebp
80102f31:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f34:	e8 a8 fe ff ff       	call   80102de1 <readeflags>
80102f39:	25 00 02 00 00       	and    $0x200,%eax
80102f3e:	85 c0                	test   %eax,%eax
80102f40:	74 26                	je     80102f68 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f42:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102f47:	8d 50 01             	lea    0x1(%eax),%edx
80102f4a:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102f50:	85 c0                	test   %eax,%eax
80102f52:	75 14                	jne    80102f68 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f54:	8b 45 04             	mov    0x4(%ebp),%eax
80102f57:	83 ec 08             	sub    $0x8,%esp
80102f5a:	50                   	push   %eax
80102f5b:	68 34 86 10 80       	push   $0x80108634
80102f60:	e8 5a d4 ff ff       	call   801003bf <cprintf>
80102f65:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f68:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102f6d:	85 c0                	test   %eax,%eax
80102f6f:	74 0f                	je     80102f80 <cpunum+0x52>
    return lapic[ID]>>24;
80102f71:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102f76:	83 c0 20             	add    $0x20,%eax
80102f79:	8b 00                	mov    (%eax),%eax
80102f7b:	c1 e8 18             	shr    $0x18,%eax
80102f7e:	eb 05                	jmp    80102f85 <cpunum+0x57>
  return 0;
80102f80:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f85:	c9                   	leave  
80102f86:	c3                   	ret    

80102f87 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f87:	55                   	push   %ebp
80102f88:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f8a:	a1 dc 22 11 80       	mov    0x801122dc,%eax
80102f8f:	85 c0                	test   %eax,%eax
80102f91:	74 0c                	je     80102f9f <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f93:	6a 00                	push   $0x0
80102f95:	6a 2c                	push   $0x2c
80102f97:	e8 55 fe ff ff       	call   80102df1 <lapicw>
80102f9c:	83 c4 08             	add    $0x8,%esp
}
80102f9f:	c9                   	leave  
80102fa0:	c3                   	ret    

80102fa1 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fa1:	55                   	push   %ebp
80102fa2:	89 e5                	mov    %esp,%ebp
}
80102fa4:	5d                   	pop    %ebp
80102fa5:	c3                   	ret    

80102fa6 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fa6:	55                   	push   %ebp
80102fa7:	89 e5                	mov    %esp,%ebp
80102fa9:	83 ec 14             	sub    $0x14,%esp
80102fac:	8b 45 08             	mov    0x8(%ebp),%eax
80102faf:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fb2:	6a 0f                	push   $0xf
80102fb4:	6a 70                	push   $0x70
80102fb6:	e8 08 fe ff ff       	call   80102dc3 <outb>
80102fbb:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102fbe:	6a 0a                	push   $0xa
80102fc0:	6a 71                	push   $0x71
80102fc2:	e8 fc fd ff ff       	call   80102dc3 <outb>
80102fc7:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fca:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd4:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fdc:	83 c0 02             	add    $0x2,%eax
80102fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80102fe2:	c1 ea 04             	shr    $0x4,%edx
80102fe5:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fe8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fec:	c1 e0 18             	shl    $0x18,%eax
80102fef:	50                   	push   %eax
80102ff0:	68 c4 00 00 00       	push   $0xc4
80102ff5:	e8 f7 fd ff ff       	call   80102df1 <lapicw>
80102ffa:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ffd:	68 00 c5 00 00       	push   $0xc500
80103002:	68 c0 00 00 00       	push   $0xc0
80103007:	e8 e5 fd ff ff       	call   80102df1 <lapicw>
8010300c:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010300f:	68 c8 00 00 00       	push   $0xc8
80103014:	e8 88 ff ff ff       	call   80102fa1 <microdelay>
80103019:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010301c:	68 00 85 00 00       	push   $0x8500
80103021:	68 c0 00 00 00       	push   $0xc0
80103026:	e8 c6 fd ff ff       	call   80102df1 <lapicw>
8010302b:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010302e:	6a 64                	push   $0x64
80103030:	e8 6c ff ff ff       	call   80102fa1 <microdelay>
80103035:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010303f:	eb 3d                	jmp    8010307e <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103041:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103045:	c1 e0 18             	shl    $0x18,%eax
80103048:	50                   	push   %eax
80103049:	68 c4 00 00 00       	push   $0xc4
8010304e:	e8 9e fd ff ff       	call   80102df1 <lapicw>
80103053:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103056:	8b 45 0c             	mov    0xc(%ebp),%eax
80103059:	c1 e8 0c             	shr    $0xc,%eax
8010305c:	80 cc 06             	or     $0x6,%ah
8010305f:	50                   	push   %eax
80103060:	68 c0 00 00 00       	push   $0xc0
80103065:	e8 87 fd ff ff       	call   80102df1 <lapicw>
8010306a:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010306d:	68 c8 00 00 00       	push   $0xc8
80103072:	e8 2a ff ff ff       	call   80102fa1 <microdelay>
80103077:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010307a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010307e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103082:	7e bd                	jle    80103041 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103084:	c9                   	leave  
80103085:	c3                   	ret    

80103086 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103086:	55                   	push   %ebp
80103087:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103089:	8b 45 08             	mov    0x8(%ebp),%eax
8010308c:	0f b6 c0             	movzbl %al,%eax
8010308f:	50                   	push   %eax
80103090:	6a 70                	push   $0x70
80103092:	e8 2c fd ff ff       	call   80102dc3 <outb>
80103097:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010309a:	68 c8 00 00 00       	push   $0xc8
8010309f:	e8 fd fe ff ff       	call   80102fa1 <microdelay>
801030a4:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030a7:	6a 71                	push   $0x71
801030a9:	e8 f8 fc ff ff       	call   80102da6 <inb>
801030ae:	83 c4 04             	add    $0x4,%esp
801030b1:	0f b6 c0             	movzbl %al,%eax
}
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    

801030b6 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030b6:	55                   	push   %ebp
801030b7:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801030b9:	6a 00                	push   $0x0
801030bb:	e8 c6 ff ff ff       	call   80103086 <cmos_read>
801030c0:	83 c4 04             	add    $0x4,%esp
801030c3:	89 c2                	mov    %eax,%edx
801030c5:	8b 45 08             	mov    0x8(%ebp),%eax
801030c8:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801030ca:	6a 02                	push   $0x2
801030cc:	e8 b5 ff ff ff       	call   80103086 <cmos_read>
801030d1:	83 c4 04             	add    $0x4,%esp
801030d4:	89 c2                	mov    %eax,%edx
801030d6:	8b 45 08             	mov    0x8(%ebp),%eax
801030d9:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801030dc:	6a 04                	push   $0x4
801030de:	e8 a3 ff ff ff       	call   80103086 <cmos_read>
801030e3:	83 c4 04             	add    $0x4,%esp
801030e6:	89 c2                	mov    %eax,%edx
801030e8:	8b 45 08             	mov    0x8(%ebp),%eax
801030eb:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801030ee:	6a 07                	push   $0x7
801030f0:	e8 91 ff ff ff       	call   80103086 <cmos_read>
801030f5:	83 c4 04             	add    $0x4,%esp
801030f8:	89 c2                	mov    %eax,%edx
801030fa:	8b 45 08             	mov    0x8(%ebp),%eax
801030fd:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103100:	6a 08                	push   $0x8
80103102:	e8 7f ff ff ff       	call   80103086 <cmos_read>
80103107:	83 c4 04             	add    $0x4,%esp
8010310a:	89 c2                	mov    %eax,%edx
8010310c:	8b 45 08             	mov    0x8(%ebp),%eax
8010310f:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103112:	6a 09                	push   $0x9
80103114:	e8 6d ff ff ff       	call   80103086 <cmos_read>
80103119:	83 c4 04             	add    $0x4,%esp
8010311c:	89 c2                	mov    %eax,%edx
8010311e:	8b 45 08             	mov    0x8(%ebp),%eax
80103121:	89 50 14             	mov    %edx,0x14(%eax)
}
80103124:	c9                   	leave  
80103125:	c3                   	ret    

80103126 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103126:	55                   	push   %ebp
80103127:	89 e5                	mov    %esp,%ebp
80103129:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010312c:	6a 0b                	push   $0xb
8010312e:	e8 53 ff ff ff       	call   80103086 <cmos_read>
80103133:	83 c4 04             	add    $0x4,%esp
80103136:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010313c:	83 e0 04             	and    $0x4,%eax
8010313f:	85 c0                	test   %eax,%eax
80103141:	0f 94 c0             	sete   %al
80103144:	0f b6 c0             	movzbl %al,%eax
80103147:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010314a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314d:	50                   	push   %eax
8010314e:	e8 63 ff ff ff       	call   801030b6 <fill_rtcdate>
80103153:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103156:	6a 0a                	push   $0xa
80103158:	e8 29 ff ff ff       	call   80103086 <cmos_read>
8010315d:	83 c4 04             	add    $0x4,%esp
80103160:	25 80 00 00 00       	and    $0x80,%eax
80103165:	85 c0                	test   %eax,%eax
80103167:	74 02                	je     8010316b <cmostime+0x45>
        continue;
80103169:	eb 32                	jmp    8010319d <cmostime+0x77>
    fill_rtcdate(&t2);
8010316b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010316e:	50                   	push   %eax
8010316f:	e8 42 ff ff ff       	call   801030b6 <fill_rtcdate>
80103174:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103177:	83 ec 04             	sub    $0x4,%esp
8010317a:	6a 18                	push   $0x18
8010317c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317f:	50                   	push   %eax
80103180:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103183:	50                   	push   %eax
80103184:	e8 71 20 00 00       	call   801051fa <memcmp>
80103189:	83 c4 10             	add    $0x10,%esp
8010318c:	85 c0                	test   %eax,%eax
8010318e:	75 0d                	jne    8010319d <cmostime+0x77>
      break;
80103190:	90                   	nop
  }

  // convert
  if (bcd) {
80103191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103195:	0f 84 b8 00 00 00    	je     80103253 <cmostime+0x12d>
8010319b:	eb 02                	jmp    8010319f <cmostime+0x79>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010319d:	eb ab                	jmp    8010314a <cmostime+0x24>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010319f:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031a2:	c1 e8 04             	shr    $0x4,%eax
801031a5:	89 c2                	mov    %eax,%edx
801031a7:	89 d0                	mov    %edx,%eax
801031a9:	c1 e0 02             	shl    $0x2,%eax
801031ac:	01 d0                	add    %edx,%eax
801031ae:	01 c0                	add    %eax,%eax
801031b0:	89 c2                	mov    %eax,%edx
801031b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031b5:	83 e0 0f             	and    $0xf,%eax
801031b8:	01 d0                	add    %edx,%eax
801031ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031c0:	c1 e8 04             	shr    $0x4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	89 d0                	mov    %edx,%eax
801031c7:	c1 e0 02             	shl    $0x2,%eax
801031ca:	01 d0                	add    %edx,%eax
801031cc:	01 c0                	add    %eax,%eax
801031ce:	89 c2                	mov    %eax,%edx
801031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031d3:	83 e0 0f             	and    $0xf,%eax
801031d6:	01 d0                	add    %edx,%eax
801031d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031de:	c1 e8 04             	shr    $0x4,%eax
801031e1:	89 c2                	mov    %eax,%edx
801031e3:	89 d0                	mov    %edx,%eax
801031e5:	c1 e0 02             	shl    $0x2,%eax
801031e8:	01 d0                	add    %edx,%eax
801031ea:	01 c0                	add    %eax,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031f1:	83 e0 0f             	and    $0xf,%eax
801031f4:	01 d0                	add    %edx,%eax
801031f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031fc:	c1 e8 04             	shr    $0x4,%eax
801031ff:	89 c2                	mov    %eax,%edx
80103201:	89 d0                	mov    %edx,%eax
80103203:	c1 e0 02             	shl    $0x2,%eax
80103206:	01 d0                	add    %edx,%eax
80103208:	01 c0                	add    %eax,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010320f:	83 e0 0f             	and    $0xf,%eax
80103212:	01 d0                	add    %edx,%eax
80103214:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103217:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010321a:	c1 e8 04             	shr    $0x4,%eax
8010321d:	89 c2                	mov    %eax,%edx
8010321f:	89 d0                	mov    %edx,%eax
80103221:	c1 e0 02             	shl    $0x2,%eax
80103224:	01 d0                	add    %edx,%eax
80103226:	01 c0                	add    %eax,%eax
80103228:	89 c2                	mov    %eax,%edx
8010322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010322d:	83 e0 0f             	and    $0xf,%eax
80103230:	01 d0                	add    %edx,%eax
80103232:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103235:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103238:	c1 e8 04             	shr    $0x4,%eax
8010323b:	89 c2                	mov    %eax,%edx
8010323d:	89 d0                	mov    %edx,%eax
8010323f:	c1 e0 02             	shl    $0x2,%eax
80103242:	01 d0                	add    %edx,%eax
80103244:	01 c0                	add    %eax,%eax
80103246:	89 c2                	mov    %eax,%edx
80103248:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010324b:	83 e0 0f             	and    $0xf,%eax
8010324e:	01 d0                	add    %edx,%eax
80103250:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103253:	8b 45 08             	mov    0x8(%ebp),%eax
80103256:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103259:	89 10                	mov    %edx,(%eax)
8010325b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010325e:	89 50 04             	mov    %edx,0x4(%eax)
80103261:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103264:	89 50 08             	mov    %edx,0x8(%eax)
80103267:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010326a:	89 50 0c             	mov    %edx,0xc(%eax)
8010326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103270:	89 50 10             	mov    %edx,0x10(%eax)
80103273:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103276:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103279:	8b 45 08             	mov    0x8(%ebp),%eax
8010327c:	8b 40 14             	mov    0x14(%eax),%eax
8010327f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103285:	8b 45 08             	mov    0x8(%ebp),%eax
80103288:	89 50 14             	mov    %edx,0x14(%eax)
}
8010328b:	c9                   	leave  
8010328c:	c3                   	ret    

8010328d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
8010328d:	55                   	push   %ebp
8010328e:	89 e5                	mov    %esp,%ebp
80103290:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103293:	83 ec 08             	sub    $0x8,%esp
80103296:	68 60 86 10 80       	push   $0x80108660
8010329b:	68 00 23 11 80       	push   $0x80112300
801032a0:	e8 71 1c 00 00       	call   80104f16 <initlock>
801032a5:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
801032a8:	83 ec 08             	sub    $0x8,%esp
801032ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
801032ae:	50                   	push   %eax
801032af:	6a 01                	push   $0x1
801032b1:	e8 94 e0 ff ff       	call   8010134a <readsb>
801032b6:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
801032b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032bf:	29 c2                	sub    %eax,%edx
801032c1:	89 d0                	mov    %edx,%eax
801032c3:	a3 34 23 11 80       	mov    %eax,0x80112334
  log.size = sb.nlog;
801032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cb:	a3 38 23 11 80       	mov    %eax,0x80112338
  log.dev = ROOTDEV;
801032d0:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
801032d7:	00 00 00 
  recover_from_log();
801032da:	e8 ae 01 00 00       	call   8010348d <recover_from_log>
}
801032df:	c9                   	leave  
801032e0:	c3                   	ret    

801032e1 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032e1:	55                   	push   %ebp
801032e2:	89 e5                	mov    %esp,%ebp
801032e4:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032ee:	e9 95 00 00 00       	jmp    80103388 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032f3:	8b 15 34 23 11 80    	mov    0x80112334,%edx
801032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032fc:	01 d0                	add    %edx,%eax
801032fe:	83 c0 01             	add    $0x1,%eax
80103301:	89 c2                	mov    %eax,%edx
80103303:	a1 44 23 11 80       	mov    0x80112344,%eax
80103308:	83 ec 08             	sub    $0x8,%esp
8010330b:	52                   	push   %edx
8010330c:	50                   	push   %eax
8010330d:	e8 a2 ce ff ff       	call   801001b4 <bread>
80103312:	83 c4 10             	add    $0x10,%esp
80103315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010331b:	83 c0 10             	add    $0x10,%eax
8010331e:	8b 04 85 0c 23 11 80 	mov    -0x7feedcf4(,%eax,4),%eax
80103325:	89 c2                	mov    %eax,%edx
80103327:	a1 44 23 11 80       	mov    0x80112344,%eax
8010332c:	83 ec 08             	sub    $0x8,%esp
8010332f:	52                   	push   %edx
80103330:	50                   	push   %eax
80103331:	e8 7e ce ff ff       	call   801001b4 <bread>
80103336:	83 c4 10             	add    $0x10,%esp
80103339:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010333c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333f:	8d 50 18             	lea    0x18(%eax),%edx
80103342:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103345:	83 c0 18             	add    $0x18,%eax
80103348:	83 ec 04             	sub    $0x4,%esp
8010334b:	68 00 02 00 00       	push   $0x200
80103350:	52                   	push   %edx
80103351:	50                   	push   %eax
80103352:	e8 fb 1e 00 00       	call   80105252 <memmove>
80103357:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010335a:	83 ec 0c             	sub    $0xc,%esp
8010335d:	ff 75 ec             	pushl  -0x14(%ebp)
80103360:	e8 88 ce ff ff       	call   801001ed <bwrite>
80103365:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103368:	83 ec 0c             	sub    $0xc,%esp
8010336b:	ff 75 f0             	pushl  -0x10(%ebp)
8010336e:	e8 b8 ce ff ff       	call   8010022b <brelse>
80103373:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103376:	83 ec 0c             	sub    $0xc,%esp
80103379:	ff 75 ec             	pushl  -0x14(%ebp)
8010337c:	e8 aa ce ff ff       	call   8010022b <brelse>
80103381:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103384:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103388:	a1 48 23 11 80       	mov    0x80112348,%eax
8010338d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103390:	0f 8f 5d ff ff ff    	jg     801032f3 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103396:	c9                   	leave  
80103397:	c3                   	ret    

80103398 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103398:	55                   	push   %ebp
80103399:	89 e5                	mov    %esp,%ebp
8010339b:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010339e:	a1 34 23 11 80       	mov    0x80112334,%eax
801033a3:	89 c2                	mov    %eax,%edx
801033a5:	a1 44 23 11 80       	mov    0x80112344,%eax
801033aa:	83 ec 08             	sub    $0x8,%esp
801033ad:	52                   	push   %edx
801033ae:	50                   	push   %eax
801033af:	e8 00 ce ff ff       	call   801001b4 <bread>
801033b4:	83 c4 10             	add    $0x10,%esp
801033b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033bd:	83 c0 18             	add    $0x18,%eax
801033c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c6:	8b 00                	mov    (%eax),%eax
801033c8:	a3 48 23 11 80       	mov    %eax,0x80112348
  for (i = 0; i < log.lh.n; i++) {
801033cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d4:	eb 1b                	jmp    801033f1 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801033d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033dc:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e3:	83 c2 10             	add    $0x10,%edx
801033e6:	89 04 95 0c 23 11 80 	mov    %eax,-0x7feedcf4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f1:	a1 48 23 11 80       	mov    0x80112348,%eax
801033f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033f9:	7f db                	jg     801033d6 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801033fb:	83 ec 0c             	sub    $0xc,%esp
801033fe:	ff 75 f0             	pushl  -0x10(%ebp)
80103401:	e8 25 ce ff ff       	call   8010022b <brelse>
80103406:	83 c4 10             	add    $0x10,%esp
}
80103409:	c9                   	leave  
8010340a:	c3                   	ret    

8010340b <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010340b:	55                   	push   %ebp
8010340c:	89 e5                	mov    %esp,%ebp
8010340e:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103411:	a1 34 23 11 80       	mov    0x80112334,%eax
80103416:	89 c2                	mov    %eax,%edx
80103418:	a1 44 23 11 80       	mov    0x80112344,%eax
8010341d:	83 ec 08             	sub    $0x8,%esp
80103420:	52                   	push   %edx
80103421:	50                   	push   %eax
80103422:	e8 8d cd ff ff       	call   801001b4 <bread>
80103427:	83 c4 10             	add    $0x10,%esp
8010342a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010342d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103430:	83 c0 18             	add    $0x18,%eax
80103433:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103436:	8b 15 48 23 11 80    	mov    0x80112348,%edx
8010343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010343f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103448:	eb 1b                	jmp    80103465 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010344d:	83 c0 10             	add    $0x10,%eax
80103450:	8b 0c 85 0c 23 11 80 	mov    -0x7feedcf4(,%eax,4),%ecx
80103457:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010345d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103461:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103465:	a1 48 23 11 80       	mov    0x80112348,%eax
8010346a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010346d:	7f db                	jg     8010344a <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010346f:	83 ec 0c             	sub    $0xc,%esp
80103472:	ff 75 f0             	pushl  -0x10(%ebp)
80103475:	e8 73 cd ff ff       	call   801001ed <bwrite>
8010347a:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010347d:	83 ec 0c             	sub    $0xc,%esp
80103480:	ff 75 f0             	pushl  -0x10(%ebp)
80103483:	e8 a3 cd ff ff       	call   8010022b <brelse>
80103488:	83 c4 10             	add    $0x10,%esp
}
8010348b:	c9                   	leave  
8010348c:	c3                   	ret    

8010348d <recover_from_log>:

static void
recover_from_log(void)
{
8010348d:	55                   	push   %ebp
8010348e:	89 e5                	mov    %esp,%ebp
80103490:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103493:	e8 00 ff ff ff       	call   80103398 <read_head>
  install_trans(); // if committed, copy from log to disk
80103498:	e8 44 fe ff ff       	call   801032e1 <install_trans>
  log.lh.n = 0;
8010349d:	c7 05 48 23 11 80 00 	movl   $0x0,0x80112348
801034a4:	00 00 00 
  write_head(); // clear the log
801034a7:	e8 5f ff ff ff       	call   8010340b <write_head>
}
801034ac:	c9                   	leave  
801034ad:	c3                   	ret    

801034ae <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034ae:	55                   	push   %ebp
801034af:	89 e5                	mov    %esp,%ebp
801034b1:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801034b4:	83 ec 0c             	sub    $0xc,%esp
801034b7:	68 00 23 11 80       	push   $0x80112300
801034bc:	e8 76 1a 00 00       	call   80104f37 <acquire>
801034c1:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801034c4:	a1 40 23 11 80       	mov    0x80112340,%eax
801034c9:	85 c0                	test   %eax,%eax
801034cb:	74 17                	je     801034e4 <begin_op+0x36>
      sleep(&log, &log.lock);
801034cd:	83 ec 08             	sub    $0x8,%esp
801034d0:	68 00 23 11 80       	push   $0x80112300
801034d5:	68 00 23 11 80       	push   $0x80112300
801034da:	e8 68 17 00 00       	call   80104c47 <sleep>
801034df:	83 c4 10             	add    $0x10,%esp
801034e2:	eb 54                	jmp    80103538 <begin_op+0x8a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034e4:	8b 0d 48 23 11 80    	mov    0x80112348,%ecx
801034ea:	a1 3c 23 11 80       	mov    0x8011233c,%eax
801034ef:	8d 50 01             	lea    0x1(%eax),%edx
801034f2:	89 d0                	mov    %edx,%eax
801034f4:	c1 e0 02             	shl    $0x2,%eax
801034f7:	01 d0                	add    %edx,%eax
801034f9:	01 c0                	add    %eax,%eax
801034fb:	01 c8                	add    %ecx,%eax
801034fd:	83 f8 1e             	cmp    $0x1e,%eax
80103500:	7e 17                	jle    80103519 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103502:	83 ec 08             	sub    $0x8,%esp
80103505:	68 00 23 11 80       	push   $0x80112300
8010350a:	68 00 23 11 80       	push   $0x80112300
8010350f:	e8 33 17 00 00       	call   80104c47 <sleep>
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	eb 1f                	jmp    80103538 <begin_op+0x8a>
    } else {
      log.outstanding += 1;
80103519:	a1 3c 23 11 80       	mov    0x8011233c,%eax
8010351e:	83 c0 01             	add    $0x1,%eax
80103521:	a3 3c 23 11 80       	mov    %eax,0x8011233c
      release(&log.lock);
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	68 00 23 11 80       	push   $0x80112300
8010352e:	e8 6a 1a 00 00       	call   80104f9d <release>
80103533:	83 c4 10             	add    $0x10,%esp
      break;
80103536:	eb 02                	jmp    8010353a <begin_op+0x8c>
    }
  }
80103538:	eb 8a                	jmp    801034c4 <begin_op+0x16>
}
8010353a:	c9                   	leave  
8010353b:	c3                   	ret    

8010353c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010353c:	55                   	push   %ebp
8010353d:	89 e5                	mov    %esp,%ebp
8010353f:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103549:	83 ec 0c             	sub    $0xc,%esp
8010354c:	68 00 23 11 80       	push   $0x80112300
80103551:	e8 e1 19 00 00       	call   80104f37 <acquire>
80103556:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103559:	a1 3c 23 11 80       	mov    0x8011233c,%eax
8010355e:	83 e8 01             	sub    $0x1,%eax
80103561:	a3 3c 23 11 80       	mov    %eax,0x8011233c
  if(log.committing)
80103566:	a1 40 23 11 80       	mov    0x80112340,%eax
8010356b:	85 c0                	test   %eax,%eax
8010356d:	74 0d                	je     8010357c <end_op+0x40>
    panic("log.committing");
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	68 64 86 10 80       	push   $0x80108664
80103577:	e8 e0 cf ff ff       	call   8010055c <panic>
  if(log.outstanding == 0){
8010357c:	a1 3c 23 11 80       	mov    0x8011233c,%eax
80103581:	85 c0                	test   %eax,%eax
80103583:	75 13                	jne    80103598 <end_op+0x5c>
    do_commit = 1;
80103585:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010358c:	c7 05 40 23 11 80 01 	movl   $0x1,0x80112340
80103593:	00 00 00 
80103596:	eb 10                	jmp    801035a8 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103598:	83 ec 0c             	sub    $0xc,%esp
8010359b:	68 00 23 11 80       	push   $0x80112300
801035a0:	e8 8b 17 00 00       	call   80104d30 <wakeup>
801035a5:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035a8:	83 ec 0c             	sub    $0xc,%esp
801035ab:	68 00 23 11 80       	push   $0x80112300
801035b0:	e8 e8 19 00 00       	call   80104f9d <release>
801035b5:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801035b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035bc:	74 3f                	je     801035fd <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035be:	e8 f3 00 00 00       	call   801036b6 <commit>
    acquire(&log.lock);
801035c3:	83 ec 0c             	sub    $0xc,%esp
801035c6:	68 00 23 11 80       	push   $0x80112300
801035cb:	e8 67 19 00 00       	call   80104f37 <acquire>
801035d0:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d3:	c7 05 40 23 11 80 00 	movl   $0x0,0x80112340
801035da:	00 00 00 
    wakeup(&log);
801035dd:	83 ec 0c             	sub    $0xc,%esp
801035e0:	68 00 23 11 80       	push   $0x80112300
801035e5:	e8 46 17 00 00       	call   80104d30 <wakeup>
801035ea:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035ed:	83 ec 0c             	sub    $0xc,%esp
801035f0:	68 00 23 11 80       	push   $0x80112300
801035f5:	e8 a3 19 00 00       	call   80104f9d <release>
801035fa:	83 c4 10             	add    $0x10,%esp
  }
}
801035fd:	c9                   	leave  
801035fe:	c3                   	ret    

801035ff <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035ff:	55                   	push   %ebp
80103600:	89 e5                	mov    %esp,%ebp
80103602:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103605:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010360c:	e9 95 00 00 00       	jmp    801036a6 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103611:	8b 15 34 23 11 80    	mov    0x80112334,%edx
80103617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010361a:	01 d0                	add    %edx,%eax
8010361c:	83 c0 01             	add    $0x1,%eax
8010361f:	89 c2                	mov    %eax,%edx
80103621:	a1 44 23 11 80       	mov    0x80112344,%eax
80103626:	83 ec 08             	sub    $0x8,%esp
80103629:	52                   	push   %edx
8010362a:	50                   	push   %eax
8010362b:	e8 84 cb ff ff       	call   801001b4 <bread>
80103630:	83 c4 10             	add    $0x10,%esp
80103633:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103639:	83 c0 10             	add    $0x10,%eax
8010363c:	8b 04 85 0c 23 11 80 	mov    -0x7feedcf4(,%eax,4),%eax
80103643:	89 c2                	mov    %eax,%edx
80103645:	a1 44 23 11 80       	mov    0x80112344,%eax
8010364a:	83 ec 08             	sub    $0x8,%esp
8010364d:	52                   	push   %edx
8010364e:	50                   	push   %eax
8010364f:	e8 60 cb ff ff       	call   801001b4 <bread>
80103654:	83 c4 10             	add    $0x10,%esp
80103657:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010365a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010365d:	8d 50 18             	lea    0x18(%eax),%edx
80103660:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103663:	83 c0 18             	add    $0x18,%eax
80103666:	83 ec 04             	sub    $0x4,%esp
80103669:	68 00 02 00 00       	push   $0x200
8010366e:	52                   	push   %edx
8010366f:	50                   	push   %eax
80103670:	e8 dd 1b 00 00       	call   80105252 <memmove>
80103675:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	ff 75 f0             	pushl  -0x10(%ebp)
8010367e:	e8 6a cb ff ff       	call   801001ed <bwrite>
80103683:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103686:	83 ec 0c             	sub    $0xc,%esp
80103689:	ff 75 ec             	pushl  -0x14(%ebp)
8010368c:	e8 9a cb ff ff       	call   8010022b <brelse>
80103691:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	ff 75 f0             	pushl  -0x10(%ebp)
8010369a:	e8 8c cb ff ff       	call   8010022b <brelse>
8010369f:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036a6:	a1 48 23 11 80       	mov    0x80112348,%eax
801036ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036ae:	0f 8f 5d ff ff ff    	jg     80103611 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036b4:	c9                   	leave  
801036b5:	c3                   	ret    

801036b6 <commit>:

static void
commit()
{
801036b6:	55                   	push   %ebp
801036b7:	89 e5                	mov    %esp,%ebp
801036b9:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036bc:	a1 48 23 11 80       	mov    0x80112348,%eax
801036c1:	85 c0                	test   %eax,%eax
801036c3:	7e 1e                	jle    801036e3 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036c5:	e8 35 ff ff ff       	call   801035ff <write_log>
    write_head();    // Write header to disk -- the real commit
801036ca:	e8 3c fd ff ff       	call   8010340b <write_head>
    install_trans(); // Now install writes to home locations
801036cf:	e8 0d fc ff ff       	call   801032e1 <install_trans>
    log.lh.n = 0; 
801036d4:	c7 05 48 23 11 80 00 	movl   $0x0,0x80112348
801036db:	00 00 00 
    write_head();    // Erase the transaction from the log
801036de:	e8 28 fd ff ff       	call   8010340b <write_head>
  }
}
801036e3:	c9                   	leave  
801036e4:	c3                   	ret    

801036e5 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036e5:	55                   	push   %ebp
801036e6:	89 e5                	mov    %esp,%ebp
801036e8:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036eb:	a1 48 23 11 80       	mov    0x80112348,%eax
801036f0:	83 f8 1d             	cmp    $0x1d,%eax
801036f3:	7f 12                	jg     80103707 <log_write+0x22>
801036f5:	a1 48 23 11 80       	mov    0x80112348,%eax
801036fa:	8b 15 38 23 11 80    	mov    0x80112338,%edx
80103700:	83 ea 01             	sub    $0x1,%edx
80103703:	39 d0                	cmp    %edx,%eax
80103705:	7c 0d                	jl     80103714 <log_write+0x2f>
    panic("too big a transaction");
80103707:	83 ec 0c             	sub    $0xc,%esp
8010370a:	68 73 86 10 80       	push   $0x80108673
8010370f:	e8 48 ce ff ff       	call   8010055c <panic>
  if (log.outstanding < 1)
80103714:	a1 3c 23 11 80       	mov    0x8011233c,%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	7f 0d                	jg     8010372a <log_write+0x45>
    panic("log_write outside of trans");
8010371d:	83 ec 0c             	sub    $0xc,%esp
80103720:	68 89 86 10 80       	push   $0x80108689
80103725:	e8 32 ce ff ff       	call   8010055c <panic>

  acquire(&log.lock);
8010372a:	83 ec 0c             	sub    $0xc,%esp
8010372d:	68 00 23 11 80       	push   $0x80112300
80103732:	e8 00 18 00 00       	call   80104f37 <acquire>
80103737:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010373a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103741:	eb 1f                	jmp    80103762 <log_write+0x7d>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103746:	83 c0 10             	add    $0x10,%eax
80103749:	8b 04 85 0c 23 11 80 	mov    -0x7feedcf4(,%eax,4),%eax
80103750:	89 c2                	mov    %eax,%edx
80103752:	8b 45 08             	mov    0x8(%ebp),%eax
80103755:	8b 40 08             	mov    0x8(%eax),%eax
80103758:	39 c2                	cmp    %eax,%edx
8010375a:	75 02                	jne    8010375e <log_write+0x79>
      break;
8010375c:	eb 0e                	jmp    8010376c <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010375e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103762:	a1 48 23 11 80       	mov    0x80112348,%eax
80103767:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010376a:	7f d7                	jg     80103743 <log_write+0x5e>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
8010376c:	8b 45 08             	mov    0x8(%ebp),%eax
8010376f:	8b 40 08             	mov    0x8(%eax),%eax
80103772:	89 c2                	mov    %eax,%edx
80103774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103777:	83 c0 10             	add    $0x10,%eax
8010377a:	89 14 85 0c 23 11 80 	mov    %edx,-0x7feedcf4(,%eax,4)
  if (i == log.lh.n)
80103781:	a1 48 23 11 80       	mov    0x80112348,%eax
80103786:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103789:	75 0d                	jne    80103798 <log_write+0xb3>
    log.lh.n++;
8010378b:	a1 48 23 11 80       	mov    0x80112348,%eax
80103790:	83 c0 01             	add    $0x1,%eax
80103793:	a3 48 23 11 80       	mov    %eax,0x80112348
  b->flags |= B_DIRTY; // prevent eviction
80103798:	8b 45 08             	mov    0x8(%ebp),%eax
8010379b:	8b 00                	mov    (%eax),%eax
8010379d:	83 c8 04             	or     $0x4,%eax
801037a0:	89 c2                	mov    %eax,%edx
801037a2:	8b 45 08             	mov    0x8(%ebp),%eax
801037a5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037a7:	83 ec 0c             	sub    $0xc,%esp
801037aa:	68 00 23 11 80       	push   $0x80112300
801037af:	e8 e9 17 00 00       	call   80104f9d <release>
801037b4:	83 c4 10             	add    $0x10,%esp
}
801037b7:	c9                   	leave  
801037b8:	c3                   	ret    

801037b9 <v2p>:
801037b9:	55                   	push   %ebp
801037ba:	89 e5                	mov    %esp,%ebp
801037bc:	8b 45 08             	mov    0x8(%ebp),%eax
801037bf:	05 00 00 00 80       	add    $0x80000000,%eax
801037c4:	5d                   	pop    %ebp
801037c5:	c3                   	ret    

801037c6 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037c6:	55                   	push   %ebp
801037c7:	89 e5                	mov    %esp,%ebp
801037c9:	8b 45 08             	mov    0x8(%ebp),%eax
801037cc:	05 00 00 00 80       	add    $0x80000000,%eax
801037d1:	5d                   	pop    %ebp
801037d2:	c3                   	ret    

801037d3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037d3:	55                   	push   %ebp
801037d4:	89 e5                	mov    %esp,%ebp
801037d6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037d9:	8b 55 08             	mov    0x8(%ebp),%edx
801037dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801037df:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037e2:	f0 87 02             	lock xchg %eax,(%edx)
801037e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037eb:	c9                   	leave  
801037ec:	c3                   	ret    

801037ed <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037ed:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037f1:	83 e4 f0             	and    $0xfffffff0,%esp
801037f4:	ff 71 fc             	pushl  -0x4(%ecx)
801037f7:	55                   	push   %ebp
801037f8:	89 e5                	mov    %esp,%ebp
801037fa:	51                   	push   %ecx
801037fb:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037fe:	83 ec 08             	sub    $0x8,%esp
80103801:	68 00 00 40 80       	push   $0x80400000
80103806:	68 1c 52 11 80       	push   $0x8011521c
8010380b:	e8 8a f2 ff ff       	call   80102a9a <kinit1>
80103810:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103813:	e8 c2 44 00 00       	call   80107cda <kvmalloc>
  mpinit();        // collect info about this machine
80103818:	e8 45 04 00 00       	call   80103c62 <mpinit>
  lapicinit();
8010381d:	e8 f0 f5 ff ff       	call   80102e12 <lapicinit>
  seginit();       // set up segments
80103822:	e8 5b 3e 00 00       	call   80107682 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103827:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010382d:	0f b6 00             	movzbl (%eax),%eax
80103830:	0f b6 c0             	movzbl %al,%eax
80103833:	83 ec 08             	sub    $0x8,%esp
80103836:	50                   	push   %eax
80103837:	68 a4 86 10 80       	push   $0x801086a4
8010383c:	e8 7e cb ff ff       	call   801003bf <cprintf>
80103841:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103844:	e8 6a 06 00 00       	call   80103eb3 <picinit>
  ioapicinit();    // another interrupt controller
80103849:	e8 44 f1 ff ff       	call   80102992 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010384e:	e8 90 d2 ff ff       	call   80100ae3 <consoleinit>
  uartinit();      // serial port
80103853:	e8 8d 31 00 00       	call   801069e5 <uartinit>
  pinit();         // process table
80103858:	e8 55 0b 00 00       	call   801043b2 <pinit>
  tvinit();        // trap vectors
8010385d:	e8 52 2d 00 00       	call   801065b4 <tvinit>
  binit();         // buffer cache
80103862:	e8 cd c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103867:	e8 d2 d6 ff ff       	call   80100f3e <fileinit>
  iinit();         // inode cache
8010386c:	e8 98 dd ff ff       	call   80101609 <iinit>
  ideinit();       // disk
80103871:	e8 28 ed ff ff       	call   8010259e <ideinit>
  if(!ismp)
80103876:	a1 04 24 11 80       	mov    0x80112404,%eax
8010387b:	85 c0                	test   %eax,%eax
8010387d:	75 05                	jne    80103884 <main+0x97>
    timerinit();   // uniprocessor timer
8010387f:	e8 8f 2c 00 00       	call   80106513 <timerinit>
  startothers();   // start other processors
80103884:	e8 7f 00 00 00       	call   80103908 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103889:	83 ec 08             	sub    $0x8,%esp
8010388c:	68 00 00 00 8e       	push   $0x8e000000
80103891:	68 00 00 40 80       	push   $0x80400000
80103896:	e8 37 f2 ff ff       	call   80102ad2 <kinit2>
8010389b:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010389e:	e8 31 0c 00 00       	call   801044d4 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038a3:	e8 1a 00 00 00       	call   801038c2 <mpmain>

801038a8 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038a8:	55                   	push   %ebp
801038a9:	89 e5                	mov    %esp,%ebp
801038ab:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038ae:	e8 3e 44 00 00       	call   80107cf1 <switchkvm>
  seginit();
801038b3:	e8 ca 3d 00 00       	call   80107682 <seginit>
  lapicinit();
801038b8:	e8 55 f5 ff ff       	call   80102e12 <lapicinit>
  mpmain();
801038bd:	e8 00 00 00 00       	call   801038c2 <mpmain>

801038c2 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038c2:	55                   	push   %ebp
801038c3:	89 e5                	mov    %esp,%ebp
801038c5:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038ce:	0f b6 00             	movzbl (%eax),%eax
801038d1:	0f b6 c0             	movzbl %al,%eax
801038d4:	83 ec 08             	sub    $0x8,%esp
801038d7:	50                   	push   %eax
801038d8:	68 bb 86 10 80       	push   $0x801086bb
801038dd:	e8 dd ca ff ff       	call   801003bf <cprintf>
801038e2:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038e5:	e8 3f 2e 00 00       	call   80106729 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038ea:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038f0:	05 a8 00 00 00       	add    $0xa8,%eax
801038f5:	83 ec 08             	sub    $0x8,%esp
801038f8:	6a 01                	push   $0x1
801038fa:	50                   	push   %eax
801038fb:	e8 d3 fe ff ff       	call   801037d3 <xchg>
80103900:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103903:	e8 76 11 00 00       	call   80104a7e <scheduler>

80103908 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103908:	55                   	push   %ebp
80103909:	89 e5                	mov    %esp,%ebp
8010390b:	53                   	push   %ebx
8010390c:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010390f:	68 00 70 00 00       	push   $0x7000
80103914:	e8 ad fe ff ff       	call   801037c6 <p2v>
80103919:	83 c4 04             	add    $0x4,%esp
8010391c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010391f:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103924:	83 ec 04             	sub    $0x4,%esp
80103927:	50                   	push   %eax
80103928:	68 2c b5 10 80       	push   $0x8010b52c
8010392d:	ff 75 f0             	pushl  -0x10(%ebp)
80103930:	e8 1d 19 00 00       	call   80105252 <memmove>
80103935:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103938:	c7 45 f4 40 24 11 80 	movl   $0x80112440,-0xc(%ebp)
8010393f:	e9 8f 00 00 00       	jmp    801039d3 <startothers+0xcb>
    if(c == cpus+cpunum())  // We've started already.
80103944:	e8 e5 f5 ff ff       	call   80102f2e <cpunum>
80103949:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010394f:	05 40 24 11 80       	add    $0x80112440,%eax
80103954:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103957:	75 02                	jne    8010395b <startothers+0x53>
      continue;
80103959:	eb 71                	jmp    801039cc <startothers+0xc4>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010395b:	e8 6d f2 ff ff       	call   80102bcd <kalloc>
80103960:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103963:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103966:	83 e8 04             	sub    $0x4,%eax
80103969:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010396c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103972:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103974:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103977:	83 e8 08             	sub    $0x8,%eax
8010397a:	c7 00 a8 38 10 80    	movl   $0x801038a8,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103980:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103983:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103986:	83 ec 0c             	sub    $0xc,%esp
80103989:	68 00 a0 10 80       	push   $0x8010a000
8010398e:	e8 26 fe ff ff       	call   801037b9 <v2p>
80103993:	83 c4 10             	add    $0x10,%esp
80103996:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103998:	83 ec 0c             	sub    $0xc,%esp
8010399b:	ff 75 f0             	pushl  -0x10(%ebp)
8010399e:	e8 16 fe ff ff       	call   801037b9 <v2p>
801039a3:	83 c4 10             	add    $0x10,%esp
801039a6:	89 c2                	mov    %eax,%edx
801039a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ab:	0f b6 00             	movzbl (%eax),%eax
801039ae:	0f b6 c0             	movzbl %al,%eax
801039b1:	83 ec 08             	sub    $0x8,%esp
801039b4:	52                   	push   %edx
801039b5:	50                   	push   %eax
801039b6:	e8 eb f5 ff ff       	call   80102fa6 <lapicstartap>
801039bb:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039be:	90                   	nop
801039bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c2:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039c8:	85 c0                	test   %eax,%eax
801039ca:	74 f3                	je     801039bf <startothers+0xb7>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039cc:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039d3:	a1 20 2a 11 80       	mov    0x80112a20,%eax
801039d8:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039de:	05 40 24 11 80       	add    $0x80112440,%eax
801039e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039e6:	0f 87 58 ff ff ff    	ja     80103944 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ef:	c9                   	leave  
801039f0:	c3                   	ret    

801039f1 <p2v>:
801039f1:	55                   	push   %ebp
801039f2:	89 e5                	mov    %esp,%ebp
801039f4:	8b 45 08             	mov    0x8(%ebp),%eax
801039f7:	05 00 00 00 80       	add    $0x80000000,%eax
801039fc:	5d                   	pop    %ebp
801039fd:	c3                   	ret    

801039fe <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039fe:	55                   	push   %ebp
801039ff:	89 e5                	mov    %esp,%ebp
80103a01:	83 ec 14             	sub    $0x14,%esp
80103a04:	8b 45 08             	mov    0x8(%ebp),%eax
80103a07:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a0b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a0f:	89 c2                	mov    %eax,%edx
80103a11:	ec                   	in     (%dx),%al
80103a12:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a15:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a19:	c9                   	leave  
80103a1a:	c3                   	ret    

80103a1b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a1b:	55                   	push   %ebp
80103a1c:	89 e5                	mov    %esp,%ebp
80103a1e:	83 ec 08             	sub    $0x8,%esp
80103a21:	8b 55 08             	mov    0x8(%ebp),%edx
80103a24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a27:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a2b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a2e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a32:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a36:	ee                   	out    %al,(%dx)
}
80103a37:	c9                   	leave  
80103a38:	c3                   	ret    

80103a39 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a39:	55                   	push   %ebp
80103a3a:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a3c:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103a41:	89 c2                	mov    %eax,%edx
80103a43:	b8 40 24 11 80       	mov    $0x80112440,%eax
80103a48:	29 c2                	sub    %eax,%edx
80103a4a:	89 d0                	mov    %edx,%eax
80103a4c:	c1 f8 02             	sar    $0x2,%eax
80103a4f:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a55:	5d                   	pop    %ebp
80103a56:	c3                   	ret    

80103a57 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a57:	55                   	push   %ebp
80103a58:	89 e5                	mov    %esp,%ebp
80103a5a:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a6b:	eb 15                	jmp    80103a82 <sum+0x2b>
    sum += addr[i];
80103a6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a70:	8b 45 08             	mov    0x8(%ebp),%eax
80103a73:	01 d0                	add    %edx,%eax
80103a75:	0f b6 00             	movzbl (%eax),%eax
80103a78:	0f b6 c0             	movzbl %al,%eax
80103a7b:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a7e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a85:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a88:	7c e3                	jl     80103a6d <sum+0x16>
    sum += addr[i];
  return sum;
80103a8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a8d:	c9                   	leave  
80103a8e:	c3                   	ret    

80103a8f <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a8f:	55                   	push   %ebp
80103a90:	89 e5                	mov    %esp,%ebp
80103a92:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a95:	ff 75 08             	pushl  0x8(%ebp)
80103a98:	e8 54 ff ff ff       	call   801039f1 <p2v>
80103a9d:	83 c4 04             	add    $0x4,%esp
80103aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
80103aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa9:	01 d0                	add    %edx,%eax
80103aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ab4:	eb 36                	jmp    80103aec <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ab6:	83 ec 04             	sub    $0x4,%esp
80103ab9:	6a 04                	push   $0x4
80103abb:	68 cc 86 10 80       	push   $0x801086cc
80103ac0:	ff 75 f4             	pushl  -0xc(%ebp)
80103ac3:	e8 32 17 00 00       	call   801051fa <memcmp>
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	85 c0                	test   %eax,%eax
80103acd:	75 19                	jne    80103ae8 <mpsearch1+0x59>
80103acf:	83 ec 08             	sub    $0x8,%esp
80103ad2:	6a 10                	push   $0x10
80103ad4:	ff 75 f4             	pushl  -0xc(%ebp)
80103ad7:	e8 7b ff ff ff       	call   80103a57 <sum>
80103adc:	83 c4 10             	add    $0x10,%esp
80103adf:	84 c0                	test   %al,%al
80103ae1:	75 05                	jne    80103ae8 <mpsearch1+0x59>
      return (struct mp*)p;
80103ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae6:	eb 11                	jmp    80103af9 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ae8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103af2:	72 c2                	jb     80103ab6 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103af9:	c9                   	leave  
80103afa:	c3                   	ret    

80103afb <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103afb:	55                   	push   %ebp
80103afc:	89 e5                	mov    %esp,%ebp
80103afe:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b01:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0b:	83 c0 0f             	add    $0xf,%eax
80103b0e:	0f b6 00             	movzbl (%eax),%eax
80103b11:	0f b6 c0             	movzbl %al,%eax
80103b14:	c1 e0 08             	shl    $0x8,%eax
80103b17:	89 c2                	mov    %eax,%edx
80103b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b1c:	83 c0 0e             	add    $0xe,%eax
80103b1f:	0f b6 00             	movzbl (%eax),%eax
80103b22:	0f b6 c0             	movzbl %al,%eax
80103b25:	09 d0                	or     %edx,%eax
80103b27:	c1 e0 04             	shl    $0x4,%eax
80103b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b31:	74 21                	je     80103b54 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b33:	83 ec 08             	sub    $0x8,%esp
80103b36:	68 00 04 00 00       	push   $0x400
80103b3b:	ff 75 f0             	pushl  -0x10(%ebp)
80103b3e:	e8 4c ff ff ff       	call   80103a8f <mpsearch1>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b4d:	74 51                	je     80103ba0 <mpsearch+0xa5>
      return mp;
80103b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b52:	eb 61                	jmp    80103bb5 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b57:	83 c0 14             	add    $0x14,%eax
80103b5a:	0f b6 00             	movzbl (%eax),%eax
80103b5d:	0f b6 c0             	movzbl %al,%eax
80103b60:	c1 e0 08             	shl    $0x8,%eax
80103b63:	89 c2                	mov    %eax,%edx
80103b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b68:	83 c0 13             	add    $0x13,%eax
80103b6b:	0f b6 00             	movzbl (%eax),%eax
80103b6e:	0f b6 c0             	movzbl %al,%eax
80103b71:	09 d0                	or     %edx,%eax
80103b73:	c1 e0 0a             	shl    $0xa,%eax
80103b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7c:	2d 00 04 00 00       	sub    $0x400,%eax
80103b81:	83 ec 08             	sub    $0x8,%esp
80103b84:	68 00 04 00 00       	push   $0x400
80103b89:	50                   	push   %eax
80103b8a:	e8 00 ff ff ff       	call   80103a8f <mpsearch1>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b99:	74 05                	je     80103ba0 <mpsearch+0xa5>
      return mp;
80103b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b9e:	eb 15                	jmp    80103bb5 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ba0:	83 ec 08             	sub    $0x8,%esp
80103ba3:	68 00 00 01 00       	push   $0x10000
80103ba8:	68 00 00 0f 00       	push   $0xf0000
80103bad:	e8 dd fe ff ff       	call   80103a8f <mpsearch1>
80103bb2:	83 c4 10             	add    $0x10,%esp
}
80103bb5:	c9                   	leave  
80103bb6:	c3                   	ret    

80103bb7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bb7:	55                   	push   %ebp
80103bb8:	89 e5                	mov    %esp,%ebp
80103bba:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bbd:	e8 39 ff ff ff       	call   80103afb <mpsearch>
80103bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bc9:	74 0a                	je     80103bd5 <mpconfig+0x1e>
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 40 04             	mov    0x4(%eax),%eax
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	75 0a                	jne    80103bdf <mpconfig+0x28>
    return 0;
80103bd5:	b8 00 00 00 00       	mov    $0x0,%eax
80103bda:	e9 81 00 00 00       	jmp    80103c60 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be2:	8b 40 04             	mov    0x4(%eax),%eax
80103be5:	83 ec 0c             	sub    $0xc,%esp
80103be8:	50                   	push   %eax
80103be9:	e8 03 fe ff ff       	call   801039f1 <p2v>
80103bee:	83 c4 10             	add    $0x10,%esp
80103bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bf4:	83 ec 04             	sub    $0x4,%esp
80103bf7:	6a 04                	push   $0x4
80103bf9:	68 d1 86 10 80       	push   $0x801086d1
80103bfe:	ff 75 f0             	pushl  -0x10(%ebp)
80103c01:	e8 f4 15 00 00       	call   801051fa <memcmp>
80103c06:	83 c4 10             	add    $0x10,%esp
80103c09:	85 c0                	test   %eax,%eax
80103c0b:	74 07                	je     80103c14 <mpconfig+0x5d>
    return 0;
80103c0d:	b8 00 00 00 00       	mov    $0x0,%eax
80103c12:	eb 4c                	jmp    80103c60 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c17:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c1b:	3c 01                	cmp    $0x1,%al
80103c1d:	74 12                	je     80103c31 <mpconfig+0x7a>
80103c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c22:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c26:	3c 04                	cmp    $0x4,%al
80103c28:	74 07                	je     80103c31 <mpconfig+0x7a>
    return 0;
80103c2a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c2f:	eb 2f                	jmp    80103c60 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c34:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c38:	0f b7 c0             	movzwl %ax,%eax
80103c3b:	83 ec 08             	sub    $0x8,%esp
80103c3e:	50                   	push   %eax
80103c3f:	ff 75 f0             	pushl  -0x10(%ebp)
80103c42:	e8 10 fe ff ff       	call   80103a57 <sum>
80103c47:	83 c4 10             	add    $0x10,%esp
80103c4a:	84 c0                	test   %al,%al
80103c4c:	74 07                	je     80103c55 <mpconfig+0x9e>
    return 0;
80103c4e:	b8 00 00 00 00       	mov    $0x0,%eax
80103c53:	eb 0b                	jmp    80103c60 <mpconfig+0xa9>
  *pmp = mp;
80103c55:	8b 45 08             	mov    0x8(%ebp),%eax
80103c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c5b:	89 10                	mov    %edx,(%eax)
  return conf;
80103c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c60:	c9                   	leave  
80103c61:	c3                   	ret    

80103c62 <mpinit>:

void
mpinit(void)
{
80103c62:	55                   	push   %ebp
80103c63:	89 e5                	mov    %esp,%ebp
80103c65:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c68:	c7 05 64 b6 10 80 40 	movl   $0x80112440,0x8010b664
80103c6f:	24 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c72:	83 ec 0c             	sub    $0xc,%esp
80103c75:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c78:	50                   	push   %eax
80103c79:	e8 39 ff ff ff       	call   80103bb7 <mpconfig>
80103c7e:	83 c4 10             	add    $0x10,%esp
80103c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c88:	75 05                	jne    80103c8f <mpinit+0x2d>
    return;
80103c8a:	e9 94 01 00 00       	jmp    80103e23 <mpinit+0x1c1>
  ismp = 1;
80103c8f:	c7 05 04 24 11 80 01 	movl   $0x1,0x80112404
80103c96:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c9c:	8b 40 24             	mov    0x24(%eax),%eax
80103c9f:	a3 dc 22 11 80       	mov    %eax,0x801122dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca7:	83 c0 2c             	add    $0x2c,%eax
80103caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cb0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cb4:	0f b7 d0             	movzwl %ax,%edx
80103cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cba:	01 d0                	add    %edx,%eax
80103cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cbf:	e9 f2 00 00 00       	jmp    80103db6 <mpinit+0x154>
    switch(*p){
80103cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc7:	0f b6 00             	movzbl (%eax),%eax
80103cca:	0f b6 c0             	movzbl %al,%eax
80103ccd:	83 f8 04             	cmp    $0x4,%eax
80103cd0:	0f 87 bc 00 00 00    	ja     80103d92 <mpinit+0x130>
80103cd6:	8b 04 85 14 87 10 80 	mov    -0x7fef78ec(,%eax,4),%eax
80103cdd:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ce8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cec:	0f b6 d0             	movzbl %al,%edx
80103cef:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80103cf4:	39 c2                	cmp    %eax,%edx
80103cf6:	74 2b                	je     80103d23 <mpinit+0xc1>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cfb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cff:	0f b6 d0             	movzbl %al,%edx
80103d02:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80103d07:	83 ec 04             	sub    $0x4,%esp
80103d0a:	52                   	push   %edx
80103d0b:	50                   	push   %eax
80103d0c:	68 d6 86 10 80       	push   $0x801086d6
80103d11:	e8 a9 c6 ff ff       	call   801003bf <cprintf>
80103d16:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d19:	c7 05 04 24 11 80 00 	movl   $0x0,0x80112404
80103d20:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d26:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d2a:	0f b6 c0             	movzbl %al,%eax
80103d2d:	83 e0 02             	and    $0x2,%eax
80103d30:	85 c0                	test   %eax,%eax
80103d32:	74 15                	je     80103d49 <mpinit+0xe7>
        bcpu = &cpus[ncpu];
80103d34:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80103d39:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d3f:	05 40 24 11 80       	add    $0x80112440,%eax
80103d44:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103d49:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80103d4e:	8b 15 20 2a 11 80    	mov    0x80112a20,%edx
80103d54:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d5a:	05 40 24 11 80       	add    $0x80112440,%eax
80103d5f:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d61:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80103d66:	83 c0 01             	add    $0x1,%eax
80103d69:	a3 20 2a 11 80       	mov    %eax,0x80112a20
      p += sizeof(struct mpproc);
80103d6e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d72:	eb 42                	jmp    80103db6 <mpinit+0x154>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d7d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d81:	a2 00 24 11 80       	mov    %al,0x80112400
      p += sizeof(struct mpioapic);
80103d86:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d8a:	eb 2a                	jmp    80103db6 <mpinit+0x154>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d8c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d90:	eb 24                	jmp    80103db6 <mpinit+0x154>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d95:	0f b6 00             	movzbl (%eax),%eax
80103d98:	0f b6 c0             	movzbl %al,%eax
80103d9b:	83 ec 08             	sub    $0x8,%esp
80103d9e:	50                   	push   %eax
80103d9f:	68 f4 86 10 80       	push   $0x801086f4
80103da4:	e8 16 c6 ff ff       	call   801003bf <cprintf>
80103da9:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103dac:	c7 05 04 24 11 80 00 	movl   $0x0,0x80112404
80103db3:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dbc:	0f 82 02 ff ff ff    	jb     80103cc4 <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103dc2:	a1 04 24 11 80       	mov    0x80112404,%eax
80103dc7:	85 c0                	test   %eax,%eax
80103dc9:	75 1d                	jne    80103de8 <mpinit+0x186>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dcb:	c7 05 20 2a 11 80 01 	movl   $0x1,0x80112a20
80103dd2:	00 00 00 
    lapic = 0;
80103dd5:	c7 05 dc 22 11 80 00 	movl   $0x0,0x801122dc
80103ddc:	00 00 00 
    ioapicid = 0;
80103ddf:	c6 05 00 24 11 80 00 	movb   $0x0,0x80112400
    return;
80103de6:	eb 3b                	jmp    80103e23 <mpinit+0x1c1>
  }

  if(mp->imcrp){
80103de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103deb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103def:	84 c0                	test   %al,%al
80103df1:	74 30                	je     80103e23 <mpinit+0x1c1>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103df3:	83 ec 08             	sub    $0x8,%esp
80103df6:	6a 70                	push   $0x70
80103df8:	6a 22                	push   $0x22
80103dfa:	e8 1c fc ff ff       	call   80103a1b <outb>
80103dff:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	6a 23                	push   $0x23
80103e07:	e8 f2 fb ff ff       	call   801039fe <inb>
80103e0c:	83 c4 10             	add    $0x10,%esp
80103e0f:	83 c8 01             	or     $0x1,%eax
80103e12:	0f b6 c0             	movzbl %al,%eax
80103e15:	83 ec 08             	sub    $0x8,%esp
80103e18:	50                   	push   %eax
80103e19:	6a 23                	push   $0x23
80103e1b:	e8 fb fb ff ff       	call   80103a1b <outb>
80103e20:	83 c4 10             	add    $0x10,%esp
  }
}
80103e23:	c9                   	leave  
80103e24:	c3                   	ret    

80103e25 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e25:	55                   	push   %ebp
80103e26:	89 e5                	mov    %esp,%ebp
80103e28:	83 ec 08             	sub    $0x8,%esp
80103e2b:	8b 55 08             	mov    0x8(%ebp),%edx
80103e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e31:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e35:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e38:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e3c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e40:	ee                   	out    %al,(%dx)
}
80103e41:	c9                   	leave  
80103e42:	c3                   	ret    

80103e43 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e43:	55                   	push   %ebp
80103e44:	89 e5                	mov    %esp,%ebp
80103e46:	83 ec 04             	sub    $0x4,%esp
80103e49:	8b 45 08             	mov    0x8(%ebp),%eax
80103e4c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e50:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e54:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e5a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e5e:	0f b6 c0             	movzbl %al,%eax
80103e61:	50                   	push   %eax
80103e62:	6a 21                	push   $0x21
80103e64:	e8 bc ff ff ff       	call   80103e25 <outb>
80103e69:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e6c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e70:	66 c1 e8 08          	shr    $0x8,%ax
80103e74:	0f b6 c0             	movzbl %al,%eax
80103e77:	50                   	push   %eax
80103e78:	68 a1 00 00 00       	push   $0xa1
80103e7d:	e8 a3 ff ff ff       	call   80103e25 <outb>
80103e82:	83 c4 08             	add    $0x8,%esp
}
80103e85:	c9                   	leave  
80103e86:	c3                   	ret    

80103e87 <picenable>:

void
picenable(int irq)
{
80103e87:	55                   	push   %ebp
80103e88:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8d:	ba 01 00 00 00       	mov    $0x1,%edx
80103e92:	89 c1                	mov    %eax,%ecx
80103e94:	d3 e2                	shl    %cl,%edx
80103e96:	89 d0                	mov    %edx,%eax
80103e98:	f7 d0                	not    %eax
80103e9a:	89 c2                	mov    %eax,%edx
80103e9c:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ea3:	21 d0                	and    %edx,%eax
80103ea5:	0f b7 c0             	movzwl %ax,%eax
80103ea8:	50                   	push   %eax
80103ea9:	e8 95 ff ff ff       	call   80103e43 <picsetmask>
80103eae:	83 c4 04             	add    $0x4,%esp
}
80103eb1:	c9                   	leave  
80103eb2:	c3                   	ret    

80103eb3 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103eb3:	55                   	push   %ebp
80103eb4:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103eb6:	68 ff 00 00 00       	push   $0xff
80103ebb:	6a 21                	push   $0x21
80103ebd:	e8 63 ff ff ff       	call   80103e25 <outb>
80103ec2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103ec5:	68 ff 00 00 00       	push   $0xff
80103eca:	68 a1 00 00 00       	push   $0xa1
80103ecf:	e8 51 ff ff ff       	call   80103e25 <outb>
80103ed4:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ed7:	6a 11                	push   $0x11
80103ed9:	6a 20                	push   $0x20
80103edb:	e8 45 ff ff ff       	call   80103e25 <outb>
80103ee0:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ee3:	6a 20                	push   $0x20
80103ee5:	6a 21                	push   $0x21
80103ee7:	e8 39 ff ff ff       	call   80103e25 <outb>
80103eec:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103eef:	6a 04                	push   $0x4
80103ef1:	6a 21                	push   $0x21
80103ef3:	e8 2d ff ff ff       	call   80103e25 <outb>
80103ef8:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103efb:	6a 03                	push   $0x3
80103efd:	6a 21                	push   $0x21
80103eff:	e8 21 ff ff ff       	call   80103e25 <outb>
80103f04:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f07:	6a 11                	push   $0x11
80103f09:	68 a0 00 00 00       	push   $0xa0
80103f0e:	e8 12 ff ff ff       	call   80103e25 <outb>
80103f13:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f16:	6a 28                	push   $0x28
80103f18:	68 a1 00 00 00       	push   $0xa1
80103f1d:	e8 03 ff ff ff       	call   80103e25 <outb>
80103f22:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f25:	6a 02                	push   $0x2
80103f27:	68 a1 00 00 00       	push   $0xa1
80103f2c:	e8 f4 fe ff ff       	call   80103e25 <outb>
80103f31:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f34:	6a 03                	push   $0x3
80103f36:	68 a1 00 00 00       	push   $0xa1
80103f3b:	e8 e5 fe ff ff       	call   80103e25 <outb>
80103f40:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f43:	6a 68                	push   $0x68
80103f45:	6a 20                	push   $0x20
80103f47:	e8 d9 fe ff ff       	call   80103e25 <outb>
80103f4c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f4f:	6a 0a                	push   $0xa
80103f51:	6a 20                	push   $0x20
80103f53:	e8 cd fe ff ff       	call   80103e25 <outb>
80103f58:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f5b:	6a 68                	push   $0x68
80103f5d:	68 a0 00 00 00       	push   $0xa0
80103f62:	e8 be fe ff ff       	call   80103e25 <outb>
80103f67:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f6a:	6a 0a                	push   $0xa
80103f6c:	68 a0 00 00 00       	push   $0xa0
80103f71:	e8 af fe ff ff       	call   80103e25 <outb>
80103f76:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103f79:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f80:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f84:	74 13                	je     80103f99 <picinit+0xe6>
    picsetmask(irqmask);
80103f86:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f8d:	0f b7 c0             	movzwl %ax,%eax
80103f90:	50                   	push   %eax
80103f91:	e8 ad fe ff ff       	call   80103e43 <picsetmask>
80103f96:	83 c4 04             	add    $0x4,%esp
}
80103f99:	c9                   	leave  
80103f9a:	c3                   	ret    

80103f9b <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f9b:	55                   	push   %ebp
80103f9c:	89 e5                	mov    %esp,%ebp
80103f9e:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fb4:	8b 10                	mov    (%eax),%edx
80103fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb9:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fbb:	e8 9b cf ff ff       	call   80100f5b <filealloc>
80103fc0:	89 c2                	mov    %eax,%edx
80103fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc5:	89 10                	mov    %edx,(%eax)
80103fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fca:	8b 00                	mov    (%eax),%eax
80103fcc:	85 c0                	test   %eax,%eax
80103fce:	0f 84 cb 00 00 00    	je     8010409f <pipealloc+0x104>
80103fd4:	e8 82 cf ff ff       	call   80100f5b <filealloc>
80103fd9:	89 c2                	mov    %eax,%edx
80103fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fde:	89 10                	mov    %edx,(%eax)
80103fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe3:	8b 00                	mov    (%eax),%eax
80103fe5:	85 c0                	test   %eax,%eax
80103fe7:	0f 84 b2 00 00 00    	je     8010409f <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fed:	e8 db eb ff ff       	call   80102bcd <kalloc>
80103ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ff9:	75 05                	jne    80104000 <pipealloc+0x65>
    goto bad;
80103ffb:	e9 9f 00 00 00       	jmp    8010409f <pipealloc+0x104>
  p->readopen = 1;
80104000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104003:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010400a:	00 00 00 
  p->writeopen = 1;
8010400d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104010:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104017:	00 00 00 
  p->nwrite = 0;
8010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401d:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104024:	00 00 00 
  p->nread = 0;
80104027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402a:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104031:	00 00 00 
  initlock(&p->lock, "pipe");
80104034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104037:	83 ec 08             	sub    $0x8,%esp
8010403a:	68 28 87 10 80       	push   $0x80108728
8010403f:	50                   	push   %eax
80104040:	e8 d1 0e 00 00       	call   80104f16 <initlock>
80104045:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104048:	8b 45 08             	mov    0x8(%ebp),%eax
8010404b:	8b 00                	mov    (%eax),%eax
8010404d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104053:	8b 45 08             	mov    0x8(%ebp),%eax
80104056:	8b 00                	mov    (%eax),%eax
80104058:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010405c:	8b 45 08             	mov    0x8(%ebp),%eax
8010405f:	8b 00                	mov    (%eax),%eax
80104061:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104065:	8b 45 08             	mov    0x8(%ebp),%eax
80104068:	8b 00                	mov    (%eax),%eax
8010406a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010406d:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104070:	8b 45 0c             	mov    0xc(%ebp),%eax
80104073:	8b 00                	mov    (%eax),%eax
80104075:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010407b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010407e:	8b 00                	mov    (%eax),%eax
80104080:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104084:	8b 45 0c             	mov    0xc(%ebp),%eax
80104087:	8b 00                	mov    (%eax),%eax
80104089:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010408d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104090:	8b 00                	mov    (%eax),%eax
80104092:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104095:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104098:	b8 00 00 00 00       	mov    $0x0,%eax
8010409d:	eb 4d                	jmp    801040ec <pipealloc+0x151>

//PAGEBREAK: 20
 bad:
  if(p)
8010409f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040a3:	74 0e                	je     801040b3 <pipealloc+0x118>
    kfree((char*)p);
801040a5:	83 ec 0c             	sub    $0xc,%esp
801040a8:	ff 75 f4             	pushl  -0xc(%ebp)
801040ab:	e8 81 ea ff ff       	call   80102b31 <kfree>
801040b0:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	85 c0                	test   %eax,%eax
801040ba:	74 11                	je     801040cd <pipealloc+0x132>
    fileclose(*f0);
801040bc:	8b 45 08             	mov    0x8(%ebp),%eax
801040bf:	8b 00                	mov    (%eax),%eax
801040c1:	83 ec 0c             	sub    $0xc,%esp
801040c4:	50                   	push   %eax
801040c5:	e8 4e cf ff ff       	call   80101018 <fileclose>
801040ca:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d0:	8b 00                	mov    (%eax),%eax
801040d2:	85 c0                	test   %eax,%eax
801040d4:	74 11                	je     801040e7 <pipealloc+0x14c>
    fileclose(*f1);
801040d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d9:	8b 00                	mov    (%eax),%eax
801040db:	83 ec 0c             	sub    $0xc,%esp
801040de:	50                   	push   %eax
801040df:	e8 34 cf ff ff       	call   80101018 <fileclose>
801040e4:	83 c4 10             	add    $0x10,%esp
  return -1;
801040e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040ec:	c9                   	leave  
801040ed:	c3                   	ret    

801040ee <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040ee:	55                   	push   %ebp
801040ef:	89 e5                	mov    %esp,%ebp
801040f1:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801040f4:	8b 45 08             	mov    0x8(%ebp),%eax
801040f7:	83 ec 0c             	sub    $0xc,%esp
801040fa:	50                   	push   %eax
801040fb:	e8 37 0e 00 00       	call   80104f37 <acquire>
80104100:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104103:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104107:	74 23                	je     8010412c <pipeclose+0x3e>
    p->writeopen = 0;
80104109:	8b 45 08             	mov    0x8(%ebp),%eax
8010410c:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104113:	00 00 00 
    wakeup(&p->nread);
80104116:	8b 45 08             	mov    0x8(%ebp),%eax
80104119:	05 34 02 00 00       	add    $0x234,%eax
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	50                   	push   %eax
80104122:	e8 09 0c 00 00       	call   80104d30 <wakeup>
80104127:	83 c4 10             	add    $0x10,%esp
8010412a:	eb 21                	jmp    8010414d <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010412c:	8b 45 08             	mov    0x8(%ebp),%eax
8010412f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104136:	00 00 00 
    wakeup(&p->nwrite);
80104139:	8b 45 08             	mov    0x8(%ebp),%eax
8010413c:	05 38 02 00 00       	add    $0x238,%eax
80104141:	83 ec 0c             	sub    $0xc,%esp
80104144:	50                   	push   %eax
80104145:	e8 e6 0b 00 00       	call   80104d30 <wakeup>
8010414a:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010414d:	8b 45 08             	mov    0x8(%ebp),%eax
80104150:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104156:	85 c0                	test   %eax,%eax
80104158:	75 2c                	jne    80104186 <pipeclose+0x98>
8010415a:	8b 45 08             	mov    0x8(%ebp),%eax
8010415d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104163:	85 c0                	test   %eax,%eax
80104165:	75 1f                	jne    80104186 <pipeclose+0x98>
    release(&p->lock);
80104167:	8b 45 08             	mov    0x8(%ebp),%eax
8010416a:	83 ec 0c             	sub    $0xc,%esp
8010416d:	50                   	push   %eax
8010416e:	e8 2a 0e 00 00       	call   80104f9d <release>
80104173:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104176:	83 ec 0c             	sub    $0xc,%esp
80104179:	ff 75 08             	pushl  0x8(%ebp)
8010417c:	e8 b0 e9 ff ff       	call   80102b31 <kfree>
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	eb 0f                	jmp    80104195 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104186:	8b 45 08             	mov    0x8(%ebp),%eax
80104189:	83 ec 0c             	sub    $0xc,%esp
8010418c:	50                   	push   %eax
8010418d:	e8 0b 0e 00 00       	call   80104f9d <release>
80104192:	83 c4 10             	add    $0x10,%esp
}
80104195:	c9                   	leave  
80104196:	c3                   	ret    

80104197 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104197:	55                   	push   %ebp
80104198:	89 e5                	mov    %esp,%ebp
8010419a:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010419d:	8b 45 08             	mov    0x8(%ebp),%eax
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	50                   	push   %eax
801041a4:	e8 8e 0d 00 00       	call   80104f37 <acquire>
801041a9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041b3:	e9 af 00 00 00       	jmp    80104267 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041b8:	eb 60                	jmp    8010421a <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
801041ba:	8b 45 08             	mov    0x8(%ebp),%eax
801041bd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041c3:	85 c0                	test   %eax,%eax
801041c5:	74 0d                	je     801041d4 <pipewrite+0x3d>
801041c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041cd:	8b 40 24             	mov    0x24(%eax),%eax
801041d0:	85 c0                	test   %eax,%eax
801041d2:	74 19                	je     801041ed <pipewrite+0x56>
        release(&p->lock);
801041d4:	8b 45 08             	mov    0x8(%ebp),%eax
801041d7:	83 ec 0c             	sub    $0xc,%esp
801041da:	50                   	push   %eax
801041db:	e8 bd 0d 00 00       	call   80104f9d <release>
801041e0:	83 c4 10             	add    $0x10,%esp
        return -1;
801041e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041e8:	e9 ac 00 00 00       	jmp    80104299 <pipewrite+0x102>
      }
      wakeup(&p->nread);
801041ed:	8b 45 08             	mov    0x8(%ebp),%eax
801041f0:	05 34 02 00 00       	add    $0x234,%eax
801041f5:	83 ec 0c             	sub    $0xc,%esp
801041f8:	50                   	push   %eax
801041f9:	e8 32 0b 00 00       	call   80104d30 <wakeup>
801041fe:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	8b 55 08             	mov    0x8(%ebp),%edx
80104207:	81 c2 38 02 00 00    	add    $0x238,%edx
8010420d:	83 ec 08             	sub    $0x8,%esp
80104210:	50                   	push   %eax
80104211:	52                   	push   %edx
80104212:	e8 30 0a 00 00       	call   80104c47 <sleep>
80104217:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010421a:	8b 45 08             	mov    0x8(%ebp),%eax
8010421d:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104223:	8b 45 08             	mov    0x8(%ebp),%eax
80104226:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010422c:	05 00 02 00 00       	add    $0x200,%eax
80104231:	39 c2                	cmp    %eax,%edx
80104233:	74 85                	je     801041ba <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104235:	8b 45 08             	mov    0x8(%ebp),%eax
80104238:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010423e:	8d 48 01             	lea    0x1(%eax),%ecx
80104241:	8b 55 08             	mov    0x8(%ebp),%edx
80104244:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010424a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010424f:	89 c1                	mov    %eax,%ecx
80104251:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104254:	8b 45 0c             	mov    0xc(%ebp),%eax
80104257:	01 d0                	add    %edx,%eax
80104259:	0f b6 10             	movzbl (%eax),%edx
8010425c:	8b 45 08             	mov    0x8(%ebp),%eax
8010425f:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104263:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010426d:	0f 8c 45 ff ff ff    	jl     801041b8 <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
80104276:	05 34 02 00 00       	add    $0x234,%eax
8010427b:	83 ec 0c             	sub    $0xc,%esp
8010427e:	50                   	push   %eax
8010427f:	e8 ac 0a 00 00       	call   80104d30 <wakeup>
80104284:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104287:	8b 45 08             	mov    0x8(%ebp),%eax
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	50                   	push   %eax
8010428e:	e8 0a 0d 00 00       	call   80104f9d <release>
80104293:	83 c4 10             	add    $0x10,%esp
  return n;
80104296:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104299:	c9                   	leave  
8010429a:	c3                   	ret    

8010429b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010429b:	55                   	push   %ebp
8010429c:	89 e5                	mov    %esp,%ebp
8010429e:	53                   	push   %ebx
8010429f:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042a2:	8b 45 08             	mov    0x8(%ebp),%eax
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	50                   	push   %eax
801042a9:	e8 89 0c 00 00       	call   80104f37 <acquire>
801042ae:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042b1:	eb 3f                	jmp    801042f2 <piperead+0x57>
    if(proc->killed){
801042b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b9:	8b 40 24             	mov    0x24(%eax),%eax
801042bc:	85 c0                	test   %eax,%eax
801042be:	74 19                	je     801042d9 <piperead+0x3e>
      release(&p->lock);
801042c0:	8b 45 08             	mov    0x8(%ebp),%eax
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	50                   	push   %eax
801042c7:	e8 d1 0c 00 00       	call   80104f9d <release>
801042cc:	83 c4 10             	add    $0x10,%esp
      return -1;
801042cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042d4:	e9 be 00 00 00       	jmp    80104397 <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042d9:	8b 45 08             	mov    0x8(%ebp),%eax
801042dc:	8b 55 08             	mov    0x8(%ebp),%edx
801042df:	81 c2 34 02 00 00    	add    $0x234,%edx
801042e5:	83 ec 08             	sub    $0x8,%esp
801042e8:	50                   	push   %eax
801042e9:	52                   	push   %edx
801042ea:	e8 58 09 00 00       	call   80104c47 <sleep>
801042ef:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042f2:	8b 45 08             	mov    0x8(%ebp),%eax
801042f5:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042fb:	8b 45 08             	mov    0x8(%ebp),%eax
801042fe:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104304:	39 c2                	cmp    %eax,%edx
80104306:	75 0d                	jne    80104315 <piperead+0x7a>
80104308:	8b 45 08             	mov    0x8(%ebp),%eax
8010430b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104311:	85 c0                	test   %eax,%eax
80104313:	75 9e                	jne    801042b3 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010431c:	eb 4b                	jmp    80104369 <piperead+0xce>
    if(p->nread == p->nwrite)
8010431e:	8b 45 08             	mov    0x8(%ebp),%eax
80104321:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104327:	8b 45 08             	mov    0x8(%ebp),%eax
8010432a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104330:	39 c2                	cmp    %eax,%edx
80104332:	75 02                	jne    80104336 <piperead+0x9b>
      break;
80104334:	eb 3b                	jmp    80104371 <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104336:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010433c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010433f:	8b 45 08             	mov    0x8(%ebp),%eax
80104342:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104348:	8d 48 01             	lea    0x1(%eax),%ecx
8010434b:	8b 55 08             	mov    0x8(%ebp),%edx
8010434e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104354:	25 ff 01 00 00       	and    $0x1ff,%eax
80104359:	89 c2                	mov    %eax,%edx
8010435b:	8b 45 08             	mov    0x8(%ebp),%eax
8010435e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104363:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104365:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010436f:	7c ad                	jl     8010431e <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104371:	8b 45 08             	mov    0x8(%ebp),%eax
80104374:	05 38 02 00 00       	add    $0x238,%eax
80104379:	83 ec 0c             	sub    $0xc,%esp
8010437c:	50                   	push   %eax
8010437d:	e8 ae 09 00 00       	call   80104d30 <wakeup>
80104382:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104385:	8b 45 08             	mov    0x8(%ebp),%eax
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	50                   	push   %eax
8010438c:	e8 0c 0c 00 00       	call   80104f9d <release>
80104391:	83 c4 10             	add    $0x10,%esp
  return i;
80104394:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010439a:	c9                   	leave  
8010439b:	c3                   	ret    

8010439c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010439c:	55                   	push   %ebp
8010439d:	89 e5                	mov    %esp,%ebp
8010439f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043a2:	9c                   	pushf  
801043a3:	58                   	pop    %eax
801043a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043aa:	c9                   	leave  
801043ab:	c3                   	ret    

801043ac <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043ac:	55                   	push   %ebp
801043ad:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043af:	fb                   	sti    
}
801043b0:	5d                   	pop    %ebp
801043b1:	c3                   	ret    

801043b2 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043b2:	55                   	push   %ebp
801043b3:	89 e5                	mov    %esp,%ebp
801043b5:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043b8:	83 ec 08             	sub    $0x8,%esp
801043bb:	68 2d 87 10 80       	push   $0x8010872d
801043c0:	68 40 2a 11 80       	push   $0x80112a40
801043c5:	e8 4c 0b 00 00       	call   80104f16 <initlock>
801043ca:	83 c4 10             	add    $0x10,%esp
}
801043cd:	c9                   	leave  
801043ce:	c3                   	ret    

801043cf <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043cf:	55                   	push   %ebp
801043d0:	89 e5                	mov    %esp,%ebp
801043d2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043d5:	83 ec 0c             	sub    $0xc,%esp
801043d8:	68 40 2a 11 80       	push   $0x80112a40
801043dd:	e8 55 0b 00 00       	call   80104f37 <acquire>
801043e2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043e5:	c7 45 f4 74 2a 11 80 	movl   $0x80112a74,-0xc(%ebp)
801043ec:	eb 56                	jmp    80104444 <allocproc+0x75>
    if(p->state == UNUSED)
801043ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f1:	8b 40 0c             	mov    0xc(%eax),%eax
801043f4:	85 c0                	test   %eax,%eax
801043f6:	75 48                	jne    80104440 <allocproc+0x71>
      goto found;
801043f8:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801043f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fc:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104403:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104408:	8d 50 01             	lea    0x1(%eax),%edx
8010440b:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104411:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104414:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	68 40 2a 11 80       	push   $0x80112a40
8010441f:	e8 79 0b 00 00       	call   80104f9d <release>
80104424:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104427:	e8 a1 e7 ff ff       	call   80102bcd <kalloc>
8010442c:	89 c2                	mov    %eax,%edx
8010442e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104431:	89 50 08             	mov    %edx,0x8(%eax)
80104434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104437:	8b 40 08             	mov    0x8(%eax),%eax
8010443a:	85 c0                	test   %eax,%eax
8010443c:	75 37                	jne    80104475 <allocproc+0xa6>
8010443e:	eb 24                	jmp    80104464 <allocproc+0x95>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104440:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104444:	81 7d f4 74 49 11 80 	cmpl   $0x80114974,-0xc(%ebp)
8010444b:	72 a1                	jb     801043ee <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010444d:	83 ec 0c             	sub    $0xc,%esp
80104450:	68 40 2a 11 80       	push   $0x80112a40
80104455:	e8 43 0b 00 00       	call   80104f9d <release>
8010445a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010445d:	b8 00 00 00 00       	mov    $0x0,%eax
80104462:	eb 6e                	jmp    801044d2 <allocproc+0x103>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104467:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010446e:	b8 00 00 00 00       	mov    $0x0,%eax
80104473:	eb 5d                	jmp    801044d2 <allocproc+0x103>
  }
  sp = p->kstack + KSTACKSIZE;
80104475:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104478:	8b 40 08             	mov    0x8(%eax),%eax
8010447b:	05 00 10 00 00       	add    $0x1000,%eax
80104480:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104483:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010448d:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104490:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104494:	ba 6f 65 10 80       	mov    $0x8010656f,%edx
80104499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010449c:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010449e:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044a8:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ae:	8b 40 1c             	mov    0x1c(%eax),%eax
801044b1:	83 ec 04             	sub    $0x4,%esp
801044b4:	6a 14                	push   $0x14
801044b6:	6a 00                	push   $0x0
801044b8:	50                   	push   %eax
801044b9:	e8 d5 0c 00 00       	call   80105193 <memset>
801044be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c4:	8b 40 1c             	mov    0x1c(%eax),%eax
801044c7:	ba 17 4c 10 80       	mov    $0x80104c17,%edx
801044cc:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044d2:	c9                   	leave  
801044d3:	c3                   	ret    

801044d4 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801044da:	e8 f0 fe ff ff       	call   801043cf <allocproc>
801044df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e5:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
801044ea:	e8 39 37 00 00       	call   80107c28 <setupkvm>
801044ef:	89 c2                	mov    %eax,%edx
801044f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f4:	89 50 04             	mov    %edx,0x4(%eax)
801044f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044fa:	8b 40 04             	mov    0x4(%eax),%eax
801044fd:	85 c0                	test   %eax,%eax
801044ff:	75 0d                	jne    8010450e <userinit+0x3a>
    panic("userinit: out of memory?");
80104501:	83 ec 0c             	sub    $0xc,%esp
80104504:	68 34 87 10 80       	push   $0x80108734
80104509:	e8 4e c0 ff ff       	call   8010055c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010450e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104516:	8b 40 04             	mov    0x4(%eax),%eax
80104519:	83 ec 04             	sub    $0x4,%esp
8010451c:	52                   	push   %edx
8010451d:	68 00 b5 10 80       	push   $0x8010b500
80104522:	50                   	push   %eax
80104523:	e8 57 39 00 00       	call   80107e7f <inituvm>
80104528:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452e:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104537:	8b 40 18             	mov    0x18(%eax),%eax
8010453a:	83 ec 04             	sub    $0x4,%esp
8010453d:	6a 4c                	push   $0x4c
8010453f:	6a 00                	push   $0x0
80104541:	50                   	push   %eax
80104542:	e8 4c 0c 00 00       	call   80105193 <memset>
80104547:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010454a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454d:	8b 40 18             	mov    0x18(%eax),%eax
80104550:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104559:	8b 40 18             	mov    0x18(%eax),%eax
8010455c:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104565:	8b 40 18             	mov    0x18(%eax),%eax
80104568:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010456b:	8b 52 18             	mov    0x18(%edx),%edx
8010456e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104572:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104579:	8b 40 18             	mov    0x18(%eax),%eax
8010457c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010457f:	8b 52 18             	mov    0x18(%edx),%edx
80104582:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104586:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010458a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458d:	8b 40 18             	mov    0x18(%eax),%eax
80104590:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459a:	8b 40 18             	mov    0x18(%eax),%eax
8010459d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a7:	8b 40 18             	mov    0x18(%eax),%eax
801045aa:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b4:	83 c0 6c             	add    $0x6c,%eax
801045b7:	83 ec 04             	sub    $0x4,%esp
801045ba:	6a 10                	push   $0x10
801045bc:	68 4d 87 10 80       	push   $0x8010874d
801045c1:	50                   	push   %eax
801045c2:	e8 d1 0d 00 00       	call   80105398 <safestrcpy>
801045c7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045ca:	83 ec 0c             	sub    $0xc,%esp
801045cd:	68 56 87 10 80       	push   $0x80108756
801045d2:	e8 c6 de ff ff       	call   8010249d <namei>
801045d7:	83 c4 10             	add    $0x10,%esp
801045da:	89 c2                	mov    %eax,%edx
801045dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045df:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
801045e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801045ec:	c9                   	leave  
801045ed:	c3                   	ret    

801045ee <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801045ee:	55                   	push   %ebp
801045ef:	89 e5                	mov    %esp,%ebp
801045f1:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801045f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045fa:	8b 00                	mov    (%eax),%eax
801045fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801045ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104603:	7e 31                	jle    80104636 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104605:	8b 55 08             	mov    0x8(%ebp),%edx
80104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460b:	01 c2                	add    %eax,%edx
8010460d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104613:	8b 40 04             	mov    0x4(%eax),%eax
80104616:	83 ec 04             	sub    $0x4,%esp
80104619:	52                   	push   %edx
8010461a:	ff 75 f4             	pushl  -0xc(%ebp)
8010461d:	50                   	push   %eax
8010461e:	e8 a8 39 00 00       	call   80107fcb <allocuvm>
80104623:	83 c4 10             	add    $0x10,%esp
80104626:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010462d:	75 3e                	jne    8010466d <growproc+0x7f>
      return -1;
8010462f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104634:	eb 59                	jmp    8010468f <growproc+0xa1>
  } else if(n < 0){
80104636:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010463a:	79 31                	jns    8010466d <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010463c:	8b 55 08             	mov    0x8(%ebp),%edx
8010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104642:	01 c2                	add    %eax,%edx
80104644:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010464a:	8b 40 04             	mov    0x4(%eax),%eax
8010464d:	83 ec 04             	sub    $0x4,%esp
80104650:	52                   	push   %edx
80104651:	ff 75 f4             	pushl  -0xc(%ebp)
80104654:	50                   	push   %eax
80104655:	e8 3a 3a 00 00       	call   80108094 <deallocuvm>
8010465a:	83 c4 10             	add    $0x10,%esp
8010465d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104664:	75 07                	jne    8010466d <growproc+0x7f>
      return -1;
80104666:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010466b:	eb 22                	jmp    8010468f <growproc+0xa1>
  }
  proc->sz = sz;
8010466d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104673:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104676:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104678:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010467e:	83 ec 0c             	sub    $0xc,%esp
80104681:	50                   	push   %eax
80104682:	e8 86 36 00 00       	call   80107d0d <switchuvm>
80104687:	83 c4 10             	add    $0x10,%esp
  return 0;
8010468a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010468f:	c9                   	leave  
80104690:	c3                   	ret    

80104691 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104691:	55                   	push   %ebp
80104692:	89 e5                	mov    %esp,%ebp
80104694:	57                   	push   %edi
80104695:	56                   	push   %esi
80104696:	53                   	push   %ebx
80104697:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010469a:	e8 30 fd ff ff       	call   801043cf <allocproc>
8010469f:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046a6:	75 0a                	jne    801046b2 <fork+0x21>
    return -1;
801046a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ad:	e9 68 01 00 00       	jmp    8010481a <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b8:	8b 10                	mov    (%eax),%edx
801046ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c0:	8b 40 04             	mov    0x4(%eax),%eax
801046c3:	83 ec 08             	sub    $0x8,%esp
801046c6:	52                   	push   %edx
801046c7:	50                   	push   %eax
801046c8:	e8 63 3b 00 00       	call   80108230 <copyuvm>
801046cd:	83 c4 10             	add    $0x10,%esp
801046d0:	89 c2                	mov    %eax,%edx
801046d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d5:	89 50 04             	mov    %edx,0x4(%eax)
801046d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046db:	8b 40 04             	mov    0x4(%eax),%eax
801046de:	85 c0                	test   %eax,%eax
801046e0:	75 30                	jne    80104712 <fork+0x81>
    kfree(np->kstack);
801046e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046e5:	8b 40 08             	mov    0x8(%eax),%eax
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	50                   	push   %eax
801046ec:	e8 40 e4 ff ff       	call   80102b31 <kfree>
801046f1:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801046f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801046fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104701:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010470d:	e9 08 01 00 00       	jmp    8010481a <fork+0x189>
  }
  np->sz = proc->sz;
80104712:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104718:	8b 10                	mov    (%eax),%edx
8010471a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010471d:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010471f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104726:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104729:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010472c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010472f:	8b 50 18             	mov    0x18(%eax),%edx
80104732:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104738:	8b 40 18             	mov    0x18(%eax),%eax
8010473b:	89 c3                	mov    %eax,%ebx
8010473d:	b8 13 00 00 00       	mov    $0x13,%eax
80104742:	89 d7                	mov    %edx,%edi
80104744:	89 de                	mov    %ebx,%esi
80104746:	89 c1                	mov    %eax,%ecx
80104748:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010474a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474d:	8b 40 18             	mov    0x18(%eax),%eax
80104750:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104757:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010475e:	eb 43                	jmp    801047a3 <fork+0x112>
    if(proc->ofile[i])
80104760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104769:	83 c2 08             	add    $0x8,%edx
8010476c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104770:	85 c0                	test   %eax,%eax
80104772:	74 2b                	je     8010479f <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104774:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010477d:	83 c2 08             	add    $0x8,%edx
80104780:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	50                   	push   %eax
80104788:	e8 3a c8 ff ff       	call   80100fc7 <filedup>
8010478d:	83 c4 10             	add    $0x10,%esp
80104790:	89 c1                	mov    %eax,%ecx
80104792:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104795:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104798:	83 c2 08             	add    $0x8,%edx
8010479b:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010479f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047a3:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047a7:	7e b7                	jle    80104760 <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047af:	8b 40 68             	mov    0x68(%eax),%eax
801047b2:	83 ec 0c             	sub    $0xc,%esp
801047b5:	50                   	push   %eax
801047b6:	e8 e5 d0 ff ff       	call   801018a0 <idup>
801047bb:	83 c4 10             	add    $0x10,%esp
801047be:	89 c2                	mov    %eax,%edx
801047c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c3:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801047c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047cc:	8d 50 6c             	lea    0x6c(%eax),%edx
801047cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d2:	83 c0 6c             	add    $0x6c,%eax
801047d5:	83 ec 04             	sub    $0x4,%esp
801047d8:	6a 10                	push   $0x10
801047da:	52                   	push   %edx
801047db:	50                   	push   %eax
801047dc:	e8 b7 0b 00 00       	call   80105398 <safestrcpy>
801047e1:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
801047e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e7:	8b 40 10             	mov    0x10(%eax),%eax
801047ea:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801047ed:	83 ec 0c             	sub    $0xc,%esp
801047f0:	68 40 2a 11 80       	push   $0x80112a40
801047f5:	e8 3d 07 00 00       	call   80104f37 <acquire>
801047fa:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801047fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104800:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104807:	83 ec 0c             	sub    $0xc,%esp
8010480a:	68 40 2a 11 80       	push   $0x80112a40
8010480f:	e8 89 07 00 00       	call   80104f9d <release>
80104814:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104817:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010481a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010481d:	5b                   	pop    %ebx
8010481e:	5e                   	pop    %esi
8010481f:	5f                   	pop    %edi
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    

80104822 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104822:	55                   	push   %ebp
80104823:	89 e5                	mov    %esp,%ebp
80104825:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104828:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010482f:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104834:	39 c2                	cmp    %eax,%edx
80104836:	75 0d                	jne    80104845 <exit+0x23>
    panic("init exiting");
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	68 58 87 10 80       	push   $0x80108758
80104840:	e8 17 bd ff ff       	call   8010055c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104845:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010484c:	eb 48                	jmp    80104896 <exit+0x74>
    if(proc->ofile[fd]){
8010484e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104854:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104857:	83 c2 08             	add    $0x8,%edx
8010485a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010485e:	85 c0                	test   %eax,%eax
80104860:	74 30                	je     80104892 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104862:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104868:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010486b:	83 c2 08             	add    $0x8,%edx
8010486e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104872:	83 ec 0c             	sub    $0xc,%esp
80104875:	50                   	push   %eax
80104876:	e8 9d c7 ff ff       	call   80101018 <fileclose>
8010487b:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
8010487e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104884:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104887:	83 c2 08             	add    $0x8,%edx
8010488a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104891:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104892:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104896:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010489a:	7e b2                	jle    8010484e <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
8010489c:	e8 0d ec ff ff       	call   801034ae <begin_op>
  iput(proc->cwd);
801048a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a7:	8b 40 68             	mov    0x68(%eax),%eax
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	50                   	push   %eax
801048ae:	e8 ef d1 ff ff       	call   80101aa2 <iput>
801048b3:	83 c4 10             	add    $0x10,%esp
  end_op();
801048b6:	e8 81 ec ff ff       	call   8010353c <end_op>
  proc->cwd = 0;
801048bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c1:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048c8:	83 ec 0c             	sub    $0xc,%esp
801048cb:	68 40 2a 11 80       	push   $0x80112a40
801048d0:	e8 62 06 00 00       	call   80104f37 <acquire>
801048d5:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801048d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048de:	8b 40 14             	mov    0x14(%eax),%eax
801048e1:	83 ec 0c             	sub    $0xc,%esp
801048e4:	50                   	push   %eax
801048e5:	e8 08 04 00 00       	call   80104cf2 <wakeup1>
801048ea:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ed:	c7 45 f4 74 2a 11 80 	movl   $0x80112a74,-0xc(%ebp)
801048f4:	eb 3c                	jmp    80104932 <exit+0x110>
    if(p->parent == proc){
801048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f9:	8b 50 14             	mov    0x14(%eax),%edx
801048fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104902:	39 c2                	cmp    %eax,%edx
80104904:	75 28                	jne    8010492e <exit+0x10c>
      p->parent = initproc;
80104906:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
8010490c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490f:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104915:	8b 40 0c             	mov    0xc(%eax),%eax
80104918:	83 f8 05             	cmp    $0x5,%eax
8010491b:	75 11                	jne    8010492e <exit+0x10c>
        wakeup1(initproc);
8010491d:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104922:	83 ec 0c             	sub    $0xc,%esp
80104925:	50                   	push   %eax
80104926:	e8 c7 03 00 00       	call   80104cf2 <wakeup1>
8010492b:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010492e:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104932:	81 7d f4 74 49 11 80 	cmpl   $0x80114974,-0xc(%ebp)
80104939:	72 bb                	jb     801048f6 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010493b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104941:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104948:	e8 d5 01 00 00       	call   80104b22 <sched>
  panic("zombie exit");
8010494d:	83 ec 0c             	sub    $0xc,%esp
80104950:	68 65 87 10 80       	push   $0x80108765
80104955:	e8 02 bc ff ff       	call   8010055c <panic>

8010495a <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010495a:	55                   	push   %ebp
8010495b:	89 e5                	mov    %esp,%ebp
8010495d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 40 2a 11 80       	push   $0x80112a40
80104968:	e8 ca 05 00 00       	call   80104f37 <acquire>
8010496d:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104970:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104977:	c7 45 f4 74 2a 11 80 	movl   $0x80112a74,-0xc(%ebp)
8010497e:	e9 a6 00 00 00       	jmp    80104a29 <wait+0xcf>
      if(p->parent != proc)
80104983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104986:	8b 50 14             	mov    0x14(%eax),%edx
80104989:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498f:	39 c2                	cmp    %eax,%edx
80104991:	74 05                	je     80104998 <wait+0x3e>
        continue;
80104993:	e9 8d 00 00 00       	jmp    80104a25 <wait+0xcb>
      havekids = 1;
80104998:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010499f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a2:	8b 40 0c             	mov    0xc(%eax),%eax
801049a5:	83 f8 05             	cmp    $0x5,%eax
801049a8:	75 7b                	jne    80104a25 <wait+0xcb>
        // Found one.
        pid = p->pid;
801049aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ad:	8b 40 10             	mov    0x10(%eax),%eax
801049b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b6:	8b 40 08             	mov    0x8(%eax),%eax
801049b9:	83 ec 0c             	sub    $0xc,%esp
801049bc:	50                   	push   %eax
801049bd:	e8 6f e1 ff ff       	call   80102b31 <kfree>
801049c2:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d2:	8b 40 04             	mov    0x4(%eax),%eax
801049d5:	83 ec 0c             	sub    $0xc,%esp
801049d8:	50                   	push   %eax
801049d9:	e8 73 37 00 00       	call   80108151 <freevm>
801049de:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
801049e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801049eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ee:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801049f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801049ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a02:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a09:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	68 40 2a 11 80       	push   $0x80112a40
80104a18:	e8 80 05 00 00       	call   80104f9d <release>
80104a1d:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a23:	eb 57                	jmp    80104a7c <wait+0x122>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a25:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a29:	81 7d f4 74 49 11 80 	cmpl   $0x80114974,-0xc(%ebp)
80104a30:	0f 82 4d ff ff ff    	jb     80104983 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a3a:	74 0d                	je     80104a49 <wait+0xef>
80104a3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a42:	8b 40 24             	mov    0x24(%eax),%eax
80104a45:	85 c0                	test   %eax,%eax
80104a47:	74 17                	je     80104a60 <wait+0x106>
      release(&ptable.lock);
80104a49:	83 ec 0c             	sub    $0xc,%esp
80104a4c:	68 40 2a 11 80       	push   $0x80112a40
80104a51:	e8 47 05 00 00       	call   80104f9d <release>
80104a56:	83 c4 10             	add    $0x10,%esp
      return -1;
80104a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a5e:	eb 1c                	jmp    80104a7c <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a66:	83 ec 08             	sub    $0x8,%esp
80104a69:	68 40 2a 11 80       	push   $0x80112a40
80104a6e:	50                   	push   %eax
80104a6f:	e8 d3 01 00 00       	call   80104c47 <sleep>
80104a74:	83 c4 10             	add    $0x10,%esp
  }
80104a77:	e9 f4 fe ff ff       	jmp    80104970 <wait+0x16>
}
80104a7c:	c9                   	leave  
80104a7d:	c3                   	ret    

80104a7e <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a7e:	55                   	push   %ebp
80104a7f:	89 e5                	mov    %esp,%ebp
80104a81:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104a84:	e8 23 f9 ff ff       	call   801043ac <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104a89:	83 ec 0c             	sub    $0xc,%esp
80104a8c:	68 40 2a 11 80       	push   $0x80112a40
80104a91:	e8 a1 04 00 00       	call   80104f37 <acquire>
80104a96:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a99:	c7 45 f4 74 2a 11 80 	movl   $0x80112a74,-0xc(%ebp)
80104aa0:	eb 62                	jmp    80104b04 <scheduler+0x86>
      if(p->state != RUNNABLE)
80104aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa5:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa8:	83 f8 03             	cmp    $0x3,%eax
80104aab:	74 02                	je     80104aaf <scheduler+0x31>
        continue;
80104aad:	eb 51                	jmp    80104b00 <scheduler+0x82>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab2:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	ff 75 f4             	pushl  -0xc(%ebp)
80104abe:	e8 4a 32 00 00       	call   80107d0d <switchuvm>
80104ac3:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac9:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104ad0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad6:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ad9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ae0:	83 c2 04             	add    $0x4,%edx
80104ae3:	83 ec 08             	sub    $0x8,%esp
80104ae6:	50                   	push   %eax
80104ae7:	52                   	push   %edx
80104ae8:	e8 1c 09 00 00       	call   80105409 <swtch>
80104aed:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104af0:	e8 fc 31 00 00       	call   80107cf1 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104af5:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104afc:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b00:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b04:	81 7d f4 74 49 11 80 	cmpl   $0x80114974,-0xc(%ebp)
80104b0b:	72 95                	jb     80104aa2 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b0d:	83 ec 0c             	sub    $0xc,%esp
80104b10:	68 40 2a 11 80       	push   $0x80112a40
80104b15:	e8 83 04 00 00       	call   80104f9d <release>
80104b1a:	83 c4 10             	add    $0x10,%esp

  }
80104b1d:	e9 62 ff ff ff       	jmp    80104a84 <scheduler+0x6>

80104b22 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b22:	55                   	push   %ebp
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 40 2a 11 80       	push   $0x80112a40
80104b30:	e8 32 05 00 00       	call   80105067 <holding>
80104b35:	83 c4 10             	add    $0x10,%esp
80104b38:	85 c0                	test   %eax,%eax
80104b3a:	75 0d                	jne    80104b49 <sched+0x27>
    panic("sched ptable.lock");
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	68 71 87 10 80       	push   $0x80108771
80104b44:	e8 13 ba ff ff       	call   8010055c <panic>
  if(cpu->ncli != 1)
80104b49:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b4f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b55:	83 f8 01             	cmp    $0x1,%eax
80104b58:	74 0d                	je     80104b67 <sched+0x45>
    panic("sched locks");
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	68 83 87 10 80       	push   $0x80108783
80104b62:	e8 f5 b9 ff ff       	call   8010055c <panic>
  if(proc->state == RUNNING)
80104b67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b6d:	8b 40 0c             	mov    0xc(%eax),%eax
80104b70:	83 f8 04             	cmp    $0x4,%eax
80104b73:	75 0d                	jne    80104b82 <sched+0x60>
    panic("sched running");
80104b75:	83 ec 0c             	sub    $0xc,%esp
80104b78:	68 8f 87 10 80       	push   $0x8010878f
80104b7d:	e8 da b9 ff ff       	call   8010055c <panic>
  if(readeflags()&FL_IF)
80104b82:	e8 15 f8 ff ff       	call   8010439c <readeflags>
80104b87:	25 00 02 00 00       	and    $0x200,%eax
80104b8c:	85 c0                	test   %eax,%eax
80104b8e:	74 0d                	je     80104b9d <sched+0x7b>
    panic("sched interruptible");
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	68 9d 87 10 80       	push   $0x8010879d
80104b98:	e8 bf b9 ff ff       	call   8010055c <panic>
  intena = cpu->intena;
80104b9d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ba3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104bac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bb2:	8b 40 04             	mov    0x4(%eax),%eax
80104bb5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bbc:	83 c2 1c             	add    $0x1c,%edx
80104bbf:	83 ec 08             	sub    $0x8,%esp
80104bc2:	50                   	push   %eax
80104bc3:	52                   	push   %edx
80104bc4:	e8 40 08 00 00       	call   80105409 <swtch>
80104bc9:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104bcc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bd5:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104bdb:	c9                   	leave  
80104bdc:	c3                   	ret    

80104bdd <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104bdd:	55                   	push   %ebp
80104bde:	89 e5                	mov    %esp,%ebp
80104be0:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104be3:	83 ec 0c             	sub    $0xc,%esp
80104be6:	68 40 2a 11 80       	push   $0x80112a40
80104beb:	e8 47 03 00 00       	call   80104f37 <acquire>
80104bf0:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104bf3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c00:	e8 1d ff ff ff       	call   80104b22 <sched>
  release(&ptable.lock);
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	68 40 2a 11 80       	push   $0x80112a40
80104c0d:	e8 8b 03 00 00       	call   80104f9d <release>
80104c12:	83 c4 10             	add    $0x10,%esp
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    

80104c17 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c17:	55                   	push   %ebp
80104c18:	89 e5                	mov    %esp,%ebp
80104c1a:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c1d:	83 ec 0c             	sub    $0xc,%esp
80104c20:	68 40 2a 11 80       	push   $0x80112a40
80104c25:	e8 73 03 00 00       	call   80104f9d <release>
80104c2a:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c2d:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104c32:	85 c0                	test   %eax,%eax
80104c34:	74 0f                	je     80104c45 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c36:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104c3d:	00 00 00 
    initlog();
80104c40:	e8 48 e6 ff ff       	call   8010328d <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    

80104c47 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c47:	55                   	push   %ebp
80104c48:	89 e5                	mov    %esp,%ebp
80104c4a:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c53:	85 c0                	test   %eax,%eax
80104c55:	75 0d                	jne    80104c64 <sleep+0x1d>
    panic("sleep");
80104c57:	83 ec 0c             	sub    $0xc,%esp
80104c5a:	68 b1 87 10 80       	push   $0x801087b1
80104c5f:	e8 f8 b8 ff ff       	call   8010055c <panic>

  if(lk == 0)
80104c64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c68:	75 0d                	jne    80104c77 <sleep+0x30>
    panic("sleep without lk");
80104c6a:	83 ec 0c             	sub    $0xc,%esp
80104c6d:	68 b7 87 10 80       	push   $0x801087b7
80104c72:	e8 e5 b8 ff ff       	call   8010055c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104c77:	81 7d 0c 40 2a 11 80 	cmpl   $0x80112a40,0xc(%ebp)
80104c7e:	74 1e                	je     80104c9e <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	68 40 2a 11 80       	push   $0x80112a40
80104c88:	e8 aa 02 00 00       	call   80104f37 <acquire>
80104c8d:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	ff 75 0c             	pushl  0xc(%ebp)
80104c96:	e8 02 03 00 00       	call   80104f9d <release>
80104c9b:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104c9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca7:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104caa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104cb7:	e8 66 fe ff ff       	call   80104b22 <sched>

  // Tidy up.
  proc->chan = 0;
80104cbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104cc9:	81 7d 0c 40 2a 11 80 	cmpl   $0x80112a40,0xc(%ebp)
80104cd0:	74 1e                	je     80104cf0 <sleep+0xa9>
    release(&ptable.lock);
80104cd2:	83 ec 0c             	sub    $0xc,%esp
80104cd5:	68 40 2a 11 80       	push   $0x80112a40
80104cda:	e8 be 02 00 00       	call   80104f9d <release>
80104cdf:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ce2:	83 ec 0c             	sub    $0xc,%esp
80104ce5:	ff 75 0c             	pushl  0xc(%ebp)
80104ce8:	e8 4a 02 00 00       	call   80104f37 <acquire>
80104ced:	83 c4 10             	add    $0x10,%esp
  }
}
80104cf0:	c9                   	leave  
80104cf1:	c3                   	ret    

80104cf2 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104cf2:	55                   	push   %ebp
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cf8:	c7 45 fc 74 2a 11 80 	movl   $0x80112a74,-0x4(%ebp)
80104cff:	eb 24                	jmp    80104d25 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d04:	8b 40 0c             	mov    0xc(%eax),%eax
80104d07:	83 f8 02             	cmp    $0x2,%eax
80104d0a:	75 15                	jne    80104d21 <wakeup1+0x2f>
80104d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d0f:	8b 40 20             	mov    0x20(%eax),%eax
80104d12:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d15:	75 0a                	jne    80104d21 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d1a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d21:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104d25:	81 7d fc 74 49 11 80 	cmpl   $0x80114974,-0x4(%ebp)
80104d2c:	72 d3                	jb     80104d01 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d2e:	c9                   	leave  
80104d2f:	c3                   	ret    

80104d30 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	68 40 2a 11 80       	push   $0x80112a40
80104d3e:	e8 f4 01 00 00       	call   80104f37 <acquire>
80104d43:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d46:	83 ec 0c             	sub    $0xc,%esp
80104d49:	ff 75 08             	pushl  0x8(%ebp)
80104d4c:	e8 a1 ff ff ff       	call   80104cf2 <wakeup1>
80104d51:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	68 40 2a 11 80       	push   $0x80112a40
80104d5c:	e8 3c 02 00 00       	call   80104f9d <release>
80104d61:	83 c4 10             	add    $0x10,%esp
}
80104d64:	c9                   	leave  
80104d65:	c3                   	ret    

80104d66 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d66:	55                   	push   %ebp
80104d67:	89 e5                	mov    %esp,%ebp
80104d69:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	68 40 2a 11 80       	push   $0x80112a40
80104d74:	e8 be 01 00 00       	call   80104f37 <acquire>
80104d79:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d7c:	c7 45 f4 74 2a 11 80 	movl   $0x80112a74,-0xc(%ebp)
80104d83:	eb 45                	jmp    80104dca <kill+0x64>
    if(p->pid == pid){
80104d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d88:	8b 40 10             	mov    0x10(%eax),%eax
80104d8b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d8e:	75 36                	jne    80104dc6 <kill+0x60>
      p->killed = 1;
80104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d93:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9d:	8b 40 0c             	mov    0xc(%eax),%eax
80104da0:	83 f8 02             	cmp    $0x2,%eax
80104da3:	75 0a                	jne    80104daf <kill+0x49>
        p->state = RUNNABLE;
80104da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	68 40 2a 11 80       	push   $0x80112a40
80104db7:	e8 e1 01 00 00       	call   80104f9d <release>
80104dbc:	83 c4 10             	add    $0x10,%esp
      return 0;
80104dbf:	b8 00 00 00 00       	mov    $0x0,%eax
80104dc4:	eb 22                	jmp    80104de8 <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dc6:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104dca:	81 7d f4 74 49 11 80 	cmpl   $0x80114974,-0xc(%ebp)
80104dd1:	72 b2                	jb     80104d85 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104dd3:	83 ec 0c             	sub    $0xc,%esp
80104dd6:	68 40 2a 11 80       	push   $0x80112a40
80104ddb:	e8 bd 01 00 00       	call   80104f9d <release>
80104de0:	83 c4 10             	add    $0x10,%esp
  return -1;
80104de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de8:	c9                   	leave  
80104de9:	c3                   	ret    

80104dea <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104dea:	55                   	push   %ebp
80104deb:	89 e5                	mov    %esp,%ebp
80104ded:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df0:	c7 45 f0 74 2a 11 80 	movl   $0x80112a74,-0x10(%ebp)
80104df7:	e9 d5 00 00 00       	jmp    80104ed1 <procdump+0xe7>
    if(p->state == UNUSED)
80104dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dff:	8b 40 0c             	mov    0xc(%eax),%eax
80104e02:	85 c0                	test   %eax,%eax
80104e04:	75 05                	jne    80104e0b <procdump+0x21>
      continue;
80104e06:	e9 c2 00 00 00       	jmp    80104ecd <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e11:	83 f8 05             	cmp    $0x5,%eax
80104e14:	77 23                	ja     80104e39 <procdump+0x4f>
80104e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e19:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1c:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e23:	85 c0                	test   %eax,%eax
80104e25:	74 12                	je     80104e39 <procdump+0x4f>
      state = states[p->state];
80104e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e2d:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e34:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e37:	eb 07                	jmp    80104e40 <procdump+0x56>
    else
      state = "???";
80104e39:	c7 45 ec c8 87 10 80 	movl   $0x801087c8,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e43:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e49:	8b 40 10             	mov    0x10(%eax),%eax
80104e4c:	52                   	push   %edx
80104e4d:	ff 75 ec             	pushl  -0x14(%ebp)
80104e50:	50                   	push   %eax
80104e51:	68 cc 87 10 80       	push   $0x801087cc
80104e56:	e8 64 b5 ff ff       	call   801003bf <cprintf>
80104e5b:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e61:	8b 40 0c             	mov    0xc(%eax),%eax
80104e64:	83 f8 02             	cmp    $0x2,%eax
80104e67:	75 54                	jne    80104ebd <procdump+0xd3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e6c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e6f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e72:	83 c0 08             	add    $0x8,%eax
80104e75:	89 c2                	mov    %eax,%edx
80104e77:	83 ec 08             	sub    $0x8,%esp
80104e7a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e7d:	50                   	push   %eax
80104e7e:	52                   	push   %edx
80104e7f:	e8 6a 01 00 00       	call   80104fee <getcallerpcs>
80104e84:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104e87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104e8e:	eb 1c                	jmp    80104eac <procdump+0xc2>
        cprintf(" %p", pc[i]);
80104e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e93:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	50                   	push   %eax
80104e9b:	68 d5 87 10 80       	push   $0x801087d5
80104ea0:	e8 1a b5 ff ff       	call   801003bf <cprintf>
80104ea5:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ea8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104eac:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104eb0:	7f 0b                	jg     80104ebd <procdump+0xd3>
80104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eb9:	85 c0                	test   %eax,%eax
80104ebb:	75 d3                	jne    80104e90 <procdump+0xa6>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ebd:	83 ec 0c             	sub    $0xc,%esp
80104ec0:	68 d9 87 10 80       	push   $0x801087d9
80104ec5:	e8 f5 b4 ff ff       	call   801003bf <cprintf>
80104eca:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ecd:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104ed1:	81 7d f0 74 49 11 80 	cmpl   $0x80114974,-0x10(%ebp)
80104ed8:	0f 82 1e ff ff ff    	jb     80104dfc <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104ede:	c9                   	leave  
80104edf:	c3                   	ret    

80104ee0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ee6:	9c                   	pushf  
80104ee7:	58                   	pop    %eax
80104ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104eee:	c9                   	leave  
80104eef:	c3                   	ret    

80104ef0 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104ef3:	fa                   	cli    
}
80104ef4:	5d                   	pop    %ebp
80104ef5:	c3                   	ret    

80104ef6 <sti>:

static inline void
sti(void)
{
80104ef6:	55                   	push   %ebp
80104ef7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104ef9:	fb                   	sti    
}
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    

80104efc <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104efc:	55                   	push   %ebp
80104efd:	89 e5                	mov    %esp,%ebp
80104eff:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f02:	8b 55 08             	mov    0x8(%ebp),%edx
80104f05:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f08:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f0b:	f0 87 02             	lock xchg %eax,(%edx)
80104f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f14:	c9                   	leave  
80104f15:	c3                   	ret    

80104f16 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f16:	55                   	push   %ebp
80104f17:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f19:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f22:	8b 45 08             	mov    0x8(%ebp),%eax
80104f25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f35:	5d                   	pop    %ebp
80104f36:	c3                   	ret    

80104f37 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f37:	55                   	push   %ebp
80104f38:	89 e5                	mov    %esp,%ebp
80104f3a:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f3d:	e8 4f 01 00 00       	call   80105091 <pushcli>
  if(holding(lk))
80104f42:	8b 45 08             	mov    0x8(%ebp),%eax
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	50                   	push   %eax
80104f49:	e8 19 01 00 00       	call   80105067 <holding>
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	85 c0                	test   %eax,%eax
80104f53:	74 0d                	je     80104f62 <acquire+0x2b>
    panic("acquire");
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	68 05 88 10 80       	push   $0x80108805
80104f5d:	e8 fa b5 ff ff       	call   8010055c <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104f62:	90                   	nop
80104f63:	8b 45 08             	mov    0x8(%ebp),%eax
80104f66:	83 ec 08             	sub    $0x8,%esp
80104f69:	6a 01                	push   $0x1
80104f6b:	50                   	push   %eax
80104f6c:	e8 8b ff ff ff       	call   80104efc <xchg>
80104f71:	83 c4 10             	add    $0x10,%esp
80104f74:	85 c0                	test   %eax,%eax
80104f76:	75 eb                	jne    80104f63 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104f78:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104f82:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104f85:	8b 45 08             	mov    0x8(%ebp),%eax
80104f88:	83 c0 0c             	add    $0xc,%eax
80104f8b:	83 ec 08             	sub    $0x8,%esp
80104f8e:	50                   	push   %eax
80104f8f:	8d 45 08             	lea    0x8(%ebp),%eax
80104f92:	50                   	push   %eax
80104f93:	e8 56 00 00 00       	call   80104fee <getcallerpcs>
80104f98:	83 c4 10             	add    $0x10,%esp
}
80104f9b:	c9                   	leave  
80104f9c:	c3                   	ret    

80104f9d <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104f9d:	55                   	push   %ebp
80104f9e:	89 e5                	mov    %esp,%ebp
80104fa0:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104fa3:	83 ec 0c             	sub    $0xc,%esp
80104fa6:	ff 75 08             	pushl  0x8(%ebp)
80104fa9:	e8 b9 00 00 00       	call   80105067 <holding>
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	75 0d                	jne    80104fc2 <release+0x25>
    panic("release");
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	68 0d 88 10 80       	push   $0x8010880d
80104fbd:	e8 9a b5 ff ff       	call   8010055c <panic>

  lk->pcs[0] = 0;
80104fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd9:	83 ec 08             	sub    $0x8,%esp
80104fdc:	6a 00                	push   $0x0
80104fde:	50                   	push   %eax
80104fdf:	e8 18 ff ff ff       	call   80104efc <xchg>
80104fe4:	83 c4 10             	add    $0x10,%esp

  popcli();
80104fe7:	e8 e9 00 00 00       	call   801050d5 <popcli>
}
80104fec:	c9                   	leave  
80104fed:	c3                   	ret    

80104fee <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104fee:	55                   	push   %ebp
80104fef:	89 e5                	mov    %esp,%ebp
80104ff1:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff7:	83 e8 08             	sub    $0x8,%eax
80104ffa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104ffd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105004:	eb 38                	jmp    8010503e <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105006:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010500a:	74 38                	je     80105044 <getcallerpcs+0x56>
8010500c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105013:	76 2f                	jbe    80105044 <getcallerpcs+0x56>
80105015:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105019:	74 29                	je     80105044 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010501b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010501e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105025:	8b 45 0c             	mov    0xc(%ebp),%eax
80105028:	01 c2                	add    %eax,%edx
8010502a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010502d:	8b 40 04             	mov    0x4(%eax),%eax
80105030:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105032:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105035:	8b 00                	mov    (%eax),%eax
80105037:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010503a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010503e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105042:	7e c2                	jle    80105006 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105044:	eb 19                	jmp    8010505f <getcallerpcs+0x71>
    pcs[i] = 0;
80105046:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105049:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105050:	8b 45 0c             	mov    0xc(%ebp),%eax
80105053:	01 d0                	add    %edx,%eax
80105055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010505b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010505f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105063:	7e e1                	jle    80105046 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105065:	c9                   	leave  
80105066:	c3                   	ret    

80105067 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105067:	55                   	push   %ebp
80105068:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010506a:	8b 45 08             	mov    0x8(%ebp),%eax
8010506d:	8b 00                	mov    (%eax),%eax
8010506f:	85 c0                	test   %eax,%eax
80105071:	74 17                	je     8010508a <holding+0x23>
80105073:	8b 45 08             	mov    0x8(%ebp),%eax
80105076:	8b 50 08             	mov    0x8(%eax),%edx
80105079:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010507f:	39 c2                	cmp    %eax,%edx
80105081:	75 07                	jne    8010508a <holding+0x23>
80105083:	b8 01 00 00 00       	mov    $0x1,%eax
80105088:	eb 05                	jmp    8010508f <holding+0x28>
8010508a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010508f:	5d                   	pop    %ebp
80105090:	c3                   	ret    

80105091 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105091:	55                   	push   %ebp
80105092:	89 e5                	mov    %esp,%ebp
80105094:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105097:	e8 44 fe ff ff       	call   80104ee0 <readeflags>
8010509c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010509f:	e8 4c fe ff ff       	call   80104ef0 <cli>
  if(cpu->ncli++ == 0)
801050a4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050ab:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801050b1:	8d 48 01             	lea    0x1(%eax),%ecx
801050b4:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801050ba:	85 c0                	test   %eax,%eax
801050bc:	75 15                	jne    801050d3 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801050be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050c7:	81 e2 00 02 00 00    	and    $0x200,%edx
801050cd:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801050d3:	c9                   	leave  
801050d4:	c3                   	ret    

801050d5 <popcli>:

void
popcli(void)
{
801050d5:	55                   	push   %ebp
801050d6:	89 e5                	mov    %esp,%ebp
801050d8:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801050db:	e8 00 fe ff ff       	call   80104ee0 <readeflags>
801050e0:	25 00 02 00 00       	and    $0x200,%eax
801050e5:	85 c0                	test   %eax,%eax
801050e7:	74 0d                	je     801050f6 <popcli+0x21>
    panic("popcli - interruptible");
801050e9:	83 ec 0c             	sub    $0xc,%esp
801050ec:	68 15 88 10 80       	push   $0x80108815
801050f1:	e8 66 b4 ff ff       	call   8010055c <panic>
  if(--cpu->ncli < 0)
801050f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050fc:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105102:	83 ea 01             	sub    $0x1,%edx
80105105:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010510b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105111:	85 c0                	test   %eax,%eax
80105113:	79 0d                	jns    80105122 <popcli+0x4d>
    panic("popcli");
80105115:	83 ec 0c             	sub    $0xc,%esp
80105118:	68 2c 88 10 80       	push   $0x8010882c
8010511d:	e8 3a b4 ff ff       	call   8010055c <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105122:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105128:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010512e:	85 c0                	test   %eax,%eax
80105130:	75 15                	jne    80105147 <popcli+0x72>
80105132:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105138:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010513e:	85 c0                	test   %eax,%eax
80105140:	74 05                	je     80105147 <popcli+0x72>
    sti();
80105142:	e8 af fd ff ff       	call   80104ef6 <sti>
}
80105147:	c9                   	leave  
80105148:	c3                   	ret    

80105149 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105149:	55                   	push   %ebp
8010514a:	89 e5                	mov    %esp,%ebp
8010514c:	57                   	push   %edi
8010514d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010514e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105151:	8b 55 10             	mov    0x10(%ebp),%edx
80105154:	8b 45 0c             	mov    0xc(%ebp),%eax
80105157:	89 cb                	mov    %ecx,%ebx
80105159:	89 df                	mov    %ebx,%edi
8010515b:	89 d1                	mov    %edx,%ecx
8010515d:	fc                   	cld    
8010515e:	f3 aa                	rep stos %al,%es:(%edi)
80105160:	89 ca                	mov    %ecx,%edx
80105162:	89 fb                	mov    %edi,%ebx
80105164:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105167:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010516a:	5b                   	pop    %ebx
8010516b:	5f                   	pop    %edi
8010516c:	5d                   	pop    %ebp
8010516d:	c3                   	ret    

8010516e <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010516e:	55                   	push   %ebp
8010516f:	89 e5                	mov    %esp,%ebp
80105171:	57                   	push   %edi
80105172:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105173:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105176:	8b 55 10             	mov    0x10(%ebp),%edx
80105179:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517c:	89 cb                	mov    %ecx,%ebx
8010517e:	89 df                	mov    %ebx,%edi
80105180:	89 d1                	mov    %edx,%ecx
80105182:	fc                   	cld    
80105183:	f3 ab                	rep stos %eax,%es:(%edi)
80105185:	89 ca                	mov    %ecx,%edx
80105187:	89 fb                	mov    %edi,%ebx
80105189:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010518c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010518f:	5b                   	pop    %ebx
80105190:	5f                   	pop    %edi
80105191:	5d                   	pop    %ebp
80105192:	c3                   	ret    

80105193 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105193:	55                   	push   %ebp
80105194:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105196:	8b 45 08             	mov    0x8(%ebp),%eax
80105199:	83 e0 03             	and    $0x3,%eax
8010519c:	85 c0                	test   %eax,%eax
8010519e:	75 43                	jne    801051e3 <memset+0x50>
801051a0:	8b 45 10             	mov    0x10(%ebp),%eax
801051a3:	83 e0 03             	and    $0x3,%eax
801051a6:	85 c0                	test   %eax,%eax
801051a8:	75 39                	jne    801051e3 <memset+0x50>
    c &= 0xFF;
801051aa:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051b1:	8b 45 10             	mov    0x10(%ebp),%eax
801051b4:	c1 e8 02             	shr    $0x2,%eax
801051b7:	89 c1                	mov    %eax,%ecx
801051b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bc:	c1 e0 18             	shl    $0x18,%eax
801051bf:	89 c2                	mov    %eax,%edx
801051c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c4:	c1 e0 10             	shl    $0x10,%eax
801051c7:	09 c2                	or     %eax,%edx
801051c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051cc:	c1 e0 08             	shl    $0x8,%eax
801051cf:	09 d0                	or     %edx,%eax
801051d1:	0b 45 0c             	or     0xc(%ebp),%eax
801051d4:	51                   	push   %ecx
801051d5:	50                   	push   %eax
801051d6:	ff 75 08             	pushl  0x8(%ebp)
801051d9:	e8 90 ff ff ff       	call   8010516e <stosl>
801051de:	83 c4 0c             	add    $0xc,%esp
801051e1:	eb 12                	jmp    801051f5 <memset+0x62>
  } else
    stosb(dst, c, n);
801051e3:	8b 45 10             	mov    0x10(%ebp),%eax
801051e6:	50                   	push   %eax
801051e7:	ff 75 0c             	pushl  0xc(%ebp)
801051ea:	ff 75 08             	pushl  0x8(%ebp)
801051ed:	e8 57 ff ff ff       	call   80105149 <stosb>
801051f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
801051f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051f8:	c9                   	leave  
801051f9:	c3                   	ret    

801051fa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051fa:	55                   	push   %ebp
801051fb:	89 e5                	mov    %esp,%ebp
801051fd:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105200:	8b 45 08             	mov    0x8(%ebp),%eax
80105203:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105206:	8b 45 0c             	mov    0xc(%ebp),%eax
80105209:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010520c:	eb 30                	jmp    8010523e <memcmp+0x44>
    if(*s1 != *s2)
8010520e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105211:	0f b6 10             	movzbl (%eax),%edx
80105214:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105217:	0f b6 00             	movzbl (%eax),%eax
8010521a:	38 c2                	cmp    %al,%dl
8010521c:	74 18                	je     80105236 <memcmp+0x3c>
      return *s1 - *s2;
8010521e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105221:	0f b6 00             	movzbl (%eax),%eax
80105224:	0f b6 d0             	movzbl %al,%edx
80105227:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010522a:	0f b6 00             	movzbl (%eax),%eax
8010522d:	0f b6 c0             	movzbl %al,%eax
80105230:	29 c2                	sub    %eax,%edx
80105232:	89 d0                	mov    %edx,%eax
80105234:	eb 1a                	jmp    80105250 <memcmp+0x56>
    s1++, s2++;
80105236:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010523a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010523e:	8b 45 10             	mov    0x10(%ebp),%eax
80105241:	8d 50 ff             	lea    -0x1(%eax),%edx
80105244:	89 55 10             	mov    %edx,0x10(%ebp)
80105247:	85 c0                	test   %eax,%eax
80105249:	75 c3                	jne    8010520e <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010524b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105250:	c9                   	leave  
80105251:	c3                   	ret    

80105252 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105252:	55                   	push   %ebp
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010525e:	8b 45 08             	mov    0x8(%ebp),%eax
80105261:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105264:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105267:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010526a:	73 3d                	jae    801052a9 <memmove+0x57>
8010526c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010526f:	8b 45 10             	mov    0x10(%ebp),%eax
80105272:	01 d0                	add    %edx,%eax
80105274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105277:	76 30                	jbe    801052a9 <memmove+0x57>
    s += n;
80105279:	8b 45 10             	mov    0x10(%ebp),%eax
8010527c:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010527f:	8b 45 10             	mov    0x10(%ebp),%eax
80105282:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105285:	eb 13                	jmp    8010529a <memmove+0x48>
      *--d = *--s;
80105287:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010528b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010528f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105292:	0f b6 10             	movzbl (%eax),%edx
80105295:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105298:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010529a:	8b 45 10             	mov    0x10(%ebp),%eax
8010529d:	8d 50 ff             	lea    -0x1(%eax),%edx
801052a0:	89 55 10             	mov    %edx,0x10(%ebp)
801052a3:	85 c0                	test   %eax,%eax
801052a5:	75 e0                	jne    80105287 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052a7:	eb 26                	jmp    801052cf <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052a9:	eb 17                	jmp    801052c2 <memmove+0x70>
      *d++ = *s++;
801052ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052ae:	8d 50 01             	lea    0x1(%eax),%edx
801052b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
801052b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052b7:	8d 4a 01             	lea    0x1(%edx),%ecx
801052ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801052bd:	0f b6 12             	movzbl (%edx),%edx
801052c0:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052c2:	8b 45 10             	mov    0x10(%ebp),%eax
801052c5:	8d 50 ff             	lea    -0x1(%eax),%edx
801052c8:	89 55 10             	mov    %edx,0x10(%ebp)
801052cb:	85 c0                	test   %eax,%eax
801052cd:	75 dc                	jne    801052ab <memmove+0x59>
      *d++ = *s++;

  return dst;
801052cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052d2:	c9                   	leave  
801052d3:	c3                   	ret    

801052d4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801052d7:	ff 75 10             	pushl  0x10(%ebp)
801052da:	ff 75 0c             	pushl  0xc(%ebp)
801052dd:	ff 75 08             	pushl  0x8(%ebp)
801052e0:	e8 6d ff ff ff       	call   80105252 <memmove>
801052e5:	83 c4 0c             	add    $0xc,%esp
}
801052e8:	c9                   	leave  
801052e9:	c3                   	ret    

801052ea <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801052ea:	55                   	push   %ebp
801052eb:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801052ed:	eb 0c                	jmp    801052fb <strncmp+0x11>
    n--, p++, q++;
801052ef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801052f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801052fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052ff:	74 1a                	je     8010531b <strncmp+0x31>
80105301:	8b 45 08             	mov    0x8(%ebp),%eax
80105304:	0f b6 00             	movzbl (%eax),%eax
80105307:	84 c0                	test   %al,%al
80105309:	74 10                	je     8010531b <strncmp+0x31>
8010530b:	8b 45 08             	mov    0x8(%ebp),%eax
8010530e:	0f b6 10             	movzbl (%eax),%edx
80105311:	8b 45 0c             	mov    0xc(%ebp),%eax
80105314:	0f b6 00             	movzbl (%eax),%eax
80105317:	38 c2                	cmp    %al,%dl
80105319:	74 d4                	je     801052ef <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010531b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010531f:	75 07                	jne    80105328 <strncmp+0x3e>
    return 0;
80105321:	b8 00 00 00 00       	mov    $0x0,%eax
80105326:	eb 16                	jmp    8010533e <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105328:	8b 45 08             	mov    0x8(%ebp),%eax
8010532b:	0f b6 00             	movzbl (%eax),%eax
8010532e:	0f b6 d0             	movzbl %al,%edx
80105331:	8b 45 0c             	mov    0xc(%ebp),%eax
80105334:	0f b6 00             	movzbl (%eax),%eax
80105337:	0f b6 c0             	movzbl %al,%eax
8010533a:	29 c2                	sub    %eax,%edx
8010533c:	89 d0                	mov    %edx,%eax
}
8010533e:	5d                   	pop    %ebp
8010533f:	c3                   	ret    

80105340 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105346:	8b 45 08             	mov    0x8(%ebp),%eax
80105349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010534c:	90                   	nop
8010534d:	8b 45 10             	mov    0x10(%ebp),%eax
80105350:	8d 50 ff             	lea    -0x1(%eax),%edx
80105353:	89 55 10             	mov    %edx,0x10(%ebp)
80105356:	85 c0                	test   %eax,%eax
80105358:	7e 1e                	jle    80105378 <strncpy+0x38>
8010535a:	8b 45 08             	mov    0x8(%ebp),%eax
8010535d:	8d 50 01             	lea    0x1(%eax),%edx
80105360:	89 55 08             	mov    %edx,0x8(%ebp)
80105363:	8b 55 0c             	mov    0xc(%ebp),%edx
80105366:	8d 4a 01             	lea    0x1(%edx),%ecx
80105369:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010536c:	0f b6 12             	movzbl (%edx),%edx
8010536f:	88 10                	mov    %dl,(%eax)
80105371:	0f b6 00             	movzbl (%eax),%eax
80105374:	84 c0                	test   %al,%al
80105376:	75 d5                	jne    8010534d <strncpy+0xd>
    ;
  while(n-- > 0)
80105378:	eb 0c                	jmp    80105386 <strncpy+0x46>
    *s++ = 0;
8010537a:	8b 45 08             	mov    0x8(%ebp),%eax
8010537d:	8d 50 01             	lea    0x1(%eax),%edx
80105380:	89 55 08             	mov    %edx,0x8(%ebp)
80105383:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105386:	8b 45 10             	mov    0x10(%ebp),%eax
80105389:	8d 50 ff             	lea    -0x1(%eax),%edx
8010538c:	89 55 10             	mov    %edx,0x10(%ebp)
8010538f:	85 c0                	test   %eax,%eax
80105391:	7f e7                	jg     8010537a <strncpy+0x3a>
    *s++ = 0;
  return os;
80105393:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105396:	c9                   	leave  
80105397:	c3                   	ret    

80105398 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105398:	55                   	push   %ebp
80105399:	89 e5                	mov    %esp,%ebp
8010539b:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010539e:	8b 45 08             	mov    0x8(%ebp),%eax
801053a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053a8:	7f 05                	jg     801053af <safestrcpy+0x17>
    return os;
801053aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ad:	eb 31                	jmp    801053e0 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801053af:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053b7:	7e 1e                	jle    801053d7 <safestrcpy+0x3f>
801053b9:	8b 45 08             	mov    0x8(%ebp),%eax
801053bc:	8d 50 01             	lea    0x1(%eax),%edx
801053bf:	89 55 08             	mov    %edx,0x8(%ebp)
801053c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801053c5:	8d 4a 01             	lea    0x1(%edx),%ecx
801053c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053cb:	0f b6 12             	movzbl (%edx),%edx
801053ce:	88 10                	mov    %dl,(%eax)
801053d0:	0f b6 00             	movzbl (%eax),%eax
801053d3:	84 c0                	test   %al,%al
801053d5:	75 d8                	jne    801053af <safestrcpy+0x17>
    ;
  *s = 0;
801053d7:	8b 45 08             	mov    0x8(%ebp),%eax
801053da:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801053dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053e0:	c9                   	leave  
801053e1:	c3                   	ret    

801053e2 <strlen>:

int
strlen(const char *s)
{
801053e2:	55                   	push   %ebp
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801053e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801053ef:	eb 04                	jmp    801053f5 <strlen+0x13>
801053f1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053f8:	8b 45 08             	mov    0x8(%ebp),%eax
801053fb:	01 d0                	add    %edx,%eax
801053fd:	0f b6 00             	movzbl (%eax),%eax
80105400:	84 c0                	test   %al,%al
80105402:	75 ed                	jne    801053f1 <strlen+0xf>
    ;
  return n;
80105404:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105407:	c9                   	leave  
80105408:	c3                   	ret    

80105409 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105409:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010540d:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105411:	55                   	push   %ebp
  pushl %ebx
80105412:	53                   	push   %ebx
  pushl %esi
80105413:	56                   	push   %esi
  pushl %edi
80105414:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105415:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105417:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105419:	5f                   	pop    %edi
  popl %esi
8010541a:	5e                   	pop    %esi
  popl %ebx
8010541b:	5b                   	pop    %ebx
  popl %ebp
8010541c:	5d                   	pop    %ebp
  ret
8010541d:	c3                   	ret    

8010541e <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010541e:	55                   	push   %ebp
8010541f:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105421:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105427:	8b 00                	mov    (%eax),%eax
80105429:	3b 45 08             	cmp    0x8(%ebp),%eax
8010542c:	76 12                	jbe    80105440 <fetchint+0x22>
8010542e:	8b 45 08             	mov    0x8(%ebp),%eax
80105431:	8d 50 04             	lea    0x4(%eax),%edx
80105434:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010543a:	8b 00                	mov    (%eax),%eax
8010543c:	39 c2                	cmp    %eax,%edx
8010543e:	76 07                	jbe    80105447 <fetchint+0x29>
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105445:	eb 0f                	jmp    80105456 <fetchint+0x38>
  *ip = *(int*)(addr);
80105447:	8b 45 08             	mov    0x8(%ebp),%eax
8010544a:	8b 10                	mov    (%eax),%edx
8010544c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544f:	89 10                	mov    %edx,(%eax)
  return 0;
80105451:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105456:	5d                   	pop    %ebp
80105457:	c3                   	ret    

80105458 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105458:	55                   	push   %ebp
80105459:	89 e5                	mov    %esp,%ebp
8010545b:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010545e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105464:	8b 00                	mov    (%eax),%eax
80105466:	3b 45 08             	cmp    0x8(%ebp),%eax
80105469:	77 07                	ja     80105472 <fetchstr+0x1a>
    return -1;
8010546b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105470:	eb 46                	jmp    801054b8 <fetchstr+0x60>
  *pp = (char*)addr;
80105472:	8b 55 08             	mov    0x8(%ebp),%edx
80105475:	8b 45 0c             	mov    0xc(%ebp),%eax
80105478:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010547a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105480:	8b 00                	mov    (%eax),%eax
80105482:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105485:	8b 45 0c             	mov    0xc(%ebp),%eax
80105488:	8b 00                	mov    (%eax),%eax
8010548a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010548d:	eb 1c                	jmp    801054ab <fetchstr+0x53>
    if(*s == 0)
8010548f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105492:	0f b6 00             	movzbl (%eax),%eax
80105495:	84 c0                	test   %al,%al
80105497:	75 0e                	jne    801054a7 <fetchstr+0x4f>
      return s - *pp;
80105499:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010549c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010549f:	8b 00                	mov    (%eax),%eax
801054a1:	29 c2                	sub    %eax,%edx
801054a3:	89 d0                	mov    %edx,%eax
801054a5:	eb 11                	jmp    801054b8 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801054a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054b1:	72 dc                	jb     8010548f <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801054b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b8:	c9                   	leave  
801054b9:	c3                   	ret    

801054ba <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054ba:	55                   	push   %ebp
801054bb:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801054bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c3:	8b 40 18             	mov    0x18(%eax),%eax
801054c6:	8b 40 44             	mov    0x44(%eax),%eax
801054c9:	8b 55 08             	mov    0x8(%ebp),%edx
801054cc:	c1 e2 02             	shl    $0x2,%edx
801054cf:	01 d0                	add    %edx,%eax
801054d1:	83 c0 04             	add    $0x4,%eax
801054d4:	ff 75 0c             	pushl  0xc(%ebp)
801054d7:	50                   	push   %eax
801054d8:	e8 41 ff ff ff       	call   8010541e <fetchint>
801054dd:	83 c4 08             	add    $0x8,%esp
}
801054e0:	c9                   	leave  
801054e1:	c3                   	ret    

801054e2 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054e2:	55                   	push   %ebp
801054e3:	89 e5                	mov    %esp,%ebp
801054e5:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801054e8:	8d 45 fc             	lea    -0x4(%ebp),%eax
801054eb:	50                   	push   %eax
801054ec:	ff 75 08             	pushl  0x8(%ebp)
801054ef:	e8 c6 ff ff ff       	call   801054ba <argint>
801054f4:	83 c4 08             	add    $0x8,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	79 07                	jns    80105502 <argptr+0x20>
    return -1;
801054fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105500:	eb 3d                	jmp    8010553f <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105502:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105505:	89 c2                	mov    %eax,%edx
80105507:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550d:	8b 00                	mov    (%eax),%eax
8010550f:	39 c2                	cmp    %eax,%edx
80105511:	73 16                	jae    80105529 <argptr+0x47>
80105513:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105516:	89 c2                	mov    %eax,%edx
80105518:	8b 45 10             	mov    0x10(%ebp),%eax
8010551b:	01 c2                	add    %eax,%edx
8010551d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105523:	8b 00                	mov    (%eax),%eax
80105525:	39 c2                	cmp    %eax,%edx
80105527:	76 07                	jbe    80105530 <argptr+0x4e>
    return -1;
80105529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552e:	eb 0f                	jmp    8010553f <argptr+0x5d>
  *pp = (char*)i;
80105530:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105533:	89 c2                	mov    %eax,%edx
80105535:	8b 45 0c             	mov    0xc(%ebp),%eax
80105538:	89 10                	mov    %edx,(%eax)
  return 0;
8010553a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010553f:	c9                   	leave  
80105540:	c3                   	ret    

80105541 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105541:	55                   	push   %ebp
80105542:	89 e5                	mov    %esp,%ebp
80105544:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105547:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010554a:	50                   	push   %eax
8010554b:	ff 75 08             	pushl  0x8(%ebp)
8010554e:	e8 67 ff ff ff       	call   801054ba <argint>
80105553:	83 c4 08             	add    $0x8,%esp
80105556:	85 c0                	test   %eax,%eax
80105558:	79 07                	jns    80105561 <argstr+0x20>
    return -1;
8010555a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555f:	eb 0f                	jmp    80105570 <argstr+0x2f>
  return fetchstr(addr, pp);
80105561:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105564:	ff 75 0c             	pushl  0xc(%ebp)
80105567:	50                   	push   %eax
80105568:	e8 eb fe ff ff       	call   80105458 <fetchstr>
8010556d:	83 c4 08             	add    $0x8,%esp
}
80105570:	c9                   	leave  
80105571:	c3                   	ret    

80105572 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105572:	55                   	push   %ebp
80105573:	89 e5                	mov    %esp,%ebp
80105575:	53                   	push   %ebx
80105576:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105579:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010557f:	8b 40 18             	mov    0x18(%eax),%eax
80105582:	8b 40 1c             	mov    0x1c(%eax),%eax
80105585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010558c:	7e 30                	jle    801055be <syscall+0x4c>
8010558e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105591:	83 f8 15             	cmp    $0x15,%eax
80105594:	77 28                	ja     801055be <syscall+0x4c>
80105596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105599:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055a0:	85 c0                	test   %eax,%eax
801055a2:	74 1a                	je     801055be <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055aa:	8b 58 18             	mov    0x18(%eax),%ebx
801055ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b0:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055b7:	ff d0                	call   *%eax
801055b9:	89 43 1c             	mov    %eax,0x1c(%ebx)
801055bc:	eb 34                	jmp    801055f2 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801055be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c4:	8d 50 6c             	lea    0x6c(%eax),%edx
801055c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801055cd:	8b 40 10             	mov    0x10(%eax),%eax
801055d0:	ff 75 f4             	pushl  -0xc(%ebp)
801055d3:	52                   	push   %edx
801055d4:	50                   	push   %eax
801055d5:	68 33 88 10 80       	push   $0x80108833
801055da:	e8 e0 ad ff ff       	call   801003bf <cprintf>
801055df:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801055e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e8:	8b 40 18             	mov    0x18(%eax),%eax
801055eb:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801055f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055f5:	c9                   	leave  
801055f6:	c3                   	ret    

801055f7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801055f7:	55                   	push   %ebp
801055f8:	89 e5                	mov    %esp,%ebp
801055fa:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801055fd:	83 ec 08             	sub    $0x8,%esp
80105600:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105603:	50                   	push   %eax
80105604:	ff 75 08             	pushl  0x8(%ebp)
80105607:	e8 ae fe ff ff       	call   801054ba <argint>
8010560c:	83 c4 10             	add    $0x10,%esp
8010560f:	85 c0                	test   %eax,%eax
80105611:	79 07                	jns    8010561a <argfd+0x23>
    return -1;
80105613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105618:	eb 50                	jmp    8010566a <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010561a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010561d:	85 c0                	test   %eax,%eax
8010561f:	78 21                	js     80105642 <argfd+0x4b>
80105621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105624:	83 f8 0f             	cmp    $0xf,%eax
80105627:	7f 19                	jg     80105642 <argfd+0x4b>
80105629:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105632:	83 c2 08             	add    $0x8,%edx
80105635:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105639:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010563c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105640:	75 07                	jne    80105649 <argfd+0x52>
    return -1;
80105642:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105647:	eb 21                	jmp    8010566a <argfd+0x73>
  if(pfd)
80105649:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010564d:	74 08                	je     80105657 <argfd+0x60>
    *pfd = fd;
8010564f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105652:	8b 45 0c             	mov    0xc(%ebp),%eax
80105655:	89 10                	mov    %edx,(%eax)
  if(pf)
80105657:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010565b:	74 08                	je     80105665 <argfd+0x6e>
    *pf = f;
8010565d:	8b 45 10             	mov    0x10(%ebp),%eax
80105660:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105663:	89 10                	mov    %edx,(%eax)
  return 0;
80105665:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010566a:	c9                   	leave  
8010566b:	c3                   	ret    

8010566c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010566c:	55                   	push   %ebp
8010566d:	89 e5                	mov    %esp,%ebp
8010566f:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105672:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105679:	eb 30                	jmp    801056ab <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010567b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105681:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105684:	83 c2 08             	add    $0x8,%edx
80105687:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010568b:	85 c0                	test   %eax,%eax
8010568d:	75 18                	jne    801056a7 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010568f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105695:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105698:	8d 4a 08             	lea    0x8(%edx),%ecx
8010569b:	8b 55 08             	mov    0x8(%ebp),%edx
8010569e:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801056a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056a5:	eb 0f                	jmp    801056b6 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056ab:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801056af:	7e ca                	jle    8010567b <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b6:	c9                   	leave  
801056b7:	c3                   	ret    

801056b8 <sys_dup>:

int
sys_dup(void)
{
801056b8:	55                   	push   %ebp
801056b9:	89 e5                	mov    %esp,%ebp
801056bb:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801056be:	83 ec 04             	sub    $0x4,%esp
801056c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c4:	50                   	push   %eax
801056c5:	6a 00                	push   $0x0
801056c7:	6a 00                	push   $0x0
801056c9:	e8 29 ff ff ff       	call   801055f7 <argfd>
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	85 c0                	test   %eax,%eax
801056d3:	79 07                	jns    801056dc <sys_dup+0x24>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056da:	eb 31                	jmp    8010570d <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801056dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056df:	83 ec 0c             	sub    $0xc,%esp
801056e2:	50                   	push   %eax
801056e3:	e8 84 ff ff ff       	call   8010566c <fdalloc>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056f2:	79 07                	jns    801056fb <sys_dup+0x43>
    return -1;
801056f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f9:	eb 12                	jmp    8010570d <sys_dup+0x55>
  filedup(f);
801056fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056fe:	83 ec 0c             	sub    $0xc,%esp
80105701:	50                   	push   %eax
80105702:	e8 c0 b8 ff ff       	call   80100fc7 <filedup>
80105707:	83 c4 10             	add    $0x10,%esp
  return fd;
8010570a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    

8010570f <sys_read>:

int
sys_read(void)
{
8010570f:	55                   	push   %ebp
80105710:	89 e5                	mov    %esp,%ebp
80105712:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105715:	83 ec 04             	sub    $0x4,%esp
80105718:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010571b:	50                   	push   %eax
8010571c:	6a 00                	push   $0x0
8010571e:	6a 00                	push   $0x0
80105720:	e8 d2 fe ff ff       	call   801055f7 <argfd>
80105725:	83 c4 10             	add    $0x10,%esp
80105728:	85 c0                	test   %eax,%eax
8010572a:	78 2e                	js     8010575a <sys_read+0x4b>
8010572c:	83 ec 08             	sub    $0x8,%esp
8010572f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105732:	50                   	push   %eax
80105733:	6a 02                	push   $0x2
80105735:	e8 80 fd ff ff       	call   801054ba <argint>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	78 19                	js     8010575a <sys_read+0x4b>
80105741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105744:	83 ec 04             	sub    $0x4,%esp
80105747:	50                   	push   %eax
80105748:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010574b:	50                   	push   %eax
8010574c:	6a 01                	push   $0x1
8010574e:	e8 8f fd ff ff       	call   801054e2 <argptr>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	79 07                	jns    80105761 <sys_read+0x52>
    return -1;
8010575a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575f:	eb 17                	jmp    80105778 <sys_read+0x69>
  return fileread(f, p, n);
80105761:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105764:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010576a:	83 ec 04             	sub    $0x4,%esp
8010576d:	51                   	push   %ecx
8010576e:	52                   	push   %edx
8010576f:	50                   	push   %eax
80105770:	e8 e2 b9 ff ff       	call   80101157 <fileread>
80105775:	83 c4 10             	add    $0x10,%esp
}
80105778:	c9                   	leave  
80105779:	c3                   	ret    

8010577a <sys_write>:

int
sys_write(void)
{
8010577a:	55                   	push   %ebp
8010577b:	89 e5                	mov    %esp,%ebp
8010577d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105780:	83 ec 04             	sub    $0x4,%esp
80105783:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105786:	50                   	push   %eax
80105787:	6a 00                	push   $0x0
80105789:	6a 00                	push   $0x0
8010578b:	e8 67 fe ff ff       	call   801055f7 <argfd>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	85 c0                	test   %eax,%eax
80105795:	78 2e                	js     801057c5 <sys_write+0x4b>
80105797:	83 ec 08             	sub    $0x8,%esp
8010579a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010579d:	50                   	push   %eax
8010579e:	6a 02                	push   $0x2
801057a0:	e8 15 fd ff ff       	call   801054ba <argint>
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	85 c0                	test   %eax,%eax
801057aa:	78 19                	js     801057c5 <sys_write+0x4b>
801057ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057af:	83 ec 04             	sub    $0x4,%esp
801057b2:	50                   	push   %eax
801057b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057b6:	50                   	push   %eax
801057b7:	6a 01                	push   $0x1
801057b9:	e8 24 fd ff ff       	call   801054e2 <argptr>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	79 07                	jns    801057cc <sys_write+0x52>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ca:	eb 17                	jmp    801057e3 <sys_write+0x69>
  return filewrite(f, p, n);
801057cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d5:	83 ec 04             	sub    $0x4,%esp
801057d8:	51                   	push   %ecx
801057d9:	52                   	push   %edx
801057da:	50                   	push   %eax
801057db:	e8 2f ba ff ff       	call   8010120f <filewrite>
801057e0:	83 c4 10             	add    $0x10,%esp
}
801057e3:	c9                   	leave  
801057e4:	c3                   	ret    

801057e5 <sys_close>:

int
sys_close(void)
{
801057e5:	55                   	push   %ebp
801057e6:	89 e5                	mov    %esp,%ebp
801057e8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801057eb:	83 ec 04             	sub    $0x4,%esp
801057ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f1:	50                   	push   %eax
801057f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f5:	50                   	push   %eax
801057f6:	6a 00                	push   $0x0
801057f8:	e8 fa fd ff ff       	call   801055f7 <argfd>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	79 07                	jns    8010580b <sys_close+0x26>
    return -1;
80105804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105809:	eb 28                	jmp    80105833 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010580b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105811:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105814:	83 c2 08             	add    $0x8,%edx
80105817:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010581e:	00 
  fileclose(f);
8010581f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	50                   	push   %eax
80105826:	e8 ed b7 ff ff       	call   80101018 <fileclose>
8010582b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010582e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105833:	c9                   	leave  
80105834:	c3                   	ret    

80105835 <sys_fstat>:

int
sys_fstat(void)
{
80105835:	55                   	push   %ebp
80105836:	89 e5                	mov    %esp,%ebp
80105838:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010583b:	83 ec 04             	sub    $0x4,%esp
8010583e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105841:	50                   	push   %eax
80105842:	6a 00                	push   $0x0
80105844:	6a 00                	push   $0x0
80105846:	e8 ac fd ff ff       	call   801055f7 <argfd>
8010584b:	83 c4 10             	add    $0x10,%esp
8010584e:	85 c0                	test   %eax,%eax
80105850:	78 17                	js     80105869 <sys_fstat+0x34>
80105852:	83 ec 04             	sub    $0x4,%esp
80105855:	6a 14                	push   $0x14
80105857:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010585a:	50                   	push   %eax
8010585b:	6a 01                	push   $0x1
8010585d:	e8 80 fc ff ff       	call   801054e2 <argptr>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	79 07                	jns    80105870 <sys_fstat+0x3b>
    return -1;
80105869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586e:	eb 13                	jmp    80105883 <sys_fstat+0x4e>
  return filestat(f, st);
80105870:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105876:	83 ec 08             	sub    $0x8,%esp
80105879:	52                   	push   %edx
8010587a:	50                   	push   %eax
8010587b:	e8 80 b8 ff ff       	call   80101100 <filestat>
80105880:	83 c4 10             	add    $0x10,%esp
}
80105883:	c9                   	leave  
80105884:	c3                   	ret    

80105885 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105885:	55                   	push   %ebp
80105886:	89 e5                	mov    %esp,%ebp
80105888:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105891:	50                   	push   %eax
80105892:	6a 00                	push   $0x0
80105894:	e8 a8 fc ff ff       	call   80105541 <argstr>
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	85 c0                	test   %eax,%eax
8010589e:	78 15                	js     801058b5 <sys_link+0x30>
801058a0:	83 ec 08             	sub    $0x8,%esp
801058a3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058a6:	50                   	push   %eax
801058a7:	6a 01                	push   $0x1
801058a9:	e8 93 fc ff ff       	call   80105541 <argstr>
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	85 c0                	test   %eax,%eax
801058b3:	79 0a                	jns    801058bf <sys_link+0x3a>
    return -1;
801058b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ba:	e9 69 01 00 00       	jmp    80105a28 <sys_link+0x1a3>

  begin_op();
801058bf:	e8 ea db ff ff       	call   801034ae <begin_op>
  if((ip = namei(old)) == 0){
801058c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801058c7:	83 ec 0c             	sub    $0xc,%esp
801058ca:	50                   	push   %eax
801058cb:	e8 cd cb ff ff       	call   8010249d <namei>
801058d0:	83 c4 10             	add    $0x10,%esp
801058d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058da:	75 0f                	jne    801058eb <sys_link+0x66>
    end_op();
801058dc:	e8 5b dc ff ff       	call   8010353c <end_op>
    return -1;
801058e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e6:	e9 3d 01 00 00       	jmp    80105a28 <sys_link+0x1a3>
  }

  ilock(ip);
801058eb:	83 ec 0c             	sub    $0xc,%esp
801058ee:	ff 75 f4             	pushl  -0xc(%ebp)
801058f1:	e8 e4 bf ff ff       	call   801018da <ilock>
801058f6:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801058f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058fc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105900:	66 83 f8 01          	cmp    $0x1,%ax
80105904:	75 1d                	jne    80105923 <sys_link+0x9e>
    iunlockput(ip);
80105906:	83 ec 0c             	sub    $0xc,%esp
80105909:	ff 75 f4             	pushl  -0xc(%ebp)
8010590c:	e8 80 c2 ff ff       	call   80101b91 <iunlockput>
80105911:	83 c4 10             	add    $0x10,%esp
    end_op();
80105914:	e8 23 dc ff ff       	call   8010353c <end_op>
    return -1;
80105919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591e:	e9 05 01 00 00       	jmp    80105a28 <sys_link+0x1a3>
  }

  ip->nlink++;
80105923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105926:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010592a:	83 c0 01             	add    $0x1,%eax
8010592d:	89 c2                	mov    %eax,%edx
8010592f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105932:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105936:	83 ec 0c             	sub    $0xc,%esp
80105939:	ff 75 f4             	pushl  -0xc(%ebp)
8010593c:	e8 c6 bd ff ff       	call   80101707 <iupdate>
80105941:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105944:	83 ec 0c             	sub    $0xc,%esp
80105947:	ff 75 f4             	pushl  -0xc(%ebp)
8010594a:	e8 e2 c0 ff ff       	call   80101a31 <iunlock>
8010594f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105952:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105955:	83 ec 08             	sub    $0x8,%esp
80105958:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010595b:	52                   	push   %edx
8010595c:	50                   	push   %eax
8010595d:	e8 57 cb ff ff       	call   801024b9 <nameiparent>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105968:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010596c:	75 02                	jne    80105970 <sys_link+0xeb>
    goto bad;
8010596e:	eb 71                	jmp    801059e1 <sys_link+0x15c>
  ilock(dp);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	ff 75 f0             	pushl  -0x10(%ebp)
80105976:	e8 5f bf ff ff       	call   801018da <ilock>
8010597b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010597e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105981:	8b 10                	mov    (%eax),%edx
80105983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105986:	8b 00                	mov    (%eax),%eax
80105988:	39 c2                	cmp    %eax,%edx
8010598a:	75 1d                	jne    801059a9 <sys_link+0x124>
8010598c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598f:	8b 40 04             	mov    0x4(%eax),%eax
80105992:	83 ec 04             	sub    $0x4,%esp
80105995:	50                   	push   %eax
80105996:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105999:	50                   	push   %eax
8010599a:	ff 75 f0             	pushl  -0x10(%ebp)
8010599d:	e8 63 c8 ff ff       	call   80102205 <dirlink>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	79 10                	jns    801059b9 <sys_link+0x134>
    iunlockput(dp);
801059a9:	83 ec 0c             	sub    $0xc,%esp
801059ac:	ff 75 f0             	pushl  -0x10(%ebp)
801059af:	e8 dd c1 ff ff       	call   80101b91 <iunlockput>
801059b4:	83 c4 10             	add    $0x10,%esp
    goto bad;
801059b7:	eb 28                	jmp    801059e1 <sys_link+0x15c>
  }
  iunlockput(dp);
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	ff 75 f0             	pushl  -0x10(%ebp)
801059bf:	e8 cd c1 ff ff       	call   80101b91 <iunlockput>
801059c4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801059c7:	83 ec 0c             	sub    $0xc,%esp
801059ca:	ff 75 f4             	pushl  -0xc(%ebp)
801059cd:	e8 d0 c0 ff ff       	call   80101aa2 <iput>
801059d2:	83 c4 10             	add    $0x10,%esp

  end_op();
801059d5:	e8 62 db ff ff       	call   8010353c <end_op>

  return 0;
801059da:	b8 00 00 00 00       	mov    $0x0,%eax
801059df:	eb 47                	jmp    80105a28 <sys_link+0x1a3>

bad:
  ilock(ip);
801059e1:	83 ec 0c             	sub    $0xc,%esp
801059e4:	ff 75 f4             	pushl  -0xc(%ebp)
801059e7:	e8 ee be ff ff       	call   801018da <ilock>
801059ec:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801059ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059f6:	83 e8 01             	sub    $0x1,%eax
801059f9:	89 c2                	mov    %eax,%edx
801059fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fe:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a02:	83 ec 0c             	sub    $0xc,%esp
80105a05:	ff 75 f4             	pushl  -0xc(%ebp)
80105a08:	e8 fa bc ff ff       	call   80101707 <iupdate>
80105a0d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	ff 75 f4             	pushl  -0xc(%ebp)
80105a16:	e8 76 c1 ff ff       	call   80101b91 <iunlockput>
80105a1b:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a1e:	e8 19 db ff ff       	call   8010353c <end_op>
  return -1;
80105a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a28:	c9                   	leave  
80105a29:	c3                   	ret    

80105a2a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a2a:	55                   	push   %ebp
80105a2b:	89 e5                	mov    %esp,%ebp
80105a2d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a30:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a37:	eb 40                	jmp    80105a79 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3c:	6a 10                	push   $0x10
80105a3e:	50                   	push   %eax
80105a3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a42:	50                   	push   %eax
80105a43:	ff 75 08             	pushl  0x8(%ebp)
80105a46:	e8 f1 c3 ff ff       	call   80101e3c <readi>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	83 f8 10             	cmp    $0x10,%eax
80105a51:	74 0d                	je     80105a60 <isdirempty+0x36>
      panic("isdirempty: readi");
80105a53:	83 ec 0c             	sub    $0xc,%esp
80105a56:	68 4f 88 10 80       	push   $0x8010884f
80105a5b:	e8 fc aa ff ff       	call   8010055c <panic>
    if(de.inum != 0)
80105a60:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105a64:	66 85 c0             	test   %ax,%ax
80105a67:	74 07                	je     80105a70 <isdirempty+0x46>
      return 0;
80105a69:	b8 00 00 00 00       	mov    $0x0,%eax
80105a6e:	eb 1b                	jmp    80105a8b <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a73:	83 c0 10             	add    $0x10,%eax
80105a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80105a7f:	8b 40 18             	mov    0x18(%eax),%eax
80105a82:	39 c2                	cmp    %eax,%edx
80105a84:	72 b3                	jb     80105a39 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105a86:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105a8b:	c9                   	leave  
80105a8c:	c3                   	ret    

80105a8d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105a8d:	55                   	push   %ebp
80105a8e:	89 e5                	mov    %esp,%ebp
80105a90:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105a93:	83 ec 08             	sub    $0x8,%esp
80105a96:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105a99:	50                   	push   %eax
80105a9a:	6a 00                	push   $0x0
80105a9c:	e8 a0 fa ff ff       	call   80105541 <argstr>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	79 0a                	jns    80105ab2 <sys_unlink+0x25>
    return -1;
80105aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aad:	e9 bc 01 00 00       	jmp    80105c6e <sys_unlink+0x1e1>

  begin_op();
80105ab2:	e8 f7 d9 ff ff       	call   801034ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ab7:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105aba:	83 ec 08             	sub    $0x8,%esp
80105abd:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105ac0:	52                   	push   %edx
80105ac1:	50                   	push   %eax
80105ac2:	e8 f2 c9 ff ff       	call   801024b9 <nameiparent>
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ad1:	75 0f                	jne    80105ae2 <sys_unlink+0x55>
    end_op();
80105ad3:	e8 64 da ff ff       	call   8010353c <end_op>
    return -1;
80105ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105add:	e9 8c 01 00 00       	jmp    80105c6e <sys_unlink+0x1e1>
  }

  ilock(dp);
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	ff 75 f4             	pushl  -0xc(%ebp)
80105ae8:	e8 ed bd ff ff       	call   801018da <ilock>
80105aed:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	68 61 88 10 80       	push   $0x80108861
80105af8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105afb:	50                   	push   %eax
80105afc:	e8 2e c6 ff ff       	call   8010212f <namecmp>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	85 c0                	test   %eax,%eax
80105b06:	0f 84 4a 01 00 00    	je     80105c56 <sys_unlink+0x1c9>
80105b0c:	83 ec 08             	sub    $0x8,%esp
80105b0f:	68 63 88 10 80       	push   $0x80108863
80105b14:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b17:	50                   	push   %eax
80105b18:	e8 12 c6 ff ff       	call   8010212f <namecmp>
80105b1d:	83 c4 10             	add    $0x10,%esp
80105b20:	85 c0                	test   %eax,%eax
80105b22:	0f 84 2e 01 00 00    	je     80105c56 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b28:	83 ec 04             	sub    $0x4,%esp
80105b2b:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b2e:	50                   	push   %eax
80105b2f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b32:	50                   	push   %eax
80105b33:	ff 75 f4             	pushl  -0xc(%ebp)
80105b36:	e8 0f c6 ff ff       	call   8010214a <dirlookup>
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b45:	75 05                	jne    80105b4c <sys_unlink+0xbf>
    goto bad;
80105b47:	e9 0a 01 00 00       	jmp    80105c56 <sys_unlink+0x1c9>
  ilock(ip);
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	ff 75 f0             	pushl  -0x10(%ebp)
80105b52:	e8 83 bd ff ff       	call   801018da <ilock>
80105b57:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b61:	66 85 c0             	test   %ax,%ax
80105b64:	7f 0d                	jg     80105b73 <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
80105b66:	83 ec 0c             	sub    $0xc,%esp
80105b69:	68 66 88 10 80       	push   $0x80108866
80105b6e:	e8 e9 a9 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b76:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b7a:	66 83 f8 01          	cmp    $0x1,%ax
80105b7e:	75 25                	jne    80105ba5 <sys_unlink+0x118>
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	ff 75 f0             	pushl  -0x10(%ebp)
80105b86:	e8 9f fe ff ff       	call   80105a2a <isdirempty>
80105b8b:	83 c4 10             	add    $0x10,%esp
80105b8e:	85 c0                	test   %eax,%eax
80105b90:	75 13                	jne    80105ba5 <sys_unlink+0x118>
    iunlockput(ip);
80105b92:	83 ec 0c             	sub    $0xc,%esp
80105b95:	ff 75 f0             	pushl  -0x10(%ebp)
80105b98:	e8 f4 bf ff ff       	call   80101b91 <iunlockput>
80105b9d:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105ba0:	e9 b1 00 00 00       	jmp    80105c56 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105ba5:	83 ec 04             	sub    $0x4,%esp
80105ba8:	6a 10                	push   $0x10
80105baa:	6a 00                	push   $0x0
80105bac:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105baf:	50                   	push   %eax
80105bb0:	e8 de f5 ff ff       	call   80105193 <memset>
80105bb5:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bb8:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105bbb:	6a 10                	push   $0x10
80105bbd:	50                   	push   %eax
80105bbe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bc1:	50                   	push   %eax
80105bc2:	ff 75 f4             	pushl  -0xc(%ebp)
80105bc5:	e8 d3 c3 ff ff       	call   80101f9d <writei>
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	83 f8 10             	cmp    $0x10,%eax
80105bd0:	74 0d                	je     80105bdf <sys_unlink+0x152>
    panic("unlink: writei");
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	68 78 88 10 80       	push   $0x80108878
80105bda:	e8 7d a9 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR){
80105bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105be6:	66 83 f8 01          	cmp    $0x1,%ax
80105bea:	75 21                	jne    80105c0d <sys_unlink+0x180>
    dp->nlink--;
80105bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bef:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bf3:	83 e8 01             	sub    $0x1,%eax
80105bf6:	89 c2                	mov    %eax,%edx
80105bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfb:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105bff:	83 ec 0c             	sub    $0xc,%esp
80105c02:	ff 75 f4             	pushl  -0xc(%ebp)
80105c05:	e8 fd ba ff ff       	call   80101707 <iupdate>
80105c0a:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	ff 75 f4             	pushl  -0xc(%ebp)
80105c13:	e8 79 bf ff ff       	call   80101b91 <iunlockput>
80105c18:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c22:	83 e8 01             	sub    $0x1,%eax
80105c25:	89 c2                	mov    %eax,%edx
80105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c2e:	83 ec 0c             	sub    $0xc,%esp
80105c31:	ff 75 f0             	pushl  -0x10(%ebp)
80105c34:	e8 ce ba ff ff       	call   80101707 <iupdate>
80105c39:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c3c:	83 ec 0c             	sub    $0xc,%esp
80105c3f:	ff 75 f0             	pushl  -0x10(%ebp)
80105c42:	e8 4a bf ff ff       	call   80101b91 <iunlockput>
80105c47:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c4a:	e8 ed d8 ff ff       	call   8010353c <end_op>

  return 0;
80105c4f:	b8 00 00 00 00       	mov    $0x0,%eax
80105c54:	eb 18                	jmp    80105c6e <sys_unlink+0x1e1>

bad:
  iunlockput(dp);
80105c56:	83 ec 0c             	sub    $0xc,%esp
80105c59:	ff 75 f4             	pushl  -0xc(%ebp)
80105c5c:	e8 30 bf ff ff       	call   80101b91 <iunlockput>
80105c61:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c64:	e8 d3 d8 ff ff       	call   8010353c <end_op>
  return -1;
80105c69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c6e:	c9                   	leave  
80105c6f:	c3                   	ret    

80105c70 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	83 ec 38             	sub    $0x38,%esp
80105c76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c79:	8b 55 10             	mov    0x10(%ebp),%edx
80105c7c:	8b 45 14             	mov    0x14(%ebp),%eax
80105c7f:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105c83:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105c87:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c8b:	83 ec 08             	sub    $0x8,%esp
80105c8e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c91:	50                   	push   %eax
80105c92:	ff 75 08             	pushl  0x8(%ebp)
80105c95:	e8 1f c8 ff ff       	call   801024b9 <nameiparent>
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ca4:	75 0a                	jne    80105cb0 <create+0x40>
    return 0;
80105ca6:	b8 00 00 00 00       	mov    $0x0,%eax
80105cab:	e9 90 01 00 00       	jmp    80105e40 <create+0x1d0>
  ilock(dp);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb6:	e8 1f bc ff ff       	call   801018da <ilock>
80105cbb:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105cbe:	83 ec 04             	sub    $0x4,%esp
80105cc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cc4:	50                   	push   %eax
80105cc5:	8d 45 de             	lea    -0x22(%ebp),%eax
80105cc8:	50                   	push   %eax
80105cc9:	ff 75 f4             	pushl  -0xc(%ebp)
80105ccc:	e8 79 c4 ff ff       	call   8010214a <dirlookup>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cdb:	74 50                	je     80105d2d <create+0xbd>
    iunlockput(dp);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ce3:	e8 a9 be ff ff       	call   80101b91 <iunlockput>
80105ce8:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105ceb:	83 ec 0c             	sub    $0xc,%esp
80105cee:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf1:	e8 e4 bb ff ff       	call   801018da <ilock>
80105cf6:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105cf9:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105cfe:	75 15                	jne    80105d15 <create+0xa5>
80105d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d03:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d07:	66 83 f8 02          	cmp    $0x2,%ax
80105d0b:	75 08                	jne    80105d15 <create+0xa5>
      return ip;
80105d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d10:	e9 2b 01 00 00       	jmp    80105e40 <create+0x1d0>
    iunlockput(ip);
80105d15:	83 ec 0c             	sub    $0xc,%esp
80105d18:	ff 75 f0             	pushl  -0x10(%ebp)
80105d1b:	e8 71 be ff ff       	call   80101b91 <iunlockput>
80105d20:	83 c4 10             	add    $0x10,%esp
    return 0;
80105d23:	b8 00 00 00 00       	mov    $0x0,%eax
80105d28:	e9 13 01 00 00       	jmp    80105e40 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d2d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d34:	8b 00                	mov    (%eax),%eax
80105d36:	83 ec 08             	sub    $0x8,%esp
80105d39:	52                   	push   %edx
80105d3a:	50                   	push   %eax
80105d3b:	e8 e6 b8 ff ff       	call   80101626 <ialloc>
80105d40:	83 c4 10             	add    $0x10,%esp
80105d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d4a:	75 0d                	jne    80105d59 <create+0xe9>
    panic("create: ialloc");
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	68 87 88 10 80       	push   $0x80108887
80105d54:	e8 03 a8 ff ff       	call   8010055c <panic>

  ilock(ip);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	ff 75 f0             	pushl  -0x10(%ebp)
80105d5f:	e8 76 bb ff ff       	call   801018da <ilock>
80105d64:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d6a:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105d6e:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d75:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105d79:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d80:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105d86:	83 ec 0c             	sub    $0xc,%esp
80105d89:	ff 75 f0             	pushl  -0x10(%ebp)
80105d8c:	e8 76 b9 ff ff       	call   80101707 <iupdate>
80105d91:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105d94:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d99:	75 6a                	jne    80105e05 <create+0x195>
    dp->nlink++;  // for ".."
80105d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105da2:	83 c0 01             	add    $0x1,%eax
80105da5:	89 c2                	mov    %eax,%edx
80105da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105daa:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105dae:	83 ec 0c             	sub    $0xc,%esp
80105db1:	ff 75 f4             	pushl  -0xc(%ebp)
80105db4:	e8 4e b9 ff ff       	call   80101707 <iupdate>
80105db9:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbf:	8b 40 04             	mov    0x4(%eax),%eax
80105dc2:	83 ec 04             	sub    $0x4,%esp
80105dc5:	50                   	push   %eax
80105dc6:	68 61 88 10 80       	push   $0x80108861
80105dcb:	ff 75 f0             	pushl  -0x10(%ebp)
80105dce:	e8 32 c4 ff ff       	call   80102205 <dirlink>
80105dd3:	83 c4 10             	add    $0x10,%esp
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	78 1e                	js     80105df8 <create+0x188>
80105dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddd:	8b 40 04             	mov    0x4(%eax),%eax
80105de0:	83 ec 04             	sub    $0x4,%esp
80105de3:	50                   	push   %eax
80105de4:	68 63 88 10 80       	push   $0x80108863
80105de9:	ff 75 f0             	pushl  -0x10(%ebp)
80105dec:	e8 14 c4 ff ff       	call   80102205 <dirlink>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	79 0d                	jns    80105e05 <create+0x195>
      panic("create dots");
80105df8:	83 ec 0c             	sub    $0xc,%esp
80105dfb:	68 96 88 10 80       	push   $0x80108896
80105e00:	e8 57 a7 ff ff       	call   8010055c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e08:	8b 40 04             	mov    0x4(%eax),%eax
80105e0b:	83 ec 04             	sub    $0x4,%esp
80105e0e:	50                   	push   %eax
80105e0f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e12:	50                   	push   %eax
80105e13:	ff 75 f4             	pushl  -0xc(%ebp)
80105e16:	e8 ea c3 ff ff       	call   80102205 <dirlink>
80105e1b:	83 c4 10             	add    $0x10,%esp
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	79 0d                	jns    80105e2f <create+0x1bf>
    panic("create: dirlink");
80105e22:	83 ec 0c             	sub    $0xc,%esp
80105e25:	68 a2 88 10 80       	push   $0x801088a2
80105e2a:	e8 2d a7 ff ff       	call   8010055c <panic>

  iunlockput(dp);
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	ff 75 f4             	pushl  -0xc(%ebp)
80105e35:	e8 57 bd ff ff       	call   80101b91 <iunlockput>
80105e3a:	83 c4 10             	add    $0x10,%esp

  return ip;
80105e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e40:	c9                   	leave  
80105e41:	c3                   	ret    

80105e42 <sys_open>:

int
sys_open(void)
{
80105e42:	55                   	push   %ebp
80105e43:	89 e5                	mov    %esp,%ebp
80105e45:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e48:	83 ec 08             	sub    $0x8,%esp
80105e4b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e4e:	50                   	push   %eax
80105e4f:	6a 00                	push   $0x0
80105e51:	e8 eb f6 ff ff       	call   80105541 <argstr>
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	78 15                	js     80105e72 <sys_open+0x30>
80105e5d:	83 ec 08             	sub    $0x8,%esp
80105e60:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e63:	50                   	push   %eax
80105e64:	6a 01                	push   $0x1
80105e66:	e8 4f f6 ff ff       	call   801054ba <argint>
80105e6b:	83 c4 10             	add    $0x10,%esp
80105e6e:	85 c0                	test   %eax,%eax
80105e70:	79 0a                	jns    80105e7c <sys_open+0x3a>
    return -1;
80105e72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e77:	e9 61 01 00 00       	jmp    80105fdd <sys_open+0x19b>

  begin_op();
80105e7c:	e8 2d d6 ff ff       	call   801034ae <begin_op>

  if(omode & O_CREATE){
80105e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e84:	25 00 02 00 00       	and    $0x200,%eax
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	74 2a                	je     80105eb7 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e90:	6a 00                	push   $0x0
80105e92:	6a 00                	push   $0x0
80105e94:	6a 02                	push   $0x2
80105e96:	50                   	push   %eax
80105e97:	e8 d4 fd ff ff       	call   80105c70 <create>
80105e9c:	83 c4 10             	add    $0x10,%esp
80105e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ea6:	75 75                	jne    80105f1d <sys_open+0xdb>
      end_op();
80105ea8:	e8 8f d6 ff ff       	call   8010353c <end_op>
      return -1;
80105ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb2:	e9 26 01 00 00       	jmp    80105fdd <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105eba:	83 ec 0c             	sub    $0xc,%esp
80105ebd:	50                   	push   %eax
80105ebe:	e8 da c5 ff ff       	call   8010249d <namei>
80105ec3:	83 c4 10             	add    $0x10,%esp
80105ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ecd:	75 0f                	jne    80105ede <sys_open+0x9c>
      end_op();
80105ecf:	e8 68 d6 ff ff       	call   8010353c <end_op>
      return -1;
80105ed4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed9:	e9 ff 00 00 00       	jmp    80105fdd <sys_open+0x19b>
    }
    ilock(ip);
80105ede:	83 ec 0c             	sub    $0xc,%esp
80105ee1:	ff 75 f4             	pushl  -0xc(%ebp)
80105ee4:	e8 f1 b9 ff ff       	call   801018da <ilock>
80105ee9:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eef:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ef3:	66 83 f8 01          	cmp    $0x1,%ax
80105ef7:	75 24                	jne    80105f1d <sys_open+0xdb>
80105ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105efc:	85 c0                	test   %eax,%eax
80105efe:	74 1d                	je     80105f1d <sys_open+0xdb>
      iunlockput(ip);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	ff 75 f4             	pushl  -0xc(%ebp)
80105f06:	e8 86 bc ff ff       	call   80101b91 <iunlockput>
80105f0b:	83 c4 10             	add    $0x10,%esp
      end_op();
80105f0e:	e8 29 d6 ff ff       	call   8010353c <end_op>
      return -1;
80105f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f18:	e9 c0 00 00 00       	jmp    80105fdd <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f1d:	e8 39 b0 ff ff       	call   80100f5b <filealloc>
80105f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f29:	74 17                	je     80105f42 <sys_open+0x100>
80105f2b:	83 ec 0c             	sub    $0xc,%esp
80105f2e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f31:	e8 36 f7 ff ff       	call   8010566c <fdalloc>
80105f36:	83 c4 10             	add    $0x10,%esp
80105f39:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f40:	79 2e                	jns    80105f70 <sys_open+0x12e>
    if(f)
80105f42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f46:	74 0e                	je     80105f56 <sys_open+0x114>
      fileclose(f);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4e:	e8 c5 b0 ff ff       	call   80101018 <fileclose>
80105f53:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105f56:	83 ec 0c             	sub    $0xc,%esp
80105f59:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5c:	e8 30 bc ff ff       	call   80101b91 <iunlockput>
80105f61:	83 c4 10             	add    $0x10,%esp
    end_op();
80105f64:	e8 d3 d5 ff ff       	call   8010353c <end_op>
    return -1;
80105f69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6e:	eb 6d                	jmp    80105fdd <sys_open+0x19b>
  }
  iunlock(ip);
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	ff 75 f4             	pushl  -0xc(%ebp)
80105f76:	e8 b6 ba ff ff       	call   80101a31 <iunlock>
80105f7b:	83 c4 10             	add    $0x10,%esp
  end_op();
80105f7e:	e8 b9 d5 ff ff       	call   8010353c <end_op>

  f->type = FD_INODE;
80105f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f86:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f92:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f98:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fa2:	83 e0 01             	and    $0x1,%eax
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	0f 94 c0             	sete   %al
80105faa:	89 c2                	mov    %eax,%edx
80105fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105faf:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fb5:	83 e0 01             	and    $0x1,%eax
80105fb8:	85 c0                	test   %eax,%eax
80105fba:	75 0a                	jne    80105fc6 <sys_open+0x184>
80105fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fbf:	83 e0 02             	and    $0x2,%eax
80105fc2:	85 c0                	test   %eax,%eax
80105fc4:	74 07                	je     80105fcd <sys_open+0x18b>
80105fc6:	b8 01 00 00 00       	mov    $0x1,%eax
80105fcb:	eb 05                	jmp    80105fd2 <sys_open+0x190>
80105fcd:	b8 00 00 00 00       	mov    $0x0,%eax
80105fd2:	89 c2                	mov    %eax,%edx
80105fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd7:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105fdd:	c9                   	leave  
80105fde:	c3                   	ret    

80105fdf <sys_mkdir>:

int
sys_mkdir(void)
{
80105fdf:	55                   	push   %ebp
80105fe0:	89 e5                	mov    %esp,%ebp
80105fe2:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105fe5:	e8 c4 d4 ff ff       	call   801034ae <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105fea:	83 ec 08             	sub    $0x8,%esp
80105fed:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ff0:	50                   	push   %eax
80105ff1:	6a 00                	push   $0x0
80105ff3:	e8 49 f5 ff ff       	call   80105541 <argstr>
80105ff8:	83 c4 10             	add    $0x10,%esp
80105ffb:	85 c0                	test   %eax,%eax
80105ffd:	78 1b                	js     8010601a <sys_mkdir+0x3b>
80105fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106002:	6a 00                	push   $0x0
80106004:	6a 00                	push   $0x0
80106006:	6a 01                	push   $0x1
80106008:	50                   	push   %eax
80106009:	e8 62 fc ff ff       	call   80105c70 <create>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106018:	75 0c                	jne    80106026 <sys_mkdir+0x47>
    end_op();
8010601a:	e8 1d d5 ff ff       	call   8010353c <end_op>
    return -1;
8010601f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106024:	eb 18                	jmp    8010603e <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106026:	83 ec 0c             	sub    $0xc,%esp
80106029:	ff 75 f4             	pushl  -0xc(%ebp)
8010602c:	e8 60 bb ff ff       	call   80101b91 <iunlockput>
80106031:	83 c4 10             	add    $0x10,%esp
  end_op();
80106034:	e8 03 d5 ff ff       	call   8010353c <end_op>
  return 0;
80106039:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010603e:	c9                   	leave  
8010603f:	c3                   	ret    

80106040 <sys_mknod>:

int
sys_mknod(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106046:	e8 63 d4 ff ff       	call   801034ae <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010604b:	83 ec 08             	sub    $0x8,%esp
8010604e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106051:	50                   	push   %eax
80106052:	6a 00                	push   $0x0
80106054:	e8 e8 f4 ff ff       	call   80105541 <argstr>
80106059:	83 c4 10             	add    $0x10,%esp
8010605c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010605f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106063:	78 4f                	js     801060b4 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106065:	83 ec 08             	sub    $0x8,%esp
80106068:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010606b:	50                   	push   %eax
8010606c:	6a 01                	push   $0x1
8010606e:	e8 47 f4 ff ff       	call   801054ba <argint>
80106073:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106076:	85 c0                	test   %eax,%eax
80106078:	78 3a                	js     801060b4 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010607a:	83 ec 08             	sub    $0x8,%esp
8010607d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106080:	50                   	push   %eax
80106081:	6a 02                	push   $0x2
80106083:	e8 32 f4 ff ff       	call   801054ba <argint>
80106088:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010608b:	85 c0                	test   %eax,%eax
8010608d:	78 25                	js     801060b4 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010608f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106092:	0f bf c8             	movswl %ax,%ecx
80106095:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106098:	0f bf d0             	movswl %ax,%edx
8010609b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010609e:	51                   	push   %ecx
8010609f:	52                   	push   %edx
801060a0:	6a 03                	push   $0x3
801060a2:	50                   	push   %eax
801060a3:	e8 c8 fb ff ff       	call   80105c70 <create>
801060a8:	83 c4 10             	add    $0x10,%esp
801060ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060b2:	75 0c                	jne    801060c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801060b4:	e8 83 d4 ff ff       	call   8010353c <end_op>
    return -1;
801060b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060be:	eb 18                	jmp    801060d8 <sys_mknod+0x98>
  }
  iunlockput(ip);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	ff 75 f0             	pushl  -0x10(%ebp)
801060c6:	e8 c6 ba ff ff       	call   80101b91 <iunlockput>
801060cb:	83 c4 10             	add    $0x10,%esp
  end_op();
801060ce:	e8 69 d4 ff ff       	call   8010353c <end_op>
  return 0;
801060d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060d8:	c9                   	leave  
801060d9:	c3                   	ret    

801060da <sys_chdir>:

int
sys_chdir(void)
{
801060da:	55                   	push   %ebp
801060db:	89 e5                	mov    %esp,%ebp
801060dd:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801060e0:	e8 c9 d3 ff ff       	call   801034ae <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801060e5:	83 ec 08             	sub    $0x8,%esp
801060e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060eb:	50                   	push   %eax
801060ec:	6a 00                	push   $0x0
801060ee:	e8 4e f4 ff ff       	call   80105541 <argstr>
801060f3:	83 c4 10             	add    $0x10,%esp
801060f6:	85 c0                	test   %eax,%eax
801060f8:	78 18                	js     80106112 <sys_chdir+0x38>
801060fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060fd:	83 ec 0c             	sub    $0xc,%esp
80106100:	50                   	push   %eax
80106101:	e8 97 c3 ff ff       	call   8010249d <namei>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010610c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106110:	75 0c                	jne    8010611e <sys_chdir+0x44>
    end_op();
80106112:	e8 25 d4 ff ff       	call   8010353c <end_op>
    return -1;
80106117:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611c:	eb 6e                	jmp    8010618c <sys_chdir+0xb2>
  }
  ilock(ip);
8010611e:	83 ec 0c             	sub    $0xc,%esp
80106121:	ff 75 f4             	pushl  -0xc(%ebp)
80106124:	e8 b1 b7 ff ff       	call   801018da <ilock>
80106129:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010612c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106133:	66 83 f8 01          	cmp    $0x1,%ax
80106137:	74 1a                	je     80106153 <sys_chdir+0x79>
    iunlockput(ip);
80106139:	83 ec 0c             	sub    $0xc,%esp
8010613c:	ff 75 f4             	pushl  -0xc(%ebp)
8010613f:	e8 4d ba ff ff       	call   80101b91 <iunlockput>
80106144:	83 c4 10             	add    $0x10,%esp
    end_op();
80106147:	e8 f0 d3 ff ff       	call   8010353c <end_op>
    return -1;
8010614c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106151:	eb 39                	jmp    8010618c <sys_chdir+0xb2>
  }
  iunlock(ip);
80106153:	83 ec 0c             	sub    $0xc,%esp
80106156:	ff 75 f4             	pushl  -0xc(%ebp)
80106159:	e8 d3 b8 ff ff       	call   80101a31 <iunlock>
8010615e:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106161:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106167:	8b 40 68             	mov    0x68(%eax),%eax
8010616a:	83 ec 0c             	sub    $0xc,%esp
8010616d:	50                   	push   %eax
8010616e:	e8 2f b9 ff ff       	call   80101aa2 <iput>
80106173:	83 c4 10             	add    $0x10,%esp
  end_op();
80106176:	e8 c1 d3 ff ff       	call   8010353c <end_op>
  proc->cwd = ip;
8010617b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106181:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106184:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106187:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010618c:	c9                   	leave  
8010618d:	c3                   	ret    

8010618e <sys_exec>:

int
sys_exec(void)
{
8010618e:	55                   	push   %ebp
8010618f:	89 e5                	mov    %esp,%ebp
80106191:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106197:	83 ec 08             	sub    $0x8,%esp
8010619a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010619d:	50                   	push   %eax
8010619e:	6a 00                	push   $0x0
801061a0:	e8 9c f3 ff ff       	call   80105541 <argstr>
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	85 c0                	test   %eax,%eax
801061aa:	78 18                	js     801061c4 <sys_exec+0x36>
801061ac:	83 ec 08             	sub    $0x8,%esp
801061af:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801061b5:	50                   	push   %eax
801061b6:	6a 01                	push   $0x1
801061b8:	e8 fd f2 ff ff       	call   801054ba <argint>
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	85 c0                	test   %eax,%eax
801061c2:	79 0a                	jns    801061ce <sys_exec+0x40>
    return -1;
801061c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c9:	e9 c6 00 00 00       	jmp    80106294 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801061ce:	83 ec 04             	sub    $0x4,%esp
801061d1:	68 80 00 00 00       	push   $0x80
801061d6:	6a 00                	push   $0x0
801061d8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801061de:	50                   	push   %eax
801061df:	e8 af ef ff ff       	call   80105193 <memset>
801061e4:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801061e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801061ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f1:	83 f8 1f             	cmp    $0x1f,%eax
801061f4:	76 0a                	jbe    80106200 <sys_exec+0x72>
      return -1;
801061f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fb:	e9 94 00 00 00       	jmp    80106294 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106200:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106203:	c1 e0 02             	shl    $0x2,%eax
80106206:	89 c2                	mov    %eax,%edx
80106208:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010620e:	01 c2                	add    %eax,%edx
80106210:	83 ec 08             	sub    $0x8,%esp
80106213:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106219:	50                   	push   %eax
8010621a:	52                   	push   %edx
8010621b:	e8 fe f1 ff ff       	call   8010541e <fetchint>
80106220:	83 c4 10             	add    $0x10,%esp
80106223:	85 c0                	test   %eax,%eax
80106225:	79 07                	jns    8010622e <sys_exec+0xa0>
      return -1;
80106227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622c:	eb 66                	jmp    80106294 <sys_exec+0x106>
    if(uarg == 0){
8010622e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106234:	85 c0                	test   %eax,%eax
80106236:	75 27                	jne    8010625f <sys_exec+0xd1>
      argv[i] = 0;
80106238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010623b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106242:	00 00 00 00 
      break;
80106246:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106247:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624a:	83 ec 08             	sub    $0x8,%esp
8010624d:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106253:	52                   	push   %edx
80106254:	50                   	push   %eax
80106255:	e8 f5 a8 ff ff       	call   80100b4f <exec>
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	eb 35                	jmp    80106294 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010625f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106265:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106268:	c1 e2 02             	shl    $0x2,%edx
8010626b:	01 c2                	add    %eax,%edx
8010626d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106273:	83 ec 08             	sub    $0x8,%esp
80106276:	52                   	push   %edx
80106277:	50                   	push   %eax
80106278:	e8 db f1 ff ff       	call   80105458 <fetchstr>
8010627d:	83 c4 10             	add    $0x10,%esp
80106280:	85 c0                	test   %eax,%eax
80106282:	79 07                	jns    8010628b <sys_exec+0xfd>
      return -1;
80106284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106289:	eb 09                	jmp    80106294 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010628b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010628f:	e9 5a ff ff ff       	jmp    801061ee <sys_exec+0x60>
  return exec(path, argv);
}
80106294:	c9                   	leave  
80106295:	c3                   	ret    

80106296 <sys_pipe>:

int
sys_pipe(void)
{
80106296:	55                   	push   %ebp
80106297:	89 e5                	mov    %esp,%ebp
80106299:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010629c:	83 ec 04             	sub    $0x4,%esp
8010629f:	6a 08                	push   $0x8
801062a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062a4:	50                   	push   %eax
801062a5:	6a 00                	push   $0x0
801062a7:	e8 36 f2 ff ff       	call   801054e2 <argptr>
801062ac:	83 c4 10             	add    $0x10,%esp
801062af:	85 c0                	test   %eax,%eax
801062b1:	79 0a                	jns    801062bd <sys_pipe+0x27>
    return -1;
801062b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b8:	e9 af 00 00 00       	jmp    8010636c <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801062bd:	83 ec 08             	sub    $0x8,%esp
801062c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062c3:	50                   	push   %eax
801062c4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062c7:	50                   	push   %eax
801062c8:	e8 ce dc ff ff       	call   80103f9b <pipealloc>
801062cd:	83 c4 10             	add    $0x10,%esp
801062d0:	85 c0                	test   %eax,%eax
801062d2:	79 0a                	jns    801062de <sys_pipe+0x48>
    return -1;
801062d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d9:	e9 8e 00 00 00       	jmp    8010636c <sys_pipe+0xd6>
  fd0 = -1;
801062de:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	50                   	push   %eax
801062ec:	e8 7b f3 ff ff       	call   8010566c <fdalloc>
801062f1:	83 c4 10             	add    $0x10,%esp
801062f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062fb:	78 18                	js     80106315 <sys_pipe+0x7f>
801062fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106300:	83 ec 0c             	sub    $0xc,%esp
80106303:	50                   	push   %eax
80106304:	e8 63 f3 ff ff       	call   8010566c <fdalloc>
80106309:	83 c4 10             	add    $0x10,%esp
8010630c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010630f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106313:	79 3f                	jns    80106354 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106319:	78 14                	js     8010632f <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010631b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106321:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106324:	83 c2 08             	add    $0x8,%edx
80106327:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010632e:	00 
    fileclose(rf);
8010632f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106332:	83 ec 0c             	sub    $0xc,%esp
80106335:	50                   	push   %eax
80106336:	e8 dd ac ff ff       	call   80101018 <fileclose>
8010633b:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010633e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106341:	83 ec 0c             	sub    $0xc,%esp
80106344:	50                   	push   %eax
80106345:	e8 ce ac ff ff       	call   80101018 <fileclose>
8010634a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010634d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106352:	eb 18                	jmp    8010636c <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106354:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106357:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010635a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010635c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010635f:	8d 50 04             	lea    0x4(%eax),%edx
80106362:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106365:	89 02                	mov    %eax,(%edx)
  return 0;
80106367:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010636c:	c9                   	leave  
8010636d:	c3                   	ret    

8010636e <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010636e:	55                   	push   %ebp
8010636f:	89 e5                	mov    %esp,%ebp
80106371:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106374:	e8 18 e3 ff ff       	call   80104691 <fork>
}
80106379:	c9                   	leave  
8010637a:	c3                   	ret    

8010637b <sys_exit>:

int
sys_exit(void)
{
8010637b:	55                   	push   %ebp
8010637c:	89 e5                	mov    %esp,%ebp
8010637e:	83 ec 08             	sub    $0x8,%esp
  exit();
80106381:	e8 9c e4 ff ff       	call   80104822 <exit>
  return 0;  // not reached
80106386:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010638b:	c9                   	leave  
8010638c:	c3                   	ret    

8010638d <sys_wait>:

int
sys_wait(void)
{
8010638d:	55                   	push   %ebp
8010638e:	89 e5                	mov    %esp,%ebp
80106390:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106393:	e8 c2 e5 ff ff       	call   8010495a <wait>
}
80106398:	c9                   	leave  
80106399:	c3                   	ret    

8010639a <sys_kill>:

int
sys_kill(void)
{
8010639a:	55                   	push   %ebp
8010639b:	89 e5                	mov    %esp,%ebp
8010639d:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063a0:	83 ec 08             	sub    $0x8,%esp
801063a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063a6:	50                   	push   %eax
801063a7:	6a 00                	push   $0x0
801063a9:	e8 0c f1 ff ff       	call   801054ba <argint>
801063ae:	83 c4 10             	add    $0x10,%esp
801063b1:	85 c0                	test   %eax,%eax
801063b3:	79 07                	jns    801063bc <sys_kill+0x22>
    return -1;
801063b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ba:	eb 0f                	jmp    801063cb <sys_kill+0x31>
  return kill(pid);
801063bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063bf:	83 ec 0c             	sub    $0xc,%esp
801063c2:	50                   	push   %eax
801063c3:	e8 9e e9 ff ff       	call   80104d66 <kill>
801063c8:	83 c4 10             	add    $0x10,%esp
}
801063cb:	c9                   	leave  
801063cc:	c3                   	ret    

801063cd <sys_getpid>:

int
sys_getpid(void)
{
801063cd:	55                   	push   %ebp
801063ce:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801063d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063d6:	8b 40 10             	mov    0x10(%eax),%eax
}
801063d9:	5d                   	pop    %ebp
801063da:	c3                   	ret    

801063db <sys_sbrk>:

int
sys_sbrk(void)
{
801063db:	55                   	push   %ebp
801063dc:	89 e5                	mov    %esp,%ebp
801063de:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801063e1:	83 ec 08             	sub    $0x8,%esp
801063e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063e7:	50                   	push   %eax
801063e8:	6a 00                	push   $0x0
801063ea:	e8 cb f0 ff ff       	call   801054ba <argint>
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	85 c0                	test   %eax,%eax
801063f4:	79 07                	jns    801063fd <sys_sbrk+0x22>
    return -1;
801063f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fb:	eb 28                	jmp    80106425 <sys_sbrk+0x4a>
  addr = proc->sz;
801063fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106403:	8b 00                	mov    (%eax),%eax
80106405:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106408:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010640b:	83 ec 0c             	sub    $0xc,%esp
8010640e:	50                   	push   %eax
8010640f:	e8 da e1 ff ff       	call   801045ee <growproc>
80106414:	83 c4 10             	add    $0x10,%esp
80106417:	85 c0                	test   %eax,%eax
80106419:	79 07                	jns    80106422 <sys_sbrk+0x47>
    return -1;
8010641b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106420:	eb 03                	jmp    80106425 <sys_sbrk+0x4a>
  return addr;
80106422:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    

80106427 <sys_sleep>:

int
sys_sleep(void)
{
80106427:	55                   	push   %ebp
80106428:	89 e5                	mov    %esp,%ebp
8010642a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010642d:	83 ec 08             	sub    $0x8,%esp
80106430:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106433:	50                   	push   %eax
80106434:	6a 00                	push   $0x0
80106436:	e8 7f f0 ff ff       	call   801054ba <argint>
8010643b:	83 c4 10             	add    $0x10,%esp
8010643e:	85 c0                	test   %eax,%eax
80106440:	79 07                	jns    80106449 <sys_sleep+0x22>
    return -1;
80106442:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106447:	eb 77                	jmp    801064c0 <sys_sleep+0x99>
  acquire(&tickslock);
80106449:	83 ec 0c             	sub    $0xc,%esp
8010644c:	68 80 49 11 80       	push   $0x80114980
80106451:	e8 e1 ea ff ff       	call   80104f37 <acquire>
80106456:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106459:	a1 c0 51 11 80       	mov    0x801151c0,%eax
8010645e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106461:	eb 39                	jmp    8010649c <sys_sleep+0x75>
    if(proc->killed){
80106463:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106469:	8b 40 24             	mov    0x24(%eax),%eax
8010646c:	85 c0                	test   %eax,%eax
8010646e:	74 17                	je     80106487 <sys_sleep+0x60>
      release(&tickslock);
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	68 80 49 11 80       	push   $0x80114980
80106478:	e8 20 eb ff ff       	call   80104f9d <release>
8010647d:	83 c4 10             	add    $0x10,%esp
      return -1;
80106480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106485:	eb 39                	jmp    801064c0 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106487:	83 ec 08             	sub    $0x8,%esp
8010648a:	68 80 49 11 80       	push   $0x80114980
8010648f:	68 c0 51 11 80       	push   $0x801151c0
80106494:	e8 ae e7 ff ff       	call   80104c47 <sleep>
80106499:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010649c:	a1 c0 51 11 80       	mov    0x801151c0,%eax
801064a1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801064a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064a7:	39 d0                	cmp    %edx,%eax
801064a9:	72 b8                	jb     80106463 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801064ab:	83 ec 0c             	sub    $0xc,%esp
801064ae:	68 80 49 11 80       	push   $0x80114980
801064b3:	e8 e5 ea ff ff       	call   80104f9d <release>
801064b8:	83 c4 10             	add    $0x10,%esp
  return 0;
801064bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064c0:	c9                   	leave  
801064c1:	c3                   	ret    

801064c2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064c2:	55                   	push   %ebp
801064c3:	89 e5                	mov    %esp,%ebp
801064c5:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801064c8:	83 ec 0c             	sub    $0xc,%esp
801064cb:	68 80 49 11 80       	push   $0x80114980
801064d0:	e8 62 ea ff ff       	call   80104f37 <acquire>
801064d5:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801064d8:	a1 c0 51 11 80       	mov    0x801151c0,%eax
801064dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	68 80 49 11 80       	push   $0x80114980
801064e8:	e8 b0 ea ff ff       	call   80104f9d <release>
801064ed:	83 c4 10             	add    $0x10,%esp
  return xticks;
801064f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    

801064f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801064f5:	55                   	push   %ebp
801064f6:	89 e5                	mov    %esp,%ebp
801064f8:	83 ec 08             	sub    $0x8,%esp
801064fb:	8b 55 08             	mov    0x8(%ebp),%edx
801064fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106501:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106505:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106508:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010650c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106510:	ee                   	out    %al,(%dx)
}
80106511:	c9                   	leave  
80106512:	c3                   	ret    

80106513 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106513:	55                   	push   %ebp
80106514:	89 e5                	mov    %esp,%ebp
80106516:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106519:	6a 34                	push   $0x34
8010651b:	6a 43                	push   $0x43
8010651d:	e8 d3 ff ff ff       	call   801064f5 <outb>
80106522:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106525:	68 9c 00 00 00       	push   $0x9c
8010652a:	6a 40                	push   $0x40
8010652c:	e8 c4 ff ff ff       	call   801064f5 <outb>
80106531:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106534:	6a 2e                	push   $0x2e
80106536:	6a 40                	push   $0x40
80106538:	e8 b8 ff ff ff       	call   801064f5 <outb>
8010653d:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	6a 00                	push   $0x0
80106545:	e8 3d d9 ff ff       	call   80103e87 <picenable>
8010654a:	83 c4 10             	add    $0x10,%esp
}
8010654d:	c9                   	leave  
8010654e:	c3                   	ret    

8010654f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010654f:	1e                   	push   %ds
  pushl %es
80106550:	06                   	push   %es
  pushl %fs
80106551:	0f a0                	push   %fs
  pushl %gs
80106553:	0f a8                	push   %gs
  pushal
80106555:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106556:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010655a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010655c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010655e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106562:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106564:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106566:	54                   	push   %esp
  call trap
80106567:	e8 d4 01 00 00       	call   80106740 <trap>
  addl $4, %esp
8010656c:	83 c4 04             	add    $0x4,%esp

8010656f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010656f:	61                   	popa   
  popl %gs
80106570:	0f a9                	pop    %gs
  popl %fs
80106572:	0f a1                	pop    %fs
  popl %es
80106574:	07                   	pop    %es
  popl %ds
80106575:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106576:	83 c4 08             	add    $0x8,%esp
  iret
80106579:	cf                   	iret   

8010657a <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010657a:	55                   	push   %ebp
8010657b:	89 e5                	mov    %esp,%ebp
8010657d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106580:	8b 45 0c             	mov    0xc(%ebp),%eax
80106583:	83 e8 01             	sub    $0x1,%eax
80106586:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010658a:	8b 45 08             	mov    0x8(%ebp),%eax
8010658d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106591:	8b 45 08             	mov    0x8(%ebp),%eax
80106594:	c1 e8 10             	shr    $0x10,%eax
80106597:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010659b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010659e:	0f 01 18             	lidtl  (%eax)
}
801065a1:	c9                   	leave  
801065a2:	c3                   	ret    

801065a3 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801065a3:	55                   	push   %ebp
801065a4:	89 e5                	mov    %esp,%ebp
801065a6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801065a9:	0f 20 d0             	mov    %cr2,%eax
801065ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801065af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065b2:	c9                   	leave  
801065b3:	c3                   	ret    

801065b4 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065b4:	55                   	push   %ebp
801065b5:	89 e5                	mov    %esp,%ebp
801065b7:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801065ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065c1:	e9 c3 00 00 00       	jmp    80106689 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c9:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801065d0:	89 c2                	mov    %eax,%edx
801065d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d5:	66 89 14 c5 c0 49 11 	mov    %dx,-0x7feeb640(,%eax,8)
801065dc:	80 
801065dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e0:	66 c7 04 c5 c2 49 11 	movw   $0x8,-0x7feeb63e(,%eax,8)
801065e7:	80 08 00 
801065ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ed:	0f b6 14 c5 c4 49 11 	movzbl -0x7feeb63c(,%eax,8),%edx
801065f4:	80 
801065f5:	83 e2 e0             	and    $0xffffffe0,%edx
801065f8:	88 14 c5 c4 49 11 80 	mov    %dl,-0x7feeb63c(,%eax,8)
801065ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106602:	0f b6 14 c5 c4 49 11 	movzbl -0x7feeb63c(,%eax,8),%edx
80106609:	80 
8010660a:	83 e2 1f             	and    $0x1f,%edx
8010660d:	88 14 c5 c4 49 11 80 	mov    %dl,-0x7feeb63c(,%eax,8)
80106614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106617:	0f b6 14 c5 c5 49 11 	movzbl -0x7feeb63b(,%eax,8),%edx
8010661e:	80 
8010661f:	83 e2 f0             	and    $0xfffffff0,%edx
80106622:	83 ca 0e             	or     $0xe,%edx
80106625:	88 14 c5 c5 49 11 80 	mov    %dl,-0x7feeb63b(,%eax,8)
8010662c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010662f:	0f b6 14 c5 c5 49 11 	movzbl -0x7feeb63b(,%eax,8),%edx
80106636:	80 
80106637:	83 e2 ef             	and    $0xffffffef,%edx
8010663a:	88 14 c5 c5 49 11 80 	mov    %dl,-0x7feeb63b(,%eax,8)
80106641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106644:	0f b6 14 c5 c5 49 11 	movzbl -0x7feeb63b(,%eax,8),%edx
8010664b:	80 
8010664c:	83 e2 9f             	and    $0xffffff9f,%edx
8010664f:	88 14 c5 c5 49 11 80 	mov    %dl,-0x7feeb63b(,%eax,8)
80106656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106659:	0f b6 14 c5 c5 49 11 	movzbl -0x7feeb63b(,%eax,8),%edx
80106660:	80 
80106661:	83 ca 80             	or     $0xffffff80,%edx
80106664:	88 14 c5 c5 49 11 80 	mov    %dl,-0x7feeb63b(,%eax,8)
8010666b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666e:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106675:	c1 e8 10             	shr    $0x10,%eax
80106678:	89 c2                	mov    %eax,%edx
8010667a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667d:	66 89 14 c5 c6 49 11 	mov    %dx,-0x7feeb63a(,%eax,8)
80106684:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106685:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106689:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106690:	0f 8e 30 ff ff ff    	jle    801065c6 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106696:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010669b:	66 a3 c0 4b 11 80    	mov    %ax,0x80114bc0
801066a1:	66 c7 05 c2 4b 11 80 	movw   $0x8,0x80114bc2
801066a8:	08 00 
801066aa:	0f b6 05 c4 4b 11 80 	movzbl 0x80114bc4,%eax
801066b1:	83 e0 e0             	and    $0xffffffe0,%eax
801066b4:	a2 c4 4b 11 80       	mov    %al,0x80114bc4
801066b9:	0f b6 05 c4 4b 11 80 	movzbl 0x80114bc4,%eax
801066c0:	83 e0 1f             	and    $0x1f,%eax
801066c3:	a2 c4 4b 11 80       	mov    %al,0x80114bc4
801066c8:	0f b6 05 c5 4b 11 80 	movzbl 0x80114bc5,%eax
801066cf:	83 c8 0f             	or     $0xf,%eax
801066d2:	a2 c5 4b 11 80       	mov    %al,0x80114bc5
801066d7:	0f b6 05 c5 4b 11 80 	movzbl 0x80114bc5,%eax
801066de:	83 e0 ef             	and    $0xffffffef,%eax
801066e1:	a2 c5 4b 11 80       	mov    %al,0x80114bc5
801066e6:	0f b6 05 c5 4b 11 80 	movzbl 0x80114bc5,%eax
801066ed:	83 c8 60             	or     $0x60,%eax
801066f0:	a2 c5 4b 11 80       	mov    %al,0x80114bc5
801066f5:	0f b6 05 c5 4b 11 80 	movzbl 0x80114bc5,%eax
801066fc:	83 c8 80             	or     $0xffffff80,%eax
801066ff:	a2 c5 4b 11 80       	mov    %al,0x80114bc5
80106704:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106709:	c1 e8 10             	shr    $0x10,%eax
8010670c:	66 a3 c6 4b 11 80    	mov    %ax,0x80114bc6
  
  initlock(&tickslock, "time");
80106712:	83 ec 08             	sub    $0x8,%esp
80106715:	68 b4 88 10 80       	push   $0x801088b4
8010671a:	68 80 49 11 80       	push   $0x80114980
8010671f:	e8 f2 e7 ff ff       	call   80104f16 <initlock>
80106724:	83 c4 10             	add    $0x10,%esp
}
80106727:	c9                   	leave  
80106728:	c3                   	ret    

80106729 <idtinit>:

void
idtinit(void)
{
80106729:	55                   	push   %ebp
8010672a:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010672c:	68 00 08 00 00       	push   $0x800
80106731:	68 c0 49 11 80       	push   $0x801149c0
80106736:	e8 3f fe ff ff       	call   8010657a <lidt>
8010673b:	83 c4 08             	add    $0x8,%esp
}
8010673e:	c9                   	leave  
8010673f:	c3                   	ret    

80106740 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
80106745:	53                   	push   %ebx
80106746:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106749:	8b 45 08             	mov    0x8(%ebp),%eax
8010674c:	8b 40 30             	mov    0x30(%eax),%eax
8010674f:	83 f8 40             	cmp    $0x40,%eax
80106752:	75 3f                	jne    80106793 <trap+0x53>
    if(proc->killed)
80106754:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010675a:	8b 40 24             	mov    0x24(%eax),%eax
8010675d:	85 c0                	test   %eax,%eax
8010675f:	74 05                	je     80106766 <trap+0x26>
      exit();
80106761:	e8 bc e0 ff ff       	call   80104822 <exit>
    proc->tf = tf;
80106766:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010676c:	8b 55 08             	mov    0x8(%ebp),%edx
8010676f:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106772:	e8 fb ed ff ff       	call   80105572 <syscall>
    if(proc->killed)
80106777:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010677d:	8b 40 24             	mov    0x24(%eax),%eax
80106780:	85 c0                	test   %eax,%eax
80106782:	74 0a                	je     8010678e <trap+0x4e>
      exit();
80106784:	e8 99 e0 ff ff       	call   80104822 <exit>
    return;
80106789:	e9 14 02 00 00       	jmp    801069a2 <trap+0x262>
8010678e:	e9 0f 02 00 00       	jmp    801069a2 <trap+0x262>
  }

  switch(tf->trapno){
80106793:	8b 45 08             	mov    0x8(%ebp),%eax
80106796:	8b 40 30             	mov    0x30(%eax),%eax
80106799:	83 e8 20             	sub    $0x20,%eax
8010679c:	83 f8 1f             	cmp    $0x1f,%eax
8010679f:	0f 87 c0 00 00 00    	ja     80106865 <trap+0x125>
801067a5:	8b 04 85 5c 89 10 80 	mov    -0x7fef76a4(,%eax,4),%eax
801067ac:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801067ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067b4:	0f b6 00             	movzbl (%eax),%eax
801067b7:	84 c0                	test   %al,%al
801067b9:	75 3d                	jne    801067f8 <trap+0xb8>
      acquire(&tickslock);
801067bb:	83 ec 0c             	sub    $0xc,%esp
801067be:	68 80 49 11 80       	push   $0x80114980
801067c3:	e8 6f e7 ff ff       	call   80104f37 <acquire>
801067c8:	83 c4 10             	add    $0x10,%esp
      ticks++;
801067cb:	a1 c0 51 11 80       	mov    0x801151c0,%eax
801067d0:	83 c0 01             	add    $0x1,%eax
801067d3:	a3 c0 51 11 80       	mov    %eax,0x801151c0
      wakeup(&ticks);
801067d8:	83 ec 0c             	sub    $0xc,%esp
801067db:	68 c0 51 11 80       	push   $0x801151c0
801067e0:	e8 4b e5 ff ff       	call   80104d30 <wakeup>
801067e5:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801067e8:	83 ec 0c             	sub    $0xc,%esp
801067eb:	68 80 49 11 80       	push   $0x80114980
801067f0:	e8 a8 e7 ff ff       	call   80104f9d <release>
801067f5:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801067f8:	e8 8a c7 ff ff       	call   80102f87 <lapiceoi>
    break;
801067fd:	e9 1c 01 00 00       	jmp    8010691e <trap+0x1de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106802:	e8 a1 bf ff ff       	call   801027a8 <ideintr>
    lapiceoi();
80106807:	e8 7b c7 ff ff       	call   80102f87 <lapiceoi>
    break;
8010680c:	e9 0d 01 00 00       	jmp    8010691e <trap+0x1de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106811:	e8 78 c5 ff ff       	call   80102d8e <kbdintr>
    lapiceoi();
80106816:	e8 6c c7 ff ff       	call   80102f87 <lapiceoi>
    break;
8010681b:	e9 fe 00 00 00       	jmp    8010691e <trap+0x1de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106820:	e8 5a 03 00 00       	call   80106b7f <uartintr>
    lapiceoi();
80106825:	e8 5d c7 ff ff       	call   80102f87 <lapiceoi>
    break;
8010682a:	e9 ef 00 00 00       	jmp    8010691e <trap+0x1de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010682f:	8b 45 08             	mov    0x8(%ebp),%eax
80106832:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106835:	8b 45 08             	mov    0x8(%ebp),%eax
80106838:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010683c:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010683f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106845:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106848:	0f b6 c0             	movzbl %al,%eax
8010684b:	51                   	push   %ecx
8010684c:	52                   	push   %edx
8010684d:	50                   	push   %eax
8010684e:	68 bc 88 10 80       	push   $0x801088bc
80106853:	e8 67 9b ff ff       	call   801003bf <cprintf>
80106858:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010685b:	e8 27 c7 ff ff       	call   80102f87 <lapiceoi>
    break;
80106860:	e9 b9 00 00 00       	jmp    8010691e <trap+0x1de>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106865:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010686b:	85 c0                	test   %eax,%eax
8010686d:	74 11                	je     80106880 <trap+0x140>
8010686f:	8b 45 08             	mov    0x8(%ebp),%eax
80106872:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106876:	0f b7 c0             	movzwl %ax,%eax
80106879:	83 e0 03             	and    $0x3,%eax
8010687c:	85 c0                	test   %eax,%eax
8010687e:	75 40                	jne    801068c0 <trap+0x180>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106880:	e8 1e fd ff ff       	call   801065a3 <rcr2>
80106885:	89 c3                	mov    %eax,%ebx
80106887:	8b 45 08             	mov    0x8(%ebp),%eax
8010688a:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010688d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106893:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106896:	0f b6 d0             	movzbl %al,%edx
80106899:	8b 45 08             	mov    0x8(%ebp),%eax
8010689c:	8b 40 30             	mov    0x30(%eax),%eax
8010689f:	83 ec 0c             	sub    $0xc,%esp
801068a2:	53                   	push   %ebx
801068a3:	51                   	push   %ecx
801068a4:	52                   	push   %edx
801068a5:	50                   	push   %eax
801068a6:	68 e0 88 10 80       	push   $0x801088e0
801068ab:	e8 0f 9b ff ff       	call   801003bf <cprintf>
801068b0:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801068b3:	83 ec 0c             	sub    $0xc,%esp
801068b6:	68 12 89 10 80       	push   $0x80108912
801068bb:	e8 9c 9c ff ff       	call   8010055c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068c0:	e8 de fc ff ff       	call   801065a3 <rcr2>
801068c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068c8:	8b 45 08             	mov    0x8(%ebp),%eax
801068cb:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801068ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068d4:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d7:	0f b6 d8             	movzbl %al,%ebx
801068da:	8b 45 08             	mov    0x8(%ebp),%eax
801068dd:	8b 48 34             	mov    0x34(%eax),%ecx
801068e0:	8b 45 08             	mov    0x8(%ebp),%eax
801068e3:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801068e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ec:	8d 78 6c             	lea    0x6c(%eax),%edi
801068ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068f5:	8b 40 10             	mov    0x10(%eax),%eax
801068f8:	ff 75 e4             	pushl  -0x1c(%ebp)
801068fb:	56                   	push   %esi
801068fc:	53                   	push   %ebx
801068fd:	51                   	push   %ecx
801068fe:	52                   	push   %edx
801068ff:	57                   	push   %edi
80106900:	50                   	push   %eax
80106901:	68 18 89 10 80       	push   $0x80108918
80106906:	e8 b4 9a ff ff       	call   801003bf <cprintf>
8010690b:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010690e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106914:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010691b:	eb 01                	jmp    8010691e <trap+0x1de>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010691d:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010691e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106924:	85 c0                	test   %eax,%eax
80106926:	74 24                	je     8010694c <trap+0x20c>
80106928:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010692e:	8b 40 24             	mov    0x24(%eax),%eax
80106931:	85 c0                	test   %eax,%eax
80106933:	74 17                	je     8010694c <trap+0x20c>
80106935:	8b 45 08             	mov    0x8(%ebp),%eax
80106938:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010693c:	0f b7 c0             	movzwl %ax,%eax
8010693f:	83 e0 03             	and    $0x3,%eax
80106942:	83 f8 03             	cmp    $0x3,%eax
80106945:	75 05                	jne    8010694c <trap+0x20c>
    exit();
80106947:	e8 d6 de ff ff       	call   80104822 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010694c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106952:	85 c0                	test   %eax,%eax
80106954:	74 1e                	je     80106974 <trap+0x234>
80106956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010695c:	8b 40 0c             	mov    0xc(%eax),%eax
8010695f:	83 f8 04             	cmp    $0x4,%eax
80106962:	75 10                	jne    80106974 <trap+0x234>
80106964:	8b 45 08             	mov    0x8(%ebp),%eax
80106967:	8b 40 30             	mov    0x30(%eax),%eax
8010696a:	83 f8 20             	cmp    $0x20,%eax
8010696d:	75 05                	jne    80106974 <trap+0x234>
    yield();
8010696f:	e8 69 e2 ff ff       	call   80104bdd <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697a:	85 c0                	test   %eax,%eax
8010697c:	74 24                	je     801069a2 <trap+0x262>
8010697e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106984:	8b 40 24             	mov    0x24(%eax),%eax
80106987:	85 c0                	test   %eax,%eax
80106989:	74 17                	je     801069a2 <trap+0x262>
8010698b:	8b 45 08             	mov    0x8(%ebp),%eax
8010698e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106992:	0f b7 c0             	movzwl %ax,%eax
80106995:	83 e0 03             	and    $0x3,%eax
80106998:	83 f8 03             	cmp    $0x3,%eax
8010699b:	75 05                	jne    801069a2 <trap+0x262>
    exit();
8010699d:	e8 80 de ff ff       	call   80104822 <exit>
}
801069a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    

801069aa <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801069aa:	55                   	push   %ebp
801069ab:	89 e5                	mov    %esp,%ebp
801069ad:	83 ec 14             	sub    $0x14,%esp
801069b0:	8b 45 08             	mov    0x8(%ebp),%eax
801069b3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069b7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801069bb:	89 c2                	mov    %eax,%edx
801069bd:	ec                   	in     (%dx),%al
801069be:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801069c1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801069c5:	c9                   	leave  
801069c6:	c3                   	ret    

801069c7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801069c7:	55                   	push   %ebp
801069c8:	89 e5                	mov    %esp,%ebp
801069ca:	83 ec 08             	sub    $0x8,%esp
801069cd:	8b 55 08             	mov    0x8(%ebp),%edx
801069d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801069d3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069d7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069da:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069de:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069e2:	ee                   	out    %al,(%dx)
}
801069e3:	c9                   	leave  
801069e4:	c3                   	ret    

801069e5 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801069e5:	55                   	push   %ebp
801069e6:	89 e5                	mov    %esp,%ebp
801069e8:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801069eb:	6a 00                	push   $0x0
801069ed:	68 fa 03 00 00       	push   $0x3fa
801069f2:	e8 d0 ff ff ff       	call   801069c7 <outb>
801069f7:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801069fa:	68 80 00 00 00       	push   $0x80
801069ff:	68 fb 03 00 00       	push   $0x3fb
80106a04:	e8 be ff ff ff       	call   801069c7 <outb>
80106a09:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106a0c:	6a 0c                	push   $0xc
80106a0e:	68 f8 03 00 00       	push   $0x3f8
80106a13:	e8 af ff ff ff       	call   801069c7 <outb>
80106a18:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106a1b:	6a 00                	push   $0x0
80106a1d:	68 f9 03 00 00       	push   $0x3f9
80106a22:	e8 a0 ff ff ff       	call   801069c7 <outb>
80106a27:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a2a:	6a 03                	push   $0x3
80106a2c:	68 fb 03 00 00       	push   $0x3fb
80106a31:	e8 91 ff ff ff       	call   801069c7 <outb>
80106a36:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106a39:	6a 00                	push   $0x0
80106a3b:	68 fc 03 00 00       	push   $0x3fc
80106a40:	e8 82 ff ff ff       	call   801069c7 <outb>
80106a45:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a48:	6a 01                	push   $0x1
80106a4a:	68 f9 03 00 00       	push   $0x3f9
80106a4f:	e8 73 ff ff ff       	call   801069c7 <outb>
80106a54:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106a57:	68 fd 03 00 00       	push   $0x3fd
80106a5c:	e8 49 ff ff ff       	call   801069aa <inb>
80106a61:	83 c4 04             	add    $0x4,%esp
80106a64:	3c ff                	cmp    $0xff,%al
80106a66:	75 02                	jne    80106a6a <uartinit+0x85>
    return;
80106a68:	eb 6c                	jmp    80106ad6 <uartinit+0xf1>
  uart = 1;
80106a6a:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106a71:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106a74:	68 fa 03 00 00       	push   $0x3fa
80106a79:	e8 2c ff ff ff       	call   801069aa <inb>
80106a7e:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106a81:	68 f8 03 00 00       	push   $0x3f8
80106a86:	e8 1f ff ff ff       	call   801069aa <inb>
80106a8b:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106a8e:	83 ec 0c             	sub    $0xc,%esp
80106a91:	6a 04                	push   $0x4
80106a93:	e8 ef d3 ff ff       	call   80103e87 <picenable>
80106a98:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106a9b:	83 ec 08             	sub    $0x8,%esp
80106a9e:	6a 00                	push   $0x0
80106aa0:	6a 04                	push   $0x4
80106aa2:	e8 9f bf ff ff       	call   80102a46 <ioapicenable>
80106aa7:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106aaa:	c7 45 f4 dc 89 10 80 	movl   $0x801089dc,-0xc(%ebp)
80106ab1:	eb 19                	jmp    80106acc <uartinit+0xe7>
    uartputc(*p);
80106ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab6:	0f b6 00             	movzbl (%eax),%eax
80106ab9:	0f be c0             	movsbl %al,%eax
80106abc:	83 ec 0c             	sub    $0xc,%esp
80106abf:	50                   	push   %eax
80106ac0:	e8 13 00 00 00       	call   80106ad8 <uartputc>
80106ac5:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ac8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106acf:	0f b6 00             	movzbl (%eax),%eax
80106ad2:	84 c0                	test   %al,%al
80106ad4:	75 dd                	jne    80106ab3 <uartinit+0xce>
    uartputc(*p);
}
80106ad6:	c9                   	leave  
80106ad7:	c3                   	ret    

80106ad8 <uartputc>:

void
uartputc(int c)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
80106adb:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106ade:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106ae3:	85 c0                	test   %eax,%eax
80106ae5:	75 02                	jne    80106ae9 <uartputc+0x11>
    return;
80106ae7:	eb 51                	jmp    80106b3a <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106af0:	eb 11                	jmp    80106b03 <uartputc+0x2b>
    microdelay(10);
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	6a 0a                	push   $0xa
80106af7:	e8 a5 c4 ff ff       	call   80102fa1 <microdelay>
80106afc:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106aff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b03:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106b07:	7f 1a                	jg     80106b23 <uartputc+0x4b>
80106b09:	83 ec 0c             	sub    $0xc,%esp
80106b0c:	68 fd 03 00 00       	push   $0x3fd
80106b11:	e8 94 fe ff ff       	call   801069aa <inb>
80106b16:	83 c4 10             	add    $0x10,%esp
80106b19:	0f b6 c0             	movzbl %al,%eax
80106b1c:	83 e0 20             	and    $0x20,%eax
80106b1f:	85 c0                	test   %eax,%eax
80106b21:	74 cf                	je     80106af2 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106b23:	8b 45 08             	mov    0x8(%ebp),%eax
80106b26:	0f b6 c0             	movzbl %al,%eax
80106b29:	83 ec 08             	sub    $0x8,%esp
80106b2c:	50                   	push   %eax
80106b2d:	68 f8 03 00 00       	push   $0x3f8
80106b32:	e8 90 fe ff ff       	call   801069c7 <outb>
80106b37:	83 c4 10             	add    $0x10,%esp
}
80106b3a:	c9                   	leave  
80106b3b:	c3                   	ret    

80106b3c <uartgetc>:

static int
uartgetc(void)
{
80106b3c:	55                   	push   %ebp
80106b3d:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b3f:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106b44:	85 c0                	test   %eax,%eax
80106b46:	75 07                	jne    80106b4f <uartgetc+0x13>
    return -1;
80106b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b4d:	eb 2e                	jmp    80106b7d <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106b4f:	68 fd 03 00 00       	push   $0x3fd
80106b54:	e8 51 fe ff ff       	call   801069aa <inb>
80106b59:	83 c4 04             	add    $0x4,%esp
80106b5c:	0f b6 c0             	movzbl %al,%eax
80106b5f:	83 e0 01             	and    $0x1,%eax
80106b62:	85 c0                	test   %eax,%eax
80106b64:	75 07                	jne    80106b6d <uartgetc+0x31>
    return -1;
80106b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b6b:	eb 10                	jmp    80106b7d <uartgetc+0x41>
  return inb(COM1+0);
80106b6d:	68 f8 03 00 00       	push   $0x3f8
80106b72:	e8 33 fe ff ff       	call   801069aa <inb>
80106b77:	83 c4 04             	add    $0x4,%esp
80106b7a:	0f b6 c0             	movzbl %al,%eax
}
80106b7d:	c9                   	leave  
80106b7e:	c3                   	ret    

80106b7f <uartintr>:

void
uartintr(void)
{
80106b7f:	55                   	push   %ebp
80106b80:	89 e5                	mov    %esp,%ebp
80106b82:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106b85:	83 ec 0c             	sub    $0xc,%esp
80106b88:	68 3c 6b 10 80       	push   $0x80106b3c
80106b8d:	e8 3f 9c ff ff       	call   801007d1 <consoleintr>
80106b92:	83 c4 10             	add    $0x10,%esp
}
80106b95:	c9                   	leave  
80106b96:	c3                   	ret    

80106b97 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $0
80106b99:	6a 00                	push   $0x0
  jmp alltraps
80106b9b:	e9 af f9 ff ff       	jmp    8010654f <alltraps>

80106ba0 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ba0:	6a 00                	push   $0x0
  pushl $1
80106ba2:	6a 01                	push   $0x1
  jmp alltraps
80106ba4:	e9 a6 f9 ff ff       	jmp    8010654f <alltraps>

80106ba9 <vector2>:
.globl vector2
vector2:
  pushl $0
80106ba9:	6a 00                	push   $0x0
  pushl $2
80106bab:	6a 02                	push   $0x2
  jmp alltraps
80106bad:	e9 9d f9 ff ff       	jmp    8010654f <alltraps>

80106bb2 <vector3>:
.globl vector3
vector3:
  pushl $0
80106bb2:	6a 00                	push   $0x0
  pushl $3
80106bb4:	6a 03                	push   $0x3
  jmp alltraps
80106bb6:	e9 94 f9 ff ff       	jmp    8010654f <alltraps>

80106bbb <vector4>:
.globl vector4
vector4:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $4
80106bbd:	6a 04                	push   $0x4
  jmp alltraps
80106bbf:	e9 8b f9 ff ff       	jmp    8010654f <alltraps>

80106bc4 <vector5>:
.globl vector5
vector5:
  pushl $0
80106bc4:	6a 00                	push   $0x0
  pushl $5
80106bc6:	6a 05                	push   $0x5
  jmp alltraps
80106bc8:	e9 82 f9 ff ff       	jmp    8010654f <alltraps>

80106bcd <vector6>:
.globl vector6
vector6:
  pushl $0
80106bcd:	6a 00                	push   $0x0
  pushl $6
80106bcf:	6a 06                	push   $0x6
  jmp alltraps
80106bd1:	e9 79 f9 ff ff       	jmp    8010654f <alltraps>

80106bd6 <vector7>:
.globl vector7
vector7:
  pushl $0
80106bd6:	6a 00                	push   $0x0
  pushl $7
80106bd8:	6a 07                	push   $0x7
  jmp alltraps
80106bda:	e9 70 f9 ff ff       	jmp    8010654f <alltraps>

80106bdf <vector8>:
.globl vector8
vector8:
  pushl $8
80106bdf:	6a 08                	push   $0x8
  jmp alltraps
80106be1:	e9 69 f9 ff ff       	jmp    8010654f <alltraps>

80106be6 <vector9>:
.globl vector9
vector9:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $9
80106be8:	6a 09                	push   $0x9
  jmp alltraps
80106bea:	e9 60 f9 ff ff       	jmp    8010654f <alltraps>

80106bef <vector10>:
.globl vector10
vector10:
  pushl $10
80106bef:	6a 0a                	push   $0xa
  jmp alltraps
80106bf1:	e9 59 f9 ff ff       	jmp    8010654f <alltraps>

80106bf6 <vector11>:
.globl vector11
vector11:
  pushl $11
80106bf6:	6a 0b                	push   $0xb
  jmp alltraps
80106bf8:	e9 52 f9 ff ff       	jmp    8010654f <alltraps>

80106bfd <vector12>:
.globl vector12
vector12:
  pushl $12
80106bfd:	6a 0c                	push   $0xc
  jmp alltraps
80106bff:	e9 4b f9 ff ff       	jmp    8010654f <alltraps>

80106c04 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c04:	6a 0d                	push   $0xd
  jmp alltraps
80106c06:	e9 44 f9 ff ff       	jmp    8010654f <alltraps>

80106c0b <vector14>:
.globl vector14
vector14:
  pushl $14
80106c0b:	6a 0e                	push   $0xe
  jmp alltraps
80106c0d:	e9 3d f9 ff ff       	jmp    8010654f <alltraps>

80106c12 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $15
80106c14:	6a 0f                	push   $0xf
  jmp alltraps
80106c16:	e9 34 f9 ff ff       	jmp    8010654f <alltraps>

80106c1b <vector16>:
.globl vector16
vector16:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $16
80106c1d:	6a 10                	push   $0x10
  jmp alltraps
80106c1f:	e9 2b f9 ff ff       	jmp    8010654f <alltraps>

80106c24 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c24:	6a 11                	push   $0x11
  jmp alltraps
80106c26:	e9 24 f9 ff ff       	jmp    8010654f <alltraps>

80106c2b <vector18>:
.globl vector18
vector18:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $18
80106c2d:	6a 12                	push   $0x12
  jmp alltraps
80106c2f:	e9 1b f9 ff ff       	jmp    8010654f <alltraps>

80106c34 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $19
80106c36:	6a 13                	push   $0x13
  jmp alltraps
80106c38:	e9 12 f9 ff ff       	jmp    8010654f <alltraps>

80106c3d <vector20>:
.globl vector20
vector20:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $20
80106c3f:	6a 14                	push   $0x14
  jmp alltraps
80106c41:	e9 09 f9 ff ff       	jmp    8010654f <alltraps>

80106c46 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $21
80106c48:	6a 15                	push   $0x15
  jmp alltraps
80106c4a:	e9 00 f9 ff ff       	jmp    8010654f <alltraps>

80106c4f <vector22>:
.globl vector22
vector22:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $22
80106c51:	6a 16                	push   $0x16
  jmp alltraps
80106c53:	e9 f7 f8 ff ff       	jmp    8010654f <alltraps>

80106c58 <vector23>:
.globl vector23
vector23:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $23
80106c5a:	6a 17                	push   $0x17
  jmp alltraps
80106c5c:	e9 ee f8 ff ff       	jmp    8010654f <alltraps>

80106c61 <vector24>:
.globl vector24
vector24:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $24
80106c63:	6a 18                	push   $0x18
  jmp alltraps
80106c65:	e9 e5 f8 ff ff       	jmp    8010654f <alltraps>

80106c6a <vector25>:
.globl vector25
vector25:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $25
80106c6c:	6a 19                	push   $0x19
  jmp alltraps
80106c6e:	e9 dc f8 ff ff       	jmp    8010654f <alltraps>

80106c73 <vector26>:
.globl vector26
vector26:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $26
80106c75:	6a 1a                	push   $0x1a
  jmp alltraps
80106c77:	e9 d3 f8 ff ff       	jmp    8010654f <alltraps>

80106c7c <vector27>:
.globl vector27
vector27:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $27
80106c7e:	6a 1b                	push   $0x1b
  jmp alltraps
80106c80:	e9 ca f8 ff ff       	jmp    8010654f <alltraps>

80106c85 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $28
80106c87:	6a 1c                	push   $0x1c
  jmp alltraps
80106c89:	e9 c1 f8 ff ff       	jmp    8010654f <alltraps>

80106c8e <vector29>:
.globl vector29
vector29:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $29
80106c90:	6a 1d                	push   $0x1d
  jmp alltraps
80106c92:	e9 b8 f8 ff ff       	jmp    8010654f <alltraps>

80106c97 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $30
80106c99:	6a 1e                	push   $0x1e
  jmp alltraps
80106c9b:	e9 af f8 ff ff       	jmp    8010654f <alltraps>

80106ca0 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $31
80106ca2:	6a 1f                	push   $0x1f
  jmp alltraps
80106ca4:	e9 a6 f8 ff ff       	jmp    8010654f <alltraps>

80106ca9 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $32
80106cab:	6a 20                	push   $0x20
  jmp alltraps
80106cad:	e9 9d f8 ff ff       	jmp    8010654f <alltraps>

80106cb2 <vector33>:
.globl vector33
vector33:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $33
80106cb4:	6a 21                	push   $0x21
  jmp alltraps
80106cb6:	e9 94 f8 ff ff       	jmp    8010654f <alltraps>

80106cbb <vector34>:
.globl vector34
vector34:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $34
80106cbd:	6a 22                	push   $0x22
  jmp alltraps
80106cbf:	e9 8b f8 ff ff       	jmp    8010654f <alltraps>

80106cc4 <vector35>:
.globl vector35
vector35:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $35
80106cc6:	6a 23                	push   $0x23
  jmp alltraps
80106cc8:	e9 82 f8 ff ff       	jmp    8010654f <alltraps>

80106ccd <vector36>:
.globl vector36
vector36:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $36
80106ccf:	6a 24                	push   $0x24
  jmp alltraps
80106cd1:	e9 79 f8 ff ff       	jmp    8010654f <alltraps>

80106cd6 <vector37>:
.globl vector37
vector37:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $37
80106cd8:	6a 25                	push   $0x25
  jmp alltraps
80106cda:	e9 70 f8 ff ff       	jmp    8010654f <alltraps>

80106cdf <vector38>:
.globl vector38
vector38:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $38
80106ce1:	6a 26                	push   $0x26
  jmp alltraps
80106ce3:	e9 67 f8 ff ff       	jmp    8010654f <alltraps>

80106ce8 <vector39>:
.globl vector39
vector39:
  pushl $0
80106ce8:	6a 00                	push   $0x0
  pushl $39
80106cea:	6a 27                	push   $0x27
  jmp alltraps
80106cec:	e9 5e f8 ff ff       	jmp    8010654f <alltraps>

80106cf1 <vector40>:
.globl vector40
vector40:
  pushl $0
80106cf1:	6a 00                	push   $0x0
  pushl $40
80106cf3:	6a 28                	push   $0x28
  jmp alltraps
80106cf5:	e9 55 f8 ff ff       	jmp    8010654f <alltraps>

80106cfa <vector41>:
.globl vector41
vector41:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $41
80106cfc:	6a 29                	push   $0x29
  jmp alltraps
80106cfe:	e9 4c f8 ff ff       	jmp    8010654f <alltraps>

80106d03 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $42
80106d05:	6a 2a                	push   $0x2a
  jmp alltraps
80106d07:	e9 43 f8 ff ff       	jmp    8010654f <alltraps>

80106d0c <vector43>:
.globl vector43
vector43:
  pushl $0
80106d0c:	6a 00                	push   $0x0
  pushl $43
80106d0e:	6a 2b                	push   $0x2b
  jmp alltraps
80106d10:	e9 3a f8 ff ff       	jmp    8010654f <alltraps>

80106d15 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d15:	6a 00                	push   $0x0
  pushl $44
80106d17:	6a 2c                	push   $0x2c
  jmp alltraps
80106d19:	e9 31 f8 ff ff       	jmp    8010654f <alltraps>

80106d1e <vector45>:
.globl vector45
vector45:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $45
80106d20:	6a 2d                	push   $0x2d
  jmp alltraps
80106d22:	e9 28 f8 ff ff       	jmp    8010654f <alltraps>

80106d27 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $46
80106d29:	6a 2e                	push   $0x2e
  jmp alltraps
80106d2b:	e9 1f f8 ff ff       	jmp    8010654f <alltraps>

80106d30 <vector47>:
.globl vector47
vector47:
  pushl $0
80106d30:	6a 00                	push   $0x0
  pushl $47
80106d32:	6a 2f                	push   $0x2f
  jmp alltraps
80106d34:	e9 16 f8 ff ff       	jmp    8010654f <alltraps>

80106d39 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $48
80106d3b:	6a 30                	push   $0x30
  jmp alltraps
80106d3d:	e9 0d f8 ff ff       	jmp    8010654f <alltraps>

80106d42 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $49
80106d44:	6a 31                	push   $0x31
  jmp alltraps
80106d46:	e9 04 f8 ff ff       	jmp    8010654f <alltraps>

80106d4b <vector50>:
.globl vector50
vector50:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $50
80106d4d:	6a 32                	push   $0x32
  jmp alltraps
80106d4f:	e9 fb f7 ff ff       	jmp    8010654f <alltraps>

80106d54 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $51
80106d56:	6a 33                	push   $0x33
  jmp alltraps
80106d58:	e9 f2 f7 ff ff       	jmp    8010654f <alltraps>

80106d5d <vector52>:
.globl vector52
vector52:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $52
80106d5f:	6a 34                	push   $0x34
  jmp alltraps
80106d61:	e9 e9 f7 ff ff       	jmp    8010654f <alltraps>

80106d66 <vector53>:
.globl vector53
vector53:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $53
80106d68:	6a 35                	push   $0x35
  jmp alltraps
80106d6a:	e9 e0 f7 ff ff       	jmp    8010654f <alltraps>

80106d6f <vector54>:
.globl vector54
vector54:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $54
80106d71:	6a 36                	push   $0x36
  jmp alltraps
80106d73:	e9 d7 f7 ff ff       	jmp    8010654f <alltraps>

80106d78 <vector55>:
.globl vector55
vector55:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $55
80106d7a:	6a 37                	push   $0x37
  jmp alltraps
80106d7c:	e9 ce f7 ff ff       	jmp    8010654f <alltraps>

80106d81 <vector56>:
.globl vector56
vector56:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $56
80106d83:	6a 38                	push   $0x38
  jmp alltraps
80106d85:	e9 c5 f7 ff ff       	jmp    8010654f <alltraps>

80106d8a <vector57>:
.globl vector57
vector57:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $57
80106d8c:	6a 39                	push   $0x39
  jmp alltraps
80106d8e:	e9 bc f7 ff ff       	jmp    8010654f <alltraps>

80106d93 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $58
80106d95:	6a 3a                	push   $0x3a
  jmp alltraps
80106d97:	e9 b3 f7 ff ff       	jmp    8010654f <alltraps>

80106d9c <vector59>:
.globl vector59
vector59:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $59
80106d9e:	6a 3b                	push   $0x3b
  jmp alltraps
80106da0:	e9 aa f7 ff ff       	jmp    8010654f <alltraps>

80106da5 <vector60>:
.globl vector60
vector60:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $60
80106da7:	6a 3c                	push   $0x3c
  jmp alltraps
80106da9:	e9 a1 f7 ff ff       	jmp    8010654f <alltraps>

80106dae <vector61>:
.globl vector61
vector61:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $61
80106db0:	6a 3d                	push   $0x3d
  jmp alltraps
80106db2:	e9 98 f7 ff ff       	jmp    8010654f <alltraps>

80106db7 <vector62>:
.globl vector62
vector62:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $62
80106db9:	6a 3e                	push   $0x3e
  jmp alltraps
80106dbb:	e9 8f f7 ff ff       	jmp    8010654f <alltraps>

80106dc0 <vector63>:
.globl vector63
vector63:
  pushl $0
80106dc0:	6a 00                	push   $0x0
  pushl $63
80106dc2:	6a 3f                	push   $0x3f
  jmp alltraps
80106dc4:	e9 86 f7 ff ff       	jmp    8010654f <alltraps>

80106dc9 <vector64>:
.globl vector64
vector64:
  pushl $0
80106dc9:	6a 00                	push   $0x0
  pushl $64
80106dcb:	6a 40                	push   $0x40
  jmp alltraps
80106dcd:	e9 7d f7 ff ff       	jmp    8010654f <alltraps>

80106dd2 <vector65>:
.globl vector65
vector65:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $65
80106dd4:	6a 41                	push   $0x41
  jmp alltraps
80106dd6:	e9 74 f7 ff ff       	jmp    8010654f <alltraps>

80106ddb <vector66>:
.globl vector66
vector66:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $66
80106ddd:	6a 42                	push   $0x42
  jmp alltraps
80106ddf:	e9 6b f7 ff ff       	jmp    8010654f <alltraps>

80106de4 <vector67>:
.globl vector67
vector67:
  pushl $0
80106de4:	6a 00                	push   $0x0
  pushl $67
80106de6:	6a 43                	push   $0x43
  jmp alltraps
80106de8:	e9 62 f7 ff ff       	jmp    8010654f <alltraps>

80106ded <vector68>:
.globl vector68
vector68:
  pushl $0
80106ded:	6a 00                	push   $0x0
  pushl $68
80106def:	6a 44                	push   $0x44
  jmp alltraps
80106df1:	e9 59 f7 ff ff       	jmp    8010654f <alltraps>

80106df6 <vector69>:
.globl vector69
vector69:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $69
80106df8:	6a 45                	push   $0x45
  jmp alltraps
80106dfa:	e9 50 f7 ff ff       	jmp    8010654f <alltraps>

80106dff <vector70>:
.globl vector70
vector70:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $70
80106e01:	6a 46                	push   $0x46
  jmp alltraps
80106e03:	e9 47 f7 ff ff       	jmp    8010654f <alltraps>

80106e08 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e08:	6a 00                	push   $0x0
  pushl $71
80106e0a:	6a 47                	push   $0x47
  jmp alltraps
80106e0c:	e9 3e f7 ff ff       	jmp    8010654f <alltraps>

80106e11 <vector72>:
.globl vector72
vector72:
  pushl $0
80106e11:	6a 00                	push   $0x0
  pushl $72
80106e13:	6a 48                	push   $0x48
  jmp alltraps
80106e15:	e9 35 f7 ff ff       	jmp    8010654f <alltraps>

80106e1a <vector73>:
.globl vector73
vector73:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $73
80106e1c:	6a 49                	push   $0x49
  jmp alltraps
80106e1e:	e9 2c f7 ff ff       	jmp    8010654f <alltraps>

80106e23 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $74
80106e25:	6a 4a                	push   $0x4a
  jmp alltraps
80106e27:	e9 23 f7 ff ff       	jmp    8010654f <alltraps>

80106e2c <vector75>:
.globl vector75
vector75:
  pushl $0
80106e2c:	6a 00                	push   $0x0
  pushl $75
80106e2e:	6a 4b                	push   $0x4b
  jmp alltraps
80106e30:	e9 1a f7 ff ff       	jmp    8010654f <alltraps>

80106e35 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e35:	6a 00                	push   $0x0
  pushl $76
80106e37:	6a 4c                	push   $0x4c
  jmp alltraps
80106e39:	e9 11 f7 ff ff       	jmp    8010654f <alltraps>

80106e3e <vector77>:
.globl vector77
vector77:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $77
80106e40:	6a 4d                	push   $0x4d
  jmp alltraps
80106e42:	e9 08 f7 ff ff       	jmp    8010654f <alltraps>

80106e47 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $78
80106e49:	6a 4e                	push   $0x4e
  jmp alltraps
80106e4b:	e9 ff f6 ff ff       	jmp    8010654f <alltraps>

80106e50 <vector79>:
.globl vector79
vector79:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $79
80106e52:	6a 4f                	push   $0x4f
  jmp alltraps
80106e54:	e9 f6 f6 ff ff       	jmp    8010654f <alltraps>

80106e59 <vector80>:
.globl vector80
vector80:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $80
80106e5b:	6a 50                	push   $0x50
  jmp alltraps
80106e5d:	e9 ed f6 ff ff       	jmp    8010654f <alltraps>

80106e62 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $81
80106e64:	6a 51                	push   $0x51
  jmp alltraps
80106e66:	e9 e4 f6 ff ff       	jmp    8010654f <alltraps>

80106e6b <vector82>:
.globl vector82
vector82:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $82
80106e6d:	6a 52                	push   $0x52
  jmp alltraps
80106e6f:	e9 db f6 ff ff       	jmp    8010654f <alltraps>

80106e74 <vector83>:
.globl vector83
vector83:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $83
80106e76:	6a 53                	push   $0x53
  jmp alltraps
80106e78:	e9 d2 f6 ff ff       	jmp    8010654f <alltraps>

80106e7d <vector84>:
.globl vector84
vector84:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $84
80106e7f:	6a 54                	push   $0x54
  jmp alltraps
80106e81:	e9 c9 f6 ff ff       	jmp    8010654f <alltraps>

80106e86 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $85
80106e88:	6a 55                	push   $0x55
  jmp alltraps
80106e8a:	e9 c0 f6 ff ff       	jmp    8010654f <alltraps>

80106e8f <vector86>:
.globl vector86
vector86:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $86
80106e91:	6a 56                	push   $0x56
  jmp alltraps
80106e93:	e9 b7 f6 ff ff       	jmp    8010654f <alltraps>

80106e98 <vector87>:
.globl vector87
vector87:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $87
80106e9a:	6a 57                	push   $0x57
  jmp alltraps
80106e9c:	e9 ae f6 ff ff       	jmp    8010654f <alltraps>

80106ea1 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $88
80106ea3:	6a 58                	push   $0x58
  jmp alltraps
80106ea5:	e9 a5 f6 ff ff       	jmp    8010654f <alltraps>

80106eaa <vector89>:
.globl vector89
vector89:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $89
80106eac:	6a 59                	push   $0x59
  jmp alltraps
80106eae:	e9 9c f6 ff ff       	jmp    8010654f <alltraps>

80106eb3 <vector90>:
.globl vector90
vector90:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $90
80106eb5:	6a 5a                	push   $0x5a
  jmp alltraps
80106eb7:	e9 93 f6 ff ff       	jmp    8010654f <alltraps>

80106ebc <vector91>:
.globl vector91
vector91:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $91
80106ebe:	6a 5b                	push   $0x5b
  jmp alltraps
80106ec0:	e9 8a f6 ff ff       	jmp    8010654f <alltraps>

80106ec5 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $92
80106ec7:	6a 5c                	push   $0x5c
  jmp alltraps
80106ec9:	e9 81 f6 ff ff       	jmp    8010654f <alltraps>

80106ece <vector93>:
.globl vector93
vector93:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $93
80106ed0:	6a 5d                	push   $0x5d
  jmp alltraps
80106ed2:	e9 78 f6 ff ff       	jmp    8010654f <alltraps>

80106ed7 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $94
80106ed9:	6a 5e                	push   $0x5e
  jmp alltraps
80106edb:	e9 6f f6 ff ff       	jmp    8010654f <alltraps>

80106ee0 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $95
80106ee2:	6a 5f                	push   $0x5f
  jmp alltraps
80106ee4:	e9 66 f6 ff ff       	jmp    8010654f <alltraps>

80106ee9 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $96
80106eeb:	6a 60                	push   $0x60
  jmp alltraps
80106eed:	e9 5d f6 ff ff       	jmp    8010654f <alltraps>

80106ef2 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $97
80106ef4:	6a 61                	push   $0x61
  jmp alltraps
80106ef6:	e9 54 f6 ff ff       	jmp    8010654f <alltraps>

80106efb <vector98>:
.globl vector98
vector98:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $98
80106efd:	6a 62                	push   $0x62
  jmp alltraps
80106eff:	e9 4b f6 ff ff       	jmp    8010654f <alltraps>

80106f04 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $99
80106f06:	6a 63                	push   $0x63
  jmp alltraps
80106f08:	e9 42 f6 ff ff       	jmp    8010654f <alltraps>

80106f0d <vector100>:
.globl vector100
vector100:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $100
80106f0f:	6a 64                	push   $0x64
  jmp alltraps
80106f11:	e9 39 f6 ff ff       	jmp    8010654f <alltraps>

80106f16 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $101
80106f18:	6a 65                	push   $0x65
  jmp alltraps
80106f1a:	e9 30 f6 ff ff       	jmp    8010654f <alltraps>

80106f1f <vector102>:
.globl vector102
vector102:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $102
80106f21:	6a 66                	push   $0x66
  jmp alltraps
80106f23:	e9 27 f6 ff ff       	jmp    8010654f <alltraps>

80106f28 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $103
80106f2a:	6a 67                	push   $0x67
  jmp alltraps
80106f2c:	e9 1e f6 ff ff       	jmp    8010654f <alltraps>

80106f31 <vector104>:
.globl vector104
vector104:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $104
80106f33:	6a 68                	push   $0x68
  jmp alltraps
80106f35:	e9 15 f6 ff ff       	jmp    8010654f <alltraps>

80106f3a <vector105>:
.globl vector105
vector105:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $105
80106f3c:	6a 69                	push   $0x69
  jmp alltraps
80106f3e:	e9 0c f6 ff ff       	jmp    8010654f <alltraps>

80106f43 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $106
80106f45:	6a 6a                	push   $0x6a
  jmp alltraps
80106f47:	e9 03 f6 ff ff       	jmp    8010654f <alltraps>

80106f4c <vector107>:
.globl vector107
vector107:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $107
80106f4e:	6a 6b                	push   $0x6b
  jmp alltraps
80106f50:	e9 fa f5 ff ff       	jmp    8010654f <alltraps>

80106f55 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $108
80106f57:	6a 6c                	push   $0x6c
  jmp alltraps
80106f59:	e9 f1 f5 ff ff       	jmp    8010654f <alltraps>

80106f5e <vector109>:
.globl vector109
vector109:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $109
80106f60:	6a 6d                	push   $0x6d
  jmp alltraps
80106f62:	e9 e8 f5 ff ff       	jmp    8010654f <alltraps>

80106f67 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $110
80106f69:	6a 6e                	push   $0x6e
  jmp alltraps
80106f6b:	e9 df f5 ff ff       	jmp    8010654f <alltraps>

80106f70 <vector111>:
.globl vector111
vector111:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $111
80106f72:	6a 6f                	push   $0x6f
  jmp alltraps
80106f74:	e9 d6 f5 ff ff       	jmp    8010654f <alltraps>

80106f79 <vector112>:
.globl vector112
vector112:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $112
80106f7b:	6a 70                	push   $0x70
  jmp alltraps
80106f7d:	e9 cd f5 ff ff       	jmp    8010654f <alltraps>

80106f82 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $113
80106f84:	6a 71                	push   $0x71
  jmp alltraps
80106f86:	e9 c4 f5 ff ff       	jmp    8010654f <alltraps>

80106f8b <vector114>:
.globl vector114
vector114:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $114
80106f8d:	6a 72                	push   $0x72
  jmp alltraps
80106f8f:	e9 bb f5 ff ff       	jmp    8010654f <alltraps>

80106f94 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $115
80106f96:	6a 73                	push   $0x73
  jmp alltraps
80106f98:	e9 b2 f5 ff ff       	jmp    8010654f <alltraps>

80106f9d <vector116>:
.globl vector116
vector116:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $116
80106f9f:	6a 74                	push   $0x74
  jmp alltraps
80106fa1:	e9 a9 f5 ff ff       	jmp    8010654f <alltraps>

80106fa6 <vector117>:
.globl vector117
vector117:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $117
80106fa8:	6a 75                	push   $0x75
  jmp alltraps
80106faa:	e9 a0 f5 ff ff       	jmp    8010654f <alltraps>

80106faf <vector118>:
.globl vector118
vector118:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $118
80106fb1:	6a 76                	push   $0x76
  jmp alltraps
80106fb3:	e9 97 f5 ff ff       	jmp    8010654f <alltraps>

80106fb8 <vector119>:
.globl vector119
vector119:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $119
80106fba:	6a 77                	push   $0x77
  jmp alltraps
80106fbc:	e9 8e f5 ff ff       	jmp    8010654f <alltraps>

80106fc1 <vector120>:
.globl vector120
vector120:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $120
80106fc3:	6a 78                	push   $0x78
  jmp alltraps
80106fc5:	e9 85 f5 ff ff       	jmp    8010654f <alltraps>

80106fca <vector121>:
.globl vector121
vector121:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $121
80106fcc:	6a 79                	push   $0x79
  jmp alltraps
80106fce:	e9 7c f5 ff ff       	jmp    8010654f <alltraps>

80106fd3 <vector122>:
.globl vector122
vector122:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $122
80106fd5:	6a 7a                	push   $0x7a
  jmp alltraps
80106fd7:	e9 73 f5 ff ff       	jmp    8010654f <alltraps>

80106fdc <vector123>:
.globl vector123
vector123:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $123
80106fde:	6a 7b                	push   $0x7b
  jmp alltraps
80106fe0:	e9 6a f5 ff ff       	jmp    8010654f <alltraps>

80106fe5 <vector124>:
.globl vector124
vector124:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $124
80106fe7:	6a 7c                	push   $0x7c
  jmp alltraps
80106fe9:	e9 61 f5 ff ff       	jmp    8010654f <alltraps>

80106fee <vector125>:
.globl vector125
vector125:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $125
80106ff0:	6a 7d                	push   $0x7d
  jmp alltraps
80106ff2:	e9 58 f5 ff ff       	jmp    8010654f <alltraps>

80106ff7 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $126
80106ff9:	6a 7e                	push   $0x7e
  jmp alltraps
80106ffb:	e9 4f f5 ff ff       	jmp    8010654f <alltraps>

80107000 <vector127>:
.globl vector127
vector127:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $127
80107002:	6a 7f                	push   $0x7f
  jmp alltraps
80107004:	e9 46 f5 ff ff       	jmp    8010654f <alltraps>

80107009 <vector128>:
.globl vector128
vector128:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $128
8010700b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107010:	e9 3a f5 ff ff       	jmp    8010654f <alltraps>

80107015 <vector129>:
.globl vector129
vector129:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $129
80107017:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010701c:	e9 2e f5 ff ff       	jmp    8010654f <alltraps>

80107021 <vector130>:
.globl vector130
vector130:
  pushl $0
80107021:	6a 00                	push   $0x0
  pushl $130
80107023:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107028:	e9 22 f5 ff ff       	jmp    8010654f <alltraps>

8010702d <vector131>:
.globl vector131
vector131:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $131
8010702f:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107034:	e9 16 f5 ff ff       	jmp    8010654f <alltraps>

80107039 <vector132>:
.globl vector132
vector132:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $132
8010703b:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107040:	e9 0a f5 ff ff       	jmp    8010654f <alltraps>

80107045 <vector133>:
.globl vector133
vector133:
  pushl $0
80107045:	6a 00                	push   $0x0
  pushl $133
80107047:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010704c:	e9 fe f4 ff ff       	jmp    8010654f <alltraps>

80107051 <vector134>:
.globl vector134
vector134:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $134
80107053:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107058:	e9 f2 f4 ff ff       	jmp    8010654f <alltraps>

8010705d <vector135>:
.globl vector135
vector135:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $135
8010705f:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107064:	e9 e6 f4 ff ff       	jmp    8010654f <alltraps>

80107069 <vector136>:
.globl vector136
vector136:
  pushl $0
80107069:	6a 00                	push   $0x0
  pushl $136
8010706b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107070:	e9 da f4 ff ff       	jmp    8010654f <alltraps>

80107075 <vector137>:
.globl vector137
vector137:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $137
80107077:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010707c:	e9 ce f4 ff ff       	jmp    8010654f <alltraps>

80107081 <vector138>:
.globl vector138
vector138:
  pushl $0
80107081:	6a 00                	push   $0x0
  pushl $138
80107083:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107088:	e9 c2 f4 ff ff       	jmp    8010654f <alltraps>

8010708d <vector139>:
.globl vector139
vector139:
  pushl $0
8010708d:	6a 00                	push   $0x0
  pushl $139
8010708f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107094:	e9 b6 f4 ff ff       	jmp    8010654f <alltraps>

80107099 <vector140>:
.globl vector140
vector140:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $140
8010709b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070a0:	e9 aa f4 ff ff       	jmp    8010654f <alltraps>

801070a5 <vector141>:
.globl vector141
vector141:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $141
801070a7:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070ac:	e9 9e f4 ff ff       	jmp    8010654f <alltraps>

801070b1 <vector142>:
.globl vector142
vector142:
  pushl $0
801070b1:	6a 00                	push   $0x0
  pushl $142
801070b3:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801070b8:	e9 92 f4 ff ff       	jmp    8010654f <alltraps>

801070bd <vector143>:
.globl vector143
vector143:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $143
801070bf:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801070c4:	e9 86 f4 ff ff       	jmp    8010654f <alltraps>

801070c9 <vector144>:
.globl vector144
vector144:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $144
801070cb:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801070d0:	e9 7a f4 ff ff       	jmp    8010654f <alltraps>

801070d5 <vector145>:
.globl vector145
vector145:
  pushl $0
801070d5:	6a 00                	push   $0x0
  pushl $145
801070d7:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801070dc:	e9 6e f4 ff ff       	jmp    8010654f <alltraps>

801070e1 <vector146>:
.globl vector146
vector146:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $146
801070e3:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801070e8:	e9 62 f4 ff ff       	jmp    8010654f <alltraps>

801070ed <vector147>:
.globl vector147
vector147:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $147
801070ef:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801070f4:	e9 56 f4 ff ff       	jmp    8010654f <alltraps>

801070f9 <vector148>:
.globl vector148
vector148:
  pushl $0
801070f9:	6a 00                	push   $0x0
  pushl $148
801070fb:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107100:	e9 4a f4 ff ff       	jmp    8010654f <alltraps>

80107105 <vector149>:
.globl vector149
vector149:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $149
80107107:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010710c:	e9 3e f4 ff ff       	jmp    8010654f <alltraps>

80107111 <vector150>:
.globl vector150
vector150:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $150
80107113:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107118:	e9 32 f4 ff ff       	jmp    8010654f <alltraps>

8010711d <vector151>:
.globl vector151
vector151:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $151
8010711f:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107124:	e9 26 f4 ff ff       	jmp    8010654f <alltraps>

80107129 <vector152>:
.globl vector152
vector152:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $152
8010712b:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107130:	e9 1a f4 ff ff       	jmp    8010654f <alltraps>

80107135 <vector153>:
.globl vector153
vector153:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $153
80107137:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010713c:	e9 0e f4 ff ff       	jmp    8010654f <alltraps>

80107141 <vector154>:
.globl vector154
vector154:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $154
80107143:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107148:	e9 02 f4 ff ff       	jmp    8010654f <alltraps>

8010714d <vector155>:
.globl vector155
vector155:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $155
8010714f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107154:	e9 f6 f3 ff ff       	jmp    8010654f <alltraps>

80107159 <vector156>:
.globl vector156
vector156:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $156
8010715b:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107160:	e9 ea f3 ff ff       	jmp    8010654f <alltraps>

80107165 <vector157>:
.globl vector157
vector157:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $157
80107167:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010716c:	e9 de f3 ff ff       	jmp    8010654f <alltraps>

80107171 <vector158>:
.globl vector158
vector158:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $158
80107173:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107178:	e9 d2 f3 ff ff       	jmp    8010654f <alltraps>

8010717d <vector159>:
.globl vector159
vector159:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $159
8010717f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107184:	e9 c6 f3 ff ff       	jmp    8010654f <alltraps>

80107189 <vector160>:
.globl vector160
vector160:
  pushl $0
80107189:	6a 00                	push   $0x0
  pushl $160
8010718b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107190:	e9 ba f3 ff ff       	jmp    8010654f <alltraps>

80107195 <vector161>:
.globl vector161
vector161:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $161
80107197:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010719c:	e9 ae f3 ff ff       	jmp    8010654f <alltraps>

801071a1 <vector162>:
.globl vector162
vector162:
  pushl $0
801071a1:	6a 00                	push   $0x0
  pushl $162
801071a3:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071a8:	e9 a2 f3 ff ff       	jmp    8010654f <alltraps>

801071ad <vector163>:
.globl vector163
vector163:
  pushl $0
801071ad:	6a 00                	push   $0x0
  pushl $163
801071af:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801071b4:	e9 96 f3 ff ff       	jmp    8010654f <alltraps>

801071b9 <vector164>:
.globl vector164
vector164:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $164
801071bb:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801071c0:	e9 8a f3 ff ff       	jmp    8010654f <alltraps>

801071c5 <vector165>:
.globl vector165
vector165:
  pushl $0
801071c5:	6a 00                	push   $0x0
  pushl $165
801071c7:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801071cc:	e9 7e f3 ff ff       	jmp    8010654f <alltraps>

801071d1 <vector166>:
.globl vector166
vector166:
  pushl $0
801071d1:	6a 00                	push   $0x0
  pushl $166
801071d3:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801071d8:	e9 72 f3 ff ff       	jmp    8010654f <alltraps>

801071dd <vector167>:
.globl vector167
vector167:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $167
801071df:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801071e4:	e9 66 f3 ff ff       	jmp    8010654f <alltraps>

801071e9 <vector168>:
.globl vector168
vector168:
  pushl $0
801071e9:	6a 00                	push   $0x0
  pushl $168
801071eb:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801071f0:	e9 5a f3 ff ff       	jmp    8010654f <alltraps>

801071f5 <vector169>:
.globl vector169
vector169:
  pushl $0
801071f5:	6a 00                	push   $0x0
  pushl $169
801071f7:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801071fc:	e9 4e f3 ff ff       	jmp    8010654f <alltraps>

80107201 <vector170>:
.globl vector170
vector170:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $170
80107203:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107208:	e9 42 f3 ff ff       	jmp    8010654f <alltraps>

8010720d <vector171>:
.globl vector171
vector171:
  pushl $0
8010720d:	6a 00                	push   $0x0
  pushl $171
8010720f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107214:	e9 36 f3 ff ff       	jmp    8010654f <alltraps>

80107219 <vector172>:
.globl vector172
vector172:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $172
8010721b:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107220:	e9 2a f3 ff ff       	jmp    8010654f <alltraps>

80107225 <vector173>:
.globl vector173
vector173:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $173
80107227:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010722c:	e9 1e f3 ff ff       	jmp    8010654f <alltraps>

80107231 <vector174>:
.globl vector174
vector174:
  pushl $0
80107231:	6a 00                	push   $0x0
  pushl $174
80107233:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107238:	e9 12 f3 ff ff       	jmp    8010654f <alltraps>

8010723d <vector175>:
.globl vector175
vector175:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $175
8010723f:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107244:	e9 06 f3 ff ff       	jmp    8010654f <alltraps>

80107249 <vector176>:
.globl vector176
vector176:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $176
8010724b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107250:	e9 fa f2 ff ff       	jmp    8010654f <alltraps>

80107255 <vector177>:
.globl vector177
vector177:
  pushl $0
80107255:	6a 00                	push   $0x0
  pushl $177
80107257:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010725c:	e9 ee f2 ff ff       	jmp    8010654f <alltraps>

80107261 <vector178>:
.globl vector178
vector178:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $178
80107263:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107268:	e9 e2 f2 ff ff       	jmp    8010654f <alltraps>

8010726d <vector179>:
.globl vector179
vector179:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $179
8010726f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107274:	e9 d6 f2 ff ff       	jmp    8010654f <alltraps>

80107279 <vector180>:
.globl vector180
vector180:
  pushl $0
80107279:	6a 00                	push   $0x0
  pushl $180
8010727b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107280:	e9 ca f2 ff ff       	jmp    8010654f <alltraps>

80107285 <vector181>:
.globl vector181
vector181:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $181
80107287:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010728c:	e9 be f2 ff ff       	jmp    8010654f <alltraps>

80107291 <vector182>:
.globl vector182
vector182:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $182
80107293:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107298:	e9 b2 f2 ff ff       	jmp    8010654f <alltraps>

8010729d <vector183>:
.globl vector183
vector183:
  pushl $0
8010729d:	6a 00                	push   $0x0
  pushl $183
8010729f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072a4:	e9 a6 f2 ff ff       	jmp    8010654f <alltraps>

801072a9 <vector184>:
.globl vector184
vector184:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $184
801072ab:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072b0:	e9 9a f2 ff ff       	jmp    8010654f <alltraps>

801072b5 <vector185>:
.globl vector185
vector185:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $185
801072b7:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801072bc:	e9 8e f2 ff ff       	jmp    8010654f <alltraps>

801072c1 <vector186>:
.globl vector186
vector186:
  pushl $0
801072c1:	6a 00                	push   $0x0
  pushl $186
801072c3:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801072c8:	e9 82 f2 ff ff       	jmp    8010654f <alltraps>

801072cd <vector187>:
.globl vector187
vector187:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $187
801072cf:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801072d4:	e9 76 f2 ff ff       	jmp    8010654f <alltraps>

801072d9 <vector188>:
.globl vector188
vector188:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $188
801072db:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801072e0:	e9 6a f2 ff ff       	jmp    8010654f <alltraps>

801072e5 <vector189>:
.globl vector189
vector189:
  pushl $0
801072e5:	6a 00                	push   $0x0
  pushl $189
801072e7:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801072ec:	e9 5e f2 ff ff       	jmp    8010654f <alltraps>

801072f1 <vector190>:
.globl vector190
vector190:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $190
801072f3:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801072f8:	e9 52 f2 ff ff       	jmp    8010654f <alltraps>

801072fd <vector191>:
.globl vector191
vector191:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $191
801072ff:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107304:	e9 46 f2 ff ff       	jmp    8010654f <alltraps>

80107309 <vector192>:
.globl vector192
vector192:
  pushl $0
80107309:	6a 00                	push   $0x0
  pushl $192
8010730b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107310:	e9 3a f2 ff ff       	jmp    8010654f <alltraps>

80107315 <vector193>:
.globl vector193
vector193:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $193
80107317:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010731c:	e9 2e f2 ff ff       	jmp    8010654f <alltraps>

80107321 <vector194>:
.globl vector194
vector194:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $194
80107323:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107328:	e9 22 f2 ff ff       	jmp    8010654f <alltraps>

8010732d <vector195>:
.globl vector195
vector195:
  pushl $0
8010732d:	6a 00                	push   $0x0
  pushl $195
8010732f:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107334:	e9 16 f2 ff ff       	jmp    8010654f <alltraps>

80107339 <vector196>:
.globl vector196
vector196:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $196
8010733b:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107340:	e9 0a f2 ff ff       	jmp    8010654f <alltraps>

80107345 <vector197>:
.globl vector197
vector197:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $197
80107347:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010734c:	e9 fe f1 ff ff       	jmp    8010654f <alltraps>

80107351 <vector198>:
.globl vector198
vector198:
  pushl $0
80107351:	6a 00                	push   $0x0
  pushl $198
80107353:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107358:	e9 f2 f1 ff ff       	jmp    8010654f <alltraps>

8010735d <vector199>:
.globl vector199
vector199:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $199
8010735f:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107364:	e9 e6 f1 ff ff       	jmp    8010654f <alltraps>

80107369 <vector200>:
.globl vector200
vector200:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $200
8010736b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107370:	e9 da f1 ff ff       	jmp    8010654f <alltraps>

80107375 <vector201>:
.globl vector201
vector201:
  pushl $0
80107375:	6a 00                	push   $0x0
  pushl $201
80107377:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010737c:	e9 ce f1 ff ff       	jmp    8010654f <alltraps>

80107381 <vector202>:
.globl vector202
vector202:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $202
80107383:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107388:	e9 c2 f1 ff ff       	jmp    8010654f <alltraps>

8010738d <vector203>:
.globl vector203
vector203:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $203
8010738f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107394:	e9 b6 f1 ff ff       	jmp    8010654f <alltraps>

80107399 <vector204>:
.globl vector204
vector204:
  pushl $0
80107399:	6a 00                	push   $0x0
  pushl $204
8010739b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073a0:	e9 aa f1 ff ff       	jmp    8010654f <alltraps>

801073a5 <vector205>:
.globl vector205
vector205:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $205
801073a7:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073ac:	e9 9e f1 ff ff       	jmp    8010654f <alltraps>

801073b1 <vector206>:
.globl vector206
vector206:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $206
801073b3:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801073b8:	e9 92 f1 ff ff       	jmp    8010654f <alltraps>

801073bd <vector207>:
.globl vector207
vector207:
  pushl $0
801073bd:	6a 00                	push   $0x0
  pushl $207
801073bf:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801073c4:	e9 86 f1 ff ff       	jmp    8010654f <alltraps>

801073c9 <vector208>:
.globl vector208
vector208:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $208
801073cb:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801073d0:	e9 7a f1 ff ff       	jmp    8010654f <alltraps>

801073d5 <vector209>:
.globl vector209
vector209:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $209
801073d7:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801073dc:	e9 6e f1 ff ff       	jmp    8010654f <alltraps>

801073e1 <vector210>:
.globl vector210
vector210:
  pushl $0
801073e1:	6a 00                	push   $0x0
  pushl $210
801073e3:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801073e8:	e9 62 f1 ff ff       	jmp    8010654f <alltraps>

801073ed <vector211>:
.globl vector211
vector211:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $211
801073ef:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801073f4:	e9 56 f1 ff ff       	jmp    8010654f <alltraps>

801073f9 <vector212>:
.globl vector212
vector212:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $212
801073fb:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107400:	e9 4a f1 ff ff       	jmp    8010654f <alltraps>

80107405 <vector213>:
.globl vector213
vector213:
  pushl $0
80107405:	6a 00                	push   $0x0
  pushl $213
80107407:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010740c:	e9 3e f1 ff ff       	jmp    8010654f <alltraps>

80107411 <vector214>:
.globl vector214
vector214:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $214
80107413:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107418:	e9 32 f1 ff ff       	jmp    8010654f <alltraps>

8010741d <vector215>:
.globl vector215
vector215:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $215
8010741f:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107424:	e9 26 f1 ff ff       	jmp    8010654f <alltraps>

80107429 <vector216>:
.globl vector216
vector216:
  pushl $0
80107429:	6a 00                	push   $0x0
  pushl $216
8010742b:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107430:	e9 1a f1 ff ff       	jmp    8010654f <alltraps>

80107435 <vector217>:
.globl vector217
vector217:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $217
80107437:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010743c:	e9 0e f1 ff ff       	jmp    8010654f <alltraps>

80107441 <vector218>:
.globl vector218
vector218:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $218
80107443:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107448:	e9 02 f1 ff ff       	jmp    8010654f <alltraps>

8010744d <vector219>:
.globl vector219
vector219:
  pushl $0
8010744d:	6a 00                	push   $0x0
  pushl $219
8010744f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107454:	e9 f6 f0 ff ff       	jmp    8010654f <alltraps>

80107459 <vector220>:
.globl vector220
vector220:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $220
8010745b:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107460:	e9 ea f0 ff ff       	jmp    8010654f <alltraps>

80107465 <vector221>:
.globl vector221
vector221:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $221
80107467:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010746c:	e9 de f0 ff ff       	jmp    8010654f <alltraps>

80107471 <vector222>:
.globl vector222
vector222:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $222
80107473:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107478:	e9 d2 f0 ff ff       	jmp    8010654f <alltraps>

8010747d <vector223>:
.globl vector223
vector223:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $223
8010747f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107484:	e9 c6 f0 ff ff       	jmp    8010654f <alltraps>

80107489 <vector224>:
.globl vector224
vector224:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $224
8010748b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107490:	e9 ba f0 ff ff       	jmp    8010654f <alltraps>

80107495 <vector225>:
.globl vector225
vector225:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $225
80107497:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010749c:	e9 ae f0 ff ff       	jmp    8010654f <alltraps>

801074a1 <vector226>:
.globl vector226
vector226:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $226
801074a3:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074a8:	e9 a2 f0 ff ff       	jmp    8010654f <alltraps>

801074ad <vector227>:
.globl vector227
vector227:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $227
801074af:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801074b4:	e9 96 f0 ff ff       	jmp    8010654f <alltraps>

801074b9 <vector228>:
.globl vector228
vector228:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $228
801074bb:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801074c0:	e9 8a f0 ff ff       	jmp    8010654f <alltraps>

801074c5 <vector229>:
.globl vector229
vector229:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $229
801074c7:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801074cc:	e9 7e f0 ff ff       	jmp    8010654f <alltraps>

801074d1 <vector230>:
.globl vector230
vector230:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $230
801074d3:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801074d8:	e9 72 f0 ff ff       	jmp    8010654f <alltraps>

801074dd <vector231>:
.globl vector231
vector231:
  pushl $0
801074dd:	6a 00                	push   $0x0
  pushl $231
801074df:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801074e4:	e9 66 f0 ff ff       	jmp    8010654f <alltraps>

801074e9 <vector232>:
.globl vector232
vector232:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $232
801074eb:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801074f0:	e9 5a f0 ff ff       	jmp    8010654f <alltraps>

801074f5 <vector233>:
.globl vector233
vector233:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $233
801074f7:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801074fc:	e9 4e f0 ff ff       	jmp    8010654f <alltraps>

80107501 <vector234>:
.globl vector234
vector234:
  pushl $0
80107501:	6a 00                	push   $0x0
  pushl $234
80107503:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107508:	e9 42 f0 ff ff       	jmp    8010654f <alltraps>

8010750d <vector235>:
.globl vector235
vector235:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $235
8010750f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107514:	e9 36 f0 ff ff       	jmp    8010654f <alltraps>

80107519 <vector236>:
.globl vector236
vector236:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $236
8010751b:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107520:	e9 2a f0 ff ff       	jmp    8010654f <alltraps>

80107525 <vector237>:
.globl vector237
vector237:
  pushl $0
80107525:	6a 00                	push   $0x0
  pushl $237
80107527:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010752c:	e9 1e f0 ff ff       	jmp    8010654f <alltraps>

80107531 <vector238>:
.globl vector238
vector238:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $238
80107533:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107538:	e9 12 f0 ff ff       	jmp    8010654f <alltraps>

8010753d <vector239>:
.globl vector239
vector239:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $239
8010753f:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107544:	e9 06 f0 ff ff       	jmp    8010654f <alltraps>

80107549 <vector240>:
.globl vector240
vector240:
  pushl $0
80107549:	6a 00                	push   $0x0
  pushl $240
8010754b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107550:	e9 fa ef ff ff       	jmp    8010654f <alltraps>

80107555 <vector241>:
.globl vector241
vector241:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $241
80107557:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010755c:	e9 ee ef ff ff       	jmp    8010654f <alltraps>

80107561 <vector242>:
.globl vector242
vector242:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $242
80107563:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107568:	e9 e2 ef ff ff       	jmp    8010654f <alltraps>

8010756d <vector243>:
.globl vector243
vector243:
  pushl $0
8010756d:	6a 00                	push   $0x0
  pushl $243
8010756f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107574:	e9 d6 ef ff ff       	jmp    8010654f <alltraps>

80107579 <vector244>:
.globl vector244
vector244:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $244
8010757b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107580:	e9 ca ef ff ff       	jmp    8010654f <alltraps>

80107585 <vector245>:
.globl vector245
vector245:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $245
80107587:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010758c:	e9 be ef ff ff       	jmp    8010654f <alltraps>

80107591 <vector246>:
.globl vector246
vector246:
  pushl $0
80107591:	6a 00                	push   $0x0
  pushl $246
80107593:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107598:	e9 b2 ef ff ff       	jmp    8010654f <alltraps>

8010759d <vector247>:
.globl vector247
vector247:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $247
8010759f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075a4:	e9 a6 ef ff ff       	jmp    8010654f <alltraps>

801075a9 <vector248>:
.globl vector248
vector248:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $248
801075ab:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075b0:	e9 9a ef ff ff       	jmp    8010654f <alltraps>

801075b5 <vector249>:
.globl vector249
vector249:
  pushl $0
801075b5:	6a 00                	push   $0x0
  pushl $249
801075b7:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801075bc:	e9 8e ef ff ff       	jmp    8010654f <alltraps>

801075c1 <vector250>:
.globl vector250
vector250:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $250
801075c3:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801075c8:	e9 82 ef ff ff       	jmp    8010654f <alltraps>

801075cd <vector251>:
.globl vector251
vector251:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $251
801075cf:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801075d4:	e9 76 ef ff ff       	jmp    8010654f <alltraps>

801075d9 <vector252>:
.globl vector252
vector252:
  pushl $0
801075d9:	6a 00                	push   $0x0
  pushl $252
801075db:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801075e0:	e9 6a ef ff ff       	jmp    8010654f <alltraps>

801075e5 <vector253>:
.globl vector253
vector253:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $253
801075e7:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801075ec:	e9 5e ef ff ff       	jmp    8010654f <alltraps>

801075f1 <vector254>:
.globl vector254
vector254:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $254
801075f3:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801075f8:	e9 52 ef ff ff       	jmp    8010654f <alltraps>

801075fd <vector255>:
.globl vector255
vector255:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $255
801075ff:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107604:	e9 46 ef ff ff       	jmp    8010654f <alltraps>

80107609 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107609:	55                   	push   %ebp
8010760a:	89 e5                	mov    %esp,%ebp
8010760c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010760f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107612:	83 e8 01             	sub    $0x1,%eax
80107615:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107619:	8b 45 08             	mov    0x8(%ebp),%eax
8010761c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107620:	8b 45 08             	mov    0x8(%ebp),%eax
80107623:	c1 e8 10             	shr    $0x10,%eax
80107626:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010762a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010762d:	0f 01 10             	lgdtl  (%eax)
}
80107630:	c9                   	leave  
80107631:	c3                   	ret    

80107632 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107632:	55                   	push   %ebp
80107633:	89 e5                	mov    %esp,%ebp
80107635:	83 ec 04             	sub    $0x4,%esp
80107638:	8b 45 08             	mov    0x8(%ebp),%eax
8010763b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010763f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107643:	0f 00 d8             	ltr    %ax
}
80107646:	c9                   	leave  
80107647:	c3                   	ret    

80107648 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107648:	55                   	push   %ebp
80107649:	89 e5                	mov    %esp,%ebp
8010764b:	83 ec 04             	sub    $0x4,%esp
8010764e:	8b 45 08             	mov    0x8(%ebp),%eax
80107651:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107655:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107659:	8e e8                	mov    %eax,%gs
}
8010765b:	c9                   	leave  
8010765c:	c3                   	ret    

8010765d <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010765d:	55                   	push   %ebp
8010765e:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107660:	8b 45 08             	mov    0x8(%ebp),%eax
80107663:	0f 22 d8             	mov    %eax,%cr3
}
80107666:	5d                   	pop    %ebp
80107667:	c3                   	ret    

80107668 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107668:	55                   	push   %ebp
80107669:	89 e5                	mov    %esp,%ebp
8010766b:	8b 45 08             	mov    0x8(%ebp),%eax
8010766e:	05 00 00 00 80       	add    $0x80000000,%eax
80107673:	5d                   	pop    %ebp
80107674:	c3                   	ret    

80107675 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107675:	55                   	push   %ebp
80107676:	89 e5                	mov    %esp,%ebp
80107678:	8b 45 08             	mov    0x8(%ebp),%eax
8010767b:	05 00 00 00 80       	add    $0x80000000,%eax
80107680:	5d                   	pop    %ebp
80107681:	c3                   	ret    

80107682 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107682:	55                   	push   %ebp
80107683:	89 e5                	mov    %esp,%ebp
80107685:	53                   	push   %ebx
80107686:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107689:	e8 a0 b8 ff ff       	call   80102f2e <cpunum>
8010768e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107694:	05 40 24 11 80       	add    $0x80112440,%eax
80107699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010769c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769f:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801076a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a8:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801076ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b1:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801076b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076bc:	83 e2 f0             	and    $0xfffffff0,%edx
801076bf:	83 ca 0a             	or     $0xa,%edx
801076c2:	88 50 7d             	mov    %dl,0x7d(%eax)
801076c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076cc:	83 ca 10             	or     $0x10,%edx
801076cf:	88 50 7d             	mov    %dl,0x7d(%eax)
801076d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076d9:	83 e2 9f             	and    $0xffffff9f,%edx
801076dc:	88 50 7d             	mov    %dl,0x7d(%eax)
801076df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e2:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076e6:	83 ca 80             	or     $0xffffff80,%edx
801076e9:	88 50 7d             	mov    %dl,0x7d(%eax)
801076ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ef:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076f3:	83 ca 0f             	or     $0xf,%edx
801076f6:	88 50 7e             	mov    %dl,0x7e(%eax)
801076f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107700:	83 e2 ef             	and    $0xffffffef,%edx
80107703:	88 50 7e             	mov    %dl,0x7e(%eax)
80107706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107709:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010770d:	83 e2 df             	and    $0xffffffdf,%edx
80107710:	88 50 7e             	mov    %dl,0x7e(%eax)
80107713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107716:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010771a:	83 ca 40             	or     $0x40,%edx
8010771d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107723:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107727:	83 ca 80             	or     $0xffffff80,%edx
8010772a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010772d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107730:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107737:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010773e:	ff ff 
80107740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107743:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010774a:	00 00 
8010774c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774f:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107759:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107760:	83 e2 f0             	and    $0xfffffff0,%edx
80107763:	83 ca 02             	or     $0x2,%edx
80107766:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010776c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107776:	83 ca 10             	or     $0x10,%edx
80107779:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010777f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107782:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107789:	83 e2 9f             	and    $0xffffff9f,%edx
8010778c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107795:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010779c:	83 ca 80             	or     $0xffffff80,%edx
8010779f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077af:	83 ca 0f             	or     $0xf,%edx
801077b2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077c2:	83 e2 ef             	and    $0xffffffef,%edx
801077c5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ce:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077d5:	83 e2 df             	and    $0xffffffdf,%edx
801077d8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077e8:	83 ca 40             	or     $0x40,%edx
801077eb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077fb:	83 ca 80             	or     $0xffffff80,%edx
801077fe:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107807:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010780e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107811:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107818:	ff ff 
8010781a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781d:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107824:	00 00 
80107826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107829:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107833:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010783a:	83 e2 f0             	and    $0xfffffff0,%edx
8010783d:	83 ca 0a             	or     $0xa,%edx
80107840:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107849:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107850:	83 ca 10             	or     $0x10,%edx
80107853:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107863:	83 ca 60             	or     $0x60,%edx
80107866:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010786c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107876:	83 ca 80             	or     $0xffffff80,%edx
80107879:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010787f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107882:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107889:	83 ca 0f             	or     $0xf,%edx
8010788c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107895:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010789c:	83 e2 ef             	and    $0xffffffef,%edx
8010789f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078af:	83 e2 df             	and    $0xffffffdf,%edx
801078b2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078c2:	83 ca 40             	or     $0x40,%edx
801078c5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ce:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078d5:	83 ca 80             	or     $0xffffff80,%edx
801078d8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e1:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801078e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078eb:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801078f2:	ff ff 
801078f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f7:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801078fe:	00 00 
80107900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107903:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010790a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107914:	83 e2 f0             	and    $0xfffffff0,%edx
80107917:	83 ca 02             	or     $0x2,%edx
8010791a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107923:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010792a:	83 ca 10             	or     $0x10,%edx
8010792d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107936:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010793d:	83 ca 60             	or     $0x60,%edx
80107940:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107949:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107950:	83 ca 80             	or     $0xffffff80,%edx
80107953:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107963:	83 ca 0f             	or     $0xf,%edx
80107966:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010796c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107976:	83 e2 ef             	and    $0xffffffef,%edx
80107979:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010797f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107982:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107989:	83 e2 df             	and    $0xffffffdf,%edx
8010798c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107995:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010799c:	83 ca 40             	or     $0x40,%edx
8010799f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079af:	83 ca 80             	or     $0xffffff80,%edx
801079b2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bb:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801079c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c5:	05 b4 00 00 00       	add    $0xb4,%eax
801079ca:	89 c3                	mov    %eax,%ebx
801079cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cf:	05 b4 00 00 00       	add    $0xb4,%eax
801079d4:	c1 e8 10             	shr    $0x10,%eax
801079d7:	89 c2                	mov    %eax,%edx
801079d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079dc:	05 b4 00 00 00       	add    $0xb4,%eax
801079e1:	c1 e8 18             	shr    $0x18,%eax
801079e4:	89 c1                	mov    %eax,%ecx
801079e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e9:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801079f0:	00 00 
801079f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f5:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801079fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ff:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a08:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a0f:	83 e2 f0             	and    $0xfffffff0,%edx
80107a12:	83 ca 02             	or     $0x2,%edx
80107a15:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a25:	83 ca 10             	or     $0x10,%edx
80107a28:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a31:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a38:	83 e2 9f             	and    $0xffffff9f,%edx
80107a3b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a44:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a4b:	83 ca 80             	or     $0xffffff80,%edx
80107a4e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a57:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a5e:	83 e2 f0             	and    $0xfffffff0,%edx
80107a61:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a71:	83 e2 ef             	and    $0xffffffef,%edx
80107a74:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a84:	83 e2 df             	and    $0xffffffdf,%edx
80107a87:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a90:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a97:	83 ca 40             	or     $0x40,%edx
80107a9a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107aaa:	83 ca 80             	or     $0xffffff80,%edx
80107aad:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab6:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abf:	83 c0 70             	add    $0x70,%eax
80107ac2:	83 ec 08             	sub    $0x8,%esp
80107ac5:	6a 38                	push   $0x38
80107ac7:	50                   	push   %eax
80107ac8:	e8 3c fb ff ff       	call   80107609 <lgdt>
80107acd:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107ad0:	83 ec 0c             	sub    $0xc,%esp
80107ad3:	6a 18                	push   $0x18
80107ad5:	e8 6e fb ff ff       	call   80107648 <loadgs>
80107ada:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae0:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107ae6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107aed:	00 00 00 00 
}
80107af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107af4:	c9                   	leave  
80107af5:	c3                   	ret    

80107af6 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107af6:	55                   	push   %ebp
80107af7:	89 e5                	mov    %esp,%ebp
80107af9:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aff:	c1 e8 16             	shr    $0x16,%eax
80107b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b09:	8b 45 08             	mov    0x8(%ebp),%eax
80107b0c:	01 d0                	add    %edx,%eax
80107b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b14:	8b 00                	mov    (%eax),%eax
80107b16:	83 e0 01             	and    $0x1,%eax
80107b19:	85 c0                	test   %eax,%eax
80107b1b:	74 18                	je     80107b35 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b20:	8b 00                	mov    (%eax),%eax
80107b22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b27:	50                   	push   %eax
80107b28:	e8 48 fb ff ff       	call   80107675 <p2v>
80107b2d:	83 c4 04             	add    $0x4,%esp
80107b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b33:	eb 48                	jmp    80107b7d <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b39:	74 0e                	je     80107b49 <walkpgdir+0x53>
80107b3b:	e8 8d b0 ff ff       	call   80102bcd <kalloc>
80107b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b47:	75 07                	jne    80107b50 <walkpgdir+0x5a>
      return 0;
80107b49:	b8 00 00 00 00       	mov    $0x0,%eax
80107b4e:	eb 44                	jmp    80107b94 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b50:	83 ec 04             	sub    $0x4,%esp
80107b53:	68 00 10 00 00       	push   $0x1000
80107b58:	6a 00                	push   $0x0
80107b5a:	ff 75 f4             	pushl  -0xc(%ebp)
80107b5d:	e8 31 d6 ff ff       	call   80105193 <memset>
80107b62:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107b65:	83 ec 0c             	sub    $0xc,%esp
80107b68:	ff 75 f4             	pushl  -0xc(%ebp)
80107b6b:	e8 f8 fa ff ff       	call   80107668 <v2p>
80107b70:	83 c4 10             	add    $0x10,%esp
80107b73:	83 c8 07             	or     $0x7,%eax
80107b76:	89 c2                	mov    %eax,%edx
80107b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b7b:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b80:	c1 e8 0c             	shr    $0xc,%eax
80107b83:	25 ff 03 00 00       	and    $0x3ff,%eax
80107b88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b92:	01 d0                	add    %edx,%eax
}
80107b94:	c9                   	leave  
80107b95:	c3                   	ret    

80107b96 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107b96:	55                   	push   %ebp
80107b97:	89 e5                	mov    %esp,%ebp
80107b99:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
80107baa:	8b 45 10             	mov    0x10(%ebp),%eax
80107bad:	01 d0                	add    %edx,%eax
80107baf:	83 e8 01             	sub    $0x1,%eax
80107bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bba:	83 ec 04             	sub    $0x4,%esp
80107bbd:	6a 01                	push   $0x1
80107bbf:	ff 75 f4             	pushl  -0xc(%ebp)
80107bc2:	ff 75 08             	pushl  0x8(%ebp)
80107bc5:	e8 2c ff ff ff       	call   80107af6 <walkpgdir>
80107bca:	83 c4 10             	add    $0x10,%esp
80107bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bd4:	75 07                	jne    80107bdd <mappages+0x47>
      return -1;
80107bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bdb:	eb 49                	jmp    80107c26 <mappages+0x90>
    if(*pte & PTE_P)
80107bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107be0:	8b 00                	mov    (%eax),%eax
80107be2:	83 e0 01             	and    $0x1,%eax
80107be5:	85 c0                	test   %eax,%eax
80107be7:	74 0d                	je     80107bf6 <mappages+0x60>
      panic("remap");
80107be9:	83 ec 0c             	sub    $0xc,%esp
80107bec:	68 e4 89 10 80       	push   $0x801089e4
80107bf1:	e8 66 89 ff ff       	call   8010055c <panic>
    *pte = pa | perm | PTE_P;
80107bf6:	8b 45 18             	mov    0x18(%ebp),%eax
80107bf9:	0b 45 14             	or     0x14(%ebp),%eax
80107bfc:	83 c8 01             	or     $0x1,%eax
80107bff:	89 c2                	mov    %eax,%edx
80107c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c04:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c0c:	75 08                	jne    80107c16 <mappages+0x80>
      break;
80107c0e:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80107c14:	eb 10                	jmp    80107c26 <mappages+0x90>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107c16:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c1d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c24:	eb 94                	jmp    80107bba <mappages+0x24>
  return 0;
}
80107c26:	c9                   	leave  
80107c27:	c3                   	ret    

80107c28 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c28:	55                   	push   %ebp
80107c29:	89 e5                	mov    %esp,%ebp
80107c2b:	53                   	push   %ebx
80107c2c:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c2f:	e8 99 af ff ff       	call   80102bcd <kalloc>
80107c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c3b:	75 0a                	jne    80107c47 <setupkvm+0x1f>
    return 0;
80107c3d:	b8 00 00 00 00       	mov    $0x0,%eax
80107c42:	e9 8e 00 00 00       	jmp    80107cd5 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107c47:	83 ec 04             	sub    $0x4,%esp
80107c4a:	68 00 10 00 00       	push   $0x1000
80107c4f:	6a 00                	push   $0x0
80107c51:	ff 75 f0             	pushl  -0x10(%ebp)
80107c54:	e8 3a d5 ff ff       	call   80105193 <memset>
80107c59:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107c5c:	83 ec 0c             	sub    $0xc,%esp
80107c5f:	68 00 00 00 0e       	push   $0xe000000
80107c64:	e8 0c fa ff ff       	call   80107675 <p2v>
80107c69:	83 c4 10             	add    $0x10,%esp
80107c6c:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107c71:	76 0d                	jbe    80107c80 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107c73:	83 ec 0c             	sub    $0xc,%esp
80107c76:	68 ea 89 10 80       	push   $0x801089ea
80107c7b:	e8 dc 88 ff ff       	call   8010055c <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c80:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107c87:	eb 40                	jmp    80107cc9 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8c:	8b 48 0c             	mov    0xc(%eax),%ecx
80107c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c92:	8b 50 04             	mov    0x4(%eax),%edx
80107c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c98:	8b 58 08             	mov    0x8(%eax),%ebx
80107c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9e:	8b 40 04             	mov    0x4(%eax),%eax
80107ca1:	29 c3                	sub    %eax,%ebx
80107ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca6:	8b 00                	mov    (%eax),%eax
80107ca8:	83 ec 0c             	sub    $0xc,%esp
80107cab:	51                   	push   %ecx
80107cac:	52                   	push   %edx
80107cad:	53                   	push   %ebx
80107cae:	50                   	push   %eax
80107caf:	ff 75 f0             	pushl  -0x10(%ebp)
80107cb2:	e8 df fe ff ff       	call   80107b96 <mappages>
80107cb7:	83 c4 20             	add    $0x20,%esp
80107cba:	85 c0                	test   %eax,%eax
80107cbc:	79 07                	jns    80107cc5 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107cbe:	b8 00 00 00 00       	mov    $0x0,%eax
80107cc3:	eb 10                	jmp    80107cd5 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cc5:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107cc9:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107cd0:	72 b7                	jb     80107c89 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107cd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107cd8:	c9                   	leave  
80107cd9:	c3                   	ret    

80107cda <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107cda:	55                   	push   %ebp
80107cdb:	89 e5                	mov    %esp,%ebp
80107cdd:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ce0:	e8 43 ff ff ff       	call   80107c28 <setupkvm>
80107ce5:	a3 18 52 11 80       	mov    %eax,0x80115218
  switchkvm();
80107cea:	e8 02 00 00 00       	call   80107cf1 <switchkvm>
}
80107cef:	c9                   	leave  
80107cf0:	c3                   	ret    

80107cf1 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107cf1:	55                   	push   %ebp
80107cf2:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107cf4:	a1 18 52 11 80       	mov    0x80115218,%eax
80107cf9:	50                   	push   %eax
80107cfa:	e8 69 f9 ff ff       	call   80107668 <v2p>
80107cff:	83 c4 04             	add    $0x4,%esp
80107d02:	50                   	push   %eax
80107d03:	e8 55 f9 ff ff       	call   8010765d <lcr3>
80107d08:	83 c4 04             	add    $0x4,%esp
}
80107d0b:	c9                   	leave  
80107d0c:	c3                   	ret    

80107d0d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d0d:	55                   	push   %ebp
80107d0e:	89 e5                	mov    %esp,%ebp
80107d10:	56                   	push   %esi
80107d11:	53                   	push   %ebx
  pushcli();
80107d12:	e8 7a d3 ff ff       	call   80105091 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107d17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d1d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d24:	83 c2 08             	add    $0x8,%edx
80107d27:	89 d6                	mov    %edx,%esi
80107d29:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d30:	83 c2 08             	add    $0x8,%edx
80107d33:	c1 ea 10             	shr    $0x10,%edx
80107d36:	89 d3                	mov    %edx,%ebx
80107d38:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d3f:	83 c2 08             	add    $0x8,%edx
80107d42:	c1 ea 18             	shr    $0x18,%edx
80107d45:	89 d1                	mov    %edx,%ecx
80107d47:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107d4e:	67 00 
80107d50:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107d57:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107d5d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107d64:	83 e2 f0             	and    $0xfffffff0,%edx
80107d67:	83 ca 09             	or     $0x9,%edx
80107d6a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d70:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107d77:	83 ca 10             	or     $0x10,%edx
80107d7a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d80:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107d87:	83 e2 9f             	and    $0xffffff9f,%edx
80107d8a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d90:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107d97:	83 ca 80             	or     $0xffffff80,%edx
80107d9a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107da0:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107da7:	83 e2 f0             	and    $0xfffffff0,%edx
80107daa:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107db0:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107db7:	83 e2 ef             	and    $0xffffffef,%edx
80107dba:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107dc0:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107dc7:	83 e2 df             	and    $0xffffffdf,%edx
80107dca:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107dd0:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107dd7:	83 ca 40             	or     $0x40,%edx
80107dda:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107de0:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107de7:	83 e2 7f             	and    $0x7f,%edx
80107dea:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107df0:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107df6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dfc:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e03:	83 e2 ef             	and    $0xffffffef,%edx
80107e06:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107e0c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e12:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107e18:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e1e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107e25:	8b 52 08             	mov    0x8(%edx),%edx
80107e28:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e2e:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107e31:	83 ec 0c             	sub    $0xc,%esp
80107e34:	6a 30                	push   $0x30
80107e36:	e8 f7 f7 ff ff       	call   80107632 <ltr>
80107e3b:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e41:	8b 40 04             	mov    0x4(%eax),%eax
80107e44:	85 c0                	test   %eax,%eax
80107e46:	75 0d                	jne    80107e55 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80107e48:	83 ec 0c             	sub    $0xc,%esp
80107e4b:	68 fb 89 10 80       	push   $0x801089fb
80107e50:	e8 07 87 ff ff       	call   8010055c <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107e55:	8b 45 08             	mov    0x8(%ebp),%eax
80107e58:	8b 40 04             	mov    0x4(%eax),%eax
80107e5b:	83 ec 0c             	sub    $0xc,%esp
80107e5e:	50                   	push   %eax
80107e5f:	e8 04 f8 ff ff       	call   80107668 <v2p>
80107e64:	83 c4 10             	add    $0x10,%esp
80107e67:	83 ec 0c             	sub    $0xc,%esp
80107e6a:	50                   	push   %eax
80107e6b:	e8 ed f7 ff ff       	call   8010765d <lcr3>
80107e70:	83 c4 10             	add    $0x10,%esp
  popcli();
80107e73:	e8 5d d2 ff ff       	call   801050d5 <popcli>
}
80107e78:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e7b:	5b                   	pop    %ebx
80107e7c:	5e                   	pop    %esi
80107e7d:	5d                   	pop    %ebp
80107e7e:	c3                   	ret    

80107e7f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107e7f:	55                   	push   %ebp
80107e80:	89 e5                	mov    %esp,%ebp
80107e82:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107e85:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107e8c:	76 0d                	jbe    80107e9b <inituvm+0x1c>
    panic("inituvm: more than a page");
80107e8e:	83 ec 0c             	sub    $0xc,%esp
80107e91:	68 0f 8a 10 80       	push   $0x80108a0f
80107e96:	e8 c1 86 ff ff       	call   8010055c <panic>
  mem = kalloc();
80107e9b:	e8 2d ad ff ff       	call   80102bcd <kalloc>
80107ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ea3:	83 ec 04             	sub    $0x4,%esp
80107ea6:	68 00 10 00 00       	push   $0x1000
80107eab:	6a 00                	push   $0x0
80107ead:	ff 75 f4             	pushl  -0xc(%ebp)
80107eb0:	e8 de d2 ff ff       	call   80105193 <memset>
80107eb5:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107eb8:	83 ec 0c             	sub    $0xc,%esp
80107ebb:	ff 75 f4             	pushl  -0xc(%ebp)
80107ebe:	e8 a5 f7 ff ff       	call   80107668 <v2p>
80107ec3:	83 c4 10             	add    $0x10,%esp
80107ec6:	83 ec 0c             	sub    $0xc,%esp
80107ec9:	6a 06                	push   $0x6
80107ecb:	50                   	push   %eax
80107ecc:	68 00 10 00 00       	push   $0x1000
80107ed1:	6a 00                	push   $0x0
80107ed3:	ff 75 08             	pushl  0x8(%ebp)
80107ed6:	e8 bb fc ff ff       	call   80107b96 <mappages>
80107edb:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107ede:	83 ec 04             	sub    $0x4,%esp
80107ee1:	ff 75 10             	pushl  0x10(%ebp)
80107ee4:	ff 75 0c             	pushl  0xc(%ebp)
80107ee7:	ff 75 f4             	pushl  -0xc(%ebp)
80107eea:	e8 63 d3 ff ff       	call   80105252 <memmove>
80107eef:	83 c4 10             	add    $0x10,%esp
}
80107ef2:	c9                   	leave  
80107ef3:	c3                   	ret    

80107ef4 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107ef4:	55                   	push   %ebp
80107ef5:	89 e5                	mov    %esp,%ebp
80107ef7:	53                   	push   %ebx
80107ef8:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107efb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107efe:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f03:	85 c0                	test   %eax,%eax
80107f05:	74 0d                	je     80107f14 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107f07:	83 ec 0c             	sub    $0xc,%esp
80107f0a:	68 2c 8a 10 80       	push   $0x80108a2c
80107f0f:	e8 48 86 ff ff       	call   8010055c <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f1b:	e9 95 00 00 00       	jmp    80107fb5 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f20:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f26:	01 d0                	add    %edx,%eax
80107f28:	83 ec 04             	sub    $0x4,%esp
80107f2b:	6a 00                	push   $0x0
80107f2d:	50                   	push   %eax
80107f2e:	ff 75 08             	pushl  0x8(%ebp)
80107f31:	e8 c0 fb ff ff       	call   80107af6 <walkpgdir>
80107f36:	83 c4 10             	add    $0x10,%esp
80107f39:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f40:	75 0d                	jne    80107f4f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80107f42:	83 ec 0c             	sub    $0xc,%esp
80107f45:	68 4f 8a 10 80       	push   $0x80108a4f
80107f4a:	e8 0d 86 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
80107f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f52:	8b 00                	mov    (%eax),%eax
80107f54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f59:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f5c:	8b 45 18             	mov    0x18(%ebp),%eax
80107f5f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f62:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f67:	77 0b                	ja     80107f74 <loaduvm+0x80>
      n = sz - i;
80107f69:	8b 45 18             	mov    0x18(%ebp),%eax
80107f6c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f72:	eb 07                	jmp    80107f7b <loaduvm+0x87>
    else
      n = PGSIZE;
80107f74:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107f7b:	8b 55 14             	mov    0x14(%ebp),%edx
80107f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f81:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107f84:	83 ec 0c             	sub    $0xc,%esp
80107f87:	ff 75 e8             	pushl  -0x18(%ebp)
80107f8a:	e8 e6 f6 ff ff       	call   80107675 <p2v>
80107f8f:	83 c4 10             	add    $0x10,%esp
80107f92:	ff 75 f0             	pushl  -0x10(%ebp)
80107f95:	53                   	push   %ebx
80107f96:	50                   	push   %eax
80107f97:	ff 75 10             	pushl  0x10(%ebp)
80107f9a:	e8 9d 9e ff ff       	call   80101e3c <readi>
80107f9f:	83 c4 10             	add    $0x10,%esp
80107fa2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fa5:	74 07                	je     80107fae <loaduvm+0xba>
      return -1;
80107fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fac:	eb 18                	jmp    80107fc6 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107fae:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb8:	3b 45 18             	cmp    0x18(%ebp),%eax
80107fbb:	0f 82 5f ff ff ff    	jb     80107f20 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fc9:	c9                   	leave  
80107fca:	c3                   	ret    

80107fcb <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107fcb:	55                   	push   %ebp
80107fcc:	89 e5                	mov    %esp,%ebp
80107fce:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107fd1:	8b 45 10             	mov    0x10(%ebp),%eax
80107fd4:	85 c0                	test   %eax,%eax
80107fd6:	79 0a                	jns    80107fe2 <allocuvm+0x17>
    return 0;
80107fd8:	b8 00 00 00 00       	mov    $0x0,%eax
80107fdd:	e9 b0 00 00 00       	jmp    80108092 <allocuvm+0xc7>
  if(newsz < oldsz)
80107fe2:	8b 45 10             	mov    0x10(%ebp),%eax
80107fe5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fe8:	73 08                	jae    80107ff2 <allocuvm+0x27>
    return oldsz;
80107fea:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fed:	e9 a0 00 00 00       	jmp    80108092 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80107ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ff5:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ffa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108002:	eb 7f                	jmp    80108083 <allocuvm+0xb8>
    mem = kalloc();
80108004:	e8 c4 ab ff ff       	call   80102bcd <kalloc>
80108009:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010800c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108010:	75 2b                	jne    8010803d <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108012:	83 ec 0c             	sub    $0xc,%esp
80108015:	68 6d 8a 10 80       	push   $0x80108a6d
8010801a:	e8 a0 83 ff ff       	call   801003bf <cprintf>
8010801f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108022:	83 ec 04             	sub    $0x4,%esp
80108025:	ff 75 0c             	pushl  0xc(%ebp)
80108028:	ff 75 10             	pushl  0x10(%ebp)
8010802b:	ff 75 08             	pushl  0x8(%ebp)
8010802e:	e8 61 00 00 00       	call   80108094 <deallocuvm>
80108033:	83 c4 10             	add    $0x10,%esp
      return 0;
80108036:	b8 00 00 00 00       	mov    $0x0,%eax
8010803b:	eb 55                	jmp    80108092 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010803d:	83 ec 04             	sub    $0x4,%esp
80108040:	68 00 10 00 00       	push   $0x1000
80108045:	6a 00                	push   $0x0
80108047:	ff 75 f0             	pushl  -0x10(%ebp)
8010804a:	e8 44 d1 ff ff       	call   80105193 <memset>
8010804f:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108052:	83 ec 0c             	sub    $0xc,%esp
80108055:	ff 75 f0             	pushl  -0x10(%ebp)
80108058:	e8 0b f6 ff ff       	call   80107668 <v2p>
8010805d:	83 c4 10             	add    $0x10,%esp
80108060:	89 c2                	mov    %eax,%edx
80108062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108065:	83 ec 0c             	sub    $0xc,%esp
80108068:	6a 06                	push   $0x6
8010806a:	52                   	push   %edx
8010806b:	68 00 10 00 00       	push   $0x1000
80108070:	50                   	push   %eax
80108071:	ff 75 08             	pushl  0x8(%ebp)
80108074:	e8 1d fb ff ff       	call   80107b96 <mappages>
80108079:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010807c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108086:	3b 45 10             	cmp    0x10(%ebp),%eax
80108089:	0f 82 75 ff ff ff    	jb     80108004 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010808f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108092:	c9                   	leave  
80108093:	c3                   	ret    

80108094 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108094:	55                   	push   %ebp
80108095:	89 e5                	mov    %esp,%ebp
80108097:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010809a:	8b 45 10             	mov    0x10(%ebp),%eax
8010809d:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080a0:	72 08                	jb     801080aa <deallocuvm+0x16>
    return oldsz;
801080a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a5:	e9 a5 00 00 00       	jmp    8010814f <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801080aa:	8b 45 10             	mov    0x10(%ebp),%eax
801080ad:	05 ff 0f 00 00       	add    $0xfff,%eax
801080b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801080ba:	e9 81 00 00 00       	jmp    80108140 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	83 ec 04             	sub    $0x4,%esp
801080c5:	6a 00                	push   $0x0
801080c7:	50                   	push   %eax
801080c8:	ff 75 08             	pushl  0x8(%ebp)
801080cb:	e8 26 fa ff ff       	call   80107af6 <walkpgdir>
801080d0:	83 c4 10             	add    $0x10,%esp
801080d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801080d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080da:	75 09                	jne    801080e5 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801080dc:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801080e3:	eb 54                	jmp    80108139 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801080e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080e8:	8b 00                	mov    (%eax),%eax
801080ea:	83 e0 01             	and    $0x1,%eax
801080ed:	85 c0                	test   %eax,%eax
801080ef:	74 48                	je     80108139 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801080f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f4:	8b 00                	mov    (%eax),%eax
801080f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801080fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108102:	75 0d                	jne    80108111 <deallocuvm+0x7d>
        panic("kfree");
80108104:	83 ec 0c             	sub    $0xc,%esp
80108107:	68 85 8a 10 80       	push   $0x80108a85
8010810c:	e8 4b 84 ff ff       	call   8010055c <panic>
      char *v = p2v(pa);
80108111:	83 ec 0c             	sub    $0xc,%esp
80108114:	ff 75 ec             	pushl  -0x14(%ebp)
80108117:	e8 59 f5 ff ff       	call   80107675 <p2v>
8010811c:	83 c4 10             	add    $0x10,%esp
8010811f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108122:	83 ec 0c             	sub    $0xc,%esp
80108125:	ff 75 e8             	pushl  -0x18(%ebp)
80108128:	e8 04 aa ff ff       	call   80102b31 <kfree>
8010812d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108130:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108139:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108143:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108146:	0f 82 73 ff ff ff    	jb     801080bf <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010814c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010814f:	c9                   	leave  
80108150:	c3                   	ret    

80108151 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108151:	55                   	push   %ebp
80108152:	89 e5                	mov    %esp,%ebp
80108154:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010815b:	75 0d                	jne    8010816a <freevm+0x19>
    panic("freevm: no pgdir");
8010815d:	83 ec 0c             	sub    $0xc,%esp
80108160:	68 8b 8a 10 80       	push   $0x80108a8b
80108165:	e8 f2 83 ff ff       	call   8010055c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010816a:	83 ec 04             	sub    $0x4,%esp
8010816d:	6a 00                	push   $0x0
8010816f:	68 00 00 00 80       	push   $0x80000000
80108174:	ff 75 08             	pushl  0x8(%ebp)
80108177:	e8 18 ff ff ff       	call   80108094 <deallocuvm>
8010817c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010817f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108186:	eb 4f                	jmp    801081d7 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108192:	8b 45 08             	mov    0x8(%ebp),%eax
80108195:	01 d0                	add    %edx,%eax
80108197:	8b 00                	mov    (%eax),%eax
80108199:	83 e0 01             	and    $0x1,%eax
8010819c:	85 c0                	test   %eax,%eax
8010819e:	74 33                	je     801081d3 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801081a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081aa:	8b 45 08             	mov    0x8(%ebp),%eax
801081ad:	01 d0                	add    %edx,%eax
801081af:	8b 00                	mov    (%eax),%eax
801081b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081b6:	83 ec 0c             	sub    $0xc,%esp
801081b9:	50                   	push   %eax
801081ba:	e8 b6 f4 ff ff       	call   80107675 <p2v>
801081bf:	83 c4 10             	add    $0x10,%esp
801081c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801081c5:	83 ec 0c             	sub    $0xc,%esp
801081c8:	ff 75 f0             	pushl  -0x10(%ebp)
801081cb:	e8 61 a9 ff ff       	call   80102b31 <kfree>
801081d0:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801081d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801081d7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801081de:	76 a8                	jbe    80108188 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801081e0:	83 ec 0c             	sub    $0xc,%esp
801081e3:	ff 75 08             	pushl  0x8(%ebp)
801081e6:	e8 46 a9 ff ff       	call   80102b31 <kfree>
801081eb:	83 c4 10             	add    $0x10,%esp
}
801081ee:	c9                   	leave  
801081ef:	c3                   	ret    

801081f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801081f0:	55                   	push   %ebp
801081f1:	89 e5                	mov    %esp,%ebp
801081f3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081f6:	83 ec 04             	sub    $0x4,%esp
801081f9:	6a 00                	push   $0x0
801081fb:	ff 75 0c             	pushl  0xc(%ebp)
801081fe:	ff 75 08             	pushl  0x8(%ebp)
80108201:	e8 f0 f8 ff ff       	call   80107af6 <walkpgdir>
80108206:	83 c4 10             	add    $0x10,%esp
80108209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010820c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108210:	75 0d                	jne    8010821f <clearpteu+0x2f>
    panic("clearpteu");
80108212:	83 ec 0c             	sub    $0xc,%esp
80108215:	68 9c 8a 10 80       	push   $0x80108a9c
8010821a:	e8 3d 83 ff ff       	call   8010055c <panic>
  *pte &= ~PTE_U;
8010821f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108222:	8b 00                	mov    (%eax),%eax
80108224:	83 e0 fb             	and    $0xfffffffb,%eax
80108227:	89 c2                	mov    %eax,%edx
80108229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822c:	89 10                	mov    %edx,(%eax)
}
8010822e:	c9                   	leave  
8010822f:	c3                   	ret    

80108230 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108230:	55                   	push   %ebp
80108231:	89 e5                	mov    %esp,%ebp
80108233:	53                   	push   %ebx
80108234:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108237:	e8 ec f9 ff ff       	call   80107c28 <setupkvm>
8010823c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010823f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108243:	75 0a                	jne    8010824f <copyuvm+0x1f>
    return 0;
80108245:	b8 00 00 00 00       	mov    $0x0,%eax
8010824a:	e9 f8 00 00 00       	jmp    80108347 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010824f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108256:	e9 c8 00 00 00       	jmp    80108323 <copyuvm+0xf3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010825b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825e:	83 ec 04             	sub    $0x4,%esp
80108261:	6a 00                	push   $0x0
80108263:	50                   	push   %eax
80108264:	ff 75 08             	pushl  0x8(%ebp)
80108267:	e8 8a f8 ff ff       	call   80107af6 <walkpgdir>
8010826c:	83 c4 10             	add    $0x10,%esp
8010826f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108272:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108276:	75 0d                	jne    80108285 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108278:	83 ec 0c             	sub    $0xc,%esp
8010827b:	68 a6 8a 10 80       	push   $0x80108aa6
80108280:	e8 d7 82 ff ff       	call   8010055c <panic>
    if(!(*pte & PTE_P))
80108285:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108288:	8b 00                	mov    (%eax),%eax
8010828a:	83 e0 01             	and    $0x1,%eax
8010828d:	85 c0                	test   %eax,%eax
8010828f:	75 0d                	jne    8010829e <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108291:	83 ec 0c             	sub    $0xc,%esp
80108294:	68 c0 8a 10 80       	push   $0x80108ac0
80108299:	e8 be 82 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
8010829e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082a1:	8b 00                	mov    (%eax),%eax
801082a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801082ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082ae:	8b 00                	mov    (%eax),%eax
801082b0:	25 ff 0f 00 00       	and    $0xfff,%eax
801082b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801082b8:	e8 10 a9 ff ff       	call   80102bcd <kalloc>
801082bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801082c4:	75 02                	jne    801082c8 <copyuvm+0x98>
      goto bad;
801082c6:	eb 6c                	jmp    80108334 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
801082c8:	83 ec 0c             	sub    $0xc,%esp
801082cb:	ff 75 e8             	pushl  -0x18(%ebp)
801082ce:	e8 a2 f3 ff ff       	call   80107675 <p2v>
801082d3:	83 c4 10             	add    $0x10,%esp
801082d6:	83 ec 04             	sub    $0x4,%esp
801082d9:	68 00 10 00 00       	push   $0x1000
801082de:	50                   	push   %eax
801082df:	ff 75 e0             	pushl  -0x20(%ebp)
801082e2:	e8 6b cf ff ff       	call   80105252 <memmove>
801082e7:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801082ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801082ed:	83 ec 0c             	sub    $0xc,%esp
801082f0:	ff 75 e0             	pushl  -0x20(%ebp)
801082f3:	e8 70 f3 ff ff       	call   80107668 <v2p>
801082f8:	83 c4 10             	add    $0x10,%esp
801082fb:	89 c2                	mov    %eax,%edx
801082fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108300:	83 ec 0c             	sub    $0xc,%esp
80108303:	53                   	push   %ebx
80108304:	52                   	push   %edx
80108305:	68 00 10 00 00       	push   $0x1000
8010830a:	50                   	push   %eax
8010830b:	ff 75 f0             	pushl  -0x10(%ebp)
8010830e:	e8 83 f8 ff ff       	call   80107b96 <mappages>
80108313:	83 c4 20             	add    $0x20,%esp
80108316:	85 c0                	test   %eax,%eax
80108318:	79 02                	jns    8010831c <copyuvm+0xec>
      goto bad;
8010831a:	eb 18                	jmp    80108334 <copyuvm+0x104>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010831c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108326:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108329:	0f 82 2c ff ff ff    	jb     8010825b <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010832f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108332:	eb 13                	jmp    80108347 <copyuvm+0x117>

bad:
  freevm(d);
80108334:	83 ec 0c             	sub    $0xc,%esp
80108337:	ff 75 f0             	pushl  -0x10(%ebp)
8010833a:	e8 12 fe ff ff       	call   80108151 <freevm>
8010833f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108342:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010834a:	c9                   	leave  
8010834b:	c3                   	ret    

8010834c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010834c:	55                   	push   %ebp
8010834d:	89 e5                	mov    %esp,%ebp
8010834f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108352:	83 ec 04             	sub    $0x4,%esp
80108355:	6a 00                	push   $0x0
80108357:	ff 75 0c             	pushl  0xc(%ebp)
8010835a:	ff 75 08             	pushl  0x8(%ebp)
8010835d:	e8 94 f7 ff ff       	call   80107af6 <walkpgdir>
80108362:	83 c4 10             	add    $0x10,%esp
80108365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836b:	8b 00                	mov    (%eax),%eax
8010836d:	83 e0 01             	and    $0x1,%eax
80108370:	85 c0                	test   %eax,%eax
80108372:	75 07                	jne    8010837b <uva2ka+0x2f>
    return 0;
80108374:	b8 00 00 00 00       	mov    $0x0,%eax
80108379:	eb 29                	jmp    801083a4 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010837b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837e:	8b 00                	mov    (%eax),%eax
80108380:	83 e0 04             	and    $0x4,%eax
80108383:	85 c0                	test   %eax,%eax
80108385:	75 07                	jne    8010838e <uva2ka+0x42>
    return 0;
80108387:	b8 00 00 00 00       	mov    $0x0,%eax
8010838c:	eb 16                	jmp    801083a4 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010838e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108391:	8b 00                	mov    (%eax),%eax
80108393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108398:	83 ec 0c             	sub    $0xc,%esp
8010839b:	50                   	push   %eax
8010839c:	e8 d4 f2 ff ff       	call   80107675 <p2v>
801083a1:	83 c4 10             	add    $0x10,%esp
}
801083a4:	c9                   	leave  
801083a5:	c3                   	ret    

801083a6 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083a6:	55                   	push   %ebp
801083a7:	89 e5                	mov    %esp,%ebp
801083a9:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801083ac:	8b 45 10             	mov    0x10(%ebp),%eax
801083af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801083b2:	eb 7f                	jmp    80108433 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801083b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801083b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801083bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083c2:	83 ec 08             	sub    $0x8,%esp
801083c5:	50                   	push   %eax
801083c6:	ff 75 08             	pushl  0x8(%ebp)
801083c9:	e8 7e ff ff ff       	call   8010834c <uva2ka>
801083ce:	83 c4 10             	add    $0x10,%esp
801083d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801083d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801083d8:	75 07                	jne    801083e1 <copyout+0x3b>
      return -1;
801083da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083df:	eb 61                	jmp    80108442 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801083e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083e4:	2b 45 0c             	sub    0xc(%ebp),%eax
801083e7:	05 00 10 00 00       	add    $0x1000,%eax
801083ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801083ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083f2:	3b 45 14             	cmp    0x14(%ebp),%eax
801083f5:	76 06                	jbe    801083fd <copyout+0x57>
      n = len;
801083f7:	8b 45 14             	mov    0x14(%ebp),%eax
801083fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801083fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108400:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108403:	89 c2                	mov    %eax,%edx
80108405:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108408:	01 d0                	add    %edx,%eax
8010840a:	83 ec 04             	sub    $0x4,%esp
8010840d:	ff 75 f0             	pushl  -0x10(%ebp)
80108410:	ff 75 f4             	pushl  -0xc(%ebp)
80108413:	50                   	push   %eax
80108414:	e8 39 ce ff ff       	call   80105252 <memmove>
80108419:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010841c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010841f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108422:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108425:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108428:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010842b:	05 00 10 00 00       	add    $0x1000,%eax
80108430:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108433:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108437:	0f 85 77 ff ff ff    	jne    801083b4 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010843d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108442:	c9                   	leave  
80108443:	c3                   	ret    
