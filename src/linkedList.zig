const std = @import("std");

const List = struct {
    const Self = @This();

    pub const Node = struct { value: i32, next: ?*Node = null };
    first: ?*Node = null,
    last: ?*Node = null,
    len: usize = 0,

    pub fn init() List {
        return Self{
            .first = null,
            .last = null,
            .len = 0,
        };
    }

    pub fn add(self: *Self, allocator: std.mem.Allocator, value: i32) anyerror!*List {
        var node = try allocator.create(Node);
        node.next = null;
        node.value = value;

        if (self.first == null) {
            self.first = node;
            self.last = node;
        } else {
            var last = self.last.?;
            last.next = node;
            self.last = node;
        }
        self.len += 1;
        return self;
    }

    pub fn removeAll(self: *Self, allocator: std.mem.Allocator) bool {
        var i: usize = 0;

        while (self.len > i) {
            var node = self.first;
            self.first = node.?.next;
            allocator.destroy(node.?);

            i += 1;
        }
        return true;
    }

    pub fn remove(self: *Self, allocator: std.mem.Allocator) bool {
        _ = allocator;
        _ = self;
        return true;
    }
};

test "alloc memory to struct" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var list = List.init();
    var idx: i32 = 0;
    while (idx < 5) : (idx += 1) {
        _ = try list.add(allocator, idx);
    }
    _ = list.removeAll(allocator);
}
