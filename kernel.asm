
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 75 10 80       	push   $0x80107500
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 d5 46 00 00       	call   80104730 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 75 10 80       	push   $0x80107507
80100097:	50                   	push   %eax
80100098:	e8 63 45 00 00       	call   80104600 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 87 47 00 00       	call   80104870 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 c9 47 00 00       	call   80104930 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 44 00 00       	call   80104640 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 75 10 80       	push   $0x8010750e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 2d 45 00 00       	call   801046e0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 75 10 80       	push   $0x8010751f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ec 44 00 00       	call   801046e0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 44 00 00       	call   801046a0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 60 46 00 00       	call   80104870 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 cf 46 00 00       	jmp    80104930 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 75 10 80       	push   $0x80107526
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 df 45 00 00       	call   80104870 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 76 3b 00 00       	call   80103e40 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 35 00 00       	call   80103800 <myproc>
801002e0:	8b 40 38             	mov    0x38(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 3c 46 00 00       	call   80104930 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 de 45 00 00       	call   80104930 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 75 10 80       	push   $0x8010752d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 e3 7e 10 80 	movl   $0x80107ee3,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 43 00 00       	call   80104750 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 75 10 80       	push   $0x80107541
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 c1 5c 00 00       	call   80106100 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 0f 5c 00 00       	call   80106100 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 5c 00 00       	call   80106100 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 5b 00 00       	call   80106100 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 07 45 00 00       	call   80104a30 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 3a 44 00 00       	call   80104980 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 75 10 80       	push   $0x80107545
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 70 75 10 80 	movzbl -0x7fef8a90(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 50 42 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 e4 42 00 00       	call   80104930 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 0c 42 00 00       	call   80104930 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 58 75 10 80       	mov    $0x80107558,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 7b 40 00 00       	call   80104870 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 75 10 80       	push   $0x8010755f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 48 40 00 00       	call   80104870 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 a3 40 00 00       	call   80104930 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 e5 35 00 00       	call   80103f00 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 84 3a 00 00       	jmp    80104420 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 68 75 10 80       	push   $0x80107568
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 5b 3d 00 00       	call   80104730 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 df 2d 00 00       	call   80103800 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 b7 67 00 00       	call   80107250 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8e 02 00 00    	je     80100d4d <exec+0x33d>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 75 65 00 00       	call   80107070 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 83 64 00 00       	call   80106fb0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 59 66 00 00       	call   801071d0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 c1 64 00 00       	call   80107070 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 0a 66 00 00       	call   801071d0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 75 10 80       	push   $0x80107581
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 e5 66 00 00       	call   801072f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 62 3f 00 00       	call   80104ba0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 4f 3f 00 00       	call   80104ba0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ee 67 00 00       	call   80107450 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 84 67 00 00       	call   80107450 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	05 88 00 00 00       	add    $0x88,%eax
80100d0b:	50                   	push   %eax
80100d0c:	e8 4f 3e 00 00       	call   80104b60 <safestrcpy>
  curproc->pgdir = pgdir;
80100d11:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d17:	89 f9                	mov    %edi,%ecx
80100d19:	8b 7f 14             	mov    0x14(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1c:	8b 41 2c             	mov    0x2c(%ecx),%eax
  curproc->sz = sz;
80100d1f:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d21:	89 51 14             	mov    %edx,0x14(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d24:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d2a:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2d:	8b 41 2c             	mov    0x2c(%ecx),%eax
80100d30:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d33:	89 0c 24             	mov    %ecx,(%esp)
80100d36:	e8 e5 60 00 00       	call   80106e20 <switchuvm>
  freevm(oldpgdir);
80100d3b:	89 3c 24             	mov    %edi,(%esp)
80100d3e:	e8 8d 64 00 00       	call   801071d0 <freevm>
  return 0;
80100d43:	83 c4 10             	add    $0x10,%esp
80100d46:	31 c0                	xor    %eax,%eax
80100d48:	e9 2f fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4d:	be 00 20 00 00       	mov    $0x2000,%esi
80100d52:	e9 3a fe ff ff       	jmp    80100b91 <exec+0x181>
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 8d 75 10 80       	push   $0x8010758d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 bb 39 00 00       	call   80104730 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 da 3a 00 00       	call   80104870 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 6a 3b 00 00       	call   80104930 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 51 3b 00 00       	call   80104930 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 6c 3a 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 0f 3b 00 00       	call   80104930 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 94 75 10 80       	push   $0x80107594
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 1a 3a 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 af 3a 00 00       	jmp    80104930 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 83 3a 00 00       	call   80104930 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 9c 75 10 80       	push   $0x8010759c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 a6 75 10 80       	push   $0x801075a6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 af 75 10 80       	push   $0x801075af
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 b5 75 10 80       	push   $0x801075b5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 bf 75 10 80       	push   $0x801075bf
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 d2 75 10 80       	push   $0x801075d2
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 16 37 00 00       	call   80104980 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 c1 35 00 00       	call   80104870 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 e0 09 11 80       	push   $0x801109e0
8010130f:	e8 1c 36 00 00       	call   80104930 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 ee 35 00 00       	call   80104930 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 e8 75 10 80       	push   $0x801075e8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 f8 75 10 80       	push   $0x801075f8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 ca 35 00 00       	call   80104a30 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 0b 76 10 80       	push   $0x8010760b
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 95 32 00 00       	call   80104730 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 12 76 10 80       	push   $0x80107612
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 4c 31 00 00       	call   80104600 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 c0 09 11 80       	push   $0x801109c0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014d5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014db:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014e1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014e7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ed:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014f3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014f9:	68 78 76 10 80       	push   $0x80107678
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 ed 33 00 00       	call   80104980 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 18 76 10 80       	push   $0x80107618
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 fa 33 00 00       	call   80104a30 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 e0 09 11 80       	push   $0x801109e0
8010165f:	e8 0c 32 00 00       	call   80104870 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 bc 32 00 00       	call   80104930 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 99 2f 00 00       	call   80104640 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 13 33 00 00       	call   80104a30 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 30 76 10 80       	push   $0x80107630
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 2a 76 10 80       	push   $0x8010762a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 68 2f 00 00       	call   801046e0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 0c 2f 00 00       	jmp    801046a0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 3f 76 10 80       	push   $0x8010763f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 7b 2e 00 00       	call   80104640 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 c1 2e 00 00       	call   801046a0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 85 30 00 00       	call   80104870 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 2b 31 00 00       	jmp    80104930 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 5b 30 00 00       	call   80104870 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 0c 31 00 00       	call   80104930 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 24 30 00 00       	call   80104a30 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 28 2f 00 00       	call   80104a30 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 fd 2e 00 00       	call   80104aa0 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 9e 2e 00 00       	call   80104aa0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 59 76 10 80       	push   $0x80107659
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 47 76 10 80       	push   $0x80107647
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 82 1b 00 00       	call   80103800 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 7c             	mov    0x7c(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 e0 09 11 80       	push   $0x801109e0
80101c89:	e8 e2 2b 00 00       	call   80104870 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c99:	e8 92 2c 00 00       	call   80104930 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 36 2d 00 00       	call   80104a30 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 a3 2c 00 00       	call   80104a30 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 7e 2c 00 00       	call   80104b00 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 68 76 10 80       	push   $0x80107668
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ca 7c 10 80       	push   $0x80107cca
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 d4 76 10 80       	push   $0x801076d4
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 cb 76 10 80       	push   $0x801076cb
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 e6 76 10 80       	push   $0x801076e6
8010200b:	68 80 a5 10 80       	push   $0x8010a580
80102010:	e8 1b 27 00 00       	call   80104730 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 a5 10 80       	push   $0x8010a580
8010208e:	e8 dd 27 00 00       	call   80104870 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 0a 1e 00 00       	call   80103f00 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 a5 10 80       	push   $0x8010a580
8010210f:	e8 1c 28 00 00       	call   80104930 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 ad 25 00 00       	call   801046e0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 a5 10 80       	push   $0x8010a580
80102168:	e8 03 27 00 00       	call   80104870 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 a5 10 80       	push   $0x8010a580
801021b8:	53                   	push   %ebx
801021b9:	e8 82 1c 00 00       	call   80103e40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 55 27 00 00       	jmp    80104930 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 00 77 10 80       	push   $0x80107700
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 ea 76 10 80       	push   $0x801076ea
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 15 77 10 80       	push   $0x80107715
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 34 26 11 80       	mov    0x80112634,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 34 77 10 80       	push   $0x80107734
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb c8 5b 11 80    	cmp    $0x80115bc8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 39 26 00 00       	call   80104980 <memset>

  if(kmem.use_lock)
80102347:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 78 26 11 80       	mov    0x80112678,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102360:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 b0 25 00 00       	jmp    80104930 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 40 26 11 80       	push   $0x80112640
80102388:	e8 e3 24 00 00       	call   80104870 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 66 77 10 80       	push   $0x80107766
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 6c 77 10 80       	push   $0x8010776c
80102400:	68 40 26 11 80       	push   $0x80112640
80102405:	e8 26 23 00 00       	call   80104730 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 74 26 11 80       	mov    0x80112674,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 40 26 11 80       	push   $0x80112640
801024f3:	e8 78 23 00 00       	call   80104870 <acquire>
  r = kmem.freelist;
801024f8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 40 26 11 80       	push   $0x80112640
80102521:	e8 0a 24 00 00       	call   80104930 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 94 20 00 00       	call   801049d0 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a44:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 c7 1f 00 00       	call   80104a30 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102aae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 a0 79 10 80       	push   $0x801079a0
80102b0f:	68 80 26 11 80       	push   $0x80112680
80102b14:	e8 17 1c 00 00       	call   80104730 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b32:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b38:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 80 26 11 80       	push   $0x80112680
80102bab:	e8 c0 1c 00 00       	call   80104870 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 80 26 11 80       	push   $0x80112680
80102bc0:	68 80 26 11 80       	push   $0x80112680
80102bc5:	e8 76 12 00 00       	call   80103e40 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102bdb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102bf7:	68 80 26 11 80       	push   $0x80112680
80102bfc:	e8 2f 1d 00 00       	call   80104930 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 80 26 11 80       	push   $0x80112680
80102c1e:	e8 4d 1c 00 00       	call   80104870 <acquire>
  log.outstanding -= 1;
80102c23:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c28:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 80 26 11 80       	push   $0x80112680
80102c5c:	e8 cf 1c 00 00       	call   80104930 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c96:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 75 1d 00 00       	call   80104a30 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 80 26 11 80       	push   $0x80112680
80102cff:	e8 6c 1b 00 00       	call   80104870 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d0b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 e6 11 00 00       	call   80103f00 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d21:	e8 0a 1c 00 00       	call   80104930 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 80 26 11 80       	push   $0x80112680
80102d40:	e8 bb 11 00 00       	call   80103f00 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d4c:	e8 df 1b 00 00       	call   80104930 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 a4 79 10 80       	push   $0x801079a4
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 80 26 11 80       	push   $0x80112680
80102dae:	e8 bd 1a 00 00       	call   80104870 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 2e 1b 00 00       	jmp    80104930 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 b3 79 10 80       	push   $0x801079b3
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 c9 79 10 80       	push   $0x801079c9
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 94 09 00 00       	call   801037e0 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 8d 09 00 00       	call   801037e0 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 e4 79 10 80       	push   $0x801079e4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 59 2e 00 00       	call   80105cc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 f4 08 00 00       	call   80103760 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 d1 0c 00 00       	call   80103b50 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 75 3f 00 00       	call   80106e00 <switchkvm>
  seginit();
80102e8b:	e8 e0 3e 00 00       	call   80106d70 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 c8 5b 11 80       	push   $0x80115bc8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 0a 44 00 00       	call   801072d0 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 9b 3e 00 00       	call   80106d70 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 57 31 00 00       	call   80106040 <uartinit>
  pinit();         // process table
80102ee9:	e8 52 08 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 4d 2d 00 00       	call   80105c40 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 8c a4 10 80       	push   $0x8010a48c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 17 1b 00 00       	call   80104a30 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 80 27 11 80       	add    $0x80112780,%eax
80102f2b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 1b 08 00 00       	call   80103760 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f64:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 76 08 00 00       	call   80103830 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 f8 79 10 80       	push   $0x801079f8
80102ff3:	56                   	push   %esi
80102ff4:	e8 d7 19 00 00       	call   801049d0 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 15 7a 10 80       	push   $0x80107a15
801030b1:	56                   	push   %esi
801030b2:	e8 19 19 00 00       	call   801049d0 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 3c 7a 10 80 	jmp    *-0x7fef85c4(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 fd 79 10 80       	push   $0x801079fd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 1c 7a 10 80       	push   $0x80107a1c
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 50 7a 10 80       	push   $0x80107a50
80103300:	50                   	push   %eax
80103301:	e8 2a 14 00 00       	call   80104730 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 0c 15 00 00       	call   80104870 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 7c 0b 00 00       	call   80103f00 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 87 15 00 00       	jmp    80104930 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 37 0b 00 00       	call   80103f00 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 57 15 00 00       	call   80104930 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 6e 14 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 a7 0a 00 00       	call   80103f00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 de 09 00 00       	call   80103e40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 77 03 00 00       	call   80103800 <myproc>
80103489:	8b 40 38             	mov    0x38(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 97 14 00 00       	call   80104930 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 18 0a 00 00       	call   80103f00 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 40 14 00 00       	call   80104930 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 5b 13 00 00       	call   80104870 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 f6 08 00 00       	call   80103e40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 92 02 00 00       	call   80103800 <myproc>
8010356e:	8b 48 38             	mov    0x38(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 ad 13 00 00       	call   80104930 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 24 09 00 00       	call   80103f00 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 4c 13 00 00       	call   80104930 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++)
80103604:	bb 6c 2d 11 80       	mov    $0x80112d6c,%ebx
{
80103609:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010360c:	68 20 2d 11 80       	push   $0x80112d20
80103611:	e8 5a 12 00 00       	call   80104870 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++)
80103620:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103626:	81 fb 6c 53 11 80    	cmp    $0x8011536c,%ebx
8010362c:	0f 83 96 00 00 00    	jae    801036c8 <allocproc+0xc8>
    if(p->state == UNUSED)
80103632:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103639:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = HIGH;
  p->next = 0;
  p->prev = 0;

  release(&ptable.lock);
8010363e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103641:	c7 43 1c 01 00 00 00 	movl   $0x1,0x1c(%ebx)
  p->priority = HIGH;
80103648:	c7 43 20 02 00 00 00 	movl   $0x2,0x20(%ebx)
  p->next = 0;
8010364f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103656:	00 00 00 
  p->prev = 0;
80103659:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103660:	00 00 00 
  p->pid = nextpid++;
80103663:	8d 50 01             	lea    0x1(%eax),%edx
80103666:	89 43 24             	mov    %eax,0x24(%ebx)
  release(&ptable.lock);
80103669:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010366e:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103674:	e8 b7 12 00 00       	call   80104930 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103679:	e8 42 ee ff ff       	call   801024c0 <kalloc>
8010367e:	83 c4 10             	add    $0x10,%esp
80103681:	85 c0                	test   %eax,%eax
80103683:	89 43 18             	mov    %eax,0x18(%ebx)
80103686:	74 59                	je     801036e1 <allocproc+0xe1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103688:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010368e:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103691:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103696:	89 53 2c             	mov    %edx,0x2c(%ebx)
  *(uint*)sp = (uint)trapret;
80103699:	c7 40 14 32 5c 10 80 	movl   $0x80105c32,0x14(%eax)
  p->context = (struct context*)sp;
801036a0:	89 43 30             	mov    %eax,0x30(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036a3:	6a 14                	push   $0x14
801036a5:	6a 00                	push   $0x0
801036a7:	50                   	push   %eax
801036a8:	e8 d3 12 00 00       	call   80104980 <memset>
  p->context->eip = (uint)forkret;
801036ad:	8b 43 30             	mov    0x30(%ebx),%eax

  return p;
801036b0:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036b3:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
}
801036ba:	89 d8                	mov    %ebx,%eax
801036bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036bf:	c9                   	leave  
801036c0:	c3                   	ret    
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801036c8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036cb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036cd:	68 20 2d 11 80       	push   $0x80112d20
801036d2:	e8 59 12 00 00       	call   80104930 <release>
}
801036d7:	89 d8                	mov    %ebx,%eax
  return 0;
801036d9:	83 c4 10             	add    $0x10,%esp
}
801036dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036df:	c9                   	leave  
801036e0:	c3                   	ret    
    p->state = UNUSED;
801036e1:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    return 0;
801036e8:	31 db                	xor    %ebx,%ebx
801036ea:	eb ce                	jmp    801036ba <allocproc+0xba>
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036f6:	68 20 2d 11 80       	push   $0x80112d20
801036fb:	e8 30 12 00 00       	call   80104930 <release>

  if (first) {
80103700:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 04                	jne    80103710 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103710:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103713:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010371a:	00 00 00 
    iinit(ROOTDEV);
8010371d:	6a 01                	push   $0x1
8010371f:	e8 5c dd ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 d0 f3 ff ff       	call   80102b00 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <pinit>:
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103746:	68 55 7a 10 80       	push   $0x80107a55
8010374b:	68 20 2d 11 80       	push   $0x80112d20
80103750:	e8 db 0f 00 00       	call   80104730 <initlock>
}
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	c9                   	leave  
80103759:	c3                   	ret    
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <mycpu>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103765:	9c                   	pushf  
80103766:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103767:	f6 c4 02             	test   $0x2,%ah
8010376a:	75 5e                	jne    801037ca <mycpu+0x6a>
  apicid = lapicid();
8010376c:	e8 bf ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103771:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103777:	85 f6                	test   %esi,%esi
80103779:	7e 42                	jle    801037bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010377b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103782:	39 d0                	cmp    %edx,%eax
80103784:	74 30                	je     801037b6 <mycpu+0x56>
80103786:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010378b:	31 d2                	xor    %edx,%edx
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
80103790:	83 c2 01             	add    $0x1,%edx
80103793:	39 f2                	cmp    %esi,%edx
80103795:	74 26                	je     801037bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103797:	0f b6 19             	movzbl (%ecx),%ebx
8010379a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037a0:	39 c3                	cmp    %eax,%ebx
801037a2:	75 ec                	jne    80103790 <mycpu+0x30>
801037a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037aa:	05 80 27 11 80       	add    $0x80112780,%eax
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037b6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801037bb:	eb f2                	jmp    801037af <mycpu+0x4f>
  panic("unknown apicid\n");
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	68 5c 7a 10 80       	push   $0x80107a5c
801037c5:	e8 c6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	68 74 7b 10 80       	push   $0x80107b74
801037d2:	e8 b9 cb ff ff       	call   80100390 <panic>
801037d7:	89 f6                	mov    %esi,%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <cpuid>:
cpuid() {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037e6:	e8 75 ff ff ff       	call   80103760 <mycpu>
801037eb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
801037f0:	c9                   	leave  
  return mycpu()-cpus;
801037f1:	c1 f8 04             	sar    $0x4,%eax
801037f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037fa:	c3                   	ret    
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <myproc>:
myproc(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103807:	e8 94 0f 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103817:	e8 c4 0f 00 00       	call   801047e0 <popcli>
}
8010381c:	83 c4 04             	add    $0x4,%esp
8010381f:	89 d8                	mov    %ebx,%eax
80103821:	5b                   	pop    %ebx
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <userinit>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
80103834:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103837:	e8 c4 fd ff ff       	call   80103600 <allocproc>
  p->prev = p;
8010383c:	89 80 84 00 00 00    	mov    %eax,0x84(%eax)
  p = allocproc();
80103842:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103844:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103849:	e8 02 3a 00 00       	call   80107250 <setupkvm>
8010384e:	85 c0                	test   %eax,%eax
80103850:	89 43 14             	mov    %eax,0x14(%ebx)
80103853:	0f 84 f7 00 00 00    	je     80103950 <userinit+0x120>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103859:	83 ec 04             	sub    $0x4,%esp
8010385c:	68 2c 00 00 00       	push   $0x2c
80103861:	68 60 a4 10 80       	push   $0x8010a460
80103866:	50                   	push   %eax
80103867:	e8 c4 36 00 00       	call   80106f30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010386c:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010386f:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103875:	6a 4c                	push   $0x4c
80103877:	6a 00                	push   $0x0
80103879:	ff 73 2c             	pushl  0x2c(%ebx)
8010387c:	e8 ff 10 00 00       	call   80104980 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103881:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103884:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103889:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010388e:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103891:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103895:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103898:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010389c:	8b 43 2c             	mov    0x2c(%ebx),%eax
8010389f:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038a3:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038a7:	8b 43 2c             	mov    0x2c(%ebx),%eax
801038aa:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ae:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038b2:	8b 43 2c             	mov    0x2c(%ebx),%eax
801038b5:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038bc:	8b 43 2c             	mov    0x2c(%ebx),%eax
801038bf:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038c6:	8b 43 2c             	mov    0x2c(%ebx),%eax
801038c9:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038d0:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801038d6:	6a 10                	push   $0x10
801038d8:	68 85 7a 10 80       	push   $0x80107a85
801038dd:	50                   	push   %eax
801038de:	e8 7d 12 00 00       	call   80104b60 <safestrcpy>
  p->cwd = namei("/");
801038e3:	c7 04 24 8e 7a 10 80 	movl   $0x80107a8e,(%esp)
801038ea:	e8 f1 e5 ff ff       	call   80101ee0 <namei>
801038ef:	89 43 7c             	mov    %eax,0x7c(%ebx)
  acquire(&ptable.lock);
801038f2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038f9:	e8 72 0f 00 00       	call   80104870 <acquire>
  ptable.heads[HIGH] = initproc;
801038fe:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
  p->state = RUNNABLE;
80103903:	c7 43 1c 03 00 00 00 	movl   $0x3,0x1c(%ebx)
  release(&ptable.lock);
8010390a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  ptable.heads[MEDIUM] = 0;
80103911:	c7 05 58 2d 11 80 00 	movl   $0x0,0x80112d58
80103918:	00 00 00 
  ptable.tails[MEDIUM] = 0;
8010391b:	c7 05 64 2d 11 80 00 	movl   $0x0,0x80112d64
80103922:	00 00 00 
  ptable.heads[LOW] = 0;
80103925:	c7 05 54 2d 11 80 00 	movl   $0x0,0x80112d54
8010392c:	00 00 00 
  ptable.heads[HIGH] = initproc;
8010392f:	a3 5c 2d 11 80       	mov    %eax,0x80112d5c
  ptable.tails[HIGH] = initproc;
80103934:	a3 68 2d 11 80       	mov    %eax,0x80112d68
  ptable.tails[LOW] = 0;
80103939:	c7 05 60 2d 11 80 00 	movl   $0x0,0x80112d60
80103940:	00 00 00 
  release(&ptable.lock);
80103943:	e8 e8 0f 00 00       	call   80104930 <release>
}
80103948:	83 c4 10             	add    $0x10,%esp
8010394b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010394e:	c9                   	leave  
8010394f:	c3                   	ret    
    panic("userinit: out of memory?");
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	68 6c 7a 10 80       	push   $0x80107a6c
80103958:	e8 33 ca ff ff       	call   80100390 <panic>
8010395d:	8d 76 00             	lea    0x0(%esi),%esi

80103960 <growproc>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
80103964:	53                   	push   %ebx
80103965:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103968:	e8 33 0e 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010396d:	e8 ee fd ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103972:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103978:	e8 63 0e 00 00       	call   801047e0 <popcli>
  if(n > 0){
8010397d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103980:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103982:	7f 1c                	jg     801039a0 <growproc+0x40>
  } else if(n < 0){
80103984:	75 3a                	jne    801039c0 <growproc+0x60>
  switchuvm(curproc);
80103986:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103989:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010398b:	53                   	push   %ebx
8010398c:	e8 8f 34 00 00       	call   80106e20 <switchuvm>
  return 0;
80103991:	83 c4 10             	add    $0x10,%esp
80103994:	31 c0                	xor    %eax,%eax
}
80103996:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103999:	5b                   	pop    %ebx
8010399a:	5e                   	pop    %esi
8010399b:	5d                   	pop    %ebp
8010399c:	c3                   	ret    
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039a0:	83 ec 04             	sub    $0x4,%esp
801039a3:	01 c6                	add    %eax,%esi
801039a5:	56                   	push   %esi
801039a6:	50                   	push   %eax
801039a7:	ff 73 14             	pushl  0x14(%ebx)
801039aa:	e8 c1 36 00 00       	call   80107070 <allocuvm>
801039af:	83 c4 10             	add    $0x10,%esp
801039b2:	85 c0                	test   %eax,%eax
801039b4:	75 d0                	jne    80103986 <growproc+0x26>
      return -1;
801039b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039bb:	eb d9                	jmp    80103996 <growproc+0x36>
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039c0:	83 ec 04             	sub    $0x4,%esp
801039c3:	01 c6                	add    %eax,%esi
801039c5:	56                   	push   %esi
801039c6:	50                   	push   %eax
801039c7:	ff 73 14             	pushl  0x14(%ebx)
801039ca:	e8 d1 37 00 00       	call   801071a0 <deallocuvm>
801039cf:	83 c4 10             	add    $0x10,%esp
801039d2:	85 c0                	test   %eax,%eax
801039d4:	75 b0                	jne    80103986 <growproc+0x26>
801039d6:	eb de                	jmp    801039b6 <growproc+0x56>
801039d8:	90                   	nop
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039e0 <fork>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	56                   	push   %esi
801039e5:	53                   	push   %ebx
801039e6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801039e9:	e8 b2 0d 00 00       	call   801047a0 <pushcli>
  c = mycpu();
801039ee:	e8 6d fd ff ff       	call   80103760 <mycpu>
  p = c->proc;
801039f3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801039f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
801039fc:	e8 df 0d 00 00       	call   801047e0 <popcli>
  if((np = allocproc()) == 0){
80103a01:	e8 fa fb ff ff       	call   80103600 <allocproc>
80103a06:	85 c0                	test   %eax,%eax
80103a08:	0f 84 0a 01 00 00    	je     80103b18 <fork+0x138>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a11:	83 ec 08             	sub    $0x8,%esp
80103a14:	89 c3                	mov    %eax,%ebx
80103a16:	ff 32                	pushl  (%edx)
80103a18:	ff 72 14             	pushl  0x14(%edx)
80103a1b:	e8 00 39 00 00       	call   80107320 <copyuvm>
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	85 c0                	test   %eax,%eax
80103a25:	89 43 14             	mov    %eax,0x14(%ebx)
80103a28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a2b:	0f 84 ee 00 00 00    	je     80103b1f <fork+0x13f>
  np->sz = curproc->sz;
80103a31:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103a33:	8b 7b 2c             	mov    0x2c(%ebx),%edi
80103a36:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103a3b:	89 53 28             	mov    %edx,0x28(%ebx)
  np->sz = curproc->sz;
80103a3e:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103a40:	8b 72 2c             	mov    0x2c(%edx),%esi
80103a43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a45:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a47:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103a4a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103a58:	8b 44 b2 3c          	mov    0x3c(%edx,%esi,4),%eax
80103a5c:	85 c0                	test   %eax,%eax
80103a5e:	74 16                	je     80103a76 <fork+0x96>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103a66:	50                   	push   %eax
80103a67:	e8 84 d3 ff ff       	call   80100df0 <filedup>
80103a6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a6f:	89 44 b3 3c          	mov    %eax,0x3c(%ebx,%esi,4)
80103a73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103a76:	83 c6 01             	add    $0x1,%esi
80103a79:	83 fe 10             	cmp    $0x10,%esi
80103a7c:	75 da                	jne    80103a58 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103a7e:	83 ec 0c             	sub    $0xc,%esp
80103a81:	ff 72 7c             	pushl  0x7c(%edx)
80103a84:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103a87:	e8 c4 db ff ff       	call   80101650 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->cwd = idup(curproc->cwd);
80103a8f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a92:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103a98:	83 c4 0c             	add    $0xc,%esp
80103a9b:	6a 10                	push   $0x10
80103a9d:	81 c2 88 00 00 00    	add    $0x88,%edx
80103aa3:	52                   	push   %edx
80103aa4:	50                   	push   %eax
80103aa5:	e8 b6 10 00 00       	call   80104b60 <safestrcpy>
  np->ctime = ticks;
80103aaa:	a1 c0 5b 11 80       	mov    0x80115bc0,%eax
  np->stime = 0;
80103aaf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  np->retime = 0;
80103ab6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  np->rutime = 0;
80103abd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  pid = np->pid;
80103ac4:	8b 73 24             	mov    0x24(%ebx),%esi
  np->ctime = ticks;
80103ac7:	89 43 04             	mov    %eax,0x4(%ebx)
  acquire(&ptable.lock);
80103aca:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad1:	e8 9a 0d 00 00       	call   80104870 <acquire>
  np->state = RUNNABLE;
80103ad6:	c7 43 1c 03 00 00 00 	movl   $0x3,0x1c(%ebx)
  np->prev = ptable.tails[HIGH];
80103add:	8b 15 68 2d 11 80    	mov    0x80112d68,%edx
  np->next = 0;
80103ae3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103aea:	00 00 00 
  ptable.tails[HIGH] = np;
80103aed:	89 1d 68 2d 11 80    	mov    %ebx,0x80112d68
  np->prev = ptable.tails[HIGH];
80103af3:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
  ptable.tails[HIGH]->next = np;
80103af9:	89 9a 80 00 00 00    	mov    %ebx,0x80(%edx)
  release(&ptable.lock);
80103aff:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b06:	e8 25 0e 00 00       	call   80104930 <release>
  return pid;
80103b0b:	83 c4 10             	add    $0x10,%esp
}
80103b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b11:	89 f0                	mov    %esi,%eax
80103b13:	5b                   	pop    %ebx
80103b14:	5e                   	pop    %esi
80103b15:	5f                   	pop    %edi
80103b16:	5d                   	pop    %ebp
80103b17:	c3                   	ret    
    return -1;
80103b18:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103b1d:	eb ef                	jmp    80103b0e <fork+0x12e>
    kfree(np->kstack);
80103b1f:	83 ec 0c             	sub    $0xc,%esp
80103b22:	ff 73 18             	pushl  0x18(%ebx)
    return -1;
80103b25:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103b2a:	e8 e1 e7 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103b2f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    np->state = UNUSED;
80103b36:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    return -1;
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	eb cc                	jmp    80103b0e <fork+0x12e>
80103b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b50 <scheduler>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103b59:	e8 02 fc ff ff       	call   80103760 <mycpu>
  c->proc = 0;
80103b5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b65:	00 00 00 
  struct cpu *c = mycpu();
80103b68:	89 c6                	mov    %eax,%esi
80103b6a:	8d 40 04             	lea    0x4(%eax),%eax
80103b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103b70:	fb                   	sti    
    acquire(&ptable.lock);
80103b71:	83 ec 0c             	sub    $0xc,%esp
80103b74:	bb 20 2d 11 80       	mov    $0x80112d20,%ebx
80103b79:	68 20 2d 11 80       	push   $0x80112d20
80103b7e:	e8 ed 0c 00 00       	call   80104870 <acquire>
80103b83:	83 c4 10             	add    $0x10,%esp
      curr_queue = ptable.heads[prio];
80103b86:	8b 7b 3c             	mov    0x3c(%ebx),%edi
      for(p = curr_queue; p != 0; p=p->next){
80103b89:	85 ff                	test   %edi,%edi
80103b8b:	74 48                	je     80103bd5 <scheduler+0x85>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
        if(p->state != RUNNABLE)
80103b90:	83 7f 1c 03          	cmpl   $0x3,0x1c(%edi)
80103b94:	75 35                	jne    80103bcb <scheduler+0x7b>
        switchuvm(p);
80103b96:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103b99:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
        switchuvm(p);
80103b9f:	57                   	push   %edi
80103ba0:	e8 7b 32 00 00       	call   80106e20 <switchuvm>
        p->state = RUNNING;
80103ba5:	c7 47 1c 04 00 00 00 	movl   $0x4,0x1c(%edi)
        swtch(&(c->scheduler), p->context);
80103bac:	58                   	pop    %eax
80103bad:	5a                   	pop    %edx
80103bae:	ff 77 30             	pushl  0x30(%edi)
80103bb1:	ff 75 e4             	pushl  -0x1c(%ebp)
80103bb4:	e8 02 10 00 00       	call   80104bbb <swtch>
        switchkvm();
80103bb9:	e8 42 32 00 00       	call   80106e00 <switchkvm>
        c->proc = 0;
80103bbe:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103bc5:	00 00 00 
80103bc8:	83 c4 10             	add    $0x10,%esp
      for(p = curr_queue; p != 0; p=p->next){
80103bcb:	8b bf 80 00 00 00    	mov    0x80(%edi),%edi
80103bd1:	85 ff                	test   %edi,%edi
80103bd3:	75 bb                	jne    80103b90 <scheduler+0x40>
80103bd5:	83 eb 04             	sub    $0x4,%ebx
    for(prio = HIGH; prio >= LOW; --prio){
80103bd8:	81 fb 14 2d 11 80    	cmp    $0x80112d14,%ebx
80103bde:	75 a6                	jne    80103b86 <scheduler+0x36>
    release(&ptable.lock);
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	68 20 2d 11 80       	push   $0x80112d20
80103be8:	e8 43 0d 00 00       	call   80104930 <release>
  for(;;){
80103bed:	83 c4 10             	add    $0x10,%esp
80103bf0:	e9 7b ff ff ff       	jmp    80103b70 <scheduler+0x20>
80103bf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <sched>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
  pushcli();
80103c05:	e8 96 0b 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103c0a:	e8 51 fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103c0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c15:	e8 c6 0b 00 00       	call   801047e0 <popcli>
  if(!holding(&ptable.lock))
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 20 2d 11 80       	push   $0x80112d20
80103c22:	e8 19 0c 00 00       	call   80104840 <holding>
80103c27:	83 c4 10             	add    $0x10,%esp
80103c2a:	85 c0                	test   %eax,%eax
80103c2c:	74 4f                	je     80103c7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c2e:	e8 2d fb ff ff       	call   80103760 <mycpu>
80103c33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c3a:	75 68                	jne    80103ca4 <sched+0xa4>
  if(p->state == RUNNING)
80103c3c:	83 7b 1c 04          	cmpl   $0x4,0x1c(%ebx)
80103c40:	74 55                	je     80103c97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c42:	9c                   	pushf  
80103c43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c44:	f6 c4 02             	test   $0x2,%ah
80103c47:	75 41                	jne    80103c8a <sched+0x8a>
  intena = mycpu()->intena;
80103c49:	e8 12 fb ff ff       	call   80103760 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c4e:	83 c3 30             	add    $0x30,%ebx
  intena = mycpu()->intena;
80103c51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c57:	e8 04 fb ff ff       	call   80103760 <mycpu>
80103c5c:	83 ec 08             	sub    $0x8,%esp
80103c5f:	ff 70 04             	pushl  0x4(%eax)
80103c62:	53                   	push   %ebx
80103c63:	e8 53 0f 00 00       	call   80104bbb <swtch>
  mycpu()->intena = intena;
80103c68:	e8 f3 fa ff ff       	call   80103760 <mycpu>
}
80103c6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c79:	5b                   	pop    %ebx
80103c7a:	5e                   	pop    %esi
80103c7b:	5d                   	pop    %ebp
80103c7c:	c3                   	ret    
    panic("sched ptable.lock");
80103c7d:	83 ec 0c             	sub    $0xc,%esp
80103c80:	68 90 7a 10 80       	push   $0x80107a90
80103c85:	e8 06 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c8a:	83 ec 0c             	sub    $0xc,%esp
80103c8d:	68 bc 7a 10 80       	push   $0x80107abc
80103c92:	e8 f9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c97:	83 ec 0c             	sub    $0xc,%esp
80103c9a:	68 ae 7a 10 80       	push   $0x80107aae
80103c9f:	e8 ec c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	68 a2 7a 10 80       	push   $0x80107aa2
80103cac:	e8 df c6 ff ff       	call   80100390 <panic>
80103cb1:	eb 0d                	jmp    80103cc0 <exit>
80103cb3:	90                   	nop
80103cb4:	90                   	nop
80103cb5:	90                   	nop
80103cb6:	90                   	nop
80103cb7:	90                   	nop
80103cb8:	90                   	nop
80103cb9:	90                   	nop
80103cba:	90                   	nop
80103cbb:	90                   	nop
80103cbc:	90                   	nop
80103cbd:	90                   	nop
80103cbe:	90                   	nop
80103cbf:	90                   	nop

80103cc0 <exit>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103cc9:	e8 d2 0a 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103cce:	e8 8d fa ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103cd3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cd9:	e8 02 0b 00 00       	call   801047e0 <popcli>
  if(curproc == initproc)
80103cde:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103ce4:	8d 5e 3c             	lea    0x3c(%esi),%ebx
80103ce7:	8d 7e 7c             	lea    0x7c(%esi),%edi
80103cea:	0f 84 f1 00 00 00    	je     80103de1 <exit+0x121>
    if(curproc->ofile[fd]){
80103cf0:	8b 03                	mov    (%ebx),%eax
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	74 12                	je     80103d08 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103cf6:	83 ec 0c             	sub    $0xc,%esp
80103cf9:	50                   	push   %eax
80103cfa:	e8 41 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103cff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d05:	83 c4 10             	add    $0x10,%esp
80103d08:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d0b:	39 fb                	cmp    %edi,%ebx
80103d0d:	75 e1                	jne    80103cf0 <exit+0x30>
  begin_op();
80103d0f:	e8 8c ee ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103d14:	83 ec 0c             	sub    $0xc,%esp
80103d17:	ff 76 7c             	pushl  0x7c(%esi)
80103d1a:	e8 91 da ff ff       	call   801017b0 <iput>
  end_op();
80103d1f:	e8 ec ee ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103d24:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  acquire(&ptable.lock);
80103d2b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d32:	e8 39 0b 00 00       	call   80104870 <acquire>
  wakeup1(curproc->parent);
80103d37:	8b 56 28             	mov    0x28(%esi),%edx
80103d3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80103d3d:	b8 6c 2d 11 80       	mov    $0x80112d6c,%eax
80103d42:	eb 10                	jmp    80103d54 <exit+0x94>
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d48:	05 98 00 00 00       	add    $0x98,%eax
80103d4d:	3d 6c 53 11 80       	cmp    $0x8011536c,%eax
80103d52:	73 1e                	jae    80103d72 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan) {
80103d54:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103d58:	75 ee                	jne    80103d48 <exit+0x88>
80103d5a:	3b 50 34             	cmp    0x34(%eax),%edx
80103d5d:	75 e9                	jne    80103d48 <exit+0x88>
      p->state = RUNNABLE;
80103d5f:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80103d66:	05 98 00 00 00       	add    $0x98,%eax
80103d6b:	3d 6c 53 11 80       	cmp    $0x8011536c,%eax
80103d70:	72 e2                	jb     80103d54 <exit+0x94>
      p->parent = initproc;
80103d72:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80103d78:	ba 6c 2d 11 80       	mov    $0x80112d6c,%edx
80103d7d:	eb 0f                	jmp    80103d8e <exit+0xce>
80103d7f:	90                   	nop
80103d80:	81 c2 98 00 00 00    	add    $0x98,%edx
80103d86:	81 fa 6c 53 11 80    	cmp    $0x8011536c,%edx
80103d8c:	73 3a                	jae    80103dc8 <exit+0x108>
    if(p->parent == curproc){
80103d8e:	39 72 28             	cmp    %esi,0x28(%edx)
80103d91:	75 ed                	jne    80103d80 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d93:	83 7a 1c 05          	cmpl   $0x5,0x1c(%edx)
      p->parent = initproc;
80103d97:	89 4a 28             	mov    %ecx,0x28(%edx)
      if(p->state == ZOMBIE)
80103d9a:	75 e4                	jne    80103d80 <exit+0xc0>
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80103d9c:	b8 6c 2d 11 80       	mov    $0x80112d6c,%eax
80103da1:	eb 11                	jmp    80103db4 <exit+0xf4>
80103da3:	90                   	nop
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103da8:	05 98 00 00 00       	add    $0x98,%eax
80103dad:	3d 6c 53 11 80       	cmp    $0x8011536c,%eax
80103db2:	73 cc                	jae    80103d80 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan) {
80103db4:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103db8:	75 ee                	jne    80103da8 <exit+0xe8>
80103dba:	3b 48 34             	cmp    0x34(%eax),%ecx
80103dbd:	75 e9                	jne    80103da8 <exit+0xe8>
      p->state = RUNNABLE;
80103dbf:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
80103dc6:	eb e0                	jmp    80103da8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103dc8:	c7 46 1c 05 00 00 00 	movl   $0x5,0x1c(%esi)
  sched();
80103dcf:	e8 2c fe ff ff       	call   80103c00 <sched>
  panic("zombie exit");
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 dd 7a 10 80       	push   $0x80107add
80103ddc:	e8 af c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103de1:	83 ec 0c             	sub    $0xc,%esp
80103de4:	68 d0 7a 10 80       	push   $0x80107ad0
80103de9:	e8 a2 c5 ff ff       	call   80100390 <panic>
80103dee:	66 90                	xchg   %ax,%ax

80103df0 <yield>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103df7:	68 20 2d 11 80       	push   $0x80112d20
80103dfc:	e8 6f 0a 00 00       	call   80104870 <acquire>
  pushcli();
80103e01:	e8 9a 09 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103e06:	e8 55 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103e0b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e11:	e8 ca 09 00 00       	call   801047e0 <popcli>
  myproc()->state = RUNNABLE;
80103e16:	c7 43 1c 03 00 00 00 	movl   $0x3,0x1c(%ebx)
  sched();
80103e1d:	e8 de fd ff ff       	call   80103c00 <sched>
  release(&ptable.lock);
80103e22:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e29:	e8 02 0b 00 00       	call   80104930 <release>
}
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e34:	c9                   	leave  
80103e35:	c3                   	ret    
80103e36:	8d 76 00             	lea    0x0(%esi),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <sleep>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
80103e49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e4f:	e8 4c 09 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103e54:	e8 07 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103e59:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e5f:	e8 7c 09 00 00       	call   801047e0 <popcli>
  if(p == 0)
80103e64:	85 db                	test   %ebx,%ebx
80103e66:	0f 84 87 00 00 00    	je     80103ef3 <sleep+0xb3>
  if(lk == 0)
80103e6c:	85 f6                	test   %esi,%esi
80103e6e:	74 76                	je     80103ee6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e70:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e76:	74 50                	je     80103ec8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	68 20 2d 11 80       	push   $0x80112d20
80103e80:	e8 eb 09 00 00       	call   80104870 <acquire>
    release(lk);
80103e85:	89 34 24             	mov    %esi,(%esp)
80103e88:	e8 a3 0a 00 00       	call   80104930 <release>
  p->chan = chan;
80103e8d:	89 7b 34             	mov    %edi,0x34(%ebx)
  p->state = SLEEPING;
80103e90:	c7 43 1c 02 00 00 00 	movl   $0x2,0x1c(%ebx)
  sched();
80103e97:	e8 64 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103e9c:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
    release(&ptable.lock);
80103ea3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eaa:	e8 81 0a 00 00       	call   80104930 <release>
    acquire(lk);
80103eaf:	89 75 08             	mov    %esi,0x8(%ebp)
80103eb2:	83 c4 10             	add    $0x10,%esp
}
80103eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eb8:	5b                   	pop    %ebx
80103eb9:	5e                   	pop    %esi
80103eba:	5f                   	pop    %edi
80103ebb:	5d                   	pop    %ebp
    acquire(lk);
80103ebc:	e9 af 09 00 00       	jmp    80104870 <acquire>
80103ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103ec8:	89 7b 34             	mov    %edi,0x34(%ebx)
  p->state = SLEEPING;
80103ecb:	c7 43 1c 02 00 00 00 	movl   $0x2,0x1c(%ebx)
  sched();
80103ed2:	e8 29 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103ed7:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
}
80103ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee1:	5b                   	pop    %ebx
80103ee2:	5e                   	pop    %esi
80103ee3:	5f                   	pop    %edi
80103ee4:	5d                   	pop    %ebp
80103ee5:	c3                   	ret    
    panic("sleep without lk");
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	68 ef 7a 10 80       	push   $0x80107aef
80103eee:	e8 9d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ef3:	83 ec 0c             	sub    $0xc,%esp
80103ef6:	68 e9 7a 10 80       	push   $0x80107ae9
80103efb:	e8 90 c4 ff ff       	call   80100390 <panic>

80103f00 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 10             	sub    $0x10,%esp
80103f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f0a:	68 20 2d 11 80       	push   $0x80112d20
80103f0f:	e8 5c 09 00 00       	call   80104870 <acquire>
80103f14:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80103f17:	b8 6c 2d 11 80       	mov    $0x80112d6c,%eax
80103f1c:	eb 0e                	jmp    80103f2c <wakeup+0x2c>
80103f1e:	66 90                	xchg   %ax,%ax
80103f20:	05 98 00 00 00       	add    $0x98,%eax
80103f25:	3d 6c 53 11 80       	cmp    $0x8011536c,%eax
80103f2a:	73 1e                	jae    80103f4a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan) {
80103f2c:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103f30:	75 ee                	jne    80103f20 <wakeup+0x20>
80103f32:	3b 58 34             	cmp    0x34(%eax),%ebx
80103f35:	75 e9                	jne    80103f20 <wakeup+0x20>
      p->state = RUNNABLE;
80103f37:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80103f3e:	05 98 00 00 00       	add    $0x98,%eax
80103f43:	3d 6c 53 11 80       	cmp    $0x8011536c,%eax
80103f48:	72 e2                	jb     80103f2c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103f4a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f54:	c9                   	leave  
  release(&ptable.lock);
80103f55:	e9 d6 09 00 00       	jmp    80104930 <release>
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f60 <remove_proc_from_its_queue>:

void 
remove_proc_from_its_queue (struct proc *p)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	8b 45 08             	mov    0x8(%ebp),%eax
  if (ptable.heads[p->priority] == p) // p is the head
80103f66:	8b 50 20             	mov    0x20(%eax),%edx
80103f69:	8d 4a 0c             	lea    0xc(%edx),%ecx
80103f6c:	39 04 8d 24 2d 11 80 	cmp    %eax,-0x7feed2dc(,%ecx,4)
80103f73:	74 3b                	je     80103fb0 <remove_proc_from_its_queue+0x50>
    if (ptable.tails[p->priority] == p) { // p is the only proc on queue
      ptable.tails[p->priority] = 0;
    }
    p->next = 0;
  }
  else if (ptable.tails[p->priority] == p) // p is the tail
80103f75:	83 c2 10             	add    $0x10,%edx
80103f78:	39 04 95 20 2d 11 80 	cmp    %eax,-0x7feed2e0(,%edx,4)
80103f7f:	0f 84 8b 00 00 00    	je     80104010 <remove_proc_from_its_queue+0xb0>
  {
    ptable.tails[p->priority] = p->prev;
    ptable.tails[p->priority]->next = 0;
  } else // p is in the middle
  {
    p->prev->next = p->next;
80103f85:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80103f8b:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103f91:	89 8a 80 00 00 00    	mov    %ecx,0x80(%edx)
    p->next->prev = p->prev;
80103f97:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103f9d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80103fa3:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  }
}
80103fa9:	5d                   	pop    %ebp
80103faa:	c3                   	ret    
80103fab:	90                   	nop
80103fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ptable.heads[p->priority] = p->next;
80103fb0:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103fb6:	89 14 8d 24 2d 11 80 	mov    %edx,-0x7feed2dc(,%ecx,4)
    ptable.heads[p->priority]->prev = p->next;
80103fbd:	8b 48 20             	mov    0x20(%eax),%ecx
80103fc0:	8b 0c 8d 54 2d 11 80 	mov    -0x7feed2ac(,%ecx,4),%ecx
80103fc7:	89 91 84 00 00 00    	mov    %edx,0x84(%ecx)
    if (ptable.tails[p->priority] == p) { // p is the only proc on queue
80103fcd:	8b 48 20             	mov    0x20(%eax),%ecx
80103fd0:	8d 51 10             	lea    0x10(%ecx),%edx
80103fd3:	39 04 95 20 2d 11 80 	cmp    %eax,-0x7feed2e0(,%edx,4)
80103fda:	74 14                	je     80103ff0 <remove_proc_from_its_queue+0x90>
    ptable.tails[p->priority]->next = 0;
80103fdc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103fe3:	00 00 00 
}
80103fe6:	5d                   	pop    %ebp
80103fe7:	c3                   	ret    
80103fe8:	90                   	nop
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ptable.tails[p->priority] = 0;
80103ff0:	c7 04 95 20 2d 11 80 	movl   $0x0,-0x7feed2e0(,%edx,4)
80103ff7:	00 00 00 00 
    ptable.tails[p->priority]->next = 0;
80103ffb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104002:	00 00 00 
80104005:	eb df                	jmp    80103fe6 <remove_proc_from_its_queue+0x86>
80104007:	89 f6                	mov    %esi,%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ptable.tails[p->priority] = p->prev;
80104010:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80104016:	89 0c 95 20 2d 11 80 	mov    %ecx,-0x7feed2e0(,%edx,4)
    ptable.tails[p->priority]->next = 0;
8010401d:	8b 40 20             	mov    0x20(%eax),%eax
80104020:	8b 04 85 60 2d 11 80 	mov    -0x7feed2a0(,%eax,4),%eax
80104027:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010402e:	00 00 00 
80104031:	eb b3                	jmp    80103fe6 <remove_proc_from_its_queue+0x86>
80104033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <wait>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
  pushcli();
80104045:	e8 56 07 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010404a:	e8 11 f7 ff ff       	call   80103760 <mycpu>
  p = c->proc;
8010404f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104055:	e8 86 07 00 00       	call   801047e0 <popcli>
  acquire(&ptable.lock);
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 20 2d 11 80       	push   $0x80112d20
80104062:	e8 09 08 00 00       	call   80104870 <acquire>
80104067:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010406a:	31 c0                	xor    %eax,%eax
    for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
8010406c:	bb 6c 2d 11 80       	mov    $0x80112d6c,%ebx
80104071:	eb 13                	jmp    80104086 <wait+0x46>
80104073:	90                   	nop
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104078:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010407e:	81 fb 6c 53 11 80    	cmp    $0x8011536c,%ebx
80104084:	73 1e                	jae    801040a4 <wait+0x64>
      if(p->parent != curproc)
80104086:	39 73 28             	cmp    %esi,0x28(%ebx)
80104089:	75 ed                	jne    80104078 <wait+0x38>
      if(p->state == ZOMBIE){
8010408b:	83 7b 1c 05          	cmpl   $0x5,0x1c(%ebx)
8010408f:	74 3f                	je     801040d0 <wait+0x90>
    for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80104091:	81 c3 98 00 00 00    	add    $0x98,%ebx
      havekids = 1;
80104097:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
8010409c:	81 fb 6c 53 11 80    	cmp    $0x8011536c,%ebx
801040a2:	72 e2                	jb     80104086 <wait+0x46>
    if(!havekids || curproc->killed){
801040a4:	85 c0                	test   %eax,%eax
801040a6:	0f 84 85 00 00 00    	je     80104131 <wait+0xf1>
801040ac:	8b 46 38             	mov    0x38(%esi),%eax
801040af:	85 c0                	test   %eax,%eax
801040b1:	75 7e                	jne    80104131 <wait+0xf1>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040b3:	83 ec 08             	sub    $0x8,%esp
801040b6:	68 20 2d 11 80       	push   $0x80112d20
801040bb:	56                   	push   %esi
801040bc:	e8 7f fd ff ff       	call   80103e40 <sleep>
    havekids = 0;
801040c1:	83 c4 10             	add    $0x10,%esp
801040c4:	eb a4                	jmp    8010406a <wait+0x2a>
801040c6:	8d 76 00             	lea    0x0(%esi),%esi
801040c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        kfree(p->kstack);
801040d0:	83 ec 0c             	sub    $0xc,%esp
801040d3:	ff 73 18             	pushl  0x18(%ebx)
        pid = p->pid;
801040d6:	8b 73 24             	mov    0x24(%ebx),%esi
        kfree(p->kstack);
801040d9:	e8 32 e2 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
801040de:	5a                   	pop    %edx
801040df:	ff 73 14             	pushl  0x14(%ebx)
        p->kstack = 0;
801040e2:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        freevm(p->pgdir);
801040e9:	e8 e2 30 00 00       	call   801071d0 <freevm>
        remove_proc_from_its_queue(p);
801040ee:	89 1c 24             	mov    %ebx,(%esp)
        p->pid = 0;
801040f1:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->parent = 0;
801040f8:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->name[0] = 0;
801040ff:	c6 83 88 00 00 00 00 	movb   $0x0,0x88(%ebx)
        p->killed = 0;
80104106:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
        p->state = UNUSED;
8010410d:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        remove_proc_from_its_queue(p);
80104114:	e8 47 fe ff ff       	call   80103f60 <remove_proc_from_its_queue>
        release(&ptable.lock);
80104119:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104120:	e8 0b 08 00 00       	call   80104930 <release>
        return pid;
80104125:	83 c4 10             	add    $0x10,%esp
}
80104128:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010412b:	89 f0                	mov    %esi,%eax
8010412d:	5b                   	pop    %ebx
8010412e:	5e                   	pop    %esi
8010412f:	5d                   	pop    %ebp
80104130:	c3                   	ret    
      release(&ptable.lock);
80104131:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104134:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104139:	68 20 2d 11 80       	push   $0x80112d20
8010413e:	e8 ed 07 00 00       	call   80104930 <release>
      return -1;
80104143:	83 c4 10             	add    $0x10,%esp
80104146:	eb e0                	jmp    80104128 <wait+0xe8>
80104148:	90                   	nop
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <add_proc_to_new_queue>:

void 
add_proc_to_new_queue (struct proc *p, int new_prio)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	83 ec 08             	sub    $0x8,%esp
80104156:	8b 45 08             	mov    0x8(%ebp),%eax
80104159:	8b 55 0c             	mov    0xc(%ebp),%edx
  // Changing process to a queue that:
  //     has not been initialized
  //     got emptied
  if (p == 0)
8010415c:	85 c0                	test   %eax,%eax
8010415e:	74 60                	je     801041c0 <add_proc_to_new_queue+0x70>
  {
    panic("Trying to add null proc to queue");
    return;
  }
  p->priority = new_prio;
  if (ptable.heads[new_prio] == 0) {
80104160:	8d 4a 0c             	lea    0xc(%edx),%ecx
  p->priority = new_prio;
80104163:	89 50 20             	mov    %edx,0x20(%eax)
  if (ptable.heads[new_prio] == 0) {
80104166:	83 3c 8d 24 2d 11 80 	cmpl   $0x0,-0x7feed2dc(,%ecx,4)
8010416d:	00 
8010416e:	74 30                	je     801041a0 <add_proc_to_new_queue+0x50>
    ptable.heads[new_prio] = p;
    ptable.tails[new_prio] = p;
    p->prev = p;
    p->next = 0;
  } else {
    ptable.tails[new_prio]->next = p;
80104170:	83 c2 10             	add    $0x10,%edx
80104173:	8b 0c 95 20 2d 11 80 	mov    -0x7feed2e0(,%edx,4),%ecx
    p->prev = ptable.tails[new_prio];
    ptable.tails[new_prio] = p;
8010417a:	89 04 95 20 2d 11 80 	mov    %eax,-0x7feed2e0(,%edx,4)
    ptable.tails[new_prio]->next = p;
80104181:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
    p->prev = ptable.tails[new_prio];
80104187:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
    p->next = 0;
8010418d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104194:	00 00 00 
  }
}
80104197:	c9                   	leave  
80104198:	c3                   	ret    
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ptable.heads[new_prio] = p;
801041a0:	89 04 8d 24 2d 11 80 	mov    %eax,-0x7feed2dc(,%ecx,4)
    ptable.tails[new_prio] = p;
801041a7:	89 04 95 60 2d 11 80 	mov    %eax,-0x7feed2a0(,%edx,4)
    p->prev = p;
801041ae:	89 80 84 00 00 00    	mov    %eax,0x84(%eax)
    p->next = 0;
801041b4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801041bb:	00 00 00 
}
801041be:	c9                   	leave  
801041bf:	c3                   	ret    
    panic("Trying to add null proc to queue");
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	68 9c 7b 10 80       	push   $0x80107b9c
801041c8:	e8 c3 c1 ff ff       	call   80100390 <panic>
801041cd:	8d 76 00             	lea    0x0(%esi),%esi

801041d0 <set_prio>:

int
set_prio(int prio)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (prio < LOW || prio > HIGH)
801041dc:	83 fb 02             	cmp    $0x2,%ebx
801041df:	77 57                	ja     80104238 <set_prio+0x68>
  pushcli();
801041e1:	e8 ba 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
801041e6:	e8 75 f5 ff ff       	call   80103760 <mycpu>
  p = c->proc;
801041eb:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    return -1;
  struct proc *myp = myproc();
  // Nothing to be done
  if(prio == myp->priority){
    return 0;
801041f1:	31 ff                	xor    %edi,%edi
  popcli();
801041f3:	e8 e8 05 00 00       	call   801047e0 <popcli>
  if(prio == myp->priority){
801041f8:	3b 5e 20             	cmp    0x20(%esi),%ebx
801041fb:	74 2d                	je     8010422a <set_prio+0x5a>
  }
  acquire(&ptable.lock);
801041fd:	83 ec 0c             	sub    $0xc,%esp
80104200:	68 20 2d 11 80       	push   $0x80112d20
80104205:	e8 66 06 00 00       	call   80104870 <acquire>

  remove_proc_from_its_queue(myp);
8010420a:	89 34 24             	mov    %esi,(%esp)
8010420d:	e8 4e fd ff ff       	call   80103f60 <remove_proc_from_its_queue>

  add_proc_to_new_queue(myp, prio);
80104212:	58                   	pop    %eax
80104213:	5a                   	pop    %edx
80104214:	53                   	push   %ebx
80104215:	56                   	push   %esi
80104216:	e8 35 ff ff ff       	call   80104150 <add_proc_to_new_queue>

  release(&ptable.lock);
8010421b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104222:	e8 09 07 00 00       	call   80104930 <release>
  return 0;
80104227:	83 c4 10             	add    $0x10,%esp
}
8010422a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010422d:	89 f8                	mov    %edi,%eax
8010422f:	5b                   	pop    %ebx
80104230:	5e                   	pop    %esi
80104231:	5f                   	pop    %edi
80104232:	5d                   	pop    %ebp
80104233:	c3                   	ret    
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104238:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010423d:	eb eb                	jmp    8010422a <set_prio+0x5a>
8010423f:	90                   	nop

80104240 <wait2>:

int
wait2(int* retime, int* rutime, int* stime)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	83 ec 0c             	sub    $0xc,%esp
  if (!retime || !rutime || !stime) {
80104249:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010424c:	8b 5d 10             	mov    0x10(%ebp),%ebx
{
8010424f:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (!retime || !rutime || !stime) {
80104252:	85 c9                	test   %ecx,%ecx
80104254:	0f 94 c2             	sete   %dl
80104257:	85 db                	test   %ebx,%ebx
80104259:	0f 94 c0             	sete   %al
8010425c:	08 c2                	or     %al,%dl
8010425e:	0f 85 22 01 00 00    	jne    80104386 <wait2+0x146>
80104264:	85 ff                	test   %edi,%edi
80104266:	0f 84 1a 01 00 00    	je     80104386 <wait2+0x146>
    return -1;
  }
  struct proc *p;
  int havekids, pid;
  
  acquire(&ptable.lock);
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	68 20 2d 11 80       	push   $0x80112d20
80104274:	e8 f7 05 00 00       	call   80104870 <acquire>
  pushcli();
80104279:	e8 22 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010427e:	e8 dd f4 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104283:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104289:	e8 52 05 00 00       	call   801047e0 <popcli>
8010428e:	83 c4 10             	add    $0x10,%esp
  struct proc *curproc = myproc();
    // Scan through table looking for exited children.
  for(;;){
    havekids = 0;
80104291:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80104293:	be 6c 2d 11 80       	mov    $0x80112d6c,%esi
80104298:	eb 14                	jmp    801042ae <wait2+0x6e>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042a0:	81 c6 98 00 00 00    	add    $0x98,%esi
801042a6:	81 fe 6c 53 11 80    	cmp    $0x8011536c,%esi
801042ac:	73 1e                	jae    801042cc <wait2+0x8c>
      if(p->parent != curproc)
801042ae:	39 5e 28             	cmp    %ebx,0x28(%esi)
801042b1:	75 ed                	jne    801042a0 <wait2+0x60>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801042b3:	83 7e 1c 05          	cmpl   $0x5,0x1c(%esi)
801042b7:	74 3f                	je     801042f8 <wait2+0xb8>
    for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
801042b9:	81 c6 98 00 00 00    	add    $0x98,%esi
      havekids = 1;
801042bf:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
801042c4:	81 fe 6c 53 11 80    	cmp    $0x8011536c,%esi
801042ca:	72 e2                	jb     801042ae <wait2+0x6e>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801042cc:	85 c9                	test   %ecx,%ecx
801042ce:	0f 84 9b 00 00 00    	je     8010436f <wait2+0x12f>
801042d4:	8b 43 38             	mov    0x38(%ebx),%eax
801042d7:	85 c0                	test   %eax,%eax
801042d9:	0f 85 90 00 00 00    	jne    8010436f <wait2+0x12f>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042df:	83 ec 08             	sub    $0x8,%esp
801042e2:	68 20 2d 11 80       	push   $0x80112d20
801042e7:	53                   	push   %ebx
801042e8:	e8 53 fb ff ff       	call   80103e40 <sleep>
    havekids = 0;
801042ed:	83 c4 10             	add    $0x10,%esp
801042f0:	eb 9f                	jmp    80104291 <wait2+0x51>
801042f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *retime = p->retime;
801042f8:	8b 46 0c             	mov    0xc(%esi),%eax
        *stime  = p->stime;
801042fb:	8b 55 10             	mov    0x10(%ebp),%edx
        kfree(p->kstack);
801042fe:	83 ec 0c             	sub    $0xc,%esp
        *retime = p->retime;
80104301:	89 07                	mov    %eax,(%edi)
        *rutime = p->rutime;
80104303:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104306:	8b 46 10             	mov    0x10(%esi),%eax
80104309:	89 07                	mov    %eax,(%edi)
        *stime  = p->stime;
8010430b:	8b 46 08             	mov    0x8(%esi),%eax
8010430e:	89 02                	mov    %eax,(%edx)
        kfree(p->kstack);
80104310:	ff 76 18             	pushl  0x18(%esi)
        pid = p->pid;
80104313:	8b 5e 24             	mov    0x24(%esi),%ebx
        kfree(p->kstack);
80104316:	e8 f5 df ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
8010431b:	5a                   	pop    %edx
8010431c:	ff 76 14             	pushl  0x14(%esi)
        p->kstack = 0;
8010431f:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
        freevm(p->pgdir);
80104326:	e8 a5 2e 00 00       	call   801071d0 <freevm>
        remove_proc_from_its_queue(p);
8010432b:	89 34 24             	mov    %esi,(%esp)
        p->pid = 0;
8010432e:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
        p->parent = 0;
80104335:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
        p->name[0] = 0;
8010433c:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        p->killed = 0;
80104343:	c7 46 38 00 00 00 00 	movl   $0x0,0x38(%esi)
        p->state = UNUSED;
8010434a:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
        remove_proc_from_its_queue(p);
80104351:	e8 0a fc ff ff       	call   80103f60 <remove_proc_from_its_queue>
        release(&ptable.lock);
80104356:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010435d:	e8 ce 05 00 00       	call   80104930 <release>
        return pid;
80104362:	83 c4 10             	add    $0x10,%esp
  }
}
80104365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104368:	89 d8                	mov    %ebx,%eax
8010436a:	5b                   	pop    %ebx
8010436b:	5e                   	pop    %esi
8010436c:	5f                   	pop    %edi
8010436d:	5d                   	pop    %ebp
8010436e:	c3                   	ret    
      release(&ptable.lock);
8010436f:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104372:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&ptable.lock);
80104377:	68 20 2d 11 80       	push   $0x80112d20
8010437c:	e8 af 05 00 00       	call   80104930 <release>
      return -1;
80104381:	83 c4 10             	add    $0x10,%esp
80104384:	eb df                	jmp    80104365 <wait2+0x125>
    panic("wait2 recieved null argument");
80104386:	83 ec 0c             	sub    $0xc,%esp
80104389:	68 00 7b 10 80       	push   $0x80107b00
8010438e:	e8 fd bf ff ff       	call   80100390 <panic>
80104393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043aa:	68 20 2d 11 80       	push   $0x80112d20
801043af:	e8 bc 04 00 00       	call   80104870 <acquire>
801043b4:	83 c4 10             	add    $0x10,%esp
  
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
801043b7:	b8 6c 2d 11 80       	mov    $0x80112d6c,%eax
801043bc:	eb 0e                	jmp    801043cc <kill+0x2c>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	05 98 00 00 00       	add    $0x98,%eax
801043c5:	3d 6c 53 11 80       	cmp    $0x8011536c,%eax
801043ca:	73 34                	jae    80104400 <kill+0x60>
    if(p->pid == pid){
801043cc:	39 58 24             	cmp    %ebx,0x24(%eax)
801043cf:	75 ef                	jne    801043c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043d1:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
      p->killed = 1;
801043d5:	c7 40 38 01 00 00 00 	movl   $0x1,0x38(%eax)
      if(p->state == SLEEPING)
801043dc:	75 07                	jne    801043e5 <kill+0x45>
        p->state = RUNNABLE;
801043de:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
      release(&ptable.lock);
801043e5:	83 ec 0c             	sub    $0xc,%esp
801043e8:	68 20 2d 11 80       	push   $0x80112d20
801043ed:	e8 3e 05 00 00       	call   80104930 <release>
      return 0;
801043f2:	83 c4 10             	add    $0x10,%esp
801043f5:	31 c0                	xor    %eax,%eax
    }
  }
  
  release(&ptable.lock);
  return -1;
}
801043f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043fa:	c9                   	leave  
801043fb:	c3                   	ret    
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104400:	83 ec 0c             	sub    $0xc,%esp
80104403:	68 20 2d 11 80       	push   $0x80112d20
80104408:	e8 23 05 00 00       	call   80104930 <release>
  return -1;
8010440d:	83 c4 10             	add    $0x10,%esp
80104410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104418:	c9                   	leave  
80104419:	c3                   	ret    
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	53                   	push   %ebx
80104426:	8d 75 e8             	lea    -0x18(%ebp),%esi
  struct proc *p;
  char *state;
  uint pc[10];

  cprintf("\ntick %d\n", ticks);
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80104429:	bb 6c 2d 11 80       	mov    $0x80112d6c,%ebx
{
8010442e:	83 ec 44             	sub    $0x44,%esp
  cprintf("\ntick %d\n", ticks);
80104431:	ff 35 c0 5b 11 80    	pushl  0x80115bc0
80104437:	68 21 7b 10 80       	push   $0x80107b21
8010443c:	e8 1f c2 ff ff       	call   80100660 <cprintf>
80104441:	83 c4 10             	add    $0x10,%esp
80104444:	eb 2c                	jmp    80104472 <procdump+0x52>
80104446:	8d 76 00             	lea    0x0(%esi),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	68 e3 7e 10 80       	push   $0x80107ee3
80104458:	e8 03 c2 ff ff       	call   80100660 <cprintf>
8010445d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.queue; p < &ptable.queue[NPROC]; p++){
80104460:	81 c3 98 00 00 00    	add    $0x98,%ebx
80104466:	81 fb 6c 53 11 80    	cmp    $0x8011536c,%ebx
8010446c:	0f 83 8e 00 00 00    	jae    80104500 <procdump+0xe0>
    if(p->state == UNUSED)
80104472:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104475:	85 c0                	test   %eax,%eax
80104477:	74 e7                	je     80104460 <procdump+0x40>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104479:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
8010447c:	ba 1d 7b 10 80       	mov    $0x80107b1d,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104481:	77 11                	ja     80104494 <procdump+0x74>
80104483:	8b 14 85 c0 7b 10 80 	mov    -0x7fef8440(,%eax,4),%edx
      state = "???";
8010448a:	b8 1d 7b 10 80       	mov    $0x80107b1d,%eax
8010448f:	85 d2                	test   %edx,%edx
80104491:	0f 44 d0             	cmove  %eax,%edx
    cprintf("\n%d %d %s %s", p->pid, p->priority, state, p->name);
80104494:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	50                   	push   %eax
8010449e:	52                   	push   %edx
8010449f:	ff 73 20             	pushl  0x20(%ebx)
801044a2:	ff 73 24             	pushl  0x24(%ebx)
801044a5:	68 2b 7b 10 80       	push   $0x80107b2b
801044aa:	e8 b1 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044af:	83 c4 20             	add    $0x20,%esp
801044b2:	83 7b 1c 02          	cmpl   $0x2,0x1c(%ebx)
801044b6:	75 98                	jne    80104450 <procdump+0x30>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044b8:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044bb:	83 ec 08             	sub    $0x8,%esp
801044be:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044c1:	50                   	push   %eax
801044c2:	8b 43 30             	mov    0x30(%ebx),%eax
801044c5:	8b 40 0c             	mov    0xc(%eax),%eax
801044c8:	83 c0 08             	add    $0x8,%eax
801044cb:	50                   	push   %eax
801044cc:	e8 7f 02 00 00       	call   80104750 <getcallerpcs>
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801044d8:	8b 17                	mov    (%edi),%edx
801044da:	85 d2                	test   %edx,%edx
801044dc:	0f 84 6e ff ff ff    	je     80104450 <procdump+0x30>
        cprintf(" %p", pc[i]);
801044e2:	83 ec 08             	sub    $0x8,%esp
801044e5:	83 c7 04             	add    $0x4,%edi
801044e8:	52                   	push   %edx
801044e9:	68 41 75 10 80       	push   $0x80107541
801044ee:	e8 6d c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044f3:	83 c4 10             	add    $0x10,%esp
801044f6:	39 fe                	cmp    %edi,%esi
801044f8:	75 de                	jne    801044d8 <procdump+0xb8>
801044fa:	e9 51 ff ff ff       	jmp    80104450 <procdump+0x30>
801044ff:	90                   	nop
  }
  cprintf("--------------\n");
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	68 38 7b 10 80       	push   $0x80107b38
80104508:	e8 53 c1 ff ff       	call   80100660 <cprintf>
}
8010450d:	83 c4 10             	add    $0x10,%esp
80104510:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104513:	5b                   	pop    %ebx
80104514:	5e                   	pop    %esi
80104515:	5f                   	pop    %edi
80104516:	5d                   	pop    %ebp
80104517:	c3                   	ret    
80104518:	90                   	nop
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <update_proc_status>:

void 
update_proc_status (void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.queue; p < &ptable.queue[NPROC]; p++) {
80104524:	bb 6c 2d 11 80       	mov    $0x80112d6c,%ebx
{
80104529:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010452c:	68 20 2d 11 80       	push   $0x80112d20
80104531:	e8 3a 03 00 00       	call   80104870 <acquire>
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	eb 36                	jmp    80104571 <update_proc_status+0x51>
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->priority == LOW && p->retime > T0TO1) {
80104540:	81 7b 0c c8 00 00 00 	cmpl   $0xc8,0xc(%ebx)
80104547:	0f 8f 93 00 00 00    	jg     801045e0 <update_proc_status+0xc0>
      add_proc_to_new_queue(p, MEDIUM);
    } else if (p->priority == MEDIUM && p->retime > T1TO2) {
      remove_proc_from_its_queue(p);
      add_proc_to_new_queue(p, HIGH);
    }
    switch (p->state)
8010454d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104550:	83 f8 03             	cmp    $0x3,%eax
80104553:	74 53                	je     801045a8 <update_proc_status+0x88>
80104555:	83 f8 04             	cmp    $0x4,%eax
80104558:	74 76                	je     801045d0 <update_proc_status+0xb0>
8010455a:	83 f8 02             	cmp    $0x2,%eax
8010455d:	75 04                	jne    80104563 <update_proc_status+0x43>
    {
    case SLEEPING:
      p->stime++;
8010455f:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  for (p = ptable.queue; p < &ptable.queue[NPROC]; p++) {
80104563:	81 c3 98 00 00 00    	add    $0x98,%ebx
80104569:	81 fb 6c 53 11 80    	cmp    $0x8011536c,%ebx
8010456f:	73 49                	jae    801045ba <update_proc_status+0x9a>
    if (p->priority == LOW && p->retime > T0TO1) {
80104571:	8b 43 20             	mov    0x20(%ebx),%eax
80104574:	85 c0                	test   %eax,%eax
80104576:	74 c8                	je     80104540 <update_proc_status+0x20>
    } else if (p->priority == MEDIUM && p->retime > T1TO2) {
80104578:	83 f8 01             	cmp    $0x1,%eax
8010457b:	75 d0                	jne    8010454d <update_proc_status+0x2d>
8010457d:	81 7b 0c 90 01 00 00 	cmpl   $0x190,0xc(%ebx)
80104584:	7e c7                	jle    8010454d <update_proc_status+0x2d>
      remove_proc_from_its_queue(p);
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	53                   	push   %ebx
8010458a:	e8 d1 f9 ff ff       	call   80103f60 <remove_proc_from_its_queue>
      add_proc_to_new_queue(p, HIGH);
8010458f:	58                   	pop    %eax
80104590:	5a                   	pop    %edx
80104591:	6a 02                	push   $0x2
80104593:	53                   	push   %ebx
80104594:	e8 b7 fb ff ff       	call   80104150 <add_proc_to_new_queue>
    switch (p->state)
80104599:	8b 43 1c             	mov    0x1c(%ebx),%eax
      add_proc_to_new_queue(p, HIGH);
8010459c:	83 c4 10             	add    $0x10,%esp
    switch (p->state)
8010459f:	83 f8 03             	cmp    $0x3,%eax
801045a2:	75 b1                	jne    80104555 <update_proc_status+0x35>
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    case RUNNING:
      p->rutime++;
      break;
    case RUNNABLE:
      p->retime++;
801045a8:	83 43 0c 01          	addl   $0x1,0xc(%ebx)
  for (p = ptable.queue; p < &ptable.queue[NPROC]; p++) {
801045ac:	81 c3 98 00 00 00    	add    $0x98,%ebx
801045b2:	81 fb 6c 53 11 80    	cmp    $0x8011536c,%ebx
801045b8:	72 b7                	jb     80104571 <update_proc_status+0x51>
      break;
    default:
      break;
    }
  }
  release(&ptable.lock);
801045ba:	83 ec 0c             	sub    $0xc,%esp
801045bd:	68 20 2d 11 80       	push   $0x80112d20
801045c2:	e8 69 03 00 00       	call   80104930 <release>
}
801045c7:	83 c4 10             	add    $0x10,%esp
801045ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045cd:	c9                   	leave  
801045ce:	c3                   	ret    
801045cf:	90                   	nop
      p->rutime++;
801045d0:	83 43 10 01          	addl   $0x1,0x10(%ebx)
      break;
801045d4:	eb 8d                	jmp    80104563 <update_proc_status+0x43>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      remove_proc_from_its_queue(p);
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	53                   	push   %ebx
801045e4:	e8 77 f9 ff ff       	call   80103f60 <remove_proc_from_its_queue>
      add_proc_to_new_queue(p, MEDIUM);
801045e9:	59                   	pop    %ecx
801045ea:	58                   	pop    %eax
801045eb:	6a 01                	push   $0x1
801045ed:	53                   	push   %ebx
801045ee:	e8 5d fb ff ff       	call   80104150 <add_proc_to_new_queue>
801045f3:	83 c4 10             	add    $0x10,%esp
801045f6:	e9 52 ff ff ff       	jmp    8010454d <update_proc_status+0x2d>
801045fb:	66 90                	xchg   %ax,%ax
801045fd:	66 90                	xchg   %ax,%ax
801045ff:	90                   	nop

80104600 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010460a:	68 d8 7b 10 80       	push   $0x80107bd8
8010460f:	8d 43 04             	lea    0x4(%ebx),%eax
80104612:	50                   	push   %eax
80104613:	e8 18 01 00 00       	call   80104730 <initlock>
  lk->name = name;
80104618:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010461b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104621:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104624:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010462b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010462e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104631:	c9                   	leave  
80104632:	c3                   	ret    
80104633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	8d 73 04             	lea    0x4(%ebx),%esi
8010464e:	56                   	push   %esi
8010464f:	e8 1c 02 00 00       	call   80104870 <acquire>
  while (lk->locked) {
80104654:	8b 13                	mov    (%ebx),%edx
80104656:	83 c4 10             	add    $0x10,%esp
80104659:	85 d2                	test   %edx,%edx
8010465b:	74 16                	je     80104673 <acquiresleep+0x33>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104660:	83 ec 08             	sub    $0x8,%esp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	e8 d6 f7 ff ff       	call   80103e40 <sleep>
  while (lk->locked) {
8010466a:	8b 03                	mov    (%ebx),%eax
8010466c:	83 c4 10             	add    $0x10,%esp
8010466f:	85 c0                	test   %eax,%eax
80104671:	75 ed                	jne    80104660 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104673:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104679:	e8 82 f1 ff ff       	call   80103800 <myproc>
8010467e:	8b 40 24             	mov    0x24(%eax),%eax
80104681:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104684:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104687:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468a:	5b                   	pop    %ebx
8010468b:	5e                   	pop    %esi
8010468c:	5d                   	pop    %ebp
  release(&lk->lk);
8010468d:	e9 9e 02 00 00       	jmp    80104930 <release>
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	8d 73 04             	lea    0x4(%ebx),%esi
801046ae:	56                   	push   %esi
801046af:	e8 bc 01 00 00       	call   80104870 <acquire>
  lk->locked = 0;
801046b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046c1:	89 1c 24             	mov    %ebx,(%esp)
801046c4:	e8 37 f8 ff ff       	call   80103f00 <wakeup>
  release(&lk->lk);
801046c9:	89 75 08             	mov    %esi,0x8(%ebp)
801046cc:	83 c4 10             	add    $0x10,%esp
}
801046cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d2:	5b                   	pop    %ebx
801046d3:	5e                   	pop    %esi
801046d4:	5d                   	pop    %ebp
  release(&lk->lk);
801046d5:	e9 56 02 00 00       	jmp    80104930 <release>
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	31 ff                	xor    %edi,%edi
801046e8:	83 ec 18             	sub    $0x18,%esp
801046eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046ee:	8d 73 04             	lea    0x4(%ebx),%esi
801046f1:	56                   	push   %esi
801046f2:	e8 79 01 00 00       	call   80104870 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046f7:	8b 03                	mov    (%ebx),%eax
801046f9:	83 c4 10             	add    $0x10,%esp
801046fc:	85 c0                	test   %eax,%eax
801046fe:	74 13                	je     80104713 <holdingsleep+0x33>
80104700:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104703:	e8 f8 f0 ff ff       	call   80103800 <myproc>
80104708:	39 58 24             	cmp    %ebx,0x24(%eax)
8010470b:	0f 94 c0             	sete   %al
8010470e:	0f b6 c0             	movzbl %al,%eax
80104711:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104713:	83 ec 0c             	sub    $0xc,%esp
80104716:	56                   	push   %esi
80104717:	e8 14 02 00 00       	call   80104930 <release>
  return r;
}
8010471c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010471f:	89 f8                	mov    %edi,%eax
80104721:	5b                   	pop    %ebx
80104722:	5e                   	pop    %esi
80104723:	5f                   	pop    %edi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	66 90                	xchg   %ax,%ax
80104728:	66 90                	xchg   %ax,%ax
8010472a:	66 90                	xchg   %ax,%ax
8010472c:	66 90                	xchg   %ax,%ax
8010472e:	66 90                	xchg   %ax,%ax

80104730 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104736:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010473f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104742:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104750:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104751:	31 d2                	xor    %edx,%edx
{
80104753:	89 e5                	mov    %esp,%ebp
80104755:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104756:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104759:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010475c:	83 e8 08             	sub    $0x8,%eax
8010475f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104760:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104766:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010476c:	77 1a                	ja     80104788 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010476e:	8b 58 04             	mov    0x4(%eax),%ebx
80104771:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104774:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104777:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104779:	83 fa 0a             	cmp    $0xa,%edx
8010477c:	75 e2                	jne    80104760 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010477e:	5b                   	pop    %ebx
8010477f:	5d                   	pop    %ebp
80104780:	c3                   	ret    
80104781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104788:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010478b:	83 c1 28             	add    $0x28,%ecx
8010478e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104796:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104799:	39 c1                	cmp    %eax,%ecx
8010479b:	75 f3                	jne    80104790 <getcallerpcs+0x40>
}
8010479d:	5b                   	pop    %ebx
8010479e:	5d                   	pop    %ebp
8010479f:	c3                   	ret    

801047a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
801047a7:	9c                   	pushf  
801047a8:	5b                   	pop    %ebx
  asm volatile("cli");
801047a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047aa:	e8 b1 ef ff ff       	call   80103760 <mycpu>
801047af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047b5:	85 c0                	test   %eax,%eax
801047b7:	75 11                	jne    801047ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047b9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047bf:	e8 9c ef ff ff       	call   80103760 <mycpu>
801047c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047ca:	e8 91 ef ff ff       	call   80103760 <mycpu>
801047cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047d6:	83 c4 04             	add    $0x4,%esp
801047d9:	5b                   	pop    %ebx
801047da:	5d                   	pop    %ebp
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047e0 <popcli>:

void
popcli(void)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047e6:	9c                   	pushf  
801047e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047e8:	f6 c4 02             	test   $0x2,%ah
801047eb:	75 35                	jne    80104822 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047ed:	e8 6e ef ff ff       	call   80103760 <mycpu>
801047f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047f9:	78 34                	js     8010482f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047fb:	e8 60 ef ff ff       	call   80103760 <mycpu>
80104800:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104806:	85 d2                	test   %edx,%edx
80104808:	74 06                	je     80104810 <popcli+0x30>
    sti();
}
8010480a:	c9                   	leave  
8010480b:	c3                   	ret    
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104810:	e8 4b ef ff ff       	call   80103760 <mycpu>
80104815:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010481b:	85 c0                	test   %eax,%eax
8010481d:	74 eb                	je     8010480a <popcli+0x2a>
  asm volatile("sti");
8010481f:	fb                   	sti    
}
80104820:	c9                   	leave  
80104821:	c3                   	ret    
    panic("popcli - interruptible");
80104822:	83 ec 0c             	sub    $0xc,%esp
80104825:	68 e3 7b 10 80       	push   $0x80107be3
8010482a:	e8 61 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010482f:	83 ec 0c             	sub    $0xc,%esp
80104832:	68 fa 7b 10 80       	push   $0x80107bfa
80104837:	e8 54 bb ff ff       	call   80100390 <panic>
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <holding>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	8b 75 08             	mov    0x8(%ebp),%esi
80104848:	31 db                	xor    %ebx,%ebx
  pushcli();
8010484a:	e8 51 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010484f:	8b 06                	mov    (%esi),%eax
80104851:	85 c0                	test   %eax,%eax
80104853:	74 10                	je     80104865 <holding+0x25>
80104855:	8b 5e 08             	mov    0x8(%esi),%ebx
80104858:	e8 03 ef ff ff       	call   80103760 <mycpu>
8010485d:	39 c3                	cmp    %eax,%ebx
8010485f:	0f 94 c3             	sete   %bl
80104862:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104865:	e8 76 ff ff ff       	call   801047e0 <popcli>
}
8010486a:	89 d8                	mov    %ebx,%eax
8010486c:	5b                   	pop    %ebx
8010486d:	5e                   	pop    %esi
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret    

80104870 <acquire>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104875:	e8 26 ff ff ff       	call   801047a0 <pushcli>
  if(holding(lk))
8010487a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010487d:	83 ec 0c             	sub    $0xc,%esp
80104880:	53                   	push   %ebx
80104881:	e8 ba ff ff ff       	call   80104840 <holding>
80104886:	83 c4 10             	add    $0x10,%esp
80104889:	85 c0                	test   %eax,%eax
8010488b:	0f 85 83 00 00 00    	jne    80104914 <acquire+0xa4>
80104891:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104893:	ba 01 00 00 00       	mov    $0x1,%edx
80104898:	eb 09                	jmp    801048a3 <acquire+0x33>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048a3:	89 d0                	mov    %edx,%eax
801048a5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801048a8:	85 c0                	test   %eax,%eax
801048aa:	75 f4                	jne    801048a0 <acquire+0x30>
  __sync_synchronize();
801048ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048b4:	e8 a7 ee ff ff       	call   80103760 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048b9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801048bc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801048bf:	89 e8                	mov    %ebp,%eax
801048c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048c8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801048ce:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801048d4:	77 1a                	ja     801048f0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801048d6:	8b 48 04             	mov    0x4(%eax),%ecx
801048d9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801048dc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801048df:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048e1:	83 fe 0a             	cmp    $0xa,%esi
801048e4:	75 e2                	jne    801048c8 <acquire+0x58>
}
801048e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e9:	5b                   	pop    %ebx
801048ea:	5e                   	pop    %esi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret    
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
801048f0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801048f3:	83 c2 28             	add    $0x28,%edx
801048f6:	8d 76 00             	lea    0x0(%esi),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104906:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104909:	39 d0                	cmp    %edx,%eax
8010490b:	75 f3                	jne    80104900 <acquire+0x90>
}
8010490d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104910:	5b                   	pop    %ebx
80104911:	5e                   	pop    %esi
80104912:	5d                   	pop    %ebp
80104913:	c3                   	ret    
    panic("acquire");
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	68 01 7c 10 80       	push   $0x80107c01
8010491c:	e8 6f ba ff ff       	call   80100390 <panic>
80104921:	eb 0d                	jmp    80104930 <release>
80104923:	90                   	nop
80104924:	90                   	nop
80104925:	90                   	nop
80104926:	90                   	nop
80104927:	90                   	nop
80104928:	90                   	nop
80104929:	90                   	nop
8010492a:	90                   	nop
8010492b:	90                   	nop
8010492c:	90                   	nop
8010492d:	90                   	nop
8010492e:	90                   	nop
8010492f:	90                   	nop

80104930 <release>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 10             	sub    $0x10,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010493a:	53                   	push   %ebx
8010493b:	e8 00 ff ff ff       	call   80104840 <holding>
80104940:	83 c4 10             	add    $0x10,%esp
80104943:	85 c0                	test   %eax,%eax
80104945:	74 22                	je     80104969 <release+0x39>
  lk->pcs[0] = 0;
80104947:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010494e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104955:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010495a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104963:	c9                   	leave  
  popcli();
80104964:	e9 77 fe ff ff       	jmp    801047e0 <popcli>
    panic("release");
80104969:	83 ec 0c             	sub    $0xc,%esp
8010496c:	68 09 7c 10 80       	push   $0x80107c09
80104971:	e8 1a ba ff ff       	call   80100390 <panic>
80104976:	66 90                	xchg   %ax,%ax
80104978:	66 90                	xchg   %ax,%ax
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	53                   	push   %ebx
80104985:	8b 55 08             	mov    0x8(%ebp),%edx
80104988:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010498b:	f6 c2 03             	test   $0x3,%dl
8010498e:	75 05                	jne    80104995 <memset+0x15>
80104990:	f6 c1 03             	test   $0x3,%cl
80104993:	74 13                	je     801049a8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104995:	89 d7                	mov    %edx,%edi
80104997:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499a:	fc                   	cld    
8010499b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010499d:	5b                   	pop    %ebx
8010499e:	89 d0                	mov    %edx,%eax
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	90                   	nop
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801049a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049ac:	c1 e9 02             	shr    $0x2,%ecx
801049af:	89 f8                	mov    %edi,%eax
801049b1:	89 fb                	mov    %edi,%ebx
801049b3:	c1 e0 18             	shl    $0x18,%eax
801049b6:	c1 e3 10             	shl    $0x10,%ebx
801049b9:	09 d8                	or     %ebx,%eax
801049bb:	09 f8                	or     %edi,%eax
801049bd:	c1 e7 08             	shl    $0x8,%edi
801049c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049c2:	89 d7                	mov    %edx,%edi
801049c4:	fc                   	cld    
801049c5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801049c7:	5b                   	pop    %ebx
801049c8:	89 d0                	mov    %edx,%eax
801049ca:	5f                   	pop    %edi
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    
801049cd:	8d 76 00             	lea    0x0(%esi),%esi

801049d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049d9:	8b 75 08             	mov    0x8(%ebp),%esi
801049dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049df:	85 db                	test   %ebx,%ebx
801049e1:	74 29                	je     80104a0c <memcmp+0x3c>
    if(*s1 != *s2)
801049e3:	0f b6 16             	movzbl (%esi),%edx
801049e6:	0f b6 0f             	movzbl (%edi),%ecx
801049e9:	38 d1                	cmp    %dl,%cl
801049eb:	75 2b                	jne    80104a18 <memcmp+0x48>
801049ed:	b8 01 00 00 00       	mov    $0x1,%eax
801049f2:	eb 14                	jmp    80104a08 <memcmp+0x38>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801049fc:	83 c0 01             	add    $0x1,%eax
801049ff:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104a04:	38 ca                	cmp    %cl,%dl
80104a06:	75 10                	jne    80104a18 <memcmp+0x48>
  while(n-- > 0){
80104a08:	39 d8                	cmp    %ebx,%eax
80104a0a:	75 ec                	jne    801049f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a0c:	5b                   	pop    %ebx
  return 0;
80104a0d:	31 c0                	xor    %eax,%eax
}
80104a0f:	5e                   	pop    %esi
80104a10:	5f                   	pop    %edi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a18:	0f b6 c2             	movzbl %dl,%eax
}
80104a1b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a1c:	29 c8                	sub    %ecx,%eax
}
80104a1e:	5e                   	pop    %esi
80104a1f:	5f                   	pop    %edi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	8b 45 08             	mov    0x8(%ebp),%eax
80104a38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a3b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a3e:	39 c3                	cmp    %eax,%ebx
80104a40:	73 26                	jae    80104a68 <memmove+0x38>
80104a42:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104a45:	39 c8                	cmp    %ecx,%eax
80104a47:	73 1f                	jae    80104a68 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a49:	85 f6                	test   %esi,%esi
80104a4b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104a4e:	74 0f                	je     80104a5f <memmove+0x2f>
      *--d = *--s;
80104a50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a57:	83 ea 01             	sub    $0x1,%edx
80104a5a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a5d:	75 f1                	jne    80104a50 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a5f:	5b                   	pop    %ebx
80104a60:	5e                   	pop    %esi
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    
80104a63:	90                   	nop
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a68:	31 d2                	xor    %edx,%edx
80104a6a:	85 f6                	test   %esi,%esi
80104a6c:	74 f1                	je     80104a5f <memmove+0x2f>
80104a6e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a77:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a7a:	39 d6                	cmp    %edx,%esi
80104a7c:	75 f2                	jne    80104a70 <memmove+0x40>
}
80104a7e:	5b                   	pop    %ebx
80104a7f:	5e                   	pop    %esi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a93:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a94:	eb 9a                	jmp    80104a30 <memmove>
80104a96:	8d 76 00             	lea    0x0(%esi),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104aa8:	53                   	push   %ebx
80104aa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104aaf:	85 ff                	test   %edi,%edi
80104ab1:	74 2f                	je     80104ae2 <strncmp+0x42>
80104ab3:	0f b6 01             	movzbl (%ecx),%eax
80104ab6:	0f b6 1e             	movzbl (%esi),%ebx
80104ab9:	84 c0                	test   %al,%al
80104abb:	74 37                	je     80104af4 <strncmp+0x54>
80104abd:	38 c3                	cmp    %al,%bl
80104abf:	75 33                	jne    80104af4 <strncmp+0x54>
80104ac1:	01 f7                	add    %esi,%edi
80104ac3:	eb 13                	jmp    80104ad8 <strncmp+0x38>
80104ac5:	8d 76 00             	lea    0x0(%esi),%esi
80104ac8:	0f b6 01             	movzbl (%ecx),%eax
80104acb:	84 c0                	test   %al,%al
80104acd:	74 21                	je     80104af0 <strncmp+0x50>
80104acf:	0f b6 1a             	movzbl (%edx),%ebx
80104ad2:	89 d6                	mov    %edx,%esi
80104ad4:	38 d8                	cmp    %bl,%al
80104ad6:	75 1c                	jne    80104af4 <strncmp+0x54>
    n--, p++, q++;
80104ad8:	8d 56 01             	lea    0x1(%esi),%edx
80104adb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104ade:	39 fa                	cmp    %edi,%edx
80104ae0:	75 e6                	jne    80104ac8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ae2:	5b                   	pop    %ebx
    return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	5e                   	pop    %esi
80104ae6:	5f                   	pop    %edi
80104ae7:	5d                   	pop    %ebp
80104ae8:	c3                   	ret    
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104af4:	29 d8                	sub    %ebx,%eax
}
80104af6:	5b                   	pop    %ebx
80104af7:	5e                   	pop    %esi
80104af8:	5f                   	pop    %edi
80104af9:	5d                   	pop    %ebp
80104afa:	c3                   	ret    
80104afb:	90                   	nop
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 45 08             	mov    0x8(%ebp),%eax
80104b08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b0e:	89 c2                	mov    %eax,%edx
80104b10:	eb 19                	jmp    80104b2b <strncpy+0x2b>
80104b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b18:	83 c3 01             	add    $0x1,%ebx
80104b1b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b1f:	83 c2 01             	add    $0x1,%edx
80104b22:	84 c9                	test   %cl,%cl
80104b24:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b27:	74 09                	je     80104b32 <strncpy+0x32>
80104b29:	89 f1                	mov    %esi,%ecx
80104b2b:	85 c9                	test   %ecx,%ecx
80104b2d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b30:	7f e6                	jg     80104b18 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b32:	31 c9                	xor    %ecx,%ecx
80104b34:	85 f6                	test   %esi,%esi
80104b36:	7e 17                	jle    80104b4f <strncpy+0x4f>
80104b38:	90                   	nop
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b40:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b44:	89 f3                	mov    %esi,%ebx
80104b46:	83 c1 01             	add    $0x1,%ecx
80104b49:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104b4b:	85 db                	test   %ebx,%ebx
80104b4d:	7f f1                	jg     80104b40 <strncpy+0x40>
  return os;
}
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b68:	8b 45 08             	mov    0x8(%ebp),%eax
80104b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b6e:	85 c9                	test   %ecx,%ecx
80104b70:	7e 26                	jle    80104b98 <safestrcpy+0x38>
80104b72:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b76:	89 c1                	mov    %eax,%ecx
80104b78:	eb 17                	jmp    80104b91 <safestrcpy+0x31>
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b80:	83 c2 01             	add    $0x1,%edx
80104b83:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b87:	83 c1 01             	add    $0x1,%ecx
80104b8a:	84 db                	test   %bl,%bl
80104b8c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b8f:	74 04                	je     80104b95 <safestrcpy+0x35>
80104b91:	39 f2                	cmp    %esi,%edx
80104b93:	75 eb                	jne    80104b80 <safestrcpy+0x20>
    ;
  *s = 0;
80104b95:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b98:	5b                   	pop    %ebx
80104b99:	5e                   	pop    %esi
80104b9a:	5d                   	pop    %ebp
80104b9b:	c3                   	ret    
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <strlen>:

int
strlen(const char *s)
{
80104ba0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ba1:	31 c0                	xor    %eax,%eax
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ba8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bab:	74 0c                	je     80104bb9 <strlen+0x19>
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	83 c0 01             	add    $0x1,%eax
80104bb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bb7:	75 f7                	jne    80104bb0 <strlen+0x10>
    ;
  return n;
}
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    

80104bbb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bbb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bbf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bc3:	55                   	push   %ebp
  pushl %ebx
80104bc4:	53                   	push   %ebx
  pushl %esi
80104bc5:	56                   	push   %esi
  pushl %edi
80104bc6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bc7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bc9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bcb:	5f                   	pop    %edi
  popl %esi
80104bcc:	5e                   	pop    %esi
  popl %ebx
80104bcd:	5b                   	pop    %ebx
  popl %ebp
80104bce:	5d                   	pop    %ebp
  ret
80104bcf:	c3                   	ret    

80104bd0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bda:	e8 21 ec ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bdf:	8b 00                	mov    (%eax),%eax
80104be1:	39 d8                	cmp    %ebx,%eax
80104be3:	76 1b                	jbe    80104c00 <fetchint+0x30>
80104be5:	8d 53 04             	lea    0x4(%ebx),%edx
80104be8:	39 d0                	cmp    %edx,%eax
80104bea:	72 14                	jb     80104c00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bef:	8b 13                	mov    (%ebx),%edx
80104bf1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bf3:	31 c0                	xor    %eax,%eax
}
80104bf5:	83 c4 04             	add    $0x4,%esp
80104bf8:	5b                   	pop    %ebx
80104bf9:	5d                   	pop    %ebp
80104bfa:	c3                   	ret    
80104bfb:	90                   	nop
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ee                	jmp    80104bf5 <fetchint+0x25>
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c1a:	e8 e1 eb ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz)
80104c1f:	39 18                	cmp    %ebx,(%eax)
80104c21:	76 29                	jbe    80104c4c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c26:	89 da                	mov    %ebx,%edx
80104c28:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c2a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c2c:	39 c3                	cmp    %eax,%ebx
80104c2e:	73 1c                	jae    80104c4c <fetchstr+0x3c>
    if(*s == 0)
80104c30:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c33:	75 10                	jne    80104c45 <fetchstr+0x35>
80104c35:	eb 39                	jmp    80104c70 <fetchstr+0x60>
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c40:	80 3a 00             	cmpb   $0x0,(%edx)
80104c43:	74 1b                	je     80104c60 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104c45:	83 c2 01             	add    $0x1,%edx
80104c48:	39 d0                	cmp    %edx,%eax
80104c4a:	77 f4                	ja     80104c40 <fetchstr+0x30>
    return -1;
80104c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c51:	83 c4 04             	add    $0x4,%esp
80104c54:	5b                   	pop    %ebx
80104c55:	5d                   	pop    %ebp
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c60:	83 c4 04             	add    $0x4,%esp
80104c63:	89 d0                	mov    %edx,%eax
80104c65:	29 d8                	sub    %ebx,%eax
80104c67:	5b                   	pop    %ebx
80104c68:	5d                   	pop    %ebp
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c70:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c72:	eb dd                	jmp    80104c51 <fetchstr+0x41>
80104c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c85:	e8 76 eb ff ff       	call   80103800 <myproc>
80104c8a:	8b 40 2c             	mov    0x2c(%eax),%eax
80104c8d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c90:	8b 40 44             	mov    0x44(%eax),%eax
80104c93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c96:	e8 65 eb ff ff       	call   80103800 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c9b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c9d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ca0:	39 c6                	cmp    %eax,%esi
80104ca2:	73 1c                	jae    80104cc0 <argint+0x40>
80104ca4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ca7:	39 d0                	cmp    %edx,%eax
80104ca9:	72 15                	jb     80104cc0 <argint+0x40>
  *ip = *(int*)(addr);
80104cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cae:	8b 53 04             	mov    0x4(%ebx),%edx
80104cb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	5b                   	pop    %ebx
80104cb6:	5e                   	pop    %esi
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cc5:	eb ee                	jmp    80104cb5 <argint+0x35>
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
80104cd5:	83 ec 10             	sub    $0x10,%esp
80104cd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104cdb:	e8 20 eb ff ff       	call   80103800 <myproc>
80104ce0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce5:	83 ec 08             	sub    $0x8,%esp
80104ce8:	50                   	push   %eax
80104ce9:	ff 75 08             	pushl  0x8(%ebp)
80104cec:	e8 8f ff ff ff       	call   80104c80 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	78 28                	js     80104d20 <argptr+0x50>
80104cf8:	85 db                	test   %ebx,%ebx
80104cfa:	78 24                	js     80104d20 <argptr+0x50>
80104cfc:	8b 16                	mov    (%esi),%edx
80104cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d01:	39 c2                	cmp    %eax,%edx
80104d03:	76 1b                	jbe    80104d20 <argptr+0x50>
80104d05:	01 c3                	add    %eax,%ebx
80104d07:	39 da                	cmp    %ebx,%edx
80104d09:	72 15                	jb     80104d20 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d0e:	89 02                	mov    %eax,(%edx)
  return 0;
80104d10:	31 c0                	xor    %eax,%eax
}
80104d12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d15:	5b                   	pop    %ebx
80104d16:	5e                   	pop    %esi
80104d17:	5d                   	pop    %ebp
80104d18:	c3                   	ret    
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	eb eb                	jmp    80104d12 <argptr+0x42>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d39:	50                   	push   %eax
80104d3a:	ff 75 08             	pushl  0x8(%ebp)
80104d3d:	e8 3e ff ff ff       	call   80104c80 <argint>
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	85 c0                	test   %eax,%eax
80104d47:	78 17                	js     80104d60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d49:	83 ec 08             	sub    $0x8,%esp
80104d4c:	ff 75 0c             	pushl  0xc(%ebp)
80104d4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d52:	e8 b9 fe ff ff       	call   80104c10 <fetchstr>
80104d57:	83 c4 10             	add    $0x10,%esp
}
80104d5a:	c9                   	leave  
80104d5b:	c3                   	ret    
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d77:	e8 84 ea ff ff       	call   80103800 <myproc>
80104d7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d7e:	8b 40 2c             	mov    0x2c(%eax),%eax
80104d81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d87:	83 fa 17             	cmp    $0x17,%edx
80104d8a:	77 1c                	ja     80104da8 <syscall+0x38>
80104d8c:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
80104d93:	85 d2                	test   %edx,%edx
80104d95:	74 11                	je     80104da8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d97:	ff d2                	call   *%edx
80104d99:	8b 53 2c             	mov    0x2c(%ebx),%edx
80104d9c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104da2:	c9                   	leave  
80104da3:	c3                   	ret    
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104da8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104da9:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104daf:	50                   	push   %eax
80104db0:	ff 73 24             	pushl  0x24(%ebx)
80104db3:	68 11 7c 10 80       	push   $0x80107c11
80104db8:	e8 a3 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104dbd:	8b 43 2c             	mov    0x2c(%ebx),%eax
80104dc0:	83 c4 10             	add    $0x10,%esp
80104dc3:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dcd:	c9                   	leave  
80104dce:	c3                   	ret    
80104dcf:	90                   	nop

80104dd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dd6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104dd9:	83 ec 34             	sub    $0x34,%esp
80104ddc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104de2:	56                   	push   %esi
80104de3:	50                   	push   %eax
{
80104de4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104de7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dea:	e8 11 d1 ff ff       	call   80101f00 <nameiparent>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	0f 84 46 01 00 00    	je     80104f40 <create+0x170>
    return 0;
  ilock(dp);
80104dfa:	83 ec 0c             	sub    $0xc,%esp
80104dfd:	89 c3                	mov    %eax,%ebx
80104dff:	50                   	push   %eax
80104e00:	e8 7b c8 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e05:	83 c4 0c             	add    $0xc,%esp
80104e08:	6a 00                	push   $0x0
80104e0a:	56                   	push   %esi
80104e0b:	53                   	push   %ebx
80104e0c:	e8 9f cd ff ff       	call   80101bb0 <dirlookup>
80104e11:	83 c4 10             	add    $0x10,%esp
80104e14:	85 c0                	test   %eax,%eax
80104e16:	89 c7                	mov    %eax,%edi
80104e18:	74 36                	je     80104e50 <create+0x80>
    iunlockput(dp);
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	53                   	push   %ebx
80104e1e:	e8 ed ca ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104e23:	89 3c 24             	mov    %edi,(%esp)
80104e26:	e8 55 c8 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e2b:	83 c4 10             	add    $0x10,%esp
80104e2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e33:	0f 85 97 00 00 00    	jne    80104ed0 <create+0x100>
80104e39:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104e3e:	0f 85 8c 00 00 00    	jne    80104ed0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e47:	89 f8                	mov    %edi,%eax
80104e49:	5b                   	pop    %ebx
80104e4a:	5e                   	pop    %esi
80104e4b:	5f                   	pop    %edi
80104e4c:	5d                   	pop    %ebp
80104e4d:	c3                   	ret    
80104e4e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104e50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e54:	83 ec 08             	sub    $0x8,%esp
80104e57:	50                   	push   %eax
80104e58:	ff 33                	pushl  (%ebx)
80104e5a:	e8 b1 c6 ff ff       	call   80101510 <ialloc>
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	85 c0                	test   %eax,%eax
80104e64:	89 c7                	mov    %eax,%edi
80104e66:	0f 84 e8 00 00 00    	je     80104f54 <create+0x184>
  ilock(ip);
80104e6c:	83 ec 0c             	sub    $0xc,%esp
80104e6f:	50                   	push   %eax
80104e70:	e8 0b c8 ff ff       	call   80101680 <ilock>
  ip->major = major;
80104e75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e79:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e81:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e85:	b8 01 00 00 00       	mov    $0x1,%eax
80104e8a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e8e:	89 3c 24             	mov    %edi,(%esp)
80104e91:	e8 3a c7 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e96:	83 c4 10             	add    $0x10,%esp
80104e99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e9e:	74 50                	je     80104ef0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ea0:	83 ec 04             	sub    $0x4,%esp
80104ea3:	ff 77 04             	pushl  0x4(%edi)
80104ea6:	56                   	push   %esi
80104ea7:	53                   	push   %ebx
80104ea8:	e8 73 cf ff ff       	call   80101e20 <dirlink>
80104ead:	83 c4 10             	add    $0x10,%esp
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	0f 88 8f 00 00 00    	js     80104f47 <create+0x177>
  iunlockput(dp);
80104eb8:	83 ec 0c             	sub    $0xc,%esp
80104ebb:	53                   	push   %ebx
80104ebc:	e8 4f ca ff ff       	call   80101910 <iunlockput>
  return ip;
80104ec1:	83 c4 10             	add    $0x10,%esp
}
80104ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ec7:	89 f8                	mov    %edi,%eax
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5f                   	pop    %edi
80104ecc:	5d                   	pop    %ebp
80104ecd:	c3                   	ret    
80104ece:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104ed0:	83 ec 0c             	sub    $0xc,%esp
80104ed3:	57                   	push   %edi
    return 0;
80104ed4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104ed6:	e8 35 ca ff ff       	call   80101910 <iunlockput>
    return 0;
80104edb:	83 c4 10             	add    $0x10,%esp
}
80104ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee1:	89 f8                	mov    %edi,%eax
80104ee3:	5b                   	pop    %ebx
80104ee4:	5e                   	pop    %esi
80104ee5:	5f                   	pop    %edi
80104ee6:	5d                   	pop    %ebp
80104ee7:	c3                   	ret    
80104ee8:	90                   	nop
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104ef0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ef5:	83 ec 0c             	sub    $0xc,%esp
80104ef8:	53                   	push   %ebx
80104ef9:	e8 d2 c6 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104efe:	83 c4 0c             	add    $0xc,%esp
80104f01:	ff 77 04             	pushl  0x4(%edi)
80104f04:	68 c0 7c 10 80       	push   $0x80107cc0
80104f09:	57                   	push   %edi
80104f0a:	e8 11 cf ff ff       	call   80101e20 <dirlink>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	78 1c                	js     80104f32 <create+0x162>
80104f16:	83 ec 04             	sub    $0x4,%esp
80104f19:	ff 73 04             	pushl  0x4(%ebx)
80104f1c:	68 bf 7c 10 80       	push   $0x80107cbf
80104f21:	57                   	push   %edi
80104f22:	e8 f9 ce ff ff       	call   80101e20 <dirlink>
80104f27:	83 c4 10             	add    $0x10,%esp
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	0f 89 6e ff ff ff    	jns    80104ea0 <create+0xd0>
      panic("create dots");
80104f32:	83 ec 0c             	sub    $0xc,%esp
80104f35:	68 b3 7c 10 80       	push   $0x80107cb3
80104f3a:	e8 51 b4 ff ff       	call   80100390 <panic>
80104f3f:	90                   	nop
    return 0;
80104f40:	31 ff                	xor    %edi,%edi
80104f42:	e9 fd fe ff ff       	jmp    80104e44 <create+0x74>
    panic("create: dirlink");
80104f47:	83 ec 0c             	sub    $0xc,%esp
80104f4a:	68 c2 7c 10 80       	push   $0x80107cc2
80104f4f:	e8 3c b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f54:	83 ec 0c             	sub    $0xc,%esp
80104f57:	68 a4 7c 10 80       	push   $0x80107ca4
80104f5c:	e8 2f b4 ff ff       	call   80100390 <panic>
80104f61:	eb 0d                	jmp    80104f70 <argfd.constprop.0>
80104f63:	90                   	nop
80104f64:	90                   	nop
80104f65:	90                   	nop
80104f66:	90                   	nop
80104f67:	90                   	nop
80104f68:	90                   	nop
80104f69:	90                   	nop
80104f6a:	90                   	nop
80104f6b:	90                   	nop
80104f6c:	90                   	nop
80104f6d:	90                   	nop
80104f6e:	90                   	nop
80104f6f:	90                   	nop

80104f70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
80104f75:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f77:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f7a:	89 d6                	mov    %edx,%esi
80104f7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7f:	50                   	push   %eax
80104f80:	6a 00                	push   $0x0
80104f82:	e8 f9 fc ff ff       	call   80104c80 <argint>
80104f87:	83 c4 10             	add    $0x10,%esp
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	78 2a                	js     80104fb8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f92:	77 24                	ja     80104fb8 <argfd.constprop.0+0x48>
80104f94:	e8 67 e8 ff ff       	call   80103800 <myproc>
80104f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f9c:	8b 44 90 3c          	mov    0x3c(%eax,%edx,4),%eax
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	74 14                	je     80104fb8 <argfd.constprop.0+0x48>
  if(pfd)
80104fa4:	85 db                	test   %ebx,%ebx
80104fa6:	74 02                	je     80104faa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104fa8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104faa:	89 06                	mov    %eax,(%esi)
  return 0;
80104fac:	31 c0                	xor    %eax,%eax
}
80104fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb1:	5b                   	pop    %ebx
80104fb2:	5e                   	pop    %esi
80104fb3:	5d                   	pop    %ebp
80104fb4:	c3                   	ret    
80104fb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fbd:	eb ef                	jmp    80104fae <argfd.constprop.0+0x3e>
80104fbf:	90                   	nop

80104fc0 <sys_dup>:
{
80104fc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104fc1:	31 c0                	xor    %eax,%eax
{
80104fc3:	89 e5                	mov    %esp,%ebp
80104fc5:	56                   	push   %esi
80104fc6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104fc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104fca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104fcd:	e8 9e ff ff ff       	call   80104f70 <argfd.constprop.0>
80104fd2:	85 c0                	test   %eax,%eax
80104fd4:	78 42                	js     80105018 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104fd6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104fd9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104fdb:	e8 20 e8 ff ff       	call   80103800 <myproc>
80104fe0:	eb 0e                	jmp    80104ff0 <sys_dup+0x30>
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104fe8:	83 c3 01             	add    $0x1,%ebx
80104feb:	83 fb 10             	cmp    $0x10,%ebx
80104fee:	74 28                	je     80105018 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104ff0:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
80104ff4:	85 d2                	test   %edx,%edx
80104ff6:	75 f0                	jne    80104fe8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104ff8:	89 74 98 3c          	mov    %esi,0x3c(%eax,%ebx,4)
  filedup(f);
80104ffc:	83 ec 0c             	sub    $0xc,%esp
80104fff:	ff 75 f4             	pushl  -0xc(%ebp)
80105002:	e8 e9 bd ff ff       	call   80100df0 <filedup>
  return fd;
80105007:	83 c4 10             	add    $0x10,%esp
}
8010500a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500d:	89 d8                	mov    %ebx,%eax
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	90                   	nop
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010501b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105020:	89 d8                	mov    %ebx,%eax
80105022:	5b                   	pop    %ebx
80105023:	5e                   	pop    %esi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_read>:
{
80105030:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105031:	31 c0                	xor    %eax,%eax
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105038:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010503b:	e8 30 ff ff ff       	call   80104f70 <argfd.constprop.0>
80105040:	85 c0                	test   %eax,%eax
80105042:	78 4c                	js     80105090 <sys_read+0x60>
80105044:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105047:	83 ec 08             	sub    $0x8,%esp
8010504a:	50                   	push   %eax
8010504b:	6a 02                	push   $0x2
8010504d:	e8 2e fc ff ff       	call   80104c80 <argint>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	78 37                	js     80105090 <sys_read+0x60>
80105059:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505c:	83 ec 04             	sub    $0x4,%esp
8010505f:	ff 75 f0             	pushl  -0x10(%ebp)
80105062:	50                   	push   %eax
80105063:	6a 01                	push   $0x1
80105065:	e8 66 fc ff ff       	call   80104cd0 <argptr>
8010506a:	83 c4 10             	add    $0x10,%esp
8010506d:	85 c0                	test   %eax,%eax
8010506f:	78 1f                	js     80105090 <sys_read+0x60>
  return fileread(f, p, n);
80105071:	83 ec 04             	sub    $0x4,%esp
80105074:	ff 75 f0             	pushl  -0x10(%ebp)
80105077:	ff 75 f4             	pushl  -0xc(%ebp)
8010507a:	ff 75 ec             	pushl  -0x14(%ebp)
8010507d:	e8 de be ff ff       	call   80100f60 <fileread>
80105082:	83 c4 10             	add    $0x10,%esp
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_write>:
{
801050a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a1:	31 c0                	xor    %eax,%eax
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050ab:	e8 c0 fe ff ff       	call   80104f70 <argfd.constprop.0>
801050b0:	85 c0                	test   %eax,%eax
801050b2:	78 4c                	js     80105100 <sys_write+0x60>
801050b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b7:	83 ec 08             	sub    $0x8,%esp
801050ba:	50                   	push   %eax
801050bb:	6a 02                	push   $0x2
801050bd:	e8 be fb ff ff       	call   80104c80 <argint>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 37                	js     80105100 <sys_write+0x60>
801050c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050cc:	83 ec 04             	sub    $0x4,%esp
801050cf:	ff 75 f0             	pushl  -0x10(%ebp)
801050d2:	50                   	push   %eax
801050d3:	6a 01                	push   $0x1
801050d5:	e8 f6 fb ff ff       	call   80104cd0 <argptr>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	78 1f                	js     80105100 <sys_write+0x60>
  return filewrite(f, p, n);
801050e1:	83 ec 04             	sub    $0x4,%esp
801050e4:	ff 75 f0             	pushl  -0x10(%ebp)
801050e7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ea:	ff 75 ec             	pushl  -0x14(%ebp)
801050ed:	e8 fe be ff ff       	call   80100ff0 <filewrite>
801050f2:	83 c4 10             	add    $0x10,%esp
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_close>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105116:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105119:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010511c:	e8 4f fe ff ff       	call   80104f70 <argfd.constprop.0>
80105121:	85 c0                	test   %eax,%eax
80105123:	78 2b                	js     80105150 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105125:	e8 d6 e6 ff ff       	call   80103800 <myproc>
8010512a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010512d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105130:	c7 44 90 3c 00 00 00 	movl   $0x0,0x3c(%eax,%edx,4)
80105137:	00 
  fileclose(f);
80105138:	ff 75 f4             	pushl  -0xc(%ebp)
8010513b:	e8 00 bd ff ff       	call   80100e40 <fileclose>
  return 0;
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	31 c0                	xor    %eax,%eax
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_fstat>:
{
80105160:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105168:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010516b:	e8 00 fe ff ff       	call   80104f70 <argfd.constprop.0>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 2c                	js     801051a0 <sys_fstat+0x40>
80105174:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105177:	83 ec 04             	sub    $0x4,%esp
8010517a:	6a 14                	push   $0x14
8010517c:	50                   	push   %eax
8010517d:	6a 01                	push   $0x1
8010517f:	e8 4c fb ff ff       	call   80104cd0 <argptr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	78 15                	js     801051a0 <sys_fstat+0x40>
  return filestat(f, st);
8010518b:	83 ec 08             	sub    $0x8,%esp
8010518e:	ff 75 f4             	pushl  -0xc(%ebp)
80105191:	ff 75 f0             	pushl  -0x10(%ebp)
80105194:	e8 77 bd ff ff       	call   80100f10 <filestat>
80105199:	83 c4 10             	add    $0x10,%esp
}
8010519c:	c9                   	leave  
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_link>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051bc:	50                   	push   %eax
801051bd:	6a 00                	push   $0x0
801051bf:	e8 6c fb ff ff       	call   80104d30 <argstr>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	0f 88 fb 00 00 00    	js     801052ca <sys_link+0x11a>
801051cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051d2:	83 ec 08             	sub    $0x8,%esp
801051d5:	50                   	push   %eax
801051d6:	6a 01                	push   $0x1
801051d8:	e8 53 fb ff ff       	call   80104d30 <argstr>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	85 c0                	test   %eax,%eax
801051e2:	0f 88 e2 00 00 00    	js     801052ca <sys_link+0x11a>
  begin_op();
801051e8:	e8 b3 d9 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051f3:	e8 e8 cc ff ff       	call   80101ee0 <namei>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	89 c3                	mov    %eax,%ebx
801051ff:	0f 84 ea 00 00 00    	je     801052ef <sys_link+0x13f>
  ilock(ip);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	50                   	push   %eax
80105209:	e8 72 c4 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105216:	0f 84 bb 00 00 00    	je     801052d7 <sys_link+0x127>
  ip->nlink++;
8010521c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105221:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105224:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105227:	53                   	push   %ebx
80105228:	e8 a3 c3 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010522d:	89 1c 24             	mov    %ebx,(%esp)
80105230:	e8 2b c5 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105235:	58                   	pop    %eax
80105236:	5a                   	pop    %edx
80105237:	57                   	push   %edi
80105238:	ff 75 d0             	pushl  -0x30(%ebp)
8010523b:	e8 c0 cc ff ff       	call   80101f00 <nameiparent>
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	85 c0                	test   %eax,%eax
80105245:	89 c6                	mov    %eax,%esi
80105247:	74 5b                	je     801052a4 <sys_link+0xf4>
  ilock(dp);
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	50                   	push   %eax
8010524d:	e8 2e c4 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	8b 03                	mov    (%ebx),%eax
80105257:	39 06                	cmp    %eax,(%esi)
80105259:	75 3d                	jne    80105298 <sys_link+0xe8>
8010525b:	83 ec 04             	sub    $0x4,%esp
8010525e:	ff 73 04             	pushl  0x4(%ebx)
80105261:	57                   	push   %edi
80105262:	56                   	push   %esi
80105263:	e8 b8 cb ff ff       	call   80101e20 <dirlink>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	78 29                	js     80105298 <sys_link+0xe8>
  iunlockput(dp);
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	56                   	push   %esi
80105273:	e8 98 c6 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105278:	89 1c 24             	mov    %ebx,(%esp)
8010527b:	e8 30 c5 ff ff       	call   801017b0 <iput>
  end_op();
80105280:	e8 8b d9 ff ff       	call   80102c10 <end_op>
  return 0;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	31 c0                	xor    %eax,%eax
}
8010528a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010528d:	5b                   	pop    %ebx
8010528e:	5e                   	pop    %esi
8010528f:	5f                   	pop    %edi
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    
80105292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	56                   	push   %esi
8010529c:	e8 6f c6 ff ff       	call   80101910 <iunlockput>
    goto bad;
801052a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	53                   	push   %ebx
801052a8:	e8 d3 c3 ff ff       	call   80101680 <ilock>
  ip->nlink--;
801052ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b2:	89 1c 24             	mov    %ebx,(%esp)
801052b5:	e8 16 c3 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801052ba:	89 1c 24             	mov    %ebx,(%esp)
801052bd:	e8 4e c6 ff ff       	call   80101910 <iunlockput>
  end_op();
801052c2:	e8 49 d9 ff ff       	call   80102c10 <end_op>
  return -1;
801052c7:	83 c4 10             	add    $0x10,%esp
}
801052ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801052cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d2:	5b                   	pop    %ebx
801052d3:	5e                   	pop    %esi
801052d4:	5f                   	pop    %edi
801052d5:	5d                   	pop    %ebp
801052d6:	c3                   	ret    
    iunlockput(ip);
801052d7:	83 ec 0c             	sub    $0xc,%esp
801052da:	53                   	push   %ebx
801052db:	e8 30 c6 ff ff       	call   80101910 <iunlockput>
    end_op();
801052e0:	e8 2b d9 ff ff       	call   80102c10 <end_op>
    return -1;
801052e5:	83 c4 10             	add    $0x10,%esp
801052e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ed:	eb 9b                	jmp    8010528a <sys_link+0xda>
    end_op();
801052ef:	e8 1c d9 ff ff       	call   80102c10 <end_op>
    return -1;
801052f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f9:	eb 8f                	jmp    8010528a <sys_link+0xda>
801052fb:	90                   	nop
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_unlink>:
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
80105305:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105306:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105309:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010530c:	50                   	push   %eax
8010530d:	6a 00                	push   $0x0
8010530f:	e8 1c fa ff ff       	call   80104d30 <argstr>
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
80105319:	0f 88 77 01 00 00    	js     80105496 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010531f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105322:	e8 79 d8 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105327:	83 ec 08             	sub    $0x8,%esp
8010532a:	53                   	push   %ebx
8010532b:	ff 75 c0             	pushl  -0x40(%ebp)
8010532e:	e8 cd cb ff ff       	call   80101f00 <nameiparent>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	89 c6                	mov    %eax,%esi
8010533a:	0f 84 60 01 00 00    	je     801054a0 <sys_unlink+0x1a0>
  ilock(dp);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	50                   	push   %eax
80105344:	e8 37 c3 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105349:	58                   	pop    %eax
8010534a:	5a                   	pop    %edx
8010534b:	68 c0 7c 10 80       	push   $0x80107cc0
80105350:	53                   	push   %ebx
80105351:	e8 3a c8 ff ff       	call   80101b90 <namecmp>
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	85 c0                	test   %eax,%eax
8010535b:	0f 84 03 01 00 00    	je     80105464 <sys_unlink+0x164>
80105361:	83 ec 08             	sub    $0x8,%esp
80105364:	68 bf 7c 10 80       	push   $0x80107cbf
80105369:	53                   	push   %ebx
8010536a:	e8 21 c8 ff ff       	call   80101b90 <namecmp>
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	85 c0                	test   %eax,%eax
80105374:	0f 84 ea 00 00 00    	je     80105464 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010537a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010537d:	83 ec 04             	sub    $0x4,%esp
80105380:	50                   	push   %eax
80105381:	53                   	push   %ebx
80105382:	56                   	push   %esi
80105383:	e8 28 c8 ff ff       	call   80101bb0 <dirlookup>
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	85 c0                	test   %eax,%eax
8010538d:	89 c3                	mov    %eax,%ebx
8010538f:	0f 84 cf 00 00 00    	je     80105464 <sys_unlink+0x164>
  ilock(ip);
80105395:	83 ec 0c             	sub    $0xc,%esp
80105398:	50                   	push   %eax
80105399:	e8 e2 c2 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053a6:	0f 8e 10 01 00 00    	jle    801054bc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b1:	74 6d                	je     80105420 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053b6:	83 ec 04             	sub    $0x4,%esp
801053b9:	6a 10                	push   $0x10
801053bb:	6a 00                	push   $0x0
801053bd:	50                   	push   %eax
801053be:	e8 bd f5 ff ff       	call   80104980 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053c6:	6a 10                	push   $0x10
801053c8:	ff 75 c4             	pushl  -0x3c(%ebp)
801053cb:	50                   	push   %eax
801053cc:	56                   	push   %esi
801053cd:	e8 8e c6 ff ff       	call   80101a60 <writei>
801053d2:	83 c4 20             	add    $0x20,%esp
801053d5:	83 f8 10             	cmp    $0x10,%eax
801053d8:	0f 85 eb 00 00 00    	jne    801054c9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801053de:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e3:	0f 84 97 00 00 00    	je     80105480 <sys_unlink+0x180>
  iunlockput(dp);
801053e9:	83 ec 0c             	sub    $0xc,%esp
801053ec:	56                   	push   %esi
801053ed:	e8 1e c5 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
801053f2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053f7:	89 1c 24             	mov    %ebx,(%esp)
801053fa:	e8 d1 c1 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801053ff:	89 1c 24             	mov    %ebx,(%esp)
80105402:	e8 09 c5 ff ff       	call   80101910 <iunlockput>
  end_op();
80105407:	e8 04 d8 ff ff       	call   80102c10 <end_op>
  return 0;
8010540c:	83 c4 10             	add    $0x10,%esp
8010540f:	31 c0                	xor    %eax,%eax
}
80105411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105414:	5b                   	pop    %ebx
80105415:	5e                   	pop    %esi
80105416:	5f                   	pop    %edi
80105417:	5d                   	pop    %ebp
80105418:	c3                   	ret    
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105420:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105424:	76 8d                	jbe    801053b3 <sys_unlink+0xb3>
80105426:	bf 20 00 00 00       	mov    $0x20,%edi
8010542b:	eb 0f                	jmp    8010543c <sys_unlink+0x13c>
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
80105430:	83 c7 10             	add    $0x10,%edi
80105433:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105436:	0f 83 77 ff ff ff    	jae    801053b3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010543c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010543f:	6a 10                	push   $0x10
80105441:	57                   	push   %edi
80105442:	50                   	push   %eax
80105443:	53                   	push   %ebx
80105444:	e8 17 c5 ff ff       	call   80101960 <readi>
80105449:	83 c4 10             	add    $0x10,%esp
8010544c:	83 f8 10             	cmp    $0x10,%eax
8010544f:	75 5e                	jne    801054af <sys_unlink+0x1af>
    if(de.inum != 0)
80105451:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105456:	74 d8                	je     80105430 <sys_unlink+0x130>
    iunlockput(ip);
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	53                   	push   %ebx
8010545c:	e8 af c4 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105461:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	56                   	push   %esi
80105468:	e8 a3 c4 ff ff       	call   80101910 <iunlockput>
  end_op();
8010546d:	e8 9e d7 ff ff       	call   80102c10 <end_op>
  return -1;
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547a:	eb 95                	jmp    80105411 <sys_unlink+0x111>
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105480:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	56                   	push   %esi
80105489:	e8 42 c1 ff ff       	call   801015d0 <iupdate>
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	e9 53 ff ff ff       	jmp    801053e9 <sys_unlink+0xe9>
    return -1;
80105496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549b:	e9 71 ff ff ff       	jmp    80105411 <sys_unlink+0x111>
    end_op();
801054a0:	e8 6b d7 ff ff       	call   80102c10 <end_op>
    return -1;
801054a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054aa:	e9 62 ff ff ff       	jmp    80105411 <sys_unlink+0x111>
      panic("isdirempty: readi");
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	68 e4 7c 10 80       	push   $0x80107ce4
801054b7:	e8 d4 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	68 d2 7c 10 80       	push   $0x80107cd2
801054c4:	e8 c7 ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	68 f6 7c 10 80       	push   $0x80107cf6
801054d1:	e8 ba ae ff ff       	call   80100390 <panic>
801054d6:	8d 76 00             	lea    0x0(%esi),%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_open>:

int
sys_open(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
801054e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 3c f8 ff ff       	call   80104d30 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 1d 01 00 00    	js     8010561c <sys_open+0x13c>
801054ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105502:	83 ec 08             	sub    $0x8,%esp
80105505:	50                   	push   %eax
80105506:	6a 01                	push   $0x1
80105508:	e8 73 f7 ff ff       	call   80104c80 <argint>
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	85 c0                	test   %eax,%eax
80105512:	0f 88 04 01 00 00    	js     8010561c <sys_open+0x13c>
    return -1;

  begin_op();
80105518:	e8 83 d6 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
8010551d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105521:	0f 85 a9 00 00 00    	jne    801055d0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105527:	83 ec 0c             	sub    $0xc,%esp
8010552a:	ff 75 e0             	pushl  -0x20(%ebp)
8010552d:	e8 ae c9 ff ff       	call   80101ee0 <namei>
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	85 c0                	test   %eax,%eax
80105537:	89 c6                	mov    %eax,%esi
80105539:	0f 84 b2 00 00 00    	je     801055f1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010553f:	83 ec 0c             	sub    $0xc,%esp
80105542:	50                   	push   %eax
80105543:	e8 38 c1 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105550:	0f 84 aa 00 00 00    	je     80105600 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105556:	e8 25 b8 ff ff       	call   80100d80 <filealloc>
8010555b:	85 c0                	test   %eax,%eax
8010555d:	89 c7                	mov    %eax,%edi
8010555f:	0f 84 a6 00 00 00    	je     8010560b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105565:	e8 96 e2 ff ff       	call   80103800 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556a:	31 db                	xor    %ebx,%ebx
8010556c:	eb 0e                	jmp    8010557c <sys_open+0x9c>
8010556e:	66 90                	xchg   %ax,%ax
80105570:	83 c3 01             	add    $0x1,%ebx
80105573:	83 fb 10             	cmp    $0x10,%ebx
80105576:	0f 84 ac 00 00 00    	je     80105628 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010557c:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
80105580:	85 d2                	test   %edx,%edx
80105582:	75 ec                	jne    80105570 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105584:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105587:	89 7c 98 3c          	mov    %edi,0x3c(%eax,%ebx,4)
  iunlock(ip);
8010558b:	56                   	push   %esi
8010558c:	e8 cf c1 ff ff       	call   80101760 <iunlock>
  end_op();
80105591:	e8 7a d6 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105596:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010559c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010559f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055a2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801055a5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055ac:	89 d0                	mov    %edx,%eax
801055ae:	f7 d0                	not    %eax
801055b0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055b6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c0:	89 d8                	mov    %ebx,%eax
801055c2:	5b                   	pop    %ebx
801055c3:	5e                   	pop    %esi
801055c4:	5f                   	pop    %edi
801055c5:	5d                   	pop    %ebp
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055d6:	31 c9                	xor    %ecx,%ecx
801055d8:	6a 00                	push   $0x0
801055da:	ba 02 00 00 00       	mov    $0x2,%edx
801055df:	e8 ec f7 ff ff       	call   80104dd0 <create>
    if(ip == 0){
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801055e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055eb:	0f 85 65 ff ff ff    	jne    80105556 <sys_open+0x76>
      end_op();
801055f1:	e8 1a d6 ff ff       	call   80102c10 <end_op>
      return -1;
801055f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055fb:	eb c0                	jmp    801055bd <sys_open+0xdd>
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105600:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105603:	85 c9                	test   %ecx,%ecx
80105605:	0f 84 4b ff ff ff    	je     80105556 <sys_open+0x76>
    iunlockput(ip);
8010560b:	83 ec 0c             	sub    $0xc,%esp
8010560e:	56                   	push   %esi
8010560f:	e8 fc c2 ff ff       	call   80101910 <iunlockput>
    end_op();
80105614:	e8 f7 d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105621:	eb 9a                	jmp    801055bd <sys_open+0xdd>
80105623:	90                   	nop
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	57                   	push   %edi
8010562c:	e8 0f b8 ff ff       	call   80100e40 <fileclose>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	eb d5                	jmp    8010560b <sys_open+0x12b>
80105636:	8d 76 00             	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_mkdir>:

int
sys_mkdir(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105646:	e8 55 d5 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010564b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564e:	83 ec 08             	sub    $0x8,%esp
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 d7 f6 ff ff       	call   80104d30 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 30                	js     80105690 <sys_mkdir+0x50>
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105666:	31 c9                	xor    %ecx,%ecx
80105668:	6a 00                	push   $0x0
8010566a:	ba 01 00 00 00       	mov    $0x1,%edx
8010566f:	e8 5c f7 ff ff       	call   80104dd0 <create>
80105674:	83 c4 10             	add    $0x10,%esp
80105677:	85 c0                	test   %eax,%eax
80105679:	74 15                	je     80105690 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010567b:	83 ec 0c             	sub    $0xc,%esp
8010567e:	50                   	push   %eax
8010567f:	e8 8c c2 ff ff       	call   80101910 <iunlockput>
  end_op();
80105684:	e8 87 d5 ff ff       	call   80102c10 <end_op>
  return 0;
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	31 c0                	xor    %eax,%eax
}
8010568e:	c9                   	leave  
8010568f:	c3                   	ret    
    end_op();
80105690:	e8 7b d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_mknod>:

int
sys_mknod(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056a6:	e8 f5 d4 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056ae:	83 ec 08             	sub    $0x8,%esp
801056b1:	50                   	push   %eax
801056b2:	6a 00                	push   $0x0
801056b4:	e8 77 f6 ff ff       	call   80104d30 <argstr>
801056b9:	83 c4 10             	add    $0x10,%esp
801056bc:	85 c0                	test   %eax,%eax
801056be:	78 60                	js     80105720 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c3:	83 ec 08             	sub    $0x8,%esp
801056c6:	50                   	push   %eax
801056c7:	6a 01                	push   $0x1
801056c9:	e8 b2 f5 ff ff       	call   80104c80 <argint>
  if((argstr(0, &path)) < 0 ||
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	85 c0                	test   %eax,%eax
801056d3:	78 4b                	js     80105720 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d8:	83 ec 08             	sub    $0x8,%esp
801056db:	50                   	push   %eax
801056dc:	6a 02                	push   $0x2
801056de:	e8 9d f5 ff ff       	call   80104c80 <argint>
     argint(1, &major) < 0 ||
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	78 36                	js     80105720 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056ee:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801056f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056f5:	ba 03 00 00 00       	mov    $0x3,%edx
801056fa:	50                   	push   %eax
801056fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056fe:	e8 cd f6 ff ff       	call   80104dd0 <create>
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	74 16                	je     80105720 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010570a:	83 ec 0c             	sub    $0xc,%esp
8010570d:	50                   	push   %eax
8010570e:	e8 fd c1 ff ff       	call   80101910 <iunlockput>
  end_op();
80105713:	e8 f8 d4 ff ff       	call   80102c10 <end_op>
  return 0;
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	31 c0                	xor    %eax,%eax
}
8010571d:	c9                   	leave  
8010571e:	c3                   	ret    
8010571f:	90                   	nop
    end_op();
80105720:	e8 eb d4 ff ff       	call   80102c10 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_chdir>:

int
sys_chdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	56                   	push   %esi
80105734:	53                   	push   %ebx
80105735:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105738:	e8 c3 e0 ff ff       	call   80103800 <myproc>
8010573d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010573f:	e8 5c d4 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105744:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105747:	83 ec 08             	sub    $0x8,%esp
8010574a:	50                   	push   %eax
8010574b:	6a 00                	push   $0x0
8010574d:	e8 de f5 ff ff       	call   80104d30 <argstr>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 77                	js     801057d0 <sys_chdir+0xa0>
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	ff 75 f4             	pushl  -0xc(%ebp)
8010575f:	e8 7c c7 ff ff       	call   80101ee0 <namei>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	85 c0                	test   %eax,%eax
80105769:	89 c3                	mov    %eax,%ebx
8010576b:	74 63                	je     801057d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	50                   	push   %eax
80105771:	e8 0a bf ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010577e:	75 30                	jne    801057b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	53                   	push   %ebx
80105784:	e8 d7 bf ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105789:	58                   	pop    %eax
8010578a:	ff 76 7c             	pushl  0x7c(%esi)
8010578d:	e8 1e c0 ff ff       	call   801017b0 <iput>
  end_op();
80105792:	e8 79 d4 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105797:	89 5e 7c             	mov    %ebx,0x7c(%esi)
  return 0;
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	31 c0                	xor    %eax,%eax
}
8010579f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a2:	5b                   	pop    %ebx
801057a3:	5e                   	pop    %esi
801057a4:	5d                   	pop    %ebp
801057a5:	c3                   	ret    
801057a6:	8d 76 00             	lea    0x0(%esi),%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	53                   	push   %ebx
801057b4:	e8 57 c1 ff ff       	call   80101910 <iunlockput>
    end_op();
801057b9:	e8 52 d4 ff ff       	call   80102c10 <end_op>
    return -1;
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c6:	eb d7                	jmp    8010579f <sys_chdir+0x6f>
801057c8:	90                   	nop
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801057d0:	e8 3b d4 ff ff       	call   80102c10 <end_op>
    return -1;
801057d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057da:	eb c3                	jmp    8010579f <sys_chdir+0x6f>
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057e0 <sys_exec>:

int
sys_exec(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	57                   	push   %edi
801057e4:	56                   	push   %esi
801057e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057f2:	50                   	push   %eax
801057f3:	6a 00                	push   $0x0
801057f5:	e8 36 f5 ff ff       	call   80104d30 <argstr>
801057fa:	83 c4 10             	add    $0x10,%esp
801057fd:	85 c0                	test   %eax,%eax
801057ff:	0f 88 87 00 00 00    	js     8010588c <sys_exec+0xac>
80105805:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	50                   	push   %eax
8010580f:	6a 01                	push   $0x1
80105811:	e8 6a f4 ff ff       	call   80104c80 <argint>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 6f                	js     8010588c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010581d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105823:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105826:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105828:	68 80 00 00 00       	push   $0x80
8010582d:	6a 00                	push   $0x0
8010582f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105835:	50                   	push   %eax
80105836:	e8 45 f1 ff ff       	call   80104980 <memset>
8010583b:	83 c4 10             	add    $0x10,%esp
8010583e:	eb 2c                	jmp    8010586c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105840:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105846:	85 c0                	test   %eax,%eax
80105848:	74 56                	je     801058a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010584a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105856:	52                   	push   %edx
80105857:	50                   	push   %eax
80105858:	e8 b3 f3 ff ff       	call   80104c10 <fetchstr>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 28                	js     8010588c <sys_exec+0xac>
  for(i=0;; i++){
80105864:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105867:	83 fb 20             	cmp    $0x20,%ebx
8010586a:	74 20                	je     8010588c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010586c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105872:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105879:	83 ec 08             	sub    $0x8,%esp
8010587c:	57                   	push   %edi
8010587d:	01 f0                	add    %esi,%eax
8010587f:	50                   	push   %eax
80105880:	e8 4b f3 ff ff       	call   80104bd0 <fetchint>
80105885:	83 c4 10             	add    $0x10,%esp
80105888:	85 c0                	test   %eax,%eax
8010588a:	79 b4                	jns    80105840 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010588c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010588f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105894:	5b                   	pop    %ebx
80105895:	5e                   	pop    %esi
80105896:	5f                   	pop    %edi
80105897:	5d                   	pop    %ebp
80105898:	c3                   	ret    
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801058a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058a6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801058a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058b0:	00 00 00 00 
  return exec(path, argv);
801058b4:	50                   	push   %eax
801058b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058bb:	e8 50 b1 ff ff       	call   80100a10 <exec>
801058c0:	83 c4 10             	add    $0x10,%esp
}
801058c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c6:	5b                   	pop    %ebx
801058c7:	5e                   	pop    %esi
801058c8:	5f                   	pop    %edi
801058c9:	5d                   	pop    %ebp
801058ca:	c3                   	ret    
801058cb:	90                   	nop
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_pipe>:

int
sys_pipe(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058dc:	6a 08                	push   $0x8
801058de:	50                   	push   %eax
801058df:	6a 00                	push   $0x0
801058e1:	e8 ea f3 ff ff       	call   80104cd0 <argptr>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 88 ae 00 00 00    	js     8010599f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058f4:	83 ec 08             	sub    $0x8,%esp
801058f7:	50                   	push   %eax
801058f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058fb:	50                   	push   %eax
801058fc:	e8 3f d9 ff ff       	call   80103240 <pipealloc>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	85 c0                	test   %eax,%eax
80105906:	0f 88 93 00 00 00    	js     8010599f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010590c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010590f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105911:	e8 ea de ff ff       	call   80103800 <myproc>
80105916:	eb 10                	jmp    80105928 <sys_pipe+0x58>
80105918:	90                   	nop
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105920:	83 c3 01             	add    $0x1,%ebx
80105923:	83 fb 10             	cmp    $0x10,%ebx
80105926:	74 60                	je     80105988 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105928:	8b 74 98 3c          	mov    0x3c(%eax,%ebx,4),%esi
8010592c:	85 f6                	test   %esi,%esi
8010592e:	75 f0                	jne    80105920 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105930:	8d 73 0c             	lea    0xc(%ebx),%esi
80105933:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010593a:	e8 c1 de ff ff       	call   80103800 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010593f:	31 d2                	xor    %edx,%edx
80105941:	eb 0d                	jmp    80105950 <sys_pipe+0x80>
80105943:	90                   	nop
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105948:	83 c2 01             	add    $0x1,%edx
8010594b:	83 fa 10             	cmp    $0x10,%edx
8010594e:	74 28                	je     80105978 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105950:	8b 4c 90 3c          	mov    0x3c(%eax,%edx,4),%ecx
80105954:	85 c9                	test   %ecx,%ecx
80105956:	75 f0                	jne    80105948 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105958:	89 7c 90 3c          	mov    %edi,0x3c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010595c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010595f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105961:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105964:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105967:	31 c0                	xor    %eax,%eax
}
80105969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596c:	5b                   	pop    %ebx
8010596d:	5e                   	pop    %esi
8010596e:	5f                   	pop    %edi
8010596f:	5d                   	pop    %ebp
80105970:	c3                   	ret    
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105978:	e8 83 de ff ff       	call   80103800 <myproc>
8010597d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105984:	00 
80105985:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 e0             	pushl  -0x20(%ebp)
8010598e:	e8 ad b4 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105993:	58                   	pop    %eax
80105994:	ff 75 e4             	pushl  -0x1c(%ebp)
80105997:	e8 a4 b4 ff ff       	call   80100e40 <fileclose>
    return -1;
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a4:	eb c3                	jmp    80105969 <sys_pipe+0x99>
801059a6:	66 90                	xchg   %ax,%ax
801059a8:	66 90                	xchg   %ax,%ax
801059aa:	66 90                	xchg   %ax,%ax
801059ac:	66 90                	xchg   %ax,%ax
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059b3:	5d                   	pop    %ebp
  return fork();
801059b4:	e9 27 e0 ff ff       	jmp    801039e0 <fork>
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_exit>:

int
sys_exit(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059c6:	e8 f5 e2 ff ff       	call   80103cc0 <exit>
  return 0;  // not reached
}
801059cb:	31 c0                	xor    %eax,%eax
801059cd:	c9                   	leave  
801059ce:	c3                   	ret    
801059cf:	90                   	nop

801059d0 <sys_wait>:

int
sys_wait(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059d3:	5d                   	pop    %ebp
  return wait();
801059d4:	e9 67 e6 ff ff       	jmp    80104040 <wait>
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_kill>:

int
sys_kill(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e9:	50                   	push   %eax
801059ea:	6a 00                	push   $0x0
801059ec:	e8 8f f2 ff ff       	call   80104c80 <argint>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	78 18                	js     80105a10 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 f4             	pushl  -0xc(%ebp)
801059fe:	e8 9d e9 ff ff       	call   801043a0 <kill>
80105a03:	83 c4 10             	add    $0x10,%esp
}
80105a06:	c9                   	leave  
80105a07:	c3                   	ret    
80105a08:	90                   	nop
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a20 <sys_set_prio>:

int 
sys_set_prio(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 20             	sub    $0x20,%esp
  int prio;
  
  if (argint(0, &prio) < 0)
80105a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 00                	push   $0x0
80105a2c:	e8 4f f2 ff ff       	call   80104c80 <argint>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	78 18                	js     80105a50 <sys_set_prio+0x30>
    return -1;
  return set_prio(prio);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a3e:	e8 8d e7 ff ff       	call   801041d0 <set_prio>
80105a43:	83 c4 10             	add    $0x10,%esp
}
80105a46:	c9                   	leave  
80105a47:	c3                   	ret    
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a60 <sys_wait2>:

int sys_wait2(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 1c             	sub    $0x1c,%esp
  char* retime;
  char* rutime;
  char* stime;
  if (argptr(0, &retime, sizeof(int)) < 0) {
80105a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a69:	6a 04                	push   $0x4
80105a6b:	50                   	push   %eax
80105a6c:	6a 00                	push   $0x0
80105a6e:	e8 5d f2 ff ff       	call   80104cd0 <argptr>
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	85 c0                	test   %eax,%eax
80105a78:	78 46                	js     80105ac0 <sys_wait2+0x60>
    return -1;
  }
  if (argptr(1, &rutime, sizeof(int)) < 0) {
80105a7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a7d:	83 ec 04             	sub    $0x4,%esp
80105a80:	6a 04                	push   $0x4
80105a82:	50                   	push   %eax
80105a83:	6a 01                	push   $0x1
80105a85:	e8 46 f2 ff ff       	call   80104cd0 <argptr>
80105a8a:	83 c4 10             	add    $0x10,%esp
80105a8d:	85 c0                	test   %eax,%eax
80105a8f:	78 2f                	js     80105ac0 <sys_wait2+0x60>
    return -1;
  }
  if (argptr(2, &stime, sizeof(int)) < 0) {
80105a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a94:	83 ec 04             	sub    $0x4,%esp
80105a97:	6a 04                	push   $0x4
80105a99:	50                   	push   %eax
80105a9a:	6a 02                	push   $0x2
80105a9c:	e8 2f f2 ff ff       	call   80104cd0 <argptr>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 18                	js     80105ac0 <sys_wait2+0x60>
    return -1;
  }
  return wait2((int*)retime, (int*)rutime, (int*)stime);
80105aa8:	83 ec 04             	sub    $0x4,%esp
80105aab:	ff 75 f4             	pushl  -0xc(%ebp)
80105aae:	ff 75 f0             	pushl  -0x10(%ebp)
80105ab1:	ff 75 ec             	pushl  -0x14(%ebp)
80105ab4:	e8 87 e7 ff ff       	call   80104240 <wait2>
80105ab9:	83 c4 10             	add    $0x10,%esp
}
80105abc:	c9                   	leave  
80105abd:	c3                   	ret    
80105abe:	66 90                	xchg   %ax,%ax
    return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ad0 <sys_yield>:

int sys_yield(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 08             	sub    $0x8,%esp
  yield();
80105ad6:	e8 15 e3 ff ff       	call   80103df0 <yield>
  return 0;
}
80105adb:	31 c0                	xor    %eax,%eax
80105add:	c9                   	leave  
80105ade:	c3                   	ret    
80105adf:	90                   	nop

80105ae0 <sys_getpid>:

int
sys_getpid(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ae6:	e8 15 dd ff ff       	call   80103800 <myproc>
80105aeb:	8b 40 24             	mov    0x24(%eax),%eax
}
80105aee:	c9                   	leave  
80105aef:	c3                   	ret    

80105af0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105af7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 7e f1 ff ff       	call   80104c80 <argint>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 27                	js     80105b30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b09:	e8 f2 dc ff ff       	call   80103800 <myproc>
  if(growproc(n) < 0)
80105b0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b13:	ff 75 f4             	pushl  -0xc(%ebp)
80105b16:	e8 45 de ff ff       	call   80103960 <growproc>
80105b1b:	83 c4 10             	add    $0x10,%esp
80105b1e:	85 c0                	test   %eax,%eax
80105b20:	78 0e                	js     80105b30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b22:	89 d8                	mov    %ebx,%eax
80105b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b27:	c9                   	leave  
80105b28:	c3                   	ret    
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b35:	eb eb                	jmp    80105b22 <sys_sbrk+0x32>
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b40 <sys_sleep>:

int
sys_sleep(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b4a:	50                   	push   %eax
80105b4b:	6a 00                	push   $0x0
80105b4d:	e8 2e f1 ff ff       	call   80104c80 <argint>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	0f 88 8a 00 00 00    	js     80105be7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	68 80 53 11 80       	push   $0x80115380
80105b65:	e8 06 ed ff ff       	call   80104870 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b6d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105b70:	8b 1d c0 5b 11 80    	mov    0x80115bc0,%ebx
  while(ticks - ticks0 < n){
80105b76:	85 d2                	test   %edx,%edx
80105b78:	75 27                	jne    80105ba1 <sys_sleep+0x61>
80105b7a:	eb 54                	jmp    80105bd0 <sys_sleep+0x90>
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b80:	83 ec 08             	sub    $0x8,%esp
80105b83:	68 80 53 11 80       	push   $0x80115380
80105b88:	68 c0 5b 11 80       	push   $0x80115bc0
80105b8d:	e8 ae e2 ff ff       	call   80103e40 <sleep>
  while(ticks - ticks0 < n){
80105b92:	a1 c0 5b 11 80       	mov    0x80115bc0,%eax
80105b97:	83 c4 10             	add    $0x10,%esp
80105b9a:	29 d8                	sub    %ebx,%eax
80105b9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b9f:	73 2f                	jae    80105bd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ba1:	e8 5a dc ff ff       	call   80103800 <myproc>
80105ba6:	8b 40 38             	mov    0x38(%eax),%eax
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	74 d3                	je     80105b80 <sys_sleep+0x40>
      release(&tickslock);
80105bad:	83 ec 0c             	sub    $0xc,%esp
80105bb0:	68 80 53 11 80       	push   $0x80115380
80105bb5:	e8 76 ed ff ff       	call   80104930 <release>
      return -1;
80105bba:	83 c4 10             	add    $0x10,%esp
80105bbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc5:	c9                   	leave  
80105bc6:	c3                   	ret    
80105bc7:	89 f6                	mov    %esi,%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	68 80 53 11 80       	push   $0x80115380
80105bd8:	e8 53 ed ff ff       	call   80104930 <release>
  return 0;
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	31 c0                	xor    %eax,%eax
}
80105be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
    return -1;
80105be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bec:	eb f4                	jmp    80105be2 <sys_sleep+0xa2>
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	53                   	push   %ebx
80105bf4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bf7:	68 80 53 11 80       	push   $0x80115380
80105bfc:	e8 6f ec ff ff       	call   80104870 <acquire>
  xticks = ticks;
80105c01:	8b 1d c0 5b 11 80    	mov    0x80115bc0,%ebx
  release(&tickslock);
80105c07:	c7 04 24 80 53 11 80 	movl   $0x80115380,(%esp)
80105c0e:	e8 1d ed ff ff       	call   80104930 <release>
  return xticks;
}
80105c13:	89 d8                	mov    %ebx,%eax
80105c15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c18:	c9                   	leave  
80105c19:	c3                   	ret    

80105c1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c1a:	1e                   	push   %ds
  pushl %es
80105c1b:	06                   	push   %es
  pushl %fs
80105c1c:	0f a0                	push   %fs
  pushl %gs
80105c1e:	0f a8                	push   %gs
  pushal
80105c20:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c29:	54                   	push   %esp
  call trap
80105c2a:	e8 c1 00 00 00       	call   80105cf0 <trap>
  addl $4, %esp
80105c2f:	83 c4 04             	add    $0x4,%esp

80105c32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c32:	61                   	popa   
  popl %gs
80105c33:	0f a9                	pop    %gs
  popl %fs
80105c35:	0f a1                	pop    %fs
  popl %es
80105c37:	07                   	pop    %es
  popl %ds
80105c38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c39:	83 c4 08             	add    $0x8,%esp
  iret
80105c3c:	cf                   	iret   
80105c3d:	66 90                	xchg   %ax,%ax
80105c3f:	90                   	nop

80105c40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c41:	31 c0                	xor    %eax,%eax
{
80105c43:	89 e5                	mov    %esp,%ebp
80105c45:	83 ec 08             	sub    $0x8,%esp
80105c48:	90                   	nop
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c50:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c57:	c7 04 c5 c2 53 11 80 	movl   $0x8e000008,-0x7feeac3e(,%eax,8)
80105c5e:	08 00 00 8e 
80105c62:	66 89 14 c5 c0 53 11 	mov    %dx,-0x7feeac40(,%eax,8)
80105c69:	80 
80105c6a:	c1 ea 10             	shr    $0x10,%edx
80105c6d:	66 89 14 c5 c6 53 11 	mov    %dx,-0x7feeac3a(,%eax,8)
80105c74:	80 
  for(i = 0; i < 256; i++)
80105c75:	83 c0 01             	add    $0x1,%eax
80105c78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c7d:	75 d1                	jne    80105c50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c7f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105c84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c87:	c7 05 c2 55 11 80 08 	movl   $0xef000008,0x801155c2
80105c8e:	00 00 ef 
  initlock(&tickslock, "time");
80105c91:	68 05 7d 10 80       	push   $0x80107d05
80105c96:	68 80 53 11 80       	push   $0x80115380
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c9b:	66 a3 c0 55 11 80    	mov    %ax,0x801155c0
80105ca1:	c1 e8 10             	shr    $0x10,%eax
80105ca4:	66 a3 c6 55 11 80    	mov    %ax,0x801155c6
  initlock(&tickslock, "time");
80105caa:	e8 81 ea ff ff       	call   80104730 <initlock>
}
80105caf:	83 c4 10             	add    $0x10,%esp
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    
80105cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105cc0 <idtinit>:

void
idtinit(void)
{
80105cc0:	55                   	push   %ebp
  pd[0] = size-1;
80105cc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cc6:	89 e5                	mov    %esp,%ebp
80105cc8:	83 ec 10             	sub    $0x10,%esp
80105ccb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ccf:	b8 c0 53 11 80       	mov    $0x801153c0,%eax
80105cd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cd8:	c1 e8 10             	shr    $0x10,%eax
80105cdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ce2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    
80105ce7:	89 f6                	mov    %esi,%esi
80105ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cf0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
80105cf6:	83 ec 1c             	sub    $0x1c,%esp
80105cf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105cfc:	8b 47 30             	mov    0x30(%edi),%eax
80105cff:	83 f8 40             	cmp    $0x40,%eax
80105d02:	0f 84 f0 00 00 00    	je     80105df8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d08:	83 e8 20             	sub    $0x20,%eax
80105d0b:	83 f8 1f             	cmp    $0x1f,%eax
80105d0e:	77 10                	ja     80105d20 <trap+0x30>
80105d10:	ff 24 85 ac 7d 10 80 	jmp    *-0x7fef8254(,%eax,4)
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d20:	e8 db da ff ff       	call   80103800 <myproc>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d2a:	0f 84 62 02 00 00    	je     80105f92 <trap+0x2a2>
80105d30:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d34:	0f 84 58 02 00 00    	je     80105f92 <trap+0x2a2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d3a:	0f 20 d1             	mov    %cr2,%ecx
80105d3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d40:	e8 9b da ff ff       	call   801037e0 <cpuid>
80105d45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d48:	8b 47 34             	mov    0x34(%edi),%eax
80105d4b:	8b 77 30             	mov    0x30(%edi),%esi
80105d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d51:	e8 aa da ff ff       	call   80103800 <myproc>
80105d56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d59:	e8 a2 da ff ff       	call   80103800 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d64:	51                   	push   %ecx
80105d65:	53                   	push   %ebx
80105d66:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d67:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d6d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d6e:	81 c2 88 00 00 00    	add    $0x88,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d74:	52                   	push   %edx
80105d75:	ff 70 24             	pushl  0x24(%eax)
80105d78:	68 68 7d 10 80       	push   $0x80107d68
80105d7d:	e8 de a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d82:	83 c4 20             	add    $0x20,%esp
80105d85:	e8 76 da ff ff       	call   80103800 <myproc>
80105d8a:	c7 40 38 01 00 00 00 	movl   $0x1,0x38(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d91:	e8 6a da ff ff       	call   80103800 <myproc>
80105d96:	85 c0                	test   %eax,%eax
80105d98:	74 1d                	je     80105db7 <trap+0xc7>
80105d9a:	e8 61 da ff ff       	call   80103800 <myproc>
80105d9f:	8b 50 38             	mov    0x38(%eax),%edx
80105da2:	85 d2                	test   %edx,%edx
80105da4:	74 11                	je     80105db7 <trap+0xc7>
80105da6:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105daa:	83 e0 03             	and    $0x3,%eax
80105dad:	66 83 f8 03          	cmp    $0x3,%ax
80105db1:	0f 84 69 01 00 00    	je     80105f20 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105db7:	e8 44 da ff ff       	call   80103800 <myproc>
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	74 0b                	je     80105dcb <trap+0xdb>
80105dc0:	e8 3b da ff ff       	call   80103800 <myproc>
80105dc5:	83 78 1c 04          	cmpl   $0x4,0x1c(%eax)
80105dc9:	74 65                	je     80105e30 <trap+0x140>
    // Total rutime is the acc of the last time it started until now that it is being preempted
    yield();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dcb:	e8 30 da ff ff       	call   80103800 <myproc>
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	74 19                	je     80105ded <trap+0xfd>
80105dd4:	e8 27 da ff ff       	call   80103800 <myproc>
80105dd9:	8b 40 38             	mov    0x38(%eax),%eax
80105ddc:	85 c0                	test   %eax,%eax
80105dde:	74 0d                	je     80105ded <trap+0xfd>
80105de0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105de4:	83 e0 03             	and    $0x3,%eax
80105de7:	66 83 f8 03          	cmp    $0x3,%ax
80105deb:	74 34                	je     80105e21 <trap+0x131>
    exit();
}
80105ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df0:	5b                   	pop    %ebx
80105df1:	5e                   	pop    %esi
80105df2:	5f                   	pop    %edi
80105df3:	5d                   	pop    %ebp
80105df4:	c3                   	ret    
80105df5:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105df8:	e8 03 da ff ff       	call   80103800 <myproc>
80105dfd:	8b 58 38             	mov    0x38(%eax),%ebx
80105e00:	85 db                	test   %ebx,%ebx
80105e02:	0f 85 08 01 00 00    	jne    80105f10 <trap+0x220>
    myproc()->tf = tf;
80105e08:	e8 f3 d9 ff ff       	call   80103800 <myproc>
80105e0d:	89 78 2c             	mov    %edi,0x2c(%eax)
    syscall();
80105e10:	e8 5b ef ff ff       	call   80104d70 <syscall>
    if(myproc()->killed)
80105e15:	e8 e6 d9 ff ff       	call   80103800 <myproc>
80105e1a:	8b 48 38             	mov    0x38(%eax),%ecx
80105e1d:	85 c9                	test   %ecx,%ecx
80105e1f:	74 cc                	je     80105ded <trap+0xfd>
}
80105e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e24:	5b                   	pop    %ebx
80105e25:	5e                   	pop    %esi
80105e26:	5f                   	pop    %edi
80105e27:	5d                   	pop    %ebp
      exit();
80105e28:	e9 93 de ff ff       	jmp    80103cc0 <exit>
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e30:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e34:	75 95                	jne    80105dcb <trap+0xdb>
     && ticks % INTERV == 0
80105e36:	8b 0d c0 5b 11 80    	mov    0x80115bc0,%ecx
80105e3c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105e41:	89 c8                	mov    %ecx,%eax
80105e43:	f7 e2                	mul    %edx
80105e45:	c1 ea 02             	shr    $0x2,%edx
80105e48:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105e4b:	39 c1                	cmp    %eax,%ecx
80105e4d:	0f 85 78 ff ff ff    	jne    80105dcb <trap+0xdb>
    yield();
80105e53:	e8 98 df ff ff       	call   80103df0 <yield>
80105e58:	e9 6e ff ff ff       	jmp    80105dcb <trap+0xdb>
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e60:	e8 7b d9 ff ff       	call   801037e0 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 84 c3 00 00 00    	je     80105f30 <trap+0x240>
    lapiceoi();
80105e6d:	e8 de c8 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e72:	e8 89 d9 ff ff       	call   80103800 <myproc>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	0f 85 1b ff ff ff    	jne    80105d9a <trap+0xaa>
80105e7f:	e9 33 ff ff ff       	jmp    80105db7 <trap+0xc7>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e88:	e8 83 c7 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
80105e8d:	e8 be c8 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e92:	e8 69 d9 ff ff       	call   80103800 <myproc>
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 85 fb fe ff ff    	jne    80105d9a <trap+0xaa>
80105e9f:	e9 13 ff ff ff       	jmp    80105db7 <trap+0xc7>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ea8:	e8 83 02 00 00       	call   80106130 <uartintr>
    lapiceoi();
80105ead:	e8 9e c8 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eb2:	e8 49 d9 ff ff       	call   80103800 <myproc>
80105eb7:	85 c0                	test   %eax,%eax
80105eb9:	0f 85 db fe ff ff    	jne    80105d9a <trap+0xaa>
80105ebf:	e9 f3 fe ff ff       	jmp    80105db7 <trap+0xc7>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ec8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ecc:	8b 77 38             	mov    0x38(%edi),%esi
80105ecf:	e8 0c d9 ff ff       	call   801037e0 <cpuid>
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	50                   	push   %eax
80105ed7:	68 10 7d 10 80       	push   $0x80107d10
80105edc:	e8 7f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105ee1:	e8 6a c8 ff ff       	call   80102750 <lapiceoi>
    break;
80105ee6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee9:	e8 12 d9 ff ff       	call   80103800 <myproc>
80105eee:	85 c0                	test   %eax,%eax
80105ef0:	0f 85 a4 fe ff ff    	jne    80105d9a <trap+0xaa>
80105ef6:	e9 bc fe ff ff       	jmp    80105db7 <trap+0xc7>
80105efb:	90                   	nop
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f00:	e8 7b c1 ff ff       	call   80102080 <ideintr>
80105f05:	e9 63 ff ff ff       	jmp    80105e6d <trap+0x17d>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f10:	e8 ab dd ff ff       	call   80103cc0 <exit>
80105f15:	e9 ee fe ff ff       	jmp    80105e08 <trap+0x118>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f20:	e8 9b dd ff ff       	call   80103cc0 <exit>
80105f25:	e9 8d fe ff ff       	jmp    80105db7 <trap+0xc7>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	68 80 53 11 80       	push   $0x80115380
80105f38:	e8 33 e9 ff ff       	call   80104870 <acquire>
      ticks++;
80105f3d:	83 05 c0 5b 11 80 01 	addl   $0x1,0x80115bc0
      update_proc_status();
80105f44:	e8 d7 e5 ff ff       	call   80104520 <update_proc_status>
      if (ticks % INTERV == 0)
80105f49:	8b 0d c0 5b 11 80    	mov    0x80115bc0,%ecx
80105f4f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	89 c8                	mov    %ecx,%eax
80105f59:	f7 e2                	mul    %edx
80105f5b:	c1 ea 02             	shr    $0x2,%edx
80105f5e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105f61:	39 c1                	cmp    %eax,%ecx
80105f63:	74 1b                	je     80105f80 <trap+0x290>
      release(&tickslock);
80105f65:	83 ec 0c             	sub    $0xc,%esp
80105f68:	68 80 53 11 80       	push   $0x80115380
80105f6d:	e8 be e9 ff ff       	call   80104930 <release>
80105f72:	83 c4 10             	add    $0x10,%esp
80105f75:	e9 f3 fe ff ff       	jmp    80105e6d <trap+0x17d>
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        wakeup(&ticks);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 c0 5b 11 80       	push   $0x80115bc0
80105f88:	e8 73 df ff ff       	call   80103f00 <wakeup>
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	eb d3                	jmp    80105f65 <trap+0x275>
80105f92:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f95:	e8 46 d8 ff ff       	call   801037e0 <cpuid>
80105f9a:	83 ec 0c             	sub    $0xc,%esp
80105f9d:	56                   	push   %esi
80105f9e:	53                   	push   %ebx
80105f9f:	50                   	push   %eax
80105fa0:	ff 77 30             	pushl  0x30(%edi)
80105fa3:	68 34 7d 10 80       	push   $0x80107d34
80105fa8:	e8 b3 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105fad:	83 c4 14             	add    $0x14,%esp
80105fb0:	68 0a 7d 10 80       	push   $0x80107d0a
80105fb5:	e8 d6 a3 ff ff       	call   80100390 <panic>
80105fba:	66 90                	xchg   %ax,%ax
80105fbc:	66 90                	xchg   %ax,%ax
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fc0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105fc5:	55                   	push   %ebp
80105fc6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fc8:	85 c0                	test   %eax,%eax
80105fca:	74 1c                	je     80105fe8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fcc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fd1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fd2:	a8 01                	test   $0x1,%al
80105fd4:	74 12                	je     80105fe8 <uartgetc+0x28>
80105fd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fdc:	0f b6 c0             	movzbl %al,%eax
}
80105fdf:	5d                   	pop    %ebp
80105fe0:	c3                   	ret    
80105fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fed:	5d                   	pop    %ebp
80105fee:	c3                   	ret    
80105fef:	90                   	nop

80105ff0 <uartputc.part.0>:
uartputc(int c)
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	53                   	push   %ebx
80105ff6:	89 c7                	mov    %eax,%edi
80105ff8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ffd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106002:	83 ec 0c             	sub    $0xc,%esp
80106005:	eb 1b                	jmp    80106022 <uartputc.part.0+0x32>
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	6a 0a                	push   $0xa
80106015:	e8 56 c7 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	83 eb 01             	sub    $0x1,%ebx
80106020:	74 07                	je     80106029 <uartputc.part.0+0x39>
80106022:	89 f2                	mov    %esi,%edx
80106024:	ec                   	in     (%dx),%al
80106025:	a8 20                	test   $0x20,%al
80106027:	74 e7                	je     80106010 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106029:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010602e:	89 f8                	mov    %edi,%eax
80106030:	ee                   	out    %al,(%dx)
}
80106031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106034:	5b                   	pop    %ebx
80106035:	5e                   	pop    %esi
80106036:	5f                   	pop    %edi
80106037:	5d                   	pop    %ebp
80106038:	c3                   	ret    
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106040 <uartinit>:
{
80106040:	55                   	push   %ebp
80106041:	31 c9                	xor    %ecx,%ecx
80106043:	89 c8                	mov    %ecx,%eax
80106045:	89 e5                	mov    %esp,%ebp
80106047:	57                   	push   %edi
80106048:	56                   	push   %esi
80106049:	53                   	push   %ebx
8010604a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010604f:	89 da                	mov    %ebx,%edx
80106051:	83 ec 0c             	sub    $0xc,%esp
80106054:	ee                   	out    %al,(%dx)
80106055:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010605a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010605f:	89 fa                	mov    %edi,%edx
80106061:	ee                   	out    %al,(%dx)
80106062:	b8 0c 00 00 00       	mov    $0xc,%eax
80106067:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010606c:	ee                   	out    %al,(%dx)
8010606d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106072:	89 c8                	mov    %ecx,%eax
80106074:	89 f2                	mov    %esi,%edx
80106076:	ee                   	out    %al,(%dx)
80106077:	b8 03 00 00 00       	mov    $0x3,%eax
8010607c:	89 fa                	mov    %edi,%edx
8010607e:	ee                   	out    %al,(%dx)
8010607f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106084:	89 c8                	mov    %ecx,%eax
80106086:	ee                   	out    %al,(%dx)
80106087:	b8 01 00 00 00       	mov    $0x1,%eax
8010608c:	89 f2                	mov    %esi,%edx
8010608e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010608f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106094:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106095:	3c ff                	cmp    $0xff,%al
80106097:	74 5a                	je     801060f3 <uartinit+0xb3>
  uart = 1;
80106099:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801060a0:	00 00 00 
801060a3:	89 da                	mov    %ebx,%edx
801060a5:	ec                   	in     (%dx),%al
801060a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060af:	bb 2c 7e 10 80       	mov    $0x80107e2c,%ebx
  ioapicenable(IRQ_COM1, 0);
801060b4:	6a 00                	push   $0x0
801060b6:	6a 04                	push   $0x4
801060b8:	e8 13 c2 ff ff       	call   801022d0 <ioapicenable>
801060bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060c0:	b8 78 00 00 00       	mov    $0x78,%eax
801060c5:	eb 13                	jmp    801060da <uartinit+0x9a>
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060d0:	83 c3 01             	add    $0x1,%ebx
801060d3:	0f be 03             	movsbl (%ebx),%eax
801060d6:	84 c0                	test   %al,%al
801060d8:	74 19                	je     801060f3 <uartinit+0xb3>
  if(!uart)
801060da:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
801060e0:	85 d2                	test   %edx,%edx
801060e2:	74 ec                	je     801060d0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060e4:	83 c3 01             	add    $0x1,%ebx
801060e7:	e8 04 ff ff ff       	call   80105ff0 <uartputc.part.0>
801060ec:	0f be 03             	movsbl (%ebx),%eax
801060ef:	84 c0                	test   %al,%al
801060f1:	75 e7                	jne    801060da <uartinit+0x9a>
}
801060f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060f6:	5b                   	pop    %ebx
801060f7:	5e                   	pop    %esi
801060f8:	5f                   	pop    %edi
801060f9:	5d                   	pop    %ebp
801060fa:	c3                   	ret    
801060fb:	90                   	nop
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106100 <uartputc>:
  if(!uart)
80106100:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80106106:	55                   	push   %ebp
80106107:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106109:	85 d2                	test   %edx,%edx
{
8010610b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010610e:	74 10                	je     80106120 <uartputc+0x20>
}
80106110:	5d                   	pop    %ebp
80106111:	e9 da fe ff ff       	jmp    80105ff0 <uartputc.part.0>
80106116:	8d 76 00             	lea    0x0(%esi),%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106120:	5d                   	pop    %ebp
80106121:	c3                   	ret    
80106122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106130 <uartintr>:

void
uartintr(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106136:	68 c0 5f 10 80       	push   $0x80105fc0
8010613b:	e8 d0 a6 ff ff       	call   80100810 <consoleintr>
}
80106140:	83 c4 10             	add    $0x10,%esp
80106143:	c9                   	leave  
80106144:	c3                   	ret    

80106145 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $0
80106147:	6a 00                	push   $0x0
  jmp alltraps
80106149:	e9 cc fa ff ff       	jmp    80105c1a <alltraps>

8010614e <vector1>:
.globl vector1
vector1:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $1
80106150:	6a 01                	push   $0x1
  jmp alltraps
80106152:	e9 c3 fa ff ff       	jmp    80105c1a <alltraps>

80106157 <vector2>:
.globl vector2
vector2:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $2
80106159:	6a 02                	push   $0x2
  jmp alltraps
8010615b:	e9 ba fa ff ff       	jmp    80105c1a <alltraps>

80106160 <vector3>:
.globl vector3
vector3:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $3
80106162:	6a 03                	push   $0x3
  jmp alltraps
80106164:	e9 b1 fa ff ff       	jmp    80105c1a <alltraps>

80106169 <vector4>:
.globl vector4
vector4:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $4
8010616b:	6a 04                	push   $0x4
  jmp alltraps
8010616d:	e9 a8 fa ff ff       	jmp    80105c1a <alltraps>

80106172 <vector5>:
.globl vector5
vector5:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $5
80106174:	6a 05                	push   $0x5
  jmp alltraps
80106176:	e9 9f fa ff ff       	jmp    80105c1a <alltraps>

8010617b <vector6>:
.globl vector6
vector6:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $6
8010617d:	6a 06                	push   $0x6
  jmp alltraps
8010617f:	e9 96 fa ff ff       	jmp    80105c1a <alltraps>

80106184 <vector7>:
.globl vector7
vector7:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $7
80106186:	6a 07                	push   $0x7
  jmp alltraps
80106188:	e9 8d fa ff ff       	jmp    80105c1a <alltraps>

8010618d <vector8>:
.globl vector8
vector8:
  pushl $8
8010618d:	6a 08                	push   $0x8
  jmp alltraps
8010618f:	e9 86 fa ff ff       	jmp    80105c1a <alltraps>

80106194 <vector9>:
.globl vector9
vector9:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $9
80106196:	6a 09                	push   $0x9
  jmp alltraps
80106198:	e9 7d fa ff ff       	jmp    80105c1a <alltraps>

8010619d <vector10>:
.globl vector10
vector10:
  pushl $10
8010619d:	6a 0a                	push   $0xa
  jmp alltraps
8010619f:	e9 76 fa ff ff       	jmp    80105c1a <alltraps>

801061a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061a4:	6a 0b                	push   $0xb
  jmp alltraps
801061a6:	e9 6f fa ff ff       	jmp    80105c1a <alltraps>

801061ab <vector12>:
.globl vector12
vector12:
  pushl $12
801061ab:	6a 0c                	push   $0xc
  jmp alltraps
801061ad:	e9 68 fa ff ff       	jmp    80105c1a <alltraps>

801061b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061b2:	6a 0d                	push   $0xd
  jmp alltraps
801061b4:	e9 61 fa ff ff       	jmp    80105c1a <alltraps>

801061b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061b9:	6a 0e                	push   $0xe
  jmp alltraps
801061bb:	e9 5a fa ff ff       	jmp    80105c1a <alltraps>

801061c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $15
801061c2:	6a 0f                	push   $0xf
  jmp alltraps
801061c4:	e9 51 fa ff ff       	jmp    80105c1a <alltraps>

801061c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $16
801061cb:	6a 10                	push   $0x10
  jmp alltraps
801061cd:	e9 48 fa ff ff       	jmp    80105c1a <alltraps>

801061d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061d2:	6a 11                	push   $0x11
  jmp alltraps
801061d4:	e9 41 fa ff ff       	jmp    80105c1a <alltraps>

801061d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $18
801061db:	6a 12                	push   $0x12
  jmp alltraps
801061dd:	e9 38 fa ff ff       	jmp    80105c1a <alltraps>

801061e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $19
801061e4:	6a 13                	push   $0x13
  jmp alltraps
801061e6:	e9 2f fa ff ff       	jmp    80105c1a <alltraps>

801061eb <vector20>:
.globl vector20
vector20:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $20
801061ed:	6a 14                	push   $0x14
  jmp alltraps
801061ef:	e9 26 fa ff ff       	jmp    80105c1a <alltraps>

801061f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $21
801061f6:	6a 15                	push   $0x15
  jmp alltraps
801061f8:	e9 1d fa ff ff       	jmp    80105c1a <alltraps>

801061fd <vector22>:
.globl vector22
vector22:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $22
801061ff:	6a 16                	push   $0x16
  jmp alltraps
80106201:	e9 14 fa ff ff       	jmp    80105c1a <alltraps>

80106206 <vector23>:
.globl vector23
vector23:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $23
80106208:	6a 17                	push   $0x17
  jmp alltraps
8010620a:	e9 0b fa ff ff       	jmp    80105c1a <alltraps>

8010620f <vector24>:
.globl vector24
vector24:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $24
80106211:	6a 18                	push   $0x18
  jmp alltraps
80106213:	e9 02 fa ff ff       	jmp    80105c1a <alltraps>

80106218 <vector25>:
.globl vector25
vector25:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $25
8010621a:	6a 19                	push   $0x19
  jmp alltraps
8010621c:	e9 f9 f9 ff ff       	jmp    80105c1a <alltraps>

80106221 <vector26>:
.globl vector26
vector26:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $26
80106223:	6a 1a                	push   $0x1a
  jmp alltraps
80106225:	e9 f0 f9 ff ff       	jmp    80105c1a <alltraps>

8010622a <vector27>:
.globl vector27
vector27:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $27
8010622c:	6a 1b                	push   $0x1b
  jmp alltraps
8010622e:	e9 e7 f9 ff ff       	jmp    80105c1a <alltraps>

80106233 <vector28>:
.globl vector28
vector28:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $28
80106235:	6a 1c                	push   $0x1c
  jmp alltraps
80106237:	e9 de f9 ff ff       	jmp    80105c1a <alltraps>

8010623c <vector29>:
.globl vector29
vector29:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $29
8010623e:	6a 1d                	push   $0x1d
  jmp alltraps
80106240:	e9 d5 f9 ff ff       	jmp    80105c1a <alltraps>

80106245 <vector30>:
.globl vector30
vector30:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $30
80106247:	6a 1e                	push   $0x1e
  jmp alltraps
80106249:	e9 cc f9 ff ff       	jmp    80105c1a <alltraps>

8010624e <vector31>:
.globl vector31
vector31:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $31
80106250:	6a 1f                	push   $0x1f
  jmp alltraps
80106252:	e9 c3 f9 ff ff       	jmp    80105c1a <alltraps>

80106257 <vector32>:
.globl vector32
vector32:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $32
80106259:	6a 20                	push   $0x20
  jmp alltraps
8010625b:	e9 ba f9 ff ff       	jmp    80105c1a <alltraps>

80106260 <vector33>:
.globl vector33
vector33:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $33
80106262:	6a 21                	push   $0x21
  jmp alltraps
80106264:	e9 b1 f9 ff ff       	jmp    80105c1a <alltraps>

80106269 <vector34>:
.globl vector34
vector34:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $34
8010626b:	6a 22                	push   $0x22
  jmp alltraps
8010626d:	e9 a8 f9 ff ff       	jmp    80105c1a <alltraps>

80106272 <vector35>:
.globl vector35
vector35:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $35
80106274:	6a 23                	push   $0x23
  jmp alltraps
80106276:	e9 9f f9 ff ff       	jmp    80105c1a <alltraps>

8010627b <vector36>:
.globl vector36
vector36:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $36
8010627d:	6a 24                	push   $0x24
  jmp alltraps
8010627f:	e9 96 f9 ff ff       	jmp    80105c1a <alltraps>

80106284 <vector37>:
.globl vector37
vector37:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $37
80106286:	6a 25                	push   $0x25
  jmp alltraps
80106288:	e9 8d f9 ff ff       	jmp    80105c1a <alltraps>

8010628d <vector38>:
.globl vector38
vector38:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $38
8010628f:	6a 26                	push   $0x26
  jmp alltraps
80106291:	e9 84 f9 ff ff       	jmp    80105c1a <alltraps>

80106296 <vector39>:
.globl vector39
vector39:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $39
80106298:	6a 27                	push   $0x27
  jmp alltraps
8010629a:	e9 7b f9 ff ff       	jmp    80105c1a <alltraps>

8010629f <vector40>:
.globl vector40
vector40:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $40
801062a1:	6a 28                	push   $0x28
  jmp alltraps
801062a3:	e9 72 f9 ff ff       	jmp    80105c1a <alltraps>

801062a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $41
801062aa:	6a 29                	push   $0x29
  jmp alltraps
801062ac:	e9 69 f9 ff ff       	jmp    80105c1a <alltraps>

801062b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $42
801062b3:	6a 2a                	push   $0x2a
  jmp alltraps
801062b5:	e9 60 f9 ff ff       	jmp    80105c1a <alltraps>

801062ba <vector43>:
.globl vector43
vector43:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $43
801062bc:	6a 2b                	push   $0x2b
  jmp alltraps
801062be:	e9 57 f9 ff ff       	jmp    80105c1a <alltraps>

801062c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $44
801062c5:	6a 2c                	push   $0x2c
  jmp alltraps
801062c7:	e9 4e f9 ff ff       	jmp    80105c1a <alltraps>

801062cc <vector45>:
.globl vector45
vector45:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $45
801062ce:	6a 2d                	push   $0x2d
  jmp alltraps
801062d0:	e9 45 f9 ff ff       	jmp    80105c1a <alltraps>

801062d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $46
801062d7:	6a 2e                	push   $0x2e
  jmp alltraps
801062d9:	e9 3c f9 ff ff       	jmp    80105c1a <alltraps>

801062de <vector47>:
.globl vector47
vector47:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $47
801062e0:	6a 2f                	push   $0x2f
  jmp alltraps
801062e2:	e9 33 f9 ff ff       	jmp    80105c1a <alltraps>

801062e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $48
801062e9:	6a 30                	push   $0x30
  jmp alltraps
801062eb:	e9 2a f9 ff ff       	jmp    80105c1a <alltraps>

801062f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $49
801062f2:	6a 31                	push   $0x31
  jmp alltraps
801062f4:	e9 21 f9 ff ff       	jmp    80105c1a <alltraps>

801062f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $50
801062fb:	6a 32                	push   $0x32
  jmp alltraps
801062fd:	e9 18 f9 ff ff       	jmp    80105c1a <alltraps>

80106302 <vector51>:
.globl vector51
vector51:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $51
80106304:	6a 33                	push   $0x33
  jmp alltraps
80106306:	e9 0f f9 ff ff       	jmp    80105c1a <alltraps>

8010630b <vector52>:
.globl vector52
vector52:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $52
8010630d:	6a 34                	push   $0x34
  jmp alltraps
8010630f:	e9 06 f9 ff ff       	jmp    80105c1a <alltraps>

80106314 <vector53>:
.globl vector53
vector53:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $53
80106316:	6a 35                	push   $0x35
  jmp alltraps
80106318:	e9 fd f8 ff ff       	jmp    80105c1a <alltraps>

8010631d <vector54>:
.globl vector54
vector54:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $54
8010631f:	6a 36                	push   $0x36
  jmp alltraps
80106321:	e9 f4 f8 ff ff       	jmp    80105c1a <alltraps>

80106326 <vector55>:
.globl vector55
vector55:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $55
80106328:	6a 37                	push   $0x37
  jmp alltraps
8010632a:	e9 eb f8 ff ff       	jmp    80105c1a <alltraps>

8010632f <vector56>:
.globl vector56
vector56:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $56
80106331:	6a 38                	push   $0x38
  jmp alltraps
80106333:	e9 e2 f8 ff ff       	jmp    80105c1a <alltraps>

80106338 <vector57>:
.globl vector57
vector57:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $57
8010633a:	6a 39                	push   $0x39
  jmp alltraps
8010633c:	e9 d9 f8 ff ff       	jmp    80105c1a <alltraps>

80106341 <vector58>:
.globl vector58
vector58:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $58
80106343:	6a 3a                	push   $0x3a
  jmp alltraps
80106345:	e9 d0 f8 ff ff       	jmp    80105c1a <alltraps>

8010634a <vector59>:
.globl vector59
vector59:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $59
8010634c:	6a 3b                	push   $0x3b
  jmp alltraps
8010634e:	e9 c7 f8 ff ff       	jmp    80105c1a <alltraps>

80106353 <vector60>:
.globl vector60
vector60:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $60
80106355:	6a 3c                	push   $0x3c
  jmp alltraps
80106357:	e9 be f8 ff ff       	jmp    80105c1a <alltraps>

8010635c <vector61>:
.globl vector61
vector61:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $61
8010635e:	6a 3d                	push   $0x3d
  jmp alltraps
80106360:	e9 b5 f8 ff ff       	jmp    80105c1a <alltraps>

80106365 <vector62>:
.globl vector62
vector62:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $62
80106367:	6a 3e                	push   $0x3e
  jmp alltraps
80106369:	e9 ac f8 ff ff       	jmp    80105c1a <alltraps>

8010636e <vector63>:
.globl vector63
vector63:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $63
80106370:	6a 3f                	push   $0x3f
  jmp alltraps
80106372:	e9 a3 f8 ff ff       	jmp    80105c1a <alltraps>

80106377 <vector64>:
.globl vector64
vector64:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $64
80106379:	6a 40                	push   $0x40
  jmp alltraps
8010637b:	e9 9a f8 ff ff       	jmp    80105c1a <alltraps>

80106380 <vector65>:
.globl vector65
vector65:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $65
80106382:	6a 41                	push   $0x41
  jmp alltraps
80106384:	e9 91 f8 ff ff       	jmp    80105c1a <alltraps>

80106389 <vector66>:
.globl vector66
vector66:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $66
8010638b:	6a 42                	push   $0x42
  jmp alltraps
8010638d:	e9 88 f8 ff ff       	jmp    80105c1a <alltraps>

80106392 <vector67>:
.globl vector67
vector67:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $67
80106394:	6a 43                	push   $0x43
  jmp alltraps
80106396:	e9 7f f8 ff ff       	jmp    80105c1a <alltraps>

8010639b <vector68>:
.globl vector68
vector68:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $68
8010639d:	6a 44                	push   $0x44
  jmp alltraps
8010639f:	e9 76 f8 ff ff       	jmp    80105c1a <alltraps>

801063a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $69
801063a6:	6a 45                	push   $0x45
  jmp alltraps
801063a8:	e9 6d f8 ff ff       	jmp    80105c1a <alltraps>

801063ad <vector70>:
.globl vector70
vector70:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $70
801063af:	6a 46                	push   $0x46
  jmp alltraps
801063b1:	e9 64 f8 ff ff       	jmp    80105c1a <alltraps>

801063b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $71
801063b8:	6a 47                	push   $0x47
  jmp alltraps
801063ba:	e9 5b f8 ff ff       	jmp    80105c1a <alltraps>

801063bf <vector72>:
.globl vector72
vector72:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $72
801063c1:	6a 48                	push   $0x48
  jmp alltraps
801063c3:	e9 52 f8 ff ff       	jmp    80105c1a <alltraps>

801063c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $73
801063ca:	6a 49                	push   $0x49
  jmp alltraps
801063cc:	e9 49 f8 ff ff       	jmp    80105c1a <alltraps>

801063d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $74
801063d3:	6a 4a                	push   $0x4a
  jmp alltraps
801063d5:	e9 40 f8 ff ff       	jmp    80105c1a <alltraps>

801063da <vector75>:
.globl vector75
vector75:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $75
801063dc:	6a 4b                	push   $0x4b
  jmp alltraps
801063de:	e9 37 f8 ff ff       	jmp    80105c1a <alltraps>

801063e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $76
801063e5:	6a 4c                	push   $0x4c
  jmp alltraps
801063e7:	e9 2e f8 ff ff       	jmp    80105c1a <alltraps>

801063ec <vector77>:
.globl vector77
vector77:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $77
801063ee:	6a 4d                	push   $0x4d
  jmp alltraps
801063f0:	e9 25 f8 ff ff       	jmp    80105c1a <alltraps>

801063f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $78
801063f7:	6a 4e                	push   $0x4e
  jmp alltraps
801063f9:	e9 1c f8 ff ff       	jmp    80105c1a <alltraps>

801063fe <vector79>:
.globl vector79
vector79:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $79
80106400:	6a 4f                	push   $0x4f
  jmp alltraps
80106402:	e9 13 f8 ff ff       	jmp    80105c1a <alltraps>

80106407 <vector80>:
.globl vector80
vector80:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $80
80106409:	6a 50                	push   $0x50
  jmp alltraps
8010640b:	e9 0a f8 ff ff       	jmp    80105c1a <alltraps>

80106410 <vector81>:
.globl vector81
vector81:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $81
80106412:	6a 51                	push   $0x51
  jmp alltraps
80106414:	e9 01 f8 ff ff       	jmp    80105c1a <alltraps>

80106419 <vector82>:
.globl vector82
vector82:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $82
8010641b:	6a 52                	push   $0x52
  jmp alltraps
8010641d:	e9 f8 f7 ff ff       	jmp    80105c1a <alltraps>

80106422 <vector83>:
.globl vector83
vector83:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $83
80106424:	6a 53                	push   $0x53
  jmp alltraps
80106426:	e9 ef f7 ff ff       	jmp    80105c1a <alltraps>

8010642b <vector84>:
.globl vector84
vector84:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $84
8010642d:	6a 54                	push   $0x54
  jmp alltraps
8010642f:	e9 e6 f7 ff ff       	jmp    80105c1a <alltraps>

80106434 <vector85>:
.globl vector85
vector85:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $85
80106436:	6a 55                	push   $0x55
  jmp alltraps
80106438:	e9 dd f7 ff ff       	jmp    80105c1a <alltraps>

8010643d <vector86>:
.globl vector86
vector86:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $86
8010643f:	6a 56                	push   $0x56
  jmp alltraps
80106441:	e9 d4 f7 ff ff       	jmp    80105c1a <alltraps>

80106446 <vector87>:
.globl vector87
vector87:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $87
80106448:	6a 57                	push   $0x57
  jmp alltraps
8010644a:	e9 cb f7 ff ff       	jmp    80105c1a <alltraps>

8010644f <vector88>:
.globl vector88
vector88:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $88
80106451:	6a 58                	push   $0x58
  jmp alltraps
80106453:	e9 c2 f7 ff ff       	jmp    80105c1a <alltraps>

80106458 <vector89>:
.globl vector89
vector89:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $89
8010645a:	6a 59                	push   $0x59
  jmp alltraps
8010645c:	e9 b9 f7 ff ff       	jmp    80105c1a <alltraps>

80106461 <vector90>:
.globl vector90
vector90:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $90
80106463:	6a 5a                	push   $0x5a
  jmp alltraps
80106465:	e9 b0 f7 ff ff       	jmp    80105c1a <alltraps>

8010646a <vector91>:
.globl vector91
vector91:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $91
8010646c:	6a 5b                	push   $0x5b
  jmp alltraps
8010646e:	e9 a7 f7 ff ff       	jmp    80105c1a <alltraps>

80106473 <vector92>:
.globl vector92
vector92:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $92
80106475:	6a 5c                	push   $0x5c
  jmp alltraps
80106477:	e9 9e f7 ff ff       	jmp    80105c1a <alltraps>

8010647c <vector93>:
.globl vector93
vector93:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $93
8010647e:	6a 5d                	push   $0x5d
  jmp alltraps
80106480:	e9 95 f7 ff ff       	jmp    80105c1a <alltraps>

80106485 <vector94>:
.globl vector94
vector94:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $94
80106487:	6a 5e                	push   $0x5e
  jmp alltraps
80106489:	e9 8c f7 ff ff       	jmp    80105c1a <alltraps>

8010648e <vector95>:
.globl vector95
vector95:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $95
80106490:	6a 5f                	push   $0x5f
  jmp alltraps
80106492:	e9 83 f7 ff ff       	jmp    80105c1a <alltraps>

80106497 <vector96>:
.globl vector96
vector96:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $96
80106499:	6a 60                	push   $0x60
  jmp alltraps
8010649b:	e9 7a f7 ff ff       	jmp    80105c1a <alltraps>

801064a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $97
801064a2:	6a 61                	push   $0x61
  jmp alltraps
801064a4:	e9 71 f7 ff ff       	jmp    80105c1a <alltraps>

801064a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $98
801064ab:	6a 62                	push   $0x62
  jmp alltraps
801064ad:	e9 68 f7 ff ff       	jmp    80105c1a <alltraps>

801064b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $99
801064b4:	6a 63                	push   $0x63
  jmp alltraps
801064b6:	e9 5f f7 ff ff       	jmp    80105c1a <alltraps>

801064bb <vector100>:
.globl vector100
vector100:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $100
801064bd:	6a 64                	push   $0x64
  jmp alltraps
801064bf:	e9 56 f7 ff ff       	jmp    80105c1a <alltraps>

801064c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $101
801064c6:	6a 65                	push   $0x65
  jmp alltraps
801064c8:	e9 4d f7 ff ff       	jmp    80105c1a <alltraps>

801064cd <vector102>:
.globl vector102
vector102:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $102
801064cf:	6a 66                	push   $0x66
  jmp alltraps
801064d1:	e9 44 f7 ff ff       	jmp    80105c1a <alltraps>

801064d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $103
801064d8:	6a 67                	push   $0x67
  jmp alltraps
801064da:	e9 3b f7 ff ff       	jmp    80105c1a <alltraps>

801064df <vector104>:
.globl vector104
vector104:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $104
801064e1:	6a 68                	push   $0x68
  jmp alltraps
801064e3:	e9 32 f7 ff ff       	jmp    80105c1a <alltraps>

801064e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $105
801064ea:	6a 69                	push   $0x69
  jmp alltraps
801064ec:	e9 29 f7 ff ff       	jmp    80105c1a <alltraps>

801064f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $106
801064f3:	6a 6a                	push   $0x6a
  jmp alltraps
801064f5:	e9 20 f7 ff ff       	jmp    80105c1a <alltraps>

801064fa <vector107>:
.globl vector107
vector107:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $107
801064fc:	6a 6b                	push   $0x6b
  jmp alltraps
801064fe:	e9 17 f7 ff ff       	jmp    80105c1a <alltraps>

80106503 <vector108>:
.globl vector108
vector108:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $108
80106505:	6a 6c                	push   $0x6c
  jmp alltraps
80106507:	e9 0e f7 ff ff       	jmp    80105c1a <alltraps>

8010650c <vector109>:
.globl vector109
vector109:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $109
8010650e:	6a 6d                	push   $0x6d
  jmp alltraps
80106510:	e9 05 f7 ff ff       	jmp    80105c1a <alltraps>

80106515 <vector110>:
.globl vector110
vector110:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $110
80106517:	6a 6e                	push   $0x6e
  jmp alltraps
80106519:	e9 fc f6 ff ff       	jmp    80105c1a <alltraps>

8010651e <vector111>:
.globl vector111
vector111:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $111
80106520:	6a 6f                	push   $0x6f
  jmp alltraps
80106522:	e9 f3 f6 ff ff       	jmp    80105c1a <alltraps>

80106527 <vector112>:
.globl vector112
vector112:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $112
80106529:	6a 70                	push   $0x70
  jmp alltraps
8010652b:	e9 ea f6 ff ff       	jmp    80105c1a <alltraps>

80106530 <vector113>:
.globl vector113
vector113:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $113
80106532:	6a 71                	push   $0x71
  jmp alltraps
80106534:	e9 e1 f6 ff ff       	jmp    80105c1a <alltraps>

80106539 <vector114>:
.globl vector114
vector114:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $114
8010653b:	6a 72                	push   $0x72
  jmp alltraps
8010653d:	e9 d8 f6 ff ff       	jmp    80105c1a <alltraps>

80106542 <vector115>:
.globl vector115
vector115:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $115
80106544:	6a 73                	push   $0x73
  jmp alltraps
80106546:	e9 cf f6 ff ff       	jmp    80105c1a <alltraps>

8010654b <vector116>:
.globl vector116
vector116:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $116
8010654d:	6a 74                	push   $0x74
  jmp alltraps
8010654f:	e9 c6 f6 ff ff       	jmp    80105c1a <alltraps>

80106554 <vector117>:
.globl vector117
vector117:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $117
80106556:	6a 75                	push   $0x75
  jmp alltraps
80106558:	e9 bd f6 ff ff       	jmp    80105c1a <alltraps>

8010655d <vector118>:
.globl vector118
vector118:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $118
8010655f:	6a 76                	push   $0x76
  jmp alltraps
80106561:	e9 b4 f6 ff ff       	jmp    80105c1a <alltraps>

80106566 <vector119>:
.globl vector119
vector119:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $119
80106568:	6a 77                	push   $0x77
  jmp alltraps
8010656a:	e9 ab f6 ff ff       	jmp    80105c1a <alltraps>

8010656f <vector120>:
.globl vector120
vector120:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $120
80106571:	6a 78                	push   $0x78
  jmp alltraps
80106573:	e9 a2 f6 ff ff       	jmp    80105c1a <alltraps>

80106578 <vector121>:
.globl vector121
vector121:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $121
8010657a:	6a 79                	push   $0x79
  jmp alltraps
8010657c:	e9 99 f6 ff ff       	jmp    80105c1a <alltraps>

80106581 <vector122>:
.globl vector122
vector122:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $122
80106583:	6a 7a                	push   $0x7a
  jmp alltraps
80106585:	e9 90 f6 ff ff       	jmp    80105c1a <alltraps>

8010658a <vector123>:
.globl vector123
vector123:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $123
8010658c:	6a 7b                	push   $0x7b
  jmp alltraps
8010658e:	e9 87 f6 ff ff       	jmp    80105c1a <alltraps>

80106593 <vector124>:
.globl vector124
vector124:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $124
80106595:	6a 7c                	push   $0x7c
  jmp alltraps
80106597:	e9 7e f6 ff ff       	jmp    80105c1a <alltraps>

8010659c <vector125>:
.globl vector125
vector125:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $125
8010659e:	6a 7d                	push   $0x7d
  jmp alltraps
801065a0:	e9 75 f6 ff ff       	jmp    80105c1a <alltraps>

801065a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $126
801065a7:	6a 7e                	push   $0x7e
  jmp alltraps
801065a9:	e9 6c f6 ff ff       	jmp    80105c1a <alltraps>

801065ae <vector127>:
.globl vector127
vector127:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $127
801065b0:	6a 7f                	push   $0x7f
  jmp alltraps
801065b2:	e9 63 f6 ff ff       	jmp    80105c1a <alltraps>

801065b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $128
801065b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065be:	e9 57 f6 ff ff       	jmp    80105c1a <alltraps>

801065c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $129
801065c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ca:	e9 4b f6 ff ff       	jmp    80105c1a <alltraps>

801065cf <vector130>:
.globl vector130
vector130:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $130
801065d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065d6:	e9 3f f6 ff ff       	jmp    80105c1a <alltraps>

801065db <vector131>:
.globl vector131
vector131:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $131
801065dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065e2:	e9 33 f6 ff ff       	jmp    80105c1a <alltraps>

801065e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $132
801065e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ee:	e9 27 f6 ff ff       	jmp    80105c1a <alltraps>

801065f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $133
801065f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065fa:	e9 1b f6 ff ff       	jmp    80105c1a <alltraps>

801065ff <vector134>:
.globl vector134
vector134:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $134
80106601:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106606:	e9 0f f6 ff ff       	jmp    80105c1a <alltraps>

8010660b <vector135>:
.globl vector135
vector135:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $135
8010660d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106612:	e9 03 f6 ff ff       	jmp    80105c1a <alltraps>

80106617 <vector136>:
.globl vector136
vector136:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $136
80106619:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010661e:	e9 f7 f5 ff ff       	jmp    80105c1a <alltraps>

80106623 <vector137>:
.globl vector137
vector137:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $137
80106625:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010662a:	e9 eb f5 ff ff       	jmp    80105c1a <alltraps>

8010662f <vector138>:
.globl vector138
vector138:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $138
80106631:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106636:	e9 df f5 ff ff       	jmp    80105c1a <alltraps>

8010663b <vector139>:
.globl vector139
vector139:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $139
8010663d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106642:	e9 d3 f5 ff ff       	jmp    80105c1a <alltraps>

80106647 <vector140>:
.globl vector140
vector140:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $140
80106649:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010664e:	e9 c7 f5 ff ff       	jmp    80105c1a <alltraps>

80106653 <vector141>:
.globl vector141
vector141:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $141
80106655:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010665a:	e9 bb f5 ff ff       	jmp    80105c1a <alltraps>

8010665f <vector142>:
.globl vector142
vector142:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $142
80106661:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106666:	e9 af f5 ff ff       	jmp    80105c1a <alltraps>

8010666b <vector143>:
.globl vector143
vector143:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $143
8010666d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106672:	e9 a3 f5 ff ff       	jmp    80105c1a <alltraps>

80106677 <vector144>:
.globl vector144
vector144:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $144
80106679:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010667e:	e9 97 f5 ff ff       	jmp    80105c1a <alltraps>

80106683 <vector145>:
.globl vector145
vector145:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $145
80106685:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010668a:	e9 8b f5 ff ff       	jmp    80105c1a <alltraps>

8010668f <vector146>:
.globl vector146
vector146:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $146
80106691:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106696:	e9 7f f5 ff ff       	jmp    80105c1a <alltraps>

8010669b <vector147>:
.globl vector147
vector147:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $147
8010669d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066a2:	e9 73 f5 ff ff       	jmp    80105c1a <alltraps>

801066a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $148
801066a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ae:	e9 67 f5 ff ff       	jmp    80105c1a <alltraps>

801066b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $149
801066b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ba:	e9 5b f5 ff ff       	jmp    80105c1a <alltraps>

801066bf <vector150>:
.globl vector150
vector150:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $150
801066c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066c6:	e9 4f f5 ff ff       	jmp    80105c1a <alltraps>

801066cb <vector151>:
.globl vector151
vector151:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $151
801066cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066d2:	e9 43 f5 ff ff       	jmp    80105c1a <alltraps>

801066d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $152
801066d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066de:	e9 37 f5 ff ff       	jmp    80105c1a <alltraps>

801066e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $153
801066e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ea:	e9 2b f5 ff ff       	jmp    80105c1a <alltraps>

801066ef <vector154>:
.globl vector154
vector154:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $154
801066f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066f6:	e9 1f f5 ff ff       	jmp    80105c1a <alltraps>

801066fb <vector155>:
.globl vector155
vector155:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $155
801066fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106702:	e9 13 f5 ff ff       	jmp    80105c1a <alltraps>

80106707 <vector156>:
.globl vector156
vector156:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $156
80106709:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010670e:	e9 07 f5 ff ff       	jmp    80105c1a <alltraps>

80106713 <vector157>:
.globl vector157
vector157:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $157
80106715:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010671a:	e9 fb f4 ff ff       	jmp    80105c1a <alltraps>

8010671f <vector158>:
.globl vector158
vector158:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $158
80106721:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106726:	e9 ef f4 ff ff       	jmp    80105c1a <alltraps>

8010672b <vector159>:
.globl vector159
vector159:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $159
8010672d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106732:	e9 e3 f4 ff ff       	jmp    80105c1a <alltraps>

80106737 <vector160>:
.globl vector160
vector160:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $160
80106739:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010673e:	e9 d7 f4 ff ff       	jmp    80105c1a <alltraps>

80106743 <vector161>:
.globl vector161
vector161:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $161
80106745:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010674a:	e9 cb f4 ff ff       	jmp    80105c1a <alltraps>

8010674f <vector162>:
.globl vector162
vector162:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $162
80106751:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106756:	e9 bf f4 ff ff       	jmp    80105c1a <alltraps>

8010675b <vector163>:
.globl vector163
vector163:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $163
8010675d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106762:	e9 b3 f4 ff ff       	jmp    80105c1a <alltraps>

80106767 <vector164>:
.globl vector164
vector164:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $164
80106769:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010676e:	e9 a7 f4 ff ff       	jmp    80105c1a <alltraps>

80106773 <vector165>:
.globl vector165
vector165:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $165
80106775:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010677a:	e9 9b f4 ff ff       	jmp    80105c1a <alltraps>

8010677f <vector166>:
.globl vector166
vector166:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $166
80106781:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106786:	e9 8f f4 ff ff       	jmp    80105c1a <alltraps>

8010678b <vector167>:
.globl vector167
vector167:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $167
8010678d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106792:	e9 83 f4 ff ff       	jmp    80105c1a <alltraps>

80106797 <vector168>:
.globl vector168
vector168:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $168
80106799:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010679e:	e9 77 f4 ff ff       	jmp    80105c1a <alltraps>

801067a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $169
801067a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067aa:	e9 6b f4 ff ff       	jmp    80105c1a <alltraps>

801067af <vector170>:
.globl vector170
vector170:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $170
801067b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067b6:	e9 5f f4 ff ff       	jmp    80105c1a <alltraps>

801067bb <vector171>:
.globl vector171
vector171:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $171
801067bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067c2:	e9 53 f4 ff ff       	jmp    80105c1a <alltraps>

801067c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $172
801067c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067ce:	e9 47 f4 ff ff       	jmp    80105c1a <alltraps>

801067d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $173
801067d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067da:	e9 3b f4 ff ff       	jmp    80105c1a <alltraps>

801067df <vector174>:
.globl vector174
vector174:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $174
801067e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067e6:	e9 2f f4 ff ff       	jmp    80105c1a <alltraps>

801067eb <vector175>:
.globl vector175
vector175:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $175
801067ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067f2:	e9 23 f4 ff ff       	jmp    80105c1a <alltraps>

801067f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $176
801067f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067fe:	e9 17 f4 ff ff       	jmp    80105c1a <alltraps>

80106803 <vector177>:
.globl vector177
vector177:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $177
80106805:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010680a:	e9 0b f4 ff ff       	jmp    80105c1a <alltraps>

8010680f <vector178>:
.globl vector178
vector178:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $178
80106811:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106816:	e9 ff f3 ff ff       	jmp    80105c1a <alltraps>

8010681b <vector179>:
.globl vector179
vector179:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $179
8010681d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106822:	e9 f3 f3 ff ff       	jmp    80105c1a <alltraps>

80106827 <vector180>:
.globl vector180
vector180:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $180
80106829:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010682e:	e9 e7 f3 ff ff       	jmp    80105c1a <alltraps>

80106833 <vector181>:
.globl vector181
vector181:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $181
80106835:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010683a:	e9 db f3 ff ff       	jmp    80105c1a <alltraps>

8010683f <vector182>:
.globl vector182
vector182:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $182
80106841:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106846:	e9 cf f3 ff ff       	jmp    80105c1a <alltraps>

8010684b <vector183>:
.globl vector183
vector183:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $183
8010684d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106852:	e9 c3 f3 ff ff       	jmp    80105c1a <alltraps>

80106857 <vector184>:
.globl vector184
vector184:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $184
80106859:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010685e:	e9 b7 f3 ff ff       	jmp    80105c1a <alltraps>

80106863 <vector185>:
.globl vector185
vector185:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $185
80106865:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010686a:	e9 ab f3 ff ff       	jmp    80105c1a <alltraps>

8010686f <vector186>:
.globl vector186
vector186:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $186
80106871:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106876:	e9 9f f3 ff ff       	jmp    80105c1a <alltraps>

8010687b <vector187>:
.globl vector187
vector187:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $187
8010687d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106882:	e9 93 f3 ff ff       	jmp    80105c1a <alltraps>

80106887 <vector188>:
.globl vector188
vector188:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $188
80106889:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010688e:	e9 87 f3 ff ff       	jmp    80105c1a <alltraps>

80106893 <vector189>:
.globl vector189
vector189:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $189
80106895:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010689a:	e9 7b f3 ff ff       	jmp    80105c1a <alltraps>

8010689f <vector190>:
.globl vector190
vector190:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $190
801068a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068a6:	e9 6f f3 ff ff       	jmp    80105c1a <alltraps>

801068ab <vector191>:
.globl vector191
vector191:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $191
801068ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068b2:	e9 63 f3 ff ff       	jmp    80105c1a <alltraps>

801068b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $192
801068b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068be:	e9 57 f3 ff ff       	jmp    80105c1a <alltraps>

801068c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $193
801068c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ca:	e9 4b f3 ff ff       	jmp    80105c1a <alltraps>

801068cf <vector194>:
.globl vector194
vector194:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $194
801068d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068d6:	e9 3f f3 ff ff       	jmp    80105c1a <alltraps>

801068db <vector195>:
.globl vector195
vector195:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $195
801068dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068e2:	e9 33 f3 ff ff       	jmp    80105c1a <alltraps>

801068e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $196
801068e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ee:	e9 27 f3 ff ff       	jmp    80105c1a <alltraps>

801068f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $197
801068f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068fa:	e9 1b f3 ff ff       	jmp    80105c1a <alltraps>

801068ff <vector198>:
.globl vector198
vector198:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $198
80106901:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106906:	e9 0f f3 ff ff       	jmp    80105c1a <alltraps>

8010690b <vector199>:
.globl vector199
vector199:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $199
8010690d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106912:	e9 03 f3 ff ff       	jmp    80105c1a <alltraps>

80106917 <vector200>:
.globl vector200
vector200:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $200
80106919:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010691e:	e9 f7 f2 ff ff       	jmp    80105c1a <alltraps>

80106923 <vector201>:
.globl vector201
vector201:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $201
80106925:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010692a:	e9 eb f2 ff ff       	jmp    80105c1a <alltraps>

8010692f <vector202>:
.globl vector202
vector202:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $202
80106931:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106936:	e9 df f2 ff ff       	jmp    80105c1a <alltraps>

8010693b <vector203>:
.globl vector203
vector203:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $203
8010693d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106942:	e9 d3 f2 ff ff       	jmp    80105c1a <alltraps>

80106947 <vector204>:
.globl vector204
vector204:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $204
80106949:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010694e:	e9 c7 f2 ff ff       	jmp    80105c1a <alltraps>

80106953 <vector205>:
.globl vector205
vector205:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $205
80106955:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010695a:	e9 bb f2 ff ff       	jmp    80105c1a <alltraps>

8010695f <vector206>:
.globl vector206
vector206:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $206
80106961:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106966:	e9 af f2 ff ff       	jmp    80105c1a <alltraps>

8010696b <vector207>:
.globl vector207
vector207:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $207
8010696d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106972:	e9 a3 f2 ff ff       	jmp    80105c1a <alltraps>

80106977 <vector208>:
.globl vector208
vector208:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $208
80106979:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010697e:	e9 97 f2 ff ff       	jmp    80105c1a <alltraps>

80106983 <vector209>:
.globl vector209
vector209:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $209
80106985:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010698a:	e9 8b f2 ff ff       	jmp    80105c1a <alltraps>

8010698f <vector210>:
.globl vector210
vector210:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $210
80106991:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106996:	e9 7f f2 ff ff       	jmp    80105c1a <alltraps>

8010699b <vector211>:
.globl vector211
vector211:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $211
8010699d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069a2:	e9 73 f2 ff ff       	jmp    80105c1a <alltraps>

801069a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $212
801069a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ae:	e9 67 f2 ff ff       	jmp    80105c1a <alltraps>

801069b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $213
801069b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ba:	e9 5b f2 ff ff       	jmp    80105c1a <alltraps>

801069bf <vector214>:
.globl vector214
vector214:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $214
801069c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069c6:	e9 4f f2 ff ff       	jmp    80105c1a <alltraps>

801069cb <vector215>:
.globl vector215
vector215:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $215
801069cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069d2:	e9 43 f2 ff ff       	jmp    80105c1a <alltraps>

801069d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $216
801069d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069de:	e9 37 f2 ff ff       	jmp    80105c1a <alltraps>

801069e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $217
801069e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ea:	e9 2b f2 ff ff       	jmp    80105c1a <alltraps>

801069ef <vector218>:
.globl vector218
vector218:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $218
801069f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069f6:	e9 1f f2 ff ff       	jmp    80105c1a <alltraps>

801069fb <vector219>:
.globl vector219
vector219:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $219
801069fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a02:	e9 13 f2 ff ff       	jmp    80105c1a <alltraps>

80106a07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $220
80106a09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a0e:	e9 07 f2 ff ff       	jmp    80105c1a <alltraps>

80106a13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $221
80106a15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a1a:	e9 fb f1 ff ff       	jmp    80105c1a <alltraps>

80106a1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $222
80106a21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a26:	e9 ef f1 ff ff       	jmp    80105c1a <alltraps>

80106a2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $223
80106a2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a32:	e9 e3 f1 ff ff       	jmp    80105c1a <alltraps>

80106a37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $224
80106a39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a3e:	e9 d7 f1 ff ff       	jmp    80105c1a <alltraps>

80106a43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $225
80106a45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a4a:	e9 cb f1 ff ff       	jmp    80105c1a <alltraps>

80106a4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $226
80106a51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a56:	e9 bf f1 ff ff       	jmp    80105c1a <alltraps>

80106a5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $227
80106a5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a62:	e9 b3 f1 ff ff       	jmp    80105c1a <alltraps>

80106a67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $228
80106a69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a6e:	e9 a7 f1 ff ff       	jmp    80105c1a <alltraps>

80106a73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $229
80106a75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a7a:	e9 9b f1 ff ff       	jmp    80105c1a <alltraps>

80106a7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $230
80106a81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a86:	e9 8f f1 ff ff       	jmp    80105c1a <alltraps>

80106a8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $231
80106a8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a92:	e9 83 f1 ff ff       	jmp    80105c1a <alltraps>

80106a97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $232
80106a99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a9e:	e9 77 f1 ff ff       	jmp    80105c1a <alltraps>

80106aa3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $233
80106aa5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aaa:	e9 6b f1 ff ff       	jmp    80105c1a <alltraps>

80106aaf <vector234>:
.globl vector234
vector234:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $234
80106ab1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ab6:	e9 5f f1 ff ff       	jmp    80105c1a <alltraps>

80106abb <vector235>:
.globl vector235
vector235:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $235
80106abd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ac2:	e9 53 f1 ff ff       	jmp    80105c1a <alltraps>

80106ac7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $236
80106ac9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ace:	e9 47 f1 ff ff       	jmp    80105c1a <alltraps>

80106ad3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $237
80106ad5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ada:	e9 3b f1 ff ff       	jmp    80105c1a <alltraps>

80106adf <vector238>:
.globl vector238
vector238:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $238
80106ae1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ae6:	e9 2f f1 ff ff       	jmp    80105c1a <alltraps>

80106aeb <vector239>:
.globl vector239
vector239:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $239
80106aed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106af2:	e9 23 f1 ff ff       	jmp    80105c1a <alltraps>

80106af7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $240
80106af9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106afe:	e9 17 f1 ff ff       	jmp    80105c1a <alltraps>

80106b03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $241
80106b05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b0a:	e9 0b f1 ff ff       	jmp    80105c1a <alltraps>

80106b0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $242
80106b11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b16:	e9 ff f0 ff ff       	jmp    80105c1a <alltraps>

80106b1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $243
80106b1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b22:	e9 f3 f0 ff ff       	jmp    80105c1a <alltraps>

80106b27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $244
80106b29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b2e:	e9 e7 f0 ff ff       	jmp    80105c1a <alltraps>

80106b33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $245
80106b35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b3a:	e9 db f0 ff ff       	jmp    80105c1a <alltraps>

80106b3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $246
80106b41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b46:	e9 cf f0 ff ff       	jmp    80105c1a <alltraps>

80106b4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $247
80106b4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b52:	e9 c3 f0 ff ff       	jmp    80105c1a <alltraps>

80106b57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $248
80106b59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b5e:	e9 b7 f0 ff ff       	jmp    80105c1a <alltraps>

80106b63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $249
80106b65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b6a:	e9 ab f0 ff ff       	jmp    80105c1a <alltraps>

80106b6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $250
80106b71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b76:	e9 9f f0 ff ff       	jmp    80105c1a <alltraps>

80106b7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $251
80106b7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b82:	e9 93 f0 ff ff       	jmp    80105c1a <alltraps>

80106b87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $252
80106b89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b8e:	e9 87 f0 ff ff       	jmp    80105c1a <alltraps>

80106b93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $253
80106b95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b9a:	e9 7b f0 ff ff       	jmp    80105c1a <alltraps>

80106b9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $254
80106ba1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ba6:	e9 6f f0 ff ff       	jmp    80105c1a <alltraps>

80106bab <vector255>:
.globl vector255
vector255:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $255
80106bad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bb2:	e9 63 f0 ff ff       	jmp    80105c1a <alltraps>
80106bb7:	66 90                	xchg   %ax,%ax
80106bb9:	66 90                	xchg   %ax,%ax
80106bbb:	66 90                	xchg   %ax,%ax
80106bbd:	66 90                	xchg   %ax,%ax
80106bbf:	90                   	nop

80106bc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bc6:	89 d3                	mov    %edx,%ebx
{
80106bc8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106bca:	c1 eb 16             	shr    $0x16,%ebx
80106bcd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106bd0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106bd3:	8b 06                	mov    (%esi),%eax
80106bd5:	a8 01                	test   $0x1,%al
80106bd7:	74 27                	je     80106c00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bde:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106be4:	c1 ef 0a             	shr    $0xa,%edi
}
80106be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bea:	89 fa                	mov    %edi,%edx
80106bec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bf2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c00:	85 c9                	test   %ecx,%ecx
80106c02:	74 2c                	je     80106c30 <walkpgdir+0x70>
80106c04:	e8 b7 b8 ff ff       	call   801024c0 <kalloc>
80106c09:	85 c0                	test   %eax,%eax
80106c0b:	89 c3                	mov    %eax,%ebx
80106c0d:	74 21                	je     80106c30 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c0f:	83 ec 04             	sub    $0x4,%esp
80106c12:	68 00 10 00 00       	push   $0x1000
80106c17:	6a 00                	push   $0x0
80106c19:	50                   	push   %eax
80106c1a:	e8 61 dd ff ff       	call   80104980 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c1f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c25:	83 c4 10             	add    $0x10,%esp
80106c28:	83 c8 07             	or     $0x7,%eax
80106c2b:	89 06                	mov    %eax,(%esi)
80106c2d:	eb b5                	jmp    80106be4 <walkpgdir+0x24>
80106c2f:	90                   	nop
}
80106c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c33:	31 c0                	xor    %eax,%eax
}
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5f                   	pop    %edi
80106c38:	5d                   	pop    %ebp
80106c39:	c3                   	ret    
80106c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c40 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c46:	89 d3                	mov    %edx,%ebx
80106c48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c4e:	83 ec 1c             	sub    $0x1c,%esp
80106c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c66:	29 df                	sub    %ebx,%edi
80106c68:	83 c8 01             	or     $0x1,%eax
80106c6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c6e:	eb 15                	jmp    80106c85 <mappages+0x45>
    if(*pte & PTE_P)
80106c70:	f6 00 01             	testb  $0x1,(%eax)
80106c73:	75 45                	jne    80106cba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c75:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c7b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c7d:	74 31                	je     80106cb0 <mappages+0x70>
      break;
    a += PGSIZE;
80106c7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c88:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c8d:	89 da                	mov    %ebx,%edx
80106c8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c92:	e8 29 ff ff ff       	call   80106bc0 <walkpgdir>
80106c97:	85 c0                	test   %eax,%eax
80106c99:	75 d5                	jne    80106c70 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ca3:	5b                   	pop    %ebx
80106ca4:	5e                   	pop    %esi
80106ca5:	5f                   	pop    %edi
80106ca6:	5d                   	pop    %ebp
80106ca7:	c3                   	ret    
80106ca8:	90                   	nop
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cb3:	31 c0                	xor    %eax,%eax
}
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    
      panic("remap");
80106cba:	83 ec 0c             	sub    $0xc,%esp
80106cbd:	68 34 7e 10 80       	push   $0x80107e34
80106cc2:	e8 c9 96 ff ff       	call   80100390 <panic>
80106cc7:	89 f6                	mov    %esi,%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cdc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cde:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ce4:	83 ec 1c             	sub    $0x1c,%esp
80106ce7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cea:	39 d3                	cmp    %edx,%ebx
80106cec:	73 66                	jae    80106d54 <deallocuvm.part.0+0x84>
80106cee:	89 d6                	mov    %edx,%esi
80106cf0:	eb 3d                	jmp    80106d2f <deallocuvm.part.0+0x5f>
80106cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cf8:	8b 10                	mov    (%eax),%edx
80106cfa:	f6 c2 01             	test   $0x1,%dl
80106cfd:	74 26                	je     80106d25 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106cff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d05:	74 58                	je     80106d5f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106d13:	52                   	push   %edx
80106d14:	e8 f7 b5 ff ff       	call   80102310 <kfree>
      *pte = 0;
80106d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d1c:	83 c4 10             	add    $0x10,%esp
80106d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d2b:	39 f3                	cmp    %esi,%ebx
80106d2d:	73 25                	jae    80106d54 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d2f:	31 c9                	xor    %ecx,%ecx
80106d31:	89 da                	mov    %ebx,%edx
80106d33:	89 f8                	mov    %edi,%eax
80106d35:	e8 86 fe ff ff       	call   80106bc0 <walkpgdir>
    if(!pte)
80106d3a:	85 c0                	test   %eax,%eax
80106d3c:	75 ba                	jne    80106cf8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d50:	39 f3                	cmp    %esi,%ebx
80106d52:	72 db                	jb     80106d2f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d5a:	5b                   	pop    %ebx
80106d5b:	5e                   	pop    %esi
80106d5c:	5f                   	pop    %edi
80106d5d:	5d                   	pop    %ebp
80106d5e:	c3                   	ret    
        panic("kfree");
80106d5f:	83 ec 0c             	sub    $0xc,%esp
80106d62:	68 66 77 10 80       	push   $0x80107766
80106d67:	e8 24 96 ff ff       	call   80100390 <panic>
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d70 <seginit>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d76:	e8 65 ca ff ff       	call   801037e0 <cpuid>
80106d7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d81:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d8a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106d91:	ff 00 00 
80106d94:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106d9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106da5:	ff 00 00 
80106da8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106daf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106db2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106db9:	ff 00 00 
80106dbc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106dc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dc6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106dcd:	ff 00 00 
80106dd0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106dd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dda:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106ddf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	c1 e8 10             	shr    $0x10,%eax
80106de6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ded:	0f 01 10             	lgdtl  (%eax)
}
80106df0:	c9                   	leave  
80106df1:	c3                   	ret    
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e00:	a1 c4 5b 11 80       	mov    0x80115bc4,%eax
{
80106e05:	55                   	push   %ebp
80106e06:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e08:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e0d:	0f 22 d8             	mov    %eax,%cr3
}
80106e10:	5d                   	pop    %ebp
80106e11:	c3                   	ret    
80106e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <switchuvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e2c:	85 db                	test   %ebx,%ebx
80106e2e:	0f 84 cb 00 00 00    	je     80106eff <switchuvm+0xdf>
  if(p->kstack == 0)
80106e34:	8b 43 18             	mov    0x18(%ebx),%eax
80106e37:	85 c0                	test   %eax,%eax
80106e39:	0f 84 da 00 00 00    	je     80106f19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e3f:	8b 43 14             	mov    0x14(%ebx),%eax
80106e42:	85 c0                	test   %eax,%eax
80106e44:	0f 84 c2 00 00 00    	je     80106f0c <switchuvm+0xec>
  pushcli();
80106e4a:	e8 51 d9 ff ff       	call   801047a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e4f:	e8 0c c9 ff ff       	call   80103760 <mycpu>
80106e54:	89 c6                	mov    %eax,%esi
80106e56:	e8 05 c9 ff ff       	call   80103760 <mycpu>
80106e5b:	89 c7                	mov    %eax,%edi
80106e5d:	e8 fe c8 ff ff       	call   80103760 <mycpu>
80106e62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e65:	83 c7 08             	add    $0x8,%edi
80106e68:	e8 f3 c8 ff ff       	call   80103760 <mycpu>
80106e6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e70:	83 c0 08             	add    $0x8,%eax
80106e73:	ba 67 00 00 00       	mov    $0x67,%edx
80106e78:	c1 e8 18             	shr    $0x18,%eax
80106e7b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e82:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e89:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e8f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e94:	83 c1 08             	add    $0x8,%ecx
80106e97:	c1 e9 10             	shr    $0x10,%ecx
80106e9a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ea0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ea5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106eb1:	e8 aa c8 ff ff       	call   80103760 <mycpu>
80106eb6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ebd:	e8 9e c8 ff ff       	call   80103760 <mycpu>
80106ec2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ec6:	8b 73 18             	mov    0x18(%ebx),%esi
80106ec9:	e8 92 c8 ff ff       	call   80103760 <mycpu>
80106ece:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ed4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ed7:	e8 84 c8 ff ff       	call   80103760 <mycpu>
80106edc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ee0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ee5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ee8:	8b 43 14             	mov    0x14(%ebx),%eax
80106eeb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ef0:	0f 22 d8             	mov    %eax,%cr3
}
80106ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef6:	5b                   	pop    %ebx
80106ef7:	5e                   	pop    %esi
80106ef8:	5f                   	pop    %edi
80106ef9:	5d                   	pop    %ebp
  popcli();
80106efa:	e9 e1 d8 ff ff       	jmp    801047e0 <popcli>
    panic("switchuvm: no process");
80106eff:	83 ec 0c             	sub    $0xc,%esp
80106f02:	68 3a 7e 10 80       	push   $0x80107e3a
80106f07:	e8 84 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106f0c:	83 ec 0c             	sub    $0xc,%esp
80106f0f:	68 65 7e 10 80       	push   $0x80107e65
80106f14:	e8 77 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106f19:	83 ec 0c             	sub    $0xc,%esp
80106f1c:	68 50 7e 10 80       	push   $0x80107e50
80106f21:	e8 6a 94 ff ff       	call   80100390 <panic>
80106f26:	8d 76 00             	lea    0x0(%esi),%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f30 <inituvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 1c             	sub    $0x1c,%esp
80106f39:	8b 75 10             	mov    0x10(%ebp),%esi
80106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f42:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f4b:	77 49                	ja     80106f96 <inituvm+0x66>
  mem = kalloc();
80106f4d:	e8 6e b5 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106f52:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f55:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f57:	68 00 10 00 00       	push   $0x1000
80106f5c:	6a 00                	push   $0x0
80106f5e:	50                   	push   %eax
80106f5f:	e8 1c da ff ff       	call   80104980 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f64:	58                   	pop    %eax
80106f65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f6b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f70:	5a                   	pop    %edx
80106f71:	6a 06                	push   $0x6
80106f73:	50                   	push   %eax
80106f74:	31 d2                	xor    %edx,%edx
80106f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f79:	e8 c2 fc ff ff       	call   80106c40 <mappages>
  memmove(mem, init, sz);
80106f7e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f81:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f84:	83 c4 10             	add    $0x10,%esp
80106f87:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f91:	e9 9a da ff ff       	jmp    80104a30 <memmove>
    panic("inituvm: more than a page");
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	68 79 7e 10 80       	push   $0x80107e79
80106f9e:	e8 ed 93 ff ff       	call   80100390 <panic>
80106fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <loaduvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106fb9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106fc0:	0f 85 91 00 00 00    	jne    80107057 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106fc6:	8b 75 18             	mov    0x18(%ebp),%esi
80106fc9:	31 db                	xor    %ebx,%ebx
80106fcb:	85 f6                	test   %esi,%esi
80106fcd:	75 1a                	jne    80106fe9 <loaduvm+0x39>
80106fcf:	eb 6f                	jmp    80107040 <loaduvm+0x90>
80106fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fde:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fe4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fe7:	76 57                	jbe    80107040 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fec:	8b 45 08             	mov    0x8(%ebp),%eax
80106fef:	31 c9                	xor    %ecx,%ecx
80106ff1:	01 da                	add    %ebx,%edx
80106ff3:	e8 c8 fb ff ff       	call   80106bc0 <walkpgdir>
80106ff8:	85 c0                	test   %eax,%eax
80106ffa:	74 4e                	je     8010704a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ffc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ffe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107001:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107006:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010700b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107011:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107014:	01 d9                	add    %ebx,%ecx
80107016:	05 00 00 00 80       	add    $0x80000000,%eax
8010701b:	57                   	push   %edi
8010701c:	51                   	push   %ecx
8010701d:	50                   	push   %eax
8010701e:	ff 75 10             	pushl  0x10(%ebp)
80107021:	e8 3a a9 ff ff       	call   80101960 <readi>
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	39 f8                	cmp    %edi,%eax
8010702b:	74 ab                	je     80106fd8 <loaduvm+0x28>
}
8010702d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107035:	5b                   	pop    %ebx
80107036:	5e                   	pop    %esi
80107037:	5f                   	pop    %edi
80107038:	5d                   	pop    %ebp
80107039:	c3                   	ret    
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107043:	31 c0                	xor    %eax,%eax
}
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
      panic("loaduvm: address should exist");
8010704a:	83 ec 0c             	sub    $0xc,%esp
8010704d:	68 93 7e 10 80       	push   $0x80107e93
80107052:	e8 39 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107057:	83 ec 0c             	sub    $0xc,%esp
8010705a:	68 34 7f 10 80       	push   $0x80107f34
8010705f:	e8 2c 93 ff ff       	call   80100390 <panic>
80107064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010706a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107070 <allocuvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107079:	8b 7d 10             	mov    0x10(%ebp),%edi
8010707c:	85 ff                	test   %edi,%edi
8010707e:	0f 88 8e 00 00 00    	js     80107112 <allocuvm+0xa2>
  if(newsz < oldsz)
80107084:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107087:	0f 82 93 00 00 00    	jb     80107120 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010708d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107090:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107096:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010709c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010709f:	0f 86 7e 00 00 00    	jbe    80107123 <allocuvm+0xb3>
801070a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801070a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070ab:	eb 42                	jmp    801070ef <allocuvm+0x7f>
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801070b0:	83 ec 04             	sub    $0x4,%esp
801070b3:	68 00 10 00 00       	push   $0x1000
801070b8:	6a 00                	push   $0x0
801070ba:	50                   	push   %eax
801070bb:	e8 c0 d8 ff ff       	call   80104980 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070c0:	58                   	pop    %eax
801070c1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070cc:	5a                   	pop    %edx
801070cd:	6a 06                	push   $0x6
801070cf:	50                   	push   %eax
801070d0:	89 da                	mov    %ebx,%edx
801070d2:	89 f8                	mov    %edi,%eax
801070d4:	e8 67 fb ff ff       	call   80106c40 <mappages>
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	85 c0                	test   %eax,%eax
801070de:	78 50                	js     80107130 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801070e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070e6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070e9:	0f 86 81 00 00 00    	jbe    80107170 <allocuvm+0x100>
    mem = kalloc();
801070ef:	e8 cc b3 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
801070f4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070f6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070f8:	75 b6                	jne    801070b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 b1 7e 10 80       	push   $0x80107eb1
80107102:	e8 59 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107107:	83 c4 10             	add    $0x10,%esp
8010710a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010710d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107110:	77 6e                	ja     80107180 <allocuvm+0x110>
}
80107112:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107115:	31 ff                	xor    %edi,%edi
}
80107117:	89 f8                	mov    %edi,%eax
80107119:	5b                   	pop    %ebx
8010711a:	5e                   	pop    %esi
8010711b:	5f                   	pop    %edi
8010711c:	5d                   	pop    %ebp
8010711d:	c3                   	ret    
8010711e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107120:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107126:	89 f8                	mov    %edi,%eax
80107128:	5b                   	pop    %ebx
80107129:	5e                   	pop    %esi
8010712a:	5f                   	pop    %edi
8010712b:	5d                   	pop    %ebp
8010712c:	c3                   	ret    
8010712d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107130:	83 ec 0c             	sub    $0xc,%esp
80107133:	68 c9 7e 10 80       	push   $0x80107ec9
80107138:	e8 23 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010713d:	83 c4 10             	add    $0x10,%esp
80107140:	8b 45 0c             	mov    0xc(%ebp),%eax
80107143:	39 45 10             	cmp    %eax,0x10(%ebp)
80107146:	76 0d                	jbe    80107155 <allocuvm+0xe5>
80107148:	89 c1                	mov    %eax,%ecx
8010714a:	8b 55 10             	mov    0x10(%ebp),%edx
8010714d:	8b 45 08             	mov    0x8(%ebp),%eax
80107150:	e8 7b fb ff ff       	call   80106cd0 <deallocuvm.part.0>
      kfree(mem);
80107155:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107158:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010715a:	56                   	push   %esi
8010715b:	e8 b0 b1 ff ff       	call   80102310 <kfree>
      return 0;
80107160:	83 c4 10             	add    $0x10,%esp
}
80107163:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107166:	89 f8                	mov    %edi,%eax
80107168:	5b                   	pop    %ebx
80107169:	5e                   	pop    %esi
8010716a:	5f                   	pop    %edi
8010716b:	5d                   	pop    %ebp
8010716c:	c3                   	ret    
8010716d:	8d 76 00             	lea    0x0(%esi),%esi
80107170:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107176:	5b                   	pop    %ebx
80107177:	89 f8                	mov    %edi,%eax
80107179:	5e                   	pop    %esi
8010717a:	5f                   	pop    %edi
8010717b:	5d                   	pop    %ebp
8010717c:	c3                   	ret    
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
80107180:	89 c1                	mov    %eax,%ecx
80107182:	8b 55 10             	mov    0x10(%ebp),%edx
80107185:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107188:	31 ff                	xor    %edi,%edi
8010718a:	e8 41 fb ff ff       	call   80106cd0 <deallocuvm.part.0>
8010718f:	eb 92                	jmp    80107123 <allocuvm+0xb3>
80107191:	eb 0d                	jmp    801071a0 <deallocuvm>
80107193:	90                   	nop
80107194:	90                   	nop
80107195:	90                   	nop
80107196:	90                   	nop
80107197:	90                   	nop
80107198:	90                   	nop
80107199:	90                   	nop
8010719a:	90                   	nop
8010719b:	90                   	nop
8010719c:	90                   	nop
8010719d:	90                   	nop
8010719e:	90                   	nop
8010719f:	90                   	nop

801071a0 <deallocuvm>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801071a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801071ac:	39 d1                	cmp    %edx,%ecx
801071ae:	73 10                	jae    801071c0 <deallocuvm+0x20>
}
801071b0:	5d                   	pop    %ebp
801071b1:	e9 1a fb ff ff       	jmp    80106cd0 <deallocuvm.part.0>
801071b6:	8d 76 00             	lea    0x0(%esi),%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071c0:	89 d0                	mov    %edx,%eax
801071c2:	5d                   	pop    %ebp
801071c3:	c3                   	ret    
801071c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071dc:	85 f6                	test   %esi,%esi
801071de:	74 59                	je     80107239 <freevm+0x69>
801071e0:	31 c9                	xor    %ecx,%ecx
801071e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071e7:	89 f0                	mov    %esi,%eax
801071e9:	e8 e2 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
801071ee:	89 f3                	mov    %esi,%ebx
801071f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071f6:	eb 0f                	jmp    80107207 <freevm+0x37>
801071f8:	90                   	nop
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107200:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107203:	39 fb                	cmp    %edi,%ebx
80107205:	74 23                	je     8010722a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107207:	8b 03                	mov    (%ebx),%eax
80107209:	a8 01                	test   $0x1,%al
8010720b:	74 f3                	je     80107200 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010720d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107212:	83 ec 0c             	sub    $0xc,%esp
80107215:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107218:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010721d:	50                   	push   %eax
8010721e:	e8 ed b0 ff ff       	call   80102310 <kfree>
80107223:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107226:	39 fb                	cmp    %edi,%ebx
80107228:	75 dd                	jne    80107207 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010722a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010722d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107230:	5b                   	pop    %ebx
80107231:	5e                   	pop    %esi
80107232:	5f                   	pop    %edi
80107233:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107234:	e9 d7 b0 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107239:	83 ec 0c             	sub    $0xc,%esp
8010723c:	68 e5 7e 10 80       	push   $0x80107ee5
80107241:	e8 4a 91 ff ff       	call   80100390 <panic>
80107246:	8d 76 00             	lea    0x0(%esi),%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <setupkvm>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	56                   	push   %esi
80107254:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107255:	e8 66 b2 ff ff       	call   801024c0 <kalloc>
8010725a:	85 c0                	test   %eax,%eax
8010725c:	89 c6                	mov    %eax,%esi
8010725e:	74 42                	je     801072a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107260:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107263:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107268:	68 00 10 00 00       	push   $0x1000
8010726d:	6a 00                	push   $0x0
8010726f:	50                   	push   %eax
80107270:	e8 0b d7 ff ff       	call   80104980 <memset>
80107275:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107278:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010727b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010727e:	83 ec 08             	sub    $0x8,%esp
80107281:	8b 13                	mov    (%ebx),%edx
80107283:	ff 73 0c             	pushl  0xc(%ebx)
80107286:	50                   	push   %eax
80107287:	29 c1                	sub    %eax,%ecx
80107289:	89 f0                	mov    %esi,%eax
8010728b:	e8 b0 f9 ff ff       	call   80106c40 <mappages>
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	85 c0                	test   %eax,%eax
80107295:	78 19                	js     801072b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107297:	83 c3 10             	add    $0x10,%ebx
8010729a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801072a0:	75 d6                	jne    80107278 <setupkvm+0x28>
}
801072a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072a5:	89 f0                	mov    %esi,%eax
801072a7:	5b                   	pop    %ebx
801072a8:	5e                   	pop    %esi
801072a9:	5d                   	pop    %ebp
801072aa:	c3                   	ret    
801072ab:	90                   	nop
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	56                   	push   %esi
      return 0;
801072b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801072b6:	e8 15 ff ff ff       	call   801071d0 <freevm>
      return 0;
801072bb:	83 c4 10             	add    $0x10,%esp
}
801072be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072c1:	89 f0                	mov    %esi,%eax
801072c3:	5b                   	pop    %ebx
801072c4:	5e                   	pop    %esi
801072c5:	5d                   	pop    %ebp
801072c6:	c3                   	ret    
801072c7:	89 f6                	mov    %esi,%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072d0 <kvmalloc>:
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072d6:	e8 75 ff ff ff       	call   80107250 <setupkvm>
801072db:	a3 c4 5b 11 80       	mov    %eax,0x80115bc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e0:	05 00 00 00 80       	add    $0x80000000,%eax
801072e5:	0f 22 d8             	mov    %eax,%cr3
}
801072e8:	c9                   	leave  
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072f1:	31 c9                	xor    %ecx,%ecx
{
801072f3:	89 e5                	mov    %esp,%ebp
801072f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072fb:	8b 45 08             	mov    0x8(%ebp),%eax
801072fe:	e8 bd f8 ff ff       	call   80106bc0 <walkpgdir>
  if(pte == 0)
80107303:	85 c0                	test   %eax,%eax
80107305:	74 05                	je     8010730c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107307:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010730a:	c9                   	leave  
8010730b:	c3                   	ret    
    panic("clearpteu");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 f6 7e 10 80       	push   $0x80107ef6
80107314:	e8 77 90 ff ff       	call   80100390 <panic>
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107329:	e8 22 ff ff ff       	call   80107250 <setupkvm>
8010732e:	85 c0                	test   %eax,%eax
80107330:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107333:	0f 84 9f 00 00 00    	je     801073d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010733c:	85 c9                	test   %ecx,%ecx
8010733e:	0f 84 94 00 00 00    	je     801073d8 <copyuvm+0xb8>
80107344:	31 ff                	xor    %edi,%edi
80107346:	eb 4a                	jmp    80107392 <copyuvm+0x72>
80107348:	90                   	nop
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107350:	83 ec 04             	sub    $0x4,%esp
80107353:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107359:	68 00 10 00 00       	push   $0x1000
8010735e:	53                   	push   %ebx
8010735f:	50                   	push   %eax
80107360:	e8 cb d6 ff ff       	call   80104a30 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107365:	58                   	pop    %eax
80107366:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010736c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107371:	5a                   	pop    %edx
80107372:	ff 75 e4             	pushl  -0x1c(%ebp)
80107375:	50                   	push   %eax
80107376:	89 fa                	mov    %edi,%edx
80107378:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010737b:	e8 c0 f8 ff ff       	call   80106c40 <mappages>
80107380:	83 c4 10             	add    $0x10,%esp
80107383:	85 c0                	test   %eax,%eax
80107385:	78 61                	js     801073e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107387:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010738d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107390:	76 46                	jbe    801073d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107392:	8b 45 08             	mov    0x8(%ebp),%eax
80107395:	31 c9                	xor    %ecx,%ecx
80107397:	89 fa                	mov    %edi,%edx
80107399:	e8 22 f8 ff ff       	call   80106bc0 <walkpgdir>
8010739e:	85 c0                	test   %eax,%eax
801073a0:	74 61                	je     80107403 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801073a2:	8b 00                	mov    (%eax),%eax
801073a4:	a8 01                	test   $0x1,%al
801073a6:	74 4e                	je     801073f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801073a8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801073aa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801073af:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801073b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801073b8:	e8 03 b1 ff ff       	call   801024c0 <kalloc>
801073bd:	85 c0                	test   %eax,%eax
801073bf:	89 c6                	mov    %eax,%esi
801073c1:	75 8d                	jne    80107350 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801073c3:	83 ec 0c             	sub    $0xc,%esp
801073c6:	ff 75 e0             	pushl  -0x20(%ebp)
801073c9:	e8 02 fe ff ff       	call   801071d0 <freevm>
  return 0;
801073ce:	83 c4 10             	add    $0x10,%esp
801073d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073de:	5b                   	pop    %ebx
801073df:	5e                   	pop    %esi
801073e0:	5f                   	pop    %edi
801073e1:	5d                   	pop    %ebp
801073e2:	c3                   	ret    
801073e3:	90                   	nop
801073e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073e8:	83 ec 0c             	sub    $0xc,%esp
801073eb:	56                   	push   %esi
801073ec:	e8 1f af ff ff       	call   80102310 <kfree>
      goto bad;
801073f1:	83 c4 10             	add    $0x10,%esp
801073f4:	eb cd                	jmp    801073c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801073f6:	83 ec 0c             	sub    $0xc,%esp
801073f9:	68 1a 7f 10 80       	push   $0x80107f1a
801073fe:	e8 8d 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107403:	83 ec 0c             	sub    $0xc,%esp
80107406:	68 00 7f 10 80       	push   $0x80107f00
8010740b:	e8 80 8f ff ff       	call   80100390 <panic>

80107410 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107410:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107411:	31 c9                	xor    %ecx,%ecx
{
80107413:	89 e5                	mov    %esp,%ebp
80107415:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107418:	8b 55 0c             	mov    0xc(%ebp),%edx
8010741b:	8b 45 08             	mov    0x8(%ebp),%eax
8010741e:	e8 9d f7 ff ff       	call   80106bc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107423:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107425:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107426:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107428:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010742d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107430:	05 00 00 00 80       	add    $0x80000000,%eax
80107435:	83 fa 05             	cmp    $0x5,%edx
80107438:	ba 00 00 00 00       	mov    $0x0,%edx
8010743d:	0f 45 c2             	cmovne %edx,%eax
}
80107440:	c3                   	ret    
80107441:	eb 0d                	jmp    80107450 <copyout>
80107443:	90                   	nop
80107444:	90                   	nop
80107445:	90                   	nop
80107446:	90                   	nop
80107447:	90                   	nop
80107448:	90                   	nop
80107449:	90                   	nop
8010744a:	90                   	nop
8010744b:	90                   	nop
8010744c:	90                   	nop
8010744d:	90                   	nop
8010744e:	90                   	nop
8010744f:	90                   	nop

80107450 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 1c             	sub    $0x1c,%esp
80107459:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010745c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010745f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107462:	85 db                	test   %ebx,%ebx
80107464:	75 40                	jne    801074a6 <copyout+0x56>
80107466:	eb 70                	jmp    801074d8 <copyout+0x88>
80107468:	90                   	nop
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107470:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107473:	89 f1                	mov    %esi,%ecx
80107475:	29 d1                	sub    %edx,%ecx
80107477:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010747d:	39 d9                	cmp    %ebx,%ecx
8010747f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107482:	29 f2                	sub    %esi,%edx
80107484:	83 ec 04             	sub    $0x4,%esp
80107487:	01 d0                	add    %edx,%eax
80107489:	51                   	push   %ecx
8010748a:	57                   	push   %edi
8010748b:	50                   	push   %eax
8010748c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010748f:	e8 9c d5 ff ff       	call   80104a30 <memmove>
    len -= n;
    buf += n;
80107494:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107497:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010749a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801074a0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801074a2:	29 cb                	sub    %ecx,%ebx
801074a4:	74 32                	je     801074d8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801074a6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074a8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801074ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801074ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074b4:	56                   	push   %esi
801074b5:	ff 75 08             	pushl  0x8(%ebp)
801074b8:	e8 53 ff ff ff       	call   80107410 <uva2ka>
    if(pa0 == 0)
801074bd:	83 c4 10             	add    $0x10,%esp
801074c0:	85 c0                	test   %eax,%eax
801074c2:	75 ac                	jne    80107470 <copyout+0x20>
  }
  return 0;
}
801074c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074cc:	5b                   	pop    %ebx
801074cd:	5e                   	pop    %esi
801074ce:	5f                   	pop    %edi
801074cf:	5d                   	pop    %ebp
801074d0:	c3                   	ret    
801074d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074db:	31 c0                	xor    %eax,%eax
}
801074dd:	5b                   	pop    %ebx
801074de:	5e                   	pop    %esi
801074df:	5f                   	pop    %edi
801074e0:	5d                   	pop    %ebp
801074e1:	c3                   	ret    
