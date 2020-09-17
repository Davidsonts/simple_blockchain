require "simple_blockchain/version"
require 'digest'
module SimpleBlockchain
  class Error < StandardError; end
  # Your code goes here...
  class Block
    attr_reader :index, :previousHash, :data, :timestamp, :hash
    def initialize(index = 0, previousHash = nil, data = 'Genesis block', difficulty = 1)
      @index = index
      @previousHash = previousHash
      @data = data
      @timestamp = Time.now
      @difficulty = difficulty
      @nonce = 0
      self.mine
    end

    def generateHash
      return Digest::SHA2.new(256).hexdigest [@index, @previousHash, @data, @timestamp, @nonce].to_s
    end

    def mine
      @hash = self.generateHash
      str_zero = '0' * @difficulty
      until @hash[0..@difficulty - 1].match?str_zero,0 do
        @nonce +=1
        @hash = self.generateHash
      end
    end
  end
  
  class Blockchain
    attr_reader :blocks, :index
    def initialize(difficulty = 1)
      @blocks = [Block.new]
      @index = 1
      @difficulty = difficulty
    end

    def getLastBlock
      return @blocks.last
    end

    def addBlock(data)
      previousHash = self.getLastBlock.hash
      block = Block.new(@index, previousHash, data, @difficulty)
      @index +=1 
      @blocks.push(block)
      return previousHash
    end

    def isValid
      for i in 1..@blocks.length - 1
        currentBlock = @blocks[i]
        previousBlock = @blocks[i - 1]

        if currentBlock.hash != currentBlock.generateHash
          return false
        end

        if currentBlock.index != previousBlock.index.+(1)
          return false
        end
        
        if currentBlock.previousHash != previousBlock.hash
          return false
        end
      end
      return true
    end
  end
end
