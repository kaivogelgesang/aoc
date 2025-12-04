from a import parse, sys
from dataclasses import dataclass

@dataclass
class Node:
    left: any
    right: any
    id: int | None
    size: int
    _dbg: str | None = None
    was_moved = False

    def is_space(self) -> bool:
        return self.id is None

def push_right(node: Node, other: Node):
    if node.right:
        node.right.left = other
        other.right = node.right
    other.left = node
    node.right = other
    

def push_left(node: Node, other: Node):
    if node.left:
        node.left.right = other
        other.left = node.left
    other.right = node
    node.left = other


def splice_out(node):
    if node.left:
        node.left.right = node.right
    if node.right:
        node.right.left = node.left
        

def merge_space(node):
    if node.id is not None:
        # raise ValueError("Attempt to call merge_space on File")
        return
    while node.right and (r := node.right).id is not None:
        splice_out(r)
        node.space += r.space
        del r


def find_space(node, size, end=None) -> Node | None:
    cur = node
    # while cur != end:  # oopsie, quadratic
    while cur is not None and cur is not end:
        if cur.id is None and cur.size >= size:
            return cur
        
        cur = cur.right
        

def merge_right(node):
    if node.id is not None:
        # raise ValueError("Attemt to merge file!")
        return
    if not node.right:
        return
    right = node.right
    if right.id is None:
        return
    node.size += right.size
    node.right = right.right
    right.left = node
    del right


def debug_print(node):
    print(node.size * (str(node.id) if node.id is not None else "."), end="")
    if node.right:
        debug_print(node.right)
    else:
        print()

def debug_print2(node, dbg="a", write=False):
    if write:
        node._dbg = dbg
    print(node.size * (node._dbg if node._dbg is not None else "?"), end="")
    if node.right:
        debug_print2(node.right, dbg=chr(ord(dbg) + 1), write=write)
    else:
        print()


def checksum(node, start=0):
    n = node.size
    t = (n * (n - 1)) // 2
    s = (start * n + t) * (node.id if node.id is not None else 0)
    if node.right:
        s += checksum(node.right, start=start+n)
    return s


if __name__ == "__main__":
    row = parse()
    sys.setrecursionlimit(2 * len(row))

    ll = lr = Node(None, None, 0, row[0])
    i = 1
    space = True

    spaces = []
    files = []

    for size in row[1:]:
        if space:
            # push space
            push_right(lr, Node(None, None, None, size))
            lr = lr.right
            space = False
        else:
            # push file(i)
            push_right(lr, Node(None, None, i, size))
            lr = lr.right
            i += 1
            space = True

    max_file = lr.id if lr.id is not None else lr.left.id

    debug_exit = -1
    RED = "\033[31m"
    RESET = "\033[0m"

    cur = lr
    while cur != ll:
        if debug_exit == 0:
            exit(1)
        debug_exit -= 1
        # debug_print(ll)
        # debug_print2(ll, write=True)
        if cur.id is not None:
            print(f"{cur.id}/{max_file}", file=sys.stderr)

        # print(f"cur = Node({cur.id}, size={cur.size}, _dbg={cur._dbg})")

        if cur.was_moved:
            # print(RED + "skipping because was moved" + RESET)
            cur = cur.left
            continue

        if cur.is_space():
            # print(RED + "skipping because space" + RESET)
            cur = cur.left
            continue
        
        if (space := find_space(ll, cur.size, end=cur)):
            # print(RED + f"space found: Node({space.id}, size={space.size}, _dbg={space._dbg})" + RESET)
            l = cur.left
            splice_out(cur)

            #print("\nsplice out:")
            #debug_print(ll)
            #debug_print2(ll)

            push_right(l, Node(None, None, None, cur.size))

            #print("\npush_right:")
            #debug_print(ll)
            #debug_print2(ll)

            merge_space(l)

            #print("\nmerge_space:")
            #debug_print(ll)
            #debug_print2(ll)
            
            push_left(space, cur)
            space.size -= cur.size
            cur.was_moved = True
            cur = l

            #print("\ninsert:")
            #debug_print(ll)
            #debug_print2(ll)
            continue
        
        # print(RED + "no space found" + RESET)
        cur = cur.left
        
    print(checksum(ll))
