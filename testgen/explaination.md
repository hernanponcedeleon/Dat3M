e1 po e2 rf e3 po e4 rf e1

e1.thread == e2.thread thr_merge( e1, e2 )
e1.row < e2.row

e2.addr == e3.addr; addr_merge( e2, e3 )
e2.type == WRITE
e3.type == READ
e2.value == e3.value

T1:
    r0 = r( x )
    w( x, 1 )
    r2 = r( x )
    w( x, 3 )

exists( r2 == 1 && r0 == 3 )

e1 co e2 po e3 rf e4 fr e1

e4 --rf^1-> e3

po()
rf()
co()

Set<Event> ?

po() ?
rf() ?
co() ?


forall e1,e2 in Set<Event>: po(e1,e2) => e1.thread == e2.thread && e1.raw < e2.raw
forall e1,e2 in Set<Event>: rf(e1,e2) => e1.addr== e2.add && e1.val == e2.val && e1.type = W && e2.type==R
forall e1,e2 in Set<Event>: co(e1,e2) ...
forall e1,e2 in Set<Event>: fr(e1,e2) => exists ex in Set<Event>: rf(ex,e1) && co(ex,e2)


e1 co e2 po e3 rf e4 fr e1

e1 :: DataType Event
e2 :: DataType Event
e3 :: DataType Event
e4 :: DataType Event

// This you add		This the solver derives
s.add(co(e1,e2)) -----> e1.addr == e2.addr
s.add(po(e2,e3))