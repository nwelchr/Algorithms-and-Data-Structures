class TransactionStack

  attr_accessor :store, :transaction_idx, :transaction_store, :transaction_open 

  def initialize()
    @store = []
    @transaction_idx = -1
    @transaction_store = []
    @transaction_open = Hash.new(false)
  end

  def push(val)
    if self.transaction_idx >= 0 && self.transaction_open[self.transaction_idx]
      self.transaction_store[self.transaction_idx].push(val)
    end
    self.store.push(val)
  end

  def pop()
    if self.transaction_idx >= 0 && self.transaction_open[self.transaction_idx]
      self.transaction_store[self.transaction_idx].pop()
    end
    self.store.pop()
  end

  def top()
    puts self.store[-1]
  end

  def begin()
    self.transaction_idx += 1
    self.transaction_open[self.transaction_idx] = true
    self.transaction_store.push([])
  end

  def rollback
    if transaction_idx >= 0
      self.store.pop(self.transaction_store[self.transaction_idx].length)
      self.transaction_store.pop()
      self.transaction_open[self.transaction_idx] = false
      self.transaction_idx -= 1
    end
  end

  def commit
    if self.transaction_store[self.transaction_idx].length == 0
      self.transaction_store.pop()
    end
    self.transaction_open[self.transaction_idx] = false
  end
end

def init()
  stack = TransactionStack.new
  puts stack.push(5)
  puts stack.push(2)
  puts stack.pop()
  puts stack.begin()
  puts stack.push(5)
  puts stack.push(7)
  puts stack.top()
  puts stack.pop()
  puts stack.commit()
  puts stack.push(5)
  puts stack.pop()
  puts stack.pop()
  puts stack.push(10)
  puts stack.push(5)
  puts stack.commit()
  puts stack.push(5)
  puts stack.rollback()
  puts stack.rollback()
  puts stack.top()
end

init()